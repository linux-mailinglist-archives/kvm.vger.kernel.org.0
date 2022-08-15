Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61632594ED1
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiHPCpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiHPCpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:45:17 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DA52A92CB
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:09:37 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id l10so9023933lje.7
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 16:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UTyQ2iBOsFdh0uE4SZJWHs/VdqvWr96W3H/EYMtXVOE=;
        b=Hn43eXtQG/eXeLxy2bS3ugTIyzv8ublHVhkNSmP1rh+XSOs7iM47Hkkv7weVu4DbG6
         XEs0dS1u/jh8DpvPz3udIv5nMRGiwG9mdPjSJ1ELXj1BwKoLm52fsrXPAPQxpI368D7K
         O3NoyPKvMZOyQOY/AVbSAhAmO+f4RzKIqBvpSXGNoYE0GJGXoEn+PU41SOvKnhNLxwN+
         Qo1IEWa24JO+IVZiUtog6ZZqZMBcfz2MOjLB0Y7m8tK5CQ6ZLkbjIgH/fyUN7hMQZgrL
         BOS5pbWjEauMaat04SfYhoChZmHDNPfhcxCwv0KX1MpGCLH/++mqz4nG9xMUVvxs0UnQ
         X/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UTyQ2iBOsFdh0uE4SZJWHs/VdqvWr96W3H/EYMtXVOE=;
        b=TEaBqFM06c51IPAEPiucIcUwFJK9bFb/7ciS1ecGdno+bmCahvfpQh+AU0R2ta3uVT
         QDWDrESivWnfZYYYPycBrwqHFImjinHkpEEeS6B2K6S7beElIXu+LiaMy0Nf5bZ923c2
         IOuvU8h60dlLNUM3w/IFje0svdOin15406Da8dsIVfSzTfDB05VlQyJ1NztCmFW+V9P1
         ceCwcTXiJAUr0SN2ExBpXXGgq+LrG/ayKBmJxgYZNQamy6EQAULzeV0lzkBt4SWv5vfb
         Y1pkbiG1v+Eqci/14GloUdvxWgZX0hbh8BW3Qzlek0Jre+cqCF5VpXph2dIg1J7IXQax
         uUIg==
X-Gm-Message-State: ACgBeo1UmAwGr6+cjBB4c0d1OIHGufbOiCZPv2qQDz/S1MKXCYFmx93G
        oqiJrfzHm3uU6sxWALIYuV6raw5v4egtke8JyknBaA==
X-Google-Smtp-Source: AA6agR4JpXnKYo9p8yISIs78vh+snol8taNpE7/1Q3/Nc/8SLOHCm4PMqowVZSE77DGuxKMTzgdH9SGkyrl/OZP2id0=
X-Received: by 2002:a2e:9dce:0:b0:261:806d:1de with SMTP id
 x14-20020a2e9dce000000b00261806d01demr3470606ljj.72.1660604975018; Mon, 15
 Aug 2022 16:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220815230110.2266741-1-dmatlack@google.com> <20220815230110.2266741-10-dmatlack@google.com>
In-Reply-To: <20220815230110.2266741-10-dmatlack@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 15 Aug 2022 16:09:08 -0700
Message-ID: <CALzav=eaH_5QnUhhRq17yP-E2DAKxtMgtv7pAgCy5qDL-7xxDw@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: x86/mmu: Try to handle no-slot faults during kvm_faultin_pfn()
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        kvm list <kvm@vger.kernel.org>
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

On Mon, Aug 15, 2022 at 4:01 PM David Matlack <dmatlack@google.com> wrote:
>
> Try to handle faults on GFNs that do not have a backing memslot during
> kvm_faultin_pfn(), rather than relying on the caller to call
> handle_abnormal_pfn() right after kvm_faultin_pfn(). This reduces all of
> the page fault paths by eliminating duplicate code.
>
> Opportunistically tweak the comment about handling gfn > host.MAXPHYADDR
> to reflect that the effect of returning RET_PF_EMULATE at that point is
> to avoid creating an MMIO SPTE for such GFNs.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 55 +++++++++++++++++-----------------
>  arch/x86/kvm/mmu/paging_tmpl.h |  4 ---
>  2 files changed, 27 insertions(+), 32 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
[...]
> @@ -4181,6 +4185,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>         if (unlikely(is_error_pfn(fault->pfn)))
>                 return kvm_handle_error_pfn(fault);
>
> +       if (unlikely(!fault->slot))
> +               return kvm_handle_noslot_fault(vcpu, fault, ACC_ALL);

This is broken. This needs to be pte_access for the shadow paging
case, not ACC_ALL. I remember now I had that in an earlier version but
it got lost at some point when I was rebasing locally.
