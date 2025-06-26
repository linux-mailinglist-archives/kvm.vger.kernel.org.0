Return-Path: <kvm+bounces-50789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A996EAE9506
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF4677B206E
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 05:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3834218AAA;
	Thu, 26 Jun 2025 05:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcpcWR5M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3ED2F1FF6;
	Thu, 26 Jun 2025 05:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750914155; cv=none; b=f7/hRX9QOkuf1+/efGZF0AUSEqvPsUumb0W0/8NnmwDqJbq+dE5Gfdrn59SIPMACHfpz+6IfJp506yncXGyveS/h0hPnr5NozpQVvFLmSa2vDqkIdD01dhbAcNtQkAjtO+1GZ0hTWgikIXQyRWp/9ZZebdEWUuJsWhHur15gZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750914155; c=relaxed/simple;
	bh=NH4j2FqqJw6bDqDteI6k4MIVpp4cPtz23hroizXPlvg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PCbe2tKSE5DQevg3LzqdhKAdfBLVtesSnEjcO7dSLHBPTPp4kXbEW+daNke1RDVx7xVRzANHBpLwz5kgoD+HSFe5KCzG92MCpLVZpBd6FpTZ1qWxQ8pL4bOH2xdK1mKr2WmjOVcm6aM1UA87Ay9oRMOqcr80vNMqDRYFI11beYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcpcWR5M; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7424ccbef4eso673579b3a.2;
        Wed, 25 Jun 2025 22:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750914153; x=1751518953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAbqyCTcegVpKrpjqoB86gZ0JnTtn6KDYt9zM32bdZE=;
        b=bcpcWR5M3AbwF3cSEch97CJTX+bv9Idx/fahmsQMiMUPiOWPIiNAqLhydxW0eqPXAB
         Jk3KrtI1fHjmklEMzcb6cOW7sr2Vq5wVeNnOIkZYn01Bb+3j6xxzilFtD7raA9UNeW6R
         Tj4ByjicGgUd2/nk6IHAnTKFgPAqccK4EYVY+Ghclp1XjuZY1MmvKBMfTdu7+oxYeJ7s
         AiyCRWELRD1jpAbaoYoMWopDrbcgb561dic5yMAA8n/NwgU1pMRkL8QbJFwm5mM/Fl22
         EJf2bf3sW/hIp4pYlKE4cTWEjwtaMn2H1xM8OEYAabfXfVgfAQozJYZUF6UM1bjbubDB
         W4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750914153; x=1751518953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pAbqyCTcegVpKrpjqoB86gZ0JnTtn6KDYt9zM32bdZE=;
        b=Tot2/1cxsPgQJVuaSkq9Ar1WjEZWl5bFmZTbzSXFQah+sOlowRixebXXbldsUlRznN
         Cl3yvoyyJHWrOom2Bw6cc/tLiMkRqmhhxWYk+LA1T6DzXlboo8dzDfCTIAXUeFK2draq
         1gTUbBcLrUvFo8DwrQftSjC7ebE26lYogF5XxPC2ZAYsErNf6I+BpP5m0rf7BypgWsjf
         MmO4xmN4TMeuBiMflMVMaTUVAtUStPCiURaMABe+rl+kCC3wQaG/kwGsKB7E7JRHbiYN
         GjylCnEHCBx911P3krB8wv9/1Qdy+/MotmZNgwTdJQZs6nemIYIVMMc/TCt/2C3ziBs9
         qj1w==
X-Forwarded-Encrypted: i=1; AJvYcCUDTMroJWp3XTDeYH/dyEYV1zmEBYjyiMGuaxJlHcEC4ApS9g8nbW/YeSxxjs+W6Hl5gT1s9iEK@vger.kernel.org, AJvYcCUhWlZxPqY5+QfuFNrL2KQHrtacYZibe/BvKztwNRJGi/bIODkV0GbJ60Oxhg3zn774G0jNf/xK+IsLG4eL@vger.kernel.org, AJvYcCWBc+Lc0zpMMtO7WhtgTDbqwxt/J6CRsgizCHIoYEVJjldihy72p4H5n1pl2qGTtrkfJzICZ6WbE2LNxBYc@vger.kernel.org, AJvYcCWrUy3fYqkfNP/9XAkjFYjfJ6lybQZGGtKSXqYZxeQe5F5x1oiD4Dbw6daWQtiGQiCwaR4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQh9UfwXUscZ5QAah/XFMaeHlp0tONeOGhosGBNOY9IgB6ZtTK
	r2QqCwLou3JufIYh529j7p6zbWgQ9zk4pZ6gwcVYy8/Pk4byugkgkaJS
X-Gm-Gg: ASbGncvkk+RBb0biR2kkSqcDvtAJ0Wg/2McPmCTODubMmKFBy4P8O90Hj29vfHEYA8S
	m5/f4Xt/C0YBMfa1V1gZrRgotYpFMjKBbaAlmUXy5uxBL92Y9seR+FwhQtP0lrHR+anO3cZo5Tw
	vV8kyZrBTNEqfJzLdAm05bFyd/3HF4VVjC4vJxBiE+D2I5+M88CeTIqAKIt1MnoiRuofkYMFJIW
	eSu3yRoCQOQHjoyeEUNwQoQcatRAIBTSmCuqHmWg/hT6Jj7YVjMfcaHJGftqgl1NX/KgGcEfIm6
	3ng8RbDGfKGSEB/t5sAF+GZoWh4cT1xkQwa7yaQypkzSWQ1RCI7lqlyh8cPhurFHyQrHKTCKTMJ
	JGSBIfRzv
X-Google-Smtp-Source: AGHT+IGX8J1VxZS2sFcA0G08BiW/FQ1pEDJzIhrYph3nSUl3wWFtXA7FYdmCcKqPVRcKXEU4f7ucWw==
X-Received: by 2002:a05:6300:4041:b0:220:3ab2:b50e with SMTP id adf61e73a8af0-2207f154d7cmr9460458637.6.1750914152614;
        Wed, 25 Jun 2025 22:02:32 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749b5e211d1sm5842808b3a.44.2025.06.25.22.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 22:02:32 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	decui@microsoft.com,
	fupan.lfp@antgroup.com,
	haiyangz@microsoft.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	kys@microsoft.com,
	leonardi@redhat.com,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	wei.liu@kernel.org,
	xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Date: Thu, 26 Jun 2025 13:02:19 +0800
Message-Id: <20250626050219.1847316-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
References: <wgyxcpcsnpsta65q4n7pekw2hbedrbzqgtevkzqaqkjrqfjlyo@6jod5pw75lyf>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Wed, Jun 25, 2025 at 08:03:00AM +0000, Dexuan Cui wrote:
> >> From: Stefano Garzarella <sgarzare@redhat.com>
> >> Sent: Tuesday, June 17, 2025 7:39 AM
> >>  ...
> >> Now looks better to me, I just checked transports: vmci and virtio/vhost
> >> returns what we want, but for hyperv we have:
> >>
> >> 	static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> >> 	{
> >> 		struct hvsock *hvs = vsk->trans;
> >> 		s64 ret;
> >>
> >> 		if (hvs->recv_data_len > 0)
> >> 			return 1;
> >>
> >> @Hyper-v maintainers: do you know why we don't return `recv_data_len`?
> >
> >Sorry for the late response!  This is the complete code of the function:
> >
> >static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> >{
> >        struct hvsock *hvs = vsk->trans;
> >        s64 ret;
> >
> >        if (hvs->recv_data_len > 0)
> >                return 1;
> >
> >        switch (hvs_channel_readable_payload(hvs->chan)) {
> >        case 1:
> >                ret = 1;
> >                break;
> >        case 0:
> >                vsk->peer_shutdown |= SEND_SHUTDOWN;
> >                ret = 0;
> >                break;
> >        default: /* -1 */
> >                ret = 0;
> >                break;
> >        }
> >
> >        return ret;
> >}
> >
> >If (hvs->recv_data_len > 0), I think we can return hvs->recv_data_len here.
> >
> >If hvs->recv_data_len is 0, and hvs_channel_readable_payload(hvs->chan)
> >returns 1, we should not return hvs->recv_data_len (which is 0 here), 
> >and it's
> >not very easy to find how many bytes of payload in total is available right now:
> >each host-to-guest "packet" in the VMBus channel ringbuffer has a header
> >(which is not part of the payload data) and a trailing padding field, and we
> >would have to iterate on all the "packets" (or at least the next
> >"packet"?) to find the exact bytes of pending payload. Please see
> >hvs_stream_dequeue() for details.
> >
> >Ideally hvs_stream_has_data() should return the exact length of pending
> >readable payload, but when the hv_sock code was written in 2017,
> >vsock_stream_has_data() -> ... -> hvs_stream_has_data() basically only needs
> >to know whether there is any data or not, i.e. it's kind of a boolean variable, so
> >hvs_stream_has_data() was written to return 1 or 0 for simplicity. :-)
> 
> Yeah, I see, thanks for the details! :-)
> 
> >
> >I can post the patch below (not tested yet) to fix hvs_stream_has_data() by
> >returning the payload length of the next single "packet".  Does it look good
> >to you?
> 
> Yep, LGTM! Can be a best effort IMO.
> 
> Maybe when you have it tested, post it here as proper patch, and Xuewei 
> can include it in the next version of this series (of course with you as 
> author, etc.). In this way will be easy to test/merge, since they are 
> related.
> 
> @Xuewei @Dexuan Is it okay for you?

Yeah, sounds good to me!

Thanks,
Xuewei

> Thanks,
> Stefano
> 
> >
> >--- a/net/vmw_vsock/hyperv_transport.c
> >+++ b/net/vmw_vsock/hyperv_transport.c
> >@@ -694,15 +694,25 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
> > static s64 hvs_stream_has_data(struct vsock_sock *vsk)
> > {
> >        struct hvsock *hvs = vsk->trans;
> >+       bool need_refill = !hvs->recv_desc;
> >        s64 ret;
> >
> >        if (hvs->recv_data_len > 0)
> >-               return 1;
> >+               return hvs->recv_data_len;
> >
> >        switch (hvs_channel_readable_payload(hvs->chan)) {
> >        case 1:
> >-               ret = 1;
> >-               break;
> >+               if (!need_refill)
> >+                       return -EIO;
> >+
> >+               hvs->recv_desc = hv_pkt_iter_first(hvs->chan);
> >+               if (!hvs->recv_desc)
> >+                       return -ENOBUFS;
> >+
> >+               ret = hvs_update_recv_data(hvs);
> >+               if (ret)
> >+                       return ret;
> >+               return hvs->recv_data_len;
> >        case 0:
> >                vsk->peer_shutdown |= SEND_SHUTDOWN;
> >                ret = 0;
> >
> >Thanks,
> >Dexuan

