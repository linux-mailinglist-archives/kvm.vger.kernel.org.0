Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE8E699773
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjBPObW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjBPObU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958D53B866
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676557836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U9oWDCNYoCRLAFAE2xiwQxbVwQjtrOQMjZPhjji0izk=;
        b=P9tDjnYMrH5flpq2rzVSn2P23SH0qqYCs8RjCUcEk686ol5u0U4eJIYeLZuiX7M782JNsB
        Fop5tO30fmbzQqJkycx6IShPbQRg1lG1yYENpUe8ZgwSetcd7N+Bzba12DUoMSKKP8kM68
        dG0kPqZGt5PbZvHYH7rI/ts4XsLE5Ik=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-657-ciVrV7d7Ox-lojbLXvVrLA-1; Thu, 16 Feb 2023 09:30:35 -0500
X-MC-Unique: ciVrV7d7Ox-lojbLXvVrLA-1
Received: by mail-qt1-f198.google.com with SMTP id n1-20020ac85a01000000b003ba2a2c50f9so1275236qta.23
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U9oWDCNYoCRLAFAE2xiwQxbVwQjtrOQMjZPhjji0izk=;
        b=RElHkFu6OmvyIxlCoAEZH7QDGvOZoBKtdapSlNBN/v1RlJqy6NwtKbUYuHOpBx9+Uz
         miOT3x3OiLEClOI+az35jznUwnYe5bneLKSdbu5ESwrxozIAvfTZhvKNBqPyO/+byLLX
         fbWb6aX8bF4iaVo0y20mdkX8avGVPWdaCvMH2B3NdStmCeNhcNnYVkVcZPEtV5jkSx4M
         7daJvJyognGyTs8KiG3+rO83iD+9FeNuGKAwnbDfI5H+PAs/CCJndyFhYBW19MMWhuCm
         m2SMLUrN+pvRmy907vUSE/9EJ/WRA6taWqvSQnAqDqTHHmsKe5Sa+t6NsPiXI5VWUQ0R
         WPjQ==
X-Gm-Message-State: AO0yUKWNi+9TewMNeSZd5aWXyr/Y4ACHKVAhZhyfkSD0I5qMrqRHIrP1
        x+mJ8JCGb0JMXcvhyRq2YrZzhPzSYpphPwNMPd0xriRxvMUxRJVG1pAyvklQXVukNlea9leAmnz
        2a2vq+j3vfbxm
X-Received: by 2002:ac8:5849:0:b0:3bd:15d4:ff65 with SMTP id h9-20020ac85849000000b003bd15d4ff65mr661143qth.40.1676557833583;
        Thu, 16 Feb 2023 06:30:33 -0800 (PST)
X-Google-Smtp-Source: AK7set8XJTsnTm0VaIJmbJX3VcXHUhxxi2M8Gpe8tbPNcNIuLHAOsiSc/znHPpsq3YpeBFeBz2CWkQ==
X-Received: by 2002:ac8:5849:0:b0:3bd:15d4:ff65 with SMTP id h9-20020ac85849000000b003bd15d4ff65mr661093qth.40.1676557833268;
        Thu, 16 Feb 2023 06:30:33 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id k6-20020a378806000000b0073912c099cesm1258386qkd.73.2023.02.16.06.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:30:32 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:30:27 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 06/12] vsock/virtio: non-linear skb handling for
 TAP dev
Message-ID: <20230216143027.yg737u2ndiwwatm2@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <ebee740a-95df-ed52-6274-a9340e8dc9d2@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ebee740a-95df-ed52-6274-a9340e8dc9d2@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 06:59:21AM +0000, Arseniy Krasnov wrote:
>For TAP device new skb is created and data from the current skb is
>copied to it. This adds copying data from non-linear skb to new
>the skb.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 43 +++++++++++++++++++++++--
> 1 file changed, 40 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index a1581c77cf84..05ce97b967ad 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -101,6 +101,39 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 	return NULL;
> }
>
>+static void virtio_transport_copy_nonlinear_skb(struct sk_buff *skb,
>+						void *dst,
>+						size_t len)
>+{
>+	size_t rest_len = len;
>+
>+	while (rest_len && virtio_vsock_skb_has_frags(skb)) {
>+		struct bio_vec *curr_vec;
>+		size_t curr_vec_end;
>+		size_t to_copy;
>+		int curr_frag;
>+		int curr_offs;
>+
>+		curr_frag = VIRTIO_VSOCK_SKB_CB(skb)->curr_frag;
>+		curr_offs = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>+		curr_vec = &skb_shinfo(skb)->frags[curr_frag];
>+
>+		curr_vec_end = curr_vec->bv_offset + curr_vec->bv_len;
>+		to_copy = min(rest_len, (size_t)(curr_vec_end - curr_offs));
>+
>+		memcpy(dst, page_to_virt(curr_vec->bv_page) + curr_offs,
>+		       to_copy);
>+
>+		rest_len -= to_copy;
>+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += to_copy;
>+
>+		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off == (curr_vec_end)) {
>+			VIRTIO_VSOCK_SKB_CB(skb)->curr_frag++;
>+			VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>+		}
>+	}
>+}
>+
> /* Packet capture */
> static struct sk_buff *virtio_transport_build_skb(void *opaque)
> {
>@@ -109,7 +142,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	struct af_vsockmon_hdr *hdr;
> 	struct sk_buff *skb;
> 	size_t payload_len;
>-	void *payload_buf;
>
> 	/* A packet could be split to fit the RX buffer, so we can retrieve
> 	 * the payload length from the header and the buffer pointer taking
>@@ -117,7 +149,6 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	 */
> 	pkt_hdr = virtio_vsock_hdr(pkt);
> 	payload_len = pkt->len;
>-	payload_buf = pkt->data;
>
> 	skb = alloc_skb(sizeof(*hdr) + sizeof(*pkt_hdr) + payload_len,
> 			GFP_ATOMIC);
>@@ -160,7 +191,13 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
> 	skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));
>
> 	if (payload_len) {
>-		skb_put_data(skb, payload_buf, payload_len);
>+		if (skb_is_nonlinear(skb)) {
>+			void *data = skb_put(skb, payload_len);
>+
>+			virtio_transport_copy_nonlinear_skb(skb, data, payload_len);
>+		} else {
>+			skb_put_data(skb, pkt->data, payload_len);
>+		}

Ehm I'm a bit confused. Maybe we need to rename the sk_buffs involved in
this function (pre-existing).

We have `pkt` that is the original sk_buff, and `skb` that it is 
allocated in this function, so IIUC we should check if `pkt` is 
nonlinear and copy its payload into `skb`, so we should do this 
(untested) chage:

@@ -367,10 +367,10 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
         skb_put_data(skb, pkt_hdr, sizeof(*pkt_hdr));

         if (payload_len) {
-               if (skb_is_nonlinear(skb)) {
+               if (skb_is_nonlinear(pkt)) {
                         void *data = skb_put(skb, payload_len);

-                       virtio_transport_copy_nonlinear_skb(skb, data, payload_len);
+                       virtio_transport_copy_nonlinear_skb(pkt, data, payload_len);
                 } else {
                         skb_put_data(skb, pkt->data, payload_len);
                 }

Thanks,
Stefano

> 	}
>
> 	return skb;
>-- 
>2.25.1

