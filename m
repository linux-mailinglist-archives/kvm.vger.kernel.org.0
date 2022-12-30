Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF43B65989C
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 14:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiL3NSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 08:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiL3NSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 08:18:14 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8ABD1A23C
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 05:18:12 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id z12so17140786qtv.5
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 05:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mNKbJyWVmEQaBKNSqhwilGGI/lpzT6OeBLkHWXd9xzQ=;
        b=blObeyR8hkigKkNKFmBpe6p7JTzjTLkpLrtG55HhKKga4rwSs3vLaiQwqLXt8GUtvh
         kT7uGaoToyNYB3CulzYCYSsoQzZokwqgZgZnZ8jLEGKGbJYGYM5AyH3omXxX8C2SvWSi
         DE6zd78UKHLpAnbSYqm8OUflTK21HD1o/lPsg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNKbJyWVmEQaBKNSqhwilGGI/lpzT6OeBLkHWXd9xzQ=;
        b=fWyhGLOBMix2uapDKpU17+exgQ05gSVDbgU7xgXM9m0z4CnKxvVHiivAhcxp4PPjQE
         hpOE3sAZfHgWiNlrJBiaBynT/t9C0oKTaeKoUBqmGrHzOOn1NvK/A61qIs5I11CFmof9
         5ecs8HEk1Hn/lozcLKjHGSfNEWSDX5THEMJCDwLsiHkJ2oOf+6E6yQTDBfYeopq3wxZq
         rkKBzGcmsMG8RPux28SlP3QsSpsKALO/rJUFqvlCwDNhkP/fRYKZ84jjL5sIl2LRRLNu
         ykUGz/k+zZb0G4p38F7+ZOjdN8Q/SLBLKosVuqY2rlEGIcSuZvVzbUXaXsvNbC1JEPSm
         w55g==
X-Gm-Message-State: AFqh2kpbFrJB6m6/0LXOS3nAZ9byfV7cWZAgD+C3BAxvfTgZRXJXCjfv
        oEtQnSGwdzSvEDGo6wqjvyBokVAiaUPhXIv2
X-Google-Smtp-Source: AMrXdXuvs7jo6hCfe2Sf2NNwK+HsB9uXbGW1q4VXHzebXGl2vmjh6T+YWCM9rjqMyXWZpIdpfaKNiw==
X-Received: by 2002:a05:622a:1f09:b0:3a7:eb01:5dde with SMTP id ca9-20020a05622a1f0900b003a7eb015ddemr37252938qtb.14.1672406291973;
        Fri, 30 Dec 2022 05:18:11 -0800 (PST)
Received: from smtpclient.apple (c-98-249-43-138.hsd1.va.comcast.net. [98.249.43.138])
        by smtp.gmail.com with ESMTPSA id a20-20020ac87214000000b003a57eb7f212sm12891916qtp.10.2022.12.30.05.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 05:18:11 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC] Catch dwmw2's deadlock
Date:   Fri, 30 Dec 2022 08:18:00 -0500
Message-Id: <54057376-2A57-4D8B-B05D-DE768F506819@joelfernandes.org>
References: <122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
In-Reply-To: <122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
X-Mailer: iPhone Mail (20B101)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Dec 30, 2022, at 7:28 AM, David Woodhouse <dwmw2@infradead.org> wrote:
>=20
> =EF=BB=BFOn Fri, 2022-12-30 at 11:38 +0000, Matthew Wilcox wrote:
>>=20
>> <dwmw2> why doesn't lockdep catch us calling synchronize_srcu() with
>>    a lock held, and elsewhere obtaining that lock within an srcu critical=

>>    region ("read lock") ?
>>=20
>> Because synchronize_srcu() doesn't acquire the lock, merely checks that
>> it isn't held.
>>=20
>> Would this work?  Not even compile tested.
>>=20
>> You can put my SoB on this if it works.
>>=20
>=20
> Thanks. Not sure if this addresses the issue I was talking about.
>=20
> There exists a completely unrelated mutex, let's call it kvm->lock.
>=20
> One code path *holds* kvm->lock while calling synchronize_srcu().
> Another code path is in a read-side section and attempts to obtain the
> same kvm->lock.
>=20
> Described here:
>=20
> https://lore.kernel.org/kvm/20221229211737.138861-1-mhal@rbox.co/T/#m594c1=
068d7a659f0a1aab3b64b0903836919bb0a

I think the patch from Matthew Wilcox will address it because the read side s=
ection already acquires the dep_map. So lockdep subsystem should be able to n=
ail the dependency. One comment on that below:

>=20
>> diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
>> index ca4b5dcec675..e9c2ab8369c0 100644
>> --- a/kernel/rcu/srcutree.c
>> +++ b/kernel/rcu/srcutree.c
>> @@ -1267,11 +1267,11 @@ static void __synchronize_srcu(struct srcu_struct=
 *ssp, bool do_norm)
>>  {
>>         struct rcu_synchronize rcu;
>> =20
>> -       RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
>> -                        lock_is_held(&rcu_bh_lock_map) ||
>> +       rcu_lock_acquire(&ssp->dep_map);
>> +       RCU_LOCKDEP_WARN(lock_is_held(&rcu_bh_lock_map) ||
>>                          lock_is_held(&rcu_lock_map) ||
>>                          lock_is_held(&rcu_sched_lock_map),
>> -                        "Illegal synchronize_srcu() in same-type SRCU (o=
r in RCU) read-side critical section");
>> +                        "Illegal synchronize_srcu() in RCU read-side cri=
tical section");
>> =20
>>         if (rcu_scheduler_active =3D=3D RCU_SCHEDULER_INACTIVE)
>>                 return;

Should you not release here?

Thanks,

- Joel=20


>> @@ -1282,6 +1282,7 @@ static void __synchronize_srcu(struct srcu_struct *=
ssp, bool do_norm)
>>         __call_srcu(ssp, &rcu.head, wakeme_after_rcu, do_norm);
>>         wait_for_completion(&rcu.completion);
>>         destroy_rcu_head_on_stack(&rcu.head);
>> +       rcu_lock_release(&ssp->dep_map);
>> =20
>>         /*
>>          * Make sure that later code is ordered after the SRCU grace
>=20
