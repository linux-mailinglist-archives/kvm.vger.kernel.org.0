Return-Path: <kvm+bounces-43476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15EDDA90849
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 18:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D1EC188FC04
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:05:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B4A21147B;
	Wed, 16 Apr 2025 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IVpc4FxV"
X-Original-To: kvm@vger.kernel.org
Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54C2191;
	Wed, 16 Apr 2025 16:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819533; cv=none; b=M0qAyfrEATYCTphAtyNR15rb56U1dLWRrnAM7WhIH+h5RhnWpo8OPXrmxIdBh3XhESdBFqochncR32K9oCuk/0BGhmc1oTXSsh8sWIZ6xEMcf89Nrjy7cR4oKPteR+bbmlw8bUtqaDMllhCEIQrIl7jQt7nWb5J2oVDYr8H33ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819533; c=relaxed/simple;
	bh=EhmqrT1n26AMQEMDb1XRZ5HxSAiGsR+p35wieLTxIRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXtb4XNLenJ4ftBjHfhUdwEAlREEfFDDZ89S601MhcC2S9mblwEMFr9kYtnXUZtBgRtYhJwvj7feuZ6lZni55UvaJut0dvWOF2M+Gq0L+knhcRQIUsxBzPhFCxY8ten4CGv72QeEeEyOHaYj6Fx8aTSxTPpuWbKwe5kWS9Iq/Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IVpc4FxV; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Zd5Tk3HCJzm0yVN;
	Wed, 16 Apr 2025 16:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744819525; x=1747411526; bh=4rA+OYQ/k01wwgm+jiFIFEx4
	hVYW6A62leL4CloUvtI=; b=IVpc4FxVxUl02nZnmIlRB8AfWVTQcXcDjI7g+qLS
	XSxRkVoM0SzjfHxAHdZabaGZYOhmKcE9S4Zu7Rvcsn2X1WMsxibhKmgF3d9pNm8B
	NLN3WRWoJBbLlzgpb+QDeVVYCNQ0WrSBzGhpEfENba7fXOJEe7ITKb2+L6NBxzqk
	WDLbgWblz4anjLuvefXnDadn1gWFq2NicjUStiM/py12gk9I0H6Clg9kjgeMilu8
	wjIHxV7rDmHF0QYAYemBOoWoWHBWfkfpoE1/Jg9FgZhPG/UrrIa5SeZP31NbUL1J
	ZVjskPOWJSo/jiJ3j8sXD5O3ynk+tekn5+d96iFunAf0Qw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 76cUTHYzIjV1; Wed, 16 Apr 2025 16:05:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Zd5T91lhkzm0djk;
	Wed, 16 Apr 2025 16:05:00 +0000 (UTC)
Message-ID: <bb713790-0b68-4d91-831c-b18fa1ea01a9@acm.org>
Date: Wed, 16 Apr 2025 09:04:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 5/5] lib/Kconfig.debug: introduce
 CONFIG_NO_AUTO_INLINE
To: chenlinxuan@uniontech.com, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Andrew Morton <akpm@linux-foundation.org>,
 Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>, Peter Huewe
 <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kvm@vger.kernel.org, virtualization@lists.linux.dev,
 linux-integrity@vger.kernel.org, linux-kbuild@vger.kernel.org,
 llvm@lists.linux.dev, Winston Wen <wentao@uniontech.com>,
 Changbin Du <changbin.du@intel.com>
References: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
 <20250416-noautoinline-v2-5-e69a2717530f@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250416-noautoinline-v2-5-e69a2717530f@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 2:44 AM, Chen Linxuan via B4 Relay wrote:
> 2. Make it depends on X86 and LOONGARCH,
>     as I haven't test other architectures

That sounds weird to me. Shouldn't this option be made architecture-
independent?

> +config NO_AUTO_INLINE
> +	bool "Disable compiler auto-inline optimizations (EXPERIMENTAL)"
> +	default n
> +	depends on CC_IS_GCC && (X86 || LOONGARCH)

Why "depends on CC_IS_GCC"? Please make sure that both gcc and clang are
supported.

Thanks,

Bart.

