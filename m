Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEC072EFFB
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 01:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbjFMXXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 19:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbjFMXXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 19:23:05 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EB310E6
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:23:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6662fcaac6dso233783b3a.3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686698584; x=1689290584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4mHYuNOZPM4awWtUFolsVH73wcK2hhrkSjDqkm93D2U=;
        b=w5z8/hckDrE/zBqTRA0GP8hCpCK6Id3ZZNoZ/Gn1jK1WK2IePDi8OoUWIrnx8j+Cw0
         P/q7PYaEd26uMfrCvuueJ1buDOKT3552TG055Dbaj8KSmhYpEXX3yC418J67wqXPbLMd
         eIpJzlUIV6mP9lsX4ZTU/nGBIhbBSks/GrtEAQlci8XyfTYd58uM9ny18ctCdx3+7z1x
         uvBy0XWxt9R1OGqMHvbIKUdi8UyjdO8v96s2RxhNzC8efRLLH69YweznF42kJcyFt2J7
         A0wNqhisOy6WuANj0+yt6JYOxpnNMuTQ0zaUn1dzYCPrerj4ufiaHVhAp1/AnO3d8Gpe
         RYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686698584; x=1689290584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4mHYuNOZPM4awWtUFolsVH73wcK2hhrkSjDqkm93D2U=;
        b=N5MUmVY3uOmlAAwlA4auGiIsXSb2fw8E0VDtBqa540+yhM0XQ8X3iXwFI80imRHEA/
         ZZyAh8RvSYf2kLlPfFohHbhjL0Fy2dDhrQ6ZH5FUzLnV0e7eC5O9YE5olU7o+veDCCza
         /Y0//IzXvlvh5lSnCHXCRtrZ7YriHzKJBf7x8EzTnFel9/sIC63BYjTVxIvQY4fP6+kD
         xAXkUI6po2KW0g7+Oal3sT9ogZEtLSbxq8YNMzy4qcsGWv+aQVEmBIMlJah2O8pG18Ke
         5xCBpnL1Ps8Dkz0O0Ou5LhHrJUTtJ29HMCB4gtE0Wlln28qulkIGEjxa50al7zI3NKlG
         MnRg==
X-Gm-Message-State: AC+VfDwI7zFIvJGW0SP/MqZtHEIGsnm3CsbRr6Sg3JuVTvnVEwhRC2rH
        cFXWoMvv4s6aUb+Io9M/TeLxKt95G/k=
X-Google-Smtp-Source: ACHHUZ6naYffKwkOV99ms77BVBzDcXj7ZKzf8tw1fadoJ2MQsii/4waHnbjsBY5lUOy+vhAC0vBmxeInL5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:841:b0:643:7002:e402 with SMTP id
 q1-20020a056a00084100b006437002e402mr88600pfk.5.1686698584310; Tue, 13 Jun
 2023 16:23:04 -0700 (PDT)
Date:   Tue, 13 Jun 2023 16:22:52 -0700
In-Reply-To: <20230607004449.1421131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230607004449.1421131-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <168667323139.1927661.906756138841169877.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
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

On Tue, 06 Jun 2023 17:44:49 -0700, Sean Christopherson wrote:
> WARN and continue if misc_cg_set_capacity() fails, as the only scenario
> in which it can fail is if the specified resource is invalid, which should
> never happen when CONFIG_KVM_AMD_SEV=y.  Deliberately not bailing "fixes"
> a theoretical bug where KVM would leak the ASID bitmaps on failure, which
> again can't happen.
> 
> If the impossible should happen, the end result is effectively the same
> with respect to SEV and SEV-ES (they are unusable), while continuing on
> has the advantage of letting KVM load, i.e. userspace can still run
> non-SEV guests.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() fails
      https://github.com/kvm-x86/linux/commit/106ed2cad9f7

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
