Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAF52F55FC
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbhANAo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 19:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbhANAlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:41:13 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B5C061383
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:03 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id j5so2920283qvu.22
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 16:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wfHrcWUtyBJw1gyqCm4iA8No6UqJQy8LqS3DFdxjf1o=;
        b=HQcPGOI7Db0VVKoav9UyrxXIH0+RuZkH0BGjFW/CceiS2y3B796raWTZAx8Ck3Cxqi
         PTgjzMpZ/CIKEFGxox36/SlX4hxlX1/rPh4Cs/Rj/8IiJspHi7vqNZfF96Y8ZcG0JbYY
         d3WZIX9+6/Om+jIl0pjKrS0DOPIGC55Ji1DTHBBGg1bycEQbBU5uuyz2W/H9Wx+yRmus
         NjInis52puVHDuR2Aac9iIUKIE2t3tA+HFjyuSSBkgdbMdPBrW7sdxjXXFe0J+d1Vzac
         gxpoR1tralza4fjRGmvarfURSNHSoq6lHpBSUAHAKY2l3J+vJ/pDMMsZusyiBmvMM3t8
         1TIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wfHrcWUtyBJw1gyqCm4iA8No6UqJQy8LqS3DFdxjf1o=;
        b=CjdiL7C9d7eFmo7GSBFmxrI8KubWM2/5C34i0JYPYqX7Skz1K1c0sQZUSRjuNxYQdV
         zuHIhC4OflVf9QB6dGp8UqhMKIfIQIggQUhVGg8gVreghqtGoCNx+pcSzDldDL6eWmsJ
         x1WrfIEQi0Fckp0Wc9EQKx0CdHh7no0HGUOwVd/vqUlEnZX7LwbgX9L24aCqKX3wpoRY
         4x68YRCime2Et6rn6AtAUs8SYPA6+yMbXM64qcq3DAEzOjmBc6WWtipJIjSYbFwIPT9v
         gGL4NGxO9cDayOf5H6yqnshsznJgM3t/hmcO+W4GsVupiyNjLOKZFwQu5HGVi0MdqD3f
         7EuA==
X-Gm-Message-State: AOAM5326umWemZHJRxFfyZKDOyjmm6qXbKiHR38mPt9NISKoB4ZMBZxN
        fz9UYHo7Vi7o4cllVrSv3Y378Il5Q6U=
X-Google-Smtp-Source: ABdhPJyBExKuKdicarMZn03VYv+ivyUWyIEFxxeFnpiLCdo4K9XigddOuHUaf7HqtqJJ3O3LqKiJllMVZpU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:bb8f:: with SMTP id y15mr7044676ybg.139.1610584682516;
 Wed, 13 Jan 2021 16:38:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 13 Jan 2021 16:37:05 -0800
In-Reply-To: <20210114003708.3798992-1-seanjc@google.com>
Message-Id: <20210114003708.3798992-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210114003708.3798992-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH v2 11/14] KVM: SVM: Move SEV VMCB tracking allocation to sev.c
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the allocation of the SEV VMCB array to sev.c to help pave the way
toward encapsulating SEV enabling wholly within sev.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 13 +++++++++++++
 arch/x86/kvm/svm/svm.c | 17 ++++++++---------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1a143340103e..a2c3e2d42a7f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1330,6 +1330,19 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+int sev_cpu_init(struct svm_cpu_data *sd)
+{
+	if (!svm_sev_enabled())
+		return 0;
+
+	sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1, sizeof(void *),
+				      GFP_KERNEL | __GFP_ZERO);
+	if (!sd->sev_vmcbs)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Pages used by hardware to hold guest encrypted state must be flushed before
  * returning them to the system.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bb7b99743bea..89b95fb87a0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -552,23 +552,22 @@ static void svm_cpu_uninit(int cpu)
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *sd;
+	int ret;
 
 	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
 	if (!sd)
 		return -ENOMEM;
 	sd->cpu = cpu;
 	sd->save_area = alloc_page(GFP_KERNEL);
-	if (!sd->save_area)
+	if (!sd->save_area) {
+		ret = -ENOMEM;
 		goto free_cpu_data;
+	}
 	clear_page(page_address(sd->save_area));
 
-	if (svm_sev_enabled()) {
-		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
-					      sizeof(void *),
-					      GFP_KERNEL | __GFP_ZERO);
-		if (!sd->sev_vmcbs)
-			goto free_save_area;
-	}
+	ret = sev_cpu_init(sd);
+	if (ret)
+		goto free_save_area;
 
 	per_cpu(svm_data, cpu) = sd;
 
@@ -578,7 +577,7 @@ static int svm_cpu_init(int cpu)
 	__free_page(sd->save_area);
 free_cpu_data:
 	kfree(sd);
-	return -ENOMEM;
+	return ret;
 
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8e169835f52a..4eb4bab0ca3e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -583,6 +583,7 @@ int svm_unregister_enc_region(struct kvm *kvm,
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct vcpu_svm *svm);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

