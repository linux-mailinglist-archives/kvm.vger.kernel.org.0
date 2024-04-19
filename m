Return-Path: <kvm+bounces-15354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 749608AB4AD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 20:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13DCF1F229E9
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C078E13AD30;
	Fri, 19 Apr 2024 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oIl4i+W0"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D30213AD16
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713549608; cv=none; b=KqkJN1yWMngqHSBgdbJRLv4EbOQJGJ4bHEybPXmaj1ABtwZbW6mhtc65uliVZbzZ6MiUhKUonGWUYbKVs2hJQ8Cth6maJopwwq1cLYK91Kr1yORBr4RzJy8hDtY/UNTgZufSXhSh88BF+sGxv3yrPOzKnGuNFnEMYCfBpD7JphA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713549608; c=relaxed/simple;
	bh=FYbdPO6nvS8DL8aYkCKuZMeZOTMvF4UldIjjt0A7QgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fyyGkP/WwjpDiTL/0/E3OvLK9S0Yhtzy6qObCORX0+2T8u8LLZeif1ihu2l1UM7Bi1ENVYwjZjTIaGSNsvSYkDTt94nIvsz+EQCr3qFML67gVkaEaCyWpko0pDC4sjOa7neLEzsRA6vWV9R/p2zp8H0NxZUfj7r/b/rdpvrP7xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oIl4i+W0; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 19 Apr 2024 17:59:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713549605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOSmujKg3qWQnKj2ty5CaYpgKVLjxCFMsEg1pbjGs8o=;
	b=oIl4i+W06hKJLo+dQTSLUy6UUyvNZmtaXjJWsqvx9uRO5AAA+plqHivoTh0QDgaUDK25LR
	KqYss8St0lMxjfKUsFtAPb3FSfUuxSOlOY3lq6FNk/KhJi0bQo6JgX1xmZxPEFg6QoJ5FB
	l5huJHOPwqzRnOltTO4UNJy8GWYfW1c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>, Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 00/15] KVM/arm64: Add NV support for ERET and PAuth
Message-ID: <ZiKxHyvAAMyJQM1Q@linux.dev>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 11:29:20AM +0100, Marc Zyngier wrote:
> This is the fourth version of this series introducing ERET and PAuth
> support for NV guests, and now the base prefix for the NV support
> series.
> 
> Unless someone shouts, I intend to take this in for 6.10.

Meant to do this for the last spin, sorry:

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver

