Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A07731A947
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhBMBHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhBMBGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:06:51 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C13FC0617A7
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:40 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 203so1616913ybz.2
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TBi9mzif932CxFGCWRDrn7WGDuvfCWuy0X2/DzVvU4g=;
        b=eAAy3T6Mg9MgvMRoSl1leu1/x7dc/YzSirva7kjTTqYDj3Z/JWsTk3rDtvr8fM0Ynx
         IneM1faKW1NfM4jLdO98lI+F1pZx4N/af028aMALOaJ6bXay+7Ig0rp+cujiJ+YdOvps
         UBKOb/miIzmhvD5if77dpaacD8dZfceUuRTnmYR2mXZGhPFH8VGjJ38idFteAPlX/Jd7
         2+1egmV5AcuhLwwVmRJj1NR8dICdnsfiglCXyVdKUDEgN/dNOIWNnQilRSN/jGZwUkya
         X7oAtOM86mbPt0K8UKmM6FkGzbTKkYDC2QUdkIyaXgmu3d3cthyTMUhjK6Byw9X3cgSW
         eJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TBi9mzif932CxFGCWRDrn7WGDuvfCWuy0X2/DzVvU4g=;
        b=d5Bvn3ENRwVgpzL8Xzct3aGDv7Mv/48y8EkWwyNv+bHmjP9bzHHy21WyUtXd3NN9G0
         D7e+CxZ4GyCvacZmY2bpdNDlNxSozfxwjQ8k31/EWDJsVukajg1T3cB+pOtXFiJbbPO3
         HzXkeJh1PYsbLqsS3jAmmKwOn822tmrnAjdfIlomJAsm2vu0w6jwmNdeyH6AHOhgF6MX
         MlYGMgpE3GTnEE88gPRiCDToqim4LdSkK6I/tRSCOBxX/licqUWcEFhRtUn3KeT073L2
         uV86VauPTTJRayjaQiUhTzXjpj+73CBADzp3AP6Y8PigExgDNBdxTuPPZUNg9R5+ito9
         8bow==
X-Gm-Message-State: AOAM531J8TcJoqczaMR9HzXTMDoUJrfePedMeSp+1mck/2uYG/zga1TS
        pZ2QAw+CiUq1Ebfh0Rs2YGKtUrjShiI=
X-Google-Smtp-Source: ABdhPJwJ397Wb5KM3/64tZ40OxBWn1gDdaF1KvvfyK2w6iee5rf3z8RE1K3mgwbyc0Ifiwv6u/oV9Na9y78=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:c401:: with SMTP id u1mr7304123ybf.340.1613178339470;
 Fri, 12 Feb 2021 17:05:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:14 -0800
In-Reply-To: <20210213010518.1682691-1-seanjc@google.com>
Message-Id: <20210213010518.1682691-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210213010518.1682691-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 5/9] KVM: nVMX: Truncate bits 63:32 of VMCS field on nested
 check in !64-bit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bits 63:32 of the VMCS field encoding when checking for a nested
VM-Exit on VMREAD/VMWRITE in !64-bit mode.  VMREAD and VMWRITE always
use 32-bit operands outside of 64-bit mode.

The actual emulation of VMREAD/VMWRITE does the right thing, this bug is
purely limited to incorrectly causing a nested VM-Exit if a GPR happens
to have bits 63:32 set outside of 64-bit mode.

Fixes: a7cde481b6e8 ("KVM: nVMX: Do not forward VMREAD/VMWRITE VMExits to L1 if required so by vmcs12 vmread/vmwrite bitmaps")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b2f0b5e9cd63..d6c892ea551c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5717,7 +5717,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
-- 
2.30.0.478.g8a0d178c01-goog

