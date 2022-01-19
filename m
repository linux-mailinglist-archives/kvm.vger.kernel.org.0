Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934004935F3
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345465AbiASH7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:59:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343968AbiASH7h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 02:59:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642579176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBnj8sjrELyhQ8BWKMkWh6tmxpASJAUAlAfS0x8F3uc=;
        b=JGPnqKha6Ykjsz2+rxPaXBf0uoSWsCdVvd8nfQoa/FJgzbr5Bgpc8cw0P6V0OETn0mW1TX
        xASY9SQUDKVvtgXKSL8z3JayZyMSp0u+DxkHC0ML9qHzGuKVtxbFkVEzYQW1EETfiu+tdi
        JK6YvjSQLq4F+1nncpjTVCsLIpF+9YU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-_rxmovhPOH2caHZ9C2O8zw-1; Wed, 19 Jan 2022 02:59:35 -0500
X-MC-Unique: _rxmovhPOH2caHZ9C2O8zw-1
Received: by mail-ed1-f70.google.com with SMTP id t13-20020a05640203cd00b00403cefbefe7so1516947edw.7
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 23:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eBnj8sjrELyhQ8BWKMkWh6tmxpASJAUAlAfS0x8F3uc=;
        b=0fHC8ItZU91u7NC52b6zakrN3uzrXoWj6CkvoB4/Vvu8XbAWml84BiO+ddf2s2GcwG
         sJW+Fv03F3thC6dHQvYEL9U+1aOHOqNsSqRr2p7FkqToomSDhfVI42B0jSnGLsmYvC4H
         3lwr1ypNvXDJeeb4b5yH/07xQdDb7W3l8ixNiFcx9ECzi6q3p/OZXJ3DTwxYCPOiTC07
         3qrFVGXB0OKK8ppCAzNCuTODX4puzMWcLDL8O7njirl+J5afSO4IV/KNUjKeY/cxsupS
         0UDH7yamd8pWnpxuVqrU4l4x+I5t7ktUwGu3YkFXQMwC6QcmUTQPhDHwfyHCh2eTTKyR
         PnjA==
X-Gm-Message-State: AOAM531GqngbMU3znJCZWLfCfHlUhpfKbiQ3iv1vdUYNTS8OCeodrsg5
        nWPDQZCej8VMuIFRxe1FRFPqzNbSFB1qAOxfdWh+1eQAcZkvlpDABv/eEAremAP/veCFRBJ1A5T
        eHNP0tukMY0y5
X-Received: by 2002:a17:906:4e16:: with SMTP id z22mr641264eju.338.1642579174044;
        Tue, 18 Jan 2022 23:59:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzzrHDij5w/93mDQzVdJAoZ94cB4M1vHrjsm1w/E2DboGR2uAOrnAMVGq+s3RbWFk6oCm351Q==
X-Received: by 2002:a17:906:4e16:: with SMTP id z22mr641258eju.338.1642579173775;
        Tue, 18 Jan 2022 23:59:33 -0800 (PST)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 21sm6106220ejx.83.2022.01.18.23.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 23:59:33 -0800 (PST)
Date:   Wed, 19 Jan 2022 08:59:32 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] KVM: x86: Partially allow KVM_SET_CPUID{,2}
 after KVM_RUN for CPU hotplug
Message-ID: <20220119085932.1f67de51@redhat.com>
In-Reply-To: <87ee55knpa.fsf@redhat.com>
References: <20220117150542.2176196-1-vkuznets@redhat.com>
        <20220118153531.11e73048@redhat.com>
        <87ee55knpa.fsf@redhat.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jan 2022 17:34:09 +0100
Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Igor Mammedov <imammedo@redhat.com> writes:
> 
> > On Mon, 17 Jan 2022 16:05:38 +0100
> > Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >  
> >> Changes since v1:
> >> - Drop the allowlist of items which were allowed to change and just allow
> >> the exact same CPUID data [Sean, Paolo]. Adjust selftest accordingly.
> >> - Drop PATCH1 as the exact same change got merged upstream.
> >> 
> >> Recently, KVM made it illegal to change CPUID after KVM_RUN but
> >> unfortunately this change is not fully compatible with existing VMMs.
> >> In particular, QEMU reuses vCPU fds for CPU hotplug after unplug and it
> >> calls KVM_SET_CPUID2. Relax the requirement by implementing an allowing
> >> KVM_SET_CPUID{,2} with the exact same data.  
> >
> >
> > Can you check following scenario:
> >  * on host that has IA32_TSX_CTRL and TSX enabled (RTM/HLE cpuid bits present)
> >  * boot 2 vcpus VM with TSX enabled on VMM side but with tsx=off on kernel CLI
> >
> >      that should cause kernel to set MSR_IA32_TSX_CTRL to 3H from initial 0H
> >      and clear RTM+HLE bits in CPUID, check that RTM/HLE cpuid it
> >      cleared  
> 
> Forgive me my ignorance around (not only) TSX :-) I took a "Intel(R)
> Xeon(R) CPU E3-1270 v5 @ 3.60GHz" host which seems to have rtm/hle and
> booted a guest with 'cpu=host' and with (and without) 'tsx=off' on the
> kernel command line. I decided to check what's is MSR_IA32_TSX_CTRL but
> I see the following:
> 
> # rdmsr 0x122
> rdmsr: CPU 0 cannot read MSR 0x00000122
> 
> I tried adding 'tsx_ctrl' to my QEMU command line but it complains with
> qemu-system-x86_64: warning: host doesn't support requested feature: MSR(10AH).tsx-ctrl [bit 7]
> 
> so I think my host is not good enough :-(

I've seen it being available on "COOPER LAKE" Xeon

> 
> Also, I've looked at tsx_clear_cpuid() but it actually writes to
> MSR_TSX_FORCE_ABORT MSR (0x10F), not MSR_IA32_TSX_CTRL so I'm confused.

look at tsx_disable()

> >  * hotunplug a VCPU and then replug it again
> >     if IA32_TSX_CTRL is reset to initial state, that should re-enable
> >     RTM/HLE cpuid bits and KVM_SET_CPUID2 might fail due to difference  
> 
> Could you please teach me this kung-fu, I mean hot to unplug a
> cold-plugged CPU with QMP? Previoulsy, I only did un-plugging for what
> I've hotplugged, something like:
> 
> (QEMU) device_add driver=host-x86_64-cpu socket-id=0 core-id=2 thread-id=0 id=cpu2
> {"return": {}}
> (QEMU) device_del id=cpu2
> {"return": {}}
> 
> What's the ids of the cold-plugged CPUs?

it doesn't have to be coldplugged, hot(plug/unplug/plug) sequence is fine as well.
fyi you can use qom_path with device _del from 'info hotpluggable-cpus' output


> > and as Sean pointed out there might be other non constant leafs,
> > where exact match check could leave userspace broken.  
> 
> Indeed, while testing your suggestion I've stumbled upon
> CPUID.(EAX=0x12, ECX=1) (SGX) where we mangle ECX from
> kvm_vcpu_after_set_cpuid():
> 
>         best = kvm_find_cpuid_entry(vcpu, 0x12, 0x1);
> 	if (best) {
>                 best->ecx &= vcpu->arch.guest_supported_xcr0 & 0xffffffff;
> 		best->edx &= vcpu->arch.guest_supported_xcr0 >> 32;
>                 best->ecx |= XFEATURE_MASK_FPSSE;
>         }
> 
> In theory, we should just move this to __kvm_update_cpuid_runtime()...
> I'll take a look tomorrow.
> 

