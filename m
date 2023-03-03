Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2201F6A9095
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 06:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCCFyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 00:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCCFyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 00:54:13 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAF11A666
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 21:54:12 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id i6so983158ybu.8
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 21:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677822851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i3He+bv3rDW0V3ny41kX0Dr7IEw0N5ROaGJRmfThagk=;
        b=pkAcftF0deNqcuhVJl/YwMCK8cZxYxhDgztZRQ63faIhw1olHdb6jroHQFPQL8tuaG
         LSWYDVFIq+4524BJdOAk+FsJghqzuxGSF/cK/3It0uJ+fHKlBE92LW5bEV8iBQImNxBQ
         w94oK4JbJr0kaTDUr43tcfokMLxcNIwQ/9w1JS75ZQvq/Sy9fGFtVcf6jzJYQT72OZE2
         I6j6fUxtpQtFySRfCpHer/6Rqzn5CYGCTl9vb13w3zqIF8A7A1m1rTydS+R4QWxhmdbm
         afVDfCSjkceYnYCfrp+3U+y7fOOpVLL9zoQTLX8PgGlpZMOyVOso1Jk8lkokxKw8dHwJ
         //jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677822851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3He+bv3rDW0V3ny41kX0Dr7IEw0N5ROaGJRmfThagk=;
        b=TapDupId8V5xheClplDIsKEfka1vBRgg/rCFtec5wHxIr+jtN7tvrIZAoOXCa/oZsZ
         rxz6CQ4tekimPWeyBt6PFRAwVupsioOPtoKfTmt/WsK8+8IwrhMqYL/1D160Aq+00Xmc
         WLNYu+MvIgtNHXamxhZQlH0CSiN3TU3ncm/2CJ8kqvd/8di+luar/czq6BnOsCDVe4T7
         MCjzokBSy7bSk4kMJ0/YocXUL2mMbgsVjTtrwYUNe/I7y+mRF94Zu3k+1stLzaVvpTYv
         fBokD+pZyFU8ikk7SxXBGI0exzY+v+4XvZxsybSXBlzZSdbRIsM/cPub9r4eBN4GWJsM
         27/g==
X-Gm-Message-State: AO0yUKW0bQAnGymeww0qdJKUxkfLyClnFWotSHd2ZGwRZE4NQ0cH57qG
        lxI88fk3QbkPKS/oO7f7aSzCrLmzTvNkhVrIpAB52g==
X-Google-Smtp-Source: AK7set/mXvJo2LRKEA1VZbdhiu7bdLsHIuFQ2iyJAYVS7KdwVWMwLUeyxkyg+UgWelh+593OLpYA0fPrfVFTZnchV+A=
X-Received: by 2002:a05:6902:524:b0:9f2:a18c:90ed with SMTP id
 y4-20020a056902052400b009f2a18c90edmr239306ybs.10.1677822851166; Thu, 02 Mar
 2023 21:54:11 -0800 (PST)
MIME-Version: 1.0
References: <20230301133841.18007-1-wei.w.wang@intel.com> <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <ZAAsIBUuIIO1prZT@google.com> <DS0PR11MB6373DAA05CEF9AB8A83A6499DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CAL715WLo90-JkJe6=GfX755t1jvaW-kqD_w++hv3Ed53fhLC3w@mail.gmail.com> <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB63735E9AC8F4636AF27DAA4ADCB39@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 2 Mar 2023 21:53:35 -0800
Message-ID: <CAL715WJsV3tPkMDK0exgHeuKOP9kJtc62Ra0jnRhT1Gd6AiEWg@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     David Matlack <dmatlack@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Mar 2, 2023 at 5:50=E2=80=AFPM Wang, Wei W <wei.w.wang@intel.com> w=
rote:
>
> On Friday, March 3, 2023 2:12 AM, Mingwei Zhang wrote:
> > > On Thursday, March 2, 2023 12:55 PM, Mingwei Zhang wrote:
> > > > I don't get it. Why bothering the type if we just do this?
> > > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index 4f26b244f6d0..10455253c6ea 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -848,7 +848,7 @@ static inline void kvm_vm_bugged(struct kvm
> > > > *kvm)
> > > >
> > > >  #define KVM_BUG(cond, kvm, fmt...)                           \
> > > >  ({                                                           \
> > > > -     int __ret =3D (cond);                                     \
> > > > +     int __ret =3D !!(cond);                                   \
> > >
> > > This is essentially "bool __ret". No biggie to change it this way.
> >
> > !! will return an int, not a boolean, but it is used as a boolean.
>
> What's the point of defining it as an int when actually being used as a B=
oolean?
> Original returning of an 'int' is a bug in this sense. Either returning a=
 Boolean or
> the same type (length) as cond is good way to me.

What's the point of using an integer? I think we need to ask the
original author. But I think one of the reasons might be convenience
as the return value. I am not sure if we can return a boolean in the
function. But it should be fine here since it is a macro.

Anyway, returning an 'int' is not a bug. The bug is the casting from
'cond' to the integer that may lose information and this is what you
have captured.
>
> > This is consistent with the original code which _is_ returning an integ=
er.
> >
> > > But I'm inclined to retain the original intention to have the macro
> > > return the value that was passed in:
> > > typeof(cond) __ret =3D (cond);
> >
> > hmm, I think it is appropriate to retain the original type of 'cond'
> > especially since it may also involve other arithmetic operations. But I=
 doubt it
> > will be very useful. For instance, who is going to write this code?
> >
>
> Maybe there is, maybe not. But it doesn=E2=80=99t hurt anything to leave =
the
> flexibility there using typeof(cond). As said, I'm also fine to use 'bool=
 ret',
> but probably not 'int' for no good reason.

Right, maybe or maybe not. But using typeof(cond) for the variable
does not always provide benefits. For instance if the 'cond' is
resolved as the 8-byte type like u64, we are wasting space at runtime.
We could have used a shorter type. In addition, throwing this to the
compiler creates complexity and sometimes bugs since the compiler
could have different behaviors.

So, I prefer not having typeof(cond) for KVM_BUG(). But if you have
strong opinions using typeof, go ahead.

Thanks.
-Mingwei
