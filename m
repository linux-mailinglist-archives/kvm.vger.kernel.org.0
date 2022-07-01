Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631ED5629F4
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 05:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiGAD65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 23:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiGAD6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 23:58:37 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65626759A
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 20:58:34 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1048b8a38bbso1937729fac.12
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 20:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ruHWSICItOOOzz9oeqwcmH/daMECIiVWPxSJOAyV7js=;
        b=m1mnoAwq1Mz+7F2ZWGVsdA1mC1MDfoBSfFtK8gdwQdYt+PtKI0zGONjgJH4xfeq2f/
         UptHxw8wAd4Vhwb9Y7mN3lrlerVmPsGHbOD02tubdy1hGDotjlKA2JFeXWhdy1vbsYJO
         QA6a6uJA7Jr9W7WQnZzxoGYpvepJmRyBa8mknSNMoj3LAca6a3iJnQCc7ftmfRl4kj2H
         YL3GR56Uv8tLWzuRD9YT5aSUd2A8uW40U0J54M7qkUtiiv101iuXzFMG5sbI5/tQNCy1
         ZtgpGNfn7vPpGYHWdRPkG4FU2Owy5HDoyZcsj1xrjZTK9Of8k0k7SdnRUJ9aIn8sYRLT
         5uWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ruHWSICItOOOzz9oeqwcmH/daMECIiVWPxSJOAyV7js=;
        b=OdgC1EzN1q5wEqG71px4ohhU4u05bR7Zb9SMdMDkvg4toM3L/lJg57e+BbU5jUOuds
         61FezOxpF/pew/QEcsEUWqCI1P9ZjyyPE9u7sssJIDo6LPgcPJBOh3yHOvIFCczeBlL0
         8OyCeOXSv02QmZQeqnmnBUPNwhRACUnX3BCFuJ4WOz15biBV6vBye4MGLjKxQVfvFqWh
         awdIlRjxOBiOdXNYC2N0rkhZdsa0Gn6uXoxpxL82NEV23BOZJfeXCk0HsPq/VaLtrVvF
         lgJnPx9VpqhWJ8xVEFRHJWEMTeSULkNc8e8CXAd4bLegx8EJMZVpljec6/Pc3teCP/1k
         TbHQ==
X-Gm-Message-State: AJIora9Yh3GdSavFRrPp1OmZZ9NzgQrPjxUmxsmVeTqP+yA14P1JVLek
        WaSpueV4VqSVrQSO7WhjUart2Gmlb52g5mnAMznuSw==
X-Google-Smtp-Source: AGRyM1uQ3Y13RfTBcDzsIlfFEesyltOqgOwVG4aGRr8OgC9gDgN1NYQqWTvakGrr4DL3ssw5NY7gC+z4Lw9Q8r1uwSY=
X-Received: by 2002:a05:6870:c596:b0:101:6409:ae62 with SMTP id
 ba22-20020a056870c59600b001016409ae62mr8646289oab.112.1656647912312; Thu, 30
 Jun 2022 20:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-16-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-16-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jun 2022 20:58:21 -0700
Message-ID: <CALMp9eSTv8e5=vwXRouhLubx8k6q9sH4X8z0CgFsKTv54VFdSA@mail.gmail.com>
Subject: Re: [PATCH v2 15/28] KVM: VMX: Check CPU_BASED_{INTR,NMI}_WINDOW_EXITING
 in setup_vmcs_config()
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
> CPU_BASED_{INTR,NMI}_WINDOW_EXITING controls are toggled dynamically by
> vmx_enable_{irq,nmi}_window, handle_interrupt_window(), handle_nmi_window()
> but setup_vmcs_config() doesn't check their existence. Add the check and
> filter the controls out in vmx_exec_control().
>
> No (real) functional change intended as all existing CPUs supporting
> VMX are supposed to have these controls.

I'm pretty sure vIrtual NMIs and NMI-window exiting are not available
on Prescott or Yonah.

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
