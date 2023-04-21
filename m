Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB3A6EB409
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 23:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjDUV7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbjDUV7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 17:59:52 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6D2E7
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:59:51 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-63d30b08700so13979253b3a.1
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682114391; x=1684706391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7oTagfDyC4HgrO0yoWB0k9ddYdGP35eHRr7bp/RRLZQ=;
        b=kuk2qN7KI93CF2nAuIMxjNhIYpR9YBPe+0c48Da++d12zR2YUrx9tl3VwJBbi7Y2Xa
         Z6Z9AzRPjuUT/14nCQt/c4Q1qlao51HXmIeAnx0RXAlla8BaOrj7rbAAB4LOLlOdrZEW
         j1BJ0KjIXppfb66C4IZXyBo92KNrnzZ9IhT4SNTssPwxj4LKewGJQ7SoB5WpbQcY+l2N
         WlnVlhgQ9YixVyj+cXrnhjcxjORBi+uGTQ6p920VLgiLjcMepLc/NyQP5YIzHZUTwlLg
         dGEjbkglDyseZpQCcuAmxTfavM+je6lXWwP2GGtYnHK/VJ01RjYa+LR7tfEOBAxedlXY
         Bq4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682114391; x=1684706391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7oTagfDyC4HgrO0yoWB0k9ddYdGP35eHRr7bp/RRLZQ=;
        b=NLUhpGhzfArgUIVU096LwJXuneK6AJm15n+67DfJxscuT512Eb/1C6+09bZtRTlH5l
         tEPz7Ud7O9Z+JxGtqT3m9cWJ8ucQkZbko67L08lL1qnjdxwHEFnvismp/DXx9J84LzWC
         erVXpEl7bSmB3ZUk9/7qdyKj3XH3CN19xvZWhnG1lCtIj8V7fXEWrrjgwauaqukgAN1m
         RG41VXIuwxbrqKQTAQ6D7LW4mNpHSzKDjWulGNfIRmYPjG/c7msDsSrsE2rUpeEc7i9F
         CJzZZtIXwrcKwazYn8ZrMKrI+OhcSfLKyZz9eJQAxuuzK4Jd2vlJjQNadq0QxhwZ7Qup
         zkqA==
X-Gm-Message-State: AAQBX9d6OfCVzptYMRFk4LUqppfsirPDDBQKe4jhjQBM2LAx3zwkH5II
        kzSNspjVrf9d4SzKPXY3xWROSN0aVDw=
X-Google-Smtp-Source: AKy350ZWBJ+6BJF8kSX9aaeSfJUZ2nqm9EZyabC8ndAaFsftOZ0maRlaF/Wa7DWJA4mA+v/+jqSCioFm7yU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:843:0:b0:520:8b35:157d with SMTP id
 64-20020a630843000000b005208b35157dmr1507839pgi.4.1682114390748; Fri, 21 Apr
 2023 14:59:50 -0700 (PDT)
Date:   Fri, 21 Apr 2023 14:56:07 -0700
In-Reply-To: <20230421214946.2571580-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230421214946.2571580-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <168211415988.2572634.7887087798476715003.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are
 explicitly invalidated
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 14:49:46 -0700, Sean Christopherson wrote:
> Preserve TDP MMU roots until they are explicitly invalidated by gifting
> the TDP MMU itself a reference to a root when it is allocated.  Keeping a
> reference in the TDP MMU fixes a flaw where the TDP MMU exhibits terrible
> performance, and can potentially even soft-hang a vCPU, if a vCPU
> frequently unloads its roots, e.g. when KVM is emulating SMI+RSM.
> 
> When KVM emulates something that invalidates _all_ TLB entries, e.g. SMI
> and RSM, KVM unloads all of the vCPUs roots (KVM keeps a small per-vCPU
> cache of previous roots).  Unloading roots is a simple way to ensure KVM
> flushes and synchronizes all roots for the vCPU, as KVM flushes and syncs
> when allocating a "new" root (from the vCPU's perspective).
> 
> [...]

Replaced v1 with this version in kvm-x86 mmu.  I'll omit this from the initial
pull request for 6.4 and submit it separately later on, assuming syzbot doesn't
find more holes in my logic.

David (or anyone else), feel free to provide feedback/reviews, I'll squash
any trivial changes (tags, comment tweaks, etc.) as needed.  I immediately
pushed this to -next purely to get testing on the (hopefully) fixed version.

[1/1] KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
      https://github.com/kvm-x86/linux/commit/bf4166af027e

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
