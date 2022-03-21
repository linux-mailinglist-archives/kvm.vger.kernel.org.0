Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0280A4E2FA7
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 19:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352006AbiCUSJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 14:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351998AbiCUSJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 14:09:47 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8D838BDF
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 11:08:20 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so12534559pjb.4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 11:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67U3Z2XcJlRBA5r6fKuHVpCEmGfkLy5vZyJ9ghD60yU=;
        b=TNT/gBllZiZ0tYMdVN2h6Nu1CfHmFRNsSVWVmgJWqeTocFJGIIb3xLUflmb2Xbhx9q
         MdCYvUZD5LDw5yukGlzFxb99EQ2GcdFYgCARWv7Gr3pEXX5U/g50pBVxVPt4ZhNr5a/x
         VjRv4M+nh6x3wJLti+SzX17OoJu+otOr8x0imo4nv1hUeFQFLvxbtR2BGsXICYiMY/mo
         jVNmkdGSHAZsv8nLSjjTsW33LViVjtzjXtQwj/z22oc/mKR3Vcy0kT925uiJpr1p/KUN
         7Ur/VXTjPYzzwM52Vq/bT5vSSWzJgai4h979kSvYjTeUU47hNNnekH1eV9HVlobSULM1
         lO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67U3Z2XcJlRBA5r6fKuHVpCEmGfkLy5vZyJ9ghD60yU=;
        b=A3mebpryjWqDMTu9Kc3T0AkqSWem5qCMGvsfk362hfGIRURCyP1jQF+tbm447AG7Lo
         HqNaA34NB2vD6PFIhs3I0uX87OaRRBTGf8c4pfLwBiGJGS6oQHy/NCKtDLuVJqaTIcCF
         Uc7k6Wlgv6ThUzYB2mjXq9F6+VmmhpLnRUDmPLHtc2JeZUbGNnuzy+ZTS01DjZLUtAHX
         AqVCkPNUEkSQX7bJH3Mfyi6q/q6tcCVBktIbVUKwgpHxi85OeEBZzuIZhf6fqFgRtDRx
         F7XEvX2mKjmSqPEpZo9HG8GL+0TGhnCvhN6nv0DetKOI8VbULRzC48wCNUCf3BICSp2L
         iAxQ==
X-Gm-Message-State: AOAM532t5XhC4syyM8hs3khV78mtV9XhrY3wXA7bc9rgkWHZ/l7rcqET
        21K1SmIGRZMrbUpbJ559UpdE5rwX8SSf/lyO05JR3Q==
X-Google-Smtp-Source: ABdhPJxdli37Q36UY14MXho3b/hG+Vqt/k/9g6vJskN9EhAP7yYNslsyHljpL+3GW0IP6iAmmXS2Blrig2Hpco3/F/I=
X-Received: by 2002:a17:90a:5407:b0:1bf:43ce:f11b with SMTP id
 z7-20020a17090a540700b001bf43cef11bmr367471pjh.31.1647886099922; Mon, 21 Mar
 2022 11:08:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220321150214.1895231-1-pgonda@google.com> <CAA03e5HEKPxfGZ57r=intg_ogTp_JPAio36QJXqviMZM_KmvEg@mail.gmail.com>
In-Reply-To: <CAA03e5HEKPxfGZ57r=intg_ogTp_JPAio36QJXqviMZM_KmvEg@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 21 Mar 2022 12:08:08 -0600
Message-ID: <CAMkAt6qbauEn1jGUYLQc6QURhCHLu7eDmzJhfHZZXN9FGbQOMA@mail.gmail.com>
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
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

> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 75fa6dd268f0..5f9d37dd3f6f 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
> >                 pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
> >                         reason_set, reason_code);
> >
> > -               ret = -EINVAL;
> > -               break;
> > +               vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> > +               vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> > +               vcpu->run->shutdown.ndata = 2;
> > +               vcpu->run->shutdown.data[0] = reason_set;
> > +               vcpu->run->shutdown.data[1] = reason_code;
> > +
> > +               return 0;
>
> Maybe I'm missing something, but don't we want to keep returning an error?
>
> rationale: Current behavior: return -EINVAL to userpsace, but
> userpsace cannot infer where the -EINVAL came from. After this patch:
> We should still return -EINVAL to userspace, but now userspace can
> parse this new info in the KVM run struct to properly terminate.
>

I removed the error return code here since an SEV guest may request a
termination due to no fault of the host at all. This is now inline
with any other shutdown requested by the guest. I don't have a strong
preference here but EINVAL doesn't seem correct in all cases, do
others have any thoughts on this?
