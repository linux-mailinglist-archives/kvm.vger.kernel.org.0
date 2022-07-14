Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8457421E
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 06:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbiGNEMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 00:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGNEMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 00:12:15 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14756275E6
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 21:12:14 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id s1so413879vsr.12
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 21:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEaLJX6S+5YvYcIkKQJtiP2svusPKIStGeqUFKW6f3U=;
        b=ZTbfM9Y+dMFvfF13OC4AR5kTUKBIDrUa+Le7sBHkaJuHsS+ZSMLef0DSuivVx1r/O7
         /AlaHQYPpIaVLLtVVUP41rSeb8jrDT6X0dFep8FB85XRucQPnd/uFMgqKmt5zPtCkrMg
         WTQkAsU4S1d3f5BK63arXG8fCFE0KEmW2tSc/TvZ+vezkDz8gfeay9Rur1aIMkWhbhx7
         d5936R86uO6gLko5s0VnXwBu1v3tr2GC4q8xMzpw+pv+8vxNIXAFTxHFTQLfpUW8Yl0r
         PNq3IzGt72jJdTcA1hIzOX7vSbSqU96qNpRehKAyG7phT7bN83XwbNLaJdPCzm0azUCb
         RreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEaLJX6S+5YvYcIkKQJtiP2svusPKIStGeqUFKW6f3U=;
        b=KeXqqsvMOTZF9zTUMwK0aJ4b7k3egDxMkSHb+XUWIVM1XQOYBzVREuMPAtWVB5pk6C
         mr6nJCbBVSJczHyvfNzixr64S+SLJufH0NjCzHHCMgSy/9Po9xg233d/vtQIQc6F4J73
         5XKsvb8cMCepK2JfjPBAhviujS00MtPih9tYSCdXnAk9Xd605f8uoPPrZNdlv+zL+FYL
         e9NWMtjrqwa1OqG8n7W5BZUlvux2KN6BDiJkQY2aqqenoS4+AHkGGBzyQ6aCsiTBycAS
         T6268FiuJbOlAv96lpPCWI+JU61kk6wdLRQtfPEreNeFrNLZvydlFkfSC5S0YwXiSxTc
         ZRaw==
X-Gm-Message-State: AJIora/lbdfwM7WHPKGlM32ZcLcd1IMHwbZ7JLJDTTJwOq42NmznJRBb
        tZCdaCUraSwwlRuihRn1pp0qUOwXMPusA+a+M3HfqQ==
X-Google-Smtp-Source: AGRyM1to9RnV8FNlt2WrIvg6MUdYykCobiFcxVrnd4PiT6rzfBKrQcqwcReszcf2lgnCX97QNGeFleY5Sgb+zj53VI8=
X-Received: by 2002:a67:b24c:0:b0:356:c997:1cf0 with SMTP id
 s12-20020a67b24c000000b00356c9971cf0mr2640501vsh.9.1657771933106; Wed, 13 Jul
 2022 21:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-13-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-13-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 13 Jul 2022 21:11:57 -0700
Message-ID: <CAAeT=Fx61zZ7Z8Jbm5iAJf6V1GO2HihUZRnO3fGvT8c7spaDzQ@mail.gmail.com>
Subject: Re: [PATCH 12/19] KVM: arm64: vgic-v3: Consolidate userspace access
 for MMIO registers
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
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

On Wed, Jul 6, 2022 at 10:05 AM Marc Zyngier <maz@kernel.org> wrote:
>
> For userspace accesses to GICv3 MMIO registers (and related data),
> vgic_v3_{get,set}_attr are littered with {get,put}_user() calls,
> making it hard to audit and reason about.
>
> Consolidate all userspace accesses in vgic_v3_attr_regs_access(),
> makeing the code far simpler to audit.

Nit: s/makeing/making/

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
