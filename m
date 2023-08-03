Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8FF76DBF5
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjHCAFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbjHCAF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:05:27 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48574359E
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:05:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583312344e7so2910397b3.1
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021104; x=1691625904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1B2Y9YdqEpoGLMzQwd2SRsqRVQF/VAEofv6jvEnU9GA=;
        b=gbvyVIM/NKrMVATt9jUOXSZ0A6hzmX1G0If61wECK9g+cG9W7gdb+D4f4KnFcgAemj
         b3RBWiel7mJoEHHMZHldIUOs+1zv23NN++kdiBcL9eDmHnz0UIrgNxKmgf1tlHknlwfJ
         3uLUrfp9wQ6yMKznbzhb6Ls/VNQSZozzqYo1UN9qCj+LKkT6eJSHg82/ZG+aEM/mGSKq
         RPT3vF0iaV/sBxYcHF0MeQf0NvCC4rX93Rqck2IOfeUNrkdNoq51WqY+Jec5xRFvHHq4
         y41/XAUehSEW6g+EGQ5OHHcckFKgbo3sGPgrZC/3eIVwAxEEN0ptc80b+05QB5tplEXh
         R97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021104; x=1691625904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1B2Y9YdqEpoGLMzQwd2SRsqRVQF/VAEofv6jvEnU9GA=;
        b=h7xvwvBf/aaSwah1Icq14LIU0l3mpGEuXx5GkGm4INtVm6ZTYQuPwSiHxzhEURB2y4
         Hkn9zjNSMUjT7KWkB02dB4iwNijxYQO7tHbNKtl+w95Lat8bCJh+UwtMgN50mh94Ptae
         UXh7BIW+01x53OAGd+WPYe2q7kWQBzEAvYzxcY+Hevu1wuOchkxbJfNzER40sK7gFw3L
         k8zJukWA5vDPcL76AAqq4vvqTEX1J4AJvs92JwUbSTZEhOhjfCi5vOn2iC0XTrQRDE5q
         iXAItXTgUxIupRI5M8o46nDj6SflkzdZdXvo9WY9RRNwJ3RRf9YqWwVh6wjZHcYtt8A/
         F2AA==
X-Gm-Message-State: ABy/qLYGcQaRsKu11dKcrDAqU/sYjYfY7o5qUNrgrUu3qbZWG3jfX5B3
        zX+IFbXL2cBSYs9Oj/4E+vNBRlXpW/k=
X-Google-Smtp-Source: APBJJlE9O92/NSvZcRnj0tlPXK5inQ3aOdiQY3JF+mkag1G5Qrgvq1JgTTpGdoUncj86UbtPlK8Mwz4uVic=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441d:0:b0:586:4eae:b942 with SMTP id
 r29-20020a81441d000000b005864eaeb942mr100335ywa.4.1691021104529; Wed, 02 Aug
 2023 17:05:04 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:04:59 -0700
In-Reply-To: <20230721223711.2334426-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721223711.2334426-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101966149.1829182.8699224723247011152.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jul 2023 15:37:11 -0700, Sean Christopherson wrote:
> Add an assertion in kvm_mmu_page_fault() to ensure the error code provided
> by hardware doesn't conflict with KVM's software-defined IMPLICIT_ACCESS
> flag.  In the unlikely scenario that future hardware starts using bit 48
> for a hardware-defined flag, preserving the bit could result in KVM
> incorrectly interpreting the unknown flag as KVM's IMPLICIT_ACCESS flag.
> 
> WARN so that any such conflict can be surfaced to KVM developers and
> resolved, but otherwise ignore the bit as KVM can't possibly rely on a
> flag it knows nothing about.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
      https://github.com/kvm-x86/linux/commit/3e90c27b4209

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
