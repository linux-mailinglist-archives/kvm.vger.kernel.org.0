Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60CC525832
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359423AbiELXXT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347549AbiELXXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:23:17 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000006CA82
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:23:15 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l9-20020a056830268900b006054381dd35so3798291otu.4
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdarBLYiMi2x7VgSAd/PCBnk6aZfFSV1j4amo34R1lo=;
        b=apzVBSTvVnFdVTUoPIDKPGqyCmAjRvkf6rI3Tktq7k7wvOuqA+G57qzpEtiK76kJmf
         LUfv77v/SDogQR8NwrwveKgXXJpK7D0bcaC5ELR0Er6I1I+oVXefpFegbV9MdH63NtrY
         d0AzRSpIqHI/VYzyuba4+NehsoFz6Q8QQGZLz4xBEBBgunNH75/CQBqk/gnedfzNSJmm
         wC6X3AtnEhrMqeMt4kQPSUJVdlZdwmzk5x0RZ/g1Nk4iVLMeEcA3mKSaAE0DiML+G0EG
         TBJ9BA1BCYReA9MHPJlqM4wSoQ2Nt072zGgOT7b/M8eqTe50EC8CB1bwLeI0NnEgLzcF
         eoIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdarBLYiMi2x7VgSAd/PCBnk6aZfFSV1j4amo34R1lo=;
        b=JnF/3+a3cVaizNazFZuwH611GVObkm3STF7Wmf8vQMTC+h5dADXmIe9x4FTI2E5x1T
         85Def7FkXKB0IJm0eORmMFE81ZJMHUIJmkku9plquqEmbRPcHTS9gbVIyOsqmt7Gu2NI
         WcBLET0ql9epFlq0cG6J1yatykLQj9RC141BwnLnxv60yyM3r9LgugXHIRoniMh89Yr0
         jjomc4WywFU60A7q3d77KEvb0gX8561a67tHsBRHP1idaOZJq2UUnbgQ3JExFpsN8hIZ
         NKRIu3tTnbf9qe9Od78t0KMxr9ObKMtZTDUouB0T6HXedKeEwDfhb8A4NVD2yzWy06hs
         2Vsw==
X-Gm-Message-State: AOAM533BC0h8wVhngGUFmQcAg+Ig+QRuvANxuqQIm/SAyZoWIiLBPjqi
        mVJPUmRRjPOtG7xg+q4BJZcC5q7caANdqsG+d8cWyA==
X-Google-Smtp-Source: ABdhPJxR83dsw2D24e4NsRpwGRgwD6lMR3f1zsIUpSEV4D3/p9QeXVVifJHVHC3rS+x5S68Pt26SfdlwVssdYLtQ/N8=
X-Received: by 2002:a05:6830:1c65:b0:606:3cc:862 with SMTP id
 s5-20020a0568301c6500b0060603cc0862mr875905otg.75.1652397795090; Thu, 12 May
 2022 16:23:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220512222716.4112548-1-seanjc@google.com> <20220512222716.4112548-3-seanjc@google.com>
In-Reply-To: <20220512222716.4112548-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 May 2022 16:23:04 -0700
Message-ID: <CALMp9eTRw+AsN5u73bDzOJ_Pzvh-tLFsg7Zzm0viB_EQcFrvnA@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Use explicit case-statements for MCx banks
 in {g,s}et_msr_mce()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
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

On Thu, May 12, 2022 at 3:27 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Use an explicit case statement to grab the full range of MCx bank MSRs
> in {g,s}et_msr_mce(), and manually check only the "end" (the number of
> banks configured by userspace may be less than the max).  The "default"
> trick works, but is a bit odd now, and will be quite odd if/when support
> for accessing MCx_CTL2 MSRs is added, which has near identical logic.
>
> Hoist "offset" to function scope so as to avoid curly braces for the case
> statement, and because MCx_CTL2 support will need the same variables.
>
> Opportunstically clean up the comment about allowing bit 10 to be cleared
> from bank 4.
>
> No functional change intended.
>
> Cc: Jue Wang <juew@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
Reviewed-by: Jim Mattson <jmattson@google.com>
