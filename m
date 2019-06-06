Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B859B37AF8
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfFFRYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:24:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33111 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFRYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:24:42 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so3300740wru.0
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 10:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mudUAM5qHHKy0AmfrLylRMnPBxqdWNoyk2npO27tVdw=;
        b=Z3CK64zYUx3OhxHAvyYd129UMC0XTrtoh8MVjdDSAg7RIKGjdM/U8X1W8c99acS0f6
         x8vNHnFh9EkXN+AdbSiH82+/OxVQTRmVC19SsWA2+zoZPhetQNvSihMccymkHBDpAMpb
         QX92ivP9ra8R5Uy8CHFjmmkZCXfWI+v7zobEtT3Uha1OUvhQIYb91C1PK9Kgfk2Lb3dw
         Y3BN/Iy898UZUGok+5FSRgi0AoGiTlciS2SyJgbq2S0Oln3ZxZAlQkyffD3N2/hTfJEX
         ZcXV9QCNmH5K3VITiT3mgfGgQb+g8DI5zos5OkrSVgzntetY9vMm6xAb3y7H4MaAVHWX
         BAqw==
X-Gm-Message-State: APjAAAVwI0HMoKVHTdyY+F7SiBoiBZ5ryc/s4F1xsM2BtRry5tnK9PcB
        SqOYpL1GE6RBhhBrmwpN0teI7WgekIs=
X-Google-Smtp-Source: APXvYqxj6lCQXb4TUjbjo3q4/0DlSR/j1rXOxc/qXqug5L26hsTrsoST/FWB2BzJSYinw+7n/MQYtQ==
X-Received: by 2002:adf:ee0b:: with SMTP id y11mr17664513wrn.241.1559841880245;
        Thu, 06 Jun 2019 10:24:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id z14sm3439267wre.96.2019.06.06.10.24.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:24:39 -0700 (PDT)
Subject: Re: [PATCH 12/13] KVM: nVMX: Don't mark vmcs12 as dirty when L1
 writes pin controls
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-13-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <496e9a1f-620e-d09c-c9d3-c490e289ec2e@redhat.com>
Date:   Thu, 6 Jun 2019 19:24:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-13-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:18, Sean Christopherson wrote:
> Pin controls doesn't affect dirty logic, e.g. the preemption timer value
> is loaded from vmcs12 even if vmcs12 is "clean", i.e. there is no need
> to mark vmcs12 dirty when L1 writes pin controls.
> 
> KVM currently toggles the VMX_PREEMPTION_TIMER control flag when it
> disables or enables the timer.  The VMWRITE to toggle the flag can be
> responsible for a large percentage of vmcs12 dirtying when running KVM
> as L1 (depending on the behavior of L2).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I think either we wait for patch 13 to get in the wild so that
VMX_PREEMPTION_TIMER writes do not become so frequent, or we can do
something like

--------- 8< ------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: nVMX: shadow pin based execution controls

The VMX_PREEMPTION_TIMER flag may be toggled frequently, though not
*very* frequently.  Since it does not affect KVM's dirty logic, e.g.
the preemption timer value is loaded from vmcs12 even if vmcs12 is
"clean", there is no need to mark vmcs12 dirty when L1 writes pin
controls, and shadowing the field achieves that.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 4cea018ba285..eb1ecd16fd22 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -47,6 +47,7 @@
 SHADOW_FIELD_RO(GUEST_CS_AR_BYTES, guest_cs_ar_bytes)
 SHADOW_FIELD_RO(GUEST_SS_AR_BYTES, guest_ss_ar_bytes)
 SHADOW_FIELD_RW(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control)
+SHADOW_FIELD_RW(PIN_BASED_VM_EXEC_CONTROL, pin_based_vm_exec_control)
 SHADOW_FIELD_RW(EXCEPTION_BITMAP, exception_bitmap)
 SHADOW_FIELD_RW(VM_ENTRY_EXCEPTION_ERROR_CODE,
vm_entry_exception_error_code)
 SHADOW_FIELD_RW(VM_ENTRY_INTR_INFO_FIELD, vm_entry_intr_info_field)
