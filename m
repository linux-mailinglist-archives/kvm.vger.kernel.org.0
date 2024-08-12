Return-Path: <kvm+bounces-23840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D75994EBA6
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:16:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59BBC280EBE
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 11:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB25175D24;
	Mon, 12 Aug 2024 11:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yYPVFWy5"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE9543AA1;
	Mon, 12 Aug 2024 11:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723461356; cv=none; b=IXnzViMnF1lz3mFRT5wjCaM1RX4xSzDFKuRZWCbl7Vkjp69j2drr9q97EqdilKlCmRRmgjykTixceWN9nwECCjhd+40NHgTWFU3OUu3z/iAmGLlvCah64M0JMjv3PNxcD+ZjtnKenphkK5KG/1wCIrs+RPj1bR10iX76J9ojZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723461356; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loy+FW5FUVYnspbqBHlt+U1L5Cn5QH3ncdUbJnyIr99ZvFbwBcu+2AE6UNMd/zqOkGg4IsblO8KLCGiFbn1jpoGlCJ5UtkPA9Nm7zRAW/hD36qMBHlaTDj1bCRRdnGKj+h+LkuFozd03xh+FFtJpgu3OCNcCj1uLPj5ZV04g2LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yYPVFWy5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=yYPVFWy5VbmlQx8WOa8RtCLZMU
	NybJsBjE2ZCMRIbLxm0cIabzTWnUzoNCJO7ydmGVPvEHRmwAn1W9moHoEZdxsE+1wQdqOGgxeDSBT
	tEO67Q3dZEoLbdKcBffyKI2MZLTrBQfkv66LivA8zoW9oD5vqIGvpdqigpTmf4vO5bMSDnVHK6+Gj
	gmbyFqnoRUclBDl98UOcIFfoqYfJ7qbKtcfwHQmSdnvUZq723JE4vQt0Y9BFfGsZs0ww0PSK3HfZe
	5Y0V0vt0QvbXB9XmT5sT3InKoYJz+Pzk7pI5N0WR60trirVYfvrBIDKbbCP32PuwB3Xyl2+SIFnQl
	sbMbzRmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdT1l-0000000071x-3jSj;
	Mon, 12 Aug 2024 11:15:53 +0000
Date: Mon, 12 Aug 2024 04:15:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Max Gurtovoy <mgurtovoy@nvidia.com>
Cc: stefanha@redhat.com, virtualization@lists.linux.dev, mst@redhat.com,
	axboe@kernel.dk, kvm@vger.kernel.org, linux-block@vger.kernel.org,
	oren@nvidia.com
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
Message-ID: <Zrnu6V5lsQLpo_3W@infradead.org>
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807224129.34237-1-mgurtovoy@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


