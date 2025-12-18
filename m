Return-Path: <kvm+bounces-66243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9EBCCB22A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 10:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 66D833018E5A
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 09:20:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B4532FA3F;
	Thu, 18 Dec 2025 09:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QlNv8AyZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D/sc6azZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C2C302753
	for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766049596; cv=none; b=RVLoqOvyVoTcI9xQ7If5mFheFLtqM9Ovm79fiJotIbDQEadk+i95fd/9zh/PVs8ehelX5MDed2PZcrcR/JHv6VlK9t9lPt40LbHniHfvwlIeE6mEJ8Pve9RcVwznkHs2unicWDvJiTWLGkv+CwnwFFtxYR4PGvpWlno/HEOFNuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766049596; c=relaxed/simple;
	bh=yt0+W7rSVC5sqG/HWU1LuerYwILbmVgG+28GWJkkJF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJeZKG2nbVaqkV57uvcnEDBMoL8WBNnu4haeyxay6PnxBb4fL50yXoxIjK/A14R5c647bNwcuShs+B1tlWUPLHQsY3zAT5qkl5ACiJwVFsQAfY5Mnfem2QbiGXSRrjmIvens5mcJ6flpVjIJUQKUVi8Cut1+/ENkWqBZ15Jb17s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QlNv8AyZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D/sc6azZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766049593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5DGUhTzB3JPaoSv5rwYKyV5NjPUkuU9Lam+Ho2USOIg=;
	b=QlNv8AyZ9ZoHkZOWKrM5OSEswIn3Qqr8NYIiP3+SRcGQQyeFt8UJuTuHHcMUyhp68G2hHQ
	voaVo4azLE7mveh6Pej2uJ9Y0ztw3TVfrwJNcU8x505nyuv1bkrLw/9vNvoCq7N8zdkT6x
	B0OcKmrhQM61UG8Edaj6RAAr5XfEyz0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-lyGvQlngMfGrCqNtl18Taw-1; Thu, 18 Dec 2025 04:19:51 -0500
X-MC-Unique: lyGvQlngMfGrCqNtl18Taw-1
X-Mimecast-MFC-AGG-ID: lyGvQlngMfGrCqNtl18Taw_1766049590
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b7d282ac8aaso54662766b.2
        for <kvm@vger.kernel.org>; Thu, 18 Dec 2025 01:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766049590; x=1766654390; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5DGUhTzB3JPaoSv5rwYKyV5NjPUkuU9Lam+Ho2USOIg=;
        b=D/sc6azZTLK+fgZQ1JEjLzir+OHU9IRtC3QA0hG85pZrNC26LaYuIxrqFAphgPBLpa
         f/7znE1bFK4X4Sd8Edn0K1YgdzB2lNzoR3X78f1QwfQNqYtCEmLluRM4d4QBYFonZBNv
         cbtTaZ7Tb4QBMwBpR+2U+GUMQsO/xhwHrrrDKJ/CJEBmXRE/12iHGsOyBkJYcQZoYk7/
         g2ldqvTRVXtHPmYCD57k/p2lz8N+pI/ZGqHl/+oP6KWHUxstOGbz5pzmch5bF7NMzLyV
         2XnA/D/YxqoTPCbwSybD6vtpPXllSE7rFIfkmy/MPUYdXKEMXBcBVeaeluT8DVjfg2Vo
         JZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766049590; x=1766654390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5DGUhTzB3JPaoSv5rwYKyV5NjPUkuU9Lam+Ho2USOIg=;
        b=AoOSHvXQEiVvm2Bvuhsn0/N/vNt3iAW+q2zndGlqTvD7lD/2Ju2gjbGsTSovzbRH4r
         gNm443VLWuzZtPdX8NYic7X4aR+apnIi5rMHJ5ucZdF1oArSD2Bhu4pdnMAyvZIu0uBU
         gIM2HXXHMlPK6GgG0tK4z/Tfwk6Qs0DSScrka8BUqRGoVfO//8KVinn26vEyPKyx8IH4
         po6USwuhbq/S8GU8TPXR6Oy0LlfA1gq78+QwTkdzYRCpSJ9TAP1iof0MwZOn9vR81MyW
         mng9Xxxfth5qosyX/wo6FQfysBeGVAma4Lp1arcZNo6nnFwQXPYz158baqqdvBxtcPOh
         3nuQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6sUe12KIE7gyJRe63ojLH7eMW41KvMh570heluz6f2yHuLyqLrOhRjwCCLfDi/Qi228s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhEakQu9WmVPRlW3HbhYVc18VSzrMieSU5iDcvbI/Zv+KUBCfR
	4z/c7fZj05IlVz8r2qAC+FPeHWSEr4a0bJVu2ZFx+fPYBMjUHLX3Unh1HxIOU/alDMvagfxWxFJ
	M8w3W3j+NJG8f2fEXNlXAlGJ92uJyj/ThoQdImr5a3TxLnzUCreAAmw==
X-Gm-Gg: AY/fxX6iNJrQWnQMCqtBdqFwUC8pTPqiMOlvVhPYkiJeO3aYwAzJTeo1fC4g2jkcNUD
	G0rkNMhymmcZnvS1f9fSeh71ubqRi9LF8s59mMK1DsLSA/q1/I5VdgHLqihC4R5pA266ocmCzWx
	d35BT8tXDdSkmxYeZeLuRec6Oy8kxhBKNlqgnNBx5q38Md/38weGtbKpmDPZlLMpx0jz4aB2DgV
	J/Lfibv0ZciEwN0MxHdcUjZjgW1Y90z22NBs0F8+aRB26zgCk/v+q3nmEgHl2Kz1DVO4mqwIhYK
	c0+0ciNeTumMNr4Arawj+inTO9P0ZIACVSiAHpfVZrk+dfeJeBJqey/YpqBaC0CaN73YHbVNq1f
	cjmepr7hmhObq54E=
X-Received: by 2002:a17:907:94c7:b0:b76:b921:d961 with SMTP id a640c23a62f3a-b7d23619397mr2068561266b.2.1766049590078;
        Thu, 18 Dec 2025 01:19:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwBxz8gZtgWPTcDUiRKsVSV+WI8XYHTkiS4tl6rPio3Z5g8v52QwhDNNNXIZbHjAuO8agkcQ==
X-Received: by 2002:a17:907:94c7:b0:b76:b921:d961 with SMTP id a640c23a62f3a-b7d23619397mr2068558266b.2.1766049589503;
        Thu, 18 Dec 2025 01:19:49 -0800 (PST)
Received: from sgarzare-redhat ([193.207.200.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64b58891994sm1894793a12.29.2025.12.18.01.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 01:19:48 -0800 (PST)
Date: Thu, 18 Dec 2025 10:19:42 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: stefanha@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, mst@redhat.com, 
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org
Subject: Re: [PATCH net v4 1/4] vsock/virtio: fix potential underflow in
 virtio_transport_get_credit()
Message-ID: <7oq7ejyud46smrlinz543xrczxyiz5bor62o7xpg6g4eiaa4ad@chcc25mgxc5q>
References: <20251217181206.3681159-1-mlbnkm1@gmail.com>
 <20251217181206.3681159-2-mlbnkm1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251217181206.3681159-2-mlbnkm1@gmail.com>

On Wed, Dec 17, 2025 at 07:12:03PM +0100, Melbin K Mathew wrote:
>The credit calculation in virtio_transport_get_credit() uses unsigned
>arithmetic:
>
>  ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>
>If the peer shrinks its advertised buffer (peer_buf_alloc) while bytes
>are in flight, the subtraction can underflow and produce a large
>positive value, potentially allowing more data to be queued than the
>peer can handle.
>
>Use s64 arithmetic for the subtraction and clamp negative results to
>zero, matching the approach already used in virtio_transport_has_space().
>
>Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")
>Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
>Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 17 ++++++++++++++---
> 1 file changed, 14 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index dcc8a1d5851e..d692b227912d 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -494,14 +494,25 @@ EXPORT_SYMBOL_GPL(virtio_transport_consume_skb_sent);
> u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
> {
> 	u32 ret;
>+	u32 inflight;
>+	s64 bytes;
>
> 	if (!credit)
> 		return 0;
>
> 	spin_lock_bh(&vvs->tx_lock);
>-	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
>-	if (ret > credit)
>-		ret = credit;
>+
>+	/*
>+	 * Compute available space using s64 to avoid underflow if
>+	 * peer_buf_alloc < inflight bytes (can happen if peer shrinks
>+	 * its advertised buffer while data is in flight).
>+	 */
>+	inflight = vvs->tx_cnt - vvs->peer_fwd_cnt;
>+	bytes = (s64)vvs->peer_buf_alloc - inflight;

I'm really confused, in our previous discussion we agreed on re-using
virtio_transport_has_space(), what changend in the mean time?

Stefano

>+	if (bytes < 0)
>+		bytes = 0;
>+
>+	ret = (bytes > credit) ? credit : (u32)bytes;
> 	vvs->tx_cnt += ret;
> 	vvs->bytes_unsent += ret;
> 	spin_unlock_bh(&vvs->tx_lock);
>-- 
>2.34.1
>


