Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05BC7B99A6
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244423AbjJEBb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244416AbjJEBb0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:31:26 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D170AF4
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:31:21 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27756e0e4d8so371167a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469481; x=1697074281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ySZUX6HjFXVIgBeY/TF6xiv1MhwePG0PWurucl5P4Po=;
        b=xY1Tffy5tmIpZyU0Lp5306ZMbgzEnf7hpF5eyzjP087WH7bRebXO8CtJWDHYzo79Hg
         uJnWN79nhGg7JSu0UZq+uLyFWkXKpEIONYWGxw5ch4v7N4GC1q2yUETsyp6+HHlSGInv
         7aFDBp11du2uDTHCz7PCQvC5zDcA7lza0lQGgLFLdwFTb05ibjAJNW4GYRIoNzE5OvCs
         kBtht94V9RnlP1W1tBa7hfQUNlC00iUpYlOcsjKE0AjbzESDZBlCt2540XmSFq/Fwkgj
         ONGNZWuDuKnvcKuESXUJ6co57Bttqv84r0t2AJmmiNn1zq+/MlZ5s9sfoT1dHRCifbes
         F+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469481; x=1697074281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySZUX6HjFXVIgBeY/TF6xiv1MhwePG0PWurucl5P4Po=;
        b=oWfanlUm8S4fDDXhunr9y+0OY6IaC+LCltg9JQFt/vljE4N3ODqaAFzR2AfxdKszR3
         RxDNlGuUow0pERgFNdARgbyEMCjYMN5zf1IZL5FF+DxKud3zwLGyHDlyh8YSoFqd+TyJ
         HmvNGmjmp2Dszp3kfbCHvKl1x6FXngAz1reuo5z/LLSO8sdH5nrNqEYSggqGheycSdvk
         anFCiW45ldr2fB8Bx/aMBKu34Eou1vtdiPVYb802hO2lFEiJGWmU9u6C8b7zp5KwCjci
         Sf6ZDc8Z0dKkvlQYZlNeI7LPfbkBLFzm265MCmqO+ZEmv+wzoG4bs9kQBftFOpWeAhIx
         TVjg==
X-Gm-Message-State: AOJu0YxOb+yQOZ2suzGXswCqQCiyKkTNWTOsno9BdIlTxsE76euGm9zN
        FCB3eQYSrFnAFaNYGqvQpwrb4S5Zi4g=
X-Google-Smtp-Source: AGHT+IFUnWTOmDI7bC2bvyy+SlOdFYpaQHnKi0sLYKU22erGcIh9L71d/ygzL+pi58n9BiX/NzbK/4NOTaw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:af90:b0:26b:5182:d042 with SMTP id
 w16-20020a17090aaf9000b0026b5182d042mr64813pjq.2.1696469481343; Wed, 04 Oct
 2023 18:31:21 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:29:33 -0700
In-Reply-To: <20230825013621.2845700-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825013621.2845700-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169645804510.2820791.2556170665167933788.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: SVM: Fix unexpected #UD on INT3 in SEV guests
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Aug 2023 18:36:17 -0700, Sean Christopherson wrote:
> Fix a bug where KVM injects a bogus #UD for SEV guests when trying to skip
> an INT3 as part of re-injecting the associated #BP that got kinda sorta
> intercepted due to a #NPF occuring while vectoring/delivering the #BP.
> 
> Patch 1 is the main fix.  It's a little ugly, but suitable for backporting.
> 
> Patch 2 is a tangentially related cleanup to make NRIPS a requirement for
> enabling SEV, e.g. so that we don't ever get "bug" reports of SEV guests
> not working when NRIPS is disabled.
> 
> [...]

Applied 3-4 to kvm-x86 svm (1-2 went into v6.6).

[3/4] KVM: x86: Refactor can_emulate_instruction() return to be more expressive
      https://github.com/kvm-x86/linux/commit/aeb904f6b9f1
[4/4] KVM: SVM: Treat all "skip" emulation for SEV guests as outright failures
      https://github.com/kvm-x86/linux/commit/006829954096

--
https://github.com/kvm-x86/linux/tree/next
