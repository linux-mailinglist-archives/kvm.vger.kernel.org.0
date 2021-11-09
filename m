Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7344B90A
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 23:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243577AbhKIWzS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Nov 2021 17:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344596AbhKIWxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Nov 2021 17:53:35 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08614C110F3D
        for <kvm@vger.kernel.org>; Tue,  9 Nov 2021 14:23:57 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p20-20020a63fe14000000b002cc2a31eaf6so353646pgh.6
        for <kvm@vger.kernel.org>; Tue, 09 Nov 2021 14:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ycLvjef8hLdk7LZI4/gX+inYpxs+E16n7SoVAMQYbFc=;
        b=RH/SD9WH2rxUk9ThoB6cB4kA1NBJsDJiLeOWkZk9g7Bv9p84MfGa3RXXawQbTSAMim
         k26q1x/Hb/h4jpIn4uKzi0235tEai0/9kk54pQCnBsFk/KTH/MS0KZ8T1DgOTO7TMkpn
         s/6zUSt+EmWHfxFtHwYLE5GGRdfMyf91Kfs83Krlg3O/oMeCnwTcv3Fi2dHkcgnQXpu3
         DcC9fDEQTgsnufKukuObbrWdoMJhARapdDojQb34tUuP0ulvmqIMKhu4LYmPRr/Y8+rt
         HzFPi8EdT1bYCPHxvKKQdro8eTBGp47rczee2Ke8vjU3I5ipEopeQMLQC97AfYEth96P
         KHVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ycLvjef8hLdk7LZI4/gX+inYpxs+E16n7SoVAMQYbFc=;
        b=wQvheXus/Y5LdaxCjjuCGxyW7x0Nm5CUhDRuvIWQutyVn51Y34Qw2UEdhHS4uCe663
         HFc0C95i+70snOf4kpf5BCr5g8KvYOCULAZ8Et3O9HXdTWNlvDx/rNhzoSfh3WXgC3+G
         k7aWKtmyHwmhIMyrsGz93/TZumgZAXWdODia3SzeK1Cuz49M1mTGUYTSI7xB0DqYGQuT
         VjWONaRuUgJwmGgAXKg7ABsP4rEYst50ZDfiYnDRpE8zKgFOIiSzAR/QHK5UcMBd5tHU
         MrqnMjzcDbgpnbdLI8pzeQu1CBOHWx8KqFV3WxrVI4MLlGL6oAsEycHRbRn9o9GmHjhz
         ER5A==
X-Gm-Message-State: AOAM532+kMyHvXN98HQIMY0q+60LZ1ATzFDMEHfaziHNhZ2bKnxjFmrv
        NimJ/EUYusEr6oZJH8lLEDZ6gtUFtMs=
X-Google-Smtp-Source: ABdhPJx+mhejWFf7eZ9OTGpZ/iBTqEUfe2OZ3RjoRi5mNmTU3uuvA2OydzfWAllLfWwmUIivwje0m/ZsTb0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c947:b0:141:e7f6:d688 with SMTP id
 i7-20020a170902c94700b00141e7f6d688mr10459270pla.56.1636496636511; Tue, 09
 Nov 2021 14:23:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Nov 2021 22:23:50 +0000
In-Reply-To: <20211109222350.2266045-1-seanjc@google.com>
Message-Id: <20211109222350.2266045-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211109222350.2266045-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 2/2] KVM: SEV: Fall back to __vmalloc() for SEV-ES scratch
 area if necessary
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvzalloc() to allocate KVM's buffer for SEV-ES's GHCB scratch area so
that KVM falls back to __vmalloc() if physically contiguous memory isn't
available.  The buffer is purely a KVM software construct, i.e. there's
no need for it to be physically contiguous, and at a max allowed size of
16kb it's just large enough that kzalloc() could feasibly fail due to
memory fragmentation.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea8069c9b5cb..2d5a0eea27ea 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2030,7 +2030,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->vmsa));
 
 	if (svm->ghcb_sa_free)
-		kfree(svm->ghcb_sa);
+		kvfree(svm->ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -2262,7 +2262,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 			svm->ghcb_sa_sync = false;
 		}
 
-		kfree(svm->ghcb_sa);
+		kvfree(svm->ghcb_sa);
 		svm->ghcb_sa = NULL;
 		svm->ghcb_sa_free = false;
 	}
@@ -2350,7 +2350,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			return -EINVAL;
 		}
-		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
+		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
 			return -ENOMEM;
 
@@ -2358,7 +2358,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
-			kfree(scratch_va);
+			kvfree(scratch_va);
 			return -EFAULT;
 		}
 
-- 
2.34.0.rc0.344.g81b53c2807-goog

