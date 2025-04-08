Return-Path: <kvm+bounces-42933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510E3A80A22
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:01:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 361634E6444
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 12:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F58026FA76;
	Tue,  8 Apr 2025 12:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="I90PZBhM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC90B26FA6B;
	Tue,  8 Apr 2025 12:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116267; cv=none; b=qUKigxJld3G1D6ZBeyOK8/LR9RusHGWe0EYhB7vAAQJE6l/aYV5QSNeNQIdK/iOyQgf5hrjxCA/EvpQ8hcLIiqyP4Fo6aKPZiH1bP5u2+pM6/UTXYIfI/1fd3KnxAt6Q2cxiIVYwA8v50rgFvMmiUoL8JK1QwQHN3SO0i0vi7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116267; c=relaxed/simple;
	bh=92+gVUDbM8veL5qaG67XCDOWhmC3AQ1NUPn6xtCTkrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1vb1XyNmJUt6EK1HyCB0JiBBLM5qJBiy/OuySGs14jAr+EULUt53KuhKDBI84jpEg7I5u46Y7okcjqIOhjcyTrqoQTPbZE0wjXGiqELUv+kyHF24OmAPkn1RjbrOOmN5gIj9YH82TfBUZsvGSvhOMCYQ5Tz2nukstcMFV2I1Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=I90PZBhM; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 79C5F41F12;
	Tue,  8 Apr 2025 14:44:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1744116264;
	bh=92+gVUDbM8veL5qaG67XCDOWhmC3AQ1NUPn6xtCTkrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I90PZBhM65TV2U7//+BKL0PIdDP8C0UuisOeswxIWcZfjTSvNxiTsriCM/Tl7ylOC
	 4VDxsTmsldmg3eH6O/ON/6+R83AlfRkmQUe3sSb1yEdcdkEJkDWuzg5gOOMGlftXWR
	 rGQVilkXEkwH9x7nCGdjhaiIbHHCGhiTu2gH0kbyCxwplWb6CXdy3S4CApWORlJwmO
	 9oUKlY0Xaqx6WP/1q97tYJbIjjTWmDl9A3Xt3lyd3aiLDWq9Yy/KG/rH4D0PEujw2b
	 QaBjqnFc2Uc6NoA4p5YBPGU9RPKyfrwalzFMO1JLAY3QQ6IXwpscA3B4DDqYP6BlNL
	 7+InApJnQ+V/w==
Date: Tue, 8 Apr 2025 14:44:23 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sean Christopherson <seanjc@google.com>, suravee.suthikulpanit@amd.com,
	vasant.hegde@amd.com
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
Message-ID: <Z_UaJzhtmIv4rAox@8bytes.org>
References: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>

Hey Sean,

On Fri, Apr 04, 2025 at 12:38:15PM -0700, Sean Christopherson wrote:
> TL;DR: Overhaul device posted interrupts in KVM and IOMMU, and AVIC in
>        general.  This needs more testing on AMD with device posted IRQs.

Thanks for posting this, it fixes quite some issues in the posted IRQ
implemention. I skimmed through the AMD IOMMU changes and besides some
small things didn't spot anything worrisome.

Adding Suravee and Vasant from AMD to this thread for deeper review
(also of the KVM parts) and testing.

Thanks,

	Joerg

