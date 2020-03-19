Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C326D18BE89
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgCSRnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:43:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:26000 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727561AbgCSRnX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:43:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584639802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=arXREge8xmNm33ojJlI2/DsuKy1gZAPWYFzbLrZKzuE=;
        b=bENnoaQTkZoyMJKtHZVTdrbLhmxIiQVbEqjn7oOU1ld//j7z7+jtfZfftxIQgsVayqGS9t
        25LaGLT87SRTCqB+C0VToT7jziDQoIzU9HiKIltPwKpQJvYsl3LVE90wiXDwVSWGN3P+YF
        NsFjscnha8mUKK9LMEvtKfDvxCm0b+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-xNA2rQfpPRacroWjr_yhsA-1; Thu, 19 Mar 2020 13:43:20 -0400
X-MC-Unique: xNA2rQfpPRacroWjr_yhsA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7DB18024EA;
        Thu, 19 Mar 2020 17:43:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02C055C545;
        Thu, 19 Mar 2020 17:43:18 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: x86: remove bogus user-triggerable WARN_ON
Date:   Thu, 19 Mar 2020 13:43:18 -0400
Message-Id: <20200319174318.20752-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The WARN_ON is essentially comparing a user-provided value with 0.  It is
trivial to trigger it just by passing garbage to KVM_SET_CLOCK.  Guests
can break if you do so, but if it hurts when you do like this just do not
do it.

Reported-by: syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com
Fixes: 9446e6fce0ab ("KVM: x86: fix WARN_ON check of an unsigned less than zero")
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3156e25b0774..d65ff2008cf1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2444,7 +2444,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
 	vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	vcpu->last_guest_tsc = tsc_timestamp;
-	WARN_ON((s64)vcpu->hv_clock.system_time < 0);
 
 	/* If the host uses TSC clocksource, then it is stable */
 	pvclock_flags = 0;
-- 
2.18.2

