Return-Path: <kvm+bounces-25966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2826996E41C
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 22:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBB2D1F2758E
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 20:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9719A1A2C3D;
	Thu,  5 Sep 2024 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="XjDGhJQS"
X-Original-To: kvm@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7152317623F;
	Thu,  5 Sep 2024 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725568232; cv=none; b=RJZM1ZAPkC+k5XhH3AA9n3chJj76KRZvLGyH/XKVQGkaF4jpNWvSq1kNDnHl+G2p9MYny1IBIghv0Xw6K0SE8MMy6AiSDmhz+X9Q6Gc1MlLmeU/RufaXoFSyPWsilntAhKy/WneJoU5tbbsH0D9BcjZvvbrj8H265rILi23qfFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725568232; c=relaxed/simple;
	bh=hLlYloO5J1K9pI8X2i8QN3FuAA9tOJN5UUnlOrlCvd4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kOCx+rQ9MIj26s+8sMX+dffmVnLPIvesWHLqw2kSxQ3c/k5uobMS3a7CwNCnx94Oe+UeOioRqRJZKQ0w/HicTSD97ROlYVGUoA7nKQijkJfG5DaTtk/qBjXSin/UM5ok4P6+iLu4oTDEap3weDvJGJ04oeq/RrKtDyoYCScSNZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=XjDGhJQS; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 7712542B29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1725568230; bh=EYICUJzOiUjxu7bcKA/cuRv1FEZYbIes1M0Y/sxIaLQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XjDGhJQS4LQ1RUBIbVt3VSqicyb3MsLCo/MgCmHxJJXYTfYFGFQXBPdoXyjGLlxzs
	 TxLX0QimyBhKdV7lcR8Xkk5GMbPpy7Kj2ejpXAHSyr3MvRv31sUIQaIT8YvaBZITdM
	 NOf9Xwrz9syxrdVwc9ZLO4WURVEc84AkVg0VGU9qszUFPia3Sf2UqweeDJNKDDty9e
	 4CapLoNKzvF45yvTzWCdH3TToDy+/Cvd2TrlsF1jIzN7GjF3LVSKRaKFrdYkg4m4Rv
	 oA46MYzAzPmWUCQJ7fE9IxGWc7cc7FNewzDK1oWS0EVO+BvLwlD7DCKVJkeptsETA8
	 4kx799LXzOV1A==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 7712542B29;
	Thu,  5 Sep 2024 20:30:30 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org,
 zenghui.yu@linux.dev
Cc: kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, wangyuli@uniontech.com,
 baimingcong@uniontech.com, Xianglai Li <lixianglai@loongson.cn>, Mingcong
 Bai <jeffbai@aosc.io>, Dandan Zhang <zhangdandan@uniontech.com>
Subject: Re: [PATCH v3] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
In-Reply-To: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
References: <4769C036576F8816+20240828045950.3484113-1-zhangdandan@uniontech.com>
Date: Thu, 05 Sep 2024 14:30:29 -0600
Message-ID: <877cbphmhm.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Dandan Zhang <zhangdandan@uniontech.com> writes:

> From: Bibo Mao <maobibo@loongson.cn>
>
> Add documentation topic for using pv_virt when running as a guest
> on KVM hypervisor.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> Co-developed-by: Mingcong Bai <jeffbai@aosc.io>
> Signed-off-by: Mingcong Bai <jeffbai@aosc.io>
> Link: https://lore.kernel.org/all/5c338084b1bcccc1d57dce9ddb1e7081@aosc.io/
> Signed-off-by: Dandan Zhang <zhangdandan@uniontech.com>
> ---
>  Documentation/virt/kvm/index.rst              |  1 +
>  .../virt/kvm/loongarch/hypercalls.rst         | 89 +++++++++++++++++++
>  Documentation/virt/kvm/loongarch/index.rst    | 10 +++
>  MAINTAINERS                                   |  1 +
>  4 files changed, 101 insertions(+)
>  create mode 100644 Documentation/virt/kvm/loongarch/hypercalls.rst
>  create mode 100644 Documentation/virt/kvm/loongarch/index.rst

So this generates a nifty build error:

> Documentation/virt/kvm/loongarch/hypercalls.rst:46: ERROR: Malformed table.
> Text in column margin in table line 5.
> 
> ========        ================        ================
> Register        IN                      OUT
> ========        ================        ================
> a0              function number         Return  code
> a1              1st     parameter       -
> a2              2nd     parameter       -
> a3              3rd     parameter       -
> a4              4th     parameter       -
> a5              5th     parameter       -
> ========        ================        ================

The "====" bar for the middle column is too short.  *Please* be sure
that the documentation actually builds after you make a change.

I have fixed this and applied the patch.

jon

