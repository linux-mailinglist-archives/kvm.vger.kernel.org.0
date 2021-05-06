Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD52375278
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhEFKhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhEFKhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:37:11 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84B6C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:36:13 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4FbVNr4J7RzQk2W;
        Thu,  6 May 2021 12:36:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297369; bh=RvZXkGsu8cXKRJt
        8ydP7KN+mkXFOvnb7/TswBji0CFg=; b=jDBRrN8W/XOweo2rKhlpopTx2P+tDVv
        7KqzLy3nBR4ql2WTW7HDVcfcMbOXEocCT5ywAYhKs+sFp/8Mhuin6amvxrvS4LDA
        CWC1hwJGRRUcRf5MbcRQqhGriRSyGpiKYAsBzkTd84FKaJxAZihmxB0fYqE2yl3i
        EXWZsyAyUrxgwpqLPGauz7v+DokVZj0FhOQz+vqGRh+7AVic4hjvpkr1vv7JBK8P
        j4kewwaL0rRxRZdiGNSQuM/9LYnsnrfS2alpQkvyIJaxq5qhT2rJ2bbqBPPBfISc
        OizbUPqG98iZ27HikTiDfcs0MQbUUO3Jd64PEyBPQSuRytN2oXO3mJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=KWMygrqM7CgM+ub4JVcR1kl1qNZAp7fYzNhtJ1U3Qf8=;
        b=YVaAP7/rsG/s7w/GYGI6WBA6B1de4lGuAMgMS0B6O0JZ0yXvr5J/AzSOJBLhvksPqD7qfR
        lZt/DkhtYxBrL+/l0k1aAP3IMr0Yj35X6pNs3wncpgocCMt7xiQk68cpKX6l2qR1Y8vpnb
        bMV3gVudkJfhYq6nARIuDz1dsWt80jBHeBvpgDPfpLrPNhKsLfZ/EN87+oDMzW9fifq11g
        HlYgUoNzMs2g2TuKQFhN1sTWtqS8mh54EanBB5OMQiKu/kd/FtvIbwfLYL9XYlk/6dmiLM
        ErZHmPDWd6f4VpuG4p+Q0wsjd8ByeU29VlbsyZkOZnlhHSJXCIz76u0vqoCKqw==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id iCIEuU8BK-AH; Thu,  6 May 2021 12:36:09 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 7/8] KVM: VMX: Expose TSC scaling to L2
Date:   Thu,  6 May 2021 10:32:27 +0000
Message-Id: <20210506103228.67864-8-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.55 / 15.00 / 15.00
X-Rspamd-Queue-Id: A6D2417CF
X-Rspamd-UID: 3cb4ce
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

Expose the TSC scaling feature to nested guests.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a1bf28f33837..639cb9462103 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2277,7 +2277,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				  SECONDARY_EXEC_ENABLE_VMFUNC);
+				  SECONDARY_EXEC_ENABLE_VMFUNC |
+				  SECONDARY_EXEC_TSC_SCALING);
 		if (nested_cpu_has(vmcs12,
 				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;
@@ -6483,7 +6484,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES;
+		SECONDARY_EXEC_XSAVES |
+		SECONDARY_EXEC_TSC_SCALING;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.17.1

