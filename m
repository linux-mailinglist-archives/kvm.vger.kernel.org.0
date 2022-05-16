Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF352959A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349378AbiEPX4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350577AbiEPX4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:56:10 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075DC1EAD0
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:56:07 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id t25so28496070lfg.7
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nkFg79ppLu0KAsHU9QQTviwky+keI6o4Hb3RH32jsEg=;
        b=Z1OihB3qvMNBzjMGT9ZUDLnld3pQ0QyM11yTntmrTrxcCJ2gUQWxjtZsJus6dvn2G+
         Z5f0kdOJeIHApqxaAcf0WD7yW8lHiJIdvrKtMQV1LK7YoRtExUxHvh+7jVGoIpx4hmCI
         YE87KRRFL+HeJ4R0UWb/HemJ9oivoKPWYfSRx1A7CnHjzTYPJEy1Hf6DdumnXlX8MT4I
         afJ7rMCMhdm7WGUvYQ1IFFU1qfJA19IMe2I+qSpf4P+XS/UjiXQdG0vAPZ/0Fin6GceG
         Q7ZbyDvotnOt2C6lqGM07L70ag9Utfs+n2xbrOuD+kwRjcQMU27dnBamsuUPlJPdAl8w
         DESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nkFg79ppLu0KAsHU9QQTviwky+keI6o4Hb3RH32jsEg=;
        b=yds6rLWjEp6sS3VFRypP1Fzl80XLTDX/ex02z1PjOCCs88Bq8lHPPsClMljPNgxgKW
         DNeErDdbD96soMwBAKQOhKxJWSWTezbN1Ccb3iIUK+qQN9TWppxaiijf9V5jHvnyTZt4
         84dQXqiTJ/IEzCPiYdawnh8iPxjQM34iATT1+4QlqOelOsZepSlQxXDP8clkBCx5MBNC
         978zOEKDpHl0KXSThPn/darxDFVjXrCIV3dJK/A1Tbigd7iXgClFxx5CzxKU0+2sSoHY
         qvOj8sPxnd3F8hKYieoYmTtJjnusEE0R3sqlspKb9CT/ftwfZ652Huk0QJNVj2DQUcxa
         xwog==
X-Gm-Message-State: AOAM533nen+vXzd04UXkIbP7T2Q2DkVlzeu4LDLOzjCk2ElJzUFXJKy2
        3lGyCVvbeX0FLRh5/fBjN9gxwi98S3djmo+Pbpki0g==
X-Google-Smtp-Source: ABdhPJzmTnLBmX4qt79x53sXCEJtEEX1VKElsiaozKir1uMpRaMazVQdgHpVa0h21MNIMv+oM18Lm+Zf2r0FESqxGuc=
X-Received: by 2002:a05:6512:3f26:b0:473:edee:7250 with SMTP id
 y38-20020a0565123f2600b00473edee7250mr14601201lfa.685.1652745365989; Mon, 16
 May 2022 16:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220415201542.1496582-1-oupton@google.com> <20220415201542.1496582-5-oupton@google.com>
 <YoLN8M9I0bAnO3Nu@google.com>
In-Reply-To: <YoLN8M9I0bAnO3Nu@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 16 May 2022 16:55:54 -0700
Message-ID: <CAOQ_Qsi=31PxbDj=kyfgyapvR-FQ8wzSVvruEo1O1fCcof7ESw@mail.gmail.com>
Subject: Re: [PATCH 4/5] KVM: Actually create debugfs in kvm_create_vm()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org
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

On Mon, May 16, 2022 at 3:19 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 15, 2022, Oliver Upton wrote:
> > @@ -1049,7 +1050,7 @@ int __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
> >       return 0;
> >  }
> >
> > -static struct kvm *kvm_create_vm(unsigned long type)
> > +static struct kvm *kvm_create_vm(unsigned long type, int fd)
>
> I don't love passing in @fd, because actually doing anything but printing the
> @fd in a string is doomed to fail.
>
> Rather than pass the raw fd, what about passing in just its name?

Urgh. Yeah, that's fine by me. I'll squash this and resend.

--
Thanks,
Oliver
