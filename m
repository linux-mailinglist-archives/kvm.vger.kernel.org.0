Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28EE25B882
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 03:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgICB7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 21:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICB7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 21:59:20 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF525C061244;
        Wed,  2 Sep 2020 18:59:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id g6so681789pjl.0;
        Wed, 02 Sep 2020 18:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=HvNuZt8AdbQ59bEl2yv+x8KAP+HdurnJ4QylHSI1Jw0=;
        b=iZyTWfoL34ZD3AtkfjK4Vob+sMZOthj0FCXBVjQ69gyIn7b8LhJJhN1cTFdhFxwMmi
         0Fab62bpQrPcLwbiD3fOqok3FDs5gE25ZwJeZ4KEAHEoZAZegu/JfeifjdKe6AsgnH1G
         KLuzIQxuUq683FkB+bSVd422lwYW+3NU26ARFGiS4OuvOPdsk9XDo5PFQBuGd/vhyfzV
         X4FCxLmDvvHO67KjBjXp+unjmn30XiipXoJSqM6NSGd3MuQg3QYBE8TvM9pZFmKKJICD
         RvnH1z39804+mI71J1DFL5iWUv5vzfOwUnMh5yKONIJ3GedpOvzdfTX0Ted8bhzzAn9j
         0IVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=HvNuZt8AdbQ59bEl2yv+x8KAP+HdurnJ4QylHSI1Jw0=;
        b=sJdT0FEHUNsaoxwx2P7ZSfLcRCOdi/n3PMc9Zsg29MB2D5DSrPt1TsB9vwXq/MhTzd
         whyPBt2gqCjebA1Og0me5yew1zO82YGh30RZy0YhZKIu9+BTxuUw/++mWaiZ6vtZ9eBR
         Dq8ZVt9NReZa266Xw26w2DGxvnH2QNXBEmEJDhlgJUBnOfMZLeIajLQXtvYGibyUoxxr
         BbRGfFF8ZJTBYryGNN4NjAbZG+SESVmNvISVapZqKmz1IoH/RJcPHOpkLw4686zW5+z4
         AYzcsiAFfw97wY8ihLANHJ3nt21yEUtBEtwz/8mZQUCw/iAwPYYBBfaNRMJFQfnZOPlN
         JYfw==
X-Gm-Message-State: AOAM531vSLmScCWY5N7XllxdWuWX2qirpLN9F0QN0UigidAT8nAK6fyy
        BTmRnHEBu7/sa0rct8TivQ==
X-Google-Smtp-Source: ABdhPJwU2eKyicXIBEODibPKw990WbBr45xLwxtQkefF2dMzMcVA9hRRWPo2BRtt8ZjEAVe4HPZdsg==
X-Received: by 2002:a17:90a:9307:: with SMTP id p7mr707705pjo.105.1599098359776;
        Wed, 02 Sep 2020 18:59:19 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id n128sm891812pfd.29.2020.09.02.18.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 18:59:19 -0700 (PDT)
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>, tglx@linutronix.de,
        mingo@redhat.com, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH v2] KVM: Check the allocation of pv cpu mask
Message-ID: <654d8c60-49f0-e398-be25-24aed352360d@gmail.com>
Date:   Thu, 3 Sep 2020 09:59:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

check the allocation of per-cpu __pv_cpu_mask. Initialize ops only when
successful.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
  arch/x86/kernel/kvm.c | 24 ++++++++++++++++++++----
  1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 08320b0b2b27..d3c062e551d7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -555,7 +555,6 @@ static void kvm_send_ipi_mask_allbutself(const 
struct cpumask *mask, int vector)
  static void kvm_setup_pv_ipi(void)
  {
  	apic->send_IPI_mask = kvm_send_ipi_mask;
-	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
  	pr_info("setup PV IPIs\n");
  }

@@ -654,7 +653,6 @@ static void __init kvm_guest_init(void)
  	}

  	if (pv_tlb_flush_supported()) {
-		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
  		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
  		pr_info("KVM setup pv remote TLB flush\n");
  	}
@@ -767,6 +765,14 @@ static __init int activate_jump_labels(void)
  }
  arch_initcall(activate_jump_labels);

+static void kvm_free_pv_cpu_mask(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(__pv_cpu_mask, cpu));
+}
+
  static __init int kvm_alloc_cpumask(void)
  {
  	int cpu;
@@ -785,11 +791,21 @@ static __init int kvm_alloc_cpumask(void)

  	if (alloc)
  		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu)))
+				goto zalloc_cpumask_fail;
  		}

+#if defined(CONFIG_SMP)
+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
+#endif
+	pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
  	return 0;
+
+zalloc_cpumask_fail:
+	kvm_free_pv_cpu_mask();
+	return -ENOMEM;
  }
  arch_initcall(kvm_alloc_cpumask);

--
2.18.4
