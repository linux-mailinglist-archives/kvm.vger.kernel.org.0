Return-Path: <kvm+bounces-29047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C57DA9A1A97
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 08:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54497B215C0
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 06:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D1517ADF8;
	Thu, 17 Oct 2024 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eEc/UXlU"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70731CAA4;
	Thu, 17 Oct 2024 06:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729145774; cv=none; b=Ldnemw8RvNPYyBkyIzWeF2goHCz1ebyZBeK9Xgdbx37kdcS5Si4b1kd0SWGE8MgO1VGDgn6XcuMTeG1X7HtYJvaXHMIEYA97+K1hVpcUWPtCMJnY0KD1s/WCLzvfmLOJrwLjC8SHmeiKc7ebii1czfSh+5ylBCYWsGKjo+HdqXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729145774; c=relaxed/simple;
	bh=MFQvWVY8NO0bNmjzpGCUu9PhH36kppS1uVifK8KBWsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKzpXCW81F2kFaRqRG65wKhW3+tqKpneTqz7BSGeGZaS8rAGIYCG+UResVYBp1BHAqDwe69tiXnLCxQwrTKy6SC2deBg0BotLjDyRp9S4mfKF5qzVNdVR21I3NKH1iZKz+I773S7704Q9M5OLqnvvvbYQqyRWAeXL0EN4GXh3fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eEc/UXlU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MFQvWVY8NO0bNmjzpGCUu9PhH36kppS1uVifK8KBWsE=; b=eEc/UXlU5JSio2ZYVaSHfd/KyS
	7wJNkh/BHbgYFyV7OLIWhQ4cbmO79HUiJmqbLuxQH+glPJDQQSPCZvxWdQStHyr2+Q/OuGY9JQOMD
	wqGBIzYZ1hT2IRZlSDqi31bOw/ZX2kf0qsROXsT7FAKSEU83ayp4UrsBpfV5Zvtl49HydjgVPHUeC
	7FSzkneqPnd8/pn9KjJjdaeKiP54gSB1zi95p2jmaUt/hNVJpfpynni9lrMYhXwIc4fjJUaHNrTBK
	6KrxinvUaSC68wkpkMEmtDx7WNXjyAnL3Br9F/2Q4rl5b1MT+mNfTheQr2f+E6VEERkCLtDfGwCwL
	Syp5+BTw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t1Jns-0000000Dqy4-3pNq;
	Thu, 17 Oct 2024 06:16:08 +0000
Date: Wed, 16 Oct 2024 23:16:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <ZxCrqPPbidzZb6w1@infradead.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016134127-mutt-send-email-mst@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 01:41:51PM -0400, Michael S. Tsirkin wrote:
> It's basically because vfio does, so we have to follow suit.

That's a very bold argument, especially without any rationale of

 a) why you need to match the feature set
 b) how even adding it to vfio was agood idea


