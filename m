Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E010966466D
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbjAJQo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbjAJQop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:44:45 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D618BF0A
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:44:45 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bq39so19436079lfb.0
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JZWhn3safCoj73gyJNv7llgnh8yjRd4wZSAzSjVs0Mc=;
        b=G4fKiY1GSJz4BMFlJGMIQ8IJ+V6RoKrvGgo4E7eINRfxVVyCEPPwtL4t+NFyZ3NVpP
         pXD/jlY42w6Qm6ugJmoy2rRP7WCDl41E+tSVXNpp6Y0gSzLWKlEJV7DQ3pyUACYT53Fh
         wfz4FW6Wxto2vZjVn3uPnQExGp3WC3v2LeiZ2eA2ODwZ6jRlAqxA9QMVNMuPxDy5Jmba
         zKtfFS64roWvRzntgLLsAP1Iwcx02Zn09Q3BnimXqPJUnGfTcGaBCf3OwGE2kg84UX/b
         dM6n7EO537qlLuMWCF1aAVwAXf8yLaGoB2uEwG8o3IRcnoyphfmT7JlH+X849IHhWt4s
         vx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JZWhn3safCoj73gyJNv7llgnh8yjRd4wZSAzSjVs0Mc=;
        b=tGMCTdqtQ4zvlieHzizXGMddKYeUaDS6p/U6f2dY+GD6yPOv4rAnndfHyanpufgOaB
         gERxMEwO+bZxnYt69VxUIjRPPpVuZD6llFQUl5/jtPuziuo8psD53EYf/juPF0RcMPgE
         jhyNsxZ9l673OIJCHniSSxE4nXTDTfIawsPmIWeWqcgYbmrBiwwJ3fqUjve6+Vvz7vc8
         yduowUlwWbFFaOLplgoDIyT0mtS7Lb6cHhnyxUa9sgpgtyXErK0Bz6unKojAjb9ffnv4
         Z2dB4CQz/l4GMU6+3dh+e9SFIiREtRKNBFDdcrLSeEFc81oNcM1ExNdRlhidnrGtBpFV
         HcIw==
X-Gm-Message-State: AFqh2kqjN8TQ+nyauBERskJeCokX5AEMkaWKj9kscKDmqgb6xxrAJ8jr
        bCp9cWt/8AE7TP3wbXpQRd8HT6CORQKv8LBqK59QDQ==
X-Google-Smtp-Source: AMrXdXuO8ynBGgR/6ByzWxbV/fiR4CZywZvZlQgstlQDIZEo5PTA14Lag8TeZ03lPEGpYiDGfJaV+xjoSsxgJ/T4y+8=
X-Received: by 2002:ac2:5e7c:0:b0:4c3:d803:4427 with SMTP id
 a28-20020ac25e7c000000b004c3d8034427mr2897698lfr.170.1673369083178; Tue, 10
 Jan 2023 08:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20230109160808.3618132-1-pgonda@google.com> <74745684-785e-71b2-288e-91fbcf1b555b@amd.com>
In-Reply-To: <74745684-785e-71b2-288e-91fbcf1b555b@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 10 Jan 2023 09:44:31 -0700
Message-ID: <CAMkAt6q_E-+VV=KOs9LbDzawirWR7M4xL2pCF9fR2kMuBuFM-A@mail.gmail.com>
Subject: Re: [PATCH] KVM: sev: Fix int overflow in send|recieve_update_data ioctls
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 273cba809328..9451de72f917 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1294,7 +1294,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >
> >       /* Check if we are crossing the page boundary */
> >       offset = params.guest_uaddr & (PAGE_SIZE - 1);
> > -     if ((params.guest_len + offset > PAGE_SIZE))
> > +     if (params.guest_len > PAGE_SIZE || (params.guest_len + offset > PAGE_SIZE))
>
> I see the original if statement had double parentheses, which looks
> strange. Should this if (and the one below) be:
>
>         if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)

Isn't the order of operations here: '+' and then '>'. So is the patch
correct and matches the old conditional? I am fine adding additional
() for clarity though.
