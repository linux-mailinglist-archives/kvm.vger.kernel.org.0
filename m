Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DF4558854
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 21:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiFWTHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 15:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiFWTHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 15:07:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4411194F2
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:12:38 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id e5so11498017wma.0
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 11:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fE/hn8d1SxB+WF9l62z81tDfQAMtVscZwT7QZwLa4i4=;
        b=awzDMxUoNHvZgy6lw0yBYzcMwwUE/rsgv7EdfwAqAZvk/FYB5MjxT96L6VpUeCLdMM
         q+SqS4u02xnPBg03TFxz9GvCgyRYTwD8N1MtNFAB8w51dBzCjFxfokktX8VWoQUszl5k
         9DLa8yc6QltXFWgLehCCVo1oq8FqxP9LskAgCwEorWgzMbm3Z+cXVxkxMeFzLDambLK3
         nF4urVFAKtau9c5dSF0vAKMO+Lh7znaIPsBVUzXFn8176xONMWqPio5LvM+64CkHK/D5
         rKcvMR8DBqpNBf3fbL9EIbJtuu5gs0lWSXgdnuez9QkLbOcQ/54chwV9VHX083qfTrJq
         0LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fE/hn8d1SxB+WF9l62z81tDfQAMtVscZwT7QZwLa4i4=;
        b=xBhYKEwuDac7KZO3eaOp5vkor8pdNh//1JgfogYOFutbYAvHilgrJVnMV48cPnxr/z
         wLG7Qv+P3i1HQfC8GZs1YD2cN7BGjN3r46sJ1jbe2Qua/JC8kzm5u+cA5I/+2xbZycxi
         JL9a2rwvRlvaA3LWiLl/yZkzuYu5f8jp6g114zPNXJTeQjkiHgIH2svtrffGZJWCYH+0
         tLwkS6Mw+eYZh0WKiG+dSTpKtQjAgG0ZRPKscm4tRY4dnYVaye/ge0mXZFto2lX9dgMp
         SRDpttwNpExQmBQgVE9BQGKrGRQVGd0fD/aY75EKFj51Rr/HJyD62TM4EhYRevZ82p03
         0vsg==
X-Gm-Message-State: AJIora/JTQmdmyyUhX8rED2LA4gtwYssKzZVMo914UV70TnFvjSHikyj
        4wIJMyTt3jIwn3cE7VOqaslRS+CKyuNQojPqET08Ew==
X-Google-Smtp-Source: AGRyM1s/fZccnSKBWvj+dourDgZr/O+gW7wossFeEqxf1vrMwtrpiVhU64nQC1w8oOn2ieqVBklFfi39qtIUPXd9XTE=
X-Received: by 2002:a1c:7418:0:b0:39c:6ead:321c with SMTP id
 p24-20020a1c7418000000b0039c6ead321cmr5508368wmc.171.1656007949830; Thu, 23
 Jun 2022 11:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220623021926.3443240-1-pcc@google.com> <20220623021926.3443240-2-pcc@google.com>
 <YrRmmrY24Pv6hyAO@google.com>
In-Reply-To: <YrRmmrY24Pv6hyAO@google.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Thu, 23 Jun 2022 11:12:17 -0700
Message-ID: <CAMn1gO4RyNCh8aYxrbHqff0xK5vSaV9iaRt20Utb8x9wQA2BYg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
To:     Quentin Perret <qperret@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
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

On Thu, Jun 23, 2022 at 6:12 AM Quentin Perret <qperret@google.com> wrote:
>
> Hi Peter,
>
> On Wednesday 22 Jun 2022 at 19:19:24 (-0700), Peter Collingbourne wrote:
> > @@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
> >       /*
> >        * The refcount tracks valid entries as well as invalid entries if they
> >        * encode ownership of a page to another entity than the page-table
> > -      * owner, whose id is 0.
> > +      * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
> >        */
> > -     return !!pte;
> > +     return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
> >  }
>
> I'm not sure to understand this part? By not refcounting the PTEs that
> are annotated with PKVM_ID_NOBODY, the page-table page that contains
> them may be freed at some point. And when that happens, I don't see how
> the hypervisor will remember to block host accesses to the disowned
> pages.

This was because I misunderstood the code and thought that this was
for maintaining a count from PTEs to the pages that they reference
(which would make the refcounting unnecessary for pages owned by
nobody). Reading the code more carefully my understanding is now that
the refcounts are instead for tracking the number of non-zero PTEs in
the page table, so that the hypervisor knows that it can free up a
page table when it becomes all zeros i.e. no longer contains any
information that needs to be preserved (so the "references" that are
being counted are implicit in the location of the PTE). So it doesn't
make sense to not track PTEs owned by nobody here. I'll remove this
part in v2.

Peter
