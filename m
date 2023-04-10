Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A06A6DCE17
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 01:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDJXab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjDJXa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 19:30:29 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D648212F
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x189-20020a6386c6000000b004fc1c14c9daso2727882pgd.23
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 16:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681169425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SGBGzrRdSuqlJo6fw6TeMWWpr6+5GjYFLHA4nEngttc=;
        b=Ru65Pzc879+xETx5Zledk/P9a+1eK7uKI2wtoXqJHpHY3WyYXQNNE5shzRZyhki3Mf
         8YUyCYUGaA7gurpOfttr52Z24wD5ptZKcq9DAGihA3NyOpTqAaSQDQ9puozJOsK0yWaM
         RRUBIX3iLRuswYsvJ6xlNinwDh6au95ivzm5lTlQ91BVE6Bq9WMEZMS7ls+KSPdI8GzU
         rSpXSrPkgjPrRgViS0cF+vNCVZBcNOgbq4qDKfSZWfZPO98DOpXUSnysnbYPzOKJ4GjE
         8H0ZdEBvw/5vPiNXCaOJRiXsXf4jBHa5GJc2VtaJbFGd9VP+9C3ae71m/kAPGjzD6UEI
         2s+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681169425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SGBGzrRdSuqlJo6fw6TeMWWpr6+5GjYFLHA4nEngttc=;
        b=SOUgJeLWijegznBfdMikbCwraOVGs76/krDDTJMAO7OEKbNAS6b63ERVkY1aT1LEVf
         mH8ehQA0TbSK4K6mME74ieOMm3DHn0ljrtls8qPiALFelTQgUfEWrSesOh8MpBCSgkts
         3ANrPVDWro2rQOmTlqmHVqTuKTnt0DrF0ASWXyVSWxMfG7/ssA9px6m0a7qRyCFnwkWx
         jHiwPh6UkWL9D6VfE6C5+kqFi41r/nBdCem+VEAD0t4DDiz78IYBN1cFOrxszpkfl5+q
         rmGL3Pjx3TraVJpbn77rUeTZGZIeiIqBlNIFGRUoIh7lnS+mAGnzFeF1BW67PwOwk1sn
         3cTA==
X-Gm-Message-State: AAQBX9f98TT0xHOO+k+BNrZZ+YK025ScXOeHFtNvEI7c+Xnba4gQ3S33
        a7VnNwUhkRSoPmkkCq3FZlUBfnX9UGM=
X-Google-Smtp-Source: AKy350bBgqNyS0bBG2G1WviinT0otbiuq+k1Lb5mVAeeqmQ+fNTVlOnWvEF+zCcVRBRlmVlHYUv1u7oPNuI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cc01:b0:244:9909:6e60 with SMTP id
 b1-20020a17090acc0100b0024499096e60mr3334922pju.3.1681169424866; Mon, 10 Apr
 2023 16:30:24 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:30:17 -0700
In-Reply-To: <20230405002608.418442-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405002608.418442-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <168116555741.1037547.7553662106650689195.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Refresh CR0.WP prior to checking for
 emulated permission faults
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 04 Apr 2023 17:26:08 -0700, Sean Christopherson wrote:
> If CR0.WP may be guest-owned, i.e. TDP is enabled, refresh the MMU's
> snapshot of the guest's CR0.WP prior to checking for permission faults
> when emulating a guest memory access.  If the guest toggles only CR0.WP
> and triggers emulation of a supervisor write, e.g. when KVM is emulating
> UMIP, KVM may consume a stale CR0.WP, i.e. use stale protection bits
> metadata.
> 
> [...]

Applied to kvm-x86 misc, with a reworked changelog.

[1/1] KVM: x86/mmu: Refresh CR0.WP prior to checking for emulated permission faults
      https://github.com/kvm-x86/linux/commit/cf9f4c0eb169

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
