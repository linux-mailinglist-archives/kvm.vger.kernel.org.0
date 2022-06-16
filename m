Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185AD54EDFF
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 01:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379430AbiFPXrY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 19:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379414AbiFPXrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 19:47:23 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA0C62A34
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:47:22 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l24-20020a0568301d7800b0060c1ebc6438so2062018oti.9
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 16:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVOjLQOn5rkbAgX3DzxQefZU3LMVvDO0uAOuYUy012k=;
        b=gRaVg9vhHMOd8BGjWadlIl5LolvwUSryNLvSTz8NdyhcibeCOdxr8G0uotXuu+tIFh
         G3soZDLi2MaXJMauEKX4a1a6v0BV0OZ8QrASAjvQNwXaRLZR2rixmTT89vKA06nSXPsv
         MrahPpFgqm7Ld10+WNnTt2T3cqAjVPRIYa17HFVPege84vmMUF4/YPU9NQfniznxVCsC
         M1WYjtw7dVPOLsEl93YWju3GoVA7pzf4+ytD0LFUEYN3likKXyHT/F6a9wpr9zfGQrSx
         WNx3Ko+17Q8ENqLReMXuISYivdArSBrCZja+R11UL6ptk+TM4zgWyHqRwQ96oo66psz3
         PTSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVOjLQOn5rkbAgX3DzxQefZU3LMVvDO0uAOuYUy012k=;
        b=RfvTYjWpYi0e7nTRAOfclQ39BuYNq/6edglMSEQy6rWyagrtlELw2J6jA1iHGtJmVD
         GlbkkgUNI8hvV3At6lL+cCW+p2XB0h4DuyMiE204HMrGj1bUvAe6WTTFVMr/8CH5wA1b
         vxtgENgESQf8UEFEXiVYSAcRchRhP/jendSCOqQXPdvFwpNARuTIuLCXYpdkUqbXv050
         6mDjxKC0UlG6xP4vzErw96nsyxmolRM6llDOPiL0LY+8P9LuJiB3hct8mnLBE6JfgEPh
         26eLxHc87A64H+MieXAyijsONj0u5oREM6NHdgTWFkOGkNZQ00oz3PQrMk0Mo69x+bVi
         +jeQ==
X-Gm-Message-State: AJIora/zF17Cv486uSn6BuILUpu36Shh/XM4vXKrO0T7a2XFrUEyIefM
        JOxiF9P+zoUhUbfCSYukiUEQ/zJeX/gf/jja3cPLmg==
X-Google-Smtp-Source: AGRyM1um+KDnzmheXvWCEIBfT3FoDM4+vXqjZU94rgQkTHYmU4N3NNDH2X5gKH2fj+NiyPiZXNtxr7R1mXvzNzfPTUY=
X-Received: by 2002:a05:6830:18cb:b0:60c:2576:5578 with SMTP id
 v11-20020a05683018cb00b0060c25765578mr3075358ote.367.1655423241592; Thu, 16
 Jun 2022 16:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com> <20220614204730.3359543-2-seanjc@google.com>
In-Reply-To: <20220614204730.3359543-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 16 Jun 2022 16:47:10 -0700
Message-ID: <CALMp9eSg-9RpoTMzmFY3_0RzS3x=cQdsnC3PeQevtMtJ9735OQ@mail.gmail.com>
Subject: Re: [PATCH v2 01/21] KVM: nVMX: Unconditionally purge queued/injected
 events on nested "exit"
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

On Tue, Jun 14, 2022 at 1:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Drop pending exceptions and events queued for re-injection when leaving
> nested guest mode, even if the "exit" is due to VM-Fail, SMI, or forced
> by host userspace.  Failure to purge events could result in an event
> belonging to L2 being injected into L1.
>
> This _should_ never happen for VM-Fail as all events should be blocked by
> nested_run_pending, but it's possible if KVM, not the L1 hypervisor, is
> the source of VM-Fail when running vmcs02.
>
> SMI is a nop (barring unknown bugs) as recognition of SMI and thus entry
> to SMM is blocked by pending exceptions and re-injected events.
>
> Forced exit is definitely buggy, but has likely gone unnoticed because
> userspace probably follows the forced exit with KVM_SET_VCPU_EVENTS (or
> some other ioctl() that purges the queue).
>
> Fixes: 4f350c6dbcb9 ("kvm: nVMX: Handle deferred early VMLAUNCH/VMRESUME failure properly")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
