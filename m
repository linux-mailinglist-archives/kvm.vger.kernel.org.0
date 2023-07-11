Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D9D74E9CC
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 11:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjGKJEo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 05:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbjGKJEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 05:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B52E49
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 02:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689066200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iihmivwEn9Wi0ZUwLTeLIftJFTnt1a5VduovAvNB2Io=;
        b=ayGuHVFGdz+SzYXVVYZK0+/8B6qf6qxTuQDo2h6rCeKwXX1/ESjvgNy9ofdWdU7xblydUZ
        WD4+ZRdseX1aVUHF+Lagp8yXhkBj80C5/la1/a7aRZQkNX87az2HzGYjSrFaSpB6q/l7iK
        aMNXPnKujLJ8uDXMoRhq6eGvMW2YwU0=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-HX8ICoxdN9OhGytlv9RVWA-1; Tue, 11 Jul 2023 05:03:19 -0400
X-MC-Unique: HX8ICoxdN9OhGytlv9RVWA-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-78f1b0510c7so490529241.2
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 02:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689066198; x=1691658198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iihmivwEn9Wi0ZUwLTeLIftJFTnt1a5VduovAvNB2Io=;
        b=AAaU0qSfw5fxZCkFkul7WYMh2FtuSR1Utft5rzi2q/shAqgi28tC5lLZW20M2ckgJ5
         3wd+y/XOi98NCzasSus5jzbbaxSL3GsMPbPHotddkrGwnWSo3sh8NYO2s2z6bHBH1Cbq
         X7QS6DYFVpb5zj5Oem6DTN52ajz2T9pUVDhCvCyLrfav2cDz09O4wWqoCT0P0RQr2WUn
         XJrOPWeXcDdl9/9o7njWTMHGGtof4ZjqIv39D9vpGB1czjOZdojxClIEikaQIarcRUPd
         vbG5NVMeHLkKXBb/JlZb8VzdLxOD3PHCbwfP8sRI/NuaU38tygA+TFnhsGwlsYWmtc+v
         9tDQ==
X-Gm-Message-State: ABy/qLa2xpvNTm7ABG696C6XU297ecbvkwVgd5wCy372FoLBBoxk73O9
        vpg7xSn61f/Wu6Ptrcupptv82zth91AVt5uDcCVDKgBfgRp8vn4doIXSoNHeGfgpqqkxwUtJrkJ
        vLJxpW7whiCtGDPQYuf68SFnXCE/YSC4ZnEpxGl8=
X-Received: by 2002:a67:de06:0:b0:443:ef68:1f12 with SMTP id q6-20020a67de06000000b00443ef681f12mr4578380vsk.28.1689066198232;
        Tue, 11 Jul 2023 02:03:18 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEi3YSBJDDeOv3ojRzo2zv1jNoG/qH53iGoPLoSsKb79M6xeEVeOT8QMIda4rFwHLatXjP2v1QlBKOqD4orUsM=
X-Received: by 2002:a67:de06:0:b0:443:ef68:1f12 with SMTP id
 q6-20020a67de06000000b00443ef681f12mr4578375vsk.28.1689066197920; Tue, 11 Jul
 2023 02:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com> <20230627003306.2841058-2-seanjc@google.com>
 <CABgObfZCbt8YNuJSa358Er5DO4Eeb4UNbcdyNsWymSSqAnVSpA@mail.gmail.com> <ZKwzCA6guSJZGtJJ@google.com>
In-Reply-To: <ZKwzCA6guSJZGtJJ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue, 11 Jul 2023 11:03:06 +0200
Message-ID: <CABgObfZvHHnfgVJc39rLOeD4YKdkWSk5+fo8vEJZPDESbNBD5g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.5
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
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

On Mon, Jul 10, 2023 at 6:34=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Sat, Jul 01, 2023, Paolo Bonzini wrote:
> > On Tue, Jun 27, 2023 at 2:33=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >  - Fix a longstanding bug in the reporting of the number of entries r=
eturned by
> > >    KVM_GET_CPUID2
> >
> > This description does not match the actual commit which says there is
> > no functional change. I have removed this entry from the merge commit,
> > letting it go under "Misc cleanups".
>
> Hmm, which commit are you looking at?  This is the commit I was referring=
 to in
> the tag.

Yeah, you're right. You are removing the code from the failure case,
but of course it's being added to the success case because of the

-    return 0;

change.

Paolo

