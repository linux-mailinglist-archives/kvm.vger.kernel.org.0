Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D82E725140
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbjFGAx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbjFGAxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:53:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6271B199A
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:53:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56938733c13so90009447b3.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686099233; x=1688691233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pD9JHpKa9k5ZTt3oQtanv15RS2ukb+oCEMW4HydPPPc=;
        b=4K4GdjQlGVzj7cMvF1aWAyUT1TBmSn3cSo54e+6hd/SRJFIYpbMwVydbVz8akfdd9o
         YSKbt31ky2uOnw8CCliU694KWa7dqgIXSBL2mIy40+paqzpk/0KvNvmkrf/d2xXNfjOA
         4gY9iEMRmQD2ObEmKsD3+7FnL+ubsVrsplXhzlRbVeA9m+fOLB9f9CK9kHdQoIHuEZ+t
         6E7+uOy4bvM4B+xKY5GT4QmBBia7duM7Sr8B6DbgnyR/+qP2nkJEgJbhHhgnvwbGLA/z
         jwiKKm73iQ5FEOjET211bijHaiFLQADbhvMdP5Ci5qk4pQU76wFpR0eApwP31iwMfd3o
         yLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686099233; x=1688691233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pD9JHpKa9k5ZTt3oQtanv15RS2ukb+oCEMW4HydPPPc=;
        b=MLUSjuSWhD31j7I6Zl8bv4dHySE4qQRIu5PtEePNTaiyBsjojP2z8K+bZClqjYjNp0
         7OhcKKHLj4JlbjLKzrwoFZFaSMjjNiOfUEam/S0kGSPQ1Dg8kozCBYE1j1n5DK60KFsu
         +wYLEU39yUBcQudGhzrFm9H4kMtIbv238N9iSobYwdkcU8W9S3n6hV4o/WT4gSTbHw7V
         Rc7+pst5zXW7UFBnDlIl+ZYNBpMp9eMcJmrD7lP9tbMBxMMZ2+5jcCpONP1m+qnOLL7b
         yq816bGhIjK5MeqqX7J6ZWhulvINYKcBadkF5c33lr9QMN9slyIfuzh1IxBtuJV0vgUF
         WACw==
X-Gm-Message-State: AC+VfDxjb4Sxa97MA9F2hwpxQZFDuwhpTVUmytVsjsfeNDu2U5dzjB6K
        UHP5pefweZdQojqFKG9xmSAgyTRAeEs=
X-Google-Smtp-Source: ACHHUZ4DFXG1xXJqUvdqCKKlCCwxV/qDcG6kNSxVlXhWXoWbCpJKlcsChumJb3kitTfzWf+4OHeMyk3Uxqk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:188c:b0:ba8:8d92:caea with SMTP id
 cj12-20020a056902188c00b00ba88d92caeamr1413698ybb.1.1686099233638; Tue, 06
 Jun 2023 17:53:53 -0700 (PDT)
Date:   Tue,  6 Jun 2023 17:53:42 -0700
In-Reply-To: <20230602010550.785722-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602010550.785722-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168608971339.1368390.3660632949496517559.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>
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

On Thu, 01 Jun 2023 18:05:50 -0700, Sean Christopherson wrote:
> Replace an #ifdef on CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS with a
> cpu_feature_enabled() check on X86_FEATURE_PKU.  The macro magic of
> DISABLED_MASK_BIT_SET() means that cpu_feature_enabled() provides the
> same end result (no code generated) when PKU is disabled by Kconfig.
> 
> No functional change intended.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Use cpu_feature_enabled() for PKU instead of #ifdef
      https://github.com/kvm-x86/linux/commit/056b9919a16a

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
