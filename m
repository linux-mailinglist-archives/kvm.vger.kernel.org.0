Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1B6DB32E
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbjDGSsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 14:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjDGSrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 14:47:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B4ECC12
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 11:47:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q11-20020a17090ad38b00b0023fbe01dc06so987192pju.8
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680893233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OTBDFB/hhhn8Mc04B/VoG7g6BDECxL7p1vlP64XFh9U=;
        b=ebGNqQbe+vjGyfjodFajYI3IgeE+bJopdZe//hJwmbq92W9sVefUKKV6fjXMeFstLP
         x6oqLo5Tb/5ebFfeGHM+CtFVs1PFMenyGf1xCplKu82YrrAF73nErU/ogj5msF1i+vVT
         jRGziCWmmGls8WKXFo9T4VhoqsCLPb866ViJSr/wt/uLccTDZL5RTgvFXlpt0MzVo5yL
         /WJKHxmIhaccZJfl4Sw4xhTs5yR+fVsEXRpgDkCO2OZIhio63gubTODn6TozoQapE7Py
         LmH0sMdt0j10cN0eGbVQkeh/uInp+Jcym3iaqxWdSwPoVcrSm27LdjvAXNs7otKRYAHI
         avBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680893233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTBDFB/hhhn8Mc04B/VoG7g6BDECxL7p1vlP64XFh9U=;
        b=6BQDrTPImJ+7uDZp8P1W1rXSG7ssZs3PJu++giJtCEn+ufTMBjI4gV9m8/Apk5fKCW
         AmTxsa7CQBmeCEeD3Ja7v3jwCHQg7lZvoHumH195Sh8g1rsV/UowZo3RDhrbDg50UU1P
         Ua8BhnEH5phd7CyqUT4+Vqlv5BKcNu5u0aXnMGxKt9U5nIrC2jdVELsWoXB6ntJ3H98W
         zjuW9tv/BLU2DEgGzxufPQH2TOrOGERZPy9wewe98leecN5MIN5IJRCaGrsIvfdU63Jy
         fKTvUJV6xfgKxYgGmq6dfyNxYVuZ4iVt6jPwtl3JOfWp+l7/FHRrlMCnkIIg7rbixFbo
         lgrw==
X-Gm-Message-State: AAQBX9cyFvpWMrpgizOVvFznvF+SrZc0EFwMJGTZEk3CGXFQWiPqetXB
        1nElsC6CJzyObP5ahUWB0Op7G1vBAKU=
X-Google-Smtp-Source: AKy350a8wiZBx8OUQZNQfX9dt3RH3KuUGbah+6HhwDvBG17Ry6RdRglqdJjx0WBO6DDYvsvMQhBfYnz4eqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf0b:b0:19f:3cc1:e3cc with SMTP id
 bi11-20020a170902bf0b00b0019f3cc1e3ccmr1157852plb.3.1680893233210; Fri, 07
 Apr 2023 11:47:13 -0700 (PDT)
Date:   Fri, 7 Apr 2023 11:47:11 -0700
In-Reply-To: <20230307141400.1486314-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com> <20230307141400.1486314-4-aaronlewis@google.com>
Message-ID: <ZDBlL/MZLAcYKpwN@google.com>
Subject: Re: [PATCH v3 3/5] KVM: selftests: Add helpers for PMC asserts
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        like.xu.linux@gmail.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Same issue on this one, it's not obvious that the helper is being added to a single
test.

On Tue, Mar 07, 2023, Aaron Lewis wrote:
> Add the helpers, ASSERT_PMC_COUNTING and ASSERT_PMC_NOT_COUNTING, to
> split out the asserts into one place.  This will make it easier to add
> additional asserts related to counting later on.
> 
> No functional changes intended.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 70 ++++++++++---------
>  1 file changed, 36 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index f33079fc552b..8277b8f49dca 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -250,14 +250,27 @@ static struct kvm_pmu_event_filter *remove_event(struct kvm_pmu_event_filter *f,
>  	return f;
>  }
>  
> +#define ASSERT_PMC_COUNTING(count)							\

Looking at the future patches, I think it makes sense to append INSTRUCTIONS to
the name to clarify what it's counting.  That's arguably slightly misleading for
counting branch instructions, but they are still instructions...
