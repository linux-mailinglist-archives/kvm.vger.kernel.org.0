Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 419505847C7
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 23:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiG1VlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiG1VlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 17:41:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947755142E
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 14:41:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id w7so2886547ply.12
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 14:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bqeABTxGQTDz6Qdm0FRzgWxnlTEHH6Ytj+e5WoKlX9o=;
        b=RRucGTqTTQzeQcuR07bz1WJ4pxTwsK7dR/AirbzU0cDMl1a4d/XPBmB4pzgWxFUWxo
         QiDihGbpO7ykiwej5rq/Ht+xV/3mrh2nbsnuInTPH9APjpJnQSRcKa/vz/BEF1LGbxGb
         l/CyW/LZ7uZZRd8SkCEXSxgWAhD6y6HP8IG4OTk/vfV/2mUq9DhgCJz983nMsd4tZzV3
         9xcYfVt7LIRa/pTWNUWqWBTy/6wVuc8O/5pTF4IWgUL3k3PTjEbiPI3NvDReNABeN4Ad
         wHhZIJYWm0EVv8LwU5u6s74KxnymKGHyDH1yyP8kbk9WkSGlj5osR5nzsbkVnrcgs+fh
         D8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bqeABTxGQTDz6Qdm0FRzgWxnlTEHH6Ytj+e5WoKlX9o=;
        b=xkCCXB4qv65BUXkLqO489cVgVTITTaLWdsMTAN5QS/1obQBi7Q+MoS6+zL/+qqS6DM
         8hTymaHaCQzCNdZ858GB6fYDgLrZm4PDjam42OwiVjcsk07osz/aI4AJLozoGeZWdHEH
         5de9OYyCcI5d6fRIXK8x8W1MBIUIBiPWGydhtgZZfnttAHHuMFL70fqDM/amyLbaFwCW
         GK1F3RJyw53mZWCTC4gZ4w5/l0Mgb8z80eXX0S/UvKZ451pqMN4GEtZZf80pFW5YXmLl
         tmEmY8nliyW/ejN8Cy5mn2BHJbmw1TwWj1mbRKfXYeGiffi2AjMMTjbREKK3Pt60qaGD
         eJow==
X-Gm-Message-State: ACgBeo1sRB/T83F7G/NiRR5NE/IwfU98/J/VmLR055qwGA7nv9hpmP+l
        F0DVO+XXCGzQ7rnbai688vLKs4aw8FBtJvutlOPqcg==
X-Google-Smtp-Source: AA6agR4z5qrgAr38neIx9KxOypAhLMErO+xBzP4aTQFVwzTTRHJ6ojXPeKBNQCx1cEX6gqAcqbuxe2LLKMQ9ruR5ac4=
X-Received: by 2002:a17:902:c40a:b0:16d:2dcb:9b8c with SMTP id
 k10-20020a170902c40a00b0016d2dcb9b8cmr741853plk.61.1659044480954; Thu, 28 Jul
 2022 14:41:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com> <08c9e2ed-29a2-14ea-c872-1a353a70d3e5@redhat.com>
 <YuL9sB8ux88TJ9o0@google.com>
In-Reply-To: <YuL9sB8ux88TJ9o0@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 28 Jul 2022 14:41:09 -0700
Message-ID: <CAL715WJ-joevnX+D2TDUmCA0bemJWpfimutxsQSjWZyk03Gsow@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 2:20 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 28, 2022, Paolo Bonzini wrote:
> > On 7/23/22 03:23, Sean Christopherson wrote:
> > > Patch 6 from Mingwei is the end goal of the series.  KVM incorrectly
> > > assumes that the NX huge page mitigation is the only scenario where KVM
> > > will create a non-leaf page instead of a huge page.   Precisely track
> > > (via kvm_mmu_page) if a non-huge page is being forced and use that info
> > > to avoid unnecessarily forcing smaller page sizes in
> > > disallowed_hugepage_adjust().
> > >
> > > v2: Rebase, tweak a changelog accordingly.
> > >
> > > v1:https://lore.kernel.org/all/20220409003847.819686-1-seanjc@google.com
> > >
> > > Mingwei Zhang (1):
> > >    KVM: x86/mmu: explicitly check nx_hugepage in
> > >      disallowed_hugepage_adjust()
> > >
> > > Sean Christopherson (5):
> > >    KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
> > >    KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
> > >      MMUs
> > >    KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
> > >      SPTE
> > >    KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
> > >      pages
> > >    KVM: x86/mmu: Add helper to convert SPTE value to its shadow page
> >
> > Some of the benefits are cool, such as not having to track the pages for the
> > TDP MMU, and patch 2 is a borderline bugfix, but there's quite a lot of new
> > non-obvious complexity here.
>
> 100% agree on the complexity.
>
> > So the obligatory question is: is it worth a hundred lines of new code?
>
> Assuming I understanding the bug Mingwei's patch fixes, yes.  Though after
> re-reading that changelog, it should more explicitly call out the scenario we
> actually care about.
>
> Anyways, the bug we really care about is that by not precisely checking if a
> huge page is disallowed, KVM would refuse to create huge page after disabling
> dirty logging, which is a very noticeable performance issue for large VMs if
> a migration is canceled.  That particular bug has since been unintentionally
> fixed in the TDP MMU by zapping the non-leaf SPTE, but there are other paths
> that could similarly be affected, e.g. I believe zapping leaf SPTEs in response
> to a host page migration (mmu_notifier invalidation) to create a huge page would
> yield a similar result; KVM would see the shadow-present non-leaf SPTE and assume
> a huge page is disallowed.

Just a quick update: the kernel crash has been resolved. It turns out
to be a bug introduced when I rebase the patch.

I see the patch set is working now.
