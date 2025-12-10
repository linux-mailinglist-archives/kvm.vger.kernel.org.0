Return-Path: <kvm+bounces-65643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49087CB1A94
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BA07310BA84
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A21243954;
	Wed, 10 Dec 2025 01:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFqKTU/G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6961613AD1C;
	Wed, 10 Dec 2025 01:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331131; cv=none; b=FdB690gMLkd0n1a06DX5V2os942t/wHJ72RLUnqvnOejs4nv+3mx8yDsWeNYSdV/hAn1bvcuzJ8xjcrblaxIHWJGuxEkeHTprzXgLc7cxyAtFud9QUFojGJe7SE27zwuZA26pBSPMBqUc1By+PH4z+5j9/7qS27Lmw3Zc2UUKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331131; c=relaxed/simple;
	bh=pyHBSrg3GctSKsaVwadS9CUZoUETTzkVyFsjnETrJQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQA/L5+drYjWKxayoChOn3fBqZ1OKtXdF3zgcNgTXa1TDpqFMuv9wOpBdlar9gpbmLcuG7B+ONgn6SDdS1ikLWcYCCkrgzlWUkrjRYhG+9tk21pCf5wfO15JApCWl9mWKapWzvD6TLL7sHjI3YDk41k6mpuEvMbTv4KMEmyn3G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFqKTU/G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94272C4CEF5;
	Wed, 10 Dec 2025 01:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765331130;
	bh=pyHBSrg3GctSKsaVwadS9CUZoUETTzkVyFsjnETrJQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eFqKTU/GdBdwZWHZK3NTtaLxr8sZpkHoFHfVhTi/yIDp9kVKasevFHRkMXsOgoQ/A
	 2Ypkx0RGHHJ/J0F+mGqDd4ZyjxMUs4RDdIQBjd6uvQpPLP3tScn+hqmNe31xO5yduF
	 GLn8mHbrYOLBckuWw90jUqUKcdV4cSKEN2g94EoQsbq+m6hpzV3LYaYJfyN35jNPgV
	 ho+vTtDbUU6frsu3ZL7tQ2o62WxQKe/3XbgViTCpB0wXePwfpfPirFlLV/vhEWL+T1
	 2ZPNM0nozFQFrAQhkl5FOIHlfCXx8IFlnswjMaxvZKQHi4+SEOSnJxh6g8CvhG8Hwr
	 8H+cnBUuOhUiA==
Date: Tue, 9 Dec 2025 17:45:24 -0800
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
Message-ID: <20251210014524.GA4128@sol>
References: <20251209022258.4183415-1-maobibo@loongson.cn>
 <20251209022258.4183415-11-maobibo@loongson.cn>
 <20251209232524.GE54030@quark>
 <4ac7b5b9-d819-62b5-1425-0e0b07762120@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ac7b5b9-d819-62b5-1425-0e0b07762120@loongson.cn>

On Wed, Dec 10, 2025 at 09:36:06AM +0800, Bibo Mao wrote:
> 
> 
> On 2025/12/10 上午7:25, Eric Biggers wrote:
> > On Tue, Dec 09, 2025 at 10:22:58AM +0800, Bibo Mao wrote:
> > > ECB AES also is added here, its ivsize is zero and name is different
> > > compared with CBC AES algo.
> > 
> > What is the use case for this feature?Currently qemu builtin backend and
> > openssl afalg only support CBC AES,
> it depends on modified qemu and openssl to test this.
> 
> Maybe this patch adding ECB AES algo can be skipped now, it is just an
> example, the final target is to add SM4 cipher.

There's no need to add useless features.  The title of your patchset is
"crypto: virtio: Add ecb aes algo support".  So it sounds like the main
point of your patchset is to add a useless feature?  If there are
actually unrelated fixes you want, you should send those separately.

As for SM4 support (which mode?), if you really want that (you
shouldn't), why not use the existing CPU accelerated implementation?

- Eric

