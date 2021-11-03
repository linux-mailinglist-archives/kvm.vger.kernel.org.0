Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B318644497E
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 21:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhKCU0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 16:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhKCU0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 16:26:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB54C061714
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 13:23:39 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j2so7573315lfg.3
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 13:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxN7xgD0iXSw13F0ipDNCDWnNNmNAyOzVQih9uftgyE=;
        b=E4J25Q2pudhON45fR3Ntmj+rxfJTuheLQ9A0zpV/g9nLr4j2b5wNMamPgojdn2BlUZ
         vn5Oricpphfe/mHsqdm0R8rD1KtLxcg5ljzSlWEmdAHZjL6S/WIwxBDt+Zh5ohNww0d0
         P/x9uD4qi7IZm97z8FLJdyLye347iZ0mahDxooBOd3kvw8os1OazifhAlDY37HY7WTRz
         dZlUiDeDIpz2Qoi1yamy1CFxN9pPnJaifXY/nTbU+h9f1iFcJpOQRjKuFA5Z/IMc4dvi
         VhPLMV7gmJUTTcR0mG4BeeWIjRj7I7l3b50Ugbi6H6+gFVxIdF3QREgeoIWhsNdzP6HM
         k7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxN7xgD0iXSw13F0ipDNCDWnNNmNAyOzVQih9uftgyE=;
        b=EJpvm0lyJ1aWLJMlhUJr4jniLNmN5DW3L/fv898WyYXiYJeJaaRBxdMLAXsbtPxoKG
         6dZRHp54VmAFkK16CjtoUosQGqIueBqgT7CvcjNHwtdDbMOPJ6U00HDcsIdEQIjByjFr
         i1V5VL505cuLE9G2tzzfD/Wxpja5rdq7bkrrwmHamH0u/u09k9Hjsl6E/ImcFwB5SdmJ
         iLI5rnNogUf4kk4HJr1rlJWCYuPeHy0z2PFzopMlHbuZK5fGue6h/i4oJXoH7iPUGbbo
         kOzc7xPWaO3npfXqeburGK6VPNmtUM7YY1OGImqj87tolv+erRdI90IgTIDQF603krbc
         g4Eg==
X-Gm-Message-State: AOAM5334hhqssIKo/SJdqr5VgHwgxteN8yrHdIs3HQgQwuYEBk0bnMl7
        jgs9RvlDKKnMPC03qi3+YMI+dj9nT/zmLTqN67Prqg==
X-Google-Smtp-Source: ABdhPJxbCGrrn1mL2csyohdl4SutP0n6yFXUsYy1lJDoQWH0TqVRaru+bSnlVhGUZ647VrzZrYCT1sbGrvvzZuYEUBM=
X-Received: by 2002:a19:c211:: with SMTP id l17mr5051426lfc.627.1635971017862;
 Wed, 03 Nov 2021 13:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211103183232.1213761-1-vipinsh@google.com> <20211103183232.1213761-3-vipinsh@google.com>
 <YYLqRRfaiXrWo7Yz@google.com>
In-Reply-To: <YYLqRRfaiXrWo7Yz@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Wed, 3 Nov 2021 13:23:01 -0700
Message-ID: <CAHVum0dzN0cBzkS1ruWNQhJ+wSkfJO3uqFoNjzi67hiMzF2wwQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] KVM: Move INVPCID type check from vmx and svm to
 the common kvm_handle_invpcid()
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, dmatlack@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 3, 2021 at 1:00 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 03, 2021, Vipin Sharma wrote:
> > This check will be done in switch statement of kvm_handle_invpcid(),
>
> Please make the changelog a stand on its own, i.e. don't rely on the shortlog
> for context.
>
> > used by both VMX and SVM. It also removes (type > 3) check.
>
> Use imperative mood, i.e. state what you're doing as a "command", don't refer to
> the patch from a third-person point of view.
>
> The changelog also needs to call out that, unlike INVVPID and INVEPT, INVPCID is
> not explicitly documented as checking the "type" before reading the operand from
> memory.  I.e. there's a subtle, undocumented functional change in this patch.
>
> Something like:
>
>   Handle #GP on INVCPID due to an invalid type in the common switch statement
>   instead of relying on callers to manually verify the type is valid.  Unlike
>   INVVPID and INVPET, INVPCID is not explicitly documented as checking the type
>   before reading the operand from memory, so deferring the type validity check
>   until after that point is architecturally allowed.
>

Thanks. I will update it and send out v3.

> For the code:
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
