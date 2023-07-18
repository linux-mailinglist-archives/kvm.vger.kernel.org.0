Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93CD75787F
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 11:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjGRJxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 05:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbjGRJwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 05:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24186172E
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689673895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6GL7be3klq4AQltl7ywAx49QXpY3NCEVoxVIWeGEGA=;
        b=XhM8oBKyZN/S2JzECk0faKP1e125Bvdb6fJiOKgo7BtHjKdrtDH/+b2+nR30Ls4uENPRth
        bqK3HKwiJRmUfxjr7LuJaqx830/eaXX6x6lFrXHD0OouAVXh0Uc1e/pXfV80SeA0JJt/OB
        LaNGvZu82zy3hyCAr8BMBh+dWXEzoCk=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-YzLJ28RMMYCyzwt_sTFqqA-1; Tue, 18 Jul 2023 05:51:34 -0400
X-MC-Unique: YzLJ28RMMYCyzwt_sTFqqA-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-79977e6b834so635253241.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 02:51:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689673894; x=1692265894;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6GL7be3klq4AQltl7ywAx49QXpY3NCEVoxVIWeGEGA=;
        b=Pzi2JydENzILIHIZLYAl2S5VqT07fHHcT84JbbmbFY9r4+lHLWXO3rBUil49mnDONA
         ohkX9S2xUQ02vWpbtyX6MUz8Ay3ss2E/7OhjD65uLFKMn4mQ+cNNQ18wpYqNVz/9MvY6
         LMzxqfdaEgH0t4dsnqwHFkDOrBnDgzom9IYJEIE3zHcIdxNSOF5W4MXGwND7MGQZEHIf
         ubJxqcrdG1HOjN1DtWkIYc6nMgpkPbiLnlXbAW5cBYCBrAiU5A646cEKPTnVfdbetZFx
         E2nlzWkwUmfDVIeWSaUsXrzNXfi2OL3QRyXSfHKJSrdQMeqqGy3VZUx2jtZVTIpguijd
         tYxA==
X-Gm-Message-State: ABy/qLY8VveQx3Yqh7uLrmyAt3jMnrqpInyPYDoAjfVfl7jXfvHjAAoL
        qaS+RbGq4cgRmWu9PDrIRzyWRjdDyVjgS1OY6KLBv0U7KYLyNcAnxWmoNr16yoGqeDCtPQD5XGe
        /KxqFPpoyFn4dlyo/WZ1lIdGgzFmM
X-Received: by 2002:a67:cd0f:0:b0:443:7787:8333 with SMTP id u15-20020a67cd0f000000b0044377878333mr973857vsl.8.1689673893854;
        Tue, 18 Jul 2023 02:51:33 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGB8pAKp8mtkNlDXSgPOxL3UEVlrskI1QSq4QCgpqOGXlB7bD0z0zo+etuUDk0qCxJ/lf9/tiLO2aFIPV9hVDY=
X-Received: by 2002:a67:cd0f:0:b0:443:7787:8333 with SMTP id
 u15-20020a67cd0f000000b0044377878333mr973851vsl.8.1689673893614; Tue, 18 Jul
 2023 02:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <bug-217379-28872@https.bugzilla.kernel.org/> <ZE/uDYGhVAJ28LYu@google.com>
 <c1ac9dae-51d8-f570-db6c-39a161ab6bb9@gmail.com> <CABgObfbmR3oPhMirpKooPCMkMi=JwcoCjoVzS1-nXKhfYhOZhA@mail.gmail.com>
 <0810897c-de79-28b9-df3e-98eb442e803f@gmail.com>
In-Reply-To: <0810897c-de79-28b9-df3e-98eb442e803f@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 18 Jul 2023 11:51:21 +0200
Message-ID: <CABgObfZOjmRpsaPNix4D=GJk6Ub0Eoz3c=kFX_VU-fbgoz8UUQ@mail.gmail.com>
Subject: Re: [Bug 217379] New: Latency issues in irq_bypass_register_consumer
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        "Alex Williamson, Red Hat" <alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 5:43=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> On 17/7/2023 11:25 pm, Paolo Bonzini wrote:
> > On Mon, Jul 17, 2023 at 1:58=E2=80=AFPM Like Xu <like.xu.linux@gmail.co=
m> wrote:
> >>>      - Use a different data type to track the producers and consumers=
 so that lookups
> >>>        don't require a linear walk.  AIUI, the "tokens" used to match=
 producers and
> >>>        consumers are just kernel pointers, so I _think_ XArray would =
perform reasonably
> >>>        well.
> >>
> >> My measurements show that there is little performance gain from optimi=
zing lookups.
>
> First of all, I agree that the use of linear lookups here is certainly no=
t
> optimal, and meanwhile the point is that it's not the culprit for the lon=
g
> delay of irq_bypass_register_consumer().
>
> Based on the user-supplied kvm_irqfd_fork load, we note that this is a te=
st
> scenario where there are no producers and the number of consumer is growi=
ng
> linearly, and we note that the time delay [*] for two list_for_each_entry=
()
> walks (w/o xArray proposal) is:

This scenario is still subject to quadratic complexity in the first
foreach loop:

        list_for_each_entry(tmp, &consumers, node) {
                if (tmp->token =3D=3D consumer->token || tmp =3D=3D consume=
r) {
                        ret =3D -EBUSY;
                        goto out_err;
                }
        }

Paolo

