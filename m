Return-Path: <kvm+bounces-40699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F27AA5A48C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D061F168546
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 20:14:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7057B1DE885;
	Mon, 10 Mar 2025 20:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7RP2/Y4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2401D5CDB;
	Mon, 10 Mar 2025 20:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637683; cv=none; b=kXk37g8iNaWrFt+qFtTrpCcKT2SX4YkgsQYwM9Uk0zpur+5cVz5fAiXqv9rHeJIglmEgifoUhmbHoUP7Tt5Uz9PFvqKqbD770/NxIK3lHbYBrut8tFa53aYuXUmi4mxNz8tIP2iuaRpexe0iZOxHpQZemHECxMLlplim9oAP0yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637683; c=relaxed/simple;
	bh=8iEcHXkc9LSURdsHe2A+6jQjFaaSOLr9zyyzvR4j+oM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PrZ4xzy6Ux22+Us+fYJLsK4l1j+02fpEwiFumjkQ51NxdszF83xoPCqX03mY4jYutJElFshfvWTAnZ/94EeLBIApG58aRnk4e5igCtNcj+TDUKUSfWP3qHhDQBp7BDmCIaNT/p0+GUol/cBO4/c0ViHKoeaA7VuRsXprmTrHZUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7RP2/Y4; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff6ae7667dso8921017a91.0;
        Mon, 10 Mar 2025 13:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741637681; x=1742242481; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8VCJDvDifH6QKwricJgYOLTAKH9PbYZJOyD+3nB9w8A=;
        b=C7RP2/Y4MS5oFOE67uZDp4SkhsFBw7vn2mbuZIpfDGY3DgLTjew8+fZuqu8btJtf+1
         u3v4kzPDLaLDL6A0cKBunQuf28LyG91QwBVDcfDNB9kyMawnaCyQXieF3TEblI7USBOI
         CPiIO6GzHtb5G9ypo34XS2Cnv7kRtDjyLC+0Z6vRsigHPTEcZiik16dxwAgRggSN2gXD
         tyVDyFYrwhkFBNlTedb2M5mSDWwU8J3QTZ84oSPIWYQLRqkKS5f9iRLSDCiXCdUtp+y1
         rDsGT/OGe5JOoawH/Y1lpaTAqrRYORit6CJGM++mW0Zx4rXI/4BuhxINtIxsK7kYBweR
         Y8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741637681; x=1742242481;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8VCJDvDifH6QKwricJgYOLTAKH9PbYZJOyD+3nB9w8A=;
        b=oXN0qLHoLewyyjqV1DnXYSr/lrlbbaEEhccnn4i6DxAB0gw/sXSr8TRK2jk+AFAGxI
         kydbc12WqMVGVLA1+h5Y/LPUU8SQ5A37Bhqlrhgfina7lOBOH0k75GVn13tblb5uct7b
         zcUt3YDbOJxMk2FEOk7Xh0H36CGxFYfigbas1dun8Fa3hcfLj2fwJLNNYMZY+l0p5qrp
         SJa4XMGWoceh3OT5YNSgfDl245GCw51dR5CFloyiPsQB57eftBPvzDGl83FKH7qu45F9
         phsmDHKGRg+/E41CbsvPoHcKpBjRfBcP27UpQapBGaCaHbUdII5DQL/hfmCdsiNzZcsP
         Ysqw==
X-Forwarded-Encrypted: i=1; AJvYcCUbWErZBAT+Kgr6ObIqW4bf8pPTmR85VyUieLmKi2XSF52L0nELJABR7qGfzR0/d1DlXGG508mG@vger.kernel.org, AJvYcCVCHqcb2FWYdz6JCiWV8OGPnAmfdQHGe/5ExujT2nPfN1RhoUt2K6L/P4giCIWhnuF36R0UOemdr5CRz3Uf@vger.kernel.org, AJvYcCWCJKLi53YiL1VSC5Dyb+5BtqVBax9HQ8nHkaK5WHG+HAWurifo80avhRUGTBC0hvYmKIXN4rUhOOyn7aqq@vger.kernel.org, AJvYcCXN+qanx1kXOFLmNHH+fyX0Tm7Adpeeeir/btpnRdhEaw0Vfct4xIT4mg1Y7GTFuENOwjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ6rGN7/H+8/cN7woEdD4E3BsCNVGGPMjtU5p0Bt7NBmaFqiQZ
	gJBgVpopDEYqDLIaqmZyF4oAGf4GoyTqyILWNlgu1Fx4Aa69ufc0
X-Gm-Gg: ASbGncvGHXWL5sLZknXle1yntwOjVOIHoovlZdsRuPMcYW73QhRQRMb3D3dLxzzipsx
	k+GH3QIpAL30D+T4mOUHZ62U1uxdas3U/zp8pq23r2y9YWU7skZodlnZWImwLIoy7ouS6XirqnX
	ldRrZyK3Jf4QHjmyn41J1LPzSx/6PP1ocOxNncuEUZZ6nDVzZ0SdD3EXDiRBEc1CCI/LV8arRFq
	PMWa1NyIFsE7R2Q+/V7fjaWmMIEQXhHRuKifZ1GIf8PpyqaL8vs1naDdm5ICXfL3aVYo3GVmZEY
	sjS5Zq3bvuxNMqJRFq+p5ap1jVgvh9ZCMqyq4ZlO/zyJm/d2wqC1TplE2igIWWb3Xw==
X-Google-Smtp-Source: AGHT+IGGtgGnLtHGp5hJ/nBMAaLcHC95KiwN+PXL01qiy3ZPgyM0bcKKidXs9guWID/UnTwOCCd32g==
X-Received: by 2002:a17:90b:1a86:b0:2ee:53b3:3f1c with SMTP id 98e67ed59e1d1-2ff7ce59755mr22191888a91.5.1741637681325;
        Mon, 10 Mar 2025 13:14:41 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:5::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30102709b6asm26289a91.1.2025.03.10.13.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 13:14:40 -0700 (PDT)
Date: Mon, 10 Mar 2025 13:14:38 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, davem@davemloft.net,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-hyperv@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
Message-ID: <Z89ILjEUU12CuVwk@devvm6277.cco0.facebook.com>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com>
 <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com>
 <CACGkMEtTgmFVDU+ftDKEvy31JkV9zLLUv25LrEPKQyzgKiQGSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtTgmFVDU+ftDKEvy31JkV9zLLUv25LrEPKQyzgKiQGSQ@mail.gmail.com>

On Wed, Mar 05, 2025 at 01:46:54PM +0800, Jason Wang wrote:
> On Wed, Mar 5, 2025 at 8:39 AM Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
> >
> > On Tue, Apr 28, 2020 at 06:00:52PM +0200, Stefano Garzarella wrote:
> > > On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> >
> > WRT netdev, do we foresee big gains beyond just leveraging the netdev's
> > namespace?
> 
> It's a leverage of the network subsystem (netdevice, steering, uAPI,
> tracing, probably a lot of others), not only its namespace. It can
> avoid duplicating existing mechanisms in a vsock specific way. If we
> manage to do that, namespace support will be a "byproduct".
> 
[...]
> 
> Yes, it can. I think we need to evaluate both approaches (that's why I
> raise the approach of reusing netdevice). We can hear from others.
> 

I agree it is worth evaluating. If netdev is being considered, then it
is probably also worth considering your suggestion from a few years back
to add these capabilities by building vsock on top of virtio-net [1].

[1] https://lore.kernel.org/all/2747ac1f-390e-99f9-b24e-f179af79a9da@redhat.com/

Considering that the current vsock protocol will only ever be able to
enjoy a restricted feature set of these other net subsystems due to its
lack of tolerance for packet loss (e.g., no multiqueue steering, no
packet scheduling), I wonder if it would be best to a) wait until a user
requires these capabilities, and b) at that point extend vsock to tolerate
packet loss (add a seqnum)?

> >
> > Some other thoughts I had: netdev's flow control features would all have
> > to be ignored or disabled somehow (I think dev_direct_xmit()?), because
> > queueing introduces packet loss and the vsock protocol is unable to
> > survive packet loss.
> 
> Or just allow it and then configuring a qdisc that may drop packets
> could be treated as a misconfiguration.
> 

That is possible, but when I was playing with vsock qdisc the only one
that worked was pfifo_fast/pfifo, as the others that I tested async drop
packets.

Thanks,
Bobby

