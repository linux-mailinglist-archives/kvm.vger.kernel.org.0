Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349182774A5
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 16:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgIXO7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 10:59:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728184AbgIXO6T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 10:58:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3cKmN/G4JQx8JIZf3k/gZZAWceOigmYqUGv0Iykr/I=;
        b=jE9ean2BLRXjIV01V4QpUOfzm6qlZQ5BsQQchVyQGonqXjqPMlgUJcHStHjjX1XGLNMgYU
        /cqHKX4GHW7IqK5fonyQTpDp1A9CJ2Cpa/rf05osVkiPwpOmXCFStBp4MdM+ZASW80hI80
        dwVI9W8R+TE0MlbqgKutsbS7jcIZViY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-rNoR_jS8NmeKiOhPetHW1g-1; Thu, 24 Sep 2020 10:58:14 -0400
X-MC-Unique: rNoR_jS8NmeKiOhPetHW1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33A7881CBF1;
        Thu, 24 Sep 2020 14:58:12 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.192.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E995B5578D;
        Thu, 24 Sep 2020 14:58:09 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KVM: x86: hyper-v: always advertise HV_STIMER_DIRECT_MODE_AVAILABLE
Date:   Thu, 24 Sep 2020 16:57:54 +0200
Message-Id: <20200924145757.1035782-5-vkuznets@redhat.com>
In-Reply-To: <20200924145757.1035782-1-vkuznets@redhat.com>
References: <20200924145757.1035782-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HV_STIMER_DIRECT_MODE_AVAILABLE is the last conditionally set feature bit
in KVM_GET_SUPPORTED_HV_CPUID but it doesn't have to be conditional: first,
this bit is only an indication to userspace VMM that direct mode stimers
are supported, it still requires manual enablement (enabling SynIC) to
work so no VMM should just blindly copy it to guest CPUIDs. Second,
lapic_in_kernel() is a must for SynIC. Expose the bit unconditionally.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 6da20f91cd59..503829f71270 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2028,13 +2028,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 			ent->ebx |= HV_DEBUGGING;
 			ent->edx |= HV_X64_GUEST_DEBUGGING_AVAILABLE;
 			ent->edx |= HV_FEATURE_DEBUG_MSRS_AVAILABLE;
-
-			/*
-			 * Direct Synthetic timers only make sense with in-kernel
-			 * LAPIC
-			 */
-			if (lapic_in_kernel(vcpu))
-				ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
+			ent->edx |= HV_STIMER_DIRECT_MODE_AVAILABLE;
 
 			break;
 
-- 
2.25.4

