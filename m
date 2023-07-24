Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79787760061
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 22:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjGXUQf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 16:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjGXUQe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 16:16:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2428E1712
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 13:16:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d063bd0bae8so4344099276.0
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 13:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690229788; x=1690834588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CpyeHlxyK/Wxza2B0XbnLOYUqgpeakiOlUVm3eRpM6Q=;
        b=j6FiLWVW1BEQWGRGDCNKnMdB/uBrkbSbLa1K1EDw/LiBM7C6eVkoRkCUsQ09WI8/Mv
         Fny2LhZv1neNQ3Jabn3zYbY6YAZITRpwrzXHx4zZI9u5ceWLtCDmcrZMemFoU3tDb+fK
         QbZ10Y+HN6R5WqhLtydaZX/6MwLGX2RVH/oHsL6aYKs8GIgi9WZA1x9l1MEoJwLIL1vk
         itEK9g3ya0QTjILKmAA+DLMdCsEqRbStG5n7GR6YMdTn19PRPfIIB/OUkoR8GuYkump5
         Op2hTrJXwr4NruPzzDOUA9+Du2VRB5PlDnJFULu7iJPUU+tT8iGY+bsTsCFdJfYvGyo6
         5PLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690229788; x=1690834588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpyeHlxyK/Wxza2B0XbnLOYUqgpeakiOlUVm3eRpM6Q=;
        b=JFpEJhg5KEsCmLlOn6ldclsFM0Toiqzdgi9TB87C20/GzhOvD/vPC+neyDMQA0QI7B
         cCbKSeoYKF3qGDDFTrCeUmsAhEFsQITazzxKHlHjYqMtrbSvTX2YJYC1EgypdKDtDslD
         MJxv4A8H3zLhAqM0OISQVlJf+8xTz6Ef3iftCKbQ5nAzcrwHgOveqaG1sCL7lJOycdHA
         A908U+IjAKHjpGnJxComAZKSoGbhUpfsKAAzha+QzK9x7Nk/H0tGK9UzyTf/+lVKaKJu
         BjsTPGQq4kWkILEOepMesmE+erroYjCgctQQ4lbqgq/9GDQenRZwmxflXPwoBuyGa4e3
         /OJg==
X-Gm-Message-State: ABy/qLbn2jeFPEDQbxzYOTF/+PzVsusuSXEgQJyWSbXombvXlMZg/lFi
        DeeQlkHiXNgnp75sxFWtQoH0CKdlhCs=
X-Google-Smtp-Source: APBJJlETEm+sUDMdwBxTQh+PqsroqqaXQ8T9Z3RbdwPygXWQyA0h4pdWgzZRNvYOpLPGkfrhzs9fYbXOMr8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:cf2:ad45:2084 with SMTP id
 w15-20020a056902100f00b00cf2ad452084mr67527ybt.12.1690229788310; Mon, 24 Jul
 2023 13:16:28 -0700 (PDT)
Date:   Mon, 24 Jul 2023 13:16:26 -0700
In-Reply-To: <20230718234512.1690985-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com>
Message-ID: <ZL7cGrJNV3//wsXD@google.com>
Subject: Re: [RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dropped non-KVM folks from Cc: so as not to bother them too much.

On Tue, Jul 18, 2023, Sean Christopherson wrote:
> This is the next iteration of implementing fd-based (instead of vma-based)
> memory for KVM guests.  If you want the full background of why we are doing
> this, please go read the v10 cover letter[1].
> 
> The biggest change from v10 is to implement the backing storage in KVM
> itself, and expose it via a KVM ioctl() instead of a "generic" sycall.
> See link[2] for details on why we pivoted to a KVM-specific approach.
> 
> Key word is "biggest".  Relative to v10, there are many big changes.
> Highlights below (I can't remember everything that got changed at
> this point).
> 
> Tagged RFC as there are a lot of empty changelogs, and a lot of missing
> documentation.  And ideally, we'll have even more tests before merging.
> There are also several gaps/opens (to be discussed in tomorrow's PUCK).

I've pushed this to

  https://github.com/kvm-x86/linux/tree/guest_memfd

along with Isaku's fix for the lock ordering bug on top.

As discussed at PUCK, I'll apply fixes/tweaks/changes on top until development
stabilizes, and will only squash/fixup when we're ready to post v12 for broad
review.

Please "formally" post patches just like you normally would do, i.e. don't *just*
repond to the buggy mail (though that is also helpful).  Standalone patches make
it easier for me to manage things via lore/b4.

If you can, put gmem or guest_memfd inside the square braces, e.g.

  [PATCH gmem] KVM: <shortlog>

so that it's obvious the patch is intended for the guest_memfd branch.  For fixes,
please also be sure to use Fixes: tags and split patches to fix exactly one base
commit, again to make my life easier.

I'll likely add my own annotations when applying, e.g. [FIXUP] and whatnot, but
that's purely notes for myself for the future squash/rebase.

Thanks!
