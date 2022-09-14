Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5805B8EB8
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 20:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiINSPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 14:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiINSPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 14:15:42 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1B24F3AA
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:15:40 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1278a61bd57so43218943fac.7
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MLlFlKmS/nz7WBfYyyHNUtfrtu2wo8gHUeoYUQLHpcM=;
        b=Ry8aXQH3Q7RjXnWfWF3IdrjZjPrk/VAEHhPzzVkEfIPOGYgEuXdS6b12jSdgZLptSu
         kA92g+QNaywjJe3V2x8bn91RwWqeUp81fbKAeQ1onT5PfBtLTeuDc6d9HTYH1zAzrTYM
         WH2WSq6gtKksauaEpFM6YomGhuQuCODGn15Cd1XEg3tGCnCltIkSaXIFRSv7zXSX/G1o
         DP4ecoMbV/YdYcqp35Are7Fg6YWe8tuw8Dh7+IA14iNVXixnfbHp3AUAq18uYiks8SUY
         170aMtkPFMA3VGSFDy8Ws3IxCnIX+kt1CexoPagJMkn5g058fduh5uiwNgHPqivaVZfN
         RpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MLlFlKmS/nz7WBfYyyHNUtfrtu2wo8gHUeoYUQLHpcM=;
        b=3WcAbNO1aQadP8gzYyQIeS/w6uhxjBo9X03BJLzcRd5rxSwV6JWVqcw8l0JErEPJRy
         dsnSNT5NTfpc+13pHLzHf/xMhH4EyJjgl74ozNXee2N1lgepdHJALR8qzzRTDMaif29/
         bpO/mc+UUUqxrpH6BBgdg+VjzgzFagao0HPCUEN0LLIlJ0WjOA/Xp/q9q288erCJiNva
         xyRB1yp0ODF2XG7FHMvIdMa9jcHfoyp1cISTUz199a623n9fF2CH0iEisdWyqkDE4ktl
         elENUEdA2svIgQnxX2mvc/6QASdutmlGBPNNY+IikxJFakZEXz8j9+K8GG7oAVjpQDmx
         hPjA==
X-Gm-Message-State: ACgBeo0o51cmQCCIl5bszwn3Q787NipW3dHFp/ggGIoSlR9b5cYbFuch
        v1ny8LDSTCdhzQRr5AKWkqy1IjHRkh2G8miLiS1ncA==
X-Google-Smtp-Source: AA6agR7E1iIrwh/4f6/w2WAXTGIOa3cyIaCyMjr/6keBljAHIqwmON1x9rVJ4HV4Kdl9DUZTkNMcPgERCl+i7RIX5D0=
X-Received: by 2002:a05:6808:151f:b0:350:1b5e:2380 with SMTP id
 u31-20020a056808151f00b003501b5e2380mr1368072oiw.112.1663179339091; Wed, 14
 Sep 2022 11:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-2-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 11:15:28 -0700
Message-ID: <CALMp9eQoPvgffXkYG9_=8+b8KX_S3bh9ungVWfWYd6htTqQgKw@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> When checking if a pmu event the guest is attempting to program should
> be filtered, only consider the event select + unit mask in that
> decision. Use an architecture specific mask to mask out all other bits,
> including bits 35:32 on Intel.  Those bits are not part of the event
> select and should not be considered in that decision.
>
> Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
