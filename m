Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9F776D798
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 21:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbjHBTRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 15:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjHBTRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 15:17:32 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78238272A
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 12:17:31 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5646868b9e7so78000a12.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 12:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691003851; x=1691608651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QFQrDXTAMuafzDtjb6zl5uKzX5d+Hu9fb3g0beFwcNw=;
        b=ugtMfBZpD3UAICwxvlNDHU8TPfkoI4yIruIWHSq1gRfMe+O11zX1OQK6SqQirdteEG
         Bu7GMnXL/hmBQnf07OfUZ8veEJp9zDMt59Qh2tj4V1+0W11Mh7ex59iPFMg3ljkdB2xI
         TfFGwHWFGe1cAq66YFGDHF9qruqO68NmRqCtb9GwfcsR3VT4JYzNS6KwixQgNxio4xba
         bXhVHfFQ6KhFEvB7dTXv8/i8EhjHGo5U9j483V3vv8PllFAl3J8sIhCFKMs6XJgSwD6t
         Qg9K+s2Zzw2UFm0U/AGybfr8GwuJqGQxRlUNIqHjq0mifsOTrBpCTYfRg07v33rWjYog
         4bEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691003851; x=1691608651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFQrDXTAMuafzDtjb6zl5uKzX5d+Hu9fb3g0beFwcNw=;
        b=Wf22rRgspS9gS9Alv8VMpYvt5yYwI0UF1W1o1vNgqYEhxAvNQ3QcVkjLsK494/9zre
         y2Yjo2Yaye2QrTj2JkQNTdDJzmpaS5NgHH/54wN8pvP4xGQdee1h7337DChJsZks66MV
         KSEvP0bXUBDbexaqRu9FKvXsVgFssopEMMQPG4fOQNHva8uZ6xt4+Ie1soSsQ7HReWbA
         hzGNFcGYcwr7HNHjFOu6115p81aBESlTva6YrcvPH4nSs6c2+xAc1bUaLYeSu5hjOWoH
         FDQfhyXMlOhjPc3A0XWYwKCe1r4S2DfulS+9EBoa7TwmMSWyc0RTfySpXlEINpieavc9
         sA6g==
X-Gm-Message-State: ABy/qLZSqr42zeVlp3YaoRVQTwtPXsCCzT329RcjRMXT8k4cP/BqlbwU
        o8GbSVQhdezbBHBwZPXQWpXcj1zSeA8=
X-Google-Smtp-Source: APBJJlHnWNSYJZB98/CIrIBWskz7TmKbZ9fk8pVeko5bW2INjVy6FsJF1K3o3r5qg8kpoeygDMSvkC1Pkhg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f990:b0:1b8:84d9:dea6 with SMTP id
 ky16-20020a170902f99000b001b884d9dea6mr77635plb.12.1691003850787; Wed, 02 Aug
 2023 12:17:30 -0700 (PDT)
Date:   Wed,  2 Aug 2023 12:17:26 -0700
In-Reply-To: <20230627042639.12636-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230627042639.12636-1-likexu@tencent.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169084279326.1259481.1489304678823959902.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Move the lockdep_assert of mmu_lock to
 inside clear_dirty_pt_masked()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jun 2023 12:26:39 +0800, Like Xu wrote:
> Move the lockdep_assert_held_write(&kvm->mmu_lock) from the only one caller
> kvm_tdp_mmu_clear_dirty_pt_masked() to inside clear_dirty_pt_masked().
> 
> This change makes it more obvious why it's safe for clear_dirty_pt_masked()
> to use the non-atomic (for non-volatile SPTEs) tdp_mmu_clear_spte_bits()
> helper. for_each_tdp_mmu_root() does its own lockdep, so the only "loss"
> in lockdep coverage is if the list is completely empty.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Move the lockdep_assert of mmu_lock to inside clear_dirty_pt_masked()
      https://github.com/kvm-x86/linux/commit/e19314998321

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
