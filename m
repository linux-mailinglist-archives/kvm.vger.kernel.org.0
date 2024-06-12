Return-Path: <kvm+bounces-19522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E155905EB8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 00:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0ABF4B20FDA
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 22:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2C012CDB2;
	Wed, 12 Jun 2024 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pv5cYMk2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D92171AF;
	Wed, 12 Jun 2024 22:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718232377; cv=none; b=CeVDcrTlkInbmg8ge3ujchlEOSOi+AK4ydDDV70qzGZvv7qkASlW/a8MtqWdwYGro4ndKoDXzJEXyJEnPLPYeEDR96VG5D+pKWeOzYWpLzLpeX/G3p4WzA6t8Ezp6b+JAt67/QGnDBA7S3z3WuhAHlj9SHPMVRAi06r7sUsC5ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718232377; c=relaxed/simple;
	bh=Btuodt76m2DyYXbGtPV/Vv1FbZvrfNlv6sM+TvESOkI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mr4wSrLBzY+LvHUNidSxsk2dYJcKoqF14XhGe6Mmrb8WapN2OXz2q26PER+rchSFB33LEZ/2tu/fB1FBKAQ9YdiHzOv69eo+TD+XRt+PBqQZVnoMBVVZKkrtubxDeegRlzIilnUuomxBBKpxNUC4adPQrK2mMgeF5zzbSgKOxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pv5cYMk2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0D1C3277B;
	Wed, 12 Jun 2024 22:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718232376;
	bh=Btuodt76m2DyYXbGtPV/Vv1FbZvrfNlv6sM+TvESOkI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pv5cYMk263zMUbCNp36wRXNXl/tjrUmckYYLHcirlYBNB77YB2467Yd4BgJb+Qb4I
	 YqDU+Cm7UNZ7n0MewE6/hilNaJ90Gza1H88RAoEG4A1Y225lvjqc3PekR4aCG22HOa
	 eAQV/usrnBVKHJJd9LkQKe85xRAaEOhB13oBSQNKJekbOzbzkrOMmITPPU9uVAHQrK
	 HrUG2rhIy4WxyzNQbzTF6NPLZ/gIHpC6rSya37s8bzyXL8h6Xw7WfeWxWP+Bz5oMyj
	 5DFBQb/iMdU8+dudcvUFs5V1g2fxaQEsU7q04KgQBDEtVH+9Kij5/LGkrSeYMBe0OP
	 HpewrgqVcBCtw==
Date: Wed, 12 Jun 2024 15:46:15 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
 kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
 linux-trace-kernel@vger.kernel.org, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, "Naveen N. Rao"
 <naveen.n.rao@linux.ibm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Nicholas Piggin <npiggin@gmail.com>,
 netdev@vger.kernel.org, wireguard@lists.zx2c4.com,
 linux-kernel@vger.kernel.org, ecryptfs@vger.kernel.org, Neil Brown
 <neilb@suse.de>, Olga Kornievskaia <kolga@netapp.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 linux-nfs@vger.kernel.org, linux-can@vger.kernel.org, Lai Jiangshan
 <jiangshanlai@gmail.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <20240612154615.21206fea@kernel.org>
In-Reply-To: <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
	<20240612143305.451abf58@kernel.org>
	<baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Jun 2024 15:37:55 -0700 Paul E. McKenney wrote:
> So 05/14, 11/14 and 12/14 are OK and can go ahead.  The rest need some
> help.

Thank you for the breakdown!

