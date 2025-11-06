Return-Path: <kvm+bounces-62213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 43EF6C3C60B
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BDDB334F39B
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DA2350A3E;
	Thu,  6 Nov 2025 16:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfDBE7l4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VymvqmNg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20172350A14
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445818; cv=none; b=tymy+UiV4bwQMbYNLzWsMmM5CaW2gkrnYMKX2zIjQ543F/F4nG8PZQ/NG/h7x4u7QcWHXGBuDcob9uSrFm3CTpsEii6RSnxFotVJsd2pC56vVNyqPkqJBE3HzUETG63/bqFgR6Ot2kk4Jgi2JFmJdpw15bhcbw1nn8lJW63B7Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445818; c=relaxed/simple;
	bh=Z7eSKPc3txhBUxRtndXMLROsssDroOhR9kPjB1j/JTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVKHUfndvWS3afTIGu+NJLwK5IWW8q812CUVRgmb3ocCrjGg9m4VilR1b8rjO65w9VfSNcQ0Qusk7QUzeLAPN6xz5NsW96Q8ofsoY2kY5Rs0VvFGE+ObR7LLyeHFSfQBypRiiFnyvQisdozBfd4lZoVffOIJC0Vm+II1j9b5wEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfDBE7l4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VymvqmNg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762445814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9tCanlI7uiN2snt10ROgiGSCHaaEX2aQy3SErwtUYP8=;
	b=PfDBE7l4+UGFjRYCXMFjnk7zcd9wT55BuAfciLIJe/QKAIq4Pyfv1iup7F1wcERPQ7EPhM
	mrmwxKAhBP2KrbX4uqzqxzl3sIphh6dhkTEujwA8Q2+yNTEIJWiWaFgQJnIcB9A6LKvvSM
	eKzw8mKxJi8mfdu1V1ajuvFc5zYNPgU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-x5ca5XZkOmiL8nwY8RymQQ-1; Thu, 06 Nov 2025 11:16:53 -0500
X-MC-Unique: x5ca5XZkOmiL8nwY8RymQQ-1
X-Mimecast-MFC-AGG-ID: x5ca5XZkOmiL8nwY8RymQQ_1762445813
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477171bbf51so8605805e9.3
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762445812; x=1763050612; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tCanlI7uiN2snt10ROgiGSCHaaEX2aQy3SErwtUYP8=;
        b=VymvqmNg37y7eS2CDMedoy/aiAdzCNcQO87H+g09/o6vS7bajlOfh61Na8jNasEcVJ
         r3TTVcdnMz462HK3JQM+Gv/tA6qdQMLyapqammQItHrgHNpMRbbmhDDuRvjA8s6G3sex
         rfGJyPY7TeB6WRfQqAyNc+N+bwIVwsURvQf54EiF/GmhyOKUXzNfgI02JUDVei/8FB0t
         6AEJdGsohKvsfqoSA8iXHUs+ReG7y57B8KBmUWyeFZhG3ghv6AnQ0L/BvlpfodwqMW5o
         sjWHsdySeJYbUo5czTerygXBXvqWCwiDjR+G4cjPKsYX+2jSpUKNoN2eCLcZadHrOn6X
         yUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762445812; x=1763050612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tCanlI7uiN2snt10ROgiGSCHaaEX2aQy3SErwtUYP8=;
        b=VqPc0eY2Okot5D0FpSqoQvZsL82AZl8GIMao5KkEL0s9hhv1xYnVywwbr766oIFep0
         acdLBbgippP+wjauoryOBzdHH7rir/98suRmtIgO53PwzC08gDOJQcPPYf9/iKKA3VS6
         lViboP0C2Qi8wl44gk2+6DEqXyvH6qrW8MMUuU9VhGyNl/Zac4QcIcnzDrDvRqfZFDUN
         tvLdtlN97LPdS84hmjZY84WV801t6IO2k7/UmDnAgG1o+1QU7Qx1Kzcu+5CWY08IHtiP
         0mxpmkEUkXWN/cJxMrY+0APQwZlej+gFaXVkDysZwX9d7NkZ5laYWwyuo10IiKqbi5zf
         Ng8g==
X-Forwarded-Encrypted: i=1; AJvYcCXz2r2nr0W65xU2oAkhSYcci6PTVKr9uIh3OEGmq7RzM0GdHfocw9mKWjWirvxg7aBV+kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEGS3Act+Ett5LZ4YD0OTGTWZWDSMa9P+h4QXS3eZfzSr7elG5
	cP2OrUQbtTPgL81i0kbxKTlRAP5Yfo+6wTZFUcPqXHk6OCIRA2sijXs94JdkXnChN4XWOXDVzkT
	h6WMgbLGs1cOWw0e7cOD4jsAB9MexyE0bzW+9KVBTF/RcBkfFk5VEiw==
X-Gm-Gg: ASbGncvhToIAN9bBT53iD1qlXKk+gOTYtCHjS14Q4vJX95hmS4UG0FeeKkg2lUWnzIv
	2X1ZOw38qtiPY7XYhr3xv9UsmRGYICLXLtOrqLt2BZv8TcMyyuikLCEChXLxHHNm+mOZZ34Inls
	OHW0cwWj4JOZTrERi0SNcMZu3d89XvipjxrPopY+q/YBikdOPTFbt5vGZj8uUxt+0WdiT5QhfFn
	Sg8+DoIksYNWUfiPh7NJaIvMlsYwvIIr/lCaixTqh4Bn3gP1ElHG+Stc/V9BlUTJ3sMl2xE4mvs
	ddsBfchkBVKWSzIBBVBgIaOHHIJiXpFR5BoCWZcjv8mX9DTupBvn0npkkaRPrfwgGuWesmRdlTV
	RXg==
X-Received: by 2002:a05:600c:8216:b0:477:10c4:b4e with SMTP id 5b1f17b1804b1-4775ce208a3mr70634115e9.41.1762445812530;
        Thu, 06 Nov 2025 08:16:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEW3IYi/YdprfC2n+fzLAs5f0/Jy2gRulDCDLn2/BkchwC+aok0NFWkDfKX3ED9iPmszk8KKA==
X-Received: by 2002:a05:600c:8216:b0:477:10c4:b4e with SMTP id 5b1f17b1804b1-4775ce208a3mr70633685e9.41.1762445812098;
        Thu, 06 Nov 2025 08:16:52 -0800 (PST)
Received: from sgarzare-redhat ([78.209.9.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477625c2fb8sm54077105e9.10.2025.11.06.08.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 08:16:51 -0800 (PST)
Date: Thu, 6 Nov 2025 17:16:46 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v8 02/14] vsock/virtio: pack struct
 virtio_vsock_skb_cb
Message-ID: <ruxocfuprofj3mktmjulqy5dhnzkbad3fetqrg2f6kw4gh4wwj@x2mb2dw7pjk5>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
 <20251023-vsock-vmtest-v8-2-dea984d02bb0@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251023-vsock-vmtest-v8-2-dea984d02bb0@meta.com>

On Thu, Oct 23, 2025 at 11:27:41AM -0700, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Reduce holes in struct virtio_vsock_skb_cb. As this struct continues to
>grow, we want to keep it trimmed down so it doesn't exceed the size of
>skb->cb (currently 48 bytes). Eliminating the 2 byte hole provides an
>additional two bytes for new fields at the end of the structure. It does
>not shrink the total size, however.
>
>Future work could include combining fields like reply and tap_delivered
>into a single bitfield, but currently doing so will not make the total
>struct size smaller (although, would extend the tail-end padding area by
>one byte).
>
>Before this patch:
>
>struct virtio_vsock_skb_cb {
>	bool                       reply;                /*     0     1 */
>	bool                       tap_delivered;        /*     1     1 */
>
>	/* XXX 2 bytes hole, try to pack */
>
>	u32                        offset;               /*     4     4 */
>
>	/* size: 8, cachelines: 1, members: 3 */
>	/* sum members: 6, holes: 1, sum holes: 2 */
>	/* last cacheline: 8 bytes */
>};
>;
>
>After this patch:
>
>struct virtio_vsock_skb_cb {
>	u32                        offset;               /*     0     4 */
>	bool                       reply;                /*     4     1 */
>	bool                       tap_delivered;        /*     5     1 */
>
>	/* size: 8, cachelines: 1, members: 3 */
>	/* padding: 2 */
>	/* last cacheline: 8 bytes */
>};
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
> include/linux/virtio_vsock.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Yeah, thanks for that!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 0c67543a45c8..87cf4dcac78a 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -10,9 +10,9 @@
> #define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
>
> struct virtio_vsock_skb_cb {
>+	u32 offset;
> 	bool reply;
> 	bool tap_delivered;
>-	u32 offset;
> };
>
> #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
>
>-- 
>2.47.3
>


