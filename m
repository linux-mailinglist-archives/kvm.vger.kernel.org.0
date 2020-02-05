Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AF01533B1
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgBEPUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 10:20:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37308 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEPUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 10:20:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so3267122wmf.2;
        Wed, 05 Feb 2020 07:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Eu/czLrqDMFVqxZHLoEa1l5MyCiw1QB7Y2F2E91wwso=;
        b=b5JgSbc6vwObcogWIFqOdkOezS9kTXNdfyy/tlLf8DObaHOghHX8McPh9K4mcOiOKB
         85UssOj3VIaD1h+nwh5BdeqmGmJDmS5g4U5wkVdxkPjOHz9YJFxJar3htH96Vt7+ayPU
         WM6ka3hNGbsAWbiknIrYLmhLGQ9Tn0EZBb8Pg/xdCbEaSSz+IyRJhSLGcLfEbmkhngY0
         2x6ciCIVfpPBxkOazxKfJoVagfZ7yLz0FGCe/tY3X87XxX/Fx24mHowRqnGy9r3MCW34
         yLlEPw+vip+6ianwxrIrlL06NBD4Ihg27IkXdJwZzMQoadZLUZOhx6w80Vu+44E5L53+
         7+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Eu/czLrqDMFVqxZHLoEa1l5MyCiw1QB7Y2F2E91wwso=;
        b=XyRMYZl/UVvpu1lZmFBEk9bR5OEF+qvKzm7PAcV+XTHLkYKCxV7QGn1Y8LTKYMiWtp
         BJUA3DaOrlVdUiV1399Xo7lh2RXK2/kTNczUM6Nu3FTflisY8AfE1kMgz30zpuTOAtdV
         xTpd3OHi4FMXjhxCgf8zkcLc6TTpfb8p//cRLYl+yKs577DpI0cC90OijE9pt68zclD3
         ib+Esfctre7+sVJedLeQloyJJtkHc4C+7s37XO3CFm6MxysED5vLepZFS3e4dGEtRFGI
         yqH3sFWkx3kR4A6SMkIz6IuSMVFW1rraTSo6kCOoEULD8mRKZnpd8lR49l2LIiC3o+Uz
         zcWQ==
X-Gm-Message-State: APjAAAXTk0LS71sdMpGi3hjsq5Zz7XKme8PegMUqJOA+Dzqxy46w4/oW
        R9HNm33ueXprBumnDcZrPBCE0EY6
X-Google-Smtp-Source: APXvYqwuVi7TatktuYrcptCy2OsCtreFpYhjY4vsG4aVYW8c+xoZYJfb6LlcgJJA4tkEcMtI/fcZ8A==
X-Received: by 2002:a1c:7c08:: with SMTP id x8mr6582758wmc.106.1580915630238;
        Wed, 05 Feb 2020 07:13:50 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c15sm176452wrt.1.2020.02.05.07.13.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Feb 2020 07:13:49 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dgilbert@redhat.com, jmattson@google.com
Subject: [PATCH] KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
Date:   Wed,  5 Feb 2020 16:13:48 +0100
Message-Id: <1580915628-42930-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace that does not know about the AMD_IBRS bit might still
allow the guest to protect itself with MSR_IA32_SPEC_CTRL using
the Intel SPEC_CTRL bit.  However, svm.c disallows this and will
cause a #GP in the guest when writing to the MSR.  Fix this by
loosening the test and allowing the Intel CPUID bit, and in fact
allow the AMD_STIBP bit as well since it allows writing to
MSR_IA32_SPEC_CTRL too.

Reported-by: Zhiyi Guo <zhguo@redhat.com>
Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Analyzed-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bf0556588ad0..a3e32d61d60c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4225,6 +4225,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
@@ -4310,6 +4312,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
-- 
1.8.3.1

