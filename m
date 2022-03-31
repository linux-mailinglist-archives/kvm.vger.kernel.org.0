Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FF04EE364
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 23:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbiCaVm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 17:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241945AbiCaVmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 17:42:52 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89839BB1
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 14:41:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id v12so1524763ljd.3
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 14:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rw60a4C/1buvlADobHgeyPYE1W+JkvNYCFomhSX9C/o=;
        b=e8LF8Ze6zOwPt6FFnClACWV3Jo+f6do+thni5aGwt3k2enqe+nuyyjgZR38Yppr/YT
         chMY6K4HfZZogZnG0SNby5Xd3KPWJtaiKDME29/XISJdc/xM37L/LXINl0tOn8ftgf0a
         8p/G0yOxS/uqQaue2tGvoYPNzXGg0Xg1vsAiM+Y7V7qZTqVwgwqU8DmaceQfIIKHE6ZK
         XYaw6qF/PswMla7HX7+k6mhIQkzuEyopPjxaCTxrXYbHadlmh4RXPZlq7Wpup4y3IDy+
         CO46Pqn2+l1c379SxtQtpcvUEVWa1Z3A2K7K8dwzPnLwb8ZOCYuN3uQXgEe7k+hvbm0J
         C1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rw60a4C/1buvlADobHgeyPYE1W+JkvNYCFomhSX9C/o=;
        b=TbiFtQQDX7Ho1KwWOLQnGEq+tZrIuMuC8e5Zn+FlzZoLVcXrPcLTwdCE1fPdS9EeCT
         LcKsSrJcEHFCQVejyFd7Yw7k9wD0/QubZRMwbAPk4OLV86rXISkxHkkjVafRCUPK0Bmz
         6LvsZs+bQZ95TA3UTXuJlM78SAMv8UtkBYO6J1uPxWbLSQHVJv6DImirExuaPvbp1VZz
         P+97hQ6wVyOvwEfRfeZgjUYDnuInSaLVO8g/ZmOh/f+rcFPnTWdznUh57CY0ACog4795
         VCA/xIfeW4zGyp/eEVErjVmX+Gig/B2791KrtQPRlL7U+y9NS1URs6lxRkibQbvuskSf
         Nvug==
X-Gm-Message-State: AOAM5304/+lGEOJRaIfFjlGqoPI/JTASdGRe81vFP8Kmrou37JVVYZNl
        OGM24y7qnbbEm9V4+Rao0WUzq72yu3iv2FuTYP8Cyw==
X-Google-Smtp-Source: ABdhPJy1FVLnw5Ep7uY/xe1k2URbIcy58oenF966+ZOMopXj2kVs4i0JqYBjG3cke0TiYjLEYAK4qaG8FpyHQsm1lvQ=
X-Received: by 2002:a2e:8913:0:b0:24a:fe47:36b with SMTP id
 d19-20020a2e8913000000b0024afe47036bmr1531024lji.361.1648762862151; Thu, 31
 Mar 2022 14:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-17-dmatlack@google.com>
 <YjGgjTnP/9sG8L+2@xz-m1.local> <CALzav=fZQYC7YyTbZqbkYTYVUXCq4skc6pkQ2S59BoSxbkKUhw@mail.gmail.com>
 <YkShwFaRqlQpyL87@xz-m1.local>
In-Reply-To: <YkShwFaRqlQpyL87@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 31 Mar 2022 14:40:35 -0700
Message-ID: <CALzav=cxm=A31PJOMes3eWpCV8s0zQGgaGZhYiQFJyxY2dNDXg@mail.gmail.com>
Subject: Re: [PATCH v2 16/26] KVM: x86/mmu: Cache the access bits of shadowed translations
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 11:30 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Mar 22, 2022 at 03:51:54PM -0700, David Matlack wrote:
> > On Wed, Mar 16, 2022 at 1:32 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Fri, Mar 11, 2022 at 12:25:18AM +0000, David Matlack wrote:
> > > > In order to split a huge page we need to know what access bits to assign
> > > > to the role of the new child page table. This can't be easily derived
> > > > from the huge page SPTE itself since KVM applies its own access policies
> > > > on top, such as for HugePage NX.
> > > >
> > > > We could walk the guest page tables to determine the correct access
> > > > bits, but that is difficult to plumb outside of a vCPU fault context.
> > > > Instead, we can store the original access bits for each leaf SPTE
> > > > alongside the GFN in the gfns array. The access bits only take up 3
> > > > bits, which leaves 61 bits left over for gfns, which is more than
> > > > enough. So this change does not require any additional memory.
> > >
> > > I have a pure question on why eager page split needs to worry on hugepage
> > > nx..
> > >
> > > IIUC that was about forbidden huge page being mapped as executable.  So
> > > afaiu the only missing bit that could happen if we copy over the huge page
> > > ptes is the executable bit.
> > >
> > > But then?  I think we could get a page fault on fault->exec==true on the
> > > split small page (because when we copy over it's cleared, even though the
> > > page can actually be executable), but it should be well resolved right
> > > after that small page fault.
> > >
> > > The thing is IIUC this is a very rare case, IOW, it should mostly not
> > > happen in 99% of the use case?  And there's a slight penalty when it
> > > happens, but only perf-wise.
> > >
> > > As I'm not really fluent with the code base, perhaps I missed something?
> >
> > You're right that we could get away with not knowing the shadowed
> > access permissions to assign to the child SPTEs when splitting a huge
> > SPTE. We could just copy the huge SPTE access permissions and then let
> > the execute bit be repaired on fault (although those faults would be a
> > performance cost).
> >
> > But the access permissions are also needed to lookup an existing
> > shadow page (or create a new shadow page) to use to split the huge
> > page. For example, let's say we are going to split a huge page that
> > does not have execute permissions enabled. That could be because NX
> > HugePages are enabled or because we are shadowing a guest translation
> > that does not allow execution (or both). We wouldn't want to propagate
> > the no-execute permission into the child SP role.access if the
> > shadowed translation really does allow execution (and vice versa).
>
> Then the follow up (pure) question is what will happen if we simply
> propagate the no-exec permission into the child SP?
>
> I think that only happens with direct sptes where guest used huge pages
> because that's where the shadow page will be huge, so IIUC that's checked
> here when the small page fault triggers:
>
> static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>                                    unsigned direct_access)
> {
>         if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep)) {
>                 struct kvm_mmu_page *child;
>
>                 /*
>                  * For the direct sp, if the guest pte's dirty bit
>                  * changed form clean to dirty, it will corrupt the
>                  * sp's access: allow writable in the read-only sp,
>                  * so we should update the spte at this point to get
>                  * a new sp with the correct access.
>                  */
>                 child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
>                 if (child->role.access == direct_access)
>                         return;
>
>                 drop_parent_pte(child, sptep);
>                 kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
>         }
> }
>
> Due to missing EXEC the role.access check will not match with direct
> access, which is the guest pgtable value which has EXEC set.  Then IIUC
> we'll simply drop the no-exec SP and replace it with a new one with exec
> perm.  The question is, would that untimately work too?
>
> Even if that works, I agree this sounds tricky because we're potentially
> caching fake sp.role conditionally and it seems we never do that before.
> It's just that the other option that you proposed here seems to add other
> way of complexity on caching spte permission information while kvm doesn't
> do either before.  IMHO we need to see which is the best trade off.

Clever! I think you're right that it would work correctly.

This approach avoids the need for caching access bits, but comes with downsides:
 - Performance impact from the extra faults needed to drop the SP and
repair the execute permission bit.
 - Some amount of memory overhead from KVM allocating new SPs when it
could re-use existing SPs.

Given the relative simplicity of access caching (and the fact that it
requires no additional memory), I'm inclined to stick with it rather
than taking the access permissions from the huge page.

>
> I could have missed something else, though.
>
> Thanks,
>
> --
> Peter Xu
>
