Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58C2B6EF5DF
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbjDZNzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240930AbjDZNzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 09:55:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9992E59FE
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 06:55:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-507bdc5ca2aso12668885a12.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 06:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1682517328; x=1685109328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmeULLSEOV/APvI8lVuTDzek93PU0j/YjPRUGy5JPfg=;
        b=cna46+0jOHZUV/FaGzVH6QylkhG3eumA8/giD5NMvaPzs/Xf7JtEtldDse4/WPqjS8
         7ACHI6qF5I4gWExilfWk4rSVsy6ODf9DN6b9frw57AkxqQccW31SPgWIFtlBbpz4vESi
         0Te2yvdscb4vW9Q6NQ2e8YqiFE0tWUyocJmMQSITlPPqnBn88bCbSc6nPE1dcnn4YGnl
         hZBJQAEZhM4IbYtkBOmBIRkM7iNdl5G5wgfZLggp95iF5aDfMrrM1qV8v/SlUS8TANB5
         e9D+RM7iTK9WpE/hzpszNOsCeE07nQikG2tAn0WqTdFvMHkYet7tV3Yx6Jp7D8kgbjbl
         pKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682517328; x=1685109328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmeULLSEOV/APvI8lVuTDzek93PU0j/YjPRUGy5JPfg=;
        b=LQmkV3iFl6s63XolnXytUQVe5Su4OVmiL8uZmNhNanWMvGauFFatoT588xbEv+nmxl
         U056f4ljNC5dO36PoyrBVvHjR/h8dR56GGoKcj8C+6k4BmX79X5mznVBa8Qw2S4skkHP
         y15Zc4whmd9W0hpg1LVGlzqxkcLmvVx9riKCpZPTmQcz+/Yb+lXsn1GlObttbTJnZR1N
         LRCENanUX1hSNhKSeJQILSNntc/3RVKumEZQZ/wn31rxBj0v10mGU0H51j2/mvBzAZMw
         6hRNOukbaXS5kX/9SrAtrHCPYFZ9Z1hQFrYPbRYObav7r9lv4ayd5T2w5zgx+jNcYrOe
         E+Cg==
X-Gm-Message-State: AAQBX9cg3yMN2q1YqBwjVyndCY7yn4D6RzYuabtcrVQmLVY5/v+4yC40
        bVRBxjB4qT2a/rgk0IcC9L/SCxqpAFYMPtrqZ7dbSg==
X-Google-Smtp-Source: AKy350ZSQ7Elfd9u9HcKo93WjXZLuwnnZAgQYcTWxiTwjcoWUY98kdeYIw7Sinq0BkVh8EDR34FSkQD/ZRAIk447qnk=
X-Received: by 2002:a50:ee83:0:b0:4fe:19cb:4788 with SMTP id
 f3-20020a50ee83000000b004fe19cb4788mr17928498edr.42.1682517327993; Wed, 26
 Apr 2023 06:55:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230419221716.3603068-1-atishp@rivosinc.com> <20230419221716.3603068-46-atishp@rivosinc.com>
 <69ba1760-a079-fd8f-b079-fcb01e3eedec@intel.com> <CAHBxVyFhDapAeMQ8quBqWZ10jWSHw1CdE227ciyKQpULHYzffA@mail.gmail.com>
 <81c476f4-ef62-e4a6-0033-8a46a15379fd@intel.com> <CAHBxVyHg7vTaQJWKoVSD8budVZEYSo1eDOyZyZK7gcJApR7SbA@mail.gmail.com>
 <fe1a849a-3276-5fad-869b-bad54bc918f6@intel.com> <CAHBxVyEkcGwcxB+oDWywJuAwkC-k-_0gMC-mXqSEHy_MyTcN4A@mail.gmail.com>
 <CAK9=C2XwPx-0jqE+Wz+zYja9oPkTF+7CD8baBYYLpOWLeCpeXQ@mail.gmail.com>
In-Reply-To: <CAK9=C2XwPx-0jqE+Wz+zYja9oPkTF+7CD8baBYYLpOWLeCpeXQ@mail.gmail.com>
From:   Andrew Bresticker <abrestic@rivosinc.com>
Date:   Wed, 26 Apr 2023 09:55:17 -0400
Message-ID: <CALE4mHqjvmx-mdHJ8pV5ramCeYz0eOEu75-PHfnh1NWePbthDA@mail.gmail.com>
Subject: Re: [RFC 45/48] RISC-V: ioremap: Implement for arch specific ioremap hooks
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Atish Kumar Patra <atishp@rivosinc.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-kernel@vger.kernel.org,
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
        Samuel Ortiz <sameo@rivosinc.com>,
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

On Wed, Apr 26, 2023 at 6:30=E2=80=AFAM Anup Patel <apatel@ventanamicro.com=
> wrote:
>
> On Wed, Apr 26, 2023 at 1:32=E2=80=AFPM Atish Kumar Patra <atishp@rivosin=
c.com> wrote:
> >
> > On Tue, Apr 25, 2023 at 6:40=E2=80=AFPM Dave Hansen <dave.hansen@intel.=
com> wrote:
> > >
> > > On 4/25/23 01:00, Atish Kumar Patra wrote:
> > > > On Mon, Apr 24, 2023 at 7:18=E2=80=AFPM Dave Hansen <dave.hansen@in=
tel.com> wrote:
> > > >> On 4/21/23 12:24, Atish Kumar Patra wrote:
> > > >> I'm not _quite_ sure what "guest initiated" means.  But SEV and TD=
X
> > > >> don't require an ioremap hook like this.  So, even if they *are* "=
guest
> > > >> initiated", the question still remains how they work without this =
patch,
> > > >> or what they are missing without it.
> > > >
> > > > Maybe I misunderstood your question earlier. Are you concerned abou=
t guests
> > > > invoking any MMIO region specific calls in the ioremap path or pass=
ing
> > > > that information to the host ?
> > >
> > > My concern is that I don't know why this patch is here.  There should=
 be
> > > a very simple answer to the question: Why does RISC-V need this patch
> > > but x86 does not?
> > >
> > > > Earlier, I assumed the former but it seems you are also concerned
> > > > about the latter as well. Sorry for the confusion in that case.
> > > > The guest initiation is necessary while the host notification can b=
e
> > > > made optional.
> > > > The "guest initiated" means the guest tells the TSM (equivalent of =
TDX
> > > > module in RISC-V) the MMIO region details.
> > > > The TSM keeps a track of this and any page faults that happen in th=
at
> > > > region are forwarded
> > > > to the host by the TSM after the instruction decoding. Thus TSM can
> > > > make sure that only ioremapped regions are
> > > > considered MMIO regions. Otherwise, all memory outside the guest
> > > > physical region will be considered as the MMIO region.
> > >
> > > Ahh, OK, that's a familiar problem.  I see the connection to device
> > > filtering now.
> > >
> > > Is this functionality in the current set?  I went looking for it and =
all
> > > I found was the host notification side.
> > >
> >
> > The current series doesn't have the guest filtering feature enabled.
> > However, we implemented guest filtering and is maintained in a separate=
 tree
> >
> > https://github.com/rivosinc/linux/tree/cove-integration-device-filterin=
g
> >
> > We did not include those in this series because the tdx patches are
> > still undergoing
> > development. We are planning to rebase our changes once the revised
> > patches are available.
> >
> > > Is this the only mechanism by which the guest tells the TSM which par=
ts
> > > of the guest physical address space can be exposed to the host?
> > >
> >
> > This is the current approach defined in CoVE spec. Guest informs about =
both
> > shared memory & mmio regions via dedicated SBI calls (
> > e.g sbi_covg_[add/remove]_mmio_region and
> > sbi_covg_[share/unshare]_memory_region)
> >
> > > For TDX and SEV, that information is inferred from a bit in the page
> > > tables.  Essentially, there are dedicated guest physical addresses th=
at
> > > tell the hardware how to treat the mappings: should the secure page
> > > tables or the host's EPT/NPT be consulted?
> > >
> >
> > Yes. We don't have such a mechanism defined in CoVE yet.
> > Having said that, there is nothing in ISA to prevent that and it is doa=
ble.
> > Some specific bits in the PTE entry can also be used to encode for
> > shared & mmio physical memory addresses.
> > The TSM implementation will probably need to implement a software page
> > walker in that case.
>
> We can certainly use PTE bits defined by Svpmbt extension to
> differentiate between IO and memory. Also, we can use the PTE
> SW bits to differentiate between shared and non-shared memory.
>
> >
> > Are there any performance advantages between the two approaches ?
> > As per my understanding, we are saving some boot time privilege
> > transitions & less ABIs but
> > adds the cost of software walk at runtime faults.
>
> Performance wise both approaches will be the same because in
> case of PTE based approach, the TSM can on-demand map the
> shared memory and do software walk upon first access.

For MMIO sure, we can use Svpbmt or an RSW bit in the VS-stage PTE.
Performance-wise the difference is a few fetches from guest memory by
the TSM vs a lookup by the TSM in an internal data-structure.

It's a little more complicated for shared <-> private conversion,
though. If we were to emulate what TDX does with separate Shared vs
Secure EPTs, we could use the MSB of the GPA to divide GPA space in
half between private vs shared. But then we need to enable the host to
reclaim the private pages on a private -> shared conversion: either
the TSM must track which parts of GPA space have been converted (which
gets complicated in the presence of hugepages), or we let the host
remove whatever private pages it wants. For the latter we'd then need
an "accept" flow -- we don't have a #VE equivalent on RISC-V, but I
suppose we could use access fault exceptions for this purpose.

-Andrew
>
> >
> > > If that mechanism is different for RISC-V, it would go a long way to
> > > explaining why RISC-V needs this patch.
> > >
> > > > In the current CoVE implementation, that MMIO region information is=
 also
> > > > passed to the host to provide additional flexibility. The host may
> > > > choose to do additional
> > > > sanity check and bail if the fault address does not belong to
> > > > requested MMIO regions without
> > > > going to the userspace. This is purely an optimization and may not =
be mandatory.
> > >
> > > Makes sense, thanks for the explanation.
> > >
> > > >>> It can be a subset of the region's host provided the layout. The
> > > >>> guest device filtering solution is based on this idea as well [1]=
.
> > > >>>
> > > >>> [1] https://lore.kernel.org/all/20210930010511.3387967-1-sathyana=
rayanan.kuppuswamy@linux.intel.com/
> > > >>
> > > >> I don't really see the connection.  Even if that series was going
> > > >> forward (I'm not sure it is) there is no ioremap hook there.  Ther=
e's
> > > >> also no guest->host communication in that series.  The guest doesn=
't
> > > >> _tell_ the host where the MMIO is, it just declines to run code fo=
r
> > > >> devices that it didn't expect to see.
> > > >
> > > > This is a recent version of the above series from tdx github. This =
is
> > > > a WIP as well and has not been posted to
> > > > the mailing list. Thus, it may be going under revisions as well.
> > > > As per my understanding the above ioremap changes for TDX mark the
> > > > ioremapped pages as shared.
> > > > The guest->host communication happen in the #VE exception handler
> > > > where the guest converts this to a hypercall by invoking TDG.VP.VMC=
ALL
> > > > with an EPT violation set. The host would emulate an MMIO address i=
f
> > > > it gets an VMCALL with EPT violation.
> > > > Please correct me if I am wrong.
> > >
> > > Yeah, TDX does:
> > >
> > > 1. Guest MMIO access
> > > 2. Guest #VE handler (if the access faults)
> > > 3. Guest hypercall->host
> > > 4. Host fixes the fault
> > > 5. Hypercall returns, guest returns from #VE via IRET
> > > 6. Guest retries MMIO instruction
> > >
> > > From what you said, RISC-V appears to do:
> > >
> > > 1. Guest MMIO access
> > > 2. Host MMIO handler
> > > 3. Host handles the fault, returns
> > > 4. Guest retries MMIO instruction
> > >
> > > In other words, this mechanism does the same thing but short-circuits
> > > the trip through #VE and the hypercall.
> > >
> >
> > Yes. Thanks for summarizing the tdx approach.
> >
> > > What happens if this ioremap() hook is not in place?  Does the hardwa=
re
> > > (or TSM) generate an exception like TDX gets?  If so, it's probably
> > > possible to move this "notify the TSM" code to that exception handler
> > > instead of needing an ioremap() hook.
> > >
> >
> > We don't have a #VE like exception mechanism in RISC-V.
> >
> > > I'm not saying that it's _better_ to do that, but it would allow you =
to
> > > get rid of this patch for now and get me to shut up. :)
> > >
> > > > As I said above, the objective here is to notify the TSM where the
> > > > MMIO is. Notifying the host is just an optimization that we choose =
to
> > > > add. In fact, in this series the KVM code doesn't do anything with
> > > > that information. The commit text probably can be improved to clari=
fy
> > > > that.
> > >
> > > Just to close the loop here, please go take a look at
> > > pgprot_decrypted().  That's where the x86 guest page table bit gets t=
o
> > > tell the hardware that the mapping might cause a #VE and is under the
> > > control of the host.  That's the extent of what x86 does at ioremap()=
 time.
> > >
> > > So, to summarize, we have:
> > >
> > > x86:
> > > 1. Guest page table bit to mark shared (host) vs. private (guest)
> > >    control
> > > 2. #VE if there is a fault on a shared mapping to call into the host
> > >
> > > RISC-V:
> > > 1. Guest->TSM call to mark MMIO vs. private
> > > 2. Faults in the MMIO area are then transparent to the guest
> > >
> >
> > Yup. This discussion raised a very valid design aspect of the CoVE spec=
.
> > To summarize, we need to investigate whether using PTE bits instead of
> > additional ABI
> > for managing shared/confidential/ioremapped pages makes more sense.
> >
> > Thanks for putting up with my answers and the feedback :).
>
> I think we should re-evaluate the PTE (or software walk) based approach
> for CoVE spec. It is better to keep the CoVE spec as minimal as possible
> and define SBI calls only if absolutely required.
>
> >
> > > That design difference would, indeed, help explain why this patch is
> > > here.  I'm still not 100% convinced that the patch is *required*, but=
 I
> > > at least understand how we arrived here.
>
> Regards,
> Anup
