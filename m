Return-Path: <kvm+bounces-16023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1F98B305A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:26:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79A96285669
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC1B13A87C;
	Fri, 26 Apr 2024 06:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TZdi78GA"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305B13A3F7
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 06:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714112761; cv=none; b=UN8jnLMF/VEcciBy6/IxlGbwzII4VSoTJhQ8YBHFg8DpizVdcVJ2jYtdEYEaKTt+6CzgUcTXw/sC6MHNJ2tQ7SWT8fhdG+lVI96ARp5ne6vcpZjX7O+A1ybHnWM24qPOckOvkAz1jsmmNRBCj5HiHHS1fVlGRKuWf4e+PZgVUOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714112761; c=relaxed/simple;
	bh=A/7Ks0UyuBJfRoZrieXI+XuopOv0YuHXfzCHVrEZyCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5bl094RhDPUCj9XNq8w/C2STN+5z6i36bKOBA+/HmkXeTr/SztunY0vpFerFCuYZD1PwiDfY9g9FHlhENgpVBWm5JQQn02h6tEDP0vmeQ+tY+srOQd768ottQ5tStC9MDaWHtfLpvNwt6E1U40fK764kP/lZimx5DFH35vY+yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TZdi78GA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Kp1UmZIqB7d7f2MzorDnfcZ24m958FlZLC9o2LuZhQ=; b=TZdi78GAxrWQRvQR+NepqsWOyc
	ka1VCUU4Q1LHWG2OvQLvzjsNYJiieUFOAC1xdwEZtn/lJPUFwc407TeRqiZ4fl2hRBLLThH+OlD89
	WaJQT4QUDTzKPITnVsvkxNwM5igVWXqpGNKrr9kP0scN5F3p6o+T6C+LaHgTxke1wIFf16G7kMXs/
	r09xKG5WVZJLKtxjqgcpijB98UH9yoixq59H7cJ/30HIget5pFGOmDDu+CJlnpSXmHfla5uhOIhpz
	WTIU1y36z7rKPikD5TZRuwsSBVFN7oTg/rv56iCEVzWtXMrzjAi9ruWEF3E5Db3sCm62pH4iqlEIA
	L6nhoAeA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0F1z-0000000BImr-0qp7;
	Fri, 26 Apr 2024 06:25:59 +0000
Date: Thu, 25 Apr 2024 23:25:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kele Huang <kele@cs.columbia.edu>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [1/1] KVM: restrict kvm_gfn_to_hva_cache_init() to only accept
 address ranges within one page
Message-ID: <ZitI9x3P43U8iuz4@infradead.org>
References: <20240423024933.80143-1-kele@cs.columbia.edu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240423024933.80143-1-kele@cs.columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (likely(nr_pages_needed == 1))
> +		return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);
> +	else
> +		return -EINVAL;
>  }

I don't really have enough knowledge to comment on the functionality,
but this code structure is really odd to read.

Try to handle error conditions with early returns first, please:

	if (unlikely(nr_pages_needed != 1))
		return -EINVAL;
	return __kvm_gfn_to_hva_cache_init(slots, ghc, gpa, len);

