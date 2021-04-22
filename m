Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E38836775B
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhDVCWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbhDVCWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:22:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDF0C06138C
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:42 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so18079482ybi.2
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=S/gdc/KPJQxXmxISBs1in1L8dT4ZjfjiXiG2Z4o7inw=;
        b=edfyNDAfRzkyrqiUAUJ07/phuYREeNXJb43J5+fNz3oqXwMMMrufgK5rmZprOH5Aji
         g9JWJ284jHbbeUlp4j9//gscxXo5H3+kVl/4DHB83adoMshbKlGZIUYJEpMFzfKy/Qqh
         CN9jOX0Aa9nJagqnJBz+i6DNzzSGnZvYUXmkaVPBnVYSzbhITj6YpuL8rowDGBIo8I3l
         EWq9Sb8eNRVJ5S55G605S8cJRQ/+/qONV6jEBozZC/d4OHwr8NWEIX0nG8ficzR6FPcz
         q6o1TDgHGjKOB6vgCYglvEr8ar7BLxGF/d/xnkE7MNLYkJwvC5VhWprH1dgwQr3BDEJT
         0Fzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=S/gdc/KPJQxXmxISBs1in1L8dT4ZjfjiXiG2Z4o7inw=;
        b=n+sAOjW74LSZkJuPA8U7oi8bhqqf/rzDs0sY3B6PUmV52edUCFqyo8XCud5TMmikuE
         jh7KsVwPPoyBMbdGpMUGbXjRCv/gE4gXzO6asGOxGOAlVzOAMoZyVGAKaApB58+VtlDM
         C5Kk53cF3/htgBpwCQWBVUkFvHPtZ7OFzkPgC3ZRLV6IPX1DF9kKcKWaDMaP3BswZkIa
         JA/fFSithF2vY68jXLvJfnS6VFj8VBfSL+uPHusp34r/zVBkqYY6VUwHCUN8D+drvzpd
         kNxlWvb0T3Q1AEMzQUFXTaQYUawD9yIMi+syCs4x2rWCV3IqDLkt7K9269S3ipvf1VID
         +VTg==
X-Gm-Message-State: AOAM531eyl07Nj5gOun1CJiPLcMva7MP+9JvcrAvNe7k1xlZjjiXuRdV
        Kf83vwumD/DJQGZp5R/CTwLaN9qY+iU=
X-Google-Smtp-Source: ABdhPJzhRsVtk2eJrm0tONdcH5S8p/3//CBgI9jMbFawrOKcua/SVngwCpua6QFNe41fYo+ga9uA8WH511Y=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a25:d051:: with SMTP id h78mr1432744ybg.497.1619058102136;
 Wed, 21 Apr 2021 19:21:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:21:24 -0700
In-Reply-To: <20210422022128.3464144-1-seanjc@google.com>
Message-Id: <20210422022128.3464144-6-seanjc@google.com>
Mime-Version: 1.0
References: <20210422022128.3464144-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5/9] KVM: nVMX: Truncate bits 63:32 of VMCS field on nested
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
index 8b111682fe5c..0e580305a1ee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5743,7 +5743,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
-- 
2.31.1.498.g6c1eba8ee3d-goog

