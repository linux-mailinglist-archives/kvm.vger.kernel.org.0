Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400D97567E3
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 17:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjGQP1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 11:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjGQP1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 11:27:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E5C1FC4
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689607555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9OLUtAxKU5UFD/3ylVLHJu+L8v08mbXQzmc+rgIwN6o=;
        b=VfNFLfj+4CFi76WCoOAvPtOm3sRVvFvpPd1Ia+n1HG+3o6FbnKuiw/aPB6/8oyysqQJZQn
        B+OUVz+eI5cAjnIk6SCWNu9rC0OMz/zJK6E0ahpnqru1Iuk5pL+XLd+Nvvcx1W58w+HNPE
        QK+F/y78h/l5oyir8Din3L44CoyWDfs=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-cbxM2jsiNdKD0WECIOxvYw-1; Mon, 17 Jul 2023 11:25:54 -0400
X-MC-Unique: cbxM2jsiNdKD0WECIOxvYw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7999ef0f37fso188059241.0
        for <kvm@vger.kernel.org>; Mon, 17 Jul 2023 08:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607553; x=1692199553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9OLUtAxKU5UFD/3ylVLHJu+L8v08mbXQzmc+rgIwN6o=;
        b=TowieCBmNvUdJcWiMs8RWgDL5H3urAFYWFvzYSezg0mRjCucTH3nSbcHkGVHyoox/x
         OsSG7orMtakTLarFetHIYAaXTMZIGCj7cpA/5gP+5fIP3a6bYWc8vqRWB+03AwkzGHFS
         C+WJcpnJsCakBcLZb8up6RpZSIQUO6qH4rCRe5VUXPU4yMpqdgTuPAVVGXY9KNEj8VeW
         fu74RB6X7Acyu/9sfiZVgZ+my1ehtIQuHVlvBm4o1EtREN0R+ZLrVVGNCuhBM845uvvE
         Z6+vJE5RWFCME9bBmONyNhmmKDrjNC37Gy0KfhrLWyoUJb1KOoEyV6l+N6t8pdRh6EFx
         NAsw==
X-Gm-Message-State: ABy/qLZ5waWL0OZC/vL1b5t85vKIIOaLNIsXKXfOGGLRkHIy3IcklCBf
        QujXamJzssS6PzV3eOo7CnfIRuDCnWpEzacEAhWPZQtMkDb7908+MrZ538++CzAibffQZCaZ3db
        BrX1eC1nI6uB63Hcs0FjcwZQGJgxi
X-Received: by 2002:a67:e20e:0:b0:444:9475:362b with SMTP id g14-20020a67e20e000000b004449475362bmr5743758vsa.1.1689607553603;
        Mon, 17 Jul 2023 08:25:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHxdr3Nb78zj+lm3NMfkSzruqbaUzVB5f7mNxqrhbqfX/DgOX0DVyexXZ4t2uN0WXGCvEfU7QlxwEFoY8oybpo=
X-Received: by 2002:a67:e20e:0:b0:444:9475:362b with SMTP id
 g14-20020a67e20e000000b004449475362bmr5743749vsa.1.1689607553384; Mon, 17 Jul
 2023 08:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <bug-217379-28872@https.bugzilla.kernel.org/> <ZE/uDYGhVAJ28LYu@google.com>
 <c1ac9dae-51d8-f570-db6c-39a161ab6bb9@gmail.com>
In-Reply-To: <c1ac9dae-51d8-f570-db6c-39a161ab6bb9@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 17 Jul 2023 17:25:41 +0200
Message-ID: <CABgObfbmR3oPhMirpKooPCMkMi=JwcoCjoVzS1-nXKhfYhOZhA@mail.gmail.com>
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

On Mon, Jul 17, 2023 at 1:58=E2=80=AFPM Like Xu <like.xu.linux@gmail.com> w=
rote:
> >     - Use a different data type to track the producers and consumers so=
 that lookups
> >       don't require a linear walk.  AIUI, the "tokens" used to match pr=
oducers and
> >       consumers are just kernel pointers, so I _think_ XArray would per=
form reasonably
> >       well.
>
> My measurements show that there is little performance gain from optimizin=
g lookups.

How did you test this?

Paolo

