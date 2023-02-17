Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82E269A4DA
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBQEYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBQEYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:24:47 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB42A42BFA
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:24:46 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id g8so4343509vso.3
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PJu4vps/ydzm+bD68RapcHOeOMmzQwBmAiW7NmBj0zU=;
        b=N9QazQscN5/bMrTwGxOfAtM8xQD0zg2C7V00UxsuXtYfAz5LVfV9yZkceaMx30llQS
         MbtMbGZSrDyQ8f+5wFmT5KPHG7yoVHYuRGjV/K+K1/YBzfts3DWsIWEL2wK13NHsBONL
         3WSw5YTZ0a5gR+5SW3CY0ht9ZWgZiEHmWxeYTUfbfTwp27jM0ayQIQmuMeH32n16zCMS
         LlHALD1+pwPBgt3KwWvli37N4+ulQIAdwqaKEMOyIYnaNF0PxJI5iNKryPEMJ1JxgseD
         cL+jVcKxymHBK7RZixjBM3EahjNXB2uD4wOmYf/cmuvuGiqT2+UiebhqO4obZD3C2vfh
         jyHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJu4vps/ydzm+bD68RapcHOeOMmzQwBmAiW7NmBj0zU=;
        b=krRIPWotF7p3dnXBhf/EhiEGhgWqSoWp0l9yE9inz5a9DABnPm2jWorBCNcguh7InA
         nKc7eml4n/nvYF1skoSiWFrKrkpxsKpKsEIhyyuNiu7Zhe6FXUvUaRoxyt1yxT94pzab
         S6MoeIJJ1xbHMlJTp5tOHftYZ8mqo0maYT+1PWCzBLLyqrIpZCtUbDD+oAG/vj9269CX
         lVPPYpaJMXf/A7dPLf84uwPMydO3Ze0qNDIy8E2p2sZkh3wr4RNPJC6+5tHzQ+eaOB8p
         oQOn9wR4yJF2ToLpo2eQEPGWhiZV+Bz20KxHA7U8be4AtJ/9g7Tr2IxAbNRNTvH+0mCl
         XKJw==
X-Gm-Message-State: AO0yUKUjtLaZQqYxhB158Wc8xMU31wfElG9iKc/cQf9e9P63GUpPoLMc
        Pbruuf1FjfjB19ZKAh+Wz91zcYG97y1YalSTm18eNg==
X-Google-Smtp-Source: AK7set+Yem2rWelUagYff1NdlU4Jg460e39X+mAJEfXHa9zcbTd/sITo7f0UTvcIS0NfZcWWeb2tTMWiIhTxmfPdL/A=
X-Received: by 2002:a67:cf47:0:b0:411:c1a0:c787 with SMTP id
 f7-20020a67cf47000000b00411c1a0c787mr1603908vsm.26.1676607885989; Thu, 16 Feb
 2023 20:24:45 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-5-yuzhao@google.com>
In-Reply-To: <20230217041230.2417228-5-yuzhao@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 16 Feb 2023 21:24:09 -0700
Message-ID: <CAOUHufbjbaBtNQX-uSOUQEDoH9nAE0nC7L+ssoPF3WHpQuiwuw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 4/5] kvm/powerpc: add kvm_arch_test_clear_young()
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
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

On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
>
> This patch adds kvm_arch_test_clear_young() for the vast majority of
> VMs that are not nested and run on hardware with Radix MMU enabled.
>
> It relies on two techniques, RCU and cmpxchg, to safely test and clear
> the accessed bit without taking the MMU lock. The former protects KVM
> page tables from being freed while the latter clears the accessed bit
> atomically against both the hardware and other software page table
> walkers.
>
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h    | 18 ++++++
>  arch/powerpc/include/asm/kvm_ppc.h     | 14 +----
>  arch/powerpc/kvm/book3s.c              |  7 +++
>  arch/powerpc/kvm/book3s.h              |  2 +
>  arch/powerpc/kvm/book3s_64_mmu_radix.c | 78 +++++++++++++++++++++++++-
>  arch/powerpc/kvm/book3s_hv.c           | 10 ++--
>  6 files changed, 110 insertions(+), 19 deletions(-)

Adding Michael, Nicholas and Christophe.

I'm not sure who I should add for this patch. Can you please add any
interested parties that I've missed?

Thank you.
