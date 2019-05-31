Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C06314DC
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 20:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfEaSmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 14:42:05 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:56048 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbfEaSmE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 14:42:04 -0400
Received: by mail-pl1-f202.google.com with SMTP id q6so4460739pll.22
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pnWVJgdabt0b2jRo7Shrg0iUuXwm5WbudjwO6+T7ruY=;
        b=naBfcKpJU+8hJedYbnxF6wF0GF5aC6lrpbDwuQhG/8nD9+um9kGqmHpssR98zzkmK/
         0NZ3f13uGIaViZhFNLhHaUaLyeXdMrKuDBtBOENQqnpYvB8BceIZ2QRFUtmKOAjiH+rW
         Ww//QFP9htNIj3/DWqOk14n8CbPhe71fyUWTLhtf2rjlpTzuADNcthFyXZEG6aikFcJx
         go0iXd4C6PEiNiCqD56pQ8006pr/JWZoIy+2/kTOTCd4dyQZFo4uHcVvnK6fWY3S19FY
         RkaVKEkLaAf5OXyGBBm1qPEZb6GTKJcs50tSM6loUYxUnW/6YjGmdOoTC1Bt40q9AF2X
         yPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pnWVJgdabt0b2jRo7Shrg0iUuXwm5WbudjwO6+T7ruY=;
        b=kKEPqJefrz9aSlA+23evpVR+/Ic9QQJPznXTljcsIcjMgzz0Lp1oQbhZU5bRYjJ41N
         9XVbURfM6rE73cG5esKzx8BFaiyiCElgMk4P7mUMw7/LMCHYGiu8Riz8WGFVaq2WVhOV
         SyHMFgBktJVmDLqNem20NIMmcn8blyJqWjLeZy2tbZTThk6MJ7tsQz7JPTrx2WjTyzE7
         lNE1sX8U7meRVFpQEuAWXO+1r0XR4uuJZb9g4RGY5P4u6kU/qptqZUpGe/Dp3uRHbG8d
         6lSwGMbUzFmwOo2WYDF1/p4eb6cdlVyX3vVJdgM8RUrpMN81PQ9ulAFd470Tm5sxSiGH
         ClWw==
X-Gm-Message-State: APjAAAWIvA0JTe52qkXvbLGSW3ueX2B0O9j7WLop4O4oPvs8R/liA1vz
        r0Q3t8pBfnjxliTaxCQGcKfBHSMTsjbc+nPy
X-Google-Smtp-Source: APXvYqxdVw329slwI5k4jMwEMk3SZz71nMe2wdh8FELT1gslh5eRmPf1RXqqfG/4PIIbknE/jM8eA8Cy4eze8i88
X-Received: by 2002:a63:fb02:: with SMTP id o2mr10948413pgh.357.1559328123820;
 Fri, 31 May 2019 11:42:03 -0700 (PDT)
Date:   Fri, 31 May 2019 11:41:59 -0700
Message-Id: <20190531184159.260151-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH 1/2] kvm: nVMX: Enforce must-be-zero bits in the
 IA32_VMX_VMCS_ENUM MSR
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, pshier@google.com, marcorr@google.com,
        kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the SDM, bit 0 and bits 63:10 of the IA32_VMX_VMCS_ENUM
MSR are reserved and are read as 0.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6401eb7ef19c..3438279e76bb 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1219,6 +1219,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_EPT_VPID_CAP:
 		return vmx_restore_vmx_ept_vpid_cap(vmx, data);
 	case MSR_IA32_VMX_VMCS_ENUM:
+		if (data & (GENMASK_ULL(63, 10) | BIT_ULL(0)))
+			return -EINVAL;
 		vmx->nested.msrs.vmcs_enum = data;
 		return 0;
 	default:
-- 
2.22.0.rc1.311.g5d7573a151-goog

