Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6065155FAF6
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 10:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiF2IqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 04:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiF2Ip6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 04:45:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F0A3CA7F
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 01:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA76F61DBD
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23F5C3411E;
        Wed, 29 Jun 2022 08:45:53 +0000 (UTC)
Date:   Wed, 29 Jun 2022 09:45:50 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Steven Price <steven.price@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Message-ID: <YrwRPh1S6qjzkJMm@arm.com>
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com>
 <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ykmcd8q.fsf@redhat.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 05:55:33PM +0200, Cornelia Huck wrote:
> [I'm still in the process of trying to grok the issues surrounding
> MTE+KVM, so apologies in advance if I'm muddying the waters]

No worries, we are not that far ahead either ;).

> On Sat, Jun 25 2022, Steven Price <steven.price@arm.com> wrote:
> > On 24/06/2022 18:05, Catalin Marinas wrote:
> >> + Steven as he added the KVM and swap support for MTE.
> >> 
> >> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> >>> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> >>> depend on being able to map guest memory as MAP_SHARED. The current
> >>> restriction on sharing MAP_SHARED pages with the guest is preventing
> >>> the use of those features with MTE. Therefore, remove this restriction.
> >> 
> >> We already have some corner cases where the PG_mte_tagged logic fails
> >> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> >> KVM MAP_SHARED will potentially make things worse (or hard to reason
> >> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> >> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> >> on user page allocation, copy them on write. For swap we can scan and if
> >> all tags are 0 and just skip saving them.
> >> 
> >> Another aspect is a change in the KVM ABI with this patch. It's probably
> >> not that bad since it's rather a relaxation but it has the potential to
> >> confuse the VMM, especially as it doesn't know whether it's running on
> >> older kernels or not (it would have to probe unless we expose this info
> >> to the VMM in some other way).
> 
> Which VMMs support KVM+MTE so far? (I'm looking at adding support in QEMU.)

Steven to confirm but I think he only played with kvmtool. Adding
Jean-Philippe who also had Qemu on his plans at some point.

> What happens in kvm_vm_ioctl_mte_copy_tags()? I think we would just end
> up copying zeroes?

Yes. For migration, the VMM could ignore sending over tags that are all
zeros or maybe use some simple compression. We don't have a way to
disable MTE for guests, so all pages mapped into the guest address space
end up with PG_mte_tagged.

> That said, do we make any assumptions about when KVM_ARM_MTE_COPY_TAGS
> will be called? I.e. when implementing migration, it should be ok to
> call it while the vm is paused, but you probably won't get a consistent
> state while the vm is running?

Wouldn't this be the same as migrating data? The VMM would only copy it
after it was marked read-only. BTW, I think sanitise_mte_tags() needs a
barrier before setting the PG_mte_tagged() flag (unless we end up with
some lock for reading the tags).

> [Postcopy needs a different interface, I guess, so that the migration
> target can atomically place a received page and its metadata. I see
> https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
> has there been any follow-up?]

I don't follow the qemu list, so I wasn't even aware of that thread. But
postcopy, the VMM needs to ensure that both the data and tags are up to
date before mapping such page into the guest address space.

-- 
Catalin
