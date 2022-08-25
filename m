Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE4E5A19A2
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243454AbiHYTiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 15:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243425AbiHYTh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 15:37:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511FCBD77F
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661456278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPWa+tzTBG+iL60ZzcAk1+gPnoGOubAk1xJV1dc/DQY=;
        b=W4Zs/mKfIiUumBqPzgXU54zsNwwXggxa4mC9vbEtta1Oqv22daJ1tI0/3VxSUcNZl3lcU7
        jDdHo4bs8CDy9ABNIpk3SNfg2+DseKn1/zhrBdjQ+K+kD+TUOU6Awgxw6P/MOV3blDg5ug
        v0QaYwgjJanZa6Tc36fMH9QqoGUlEMo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-6fAYpZL-P9GMdk9BaLqcVQ-1; Thu, 25 Aug 2022 15:37:51 -0400
X-MC-Unique: 6fAYpZL-P9GMdk9BaLqcVQ-1
Received: by mail-io1-f72.google.com with SMTP id x9-20020a056602210900b006897b3869e4so9776869iox.16
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 12:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=bPWa+tzTBG+iL60ZzcAk1+gPnoGOubAk1xJV1dc/DQY=;
        b=YDdAzddaMWrkERh7mQnUzoYlMQJsU9WbrUJ3c1BdkbIcWL8NAhy9/7qhftM78p3AbY
         Hqlx6QyzR6iIUts5vg9L9941Eo9IiOSghvLc6If++R5ctHbe9G5IEnMAbQgp+40CGwz1
         sL6f+C0sh+Z2hgHyjAlUNS2TFDYXtpKUatX0sT0zjd+0RN4AZjSUkboP7E0iA1p3Aq/G
         s4LCGH00GixLUv8hpHbmZsgabeC84/XVxpCLsUKalfMZEBJ9fg3voH/NjCtInLF6XyOs
         CFArgYP9hRhZKUmf6tNDsJ9alrXHYsZK9wG1GmdlaaiBcJ8ca4k5Hj42YmGsSIrcBMUE
         qv7A==
X-Gm-Message-State: ACgBeo1Hjayl6VdFuH7uagFmMVXuKh6nSMpno6CA0f3taNMPPoKYl/1E
        ajJWHn4vl2SkbtOddVdcHsZ7Pb8piYf2vGLVAxg4YV1j1MQktxYFHW/pb5I1dcCh9jjHV8LF1aJ
        Hg8J/eVwC0eve
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr2651629jap.203.1661456271133;
        Thu, 25 Aug 2022 12:37:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6uSXM7JpieCkAL/ZWJiy8snaZElDHAaeSiWAhWn8tGuMwjSwo6rhFGPS2VGsYxErUfUXGbsA==
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr2651614jap.203.1661456270935;
        Thu, 25 Aug 2022 12:37:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a056e02054d00b002e4d61ca3e2sm159664ils.0.2022.08.25.12.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 12:37:50 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:37:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V4 vfio 00/10] Add device DMA logging support for mlx5
 driver
Message-ID: <20220825133749.34281d14.alex.williamson@redhat.com>
In-Reply-To: <e6e79361-a19c-9ad6-403b-9a08f8abcf34@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <e6e79361-a19c-9ad6-403b-9a08f8abcf34@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Aug 2022 14:13:01 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> Alex,
>=20
> Can we please proceed with sending PR for the series to be accepted ?=C2=
=A0=20
> (i.e. as of the first two net/mlx5 patches).
>=20
> The comments that were given in the previous kernel cycle were addressed=
=20
> and there is no open comment here for few weeks already.

Hmm, it's only been posted since last week.  I still find the iova
bitmap code to be quite a mess, I just sent comments.  Thanks,

Alex

