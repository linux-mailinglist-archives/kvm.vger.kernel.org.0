Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C37134558C
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 03:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCWChk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 22:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhCWChj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 22:37:39 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02102C061574;
        Mon, 22 Mar 2021 19:37:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id l123so12735132pfl.8;
        Mon, 22 Mar 2021 19:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASe6LP2Gx6mtSgf1m3rb1TTywtdrTYLw0AlmuTfxiqU=;
        b=BxVy0iLYY1/oTq/rhBGHlTDypx3x0DqCOIiv/4JPzMpvLOpTWgzrcrzz1soaOjCoGB
         DDpLLEkNMOJN2WTKu2N7xw+MWIDSlXZO/AZ18vmSIpzp6PbfAepVMIknAQ1Bb4ZE+dUX
         mFPBsOzujrA0AiyUHZpRprJSVi97KNuZHs9m3gOOVSB4qF8ocUwhX9LJ+NajY1p5DYGD
         D/Ny/z/lBw7/7wxxsoOIRvE+83Wj/RnKPPZ1Z4pdGp5JXY73jYJziSKRwaH+/gYpTw6Y
         EEj6dvlPZyb6W/BbV3+lIEXj9L4Buch7AmFr2CGkfsKxMd/VssAvO3E3yLmdj2JvG8hG
         iK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ASe6LP2Gx6mtSgf1m3rb1TTywtdrTYLw0AlmuTfxiqU=;
        b=P1PgRjYkZC23Z6hbWaMXmOea0EDdpcVSkod7gQrM03xZJdIbbvJoiVHZaW3Sm/x2T4
         yBcvLDUdrwBSrdNznvwDGBWNBK9Qu8J80zPOWgRRf1h2IHvZQt5X+JQOdFey/DnFnIng
         dKbInj5tFIkmGUPBD0XAwxtefs48oA/ftD5BXeHc5AsRGhDWAIq2C0XEzq1Zdts+T5KM
         9Z7tTWORonMAT6/xJ6t+S5eq8NCovm6+4my/Cx5DKHNOZMwaboyDoIwjEdGPUcQoSJGL
         jHCjLKuvCV3x8KYdOMB3m767i4aU4m+Nfo73ojkfbel6af24f7GVJ357i/mk7o7RgoiP
         Bzfw==
X-Gm-Message-State: AOAM533TRa9fquv6EB612WGxIHqqSsZFC4ngqhJcMnwLO6STWJn29nbj
        LfFPtswBGYjoaa5uqu9JVDRkgNO8Ow==
X-Google-Smtp-Source: ABdhPJwmTx25ycrbKXHds+YVV/Bl8Smk1rJX/x6XZO20XF1ghvXHrCge5BdA7CoJRFpuv9ptPpzgtg==
X-Received: by 2002:a17:902:d706:b029:e6:90aa:24e0 with SMTP id w6-20020a170902d706b02900e690aa24e0mr2893731ply.42.1616467058203;
        Mon, 22 Mar 2021 19:37:38 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id w188sm4956568pfb.4.2021.03.22.19.37.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Mar 2021 19:37:37 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: VMX: Check the corresponding bits according to the intel sdm
Date:   Tue, 23 Mar 2021 10:37:26 +0800
Message-Id: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
are missing.
* Bit 31 is always 0. Earlier versions of this manual specified that the
VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
all processors produced prior to this change, bit 31 of this MSR was read
as 0.
* The values of bits 47:45 and bits 63:57 are reserved and are read as 0.

Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32cf828..0d6d13c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2577,6 +2577,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
 
+	/*
+	 * IA-32 SDM Vol 3D: Bit 31 is always 0.
+	 * For all earlier processors, bit 31 of this MSR was read as 0.
+	 */
+	if (vmx_msr_low & (1u<<31))
+		return -EIO;
+
+	/*
+	 * IA-32 SDM Vol 3D: bits 47:45 and bits 63:57 are reserved and are read
+	 * as 0.
+	 */
+	if (vmx_msr_high & 0xfe00e000)
+		return -EIO;
+
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
 	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
 		return -EIO;
-- 
1.8.3.1

