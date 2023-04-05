Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCD6D8B54
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbjDFAAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 20:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbjDEX7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 19:59:54 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0148F72B5
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 16:59:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54476ef9caeso371391417b3.6
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 16:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680739187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jxf42gC6VhPGRjwvo8awTKl9BzUHx2xinZ2m33bgrQk=;
        b=nesyRQqqoTy+PoU/LaBv18i8BsnOkWBojTUXKokYIRHcE3ixI1nx0uhvjz5PSsjIDA
         jGdUeBsAm9PFNbne4pg4dCvRtJjPdLysgEkXZ9X6pLiY59z5QafiFNhna+en8DsZfHYd
         OO+YB8sK+eDu0AGQ8k5IcjtIf9VYKFHiB66d4CiMUrT6dfDFXdfGglc0VfUUI3g+okRG
         fDK51qdW27/OQY8zN46yLsyesPZXOtZXo72r9s8kYgpe0eBrL0OoRgtistmKIgEEsFO5
         mG7OYIT9rPLb8TuG+bo/RvnApHIPQQb8euJH2TLZdrLHn4g05HohhceB7LpXTKkyqhMp
         Ua5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jxf42gC6VhPGRjwvo8awTKl9BzUHx2xinZ2m33bgrQk=;
        b=rloF7GXcvueoGtE7Z5KpY3JkE6sslZG39TrMciM4KWXQwSu6SIFHdQEk9Tkf3pe9fr
         a/6DxoejF5HNCxAz9aydC9GG8eBcXgpBGPXCBl+7ReINz/oh2q7ya4flKiTvS82xIogu
         bheFQS/fCoYY6C57J2JMBN8loi4b4v3aojERC0vxJO1tTp4B2CD05eVrcoRFlwwRPyoU
         K2HVTZ+UFl5djbfARALIVjpvNajxPaDbt+D11ZfaWNbgkskDSiZre3mTAutPZN/q0RlD
         kyj5zoHPamIktxO1DZVmLMbQ/LWRPKLgHBajkbqkKhoeJDETAHeeXo11as9T7C9wWLNS
         B5Pw==
X-Gm-Message-State: AAQBX9dXItb0ojcNkDbN2R6TB+yhmIui3n4QGPO8NyvM5N3FCZR/tQVI
        zx419w1ToXZdTDF0MNoodjhCKEipy0E=
X-Google-Smtp-Source: AKy350b4cDoXYPsRlMRHohMLckVvU0YVhPrht4uYzWVfTzjIyCRe0ISsCa6DarqChome5te0mu4tegcx3UE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d753:0:b0:b71:f49f:8d22 with SMTP id
 o80-20020a25d753000000b00b71f49f8d22mr688483ybg.3.1680739186875; Wed, 05 Apr
 2023 16:59:46 -0700 (PDT)
Date:   Wed,  5 Apr 2023 16:59:32 -0700
In-Reply-To: <20230404071759.75376-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230404071759.75376-1-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <168073781051.657542.2486795284440545503.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time
 it's refreshed
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 04 Apr 2023 15:17:59 +0800, Like Xu wrote:
> The kvm_pmu_refresh() may be called repeatedly (e.g. configure guest
> CPUID repeatedly or update MSR_IA32_PERF_CAPABILITIES) and each
> call will use the last pmu->all_valid_pmc_idx value, with the residual
> bits introducing additional overhead later in the vPMU emulation.
> 
> 

Applied to kvm-x86 pmu, thanks!

[1/1] KVM: x86/pmu: Zero out pmu->all_valid_pmc_idx each time it's refreshed
      https://github.com/kvm-x86/linux/commit/7e768ce8278b

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
