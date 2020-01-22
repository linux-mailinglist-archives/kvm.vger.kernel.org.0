Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34C14510C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2020 10:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732442AbgAVJhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jan 2020 04:37:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58400 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731652AbgAVJhW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jan 2020 04:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579685841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W6yEULGDzE/nInvw9JSJB7gTt3H5wvwQ6ls0gr1oQVY=;
        b=SvmGk5WlMLWfQLkF/+RzIovZcGgR0Qjo9YEdO1llr0BXpjTv49PDHbalxDwJqgnmR1mvcp
        DbkN9zsCPGlwdsd73sKnA+nh5sVb51H4c5cX7HSAtQfqZfFKKdJu1BSmVRQIv5tCxbi8mm
        o9RYM5cO17YWOiu8ZIUM63A58S1Vwv8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-SCmBQj6fPcC2mxAwHVSUCg-1; Wed, 22 Jan 2020 04:37:19 -0500
X-MC-Unique: SCmBQj6fPcC2mxAwHVSUCg-1
Received: by mail-wm1-f71.google.com with SMTP id b133so276446wmb.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2020 01:37:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=W6yEULGDzE/nInvw9JSJB7gTt3H5wvwQ6ls0gr1oQVY=;
        b=SiNI+3K8kDH0vLpdRBK3J5uAwR/qoHoP0k57wwoJAlqA0z4FhLhgUckEUWHLecBHxZ
         fXMYs9F5gxtIY0RAZESPUcjoxj+saLcnKgvNl/m4HOAPd70izH5U85qTUStYJIoM32KB
         Qjoe6w+MZ4BR8pxmlxLJQf6gksU72EE4lfDFEu2D6W6wIJ3ANokUNe20L0nYPsHVvNGR
         1ckdgNdDfbAgpxEhAaLOZUa8GMp45kZaNUbL/5WgHRl+DjMqxU1gjw/L1/zeFrm6ffVq
         l8pSQw6kDJ8OgehGvfAPD1ptHpnUYlzbpDu9hO/eHxw1zYPLAG/3thMlW3pEC1VCMgLu
         +MWQ==
X-Gm-Message-State: APjAAAVbhz/W8/YP/5vEvczeEozL+b2nielxZZTWjuC8ltYI1M2vzwxt
        4u8D21bHKm4ZEq+E6hytT+/j6LqVIEtOY/xWx0+o5FZ4SIqj+KHrExqtODvuktmHMh41ET6/zdy
        ZHwzIrB1+/zyj
X-Received: by 2002:adf:d846:: with SMTP id k6mr9578101wrl.337.1579685838123;
        Wed, 22 Jan 2020 01:37:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqzqWhY53TzrvajxcRumOsfe7V0LUooFHe3j3uQkZe4Gzh7e9aIgcb7kzXkxzrsSylqS9LEr5Q==
X-Received: by 2002:adf:d846:: with SMTP id k6mr9578074wrl.337.1579685837856;
        Wed, 22 Jan 2020 01:37:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b17sm57898390wrx.15.2020.01.22.01.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 01:37:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <20200122054724.GD18513@linux.intel.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com> <20200122054724.GD18513@linux.intel.com>
Date:   Wed, 22 Jan 2020 10:37:16 +0100
Message-ID: <87zhefsugj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Sat, Jan 18, 2020 at 10:42:31PM +0100, Paolo Bonzini wrote:
>> IMHO the features should stay available in case the guest chooses not to
>> use eVMCS.  A guest that uses eVMCS should know which features it cannot
>> use and not enable them.
>
> Makes sense, wasn't thinking about the scenario where the guest doesn't
> support eVMCS or doesn't want to use it for whatever reason.
>
> Rather than update vmx->nested.msrs or filter vmx_get_msr(), what about
> manually adding eVMCS consistency checks on the disallowed bits and handle
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES as a one-off case by simply
> clearing it from the eVMCS?

Unfortunately, this doesn't work because ... Windows. Not only Hyper-V
enables SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES, it actually expects it
to work (somehow) so when I do

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 72359709cdc1..e6c30eec2817 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -361,11 +361,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
        if (evmcs_already_enabled)
                return 0;
 
-       vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
-       vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
-       vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
-       vmx->nested.msrs.secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
-       vmx->nested.msrs.vmfunc_controls &= ~EVMCS1_UNSUPPORTED_VMFUNC;
-
        return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bb8afe0c5e7f..cd1f5a1c884b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1590,7 +1590,7 @@ static int copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
                        evmcs->pin_based_vm_exec_control;
                vmcs12->vm_exit_controls = evmcs->vm_exit_controls;
                vmcs12->secondary_vm_exec_control =
-                       evmcs->secondary_vm_exec_control;
+                       evmcs->secondary_vm_exec_control & ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
        }
 
        if (unlikely(!(evmcs->hv_clean_fields &

Hyper-V 2016 with > 1 vCPU fails to boot :-(

-- 
Vitaly

