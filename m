Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04E34ACB64
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 22:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbiBGVjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 16:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbiBGVjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 16:39:17 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0379C061355
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 13:39:16 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u7so20091210lji.2
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 13:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vj6d/kwNaVMSCvSwpd8SPBJUndIKEEtw3knv973Syso=;
        b=QLnMWcre93OaJiLYldJtRWqs2HqybqunwmgEVs9I1LEXcGSlxFfOOYSD8R+pgn8LzV
         V0gKqY0KcpXwQtfSgixPE9BEMFzu5WvYt0mYyrHYovLoKR5602RjdEDihU19rhcyd7C3
         AcdnkuZanaPMEKCB3W+uoqUiZGd6cky9h2g7u3eFAAPLXDsUPrBd83uAgO/hiQsTMEzp
         DhIqYvPNyAVtE+uAlCeqrA0CQO2vBKEhYX8lm9tfVQ82Gn2cqT+L7TRIsTMxLZw8iKcy
         lJ2uFxMn2WKp2IP26br3cl4XwvsUkltNyCI63Xw1ONA10o9bljxMTrIFehgf6XpxExd1
         KvKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vj6d/kwNaVMSCvSwpd8SPBJUndIKEEtw3knv973Syso=;
        b=zrNVJgYKGzxauxqA1KTS/ur1fZ5Qb6qLEI15mf0kMSNMjD7/IvbTe9GNIMtoPf5SiZ
         Du01ztCkDRF8OyO6F+jJrWOoyGfIsb2oCj7CO3MvsXKGlTKt/IoxTHMArxPbNSd1PI+z
         f7Q60x2psagRMLwM7LuaBM1UaLryqWrjXpq0B2SfAUFyfav4vDVVMEdEs7lk+l1/6pjW
         w+DnF+lN2scKFsIeeo4WsB3ukm+TQrD69xK3d6GUxe4MkqUkk8hP1ZJHUCoFme1EuQGo
         ssBNygOw4rVxLW0KCQubrXscjbB1MbQt+c0NDevIuPbazauOf+Fb7atWAmMGg3zMcKtj
         dpsw==
X-Gm-Message-State: AOAM5318OEbMERKYSeMjyUNh8DdMFDpNbbF0AH9tdToTjnsGSmlO/jeo
        rMcpUIBg6wrzwkCuxw2ZeLtb0lO1OUcK8iOxad/dyA==
X-Google-Smtp-Source: ABdhPJxpaN+DjDrQNevmZdtABjjWGyCfImugc0tOdbHZyCwxssDdoL1MLAkcOTkaKWhmMHuCPTTbz0JbyN05FdyYVSI=
X-Received: by 2002:a2e:a5cb:: with SMTP id n11mr845559ljp.361.1644269954862;
 Mon, 07 Feb 2022 13:39:14 -0800 (PST)
MIME-Version: 1.0
References: <20220204115718.14934-1-pbonzini@redhat.com> <20220204115718.14934-11-pbonzini@redhat.com>
 <Yf2hRltaM1Ezd6SM@google.com> <04e568ee-8e44-dabe-2cc3-94b9c95287e1@redhat.com>
In-Reply-To: <04e568ee-8e44-dabe-2cc3-94b9c95287e1@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 7 Feb 2022 13:38:48 -0800
Message-ID: <CALzav=eTgXJaVhrtT4SUNVvXW=WLQNHquvNNG2s6rh+_cGh+3w@mail.gmail.com>
Subject: Re: [PATCH 10/23] KVM: MMU: split cpu_role from mmu_role
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Sat, Feb 5, 2022 at 6:49 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/4/22 22:57, David Matlack wrote:
> >> +    vcpu->arch.root_mmu.cpu_role.base.level = 0;
> >> +    vcpu->arch.guest_mmu.cpu_role.base.level = 0;
> >> +    vcpu->arch.nested_mmu.cpu_role.base.level = 0;
> > Will cpu_role.base.level already be 0 if CR0.PG=0 && !tdp_enabled? i.e.
> > setting cpu_role.base.level to 0 might not have the desired effect.
> >
> > It might not matter in practice since the shadow_mmu_init_context() and
> > kvm_calc_mmu_role_common() check both the mmu_role and cpu_role, but does
> > make this reset code confusing.
> >
>
> Good point.  The (still unrealized) purpose of this series is to be able
> to check mmu_role only, so for now I'll just keep the valid bit in the
> ext part of the cpu_role.  The mmu_role's level however is never zero,
> so I can already use the level when I remove the ext part from the mmu_role.

Agreed.

>
> I'll remove the valid bit of the ext part only after the cpu_role check
> is removed, because then it can trivially go.

Ok sounds good.

>
> Paolo
>
