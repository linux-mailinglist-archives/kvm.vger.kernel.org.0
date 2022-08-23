Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26AEB59D224
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbiHWHdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 03:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbiHWHdK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 03:33:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D291A63F2C
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661239989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2ONerqKdocOJl27KKdUeRrTYuQ3xXPZVssG9HygGkPU=;
        b=GM/S4tTvhoaYro50MtCG6DTtGTaIBR/5ANWpRaLr4mb8FK5dUfl21T1ZArKsOCkF315S37
        M0OG4yaewpA3FQlHF2c/XFNiFpoxYswmI+CL4qtDM0nu07TFuU2QRRdEoEH+EPzxEMTYDc
        HEvNdL1Ge4K1zzxmeZ//7+XLNI6vtOE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-170-DDPVf_L1OuiWgD_75wyTaQ-1; Tue, 23 Aug 2022 03:33:07 -0400
X-MC-Unique: DDPVf_L1OuiWgD_75wyTaQ-1
Received: by mail-wm1-f69.google.com with SMTP id az42-20020a05600c602a00b003a552086ba9so9853434wmb.6
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=2ONerqKdocOJl27KKdUeRrTYuQ3xXPZVssG9HygGkPU=;
        b=Kt0iGjjT17VCAIAVBmZrByLb8u044aG7K+D42/WCh6wiAbJnWrCz3/XmbxRm1ZRdUe
         1UKvt/qjsffMphBgHL+7T4ru/J4pxvX5sjIr2CG1nAe1LnMKjytYqb9yAofFUF3NgCm2
         T4fzoh6BdVFfVyp+bRu+tZncbowCcyGBnaHgCe9qowIY4ZPTXaYyN7Ve5UK5J8U69gXm
         qdALzWJ/rqHFS/avRJRScQKMKAHE7F7/BZNfNKYoNNJvsRgswqkUEFix4KMp5fuJuCmR
         0hdjdNlkyv3u5ONxRf5dIEYkduBgmpzmEQ+FTFpBLrwYdXcBVzW796dNfsgo4qAVK8O1
         pMEQ==
X-Gm-Message-State: ACgBeo2OW8T11mqq9P5c3uu2D6IOYydGU/be84GMqlIeQUHfvKV7Smya
        uVCwdqnIS6WFj6yjekB6LAAZciFo+lM2cmoTKn2xKNHPcrAzgJJuQEtpYIwC5uH+65wYKu7TD9j
        2wWOHuylmFfPi
X-Received: by 2002:adf:e18b:0:b0:225:644c:59c2 with SMTP id az11-20020adfe18b000000b00225644c59c2mr1763279wrb.673.1661239986471;
        Tue, 23 Aug 2022 00:33:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6hwzHxlbGc8XuBX/h1Dx9/8oX54010sDfiLiygEgsGTbYt//zKkeH4Afdfph4nQolz745tNQ==
X-Received: by 2002:adf:e18b:0:b0:225:644c:59c2 with SMTP id az11-20020adfe18b000000b00225644c59c2mr1763265wrb.673.1661239986213;
        Tue, 23 Aug 2022 00:33:06 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p15-20020adfcc8f000000b002252ec781f7sm13612694wrj.8.2022.08.23.00.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 00:33:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct
 hv_enlightened_vmcs' definition
In-Reply-To: <YwPLt2e7CuqMzjt1@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com> <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com> <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com> <87edx8xn8h.fsf@redhat.com>
 <YwO2fSCGXnE/9mc2@google.com> <878rngxjb7.fsf@redhat.com>
 <YwPLt2e7CuqMzjt1@google.com>
Date:   Tue, 23 Aug 2022 09:33:04 +0200
Message-ID: <87wnazwh1r.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>> > On Mon, Aug 22, 2022, Vitaly Kuznetsov wrote:
>> >> My initial implementation was inventing 'eVMCS revision' concept:
>> >> https://lore.kernel.org/kvm/20220629150625.238286-7-vkuznets@redhat.com/
>> >> 
>> >> which is needed if we don't gate all these new fields on CPUID.0x4000000A.EBX BIT(0).
>> >> 
>> >> Going forward, we will still (likely) need something when new fields show up.
>> >
>> > My comments from that thread still apply.  Adding "revisions" or feature flags
>> > isn't maintanable, e.g. at best KVM will end up with a ridiculous number of flags.
>> >
>> > Looking at QEMU, which I strongly suspect is the only VMM that enables
>> > KVM_CAP_HYPERV_ENLIGHTENED_VMCS, it does the sane thing of enabling the capability
>> > before grabbing the VMX MSRs.
>> >
>> > So, why not simply apply filtering for host accesses as well?
>> 
>> (I understand that using QEMU to justify KVM's behavior is flawed but...)
>> 
>> QEMU's migration depends on the assumption that identical QEMU's command
>> lines create identical (from guest PoV) configurations. Assume we have
>> (simplified)
>> 
>> "-cpu CascadeLake-Sever,hv-evmcs"
>> 
>> on both source and destination but source host is newer, i.e. its KVM
>> knows about TSC Scaling in eVMCS and destination host has no idea about
>> it. If we just apply filtering upon vCPU creation, guest visible MSR
>> values are going to be different, right? Ok, assuming QEMU also migrates
>> VMX feature MSRs (TODO: check if that's true), we will be able to fail
>> mirgration late (which is already much worse than not being able to
>> create the desired configuration on destination, 'fail early') if we use
>> in-KVM filtering to throw an error to userspace. But if we blindly
>> filter control MSRs on the destination, 'TscScaling' will just disapper
>> undreneath the guest. This is unlikely to work.
>
> But all of that holds true irrespetive of eVMCS.  If QEMU attempts to migrate a
> nested guest from a KVM that supports TSC_SCALING to a KVM that doesn't support
> TSC_SCALING, then TSC_SCALING is going to disappear and VM-Entry on the dest will
> fail.  I.e. QEMU _must_ be able to detect the incompatibility and not attempt
> the migration.  And with that code in place, QEMU doesn't need to do anything new
> for eVMCS, it Just Works.

I'm obviously missing something. "-cpu CascadeLake-Sever" presumes
cetain features, including VMX features (e.g. TSC_SCALING), an attempt
to create such vCPU on a CPU which doesn't support it will lead to
immediate failure. So two VMs created on different hosts with

-cpu CascadeLake-Sever

are guaranteed to look exactly the same from guest PoV. This is not true
for '-cpu CascadeLake-Sever,hv-evmcs' (if we do it the way you suggest)
as 'hv-evmcs' will be a *different* filter on each host (which is going
to depend on KVM version, not even on the host's hardware).

>
>> In any case, what we need, is an option for VMM (read: QEMU) to create
>> the configuration with 'TscScaling' filtered out even KVM supports the
>> bit in eVMCS. This way the guest will be able to migrate backwards to an
>> older KVM which doesn't support it, i.e.
>> 
>> '-cpu CascadeLake-Sever,hv-evmcs'
>>  creates the 'origin' eVMCS configuration, no TscScaling
>> 
>> '-cpu CascadeLake-Sever,hv-evmcs,hv-evmcs-2022' creates the updated one.
>
> Again, this conundrum exists irrespective of eVMCS.  Properly solve the problem
> for regular nVMX and eVMCS should naturally work.

I don't think we have this problem for VMX features as named CPU models
in QEMU encode all of them explicitly, they *must* be present whenever
such vCPU is created.

>
>> KVM_CAP_HYPERV_ENLIGHTENED_VMCS is bad as it only takes 'eVMCS' version
>> as a parameter (as we assumed it will always change when new fields are
>> added, but that turned out to be false). That's why I suggested
>> KVM_CAP_HYPERV_ENLIGHTENED_VMCS2.
>
> Enumerating features via versions is such a bad API though, e.g. if there's a
> bug with nested TSC_SCALING, userspace can't disable just nested TSC_SCALING
> without everything else under the inscrutable "hv-evmcs-2022" being collateral
> damage.

Why? Something like 

"-cpu CascadeLake-Sever,hv-evmcs,hv-evmcs-2022,-vmx-tsc-scaling" 

should work well, no? 'hv-evmcs*' are just filters, if the VMX feature
is not there -- it's not there.

We can certainly make this fine-grained and introduce
KVM_CAP_HYPERV_EVMCS_TSC_SCALING instead and make a 'hv-*' flag for it,
however, with Hyper-V and Windows I really don't like 'frankenstein'
Hyper-V configurations which look nothing like genuine Hyper-V as nobody
at Microsoft tests new Windows builds with such configurations. And yes,
bugs were discovered in the past (e.g. PerfGlobalCtrl and Win11).

-- 
Vitaly

