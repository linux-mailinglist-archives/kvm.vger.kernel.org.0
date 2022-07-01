Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2B5563770
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiGAQL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGAQLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:11:25 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094982253C
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:11:23 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1048b8a38bbso4069606fac.12
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=th/OZKsYSESx9TWxFTTi5dH44gpyPseNGCExyUZ8aDM=;
        b=LoOMWKLvTVcyZJc4X3JvlhF56XLwUnl+kOwd70ngWyYFDVoG1vb/R/9xqh+b5DwIxg
         u2uu0Ql+QCP39i1zC42qNL7t9oOGap2JtxyT6Df7YtDQDOGtivSQk10ndMFfFOWdCpBa
         X+hepZEAI6YvlOVNCpAougBgpeb1XnbCWcgaEINrajBiv1CVpmK76D5Hcvh7Zo4xv53I
         ky91MfSV2ugj3kPLCTC87wHfQfw2haNcLr53bKZgOrwmFHUEgrfCXSl05fCQAwkx4V3l
         XFuLuNxSeMB80/QVdFqE27kkL3g+VXHJ31XQlfHs3pCF2xkRFfFNGw2KeYyxAkZHwcuV
         xKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=th/OZKsYSESx9TWxFTTi5dH44gpyPseNGCExyUZ8aDM=;
        b=22EyMlODwHiZMURhtTYXrPx7clnmpK4XC7wkZJwfXwAsBIBnJBT+XSecbrkJHu76UJ
         mZCyOmNccdqCcJ1oJ6c1qDToPg+biUH/g09hQQ9JI4I2rw8ueg1IIVGiEGqril4ckSdK
         lNEm6CrezI0detUk66FAL/kDWtuoSo7LlAYC8TNOrsKAJ3fkbVhDZw/YE5LPYOwYAwMD
         +CBnRytKnbdTu7nYz3FUJ3qcWH2ym3aCkma+aV/MVsypbEfZcJ+rumn5O0l39C4np2Ck
         m+X9bzul3+rdc1c+MbIsy4NpwkteZgSRah+iZhzzX9nwhGwV0++qjSgwsizLM5FzPjwG
         Vo/Q==
X-Gm-Message-State: AJIora/qvauiJdYJzziCZsjl4tp53/t4ShpghLmuyxqx30D5DFTyt0iC
        cK5rcqP8MzpfpTaM4ZJyeGv2n3JWtYhCnaFck0jpLg==
X-Google-Smtp-Source: AGRyM1v1dypOfwQzuDbf/FEZzJjt9K7fM75kBXYp8UrdBkcNPky7TWEsADN9EJewLVvxwLiZlhT+oUa6bkBUcOUErfI=
X-Received: by 2002:a05:6870:d3c7:b0:104:9120:8555 with SMTP id
 l7-20020a056870d3c700b0010491208555mr8784189oag.181.1656691882207; Fri, 01
 Jul 2022 09:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-23-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-23-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Jul 2022 09:11:11 -0700
Message-ID: <CALMp9eRA0v6BK6KG81ZE_iLKF6VNXxemN=E4gAE4AM-V4gkdHQ@mail.gmail.com>
Subject: Re: [PATCH v2 22/28] KVM: VMX: Clear controls obsoleted by EPT at
 runtime, not setup
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Clear the CR3 and INVLPG interception controls at runtime based on
> whether or not EPT is being _used_, as opposed to clearing the bits at
> setup if EPT is _supported_ in hardware, and then restoring them when EPT
> is not used.  Not mucking with the base config will allow using the base
> config as the starting point for emulating the VMX capability MSRs.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Nit: These controls aren't "obsoleted" by EPT; they're just no longer required.

Reviewed-by: Jim Mattson <jmattson@google.com>
