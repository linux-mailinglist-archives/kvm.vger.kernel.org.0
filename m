Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539B11B8403
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 09:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgDYHCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 03:02:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726343AbgDYHCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 03:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587798129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=hOqzqNt3g35oGlWmdR+OwR0lzPFCoYe2O5p/oF2M6rc=;
        b=NRVTAHVUtqgv0M8TvUSknRyq0T2yuOLsmygeB5+HskSSW2NIa20PMBBCEKS0F+YWARvRho
        7nUtZxNQbdc3wrOLJDYlYddRnlZ2WYOekMIZaT4rztcH9K0SvMUZ0mf/qLM6siVrs8Pzdh
        XVqGjfDWLh0iBTupxGJAiIPsA9lsxFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-x65JYobjPbyWxNDlk1wnuA-1; Sat, 25 Apr 2020 03:02:04 -0400
X-MC-Unique: x65JYobjPbyWxNDlk1wnuA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9381C800580;
        Sat, 25 Apr 2020 07:02:03 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7F285D9C5;
        Sat, 25 Apr 2020 07:02:02 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wei.huang2@amd.com, cavery@redhat.com, vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 19/22] KVM: x86: WARN on injected+pending exception even in nested case
Date:   Sat, 25 Apr 2020 03:01:51 -0400
Message-Id: <20200425070154.251290-10-pbonzini@redhat.com>
In-Reply-To: <20200424172416.243870-1-pbonzini@redhat.com>
References: <20200424172416.243870-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

WARN if a pending exception is coincident with an injected exception
before calling check_nested_events() so that the WARN will fire even if
inject_pending_event() bails early because check_nested_events() detects
the conflict.  Bailing early isn't problematic (quite the opposite), but
suppressing the WARN is undesirable as it could mask a bug elsewhere in
KVM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200423022550.15113-11-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e8469db6ccae..44b9d834621c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7693,6 +7693,9 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 			kvm_x86_ops.set_irq(vcpu);
 	}
 
+	WARN_ON_ONCE(vcpu->arch.exception.injected &&
+		     vcpu->arch.exception.pending);
+
 	/*
 	 * Call check_nested_events() even if we reinjected a previous event
 	 * in order for caller to determine if it should require immediate-exit
@@ -7711,7 +7714,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 					vcpu->arch.exception.has_error_code,
 					vcpu->arch.exception.error_code);
 
-		WARN_ON_ONCE(vcpu->arch.exception.injected);
 		vcpu->arch.exception.pending = false;
 		vcpu->arch.exception.injected = true;
 
-- 
2.18.2


