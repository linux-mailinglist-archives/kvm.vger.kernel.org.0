Return-Path: <kvm+bounces-33733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C909F0FAE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 15:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C8B9188508A
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 14:54:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7612D1E231D;
	Fri, 13 Dec 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gJsLon66"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65781E1C3A
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101635; cv=none; b=g9m6epK0X548csSFEDOn/UZnvD6oBfqH4hmo3SFrTLNtxde8rcZIR+D6iv9VOWSVMJo1TPXw5njOEpOacjx2TpiMwMjbdtXSJQuEtIYY/QP9YnLNI49APL6g+uR4vow3Nyt4XekxCmUsQ4sSclKDvb8qXIg5w8aC0M09UsgDp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101635; c=relaxed/simple;
	bh=JOEGtmL+jHWWNqH4mOU0I1yh2kI8+LQtfytEHW0l2QM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuqSjGB02tb3xqEXigQDWWB/EkCv9E1NS/crtwVLziFo47VwkBTQ2FkmtBmQgyZZTtYcTAca8IU10uWLqcL+DGLMB4xUf8U43spnhxZeQ72jiCM+Ob55Eo1/Cw8Dcy+P2nTvq3aMMFGLG8YbgrBzaXxlEnUsfkxcQs0KVPz3vhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gJsLon66; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jyJ5tb2FeeXPtSINp0fMJl/JE+YXb8u8zW47UoIvsB4=; b=gJsLon66j0ACIvBR96cExs8S/O
	bJV9+vjjGYrZBC+TC5NUJpj7Apd++92E8i1lMMBE68KeMKn5Q2Sak1VahwuMuIMq2LvarC3+SWyMh
	nWjpkGpd4zcTNLDLP4y7kP4N6lY89A6zgw01w0SEEf5cYdwV0WA4BX0A+tH+32x0OkDM26bnDieNS
	AonUCwjrctJJ4ZrgsBWix0y+ilg3L2AOBMlMzmK2ruxCCFqr05IHmC28db2PUEibHO2aQvesH3ApX
	iUknkYpjlU6Au+jgqKSX/Dg9YpzYcpa5QTzElZBy2SD7amm3V6ZgyaOH6chUsGrKRJRM8NiDzVKDt
	c0PFe/kQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM739-00000004AJ0-0r1u;
	Fri, 13 Dec 2024 14:53:51 +0000
Date: Fri, 13 Dec 2024 06:53:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <Z1xKf-RQmXGv7sC7@infradead.org>
References: <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
 <20241206093733.1d887dfc.alex.williamson@redhat.com>
 <2024120721-parasite-thespian-84e0@gregkh>
 <4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
 <Z1ppnnRV4aN4mZGy@infradead.org>
 <20241212111200.79b565e1.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212111200.79b565e1.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 11:12:00AM -0700, Alex Williamson wrote:
> userspace.  The "just remove it anyway" stance seems to be in conflict
> with the "don't break userspace" policy and I don't think we can
> instantly fix this.  Thanks,

The just remove was about the sample, which are explicitly samples
and not something that is part of the kernel ABI gurantee. 


