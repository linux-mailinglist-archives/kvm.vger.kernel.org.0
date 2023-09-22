Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2CD7AA739
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 05:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjIVDD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 23:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 23:03:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F304E192
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695351784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dW4RnVlw5/tVnpAaLSeim6/pCr4y6tZ4UO2FXXjy4VI=;
        b=VcvC4/p6W25r3aCvvfkiagAUgtOAEUEGdzpsrosM9KImIxyP6KeXKX5M5+QCe8oi63su2m
        mpDEQ6um+DrJL3e6vY1cQOWlurItqYeOLf8X0eqzffTzEMRmL3FCL9x3VNPOI+058ft6wF
        2tR1DN6NxOylq1KDiWBrgoV4B0wChpE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-sQgOUXh7PIepLCs06BxKtA-1; Thu, 21 Sep 2023 23:03:03 -0400
X-MC-Unique: sQgOUXh7PIepLCs06BxKtA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5042bc93273so1644570e87.1
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695351782; x=1695956582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dW4RnVlw5/tVnpAaLSeim6/pCr4y6tZ4UO2FXXjy4VI=;
        b=N/v1k7NuGw8KvTlKEKnDt+9vsTUoSdzfKoRtWc9bpAPp7maZu1spLlke/JmwlED6PS
         5Br5Nqh+FERUv6X/qpSmwbpwbL+qNpc3WHugtZG6rXZGyc2UFI14X7y+HZoh2hsr4GzT
         Rd19SnIwe2G4IzhKepyJpBme3QpuuMdrTx2E78h525CjfZhkoKxfLusRjB+l6n3ivQIk
         BrHSij3FwKSK8UqaJS0u252uOvJe4u9KhhAKVxACZYPE6ZEDbkeyLDFbmW3LxuC28AT5
         8TwZvwvduydyIbUFNHO/aD7sEI+mJlR/7IuuFBGgpz/puVOpRH6Jz9Rcr0L0uuR+YF3E
         /FhA==
X-Gm-Message-State: AOJu0Yy8hzXMKVPfEkCwmzN9Tg1kL/9eYQmHpQbs+nHU18qbzcs9M9k9
        O0/XhZkErrZ7VZl6IjOoKTCpfETYg1ee1G0RFqN/oLbV2z55BniMIj1ZNjiPLT08TRXPQqCo77E
        ii2TzkT6XhFkJGJfX12VwUz90j46c
X-Received: by 2002:a05:6512:45c:b0:500:a408:dbd with SMTP id y28-20020a056512045c00b00500a4080dbdmr5634787lfk.55.1695351781962;
        Thu, 21 Sep 2023 20:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCe0kdx/yNUkFl1DpNMRt90Uw3lvxFNhgSGLq2OYqjLwjpt60Uo7KV1kgg6YBPqqu6tDxOYe7G+arq74CtToQ=
X-Received: by 2002:a05:6512:45c:b0:500:a408:dbd with SMTP id
 y28-20020a056512045c00b00500a4080dbdmr5634777lfk.55.1695351781806; Thu, 21
 Sep 2023 20:03:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230921124040.145386-12-yishaih@nvidia.com> <20230921104350.6bb003ff.alex.williamson@redhat.com>
 <20230921165224.GR13733@nvidia.com> <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com> <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com> <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
In-Reply-To: <20230921195345.GZ13733@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 22 Sep 2023 11:02:50 +0800
Message-ID: <CACGkMEt=dxhJP4mUUWh+x-TSxA5JQcvmhJbkLJMWdN8oXV6ojg@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 3:53=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Sep 21, 2023 at 03:34:03PM -0400, Michael S. Tsirkin wrote:
>
> > that's easy/practical.  If instead VDPA gives the same speed with just
> > shadow vq then keeping this hack in vfio seems like less of a problem.
> > Finally if VDPA is faster then maybe you will reconsider using it ;)
>
> It is not all about the speed.
>
> VDPA presents another large and complex software stack in the
> hypervisor that can be eliminated by simply using VFIO.

vDPA supports standard virtio devices so how did you define complexity?

From the view of the application, what it wants is a simple virtio
device but not virtio-pci devices. That is what vDPA tries to present.

By simply counting LOCs: vdpa + vhost + vp_vdpa is much less code than
what VFIO had. It's not hard to expect, it will still be much less
even if iommufd is done.

Thanks



> VFIO is
> already required for other scenarios.
>
> This is about reducing complexity, reducing attack surface and
> increasing maintainability of the hypervisor environment.
>
> Jason
>
>

