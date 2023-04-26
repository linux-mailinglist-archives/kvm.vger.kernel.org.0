Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71126EEFC2
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 10:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbjDZICz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 04:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239446AbjDZICy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 04:02:54 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6ADDC
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:02:51 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2a8aea2a654so65958131fa.1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 01:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682496170; x=1685088170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c6VqCfb1kZ/+ni6WW1VeBoVtLPJZGHHpNASSaglTaKY=;
        b=Hp3aE02HRO0m3EBKxD02RPwATf5ceTDh/i9USme207oxn1diekd5bTeXtZQSKuJrxc
         lqxuBO0dtGbO01nQ1KD4vl/RkVBN0QnvLtUu7Y6aZDFdB7OiGGLCXEmGM6h6YHIWwtBU
         HxyaJiWfbNR6Zuemq5kBjaycfIlDoYxHVaVH4FxsN9o0Est2c0n5wikAMnmtFiXX9PgM
         X9mbBgGkR1aQGsADNvNuE/7vP4qPCdq71Cq7Eyt/io68aRAjbtbK6b4fMCrAjZwWkK3/
         k44hCbUubgZlGOX/Wn/x/Ris46x7S735iq4yyoAI4E97YMPF+plb+C8uS1LYmylluBR2
         UcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682496170; x=1685088170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c6VqCfb1kZ/+ni6WW1VeBoVtLPJZGHHpNASSaglTaKY=;
        b=DzHit/8X1NPP3pRZTQ/J2ohQNxlmNvn9VJmz+e/V0TcmmcDLWOtO1KKtTbwggPv3Z+
         HQbDBPfnKFAdGyMdlLbv/RAOrnlryMKJnI9v9wGyCllw5goYgNu2rtTJEB+pzOsAPphi
         8qqBDc0S/aFLEESztckiWL0nysG5oR3vaIdTjz8tkNOXU2HE6lAyGQQYfNFkyX5IU/k0
         /Si733RiZHZD9e9oRFW6Zu+iFLKdW3Pbc4r76F6hVngOmP1ldLiVrr6+OeDlQtUMZZH8
         PBucQK8JSBcip2l06D5nBq3pkh3zG1vXdCi4E5slA3IXNVa3l17R3+OGjT2H2vy0VUxr
         GDxA==
X-Gm-Message-State: AAQBX9ep6Z7PKIqqtqPs3ceehQCacpw8Ajw7YOZIZwTgah/2wlJPe3nf
        eiIMHAq3t9Z4ZP2gpVz0aT49CYcTA9wjx8lp7BksPA==
X-Google-Smtp-Source: AKy350bhUHsJEvcsW8iSEylieDylog00SNfNj0iBGM6TzFGJ4p1/0j/5I8WnT45BTziCTTQzCFmf2MYWcO8/ALW7viU=
X-Received: by 2002:a2e:a41a:0:b0:2a1:ab4a:153d with SMTP id
 p26-20020a2ea41a000000b002a1ab4a153dmr4970025ljn.29.1682496169872; Wed, 26
 Apr 2023 01:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-46-atishp@rivosinc.com>
 <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com> <CAHBxVyFhDapAeMQ8quBqWZ10jWSHw1CdE227ciyKQpULHYzffA@mail.gmail.com>
 <81c476f4-ef62-e4a6-0033-8a46a15379fd@intel.com> <CAHBxVyHg7vTaQJWKoVSD8budVZEYSo1eDOyZyZK7gcJApR7SbA@mail.gmail.com>
 <fe1a849a-3276-5fad-869b-bad54bc918f6@intel.com>
In-Reply-To: <fe1a849a-3276-5fad-869b-bad54bc918f6@intel.com>
From:   Atish Kumar Patra <atishp@rivosinc.com>
Date:   Wed, 26 Apr 2023 13:32:38 +0530
Message-ID: <CAHBxVyEkcGwcxB+oDWywJuAwkC-k-_0gMC-mXqSEHy_MyTcN4A@mail.gmail.com>
Subject: Re: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap hooks
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 25, 2023 at 6:40=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 4/25/23 01:00, Atish Kumar Patra wrote:
> > On Mon, Apr 24, 2023 at 7:18=E2=80=AFPM Dave Hansen <dave.hansen@intel.=
com> wrote:
> >> On 4/21/23 12:24, Atish Kumar Patra wrote:
> >> I'm not _quite_ sure what "guest initiated" means.  But SEV and TDX
> >> don't require an ioremap hook like this.  So, even if they *are* "gues=
t
> >> initiated", the question still remains how they work without this patc=
h,
> >> or what they are missing without it.
> >
> > Maybe I misunderstood your question earlier. Are you concerned about gu=
ests
> > invoking any MMIO region specific calls in the ioremap path or passing
> > that information to the host ?
>
> My concern is that I don't know why this patch is here.  There should be
> a very simple answer to the question: Why does RISC-V need this patch
> but x86 does not?
>
> > Earlier, I assumed the former but it seems you are also concerned
> > about the latter as well. Sorry for the confusion in that case.
> > The guest initiation is necessary while the host notification can be
> > made optional.
> > The "guest initiated" means the guest tells the TSM (equivalent of TDX
> > module in RISC-V) the MMIO region details.
> > The TSM keeps a track of this and any page faults that happen in that
> > region are forwarded
> > to the host by the TSM after the instruction decoding. Thus TSM can
> > make sure that only ioremapped regions are
> > considered MMIO regions. Otherwise, all memory outside the guest
> > physical region will be considered as the MMIO region.
>
> Ahh, OK, that's a familiar problem.  I see the connection to device
> filtering now.
>
> Is this functionality in the current set?  I went looking for it and all
> I found was the host notification side.
>

The current series doesn't have the guest filtering feature enabled.
However, we implemented guest filtering and is maintained in a separate tre=
e

https://github.com/rivosinc/linux/tree/cove-integration-device-filtering

We did not include those in this series because the tdx patches are
still undergoing
development. We are planning to rebase our changes once the revised
patches are available.

> Is this the only mechanism by which the guest tells the TSM which parts
> of the guest physical address space can be exposed to the host?
>

This is the current approach defined in CoVE spec. Guest informs about both
shared memory & mmio regions via dedicated SBI calls (
e.g sbi_covg_[add/remove]_mmio_region and
sbi_covg_[share/unshare]_memory_region)

> For TDX and SEV, that information is inferred from a bit in the page
> tables.  Essentially, there are dedicated guest physical addresses that
> tell the hardware how to treat the mappings: should the secure page
> tables or the host's EPT/NPT be consulted?
>

Yes. We don't have such a mechanism defined in CoVE yet.
Having said that, there is nothing in ISA to prevent that and it is doable.
Some specific bits in the PTE entry can also be used to encode for
shared & mmio physical memory addresses.
The TSM implementation will probably need to implement a software page
walker in that case.

Are there any performance advantages between the two approaches ?
As per my understanding, we are saving some boot time privilege
transitions & less ABIs but
adds the cost of software walk at runtime faults.

> If that mechanism is different for RISC-V, it would go a long way to
> explaining why RISC-V needs this patch.
>
> > In the current CoVE implementation, that MMIO region information is als=
o
> > passed to the host to provide additional flexibility. The host may
> > choose to do additional
> > sanity check and bail if the fault address does not belong to
> > requested MMIO regions without
> > going to the userspace. This is purely an optimization and may not be m=
andatory.
>
> Makes sense, thanks for the explanation.
>
> >>> It can be a subset of the region's host provided the layout. The
> >>> guest device filtering solution is based on this idea as well [1].
> >>>
> >>> [1] https://lore.kernel.org/all/20210930010511.3387967-1-sathyanaraya=
nan.kuppuswamy@linux.intel.com/
> >>
> >> I don't really see the connection.  Even if that series was going
> >> forward (I'm not sure it is) there is no ioremap hook there.  There's
> >> also no guest->host communication in that series.  The guest doesn't
> >> _tell_ the host where the MMIO is, it just declines to run code for
> >> devices that it didn't expect to see.
> >
> > This is a recent version of the above series from tdx github. This is
> > a WIP as well and has not been posted to
> > the mailing list. Thus, it may be going under revisions as well.
> > As per my understanding the above ioremap changes for TDX mark the
> > ioremapped pages as shared.
> > The guest->host communication happen in the #VE exception handler
> > where the guest converts this to a hypercall by invoking TDG.VP.VMCALL
> > with an EPT violation set. The host would emulate an MMIO address if
> > it gets an VMCALL with EPT violation.
> > Please correct me if I am wrong.
>
> Yeah, TDX does:
>
> 1. Guest MMIO access
> 2. Guest #VE handler (if the access faults)
> 3. Guest hypercall->host
> 4. Host fixes the fault
> 5. Hypercall returns, guest returns from #VE via IRET
> 6. Guest retries MMIO instruction
>
> From what you said, RISC-V appears to do:
>
> 1. Guest MMIO access
> 2. Host MMIO handler
> 3. Host handles the fault, returns
> 4. Guest retries MMIO instruction
>
> In other words, this mechanism does the same thing but short-circuits
> the trip through #VE and the hypercall.
>

Yes. Thanks for summarizing the tdx approach.

> What happens if this ioremap() hook is not in place?  Does the hardware
> (or TSM) generate an exception like TDX gets?  If so, it's probably
> possible to move this "notify the TSM" code to that exception handler
> instead of needing an ioremap() hook.
>

We don't have a #VE like exception mechanism in RISC-V.

> I'm not saying that it's _better_ to do that, but it would allow you to
> get rid of this patch for now and get me to shut up. :)
>
> > As I said above, the objective here is to notify the TSM where the
> > MMIO is. Notifying the host is just an optimization that we choose to
> > add. In fact, in this series the KVM code doesn't do anything with
> > that information. The commit text probably can be improved to clarify
> > that.
>
> Just to close the loop here, please go take a look at
> pgprot_decrypted().  That's where the x86 guest page table bit gets to
> tell the hardware that the mapping might cause a #VE and is under the
> control of the host.  That's the extent of what x86 does at ioremap() tim=
e.
>
> So, to summarize, we have:
>
> x86:
> 1. Guest page table bit to mark shared (host) vs. private (guest)
>    control
> 2. #VE if there is a fault on a shared mapping to call into the host
>
> RISC-V:
> 1. Guest->TSM call to mark MMIO vs. private
> 2. Faults in the MMIO area are then transparent to the guest
>

Yup. This discussion raised a very valid design aspect of the CoVE spec.
To summarize, we need to investigate whether using PTE bits instead of
additional ABI
for managing shared/confidential/ioremapped pages makes more sense.

Thanks for putting up with my answers and the feedback :).

> That design difference would, indeed, help explain why this patch is
> here.  I'm still not 100% convinced that the patch is *required*, but I
> at least understand how we arrived here.
