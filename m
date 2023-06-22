Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0373A510
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 17:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjFVPcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 11:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjFVPb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 11:31:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A1635AB
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687447756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LHj7B9f0CgOb6vLBDwdZy7CybIY89mtFfpP8ghtMr90=;
        b=g1YGZTQ2bnNNl4LPtYawqVPnuAHdN1imsIRwdbnaqfFhej4JTVY55fLjXxDyGSlfszihG+
        AIVBvc2ASAr4d7rDkRN/pKwKUZppdS5GvLUv5JVz/u9SAZ996K7x8eRa2gCn6TLbSbLJVD
        s+uSt6Ro4Z+IFYeRusJ+44cwQsHYui8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-0K8jDIZEOnq9sUy9k3ScNw-1; Thu, 22 Jun 2023 11:29:13 -0400
X-MC-Unique: 0K8jDIZEOnq9sUy9k3ScNw-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31286355338so1087797f8f.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 08:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687447753; x=1690039753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHj7B9f0CgOb6vLBDwdZy7CybIY89mtFfpP8ghtMr90=;
        b=ZWTsygyokKzxzR4HHfEm9yTIMGfUdJU41RNx6xUXrVcXr5uH8UfAgm8ZPXENmaO5tj
         u91/vy0yHxseGXy/IQ8VuZB/YuYRcf+HS9jwBKOVUo4kOr1YktVIm8PLOmVfLam+RYZp
         5a8K/ZlvrXoM4LV6g3qDQKXTQ7Yon2+Y4H4g7L0707s+btbq2/03M2K9cYj+p9CX5kc8
         hkXFi9jBPKeliMHhnjls5Llq4w9n02RF9K7kRI8mmm6qeFQdhMW4KrqEcPJwen78IWyw
         HX9+ghLc2CX4ZB01la1rmGoK6HLRXUmLriX7LjrUnUFXXGjuj9b87xzLYeamXvHEdq2R
         dOpg==
X-Gm-Message-State: AC+VfDy36lcMUpcHOtojirZY/W4wsMDOGBOVmpiEDLIXsH5yor1h2Q7A
        rcz0D5kWeLgjd4BNEElK1ItIonJpqN0TijBVDFmoxajMxSngD3G5/i397NCHw6FL0k26GWZolDX
        r3Ok1Vplxga6E
X-Received: by 2002:a5d:4a45:0:b0:30f:b9a2:92c5 with SMTP id v5-20020a5d4a45000000b0030fb9a292c5mr16230772wrs.49.1687447752864;
        Thu, 22 Jun 2023 08:29:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6wJek32JccOCrkY+bAzshAWmkfVijJZJwTebxPvorEXZQJ+vqataOybeRtTQvOfMVty8q+6Q==
X-Received: by 2002:a5d:4a45:0:b0:30f:b9a2:92c5 with SMTP id v5-20020a5d4a45000000b0030fb9a292c5mr16230739wrs.49.1687447752542;
        Thu, 22 Jun 2023 08:29:12 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id p7-20020adff207000000b00307acec258esm7389420wro.3.2023.06.22.08.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 08:29:12 -0700 (PDT)
Date:   Thu, 22 Jun 2023 17:29:08 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Jiang Wang <jiang.wang@bytedance.com>
Subject: Re: [PATCH RFC net-next v4 5/8] virtio/vsock: add
 VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <med476cdkdhkylddqa5wbhjpgyw2yiqfthvup2kics3zbb5vpb@ovzg57adewfw>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-5-0cebbb2ae899@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-5-0cebbb2ae899@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 12:58:32AM +0000, Bobby Eshleman wrote:
>This commit adds a feature bit for virtio vsock to support datagrams.
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> include/uapi/linux/virtio_vsock.h | 1 +
> 1 file changed, 1 insertion(+)

LGTM, but I'll give the R-b when we merge the virtio-spec.

Stefano

>
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 64738838bee5..9c25f267bbc0 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -40,6 +40,7 @@
>
> /* The feature bitmap for virtio vsock */
> #define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>+#define VIRTIO_VSOCK_F_DGRAM		3	/* SOCK_DGRAM supported */
>
> struct virtio_vsock_config {
> 	__le64 guest_cid;
>
>-- 
>2.30.2
>

