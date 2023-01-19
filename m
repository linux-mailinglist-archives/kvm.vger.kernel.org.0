Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCFA6743FB
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjASVKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjASVJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:09:22 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA8878A9B
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:02:33 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id f22-20020a056a00239600b0058d956679f5so1437789pfc.5
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Dpw2lRY6TSyGHUr11CqfXUwVeFmseGe/ZU1DTIhGkU=;
        b=K4UinZmGAeqLFdj96rFrdenRxoMek4mGBVjSA3f0xRG3bs/baYb7G90RPKHyB7P0Uh
         mEQgRIwoCzWzdy7qfhK2UA+8Zlpspj2WuCGnHWD5rrhQu6Y00V+fpXIPwQewqeKwUbMw
         PAOLeZFtDa4CxjkX/3AoJVfVKdjPxsF/Rwjynjo4gI0NSpkFq6X801MYaZzht8lpt2j7
         OxhrFI3wnsg9pBHxz22HiI+ptiycnrmpfPfODhzV4FJdAKFYrUJXdgjTifPL7z3kZXRb
         JsqCkld2+CY8iK0z7IBpXmiM+7ZCx5Vpn15UgsRPOnC31RMRP0OksEmBwCFbFg5eimdQ
         XdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Dpw2lRY6TSyGHUr11CqfXUwVeFmseGe/ZU1DTIhGkU=;
        b=onvSQtukYONxXOkvvAn4HdLnBBU864AdF0uX5qO9yrUKyovi+Tsu6KqoA8B61AmWJy
         7lhkjwgMUEafaaIdB3fPVFW1rRfuXfRalQZIgvgKBdvvl36ihu+0KtpjODhO7r2DJWgu
         Iume9WQvJrOQo6G5gPv6c/cTJnueLBxbp3tHUHp29JyqhnMhqJO6W7DIk1SSLhfl+c/0
         cG2PKa9SJzk25rzSUX0uWfcyVLCqd3Mzhm829dMj1ICOQAhQRy0ND01TFWzEC/JX1V3E
         SMClcarn7sYcvplx3Z7hVPqIbZBZclOAvqwn9ZsIWr7AIbYIAX7kR2nFgjktQG9aItMd
         vFxA==
X-Gm-Message-State: AFqh2ko3X6ZbUT50nF3DdQqLVLRKckISDX7OYxUhxJRAx0e10tXREZ34
        3UlHUIcVy1lwRATt18s+puP1bK5Y+Ys=
X-Google-Smtp-Source: AMrXdXuDjljdH1xzIWj1p2t05SKI7Hr19KhrkQ5v+0JgijaFi9G/gVCl0Vkes+QdM7REoLUA0RexCxsU+VU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:22c5:b0:194:7772:21cc with SMTP id
 y5-20020a17090322c500b00194777221ccmr1059250plg.13.1674162153484; Thu, 19 Jan
 2023 13:02:33 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:01:24 +0000
In-Reply-To: <20221220170921.2499209-1-reijiw@google.com>
Mime-Version: 1.0
References: <20221220170921.2499209-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408836887.2364758.7773595877813958931.b4-ty@google.com>
Subject: Re: [PATCH 0/1] KVM: selftests: kvm_vm_elf_load() and elfhdr_get()
 should close fd
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     kvm@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Dec 2022 09:09:20 -0800, Reiji Watanabe wrote:
> kvm_vm_elf_load() and elfhdr_get() open one file each, but they
> never close the opened file descriptor.  Fix those two functions
> to close the file descriptor.
> 
> This patch is the same as the one included in the patch series [1],
> with minor updates to the commit log (including adding Reviewed-bys
> I got).
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: kvm_vm_elf_load() and elfhdr_get() should close fd
      https://github.com/kvm-x86/linux/commit/a6854fecd0b2

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
