Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF7877C2A0
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjHNVpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 17:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjHNVpQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 17:45:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3568FE7E
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 14:45:14 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686f8614ce5so4522892b3a.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 14:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692049513; x=1692654313;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=05HbnIo80trrCFK3jXhlcJkX75MNBwCQ0epMdFi+1gQ=;
        b=LsdA0kOIAm91MVBz1+MWHFN7paCqnA3DItTPkReECqOSlQCP3UD8ca9JEH8K8j16NU
         PjlcJ6RZe2mUzfZKjRGPnm/XooBH4bBGslUGP2FCqE2fkrczn9KY1XRSON4kcEQ51Eos
         geebEyAYHm351W1X6nLwl/1HEB9/SMLBOr9Zky/YsRq04OtmshQ56rbOxyuyyvFL+Sos
         Gv3eof7UZtCM5nJ/iaLCp5ZQFjbTWbFXBhoQoNkLdSM07QWnADdKMNrxM0SPtiLs5QEa
         YENb/UIbb1AHgRbv14gXJdxBNM+yybBEckX7FOGW/uPaBQEU5p2ILcUVNTJ35zhoIP4z
         ht8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692049513; x=1692654313;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05HbnIo80trrCFK3jXhlcJkX75MNBwCQ0epMdFi+1gQ=;
        b=NRVZx0p/tCvQ+QI9GPoTh7TfirYTnv/K7OtiliT0OomSAkZR99JeAtBfXaHQTs1jrr
         nWhSEEnlZ1g34fgSDtu229mY9W86XXQBSYs4HSs1g+BdQE5pKsIlj45u+tdUr3jyAcU8
         fdowT8FWZDCxr/u0iqBoqWtCxqiObQhTURTPIu2otrKGireaGn62xX1nrlG0TcBgJXMD
         KD2nYJsyLtSnSfKhu6I/mS4rEETvXxXkh7vyWRROQ7XR9w5T8mDyudsdjNJtmR+jBOTZ
         NAvtDbXteO5JeCdB12Ea6a2dFKga7izPwZFroe5WzX3hq4PRmr8fHqUlIl+XiyjPv/P2
         gRFQ==
X-Gm-Message-State: AOJu0Yw+J/nnlsKg5DO4/PWU4Jd0RBodLCiCNcy0uXDgDklpg28KpkuU
        B7D2TxWgkwfqqX+P+IvdjBE=
X-Google-Smtp-Source: AGHT+IE6XR5hEkCSGhgyQluYXyWANfP6XGgpfUeqyacV6TXD051wXFamvRF3xEJr/RUC2WjXRi4Abg==
X-Received: by 2002:a05:6a21:2716:b0:140:94b8:3b76 with SMTP id rm22-20020a056a21271600b0014094b83b76mr12191486pzb.20.1692049513554;
        Mon, 14 Aug 2023 14:45:13 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id e23-20020a62aa17000000b006877b0b31c2sm8669128pff.147.2023.08.14.14.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 14:45:13 -0700 (PDT)
Date:   Mon, 14 Aug 2023 14:45:11 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        isaku.yamahata@gmail.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/19] QEMU gmem implemention
Message-ID: <20230814214511.GG1807130@ls.amr.corp.intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <ZMfmkCQImgsinE6T@redhat.com>
 <9b3a3e88-21f4-bfd2-a9c3-60a25832e698@intel.com>
 <20230810155808.eqne5zzb53mirgcw@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230810155808.eqne5zzb53mirgcw@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023 at 10:58:09AM -0500,
Michael Roth via <qemu-devel@nongnu.org> wrote:

> On Tue, Aug 01, 2023 at 09:45:41AM +0800, Xiaoyao Li wrote:
> > On 8/1/2023 12:51 AM, Daniel P. Berrangé wrote:
> > > On Mon, Jul 31, 2023 at 12:21:42PM -0400, Xiaoyao Li wrote:
> > > > This is the first RFC version of enabling KVM gmem[1] as the backend for
> > > > private memory of KVM_X86_PROTECTED_VM.
> > > > 
> > > > It adds the support to create a specific KVM_X86_PROTECTED_VM type VM,
> > > > and introduces 'private' property for memory backend. When the vm type
> > > > is KVM_X86_PROTECTED_VM and memory backend has private enabled as below,
> > > > it will call KVM gmem ioctl to allocate private memory for the backend.
> > > > 
> > > >      $qemu -object memory-backend-ram,id=mem0,size=1G,private=on \
> > > >            -machine q35,kvm-type=sw-protected-vm,memory-backend=mem0 \
> > > > 	  ...
> > > > 
> > > > Unfortunately this patch series fails the boot of OVMF at very early
> > > > stage due to triple fault because KVM doesn't support emulate string IO
> > > > to private memory. We leave it as an open to be discussed.
> > > > 
> > > > There are following design opens that need to be discussed:
> > > > 
> > > > 1. how to determine the vm type?
> > > > 
> > > >     a. like this series, specify the vm type via machine property
> > > >        'kvm-type'
> > > >     b. check the memory backend, if any backend has 'private' property
> > > >        set, the vm-type is set to KVM_X86_PROTECTED_VM.
> > > > 
> > > > 2. whether 'private' property is needed if we choose 1.b as design
> > > > 
> > > >     with 1.b, QEMU can decide whether the memory region needs to be
> > > >     private (allocates gmem fd for it) or not, on its own.
> > > > 
> > > > 3. What is KVM_X86_SW_PROTECTED_VM going to look like? What's the
> > > >     purose of it and what's the requirement on it. I think it's the
> > > >     questions for KVM folks than QEMU folks.
> > > > 
> > > > Any other idea/open/question is welcomed.
> > > > 
> > > > 
> > > > Beside, TDX QEMU implemetation is based on this series to provide
> > > > private gmem for TD private memory, which can be found at [2].
> > > > And it can work corresponding KVM [3] to boot TDX guest.
> > > 
> > > We already have a general purpose configuration mechanism for
> > > confidential guests.  The -machine argument has a property
> > > confidential-guest-support=$OBJECT-ID, for pointing to an
> > > object that implements the TYPE_CONFIDENTIAL_GUEST_SUPPORT
> > > interface in QEMU. This is implemented with SEV, PPC PEF
> > > mode, and s390 protvirt.
> > > 
> > > I would expect TDX to follow this same design ie
> > > 
> > >      qemu-system-x86_64 \
> > >        -object tdx-guest,id=tdx0,..... \
> > >        -machine q35,confidential-guest-support=tdx0 \
> > >        ...
> > > 
> > > and not require inventing the new 'kvm-type' attribute at least.
> > 
> > yes.
> > 
> > TDX is initialized exactly as the above.
> > 
> > This RFC series introduces the 'kvm-type' for KVM_X86_SW_PROTECTED_VM. It's
> > my fault that forgot to list the option of introducing sw_protected_vm
> > object with CONFIDENTIAL_GUEST_SUPPORT interface.
> > Thanks for Isaku to raise it https://lore.kernel.org/qemu-devel/20230731171041.GB1807130@ls.amr.corp.intel.com/
> > 
> > we can specify KVM_X86_SW_PROTECTED_VM this way:
> > 
> > qemu  \
> >   -object sw-protected,id=swp0,... \
> >   -machine confidential-guest-support=swp0 \
> >   ...
> > 
> > > For the memory backend though, I'm not so sure - possibly that
> > > might be something that still wants an extra property to identify
> > > the type of memory to allocate, since we use memory-backend-ram
> > > for a variety of use cases.  Or it could be an entirely new object
> > > type such as "memory-backend-gmem"
> > 
> > What I want to discuss is whether providing the interface to users to allow
> > them configuring which memory is/can be private. For example, QEMU can do it
> > internally. If users wants a confidential guest, QEMU allocates private gmem
> > for normal RAM automatically.
> 
> I think handling it automatically simplifies things a good deal on the
> QEMU side. I think it's still worthwhile to still allow:
> 
>  -object memory-backend-memfd-private,...
> 
> because it provides a nice mechanism to set up a pair of shared/private
> memfd's to enable hole-punching via fallocate() to avoid doubling memory
> allocations for shared/private. It's also a nice place to control
> potentially-configurable things like:
> 
>  - whether or not to enable discard/hole-punching
>  - if discard is enabled, whether or not to register the range via
>    RamDiscardManager interface so that VFIO/IOMMU mappings get updated
>    when doing PCI passthrough. SNP relies on this for PCI passthrough
>    when discard is enabled, otherwise DMA occurs to stale mappings of
>    discarded bounce-buffer pages:
> 
>      https://github.com/AMDESE/qemu/blob/snp-latest/backends/hostmem-memfd-private.c#L449
> 
> But for other memory ranges, it doesn't do a lot of good to rely on
> users to control those via -object memory-backend-memfd-private, since
> QEMU will set up some regions internally, like the UEFI ROM.
> 
> It also isn't ideal for QEMU itself to internally control what
> should/shouldn't be set up with a backing guest_memfd, because some
> guest kernels do weird stuff, like scan for ROM regions in areas that
> guest kernels might have mapped as encrypted in guest page table. You
> can consider them to be guest bugs, but even current SNP-capable
> kernels exhibit this behavior and if the guest wants to do dumb stuff
> QEMU should let it.
> 
> But for these latter 2 cases, it doesn't make sense to attempt to do
> any sort of discarding of backing pages since it doesn't make sense to
> discard ROM pages.
> 
> So I think it makes sense to just set up the gmemfd automatically across
> the board internally, and keep memory-backend-memfd-private around
> purely as a way to control/configure discardable memory.


I'm looking at the repo and
31a7c7e36684 ("*hostmem-memfd-private: Initial discard manager support")

Do we have to implement RAM_DISCARD_MANGER at memory-backend-memfd-private?
Can't we implement it at host_mem? The interface callbacks can have check
"if (!private) return".  Then we can support any host-mem backend.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
