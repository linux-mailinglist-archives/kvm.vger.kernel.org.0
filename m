Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1E9D277C
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 12:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfJJKuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 06:50:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38081 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfJJKuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 06:50:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id w12so7281560wro.5;
        Thu, 10 Oct 2019 03:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=nq8aTTwxoQayVKhvN2A/zAYVKjb3yhvqqfb15ovxI+M=;
        b=Yb24pgwv0com25khkQ7ORavf/pBJRJm3rpESqTdZkOZtcXq+ARHRuW+CRxkr1sJsWR
         KE6YW+UzKirDnW0aIcPiVPt1kM3xQuxe9FLmpwRkOEIbvRIz2WFALGdAK/UIgoIDiu9t
         em7GV6TWc4GphRF9D12b5S/BEhygUD3xcY8qR31ht7A8mAwHAFFLzt9FhCUurF/l8zBG
         okEmUb+TZiaXsP/7OByG0ZtGpNCeCko+fxF9IWuCKAhKnI3+DbNLrpfLW39WFJWuwWYL
         hQRdMB5eKvDS6YzE/fUs/VxQhyHDom4p0tQ3Z1+g36Mds6PGcJjK4tlb1vTjuKPnqUgF
         Hulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=nq8aTTwxoQayVKhvN2A/zAYVKjb3yhvqqfb15ovxI+M=;
        b=RsrfSRZ09sRN74NA9XKO6PsxyYMTv0f+w+G+Xq9e4KorbqXNP21J6EnId2BTaFaUYr
         6HH6w1vGUNz/9MSNA3kVOgWPirlDDlzTcfUUKP5Q9Ojrf7NKrBCFpHhhVxe8c2c09vGj
         kcIm9se0j99/LtG3y4hptFt+NLP7GyNXSeFflZxKSaPgQw/G2BHTwO6tT0Qvi8FPhW3n
         rc3LlFJsXDVK3RE0v/+EdO0VdYssXhG8kRN8B5QYcgHPkVtUx7Ry8WOjuVXR9F7DjOC6
         He8kYGsqiCrWd/h7Kbo+Z+SbELKpRY1tUXqpBSXp1b6qGkptuRHBVKDMTNE0nfYB+kMD
         TxwA==
X-Gm-Message-State: APjAAAXiw38Qy4tL+3PpZaHrI+fppozq3Iwjrzaye+QmU4AdtmBdjh4B
        5y9tgwxukLbCExzuzMrlYuL3cF3F
X-Google-Smtp-Source: APXvYqxNdZDbsK/iylAAYtWtc/CfhmfYlIQCb8cl6+RLKC/VLgmHbsWHZm5/d3QSMOjUDMV90ZJnyw==
X-Received: by 2002:adf:e3cb:: with SMTP id k11mr8573250wrm.80.1570704620325;
        Thu, 10 Oct 2019 03:50:20 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id r13sm8259118wrn.0.2019.10.10.03.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 03:50:18 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, suleiman@google.com
Subject: [PATCH] kvm: clear kvmclock MSR on reset
Date:   Thu, 10 Oct 2019 12:50:17 +0200
Message-Id: <1570704617-32285-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After resetting the vCPU, the kvmclock MSR keeps the previous value but it is
not enabled.  This can be confusing, so fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f26f8be4e621..a55252c69118 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2533,6 +2533,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 static void kvmclock_reset(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pv_time_enabled = false;
+	vcpu->arch.time = 0;
 }
 
 static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
@@ -2698,8 +2699,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_SYSTEM_TIME: {
 		struct kvm_arch *ka = &vcpu->kvm->arch;
 
-		kvmclock_reset(vcpu);
-
 		if (vcpu->vcpu_id == 0 && !msr_info->host_initiated) {
 			bool tmp = (msr == MSR_KVM_SYSTEM_TIME);
 
@@ -2713,14 +2712,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
 
 		/* we verify if the enable bit is set... */
+		vcpu->arch.pv_time_enabled = false;
 		if (!(data & 1))
 			break;
 
 		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
 		     &vcpu->arch.pv_time, data & ~1ULL,
 		     sizeof(struct pvclock_vcpu_time_info)))
-			vcpu->arch.pv_time_enabled = false;
-		else
 			vcpu->arch.pv_time_enabled = true;
 
 		break;
-- 
1.8.3.1

