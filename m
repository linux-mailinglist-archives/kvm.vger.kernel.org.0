Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC656375D
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiGAQGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiGAQGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:06:02 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450D722BE6
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:06:02 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id l9-20020a056830268900b006054381dd35so2173018otu.4
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tA1We13n/kM82sx0YkjNZewIMefOanocSsCM/govz+0=;
        b=HVBgkL2ltgMWKb+Ud9xDGdc/ePbGYT9TfJqKmZF2NnExOSDq9GD90EH0Ovmb7srZmJ
         ZpjLCVbLKK5qzBb0g2ihopTVCOZ+UsKiv8/PpIYNlynL41GScN9X1T/b9f0quwMCr1gr
         8u2pkT5+RDwXkqmGw4Em1grpppr/gQom1iZeBLc+muWCkh+upOL+ENLK2Q1z989Eixei
         BMn2SzHw6wqiVVSUbCYc5y/OG7CqvEptn8V9h0Ffe94UU3c8p6brvEuUpRrMod/7FtSP
         a/0WBXDjTMa/C9aBSPjfR6tm3r79QGTYc7SOmtr8gCbqD0rh+gYGujKTWCkBU6dhrYXn
         pUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tA1We13n/kM82sx0YkjNZewIMefOanocSsCM/govz+0=;
        b=C6/9q7C/9d+ZXXtmxcjHxPAPjhuMeNDnmjAasSaq2V9wImu5F1Cf/tBq7IXQ/pSzXx
         rYnTURdG55a0xl8lW39RD2OzJCrS9m2Rnv4eqwT0A18DqE0BWJpk7eHJCBXCKX7yBXHg
         r67eEMpkp0xlY1A4SRRvTf+ND33djTgzMtcQ3MqXjH7kbcUoSfnia8NDijWT2PEX3vwv
         RALkwqizzjJJbCRp3ZJLMIfx6u7Iv8I8iuWvxQMyBV3iZVf6Z2FkFsxCs6cs1VzTPLwK
         +Fi6xxeqscbK64qxAH0XaW6OvpOkNmdN6Z4XNISDZ/wKOWbq1ncgcXCK26+ZNTQSFM/s
         JP0Q==
X-Gm-Message-State: AJIora8uPX/PkzlkNTrd9cwb9qCw7tKG+DDQJWGPxciAFLT139eORPXC
        BhEa98HHzU+jiUOsB2j7s6kLTs9pDAZw6/z/ITToxg==
X-Google-Smtp-Source: AGRyM1vO9dokoKBnHxwFww77KA9btH7PjekLij6H512iD8tpl8+XaDfN/gT0wirOwEoKkiShKCKK4bdDBXGs2nNmuAk=
X-Received: by 2002:a05:6830:1d5b:b0:616:de98:2556 with SMTP id
 p27-20020a0568301d5b00b00616de982556mr7173527oth.367.1656691561453; Fri, 01
 Jul 2022 09:06:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-22-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-22-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Jul 2022 09:05:50 -0700
Message-ID: <CALMp9eRuYt0qjD-xkDZJYyu5zxUMTy5wVARzaGmP5nGtDZmqYg@mail.gmail.com>
Subject: Re: [PATCH v2 21/28] KVM: VMX: Add missing CPU based VM execution
 controls to vmcs_config
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
> As a preparation to reusing the result of setup_vmcs_config() in
> nested VMX MSR setup, add the CPU based VM execution controls which KVM
> doesn't use but supports for nVMX to KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL
> and filter them out in vmx_exec_control().
>
> No functional change intended.
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
