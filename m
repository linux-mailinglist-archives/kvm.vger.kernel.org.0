Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6513D640
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgAPI4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:56:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726370AbgAPI4D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 03:56:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579164961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afuWeP9r07izvBy00eHnBoGUT4XeV+C8WTzPNKhb2Kk=;
        b=aWpk/Qnm4V3Lm817/h89fANgV+R2IE4oOxmQ7BupWBy/MnLd/YVcY9GTTZ+u7FBrAComsW
        R03NuENPPirO1sImwfPsiA9xOWJbm/Qzd6nSuklvIbil9R+whwbZzXKTRaNdpPJsyEnhGG
        SD7Oxduy04MzIq4DepevfbLF+oxLBNA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-c9mnLw6dP8KctFxdrjWjbQ-1; Thu, 16 Jan 2020 03:56:00 -0500
X-MC-Unique: c9mnLw6dP8KctFxdrjWjbQ-1
Received: by mail-wm1-f72.google.com with SMTP id q26so402946wmq.8
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 00:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=afuWeP9r07izvBy00eHnBoGUT4XeV+C8WTzPNKhb2Kk=;
        b=oZKa8zgfIkZFurqoXnYTy4ACtvHFy7UdZzdR/hPKwMPegTos00wKZNPkch8BIsFs7h
         1bvcOVyHlvzw7+EFGem1uJaX5uYl4ow/qcwcrUB+lRnPduhvpkzvs+R2jXQkizExzc4J
         D4+Mev7pEM+qKphi3akyy7fX6I5DUL/lE6HIX2AJHvCLfzabOKQYvARHJEodPtETzJrn
         1lbTMbR1k2u3ZSxS8BFjPKtqLFLqdezdnqHZsirT7BfmtgJ/FdQmepIn6S33aZKVENqc
         C0v5AvqGyZnBAD5eoaBXH3bN4M86R/N6R/ThVRah0Y/oArncxFdzdt8ausyX/PhbOsA8
         VHlA==
X-Gm-Message-State: APjAAAWfrrfXSbWYfnnZjD1tgNGioEZWBLtWZJJwcyIDH45kx8OBliEK
        GS2XCqVtKD4KQN9xYII5xF7EjQOUsC2ONxgkWb2pWQfJNkI24zwPIz+srpVcJKKkDCSj3gstR+4
        cBXtOGKzKFMqN
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr4955234wml.114.1579164959365;
        Thu, 16 Jan 2020 00:55:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqwRaWqnsW99WiiG+BDNvBNCn+Q0DEidIbuHNwvDxAG1uCDbQ3SHAGRWFyXtx+LQ5jeXz51LhA==
X-Received: by 2002:a05:600c:220e:: with SMTP id z14mr4955216wml.114.1579164959178;
        Thu, 16 Jan 2020 00:55:59 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 5sm28507830wrh.5.2020.01.16.00.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:55:58 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 3/3] x86/kvm/hyper-v: don't allow to turn on unsupported VMX controls for nested guests
In-Reply-To: <CF37ED31-4ED0-45C2-A309-3E1E2C2E54F8@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-4-vkuznets@redhat.com> <CF37ED31-4ED0-45C2-A309-3E1E2C2E54F8@oracle.com>
Date:   Thu, 16 Jan 2020 09:55:57 +0100
Message-ID: <874kwvixuq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> Sane L1 hypervisors are not supposed to turn any of the unsupported VMX
>> controls on for its guests and nested_vmx_check_controls() checks for
>> that. This is, however, not the case for the controls which are supported
>> on the host but are missing in enlightened VMCS and when eVMCS is in use.
>> 
>> It would certainly be possible to add these missing checks to
>> nested_check_vm_execution_controls()/_vm_exit_controls()/.. but it seems
>> preferable to keep eVMCS-specific stuff in eVMCS and reduce the impact on
>> non-eVMCS guests by doing less unrelated checks. Create a separate
>> nested_evmcs_check_controls() for this purpose.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> arch/x86/kvm/vmx/evmcs.c  | 56 ++++++++++++++++++++++++++++++++++++++-
>> arch/x86/kvm/vmx/evmcs.h  |  1 +
>> arch/x86/kvm/vmx/nested.c |  3 +++
>> 3 files changed, 59 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index b5d6582ba589..88f462866396 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -4,9 +4,11 @@
>> #include <linux/smp.h>
>> 
>> #include "../hyperv.h"
>> -#include "evmcs.h"
>> #include "vmcs.h"
>> +#include "vmcs12.h"
>> +#include "evmcs.h"
>> #include "vmx.h"
>> +#include "trace.h"
>> 
>> DEFINE_STATIC_KEY_FALSE(enable_evmcs);
>> 
>> @@ -378,6 +380,58 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>> 	*pdata = ctl_low | ((u64)ctl_high << 32);
>> }
>> 
>> +int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
>> +{
>> +	int ret = 0;
>> +	u32 unsupp_ctl;
>> +
>> +	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
>> +		EVMCS1_UNSUPPORTED_PINCTRL;
>> +	if (unsupp_ctl) {
>> +		trace_kvm_nested_vmenter_failed(
>> +			"eVMCS: unsupported pin-based VM-execution controls",
>> +			unsupp_ctl);
>
> Why not move "CC” macro from nested.c to nested.h and use it here as-well instead of replicating it’s logic?
>

Because error messages I add are both human readable and conform to SDM!
:-)

On a more serious not yes, we should probably do that. We may even want
to use it in non-nesting (and non VMX) code in KVM.

Thanks,

-- 
Vitaly

