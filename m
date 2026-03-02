Return-Path: <kvm+bounces-72377-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +DQ+JsOhpWmuCAAAu9opvQ
	(envelope-from <kvm+bounces-72377-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:42:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 985681DB0D3
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 15:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A991530608BF
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 14:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2063FFACC;
	Mon,  2 Mar 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FOMo/0SW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qnFcY04Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A025C8EB
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772461867; cv=none; b=qK7fBOptPLnxPccza8g6mAurngBDr54y/JA+8Pqdvj5BPcUlfa/och7gYKvjozGT+70tOjG4bHcF+Ma66oQigRgiYFGO+6C0UEHAgtfbjXeacbZxJHj2p+K+bKsW4NcONOHhx9Ku90/QZlZ2G5++1gYd+8w71Opi7KJUwJc6Oe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772461867; c=relaxed/simple;
	bh=tu6vW5JzAvAhrtnD0Orm8DgWyEhTriU4R1yaRjCyZQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaNlEu0SMr9ij9gKxYvzI7KJaUFZtFTn4ND2O4eOaZjkj+O+/wE58qcQQh3A2BdsTR7DXAHX3nYKRkOL1lmGz3jXR9/JUNxJalc65Y3FcQj0WiJ1fspoRsDUAGzmULV7wwUaDgD6mqxAoeoHpvkEM7AGHSLlqNI0LD/wZqoJRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FOMo/0SW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qnFcY04Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772461864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SKZvtx1jQH7FuclJfSavk4MXL11q6SiX0sIanHFtIBI=;
	b=FOMo/0SWrxVbghAOHZMptVK13+Y0e7xsTsV8DeeSt2FX3pg4vQeSV/MpHKrIZxvE2OzXBq
	KFhTsRyP7KrMgZoq0NxNX9A/3iZUgU2O8HnH8iFQBlTSlwW0obmjkThAmzMhQtWJk95zPL
	4xLVebMK4P1C19/wtcfu61gFUEuRUeU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-xVjns6W4Meiw9xQ3reEYlg-1; Mon, 02 Mar 2026 09:31:03 -0500
X-MC-Unique: xVjns6W4Meiw9xQ3reEYlg-1
X-Mimecast-MFC-AGG-ID: xVjns6W4Meiw9xQ3reEYlg_1772461862
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so56036275e9.2
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 06:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772461862; x=1773066662; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SKZvtx1jQH7FuclJfSavk4MXL11q6SiX0sIanHFtIBI=;
        b=qnFcY04QZhtGR/Q79DN22LxyPSlJMCrxEGWYhXtPkaiY1vh7Y9c6rBygQM/CDxsQIX
         3i60swndx7rl3Qk6IUbhIckBLiwkOVlpweZiLr45Jpx2+7tITucbxrfNgoHlhztRFmHK
         kmWoXXVk7ClcBqvKY+Jt0bFsIkUStT+j40hamsbo9e7Kmxh1tROXFruxzfC4+BNjvA6x
         2HYQyduwO/VpocpHyRj1puBnN8IX+0eYxEPjHXixYKxyLbv/cIf8HRW29sYdEPL+3wrX
         Ek7SnU16GQD6LEhOJf+5qjYsKo8SupWV6SroRzE6tGFgXjYn0mVcHV5c60OJzBEX3nCI
         VBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772461862; x=1773066662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKZvtx1jQH7FuclJfSavk4MXL11q6SiX0sIanHFtIBI=;
        b=MUxJH3REbGhdnuwSPHMR3teyrQTw0Uz8JErnti3qYp5tIiok+WkmQcv/vefNbYYH+s
         iFr0CzbHsbn57yAqdjE/IUG3If7mhcOvhvjxi0lR67bSgvt9FKhHZv0esVGqyy1Zn/mX
         kT1XaJLYEUDAiwBqKO2GdFyyUxVPeKneikZU655K4bjuY6/xaz/a6XxOtxZkK1omhZ9r
         k0OdegfIKRxegbJOdp2/CQeEsrmViJrZCUulM3EtaYeYubnm2e3w+8zfMwSqpjLcBKDZ
         SR7btvCA+oA/1r8lWDxVt3b8jIlx6Kh/YWwigB7v9IqKiIHyGnl+/si1cLmEzhn/RvO/
         88Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXfqAn4ZnhoxQ2UY5CM8GgnU62EE9tZf5j6NPi9gJ7mBUrgIZKeh2o2xD/Fti/rv8+1ZnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl+bnBB2MFrGIgNrBVDjNitnFZUX1e0SkYgFVDhshUJYtR9yfV
	zmDHDGGq2S6GhAaHzVwPawD997zK9S8QCV3t7j12eCWkVWeKRfUKKqM6g1Oj2VTaC8Ia3pdBLWr
	YS0nYbB756+0Nr46n1KvP0vnOWLinl3116HOA/HLDkIUAhj4Ox7J1kw==
X-Gm-Gg: ATEYQzwltArE2rNwmdtJyXtopq8Uhp48TSDC/AOfcxTAn63T97ftkfCnN+al5NMRG0l
	C0Y07dIASgNferud3ieXhyzjx2xt1PBfIK8f4SjmjgPwITl0abB6aYdRDGX+z2MHncPxf5xZl9p
	wK1P0uQ5Ntd5DPySSdbxbcxTlE4KqcWsdduFPN0zfJ37R3WjYiIU6CJqUqr28KiGqBeSNcT7IX7
	9yZ/Q/jOxT0a1rDr3DjWDWR8uCVEmCjBQgAfmIZUMgpRj9n28rAVFiHyGMcZkuKPsMqXTNSnZdX
	jM6N85PfdCgCDkaFkvR7ZkbldoPkSCjP8N2Ma83GB9LCP/DspLqJSKte/o5YsCKubiWEp6iY0Y8
	zIX4DO4aDbeG0I7wk2kvWqxLLx/XP+wpEoFpsWPVxZILCQl4XZJbLRK72M+5lxRYWclKCU+k=
X-Received: by 2002:a05:600c:64c7:b0:47d:73a4:45a7 with SMTP id 5b1f17b1804b1-483c9c19a6emr218449405e9.24.1772461862153;
        Mon, 02 Mar 2026 06:31:02 -0800 (PST)
X-Received: by 2002:a05:600c:64c7:b0:47d:73a4:45a7 with SMTP id 5b1f17b1804b1-483c9c19a6emr218448515e9.24.1772461861478;
        Mon, 02 Mar 2026 06:31:01 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfcb318fsm206220415e9.6.2026.03.02.06.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 06:31:00 -0800 (PST)
Date: Mon, 2 Mar 2026 15:30:53 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, ShuangYu <shuangyu@yunyoo.cc>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC] vhost: fix vhost_get_avail_idx for a non empty ring
Message-ID: <aaWTjPXDqhMZlwLr@sgarzare-redhat>
References: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
X-Rspamd-Queue-Id: 985681DB0D3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72377-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yunyoo.cc:email]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 03:51:49AM -0500, Michael S. Tsirkin wrote:
>vhost_get_avail_idx is supposed to report whether it has updated
>vq->avail_idx. Instead, it returns whether all entries have been
>consumed, which is usually the same. But not always - in
>drivers/vhost/net.c and when mergeable buffers have been enabled, the
>driver checks whether the combined entries are big enough to store an
>incoming packet. If not, the driver re-enables notifications with
>available entries still in the ring. The incorrect return value from
>vhost_get_avail_idx propagates through vhost_enable_notify and causes
>the host to livelock if the guest is not making progress, as vhost will
>immediately disable notifications and retry using the available entries.

Here I'd add something like this just to make it clear the full picture, 
because I spent quite some time to understand how it was related to the 
Fixes tag (which I agree is the right one to use).

   This goes back to commit d3bb267bbdcb ("vhost: cache avail index in
   vhost_enable_notify()") which changed vhost_enable_notify() to compare
   the freshly read avail index against vq->last_avail_idx instead of the
   previously cached vq->avail_idx. Commit 7ad472397667 ("vhost: move
   smp_rmb() into vhost_get_avail_idx()") then carried over the same
   comparison when refactoring vhost_enable_notify() to call the unified
   vhost_get_avail_idx().

>
>The obvious fix is to make vhost_get_avail_idx do what the comment
>says it does and report whether new entries have been added.
>
>Reported-by: ShuangYu <shuangyu@yunyoo.cc>
>Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
>Cc: Stefano Garzarella <sgarzare@redhat.com>
>Cc: Stefan Hajnoczi <stefanha@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>---
>
>Lightly tested, posting early to simplify testing for the reporter.

Tested with vhost-vsock and I didn't see any issue.

Thanks!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> drivers/vhost/vhost.c | 11 +++++++----
> 1 file changed, 7 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>index 2f2c45d20883..db329a6f6145 100644
>--- a/drivers/vhost/vhost.c
>+++ b/drivers/vhost/vhost.c
>@@ -1522,6 +1522,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
> static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
> {
> 	__virtio16 idx;
>+	u16 avail_idx;
> 	int r;
>
> 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
>@@ -1532,17 +1533,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
> 	}
>
> 	/* Check it isn't doing very strange thing with available indexes */
>-	vq->avail_idx = vhost16_to_cpu(vq, idx);
>-	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
>+	avail_idx = vhost16_to_cpu(vq, idx);
>+	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
> 		vq_err(vq, "Invalid available index change from %u to %u",
>-		       vq->last_avail_idx, vq->avail_idx);
>+		       vq->last_avail_idx, avail_idx);
> 		return -EINVAL;
> 	}
>
> 	/* We're done if there is nothing new */
>-	if (vq->avail_idx == vq->last_avail_idx)
>+	if (avail_idx == vq->avail_idx)
> 		return 0;
>
>+	vq->avail_idx = avail_idx;
>+
> 	/*
> 	 * We updated vq->avail_idx so we need a memory barrier between
> 	 * the index read above and the caller reading avail ring entries.
>-- 
>MST
>


