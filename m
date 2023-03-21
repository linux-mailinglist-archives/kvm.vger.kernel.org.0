Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F9C6C268E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 01:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjCUAvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 20:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCUAvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 20:51:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE1C17143
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:51:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x4-20020a170902ec8400b001a1a5f6f272so6546431plg.1
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 17:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679359905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b/SMhSBZYB4QrO41/CqVDHVj5QCw+KIQVOvV8RHW7oQ=;
        b=QlzmdFo1nDpm+wIQODt3WZ/QoYJiX0f0RCxgNInszVHp6ThweNaHOrPIexS+mXTIlX
         Bc2bQXNn/PBS6/3MHpa/oJeTVvH7vOiuoWXotEgAzpRIForAVnQNDm+zNofe06qDcAWs
         6cbhuRztX85Td5BfBSdK71O464/4tBhWJSjV1M2mmsCVqJpYOTrsMK7DRhMU6SXtos79
         WmJcjmYtM1fvHz44QawEZsfnwT3e0MT5rk5ZaW00q5fNPNRcyqfkLVwDjBhKD+XpTB0H
         z/jGF6gx2OnHz+FwHYBMPLMqKgI+vsFbQPl+fMQmZ02W3iODT3khJnbsEXFQBkosRI0s
         cLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679359905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b/SMhSBZYB4QrO41/CqVDHVj5QCw+KIQVOvV8RHW7oQ=;
        b=hVx/mkUGCdN6V9tHwC8QZQnc9U8SNKkB15M1/iI2Lte+/qREdEg1XP3LmKbdXIlEJI
         8eBY3ipAhKPm8hZuelxCXfKTECQLbTF2NH3U3bRGPAXa9wrLQgW7RY7v2PBayBbLgUs6
         sd+8xWRRFG5sP+n3N9D5do068klL6iuYI6Fl8ieH93rKd0d/D6jjTvLFbImkmtHBOTsf
         tg23mlQ6tVZbQdcz6PMmbl/OpBuk/pc66m8VMikWw8O/12IaFi9a0ynf7+9mOyCEwQsU
         5rElew0X4SjWzWPMQqUvwsGSkUlxn/tjsvK3F05apGB2X4Oyg88kC+E1/JsPrVKhbr8L
         PT3Q==
X-Gm-Message-State: AO0yUKXooPuPjWBZJr+Xc0YsumO6/w2gTJ9T4QUbsLfO0is30LT00nAN
        8z3BY3BEUNXAhfg/QTVUYiEW5JpTTPY=
X-Google-Smtp-Source: AK7set8KtsLFLTwxOD4erVt1H/bOkxkh/tyZkv0yk6tDNjxc1lEz0yYY/2i35y3pTcA3sr60speiI/JMGX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d506:b0:19f:22b3:508d with SMTP id
 b6-20020a170902d50600b0019f22b3508dmr118964plg.11.1679359905121; Mon, 20 Mar
 2023 17:51:45 -0700 (PDT)
Date:   Mon, 20 Mar 2023 17:51:43 -0700
In-Reply-To: <20230211014626.3659152-5-vipinsh@google.com>
Mime-Version: 1.0
References: <20230211014626.3659152-1-vipinsh@google.com> <20230211014626.3659152-5-vipinsh@google.com>
Message-ID: <ZBj/n3g/c0iqQAUj@google.com>
Subject: Re: [Patch v3 4/7] KVM: x86/mmu: Optimize SPTE change for aging gfn range
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, bgardon@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023, Vipin Sharma wrote:
>  	} else {
> +		new_spte = mark_spte_for_access_track(iter->old_spte);
> +		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
> +							iter->old_spte, new_spte,
> +							iter->level);
>  		/*
>  		 * Capture the dirty status of the page, so that it doesn't get
>  		 * lost when the SPTE is marked for access tracking.
>  		 */
> -		if (is_writable_pte(new_spte))
> -			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
> -
> -		new_spte = mark_spte_for_access_track(new_spte);
> +		if (is_writable_pte(iter->old_spte))
> +			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));

Moving this block below kvm_tdp_mmu_write_spte() is an unrelated change.  Much to
my chagrin, I discovered that past me gave you this code.  I still think the change
is correct, but I dropped it for now, mostly because the legacy/shadow MMU has the
same pattern (marks the PFN dirty before setting the SPTE).

I think this might actually be a bug fix, e.g. if the XCHG races with a fast page
fault fix and drops the Writable bit, the CPU could insert writable entry into the
TLB without KVM invoking kvm_set_pfn_dirty().  But I'm not 100% confident that I'm
not missing something, and _if_ there's a bug then mmu_spte_age() needs the same
fix, so for now, I dropped it.
