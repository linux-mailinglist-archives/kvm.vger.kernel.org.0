Return-Path: <kvm+bounces-6994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02FF483BD29
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7EDF0B2B452
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043CD1C69C;
	Thu, 25 Jan 2024 09:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GGCBO8gM"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDA81BF28
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 09:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706174571; cv=none; b=TBeY4cMLlEphtTAwPoKfWbRIh4Y9y7Zq3IeGhLzOt8/IC/SspHicK0J8WTAPdbWEga16V1VeQ7JzdH8u6OMRtQkJvcPac3kf7C5xmTry+zfmYojpWnaXwzjgE0a0hY/BzC6L4bnzk4e6pVJKKFN0dhBzKWJvvrwXobhq+JmqhWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706174571; c=relaxed/simple;
	bh=K1O/I7raMmvS4c8ezYgM742lJbCbADgntjdDhnkbhk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BW1O1SV5+9XQs4zM6STeXTnuV3pzHyofEtbR4iDCVor6XeW/fooq/WK8ssAxtf3LZIK7cqeNvXpcvkOgPaY6h+iPgW8nuaoLKX0o8PvIscIVjXXzQ+DZd5lY71A06ltu/XP3VC3R6belJHa1RfcEfflQYfLC138xqumdIIz4BD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GGCBO8gM; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 25 Jan 2024 09:22:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706174567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mexG939nLP9vqeQf3vOY4O6oQrMPR7Yk4TbAr6+G5jo=;
	b=GGCBO8gMQJSYBjoLBrc/oGKQBDL06PJcXDERg5UDaLHXFLbJYwC87788jnPhCUdg4OH9cb
	wQFTR8oCyDndad4FiF41cpSncaNuvbDmYOa3CqLUQNXHkaACSh4UWVQHf+kIakVXJBnn8N
	QH9Xi0sonYviwcU5bNsfA2oVCgo4t0E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 12/15] KVM: arm64: vgic-its: Pick cache victim based on
 usage count
Message-ID: <ZbIoYm5GzMNZiZP5@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
 <20240124204909.105952-13-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124204909.105952-13-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Jan 24, 2024 at 08:49:06PM +0000, Oliver Upton wrote:

[...]

> +static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_dist *dist)
> +{
> +	struct vgic_translation_cache_entry *cte, *victim = NULL;
> +	u64 min, tmp;
> +
> +	/*
> +	 * Find the least used cache entry since the last cache miss, preferring
> +	 * older entries in the case of a tie. Note that usage accounting is
> +	 * deliberately non-atomic, so this is all best-effort.
> +	 */

This comment is stale, and does not reflect the fact that I'm very
obviously using atomics below.

-- 
Thanks,
Oliver

