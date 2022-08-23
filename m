Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE5C59EB14
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiHWScx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 14:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiHWSca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 14:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2917310AE14
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661273650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBISzaqA5voDQtlEaBBypMPzwNKF8QJeBCupWxK8JYE=;
        b=LmTlIQxr085CX98GPgDITuPtn9Za2Wz/iluWZg16sX+kPKtMs9goHI6MoOdhHS5ThxXgk0
        c87pDglyU4dQscXvsHXBlWuvTfri+TTLidEd5lFFHnoJi4DNGpObDYWJqfM7VABTOQMZ4s
        KnETmpbmVtHVnId4JxuoEppj/UFNFno=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-26-J3FVvx_TM5CtoqoKfukVCA-1; Tue, 23 Aug 2022 12:54:09 -0400
X-MC-Unique: J3FVvx_TM5CtoqoKfukVCA-1
Received: by mail-wm1-f70.google.com with SMTP id i7-20020a1c3b07000000b003a534ec2570so9020340wma.7
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 09:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=rBISzaqA5voDQtlEaBBypMPzwNKF8QJeBCupWxK8JYE=;
        b=LM6B6MUJUbrLmo9w7UEyR4gtlB2TtqmaYs3sMyjrZe+zRhmBaZHvDuTDMJaY+fv6mr
         3kwgawD+01FHMlhVpmM0mJ9Lx/Fe8h050FHQ/xbyR5gRORPViF7hExtCOkQ5gAckSSdc
         YF5uSuwwWIeKz9XbFxQNO5dhnOOoDJ2D+nfNungp0TnBs2INfDShBsVYVolO8LzLcABQ
         ajQ0udVDbSVTFFGGUxyyhAxOjM0c9Cl+OrW4W9hAsPGRv+Q2CpfT0OK3abSe7FKsBDvu
         D5U9HtMa0L0/FKG9gH8/IMfdm05puPy+DFhiVR+la3Bklxev6CQBdsYeR0lqv9+gXhym
         9RJQ==
X-Gm-Message-State: ACgBeo3KO8DHYkIlnaebd2VhWx4X0kCSImT0rB0tnkqOjFjLSJkBgfOS
        dM/8Ofi/mWVbg1n0xfZ0NPHjS/xGIt9kbrU13IaHGQm5MgWznFKbHlWxAAG60ZgFH0FBbTARQqo
        NbA+H381oQ3B/
X-Received: by 2002:a1c:2705:0:b0:3a6:78b0:9545 with SMTP id n5-20020a1c2705000000b003a678b09545mr2765996wmn.165.1661273647902;
        Tue, 23 Aug 2022 09:54:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5i4rR8VfhxDzm3LXEYycUqzB3MoaNJuulY2oZ5K80WH2C/qzTPBmLtGq/9ChNastgQFt7IfA==
X-Received: by 2002:a1c:2705:0:b0:3a6:78b0:9545 with SMTP id n5-20020a1c2705000000b003a678b09545mr2765979wmn.165.1661273647579;
        Tue, 23 Aug 2022 09:54:07 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id a17-20020adffb91000000b002207a0b93b4sm14648252wrr.49.2022.08.23.09.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 09:54:06 -0700 (PDT)
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
In-Reply-To: <YwTrlgeqoAqyH0KF@google.com>
References: <Yv5ZFgztDHzzIQJ+@google.com> <875yiptvsc.fsf@redhat.com>
 <Yv59dZwP6rNUtsrn@google.com> <87czcsskkj.fsf@redhat.com>
 <YwOm7Ph54vIYAllm@google.com> <87edx8xn8h.fsf@redhat.com>
 <YwO2fSCGXnE/9mc2@google.com> <878rngxjb7.fsf@redhat.com>
 <YwPLt2e7CuqMzjt1@google.com> <87wnazwh1r.fsf@redhat.com>
 <YwTrlgeqoAqyH0KF@google.com>
Date:   Tue, 23 Aug 2022 18:54:05 +0200
Message-ID: <87tu62x5n6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> We're talking about nested VMX, i.e. exposing TSC_SCALING to L1.  QEMU's CLX
> definition doesn't include TSC_SCALING.  In fact, none of QEMU's predefined CPU
> models supports TSC_SCALING, precisely because KVM didn't support exposing the
> feature to L1 until relatively recently.
>
> $ git grep VMX_SECONDARY_EXEC_TSC_SCALING
> target/i386/cpu.h:#define VMX_SECONDARY_EXEC_TSC_SCALING              0x02000000
> target/i386/kvm/kvm.c:    if (f[FEAT_VMX_SECONDARY_CTLS] &  VMX_SECONDARY_EXEC_TSC_SCALING) {

(sorry for my persistence but I still believe there are issues which we
won't be able to solve if we take the suggested approach).

You got me. Indeed, "vmx-tsc-scaling" feature is indeed not set for
named CPU models so my example was flawed. Let's swap it with
VMX_VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL /
VMX_VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL which a bunch of named models
have. So I do the same,

'-cpu CascadeLake-Sever,hv-evmcs'

on both the source host which knows about these eVMCS fields and the
destination host which doesn't.

First problem: CPUID. On the source host, we will have
CPUID.0x4000000A.EBX BIT(0) = 1, and "=0" on the destination. I don't
think we migrate CPUID data (can be wrong, though).

Second, assuming VMX feature MSRs are actually migrated, we must fail on
the destnation because VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL is
trying to get set. We can do this in KVM but note: currently, KVM
filters guest reads but not host's so when you're trying to migrate from
a non-fixed KVM, VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL are
actually present! So how do we distinguinsh in KVM between these two
cases, i.e. how do we know if
VMX_VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL were filtered out on the
source (old kvm) or not (new KVM)?

...
>
> Because it's completely unnecessary, adds non-trivial maintenance burden to KVM,
> and requires explicit documentation to explain to userspace what "hv-evmcs-2022"
> means.
>
> It's unnecessary because if the user is concerned about eVMCS features showing up
> in the future, then they should do:
>
>   -cpu CascadeLake-Server,hv-evmcs,-vmx-tsc-scaling,-<any other VMX features not eVMCS-friendly>
>
> If QEMU wants to make that more user friendly, then define CascadeLake-Server-eVMCS
> or whatever so that the features that are unlikely be supported for eVMCS are off by
> default.

I completely agree that what I'm trying to achieve here could've been
done in QEMU from day 1 but we now have what we have: KVM silently
filtering out certain VMX features and zero indication to userspace
VMM whether filtering is being done or not (besides this
CPUID.0x4000000A.EBX BIT(0) bit but I'm not even sure we analyze
source's CPUID data upon migration).

>  This is no different than QEMU not including nested TSC_SCALING in any of
> the predefined models; the developers _know_ KVM doesn't widely support TSC_SCALING,
> so it was omitted, even though a real CLX CPU is guaranteed to support TSC_SCALING.
>

Out of curiosity, what happens if someone sends the following patch to
QEMU:

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a599b..2278f4522b44 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -3191,6 +3191,12 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                   { "vmx-xsaves", "on" },
                   { /* end of list */ }
               },
+            { .version = 6,
+              .note = "ARCH_CAPABILITIES, EPT switching, XSAVES, no TSX, TSC_SCALING",
+              .props = (PropValue[]) {
+                  { "vmx-tsc-scaling", "on" },
+                  { /* end of list */ }
+              },
             },
             { /* end of list */ }
         }

Will Paolo remember about eVMCS and reject it?

> It's non-trivial maintenance for KVM because it would require defining new versions
> every time an eVMCS field is added, allowing userspace to specify and restrict
> features based on arbitrary versions, and do all of that without conflicting with
> whatever PV enumeration Microsoft adds.

The update at hand comes with a feature bit so no mater what we do, we
will need a new QEMU flag to support this feature bit. My suggestion was
just that we stretch its definition a bit and encode not only
PERF_GLOBAL_CTRL but all fields which were added. At the same time we
can switch to filtering host reads and failing host writes for what's
missing (and to do so we'll likely need to invert the logic and
explicitly list what eVMCS supports) so we're better prepared to the
next update.

-- 
Vitaly

