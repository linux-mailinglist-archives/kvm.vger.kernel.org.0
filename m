Return-Path: <kvm+bounces-33545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 31EFE9EDE73
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:28:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8556281E9E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A42F7154BE4;
	Thu, 12 Dec 2024 04:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="orWvcqpj"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3A82905
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 04:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733977684; cv=none; b=TZIJwDWJxv/J7zqntyM2GIlOnj1VRBiJ29hJWZgOl230oBKejb6sah0NHHwXKF7SL/arn7M/RkorlquukXsgK89i/npbxejpbYsBW+JWaEqckve5r3/rUdbeI9wPHzRugsmSlIO817Vrdb68Y36raHlRKNCosp800JFkICbuO/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733977684; c=relaxed/simple;
	bh=o84d+Sxih8rRh9Nu7iKpMQfmUQYcuPfGJiJ/okE+qEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiixrJVuWfz4PpaoP/efHCj74djG8hrVrHEHLudGMKL9gFyx1PJ42tpBBjN5dgComFGz1Oy7g058xmwWElB13asM9/q/RxDsIUIyPqyDU4dlo1W6ZeFzII4SEfq/MYbFpAQHRiUxHLp2siU8VPBQ7rO1ZEGhH6mGTEzlk+Q0k+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=orWvcqpj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lea2Bo2KNneyW0tmJJumuiWwfVEfyWRt00KyFXFpYec=; b=orWvcqpjd+3qyqimhAdBPKk5E+
	Ll6mQqxsA/AEe7XJDyJU2rmaPy57tRuj+nVxI9Tm1/RGaPHrX8EnSSnGati9FDbCDbtvaxYIsi+OI
	4+TLSvmmaNkh2LzXk2Xq1iG38tHh7Y5bNSolRSlCT2Pda0gCDEUY9246Eg+QLr1wq65QhaR1/O/Ac
	idf5qp/MdUwx6zbwTxMz1rvLalWd19S47Gp04UwYqZVUR8p6z9ts9CrQSbWYJueLdbX6xLsAsNHJ8
	c2iA6txRNmt3NOfyFLa91oq2Vok48fq31N/CLs+GIeL8B0mvSIb5qmHY59mqlRwKPBj204Rf9gMHs
	6FnhRouw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLanv-0000000GtMV-1EtZ;
	Thu, 12 Dec 2024 04:27:59 +0000
Date: Wed, 11 Dec 2024 20:27:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] driver core: class: remove class_compat code
Message-ID: <Z1pmTxlEIEqeZf31@infradead.org>
References: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147a2a3e-8227-4f1b-9ab4-d0b4f261d2a6@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 03, 2024 at 09:08:55PM +0100, Heiner Kallweit wrote:
> vfio/mdev is the last user of class_compat, and it doesn't use it for
> the intended purpose. See kdoc of class_compat_register():
> Compatibility class are meant as a temporary user-space compatibility
> workaround when converting a family of class devices to a bus devices.
> 
> In addition it uses only a part of the class_compat functionality.
> So inline the needed functionality, and afterwards all class_compat
> code can be removed.

Is there any reason it can't just be removed entirely?


