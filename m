Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B307D46BC
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 06:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjJXEpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 00:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjJXEpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 00:45:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F284A98
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 21:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698122702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6wKDdkCVWVI+YJGwvEF7/3p32/fl+T2zF7AbVVtpxE=;
        b=MWhIzqxEZh57IDJBmx5QS2YhhpnTFcZ1FLZappF9KfK2NgVd7d5KbQDzvqM36L89QZdWSm
        4YqapIKku+Skf8eK6S4pD+qDrjggeb0gCvRJLLEakHWxq+eY9Zw6pHk1unc9BBZuxosCBW
        KZn9wDonBoMIpZVjk7+GRmRVRZWDIi8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-OeoxJhGXNQ2hZ7hkSGauKw-1; Tue, 24 Oct 2023 00:45:01 -0400
X-MC-Unique: OeoxJhGXNQ2hZ7hkSGauKw-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5079fd97838so4160322e87.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 21:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698122699; x=1698727499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6wKDdkCVWVI+YJGwvEF7/3p32/fl+T2zF7AbVVtpxE=;
        b=OiwiNbrtzZrqpdM9jVsDbwpYbgaMfYpj+ZECMaVwRri2hOPgz6avev429b0LZDM7mb
         99vRjS3o3DcvrXc+KSNy4tSMR+XBQ3tdG9M2osr23e+WwAK5qXQrm0RDnEWvOVmLqLiW
         gjWfIIODUznqk3v8tMhx0zToCU+V7ub0FAx+jZWlo05co+SaJqBN1sqrk7LM94u3bTQz
         SGUR8wlYSHkglGC5W/qwtK4zOIaUhHsviwqHSpjuv/d7hT+vE6CugNzBduIT7xw0mlfW
         fPlZAQwV++arREoTOXROX9tyfBenkduMVJA2v77TOOh4LQlZlANcQ2Vm/QLK3e4Kauq3
         InSg==
X-Gm-Message-State: AOJu0YxIMfXba3pbDNo4v2QpIyKP26Fh+2pGjd3nyxi823Gaym12c1/X
        vs4gOnTCSsGhZRtJVMj4jo+NxTPbTYNgCbRBu4ST1Z5aW0sQ43pOAeXBMvcFtF4KKBhz9SivCn7
        3y07Dbvbld8UyC4kTx5GJ9Iw7SVxaW3mHRSSv6BVclA==
X-Received: by 2002:ac2:48ac:0:b0:503:2e6:6862 with SMTP id u12-20020ac248ac000000b0050302e66862mr7717003lfg.32.1698122699054;
        Mon, 23 Oct 2023 21:44:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdEbyvQwDHVj3MFSMFvxMf8SZFaaIUF0Bce0KCFOSPWwogHByPw2z1aoaFc1EveRwVlf/73Ooq22G7ATU18dM=
X-Received: by 2002:ac2:48ac:0:b0:503:2e6:6862 with SMTP id
 u12-20020ac248ac000000b0050302e66862mr7716995lfg.32.1698122698696; Mon, 23
 Oct 2023 21:44:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAKhg4tKSWLood9aFo7r1j-a3sXvf+WraFV_xUcKOMLq9sxrPXA@mail.gmail.com>
In-Reply-To: <CAKhg4tKSWLood9aFo7r1j-a3sXvf+WraFV_xUcKOMLq9sxrPXA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 24 Oct 2023 12:44:47 +0800
Message-ID: <CACGkMEufrJfM7bw7s76gq_3S5oSgx4w5KjxO_oReMg34bCy5hA@mail.gmail.com>
Subject: Re: [RFC] vhost: vmap virtio descriptor table kernel/kvm
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 11:17=E2=80=AFAM Liang Chen <liangchen.linux@gmail.=
com> wrote:
>
> The current vhost code uses 'copy_from_user' to copy descriptors from
> userspace to vhost. We attempted to 'vmap' the descriptor table to
> reduce the overhead associated with 'copy_from_user' during descriptor
> access, because it can be accessed quite frequently. This change
> resulted in a moderate performance improvement (approximately 3%) in
> our pktgen test, as shown below. Additionally, the latency in the
> 'vhost_get_vq_desc' function shows a noticeable decrease.
>
> current code:
>                 IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> Average:        vnet0      0.31 1330807.03      0.02  77976.98
> 0.00      0.00      0.00      6.39
> # /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
> avg =3D 145 nsecs, total: 1455980341 nsecs, count: 9985224
>
> vmap:
>                 IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s
> rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> Average:        vnet0      0.07 1371870.49      0.00  80383.04
> 0.00      0.00      0.00      6.58
> # /usr/share/bcc/tools/funclatency -d 10 vhost_get_vq_desc
> avg =3D 122 nsecs, total: 1286983929 nsecs, count: 10478134
>
> We are uncertain if there are any aspects we may have overlooked and
> would appreciate any advice before we submit an actual patch.

So the idea is to use a shadow page table instead of the userspace one
to avoid things like spec barriers or SMAP.

I've tried this in the past:

commit 7f466032dc9e5a61217f22ea34b2df932786bbfc (HEAD)
Author: Jason Wang <jasowang@redhat.com>
Date:   Fri May 24 04:12:18 2019 -0400

    vhost: access vq metadata through kernel virtual address

    It was noticed that the copy_to/from_user() friends that was used to
    access virtqueue metdata tends to be very expensive for dataplane
    implementation like vhost since it involves lots of software checks,
    speculation barriers, hardware feature toggling (e.g SMAP). The
    extra cost will be more obvious when transferring small packets since
    the time spent on metadata accessing become more significant.
...

Note that it tries to use a direct map instead of a VMAP as Andrea
suggests. But it led to several fallouts which were tricky to be
fixed[1] (like the use of MMU notifiers to do synchronization). So it
is reverted finally.

I'm not saying it's a dead end. But we need to find a way to solve the
issues or use something different. I'm happy to offer help.

1) Avoid using SMAP for vhost kthread, for example using shed
notifier, I'm not sure this is possible or not
2) A new iov iterator that doesn't do SMAP at all, this looks
dangerous and Al might not like it
3) (Re)using HMM
...

You may want to see archives for more information. We've had a lot of
discussions.

Thanks

[1] https://lore.kernel.org/lkml/20190731084655.7024-1-jasowang@redhat.com/

>
>
> Thanks,
> Liang
>

