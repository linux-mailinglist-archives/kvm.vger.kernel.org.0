Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5B59ED62
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 22:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiHWUfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 16:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiHWUff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 16:35:35 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E664DFF
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 13:17:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id jm11so13774965plb.13
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 13:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=okZut7hZ16D/Ks8q78i9hNYvLq2MPHNwa7I75lulHEY=;
        b=s+cnpLmB5Uxif/X7C8foADUOjJM/1BVtEgIy835uTmVCd70RFlDhDj5VExg4+UUEyd
         HvLL/gHSMK0sALKbc8Pjh6xabVTiXlphU4OZ7Er7liGfFSKzrGGy8FK6ZZab1NxoAkyH
         wySyLQbYJJV7jZx0UXZ6DtKl/1gpuaznVE+hnsMpnz8gfAPo+55lYVdhlttNziepWyJg
         DqKIk1OtVk6dVYKJgHhbA8U4BaQAy6XC6P2I6bB59mrvYPvF7VXZfXlVBnaSlc90bGSa
         iwq313Whql1f+b+khCt1ziQVhrSO56Es4cs/YgEvgiXGkUWZocCDkj3EgJwUvWvG3JY7
         avtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=okZut7hZ16D/Ks8q78i9hNYvLq2MPHNwa7I75lulHEY=;
        b=7jFFwzAoTx030uvECct4gKAlb1qlhuAvFz/k4NmSB9+7EZP4WQEXBTtcOgwvZXDy+8
         sfKdzTPjcfYmMx94JsjRYMQr11P95zdT3xXtcQYXMlFQUfUk6LeHXUWqlpsoQw/JA/8Q
         I4QDRaMQWtT7GHFHpp0rrMWSwwsOguDVd+Z+Rwg2EmEVWNb20VPW/jZoR12qSucXKfFx
         BF4IecDlQVS1ijMC0m6EXGAy0A1ZhMG3IKJ+TXTjRBTjH0FQz026CKHYPSKI95mAu3rj
         KG8FWxYFFsl+dbXYj/QZs7+JE1cKT9JbjTuO5DAPXyDRvjXnsGnCpgL+2cg+OOQ5xC9c
         umVw==
X-Gm-Message-State: ACgBeo1sus85wrPMmBlEOJFqz7sFzR6ckykSJjmb3E2Uw3aUKFoBGMUU
        KpsG8hQ48ZIzCCPok6kNz/0knQ==
X-Google-Smtp-Source: AA6agR6dkvs5dZ5d60V1skHbZ6R575OYmuskDMBOW9B0+5pss2xt22clxwzP9HGimpQDA2pjZ2ytUg==
X-Received: by 2002:a17:903:41d1:b0:172:ee09:e89e with SMTP id u17-20020a17090341d100b00172ee09e89emr9765778ple.61.1661285819426;
        Tue, 23 Aug 2022 13:16:59 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d11-20020a170903230b00b0016ef87334aesm1829972plh.162.2022.08.23.13.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 13:16:59 -0700 (PDT)
Date:   Tue, 23 Aug 2022 20:16:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <YwU1t7U9BlROOF2/@google.com>
References: <Yv59dZwP6rNUtsrn@google.com>
 <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com>
 <87edx8xn8h.fsf@redhat.com>
 <YwO2fSCGXnE/9mc2@google.com>
 <878rngxjb7.fsf@redhat.com>
 <YwPLt2e7CuqMzjt1@google.com>
 <87wnazwh1r.fsf@redhat.com>
 <YwTrlgeqoAqyH0KF@google.com>
 <87tu62x5n6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu62x5n6.fsf@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > We're talking about nested VMX, i.e. exposing TSC_SCALING to L1.  QEMU's CLX
> > definition doesn't include TSC_SCALING.  In fact, none of QEMU's predefined CPU
> > models supports TSC_SCALING, precisely because KVM didn't support exposing the
> > feature to L1 until relatively recently.
> >
> > $ git grep VMX_SECONDARY_EXEC_TSC_SCALING
> > target/i386/cpu.h:#define VMX_SECONDARY_EXEC_TSC_SCALING              0x02000000
> > target/i386/kvm/kvm.c:    if (f[FEAT_VMX_SECONDARY_CTLS] &  VMX_SECONDARY_EXEC_TSC_SCALING) {
> 
> (sorry for my persistence but I still believe there are issues which we
> won't be able to solve if we take the suggested approach).
> 
> You got me. Indeed, "vmx-tsc-scaling" feature is indeed not set for
> named CPU models so my example was flawed. Let's swap it with
> VMX_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL /
> VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL which a bunch of named models
> have. So I do the same,
> 
> '-cpu CascadeLake-Sever,hv-evmcs'
> 
> on both the source host which knows about these eVMCS fields and the
> destination host which doesn't.
 
> First problem: CPUID. On the source host, we will have
> CPUID.0x4000000A.EBX BIT(0) = 1, and "=0" on the destination. I don't
> think we migrate CPUID data (can be wrong, though).

Huh?  Why would the source have CPUID.0x4000000A.EBX.BIT(0) = 1?  If QEMU is
automatically parroting all KVM-supported Hyper-V features back into KVM via
KVM_SET_CPUID2 _and_ expects the resulting VM to be migratable, then that's a
QEMU bug.

The CPUID bits that matter _have_ to be "migrated", in the sense that the source
and destination absolutely must have compatible CPUID definitions.  The Linux kernel
does not support refreshing CPUID, where as userspace might depending on when the
userspace application starts up[*].  Dropping or adding CPUID bits across migration
is all but guaranteed to cause breakage, e.g. drop the PCID bit and KVM will start
injection #GPs on the destination.

[*] https://lore.kernel.org/lkml/Yvn5BNXfOm3uA7WA@worktop.programming.kicks-ass.net

> Second, assuming VMX feature MSRs are actually migrated, we must fail on

VMX feature MSRs are basically CPL-only CPUID leafs, i.e. they too must be "migrated",
where migrated can be an actual save/restore or QEMU ensuring that the destination
ends up with the same configuration as the source.

> the destnation because VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL is
> trying to get set. We can do this in KVM but note: currently, KVM
> filters guest reads but not host's so when you're trying to migrate from
> a non-fixed KVM, VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL are
> actually present! So how do we distinguinsh in KVM between these two
> cases, i.e. how do we know if
> VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL were filtered out on the
> source (old kvm) or not (new KVM)?

PERF_GLOBAL_CTRL is "solved" because Microsoft provided a CPUID bit.  First, fix
KVM to filter KVM_GET_MSRS when eVMCS is enabled.  Then, expose PERF_GLOBAL_CTRL
to the guest if and only if the new CPUID bit is set.

That guarantees that userspace has to explicitly enable exposure of the fields.
And again, if QEMU is blindly reflecting Hyper-V CPUID leafs, that's a QEMU bug.

But peeking ahead, I think we're in violent agreement on these points.

> > Because it's completely unnecessary, adds non-trivial maintenance burden to KVM,
> > and requires explicit documentation to explain to userspace what "hv-evmcs-2022"
> > means.
> >
> > It's unnecessary because if the user is concerned about eVMCS features showing up
> > in the future, then they should do:
> >
> >   -cpu CascadeLake-Server,hv-evmcs,-vmx-tsc-scaling,-<any other VMX features not eVMCS-friendly>
> >
> > If QEMU wants to make that more user friendly, then define CascadeLake-Server-eVMCS
> > or whatever so that the features that are unlikely be supported for eVMCS are off by
> > default.
> 
> I completely agree that what I'm trying to achieve here could've been
> done in QEMU from day 1 but we now have what we have: KVM silently
> filtering out certain VMX features and zero indication to userspace
> VMM whether filtering is being done or not (besides this
> CPUID.0x4000000A.EBX BIT(0) bit but I'm not even sure we analyze
> source's CPUID data upon migration).
>
> >  This is no different than QEMU not including nested TSC_SCALING in any of
> > the predefined models; the developers _know_ KVM doesn't widely support TSC_SCALING,
> > so it was omitted, even though a real CLX CPU is guaranteed to support TSC_SCALING.
> >
> 
> Out of curiosity, what happens if someone sends the following patch to
> QEMU:
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1db1278a599b..2278f4522b44 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -3191,6 +3191,12 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                    { "vmx-xsaves", "on" },
>                    { /* end of list */ }
>                },
> +            { .version = 6,
> +              .note = "ARCH_CAPABILITIES, EPT switching, XSAVES, no TSX, TSC_SCALING",
> +              .props = (PropValue[]) {
> +                  { "vmx-tsc-scaling", "on" },
> +                  { /* end of list */ }
> +              },
>              },
>              { /* end of list */ }
>          }
> 
> Will Paolo remember about eVMCS and reject it?

Ah, I see.  If QEMU adds vmx-tsc-scaling in the future, then creating a VM will
not fail as it should if QEMU runs with an older KVM that silently hides
TSC_SCALING.

Argh.  There's another problem.  KVM will break userspace if KVM starts enforcing
writes to VMX MSRs.  This isn't solvable without new uAPI.  We can handle
PERF_GLOBAL_CTRL and TSC_SCALING by enabling the enforcement after they're no
longer marked unsupported, but that doesn't address all the other controls that
are unsupported.  E.g. PML is in many of QEMU's named CPU models but is unsupported
when eVMCS is enabled.

This might end up looking at lot like your "versioning" approach, except that there
will be exactly two versions: legacy and enforced (or whatever we want to call 'em).

I suspect this may force QEMU to have eVMCS-specific named CPU models.  I don't see
any way around that, "CascadeLake-Server,hv-evmcs" really ends up being a wildly
different vCPU than vanilla "CascadeLake-Server".

> > It's non-trivial maintenance for KVM because it would require defining new versions
> > every time an eVMCS field is added, allowing userspace to specify and restrict
> > features based on arbitrary versions, and do all of that without conflicting with
> > whatever PV enumeration Microsoft adds.
> 
> The update at hand comes with a feature bit so no mater what we do, we
> will need a new QEMU flag to support this feature bit. My suggestion was
> just that we stretch its definition a bit and encode not only
> PERF_GLOBAL_CTRL but all fields which were added.

I really don't think KVM should take liberties with others' "architectural" CPUID
bits.  IMO, redefining Hyper-V's CPUID bits is no different than redefining Intel
or AMD's CPUID bits.

I'm pretty sure it's a moot point though, because we can't gate userspace behavior
on guest CPUID.

> At the same time we can switch to filtering host reads and failing host
> writes for what's missing (and to do so we'll likely need to invert the logic
> and explicitly list what eVMCS supports) so we're better prepared to the next update.

Yep.  Inverting the logic may not be strictly necessary, i.e. might be able to go
on top, but it definitely should be done sooner than later.

As above, we also have to snapshot the "legacy" controls and restrict the guest to
the legacy controls when KVM is _not_ enforcing userspace accesses.

Let me package up what I have so far, do some (very) light testing, and post it as
RFC so that we can make this less theoretical, and so that I can hand things back
off to you.
