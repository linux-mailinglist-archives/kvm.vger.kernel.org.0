Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB3F6F80A2
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 12:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjEEKOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 06:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjEEKOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 06:14:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F13D150DE
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 03:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683281622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oZ+W0+aJdMtjJzmRiw6PVDgzOh3temaFbWrH/wCIxiU=;
        b=H0qt/oRmfeFEm9QhCCcynQeKgfKRdHdkZZ1gddw8TQ3y5Ei5JNL+7gWFOcBupVw3OkDdxt
        vWQB9xoJJcTWe2wHvBwNLMOMZttuSjbAk0enD1RI6JMTpxPqDGW9XHH7izX6N2p80DTez0
        rY7zGWiqPGmGKliY31rXm7DaAjaMigY=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-sa603cTpOwq-sGRtWY-YiQ-1; Fri, 05 May 2023 06:13:41 -0400
X-MC-Unique: sa603cTpOwq-sGRtWY-YiQ-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-4346a3bc2c6so297571137.3
        for <kvm@vger.kernel.org>; Fri, 05 May 2023 03:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683281621; x=1685873621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oZ+W0+aJdMtjJzmRiw6PVDgzOh3temaFbWrH/wCIxiU=;
        b=HqmPm5mVix3pQhUnpmqasgSQPrdMrpJMS8dVB4qeYan6OjZ1nQTaEa5w3Oax3O0q/b
         E7QH13EX90Ers3I0aFRKkmOrY3yI3kp/wLvqrQuI0uRI5xh6z+L6viPoDpr2pl0IaRu9
         gpakw1ASumnWpmjqPVeJWKTqqlXJJXqvMWMoipyNsknj4decSI1+HP/s0T3/DJfa4SzR
         KWzowdKE//2Zt7RUI/SL5FAJintyZLxAvFYRBOY9PkrUzZlgbFJ/te1ujDbz5ZBZfSDA
         i3kiTGwEPbTFNtcG0gXN78XP3DGP2Sh1sNeteqGKNQOnFH3mzx+Q9FP36Xe+ykdx5DYH
         XiYQ==
X-Gm-Message-State: AC+VfDz39IZ2/soZozT2p0YteV7Wvdsis/ZIKs67Gl3W1XZ3Q5oI8U9r
        z7jR3l+8pDOahCTiiXaOzb5h+ikRvDVGZEN8vEFPriHNyuj/Xl2ARDXNnMgkmAUICJzHkpZFx6H
        8kf77CPiCl8n//B+iIEz/63nDxcAM
X-Received: by 2002:a05:6102:3cd:b0:430:ce0:ae90 with SMTP id n13-20020a05610203cd00b004300ce0ae90mr264081vsq.14.1683281620932;
        Fri, 05 May 2023 03:13:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OtXedp3osVnwEX33Yc8OMv+0d9M5ynEvZuqvO8k8HixdHSob0k1+rsHIZA+Ep6fL44O5RFoq3hvilcahA2KI=
X-Received: by 2002:a05:6102:3cd:b0:430:ce0:ae90 with SMTP id
 n13-20020a05610203cd00b004300ce0ae90mr264077vsq.14.1683281620688; Fri, 05 May
 2023 03:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230504171611.54844-1-imbrenda@linux.ibm.com>
In-Reply-To: <20230504171611.54844-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 5 May 2023 12:13:29 +0200
Message-ID: <CABgObfZdsv3BBTOsPCf=YYOuDifGamLivEjiMfvZ7df+Yt208A@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: Some fixes for 6.4
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 4, 2023 at 7:16=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ibm=
.com> wrote:
>
> Hi Paolo,
>
> just a couple of bugfixes, nothing too exceptional here.
>
>
> please pull, thanks!
>
> Claudio

Done, thank you.

Paolo

>
>
> The following changes since commit 8a46df7cd135fe576c18efa418cd1549e51f27=
32:
>
>   KVM: s390: pci: fix virtual-physical confusion on module unload/load (2=
023-04-20 16:30:35 +0200)
>
> are available in the Git repository at:
>
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.gi=
t tags/kvm-s390-next-6.4-2
>
> for you to fetch changes up to c148dc8e2fa403be501612ee409db866eeed35c0:
>
>   KVM: s390: fix race in gmap_make_secure() (2023-05-04 18:26:27 +0200)
>
> ----------------------------------------------------------------
> For 6.4
>
> ----------------------------------------------------------------
> Claudio Imbrenda (2):
>       KVM: s390: pv: fix asynchronous teardown for small VMs
>       KVM: s390: fix race in gmap_make_secure()
>
>  arch/s390/kernel/uv.c | 32 +++++++++++---------------------
>  arch/s390/kvm/pv.c    |  5 +++++
>  arch/s390/mm/gmap.c   |  7 +++++++
>  3 files changed, 23 insertions(+), 21 deletions(-)
>

