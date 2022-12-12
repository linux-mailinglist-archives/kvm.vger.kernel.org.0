Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7BE64A6CD
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbiLLSTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiLLSSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:18:34 -0500
Received: from out-138.mta0.migadu.com (out-138.mta0.migadu.com [IPv6:2001:41d0:1004:224b::8a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D35AE5E
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 10:17:48 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:17:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670869065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a9Id/GViUZAo9zRK46q4+Dpl7Meohnepciy9W7jEdXE=;
        b=fE9WRJWJ8x2O7m5Gd09O9tkOQ7F6YcPGusN7I2RL/OS2Rivtpch9NFEYCzf1v/E4NtmVv2
        FLeZtByUzGij7gtzYD2aTQDXJlv0CdgVRUMS8Aas8M3DkxaG3WKtYQ+564OB8J8mbI1PHJ
        LneF0SsRvU08OUrrniHIKR30jQw8fVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        "Amit, Nadav" <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5dwQEJHNiTPE+jz@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 12, 2022 at 05:39:38PM +0000, Sean Christopherson wrote:
> On Fri, Dec 09, 2022, David Matlack wrote:
> > On Fri, Dec 9, 2022 at 9:25 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > On Fri, Dec 09, 2022 at 10:37:47AM +0800, Yang, Weijiang wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index 4d188f056933..f375b719f565 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> > > > >     union kvm_cpu_role role = {0};
> > > > >     role.base.access = ACC_ALL;
> > > > > -   role.base.smm = is_smm(vcpu);
> > > > > +   role.base.as_id = is_smm(vcpu);
> > > >
> > > > I'm not familiar with other architectures, is there similar conception as
> > > > x86 smm mode?
> > 
> > The notion of address spaces is already existing architecture-neutral
> > concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
> > virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> 
> Yes, SMM is currently the only use-case.
> 
> > Architectures that do not use multiple address spaces will just leave
> > as_id is as always 0.
> 
> My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> address spaces to support SMM emulation was a mistake that should be contained to
> SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> even x86 can opt out.

+1

I don't think something is architecture-neutral by virtue of it existing
in virt/kvm/*.

> Emulating something like TrustZone or EL3 would be quite similar.

/me shudders

I know it is for the sake of discussion, but for posterity: please no!

-- 
Best,
Oliver
