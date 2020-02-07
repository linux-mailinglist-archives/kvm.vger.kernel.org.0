Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF7C15614E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbgBGWfn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 17:35:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25472 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727516AbgBGWfe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 17:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581114933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nbFuDNqXWxYaO1U3b7e5Dk8u+2RlyLNa/H+l9wnHCjY=;
        b=R/X00UbileoB8GuKo2SREXoKf79DDDeY4R7sZlkdD3MM4Eyil4++omsw1rG5fR/GpR70SF
        1RIwCp5okSpGSMNIHf5/Teu8OwuUR712EWkt5dZckF+iX2T2VxYYKIUC0d16R0npwA+cME
        pIYgAsR4hvmLAvoMUC1af+USxXGEnIU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-0e-SH77sO8mHSYGcg_l6iw-1; Fri, 07 Feb 2020 17:35:31 -0500
X-MC-Unique: 0e-SH77sO8mHSYGcg_l6iw-1
Received: by mail-qk1-f200.google.com with SMTP id r145so485530qke.8
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 14:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nbFuDNqXWxYaO1U3b7e5Dk8u+2RlyLNa/H+l9wnHCjY=;
        b=uFprM3HJABDP51rUhu/TWC+7noer+W+fm6GReeFnsbkQQkKWjAN9bK4DWOOkqGYZmv
         fGooq/asLIpvXy2lRSpv/OV2tOg+JOGVDqWY+6GU8/bFopn3gG8C1Q9l0w9xju5riGH+
         QFFjz6Nkk0WbYul+s3E3eKSLwLssn/wxoPacweix2MeU3zLT8DmyTr8YvoxSouVo8rud
         5EQD0cJLCVe4ps6L3C/MCB/+LIdvdBj238dBzBH3vV0dB70mysnUk2G7ZmT2LkLDl2Tn
         fhi1rGLFzEF75M6Q4irUTFUpWMJ2v+7EwoZltm+l8ATs1PAY04WeOxBBasNQGbIYON8d
         h/Vg==
X-Gm-Message-State: APjAAAXuk943rsFqsBhnGlIpXwXpINeDQIcJ1X+DF1VN6rdROm5YlFwC
        AzEQwkN6DcX1fhmuXJHQdQvgU0jvKC0H6n+oMUTG88FS6kwQPNDM2BkmtI5szOqnCWy9KROJIxf
        qFGuK2kqxso5n
X-Received: by 2002:ac8:70d3:: with SMTP id g19mr564428qtp.209.1581114929009;
        Fri, 07 Feb 2020 14:35:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOrsIOK2qFxwanpIc4DdFHwxuCz+v4A8f7plovFbmLVtbkNX/2LPWpBFah+G+L0x+fURCmIg==
X-Received: by 2002:ac8:70d3:: with SMTP id g19mr564402qtp.209.1581114928759;
        Fri, 07 Feb 2020 14:35:28 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id u12sm2178736qtj.84.2020.02.07.14.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 14:35:28 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-mips@vger.kernel.org, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 3/4] KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
Date:   Fri,  7 Feb 2020 17:35:19 -0500
Message-Id: <20200207223520.735523-4-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207223520.735523-1-peterx@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace kvm_flush_remote_tlbs() calls in MIPS code into
kvm_flush_remote_tlbs_common().  This is to prepare that MIPS will
define its own kvm_flush_remote_tlbs() soon.

The only three references are all in the flush_shadow_all() hooks.
One of them can be directly dropped because it's exactly the
kvm_flush_remote_tlbs_common().  Since at it, refactors the other one
a bit.

No functional change expected.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/mips/kvm/trap_emul.c | 8 +-------
 arch/mips/kvm/vz.c        | 7 ++-----
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/mips/kvm/trap_emul.c b/arch/mips/kvm/trap_emul.c
index 2ecb430ea0f1..ced481c963be 100644
--- a/arch/mips/kvm/trap_emul.c
+++ b/arch/mips/kvm/trap_emul.c
@@ -697,12 +697,6 @@ static int kvm_trap_emul_vcpu_setup(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static void kvm_trap_emul_flush_shadow_all(struct kvm *kvm)
-{
-	/* Flush GVA page tables and invalidate GVA ASIDs on all VCPUs */
-	kvm_flush_remote_tlbs(kvm);
-}
-
 static u64 kvm_trap_emul_get_one_regs[] = {
 	KVM_REG_MIPS_CP0_INDEX,
 	KVM_REG_MIPS_CP0_ENTRYLO0,
@@ -1285,7 +1279,7 @@ static struct kvm_mips_callbacks kvm_trap_emul_callbacks = {
 	.vcpu_init = kvm_trap_emul_vcpu_init,
 	.vcpu_uninit = kvm_trap_emul_vcpu_uninit,
 	.vcpu_setup = kvm_trap_emul_vcpu_setup,
-	.flush_shadow_all = kvm_trap_emul_flush_shadow_all,
+	.flush_shadow_all = kvm_flush_remote_tlbs_common,
 	.gva_to_gpa = kvm_trap_emul_gva_to_gpa_cb,
 	.queue_timer_int = kvm_mips_queue_timer_int_cb,
 	.dequeue_timer_int = kvm_mips_dequeue_timer_int_cb,
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 814bd1564a79..91fbf6710da4 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -3105,10 +3105,7 @@ static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
 
 static void kvm_vz_flush_shadow_all(struct kvm *kvm)
 {
-	if (cpu_has_guestid) {
-		/* Flush GuestID for each VCPU individually */
-		kvm_flush_remote_tlbs(kvm);
-	} else {
+	if (!cpu_has_guestid) {
 		/*
 		 * For each CPU there is a single GPA ASID used by all VCPUs in
 		 * the VM, so it doesn't make sense for the VCPUs to handle
@@ -3119,8 +3116,8 @@ static void kvm_vz_flush_shadow_all(struct kvm *kvm)
 		 * kick any running VCPUs so they check asid_flush_mask.
 		 */
 		cpumask_setall(&kvm->arch.asid_flush_mask);
-		kvm_flush_remote_tlbs(kvm);
 	}
+	kvm_flush_remote_tlbs_common(kvm);
 }
 
 static void kvm_vz_vcpu_reenter(struct kvm_run *run, struct kvm_vcpu *vcpu)
-- 
2.24.1

