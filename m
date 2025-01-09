Return-Path: <kvm+bounces-34894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98970A070E6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CA1E188A8DF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF39C2153ED;
	Thu,  9 Jan 2025 09:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ie5/3TU2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A1215196
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 09:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736413638; cv=none; b=OBKlfM0MttaUSFqf67XKrrBTFuvDtzSnxGEhAOvQm+nm7qrFukTeG3caTT908fypQCLMn+04/V4BBIG9coCB/Q5nJXSV+s7Z4kAMdmmy64v3rS5cROymNMV/VDjwEcDd5A5wVB7znfgCt+qnFuPeKRZhEzfX4GPOxYJJy+RCZUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736413638; c=relaxed/simple;
	bh=HsTQiavqafw6fsPYuIFsCx4ppw/0+dyJq2Ei9ZnXIns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IoPeVG/Am7uXLix977owzfLyZZjDBdwBXNb2bSYqe6jmvc2FWycW7/tjC3pv/gimzUmVrdjYfbGaPVZPwGfqQ66U2DhfVgoF3nWtqaSfg7vLBlUyO1IgH7HlCddpkCosLoMCxvgasNq043kwYPrOI8iAYWU1qcqtNHhdXDrn3ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ie5/3TU2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736413635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lPmn2NONYx2YB/n7h2bXDX/3a64ALTC7JSKNR4FIJZA=;
	b=Ie5/3TU2gl5N0z8RdTmVH7HbawsmN3ieqkLThcG33+pjWlJXbZnI1s4yftT8mCRmldCxtK
	2Ade9OrFPFEMW/ZnmWojkGxHXFtJfxH3qNi/AIdspXbMr+9LSeTS7jhw2A801XIRtQnlUm
	sUwQb/XbCJTiiuel+EwehP7jgnQJQ5U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-dXiBjLkIPPqYazef_sL_lg-1; Thu, 09 Jan 2025 04:07:12 -0500
X-MC-Unique: dXiBjLkIPPqYazef_sL_lg-1
X-Mimecast-MFC-AGG-ID: dXiBjLkIPPqYazef_sL_lg
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa689b88293so70132166b.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 01:07:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736413631; x=1737018431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lPmn2NONYx2YB/n7h2bXDX/3a64ALTC7JSKNR4FIJZA=;
        b=l/YgXzs/M5r2QyO71/ftKOYT4DrpfIwt2i2yaOd0WJBCp61tOEpASPfQovY/j3yD27
         /236LqgcHHm3/q2E97Dtsko7K1KanIPn7amezF6ZVz59GrTh7JMwrvNCzwpCW4Cqfkow
         T3Ma/HnBd55H/AIqw7uB9JeeVtrv0z82Ps+vQkB2o90epAJvSvEdCMBcCwEYC1J3XAUu
         XQdE0qMgHxTnB9iC3NKo6ZuCahiRKmN1IuaRtLSk0ntVtvsD4gUb0qO6abIW39YZss6N
         1GMAnxfWKiZkxfDjSj0qYeo45glPaME82J+7SVYWA1TS97BNA9EXIWttjLzA2bd3UQLE
         uPkw==
X-Forwarded-Encrypted: i=1; AJvYcCVUGyCCVndG2is6JV6oIKkjPtyaZu+JD79dIeXtaFU+4LqnrGsD+Y9AKliXIaCgZ9/V4VY=@vger.kernel.org
X-Gm-Message-State: AOJu0YybSRAKQwvCN8mLGAC5to0XsN8kT6023Q5qdqyEgS/fVqeSsIvN
	Gvl8bfii5kQJ4+FzBLPhhiPx3KbzoTVQYVuIxXG+iyjljH77CokIl6BLux/FI4ukUr2GTLJghm3
	8gp/XGyUTN0P1yttP6glaQOIdxmkro+VYsrP5JvhCuie8UvJT1g==
X-Gm-Gg: ASbGncud15O6q+D5e98/nWlWEja+G3TkHvI6k4ekKmxMbY0RNt2TfA5VdMczRfwh5YJ
	0z547ptL1NauleXYW9Kj5QfyAs6NR5/JRfrVEEYOdxONeGaknjZBaD1b6FrSRJ06zTBvFyLSxa+
	3C5XYjI1h4F8BtAXosHUfKPWMeUqJId+9HxWMkH6P648tIBd8DeaRYDhKOANVM1qEyYTFwFyfDY
	E4lcIozvEEFfmO9RJhdq30xceJoEM0gF6ViHXCEXy3uIVC8fPA=
X-Received: by 2002:a17:906:d555:b0:aa6:7b34:c1a8 with SMTP id a640c23a62f3a-ab2ab70a5a8mr454045166b.55.1736413631092;
        Thu, 09 Jan 2025 01:07:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOH7lCleOA3s9UpH750ljDgjJhUOcglbcfKRJdkkDK27qUK57limO+sZa7nGGHTPfbFQQXdg==
X-Received: by 2002:a17:906:d555:b0:aa6:7b34:c1a8 with SMTP id a640c23a62f3a-ab2ab70a5a8mr454042766b.55.1736413630614;
        Thu, 09 Jan 2025 01:07:10 -0800 (PST)
Received: from redhat.com ([2a02:14f:175:d62d:93ef:d7e2:e7da:ed72])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c95af65dsm49782566b.140.2025.01.09.01.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 01:07:09 -0800 (PST)
Date: Thu, 9 Jan 2025 04:07:03 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Wongi Lee <qwerty@theori.io>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	virtualization@lists.linux.dev,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>, bpf@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, Hyunwoo Kim <v4bel@theori.io>,
	Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Subject: Re: [PATCH net 2/2] vsock/bpf: return early if transport is not
 assigned
Message-ID: <20250109040628-mutt-send-email-mst@kernel.org>
References: <20250108180617.154053-1-sgarzare@redhat.com>
 <20250108180617.154053-3-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108180617.154053-3-sgarzare@redhat.com>

On Wed, Jan 08, 2025 at 07:06:17PM +0100, Stefano Garzarella wrote:
> Some of the core functions can only be called if the transport
> has been assigned.
> 
> As Michal reported, a socket might have the transport at NULL,
> for example after a failed connect(), causing the following trace:
> 
>     BUG: kernel NULL pointer dereference, address: 00000000000000a0
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 12faf8067 P4D 12faf8067 PUD 113670067 PMD 0
>     Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
>     CPU: 15 UID: 0 PID: 1198 Comm: a.out Not tainted 6.13.0-rc2+
>     RIP: 0010:vsock_connectible_has_data+0x1f/0x40
>     Call Trace:
>      vsock_bpf_recvmsg+0xca/0x5e0
>      sock_recvmsg+0xb9/0xc0
>      __sys_recvfrom+0xb3/0x130
>      __x64_sys_recvfrom+0x20/0x30
>      do_syscall_64+0x93/0x180
>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> So we need to check the `vsk->transport` in vsock_bpf_recvmsg(),
> especially for connected sockets (stream/seqpacket) as we already
> do in __vsock_connectible_recvmsg().
> 
> Fixes: 634f1a7110b4 ("vsock: support sockmap")
> Reported-by: Michal Luczaj <mhal@rbox.co>
> Closes: https://lore.kernel.org/netdev/5ca20d4c-1017-49c2-9516-f6f75fd331e9@rbox.co/
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>



> ---
>  net/vmw_vsock/vsock_bpf.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/vmw_vsock/vsock_bpf.c b/net/vmw_vsock/vsock_bpf.c
> index 4aa6e74ec295..f201d9eca1df 100644
> --- a/net/vmw_vsock/vsock_bpf.c
> +++ b/net/vmw_vsock/vsock_bpf.c
> @@ -77,6 +77,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  			     size_t len, int flags, int *addr_len)
>  {
>  	struct sk_psock *psock;
> +	struct vsock_sock *vsk;
>  	int copied;
>  
>  	psock = sk_psock_get(sk);
> @@ -84,6 +85,13 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		return __vsock_recvmsg(sk, msg, len, flags);
>  
>  	lock_sock(sk);
> +	vsk = vsock_sk(sk);
> +
> +	if (!vsk->transport) {
> +		copied = -ENODEV;
> +		goto out;
> +	}
> +
>  	if (vsock_has_data(sk, psock) && sk_psock_queue_empty(psock)) {
>  		release_sock(sk);
>  		sk_psock_put(sk, psock);
> @@ -108,6 +116,7 @@ static int vsock_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
>  		copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
>  	}
>  
> +out:
>  	release_sock(sk);
>  	sk_psock_put(sk, psock);
>  
> -- 
> 2.47.1


