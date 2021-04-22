Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD97367737
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhDVCMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234601AbhDVCM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D6DC061347
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k5-20020a2524050000b02904e716d0d7b1so18057860ybk.0
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=tiCpAoHUchGVexDv1AErC6WxAhJBrTlMt5PAos1eons=;
        b=TZUscWH6qgFuWrce5NvxxM2/M/gfh683fHGcrw318TDNa0LqtObchDLoyiLGySlNxM
         EFyB16hpgmRFRVVEuq5vUmHmpzct0kI6N9iwuxNie5HZn4N4hujrN1Yr6VDQDVXuMgQ0
         w0ILxQH5C/tHYFeulY3yHJZi3GtXlH4UNBHW+krrFZAs9RzYFaxuOQDtg3diDwBac3k1
         a3jOlZuLzbjornmc7F/2DMVfuOltcacZAJgY9Vfr8XdmfVZdYsIPtWRYnrc3cwOycZ/3
         2pEigOmxJKB/PT5Z/kqzFiUzE3Sy7+2lBIBpaEMmMBdR7LPJ1OLniAGjbDAiv8P+o+Eu
         XoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=tiCpAoHUchGVexDv1AErC6WxAhJBrTlMt5PAos1eons=;
        b=SXLxaKk+KMteYSDFYsso7TRbYUOvX9FcC3uqycgbw76cexXTLKrZZSgqgjy5V66h83
         mjwQU84y0sG2awX3z9y45Zk195B4CeNTUc4XDXbuVhgGXWJV7R93OMXpedu2BdnV320M
         JrWSMCt1E1Vecobz1jSKIZt26O8K8CYgG/+vYTOKN82+dgsunkmGaELoe5Ej4NV/wYru
         bvkIfNLFDOMCX8pQMzV9MRMSRU/q3VHOBrTFtnK7que5MOePUaYeuWeaiDA0QDnCIerA
         mERY/IXP+VWWf3fOeXbZ67yOXreGqkAikuZfQizceHQgPDmGboPPFqvcCCLieZ6zEYze
         jR9A==
X-Gm-Message-State: AOAM530K3fHwSpNqLoVECenWlK6jun50Uftm61uLY+72lCRE48QUU4IU
        JJCVTpnIjwphdjYn8U06bjm6PbBJj9g=
X-Google-Smtp-Source: ABdhPJzZbK0EIFWrsKZaJCnSKWcXgVkJ/vB24/h9MCj0LIevMRd70tPAJCdKTOy/gGlLON/eKaioTqi1lJA=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:2702:: with SMTP id n2mr1400961ybn.179.1619057514277;
 Wed, 21 Apr 2021 19:11:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:22 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 12/15] KVM: SVM: Move SEV VMCB tracking allocation to sev.c
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

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c | 16 ++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 8efbd23f771b..68999085db6e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1853,6 +1853,18 @@ void sev_hardware_teardown(void)
 	sev_flush_asids();
 }
 
+int sev_cpu_init(struct svm_cpu_data *sd)
+{
+	if (!svm_sev_enabled())
+		return 0;
+
+	sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *), GFP_KERNEL);
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
index f5684d24e333..a5f994e1ca50 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -544,22 +544,22 @@ static void svm_cpu_uninit(int cpu)
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
-		sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *),
-					GFP_KERNEL);
-		if (!sd->sev_vmcbs)
-			goto free_save_area;
-	}
+	ret = sev_cpu_init(sd);
+	if (ret)
+		goto free_save_area;
 
 	per_cpu(svm_data, cpu) = sd;
 
@@ -569,7 +569,7 @@ static int svm_cpu_init(int cpu)
 	__free_page(sd->save_area);
 free_cpu_data:
 	kfree(sd);
-	return -ENOMEM;
+	return ret;
 
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 39d1412f2c45..0af638f97b5f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -584,6 +584,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.31.1.498.g6c1eba8ee3d-goog

