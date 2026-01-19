Return-Path: <kvm+bounces-68530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA4DED3B55D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 19:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4116A300A99D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6554132E13E;
	Mon, 19 Jan 2026 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bUDYpU0F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D556218AAB;
	Mon, 19 Jan 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768846658; cv=none; b=IEfjPYdZ1yQHzv8587BT4QLi25OK0U8qf26ucwSG4zL0czS+LdKiwx+iu2EgC1grtHaYpSJfkhqhCb4UYIOwfzsix0jGn2WMiz1iHIXGkAIrqFPnraZTQ8BhodJHQ7Cz8cs959qSgIcJ1eokkNu00JGWcJ37MlhonODw/b8o9Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768846658; c=relaxed/simple;
	bh=kxRAABOS7MoxF8yoHnp9XMEJToBAqJTjNiyf6HxnyrI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dNbd585oqzxzRC5u/HLtJ75v67OSulp6jEW0W/twdhY5CXPho+wX9I1QyX6URlnEn3p7G/xZKEfpaeIKbzmuxnM1ejWDc6LiNfLwDa//BgYetGayMlx4+x51deVZULikFfJKAtOLMn6mJ+jUXipW640htb/evuXe5qA8lYOF8Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bUDYpU0F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE07FC116C6;
	Mon, 19 Jan 2026 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768846656;
	bh=kxRAABOS7MoxF8yoHnp9XMEJToBAqJTjNiyf6HxnyrI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bUDYpU0FS2fV8DWsuGcCibw9+VWnqwtwMXRG0EhaTDjtkGVUvrTDLauqZuY9JWREQ
	 QUkpufGhYayMw5+l+1nBN63KFzAkSjy/+XEN2CX3lHOgDWQjiIENbBoHxbLzxYj+OM
	 /7gzWb2KxNbBhmGnBk1BLO8iDB7qEOAp6kbfaJkrudNJTtfLmBoCdORT8pWnzOGOYM
	 5DNN5bgVS7ZZ3MwSNRNhehALbj/PH6CQqnlP9Gy2Mkl2M032MVyPnkZSLAnB9kV3tA
	 VXBHXvpv/ZdKfaAojdtr8othP31x5fCxbvAtqJEeruFkC2NjarLpPk0JZAHinm9CzG
	 ePM5XMHeVQnKQ==
Date: Mon, 19 Jan 2026 10:17:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev, "Michael S.
 Tsirkin" <mst@redhat.com>, Eugenio =?UTF-8?B?UMOpcmV6?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Abeni
 <pabeni@redhat.com>, kvm@vger.kernel.org, Eric Dumazet
 <edumazet@google.com>, linux-kernel@vger.kernel.org, Jason Wang
 <jasowang@redhat.com>, Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>,
 Simon Horman <horms@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Arseniy Krasnov <AVKrasnov@sberdevices.ru>, Asias He <asias@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH RESEND net v5 0/4] vsock/virtio: fix TX credit handling
Message-ID: <20260119101734.01cbe934@kernel.org>
In-Reply-To: <20260116201517.273302-1-sgarzare@redhat.com>
References: <20260116201517.273302-1-sgarzare@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 16 Jan 2026 21:15:13 +0100 Stefano Garzarella wrote:
> Resend with the right cc (sorry, a mistake on my env)

Please don't resend within 24h unless asked to:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

> The original series was posted by Melbin K Mathew <mlbnkm1@gmail.com> till
> v4: https://lore.kernel.org/netdev/20251217181206.3681159-1-mlbnkm1@gmail.com/
> 
> Since it's a real issue and the original author seems busy, I'm sending
> the v5 fixing my comments but keeping the authorship (and restoring mine
> on patch 2 as reported on v4).

Does not apply to net:

Switched to a new branch 'vsock-virtio-fix-tx-credit-handling'
Applying: vsock/virtio: fix potential underflow in virtio_transport_get_credit()
Applying: vsock/test: fix seqpacket message bounds test
Applying: vsock/virtio: cap TX credit to local buffer size
Applying: vsock/test: add stream TX credit bounds test
error: patch failed: tools/testing/vsock/vsock_test.c:2414
error: tools/testing/vsock/vsock_test.c: patch does not apply
Patch failed at 0004 vsock/test: add stream TX credit bounds test
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config set advice.mergeConflict false"

Did you generate against net-next or there's some mid-air collision?
(if the former please share the resolution for the resulting conflict;))
-- 
pw-bot: cr

