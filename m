Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3690258D95
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgIALq3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 07:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIALlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:41:55 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8D7C061245;
        Tue,  1 Sep 2020 04:41:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y6so396465plk.10;
        Tue, 01 Sep 2020 04:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vL68VqqvBOJpmK0bclLXd33KppmDO85K8QP95o8vC+4=;
        b=WTXFwaaOARSwB1lRXSnt3qJua0sM84oKQHSk1MVVav7KFevKHkgOdVWkOgVmbGz2HQ
         rOSCUGNLXUF2a8hQ0U/7QnO8Ut6haIUxfAkW5QbrydpqnMTrL8ChApB111FHedpghk8M
         qL9gl2Ulk1g7MaEOr5xX2SyOZw1fR0QrhePKuJPUmk3yXIlrBwk10NRgah5ptx0EJxo6
         6o/Lre/7Qwt0vZzwavPXFv5c5Cj/9n3WZI4zh9PQWuTw/TX4z4mIt+8u2qonXS8i8BLt
         q5gNIiVOa2LIDasdDEjPtxZloIkYI3TBp/TlgO+Myw8AincTMRjubtIaOiNIW3fiiVE9
         J3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vL68VqqvBOJpmK0bclLXd33KppmDO85K8QP95o8vC+4=;
        b=FBroC7xRngotSnK1Dg5LhfFeH3+sIwPHAk7ag9A7RZsGzazI0AmCNv4VzE4eA62QGn
         LS0q++/BpxXJmAueBLaW5jkP1+GM8ZKrCHGtUl2K2NwX6SiZw7dKEpS26PRvylclTyiD
         L11Xl4qWveGko/vqZGUMuf4smMTTHm1VHU1OnbepJvVjwM7BSM5yyf3GTfrwX+ezuJkw
         WVMPQVSbGpUtl2rxpMo062OJpyhqkw9vVhS0slMXIhpMVzGUz6g3F5kmYitqOfIim57/
         b69HjScrmCRsURgTzB5C5E5WUkNvQQhzJev0PFE4hhdWv+8fW5Kt+VTO2V1oaIFquL3+
         81Mg==
X-Gm-Message-State: AOAM531ytOHDJV7zyxw/ipVL+zjrTqP0MT2tABq3gyER5BYVALd7HB2n
        NB4e/RyhckTv1/xL8LbtLQ==
X-Google-Smtp-Source: ABdhPJw7j2QWldkxD7fX4qizVyKuseP3QD5Bv0/o1MGNiCfFzJZRsol9XRm13ns3zWHLLlrlzysLUw==
X-Received: by 2002:a17:90a:8909:: with SMTP id u9mr1207128pjn.119.1598960507698;
        Tue, 01 Sep 2020 04:41:47 -0700 (PDT)
Received: from [127.0.0.1] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id 142sm1799131pgf.68.2020.09.01.04.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 04:41:46 -0700 (PDT)
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] KVM: Check the allocation of pv cpu mask
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        vkuznets@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Message-ID: <d59f05df-e6d3-3d31-a036-cc25a2b2f33f@gmail.com>
Date:   Tue, 1 Sep 2020 19:41:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
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
  arch/x86/kernel/kvm.c | 23 +++++++++++++++++++----
  1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 08320b0b2b27..a64b894eaac0 100644
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
@@ -785,11 +791,20 @@ static __init int kvm_alloc_cpumask(void)

  	if (alloc)
  		for_each_possible_cpu(cpu) {
-			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
-				GFP_KERNEL, cpu_to_node(cpu));
+			if (!zalloc_cpumask_var_node(
+				per_cpu_ptr(&__pv_cpu_mask, cpu),
+				GFP_KERNEL, cpu_to_node(cpu))) {
+				goto zalloc_cpumask_fail;
+			}
  		}

+	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
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

