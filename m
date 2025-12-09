Return-Path: <kvm+bounces-65631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDD7CB16D9
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 00:27:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45BCE307F8F6
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 23:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A98630147C;
	Tue,  9 Dec 2025 23:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GU8bdFRh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431E21A0BD0;
	Tue,  9 Dec 2025 23:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765322727; cv=none; b=CR+D9SNSu6BAs1MabA/Igps3IMJTTAaJfPMIHya4/itWsvUdqUS0H7jjKLQmPKXbTMIjTkeIKRXa61ucn+VsxxkA5D1rhvqCD4YmuFC07DROuRdMu69MczL7UHJqyzWmPCxMJ/UDm5jztZUTWl5Jc6QpfsvEneiv8rqV/YDS7UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765322727; c=relaxed/simple;
	bh=V2NlAIHt1aH1x9kaP7IIJlACfbh8JGVtUJh3h8xflXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kqwyPH8T5UKhq1iImS9UGb55TzxpeeF0PUEngX0QvnJLH8NRu5nGUWv0xxt1O4mON/ojTGJEHQ6mKAz+/e2bbKtotElgj1eLHsuJN3lpQpA2jlNverPKPumH3C4tQey8vMlZEDABJDoNZRbNSmjxZqwyl8TxolWof4DNZ8PTffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GU8bdFRh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FEAC4CEF5;
	Tue,  9 Dec 2025 23:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765322726;
	bh=V2NlAIHt1aH1x9kaP7IIJlACfbh8JGVtUJh3h8xflXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GU8bdFRhft4RiHUvkpIhH4qO4/QMVJylzjYuY79iELlDbDV9kjX1KRBQInHhc3Xh9
	 z8SojFPLFqWjkjbt2vlPoykG8j2zDJWcF0VeUr8ehpJMyUBjgko6xJWlKtlQx9IEyg
	 8RxCrhimlmWuHofMYLZvV5jwOXe2DGl58ckcS0ZlH1j2Sn0/nOIVIUQQbpLu2WSoNE
	 9su/f635tDByB3zrVxoWB9YHXVRnqcAbogUNt+om6cASN3WfN0F2tLVOAcJCNevX6K
	 iJ47I+PzV5w/YgpYCjKT1U58azb9kIQ7ZgzIi/TBAtvdxBXgfMYWdgWdBQ5o1Gi/Yy
	 ra/lFZ4W7Lvtw==
Date: Tue, 9 Dec 2025 15:25:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/10] crypto: virtio: Add ecb aes algo support
Message-ID: <20251209232524.GE54030@quark>
References: <20251209022258.4183415-1-maobibo@loongson.cn>
 <20251209022258.4183415-11-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209022258.4183415-11-maobibo@loongson.cn>

On Tue, Dec 09, 2025 at 10:22:58AM +0800, Bibo Mao wrote:
> ECB AES also is added here, its ivsize is zero and name is different
> compared with CBC AES algo.

What is the use case for this feature?

- Eric

