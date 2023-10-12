Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EE37C710F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343912AbjJLPL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235737AbjJLPL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E78790
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697123442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G902YRH4gMYpL3ZSti9071jAR2nOwc1FYmNDsAZeTg8=;
        b=fnMmOpbl3MGrUHYHWbeE2DCbxraHe/9yhkH7ZiYreN1QAMOh2OSWs1ZDkMe4pGpXTSauwy
        IxhyZ6GBqgvlCrPmFtYP3axCWnBBsumsCrutM+xl7jLWnYPfX5bJx5h7UFXK8hM0oVKoka
        VIE+ghjmZMXfH4bBSRL9asDy3zjSr9Q=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-7TpeddBmMWapG-RJNH3hjQ-1; Thu, 12 Oct 2023 11:10:39 -0400
X-MC-Unique: 7TpeddBmMWapG-RJNH3hjQ-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3af5b5d816aso1513976b6e.3
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697123437; x=1697728237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G902YRH4gMYpL3ZSti9071jAR2nOwc1FYmNDsAZeTg8=;
        b=QX4djVb63qBiFN9pkYfNXbvtK+PUSvfk/1yd+dm1qeCXGrG3AQMJFvNIOF9+ceKOdX
         aeGcB2jYVWfBoJjmbcnNQkfYilh95dFnJjpV4F3ozb8L2VkpQFwiwkNYpYpuxhuU6MCm
         NSXApcyQjkeFHc4V0AnzZMzDL1JuOWapLdHrGV2TardErw4KEmxA2qCL3wi1taZyRmbI
         HTBy0gCiRgDjsjcityo8vhNIMY7rifjuNREHeDHD8BcyCShL7U0ftZf9/FpacKNHMJju
         XP/747HoqKlyDepPgKmh/S3mVsCWKgVDiyl2L/cq2w2XOhi1Xn6ws69vyr5Pk1ByJqXa
         xdMw==
X-Gm-Message-State: AOJu0YwnWWfPc23lR4OWACv7LuVSEqUNNk1JwkSPIIAYUeJ5qGnhVfdt
        0fIYds9BJAoKi3+uEEe3qSqr6ZYy9Jl8eGmaFUBxEv5N3E4+nOisarYolXglue9QlxdPT5pJfT5
        mLZKuruCib8sTl6n96OMOff0zjR21MFESZ3jJ
X-Received: by 2002:aca:1c0a:0:b0:3ae:aa6:dc0c with SMTP id c10-20020aca1c0a000000b003ae0aa6dc0cmr25467613oic.9.1697123436912;
        Thu, 12 Oct 2023 08:10:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJo0OsSsOp3ULotW0l+15UUEJrghdAo4jXz8BKtcULxi61l2Ufj14ZsBlTMojK8MUO2luhwvvfwNeDNima55k=
X-Received: by 2002:aca:1c0a:0:b0:3ae:aa6:dc0c with SMTP id
 c10-20020aca1c0a000000b003ae0aa6dc0cmr25467596oic.9.1697123436675; Thu, 12
 Oct 2023 08:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230929155706.81033-1-imbrenda@linux.ibm.com>
In-Reply-To: <20230929155706.81033-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 12 Oct 2023 17:10:24 +0200
Message-ID: <CABgObfa-2YkYuv6agzUfeGA6zzwPa21O74ruDJcsrU=Jo_VGiA@mail.gmail.com>
Subject: Re: [GIT PULL 0/1] KVM: s390: gisa: one fix for 6.6
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 29, 2023 at 5:57=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ib=
m.com> wrote:
>
> Hi Paolo,
>
> a small fix for gisa, please pull :)
>
>
> Claudio
>
> The following changes since commit 6465e260f48790807eef06b583b38ca9789b60=
72:
>
>   Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)
>
> are available in the Git repository at:
>
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.gi=
t tags/kvm-s390-master-6.6-1

Pulled, but you need to configure separate url/pushurl. :)

Paolo

>
> for you to fetch changes up to f87ef5723536a6545ed9c43e18b13a9faceb3c80:
>
>   KVM: s390: fix gisa destroy operation might lead to cpu stalls (2023-09=
-25 08:31:47 +0200)
>
> ----------------------------------------------------------------
> One small fix for gisa to avoid stalls.
>
> ----------------------------------------------------------------
>
> Michael Mueller (1):
>   KVM: s390: fix gisa destroy operation might lead to cpu stalls
>
>  arch/s390/kvm/interrupt.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> --
> 2.41.0
>

