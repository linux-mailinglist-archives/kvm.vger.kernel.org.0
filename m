Return-Path: <kvm+bounces-22525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC78693FE42
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 21:28:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7155E1F239DA
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 19:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A9B189F3F;
	Mon, 29 Jul 2024 19:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Aonmxs5u"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AF0188CCF;
	Mon, 29 Jul 2024 19:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722281250; cv=none; b=mQEvW5fVCjLULRCFakVU1uWBmjkejw8jWJ8gf1NLaCJ/je1I2a5POut4oqqfp9WkRiKgD6rc8GAUOxUZDSW/84wSIa1iaLrMV9D3JbRumiKY/kc076AQINY10T+CWpFLcKTlUbC2u0NgKM/IWXTrtkqc5q+nDnOcnmAJOdbPiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722281250; c=relaxed/simple;
	bh=ki6r2ab65d/Q56UwV9LDrLvStWNiMDkJ+YAMS+YtiNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YXnkxd1DN1UCrdq9KV66Ep3q0G+rHLMkATRfBzMclv6q4bVMxClsvJTNuHssnXUD7lu7aDUjTvMg+BbIJyHCcwiFw3aN43psjlWuvFKqDCYwDKa6gYP8LnC7g1KuqtUWAH3GtJVuFfyexEGkTidRHT0xib/V2rVV0nZa4AmZAjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Aonmxs5u; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ki6r2ab65d/Q56UwV9LDrLvStWNiMDkJ+YAMS+YtiNU=; b=Aonmxs5ukyx4giVn4uya552KjV
	vUECrPibWLjFHwPWB4tHgq/Av2H7rb0nU+wQtOpJdLOTEfyq/rJqHw0u0ru6hnU+nQRRqBeAvWRig
	kvSyD6NgRNjmoGAxWKjmHmp1GOOpkioNzL20NRyQTfOTnL5IQbhpc29q80pkycIZ0R1Ukg0fjp8I6
	Lj/3P1db5mPlk7C7OC7fnVBifci+SA4syyINPk5P3A3b09o8uG1lpFmZoc4BKhw4Y1XylPHqsQJVC
	CB3jRaxwKL9OKvi/z/r2BbWqJEpLul8d3pPWAATQ9WXmAYmHQx2GPX0PbcNIgBp+ye0bfyx1p+rwP
	GY3V7wvg==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sYW1l-0000000DuMs-1CAS;
	Mon, 29 Jul 2024 19:27:25 +0000
Date: Mon, 29 Jul 2024 20:27:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH v1 0/3] mm: remove arch_make_page_accessible()
Message-ID: <ZqftHX9NO6gLslLT@casper.infradead.org>
References: <20240729183844.388481-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729183844.388481-1-david@redhat.com>

On Mon, Jul 29, 2024 at 08:38:41PM +0200, David Hildenbrand wrote:
> Now that s390x implements arch_make_folio_accessible(), let's convert
> remaining users to use arch_make_folio_accessible() instead so we can
> remove arch_make_page_accessible().

For the series:

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

