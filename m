Return-Path: <kvm+bounces-33901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D4B9F41AC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 05:20:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3FB8B7A3A84
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 04:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9855F1487C1;
	Tue, 17 Dec 2024 04:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LsXaMRtY"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81313D25E
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 04:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734409201; cv=none; b=GWK7Ec7lQLl17jVpUhEJj4zIwmCcaOItZyvXeJvJDAj6Fvf0UDlETVNWfb3P6EIUox4yhhlM4WfsM7JGrDggsk9oQGOAJqXFgaDXfYAtTTsYGoQZBxa9f6UwT3GcKFXbujyVAwvM9etMEtKNT6sUowQBY7wXnKdl3BjAvMTsx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734409201; c=relaxed/simple;
	bh=s9T29V1WVMbjgigs6hlEyulQNsZX5W4uOHfEhbJEI6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BA2nQLCtb+RCH62IOnxnrixAZfA0++ryQH9iPcjJcN26wiQOrShZ1cIekyl9E6teiOEl/O9GZpCg+eexPBa2VMm4FSUhOIRtxn6cneBKVMLN5UrCT60FI+tZ+WQsfsf3WeQG3x3qidkz5VORWxMi7yxSaGOVp+Airli4FkNtbkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LsXaMRtY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s9T29V1WVMbjgigs6hlEyulQNsZX5W4uOHfEhbJEI6M=; b=LsXaMRtY8mrXbsg7z50suoem3J
	yGG40GCqCdqyUYxYaDjGuQylH/YpUzC2EsbXkFflPqovEqjkSHPbt/PoUlpP05FmuiThluGaaDla5
	TSNZ49Guz/OqT/Okn0zKT31NiFIr7pEHW3mAxdEifnHpp4S+9MmN9BTMZrjXMY9gO71rZaRUcscP9
	0Yd+jo+Mgm3PN+n42v2J+nfVLzALiqmMPOmyFZ4UBtvikqAn41zybNvoLzCBSggAG96qr6vKrZulH
	HrO1s+s0T7/sdDmVx9js6NK90W7MRNecxiP1WFx/QwApkFK6eJ3bvTOZafMz5gUjx5EZX5wxtPg0K
	V8t7N6Ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNP3v-0000000C8QJ-1nRu;
	Tue, 17 Dec 2024 04:19:59 +0000
Date: Mon, 16 Dec 2024 20:19:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Subject: Re: [Bug 219602] New: Default of kvm.enable_virt_at_load breaks
 other virtualization solutions (by default)
Message-ID: <Z2D77wbGIptAC_wv@infradead.org>
References: <bug-219602-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-219602-28872@https.bugzilla.kernel.org/>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 16, 2024 at 09:15:22AM +0000, bugzilla-daemon@kernel.org wrote:
> Previously (kernel 6.11 and lower) VMs of other virtualization solutions such
> as VirtualBox could be started with the KVM module enabled.

There is no other in-tree user of the hardware virtualization
capabilities, so this can't break anything by definition.


