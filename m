Return-Path: <kvm+bounces-40334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F295DA566AA
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 12:27:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B973F18996B8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 11:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7E221CFF4;
	Fri,  7 Mar 2025 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xenproject.org header.i=@xenproject.org header.b="1OtPf4ht"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9521D218AB3
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.130.215.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741346566; cv=none; b=nj0jLf8W7gC8GKeXjfrjbFrg2DF2Uy/ci1zt5UrMYDT07WORebQ2hV0di5qCXzaIIAE7kemvhcka4fcxTqWPDk+75e21PzYYwqfraOeddFUsmqSKESXSBDbwLU3/0cxBy8HEvMpWFSKltjt/dlstH0xFJj1XNKFfOxs2vX0ZLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741346566; c=relaxed/simple;
	bh=CVE/52zeHgWJeEWxIQ+PkOK5ghFsFhosJecGVW78+RE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ij460nE46d8vmH4bpjgtM2SPLBW+eHqF5Eu4QZfCtr1rHC7wlXYXqpCntfDgAPOT7sCwC/FCh1B2OqpSgansrj/B4TcUlydH9dkmeOG5fUyr9Buv3QbL89WunrKktTAriDKfa3JFDy1nl8RSdUEdd9docONHY10hr07qeIe/6UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xenproject.org; spf=pass smtp.mailfrom=xenproject.org; dkim=pass (1024-bit key) header.d=xenproject.org header.i=@xenproject.org header.b=1OtPf4ht; arc=none smtp.client-ip=104.130.215.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xenproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xenproject.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=xenproject.org; s=20200302mail; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date;
	bh=XTOmmQ2mK3eAeh54TywQk0UUL/JTx2q9dmNhnKy7zMQ=; b=1OtPf4htAZU3Rd4LYuqdGPd2jO
	NrsngLKHhI9MHj9pq5vgYo4rsqtytr3k+hQXsQ2qWPnJbTyWMq4s14VE7hJX0FeUkSN68H+3Q8Ba4
	gHUqZXy/o9Q/oklXinrpZaakMssFoJqkYaHHGkVJ7Z2HL/FWH5zi80opaoqdYaUawlbk=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.96)
	(envelope-from <anthony@xenproject.org>)
	id 1tqV6b-006vsi-2H;
	Fri, 07 Mar 2025 10:39:01 +0000
Received: from [2a01:e0a:1da:8420:b77:bd5:6e45:7633] (helo=l14)
	by xenbits.xenproject.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <anthony@xenproject.org>)
	id 1tqV6b-00CI90-0T;
	Fri, 07 Mar 2025 10:39:01 +0000
Date: Fri, 7 Mar 2025 11:38:58 +0100
From: Anthony PERARD <anthony@xenproject.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: qemu-devel@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] hw/xen: Add "mode" parameter to xen-block devices
Message-ID: <Z8rMwkKVSgop_eNV@l14>
References: <20250207143724.30792-1-dwmw2@infradead.org>
 <20250207143724.30792-2-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207143724.30792-2-dwmw2@infradead.org>

On Fri, Feb 07, 2025 at 02:37:24PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Block devices don't work in PV Grub (0.9x) if there is no mode specified. It
> complains: "Error ENOENT when reading the mode"
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Anthony PERARD <anthony.perard@vates.tech>

Thanks,

-- 
Anthony PERARD

