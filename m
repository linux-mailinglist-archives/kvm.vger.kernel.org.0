Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36927A467A
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240935AbjIRJ6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 05:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241001AbjIRJ6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:58:42 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A24B3;
        Mon, 18 Sep 2023 02:58:36 -0700 (PDT)
Received: from [192.168.2.59] (109-252-153-31.dynamic.spd-mgts.ru [109.252.153.31])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 1279F6607181;
        Mon, 18 Sep 2023 10:58:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1695031115;
        bh=1RNaixjMXA54V+2/e4luR24uvJkM1LcXIR0eY3+Epv8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PXGmfVf/NVnH7ZhV99d4xVXJ2zHhS05iCl/sOAl7OfLwMIGhXCok/5smR1lTKJRxR
         FUTIaUvF+Yg06PS4GxXOd4B/z+RgDUnn1wumQfgKJUCQEx6DruNnLFAvTMT8zTCnPQ
         tiZwaNKOWGzJVmXf/dxsAqE9LYplPWpcouLnIDASr+G+EDVkyEOi2+Igj13qS+gzQu
         Wr32PJ41n/sboSnmUhnBCkVDp9Gczd/Ds2HBnLyC7Kr8c2plHT5ibgbnAHsLVSdoOU
         ZaMNowQbx1sw8sDZDoCbclA+wFMVjpLKGbEtuz9ztpkhz8zT5x5KfaIxmcR++3QDE0
         vbVJnZUJ6NAaQ==
Message-ID: <14db8c0b-77de-34ec-c847-d7360025a571@collabora.com>
Date:   Mon, 18 Sep 2023 12:58:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 6/6] KVM: x86/mmu: Handle non-refcounted pages
Content-Language: en-US
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230911021637.1941096-1-stevensd@google.com>
 <20230911021637.1941096-7-stevensd@google.com>
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <20230911021637.1941096-7-stevensd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/23 05:16, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Handle non-refcounted pages in __kvm_faultin_pfn. This allows the host
> to map memory into the guest that is backed by non-refcounted struct
> pages - for example, the tail pages of higher order non-compound pages
> allocated by the amdgpu driver via ttm_pool_alloc_page.
> 
> The bulk of this change is tracking the is_refcounted_page flag so that
> non-refcounted pages don't trigger page_count() == 0 warnings. This is
> done by storing the flag in an unused bit in the sptes. There are no
> bits available in PAE SPTEs, so non-refcounted pages can only be handled
> on TDP and x86-64.
> 
> Signed-off-by: David Stevens <stevensd@chromium.org>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 52 +++++++++++++++++++++++----------
>  arch/x86/kvm/mmu/mmu_internal.h |  1 +
>  arch/x86/kvm/mmu/paging_tmpl.h  |  8 +++--
>  arch/x86/kvm/mmu/spte.c         |  4 ++-
>  arch/x86/kvm/mmu/spte.h         | 12 +++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 22 ++++++++------
>  include/linux/kvm_host.h        |  3 ++
>  virt/kvm/kvm_main.c             |  6 ++--
>  8 files changed, 76 insertions(+), 32 deletions(-)

Could you please tell which kernel tree you used for the base of this
series? This patch #6 doesn't apply cleanly to stable/mainline/next/kvm

error: sha1 information is lacking or useless (arch/x86/kvm/mmu/mmu.c).
error: could not build fake ancestor

-- 
Best regards,
Dmitry

