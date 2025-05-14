Return-Path: <kvm+bounces-46418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F773AB6306
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 775EF1B43A07
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DE41FE474;
	Wed, 14 May 2025 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X77EnhuX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E241F4177;
	Wed, 14 May 2025 06:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747203948; cv=none; b=raAo+PkIeE4L7WWT8br5OAMdxxFNCBrr8QMYSnipxm7rpHi2uI7eHwKIB3E6L9tSppGsBXJKDfnzoayQ/Xv86IpyZPniKUDXusdI0QFzJTUVmBmmSzDbPHBmhqFXwM1r+Z6lXgDPIGbh2fQtxEkRpZwv+I1BwKei9tcAAPdknmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747203948; c=relaxed/simple;
	bh=vStwmxHSNkrERwirZGjiecqs3eeHfm5murNxGvZPDkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONkm1uDpbLJ6UVMS5jADaJC1t5U2k6UeYjrRGJFVKU9BOhHXWC6eFcXnKiu71P4m/BkGlqy0GyYFiNwiTS5vSZTk1T66qVcpNx/QIMG/7Xj0E2RqTkiUbBeJ3zNQPqjyZ3irua/c3TGBSDTrTZpxZXwtotNKDc3cOmEaXhEOWKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X77EnhuX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747203946; x=1778739946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vStwmxHSNkrERwirZGjiecqs3eeHfm5murNxGvZPDkg=;
  b=X77EnhuXskqZ7g6ieQT/3WoiNKZMxIcm4xJm3S3N0PaRqm2Z+1g7eRCc
   10zZJFtmq+saQc7lbGDrODscBo8UOkpP9BJ9/IS6L3bf3PlaohQddiwUb
   gQwuD92YV7b3TDXlx3hQkHjmJdSAjYehduEba8Tg+RKJ9IiRfYF/eTnE3
   CTpvJQdXz7KsWx80zziLv7lFUf5TFJywHMjTOkE63KpxF2IYNVjzfDQcD
   tLbprBQsm26T60QdlZpjAdbwizY8R8SSthASjI8KzZsD9T0J0fMA9ZvpH
   uHivJFx/wjzY7SZ/a/jgv4uJb4BgFjPyfV3nbMDQSoycOm20g0+RB3a3c
   A==;
X-CSE-ConnectionGUID: o2VmCsZOSKKMWdB23GFi0Q==
X-CSE-MsgGUID: Z9HoWrMNTkuZsE2x/8QTOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66494200"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="66494200"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:25:46 -0700
X-CSE-ConnectionGUID: 6fUwvCpRQCqtB2cYEFosGA==
X-CSE-MsgGUID: fg7DIxxRRaOdeYtfThk/Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="142812658"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa005.fm.intel.com with ESMTP; 13 May 2025 23:25:42 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id EE8101FD; Wed, 14 May 2025 09:25:40 +0300 (EEST)
Date: Wed, 14 May 2025 09:25:40 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, rick.p.edgecombe@intel.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, yan.y.zhao@intel.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <jz5qs2gx32jeuby4gvrbt4m6m3dnhwphmj7fqflwy2mf52timq@6grx6bxkdnvn>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <aCQrMh+wxDzrpAKA@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCQrMh+wxDzrpAKA@intel.com>

On Wed, May 14, 2025 at 01:33:38PM +0800, Chao Gao wrote:
> >+static void tdx_pamt_put(struct page *page)
> >+{
> >+	unsigned long hpa = page_to_phys(page);
> >+	atomic_t *pamt_refcount;
> >+	LIST_HEAD(pamt_pages);
> >+	u64 err;
> >+
> >+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
> >+		return;
> >+
> >+	hpa = ALIGN_DOWN(hpa, SZ_2M);
> >+
> >+	pamt_refcount = tdx_get_pamt_refcount(hpa);
> >+	if (!atomic_dec_and_test(pamt_refcount))
> >+		return;
> >+
> >+	spin_lock(&pamt_lock);
> >+
> >+	/* Lost race against tdx_pamt_add()? */
> >+	if (atomic_read(pamt_refcount) != 0) {
> >+		spin_unlock(&pamt_lock);
> >+		return;
> >+	}
> >+
> >+	err = tdh_phymem_pamt_remove(hpa | TDX_PS_2M, &pamt_pages);
> >+	spin_unlock(&pamt_lock);
> >+
> >+	if (err) {
> >+		pr_tdx_error(TDH_PHYMEM_PAMT_REMOVE, err);
> 
> Should the refcount be increased here, since the PAMT pages are not removed?

Right. Thanks.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

