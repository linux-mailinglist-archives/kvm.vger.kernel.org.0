Return-Path: <kvm+bounces-16425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7358B9F3C
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 19:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 303C31F2491D
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB4416F916;
	Thu,  2 May 2024 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iChru80R"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1616FF31
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714669608; cv=none; b=cjaZoy6VgBSURrhEAiUvvDK5asKZTgOTAnmgT424Fpip8AG+YdebNu41Y3bjAE2riwiUoHqYgOXTbtqLy6GVyzF/zpr/EVKvjO3ipCHtCLSgpaBEqT3x0WL5z+TLbU2KQDdwY/hyQpB9JxI2oQIPHJOyoItCAo0uCD9R2Vv8y8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714669608; c=relaxed/simple;
	bh=5vN09ewHBnnQezmxdvtnqRp5HAhnR9Tpg1Dv9XHIcdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pml5CvB5wF0ARVXKqdFQRmjGDCRnskV32/amD1IESH0503PqhQhAVUeEJeBg9g2yo5Axw2Xe+/aGmk4r868J+I5UQ0JeQ2r5dapmOOsMfUDAQ7+vi0b5Uw/+i8hB6v14aW9/PT/tTgMBR88e8GUe0EdG5q3oVPVOvuR3Yn1ZIys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iChru80R; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 2 May 2024 10:06:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714669604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y95e8QMni8vICIQiNcuSVR4z7bE6sagf3Re/gvjO1NE=;
	b=iChru80R4XNRfPJICLXvzw07Nl7QWN2sbnBEgxMbVddeOsFpyLN40UE62rno5pp3ZtwAPE
	zmWIHkhjLO2P+YlAEd3GgWPcWbmqyf2awAskkEXndZGl6FnPWwGCy7Y/ldAKexfvFnJH79
	t8PY3EtqqYO0Z3rEQN8W8TRYR64xAfI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Convert kvm_mpidr_index() to bitmap_gather()
Message-ID: <ZjPIIMfB_QjUvPX3@linux.dev>
References: <20240502154247.3012042-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502154247.3012042-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 04:42:47PM +0100, Marc Zyngier wrote:
> Linux 6.9 has introduced new bitmap manipulation helpers, with
> bitmap_gather() being of special interest, as it does exactly
> what kvm_mpidr_index() is already doing.

Ooo, that's a handy one!

> Make the latter a wrapper around the former.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

