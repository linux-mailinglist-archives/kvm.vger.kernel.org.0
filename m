Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C6F67396A
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 14:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjASNF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 08:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjASNEi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 08:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B7346A2;
        Thu, 19 Jan 2023 05:03:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D565F60F42;
        Thu, 19 Jan 2023 13:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB22C433EF;
        Thu, 19 Jan 2023 13:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674133401;
        bh=ijfFcGC5kAQ2nYmXEtcyL9+phHOOgiGJvROKRw4V2qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RZdMtEEuZr7tE97F12rPotBfCByLsKQcgcA6T//IQ5YqeQ/v/D6XDedO0BpuyIUnx
         TBg5Gnpd4zOJUj/FvJCpx5TpBLL+470yit5tW60gms8xNYxGspnGiJA9tNTbG7R1wv
         Z1VUxRwnyHcRPmdsKatfbX51tTlsShJvyrmuxG0VDCg1QTDKKpxv0am630By1QBssp
         vzVOhZKVLz/CJJzpxLSHiCJ2Xa5fGCzVmk3raNpsu/uSz7pax5V9iNKDXGzwIgECbD
         syk+CFVp5gx0CaFlSgcEdglnzc1pcBa8wCK5SMZItMZeaNCkmFgxHV+fT/JMPsu7eg
         1A6DhF3Oj86pQ==
Date:   Thu, 19 Jan 2023 13:03:17 +0000
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Michael Roth <michael.roth@amd.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, ashish.kalra@amd.com,
        harald@profian.com, chao.p.peng@linux.intel.com
Subject: Re: [PATCH RFC v7 02/64] KVM: x86: Add
 KVM_CAP_UNMAPPED_PRIVATE_MEMORY
Message-ID: <Y8k/lXt18LwtUlff@kernel.org>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-3-michael.roth@amd.com>
 <Y6RM8RRryLgK8KiB@zn.tnic>
 <20230104174721.wa4detzppqzvsgsy@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104174721.wa4detzppqzvsgsy@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 11:47:21AM -0600, Michael Roth wrote:
> On Thu, Dec 22, 2022 at 01:26:25PM +0100, Borislav Petkov wrote:
> > On Wed, Dec 14, 2022 at 01:39:54PM -0600, Michael Roth wrote:
> > > This mainly indicates to KVM that it should expect all private guest
> > > memory to be backed by private memslots. Ideally this would work
> > > similarly for others archs, give or take a few additional flags, but
> > > for now it's a simple boolean indicator for x86.
> > 
> > ...
> > 
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index c7e9d375a902..cc9424ccf9b2 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
> > >  #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> > >  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> > >  #define KVM_CAP_MEMORY_ATTRIBUTES 225
> > > +#define KVM_CAP_UNMAPPED_PRIVATE_MEM 240
> > 
> > Isn't this new cap supposed to be documented somewhere in
> > Documentation/virt/kvm/api.rst ?
> 
> It should, but this is sort of a placeholder for now. Ideally we'd
> re-use the capabilities introduced by UPM patchset rather than introduce
> a new one. Originally the UPM patchset had a KVM_CAP_PRIVATE_MEM which
> we planned to use to switch between legacy SEV and UPM-based SEV (for
> lazy-pinning support) by making it writeable, but that was removed in v10
> in favor of KVM_CAP_MEMORY_ATTRIBUTES, which is tied to the new
> KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES ioctls:
> 
>   https://lore.kernel.org/lkml/CA+EHjTxXOdzcP25F57Mtmnb1NWyG5DcyqeDPqzjEOzRUrqH8FQ@mail.gmail.com/
> 
> It wasn't clear at the time if that was the right interface to use for
> this particular case, so we stuck with the more general
> 'use-upm/dont-use-upm' semantics originally provided by making
> KVM_CAP_UNMAPPED_PRIVATE_MEM/KVM_CAP_PRIVATE_MEM writeable.
> 
> But maybe it's okay to just make KVM_CAP_MEMORY_ATTRIBUTES writeable and
> require userspace to negotiate it rather than just tying it to
> CONFIG_HAVE_KVM_MEMORY_ATTRIBUTES. Or maybe introducing a new
> KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to pair with
> KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES. It sort of makes sense, since userspace
> needs to be prepared to deal with KVM_EXIT_MEMORY_FAULTs relating to these
> attributes.

Doesn't upm patch set imply that user space should negotiate the memory
attributes with the ioctl? 

For me it looks like that the problem is introduced by conflicting usage
pattern in the SNP code [*].

Perhaps sev_launch_update_gfn_handler() should not set memory attributes
but instead expect user space to do it before the call?

[*] https://lore.kernel.org/all/Y8cydYUfTUFwCh4K@kernel.org/

BR, Jarkko
