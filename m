Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74F706C7B
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjEQPTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjEQPTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:19:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AB9DD
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 08:19:06 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-649750dccfcso916124b3a.2
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 08:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684336746; x=1686928746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibw8lSh1tnai3y0vE621F160MkaagtEOuPXd+9BFnvQ=;
        b=T+z7AE/LIhO/SXDNtl+2CawCfvArOJ890j4x+qJwdPl+hGOS5FhPpkVjgRYJkeNswF
         O4/IXe0xIJfU4gB12IPkjsJHP6POAutv57jYh7uopnygARUIVpIxOKlEfKZciRL/tSGJ
         jL8H0qSPvlvRlpfNbWngDw4pVPbZFtaCvoa/vycy+fcwe5ArghbI8PxCB4nxZu+60Uuv
         aAHpev0ptNX1yw4guFjpRi/LJFTLMcsAJvJ16CeOHuAlviO4WQqWOy+6roeG6stGlT30
         5CPvMm0dXWxAFktocTXfxwUKwpWOwsSQTzVWKFK02WeaAgjgwP87UF5YH8oYxN3nfIwL
         Zsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684336746; x=1686928746;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibw8lSh1tnai3y0vE621F160MkaagtEOuPXd+9BFnvQ=;
        b=jwi17wnb+tNJzOQXH/hm0pmByrG4yb52sxzESqnOF+DhLrL3g7HSa4/p9mqZymwkJB
         fxrVecumEanWPws1A03G480iALWribgV6ndxVxjTqDCBbhGy/FCehP6kCshpRobJmB78
         M3n1NJ1mEgEQg/JGk5xRPmRBaARNEf71Xs4ez3xLM6AlEb8rKaQYktOFEt5o0ru6NUFk
         +uaT76HoeLq4uwmEhdzNNuI09SECLCN8gzQN8AYWRkZdpW0iR1l0jQBAgFO0xeHz/yut
         NcdnC0MaFGh0WWZtHZxW+84IpLXn1t8nKtCazzUl5AtuNQeVBN4+6uMOcerJWixQ6Qrp
         c+hA==
X-Gm-Message-State: AC+VfDzXb1CNPITP4Eir5GTk84mKgkAhhVVVQJw8QIag/2yICXFuekws
        mbg46m/N/P+co9Smn5PA+WZXQ9QDKUs=
X-Google-Smtp-Source: ACHHUZ4U6vsCSlH2Q9u2uWi5jhvI6fzWB20aO8E1QyAYW0i+7s6KJafjRBGvRaX08JoLmZPA7y+0RFylntg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:138b:b0:643:7916:16f0 with SMTP id
 t11-20020a056a00138b00b00643791616f0mr24034pfg.2.1684336746471; Wed, 17 May
 2023 08:19:06 -0700 (PDT)
Date:   Wed, 17 May 2023 08:19:04 -0700
In-Reply-To: <20230516093007.15234-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230516093007.15234-1-yan.y.zhao@intel.com>
Message-ID: <ZGTwaP6peRcpl+GA@google.com>
Subject: Re: [PATCH] vfio/type1: check pfn valid before converting to struct page
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com
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

On Tue, May 16, 2023, Yan Zhao wrote:
> vfio_pin_page_external() can return a phys_pfn for vma with VM_PFNMAP,
> e.g. for MMIO PFNs.
> 
> It's necessary to check if it's a valid pfn before calling pfn_to_page().
> 
> Fixes: 34a255e67615 ("vfio: Replace phys_pfn with pages for vfio_pin_pages()")

Might be worth adding a blurb to call out that this is _not_ ABI breakage.  Prior
to the buggy commit, KVMGT manually checked that the pfn pinned by vfio_pin_pages()
was pfn_valid(), and s390's driver(s) either blindly expected struct page memory,
e.g. did

        ret = page_array_pin(&pa, vdev);
        if (ret < 0) {
                page_array_unpin_free(&pa, vdev);
                return ret;
        }

        l = n;
        for (i = 0; i < pa.pa_nr; i++) {
                struct page *page = pfn_to_page(pa.pa_pfn[i]);
                void *from = kmap_local_page(page);

or in the case of its crypto driver, apparently was all kinds of confused about
virtual vs. physical, i.e. likely couldn't have worked with anything but "normal"
memory anyways.

AFAICT, those are the only in-tree users of vfio_pin_pages().
