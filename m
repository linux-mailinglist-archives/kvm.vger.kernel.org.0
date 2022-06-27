Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3911455C7BA
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbiF0SQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 14:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbiF0SQd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 14:16:33 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8B7DF65
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:16:31 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i25so8704245wrc.13
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 11:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LlJtaVzVIPbITR1tJ88VD+jcE++J+LsNM5MudmiK28=;
        b=ah1xQBJc+xEd1R0W2HGpRMCsaYZJDKR0IEIpQLbDCyo+7zewg9Q9ruwKsiQJi8zDDr
         xkaPmSRmSDagG8t876mkd+0kPUkntNCoVD5qCO0c2WFqtPVh8e3NOfVdr2gcmaSIGzWv
         UYgYTcf0m0bKJVQ6fV2fJjzL2/0/yGh72iup5k4Y1JCymUSMEHI+fITbCqNe6L7uSEkY
         tChiBA5KCj1ngwGjKjgASrDzFNysmKLUrROFKHgqUTJXHFLG2yDyNmdlHOBGEmGZdh/z
         zqdRlbiYXBj7cNnoHObc1dS4vUPkTd/9bkzn+/Gm+M0rJICtAdjXqkrLdxvR/xap8co9
         8HKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LlJtaVzVIPbITR1tJ88VD+jcE++J+LsNM5MudmiK28=;
        b=Q1LIGwuk0a2mNMsojqKBibamEsCGxduamy21jx8Jbt3rhEwFAY1g6vs5NgzllDwgjS
         17LMVJUAwPd6k76CU+plVUfg3XJ97qCPBA7Jg77/Sax5zmc0VZ70qL0rFxVJbU/pUU/y
         peNNBtPXng0SfMl7dXwWf378VmZ0rRwAUBYFlThCWYOgJkll/pSWjYkgC7xHbASpm4Qu
         v/3Dm6sw6N9NIC8wu9KjrPx86xW+L9U+jBnIDal0KHleginBBnHlnuJ2TZ566DkrhZkM
         Eiy08RJW/z1GwdOPmdqZzvlpbVFB9Vozm3+GKOloggRkBeh/+KPX91ZqvUQQy7lSMV8Y
         uzlQ==
X-Gm-Message-State: AJIora8d3stYh97g66CHEdNVwrVOReR9hROAI0ND7kz0limsqRI/DF6U
        d2vQ1TOHCxQEJp/S3NoCVloLnHjmsqPh3bKBkRzLvRSM0qU6yQ==
X-Google-Smtp-Source: AGRyM1seKdGGzR2nopVunzukx19s+tFcWxVOYunQqO+UaE1iq3u9pesjp5GTynZZ50K9elCTOUy0F5yovwsdhktAOFU=
X-Received: by 2002:a05:6000:2a8:b0:21b:bdd9:569a with SMTP id
 l8-20020a05600002a800b0021bbdd9569amr12390206wry.170.1656353789831; Mon, 27
 Jun 2022 11:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220623234944.141869-1-pcc@google.com> <YrXu0Uzi73pUDwye@arm.com>
 <CAMn1gO7-qVzZrAt63BJC-M8gKLw4=60iVUo6Eu8T_5y3AZnKcA@mail.gmail.com> <YrmXzHXv4babwbNZ@arm.com>
In-Reply-To: <YrmXzHXv4babwbNZ@arm.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 27 Jun 2022 11:16:17 -0700
Message-ID: <CAMn1gO5s2m-AkoYpY0dcLkKVyEAGeC2borZfgT09iqc=w_LZxQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>,
        Steven Price <steven.price@arm.com>
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

On Mon, Jun 27, 2022 at 4:43 AM Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> On Fri, Jun 24, 2022 at 02:50:53PM -0700, Peter Collingbourne wrote:
> > On Fri, Jun 24, 2022 at 10:05 AM Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > + Steven as he added the KVM and swap support for MTE.
> > >
> > > On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
> > > > Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
> > > > depend on being able to map guest memory as MAP_SHARED. The current
> > > > restriction on sharing MAP_SHARED pages with the guest is preventing
> > > > the use of those features with MTE. Therefore, remove this restriction.
> > >
> > > We already have some corner cases where the PG_mte_tagged logic fails
> > > even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
> > > KVM MAP_SHARED will potentially make things worse (or hard to reason
> > > about; for example the VMM sets PROT_MTE as well). I'm more inclined to
> > > get rid of PG_mte_tagged altogether, always zero (or restore) the tags
> > > on user page allocation, copy them on write. For swap we can scan and if
> > > all tags are 0 and just skip saving them.
> >
> > A problem with this approach is that it would conflict with any
> > potential future changes that we might make that would require the
> > kernel to avoid modifying the tags for non-PROT_MTE pages.
>
> Not if in all those cases we check VM_MTE_ALLOWED. We seem to have the
> vma available where it matters. We can keep PG_mte_tagged around but
> always set it on page allocation (e.g. when zeroing or CoW) and check
> VM_MTE_ALLOWED rather than VM_MTE.

Right, but for avoiding tagging we would like that to apply to as many
pages as possible. If we check VM_MTE_ALLOWED then the heap pages of
those processes that are not using MTE would not be covered, which on
a mostly non-MTE system would be a majority of pages.

Over the weekend I thought of another policy, which would be similar
to your original one. We can always tag pages which are mapped as
MAP_SHARED. These pages are much less common than private pages, so
the impact would be less. So the if statement in
alloc_zeroed_user_highpage_movable would become:

if ((vma->vm_flags & VM_MTE) || (system_supports_mte() &&
(vma->vm_flags & VM_SHARED)))

That would allow us to put basically any shared mapping in the guest
address space without needing to deal with races in sanitise_mte_tags.

We may consider going further than this and require all pages mapped
into guests with MTE enabled to be PROT_MTE. I think it would allow
dropping sanitise_mte_tags entirely. This would not be a relaxation of
the ABI but perhaps we can get away with it if, as Cornelia mentioned,
QEMU does not currently support MTE, and since crosvm doesn't
currently support it either there's no userspace to break AFAIK. This
would also address a current weirdness in the API where it is possible
for the underlying pages of a MAP_SHARED file mapping to become tagged
via KVM, said tags are exposed to the guest and are discarded when the
underlying page is paged out. We can perhaps accomplish it by dropping
support for KVM_CAP_ARM_MTE in the kernel and introducing something
like a KVM_CAP_ARM_MTE_V2 with the new restriction.

> I'm not sure how Linux can deal with pages that do not support MTE.
> Currently we only handle this at the vm_flags level. Assuming that we
> somehow manage to, we can still use PG_mte_tagged to mark the pages that
> supported tags on allocation (and they have been zeroed or copied). I
> guess if you want to move a page around, you'd need to go through
> something like try_to_unmap() (or set all mappings to PROT_NONE like in
> NUMA migration). Then you can either check whether the page is PROT_MTE
> anywhere and maybe read the tags to see whether all are zero after
> unmapping.
>
> Deferring tag zeroing/restoring to set_pte_at() can be racy without a
> lock (or your approach with another flag) but I'm not sure it's worth
> the extra logic if zeroing or copying the tags doesn't have a
> significant overhead for non-PROT_MTE pages.
>
> Another issue with set_pte_at() is that it can write tags on mprotect()
> even if the page is mapped read-only. So far I couldn't find a problem
> with this but it adds to the complexity.
>
> > Thinking about this some more, another idea that I had was to only
> > allow MAP_SHARED mappings in a guest with MTE enabled if the mapping
> > is PROT_MTE and there are no non-PROT_MTE aliases. For anonymous
> > mappings I don't think it's possible to create a non-PROT_MTE alias in
> > another mm (since you can't turn off PROT_MTE with mprotect), and for
> > memfd maybe we could introduce a flag that requires PROT_MTE on all
> > mappings. That way, we are guaranteed that either the page has been
> > tagged prior to fault or we have exclusive access to it so it can be
> > tagged on demand without racing. Let me see what effect that has on
> > crosvm.
>
> You could still have all initial shared mappings as !PROT_MTE and some
> mprotect() afterwards setting PG_mte_tagged and clearing the tags and
> this can race. AFAICT, the easiest way to avoid the race is to set
> PG_mte_tagged on allocation before it ends up in set_pte_at().

For shared pages we will be safe with my new proposal because the
pages will always be tagged. For private ones we might need to move
pages to an MTE supported region in response to the mprotect, as you
discussed above.

Peter
