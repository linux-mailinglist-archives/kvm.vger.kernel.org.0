Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5902F5BEC6D
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiITR5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiITR5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:57:06 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D0065569
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:57:03 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1279948d93dso5345002fac.10
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Uz6bgbm84CvAr0FDt/UdGvu+RG/G6TA3uHu9O3uLdXs=;
        b=k/UTHKoF2wDda/Jd6la/V64YDg+HXhjqlhO3RFrlFdXktBxRElzufYFRLZGEQFLGKk
         iagnusJW4BrcjMsLf69hfLcgbjHwYKVIPtToC4Gi4U1adzKHgTjG/v8jIVL6Dyw40hKd
         wgb9VMw8qqtM0h9pvOUvsRUB0FtTHVcVFFm6TMusH8ExFw90nrjeK38NlbOTJkMzSDf8
         onA/Cr/m/TWaN8V+fREEcDNGaIfS+TVUFsiUV7uWF7JL3H5OgwkUd56oD0rmn4x3nOdy
         mr/iQJrRU6BZ0E8H69i2+MajGxDNOnmYR2TY+lGYXI0QCnpy+oYiqFzIcvkvYCKPLeN2
         6hvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Uz6bgbm84CvAr0FDt/UdGvu+RG/G6TA3uHu9O3uLdXs=;
        b=gsGU+OQRzCeMIG18AOSqFagUWIDZNc3x+SlhV9KSxupqMc5jX7+LcteXVJ8UubWQp9
         sXFAvzdBYAHju9T9+1Ekdk3SobbOLWSXfrT6pJJIfbJQ2vuNu1iLZEm25g7RKyarVy4q
         QRj6oPvCppI+1bJDrpS09A2pIHpOmEMOv8sQSQE+YfObccs5p/+NKIx/7pmQq+EpuC0+
         4sexDaO0jVUlu0Q97SkhnwZGsaepRE9tqzOYFSwpOGmUeM768pD6ox1xWEzlg4dAhtK+
         TgGtOw5DtRMeCe4Un8Jkp5CRH3bGqf+h7W8HKhcnlqVk/nHFRq1cYfnGAtkzMTmB/oNe
         6mbw==
X-Gm-Message-State: ACrzQf3sSXhAOO5HoJUEaSGI72u/7/V0Xyus8jhr7fNtNtWQ+7pSdQ+V
        hfRHen2FQnHUuxcgmZKEwfDDreNXj/JzQ7lB9/YZYPosU10=
X-Google-Smtp-Source: AMsMyM4dgCKnzHsrxoHwfiszhVMOM/v8BIZ1eiz+RQ0Lkj4rkBOrnW+7Flh2zLpQliXxx/+kW6rFgGk+DI8LlUGNDIk=
X-Received: by 2002:a05:6870:5250:b0:127:4360:a00b with SMTP id
 o16-20020a056870525000b001274360a00bmr2782024oai.13.1663696622971; Tue, 20
 Sep 2022 10:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com> <20220920174603.302510-7-aaronlewis@google.com>
In-Reply-To: <20220920174603.302510-7-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 20 Sep 2022 10:56:52 -0700
Message-ID: <CALMp9eQg0Yjoe4_H2PUa6x-v8Rk9mHEDqHyPnaXkF+wwbHLvHw@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 10:46 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Test that masked events are not using invalid bits, and if they are,
> ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
> The only valid bits that can be used for masked events are set when
> using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one exception: If any
> of the high bits (11:8) of the event select are set when using Intel,
> the PMU event filter will fail.
>
> Also, because validation was not being done prior to the introduction
> of masked events, only expect validation to fail when masked events
> are used.  E.g. in the first test a filter event with all its bits set
> is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
