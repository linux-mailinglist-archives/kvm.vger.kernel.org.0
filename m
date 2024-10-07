Return-Path: <kvm+bounces-28071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED932993187
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 17:39:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3556C1F20EE3
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 15:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356BF1D95B0;
	Mon,  7 Oct 2024 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ftYgT4KL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D4E1D9323;
	Mon,  7 Oct 2024 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728315562; cv=none; b=YAfODNJ8rBVmRSrpnhdTrewolySjEwFHNO5W9BNXi2cW/zxjgMEvfQ/9FAGqoOuDad79wXxMsaz0RdO36iPGaEacKWZqmetfA0UBdNU1O/i0Yh1Uk0O9KXPczbE3ZREPCnJiSH4Qd7wQRvn8CIm0Amq7NNt81MtVcH5Sx1D26PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728315562; c=relaxed/simple;
	bh=i8/cXsc1P+gY9+tHDTN7Wzho/iAXByDm2MeytdzGq7w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e7tQPjavYTEacwoLwA/kZHVSFJvNvHSQyXK5y0ShVfcxaE37/hIpb88I+CnamLr7C1nlz5qqS8n9XZQicMI/emNB4MZGwKrLJG6rG+i8aE5CrL6yPFV+DKO1eL/323fTW+egIKPymAAgyw7i9dfFgvkF1QFn5zljNb0MD2zMFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ftYgT4KL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3879EC4CEC6;
	Mon,  7 Oct 2024 15:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728315561;
	bh=i8/cXsc1P+gY9+tHDTN7Wzho/iAXByDm2MeytdzGq7w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ftYgT4KLg0yQ2MbRSEnwBq2WnIF78HoWwpVVTi4jIuNwiZjB+iXZdSOCNvSdTFy9B
	 N/YIPETDFS3GpYMeRaLIL7JxOt2yW7MXXH+rNIQxbrlX7y+ORDGJWlXF6R8G+6Fyc5
	 h4knRAegAufe/MQtdov0BkL+qVPkfgOoEF8s0Vt7iaS9IXJ7JYa+nBYLvmdk7shfy5
	 BwiUm9Kge7i8OS0Zy68NT3q66BFLrTYe8igKQ7YlM5BZQ/Y4vtYGvr15Gjn1bLxC2E
	 XzU+sVpaaa0XWSfBkP9XZKIog8HHI0VSFXnpAqscEFPvgKxAruuNYIMctRjHNeiegq
	 8w+Js6sQi2WTg==
Date: Mon, 7 Oct 2024 08:39:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, Luigi Leonardi
 <luigi.leonardi@outlook.com>, Jason Wang <jasowang@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Marco Pinna <marco.pinn95@gmail.com>,
 virtualization@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: use GFP_ATOMIC under RCU read lock
Message-ID: <20241007083920.185578a7@kernel.org>
In-Reply-To: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
References: <3fbfb6e871f625f89eb578c7228e127437b1975a.1727876449.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Oct 2024 09:41:42 -0400 Michael S. Tsirkin wrote:
> virtio_transport_send_pkt in now called on transport fast path,
> under RCU read lock. In that case, we have a bug: virtio_add_sgs
> is called with GFP_KERNEL, and might sleep.
> 
> Pass the gfp flags as an argument, and use GFP_ATOMIC on
> the fast path.

Hi Michael! The To: linux-kernel@vger.kernel.org doesn't give much info
on who you expect to apply this ;) Please let us know if you plan to
take it via your own tree, otherwise we'll ship it to Linus on Thu.

