Return-Path: <kvm+bounces-3264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD93801FB6
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 00:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D48E21F2108F
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 23:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2917224D1;
	Sat,  2 Dec 2023 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="iMB1Y3tk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AD8124;
	Sat,  2 Dec 2023 15:24:07 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 049B240E025E;
	Sat,  2 Dec 2023 23:24:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Niido9d84076; Sat,  2 Dec 2023 23:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701559440; bh=9MUOeGeZ5B/ijKebEMHCI1M4SgxyUmLcB9iMR+JlMLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iMB1Y3tkckvcPzSIMFzmO3QkTWIi54wspB5lmz1p3wTg6sxvgAQFS/nx36pDTM0Sq
	 NgyyYA2BJjSs7mKalgZjLnssy9RIcogY/ezUBLtJSnSwvaN+XnU5Q5hoPq6ey5XoNV
	 6i90Aks8zWvQzMrvKCE5JQCJaUAOU4vauU5u20R0RY+FOSPtmhNz7S07ruwEpCyljE
	 Zb4HbsOKfUmciNg9PdeQk3uLL+uq60AT+D/jnZyFPFOlGc4/9lxSUnjq7/nrc6ngtY
	 0knlTxmZsBU3V9L64c5k459EgRJwLOUS5s1LkhThC/cC5hR+QwuT0CTvf6tC2xwiou
	 yepw3gnX7/Y6zWZ0dZqtIdVdM/aKXqa0GEY1vGHu4DKt5YznVMOr4f/+IqoEJMgxvP
	 FqKfr1f5QsXC4gL42/Xiy15FtLlx/TfRSPZ08FFR8FHMIOGAG9ZQE9lEweuHN39f8x
	 DkjCdnOJpfKb0NLaNGgStt710K9S2259FgCEMmkaaHH88Y+snZGFi6BcpkfHXAuwuM
	 G+Gr0/GajAaNadrPeOZf03ISMk2hx9VOPR7KTqjZPfUWklUcKDe6raWSXDSZXRxgAS
	 4hdDMInA/pVlpCBNIPHhSt1v1VTU4AAmV1i7LX110RdsrPcVsxU+SSFaTt6AF/cTVk
	 CfeM1jrzHeYaLK5JmqqRPwG0=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 05E0D40E024E;
	Sat,  2 Dec 2023 23:23:26 +0000 (UTC)
Date: Sun, 3 Dec 2023 00:23:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, alex.williamson@redhat.com, naoya.horiguchi@nec.com,
	akpm@linux-foundation.org, tony.luck@intel.com,
	linmiaohe@huawei.com, rafael@kernel.org, lenb@kernel.org,
	james.morse@arm.com, shiju.jose@huawei.com, bhelgaas@google.com,
	pabeni@redhat.com, yishaih@nvidia.com,
	shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, anuaggarwal@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, mochs@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm: Change ghes code to allow poison of
 non-struct pfn
Message-ID: <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
References: <20231123003513.24292-1-ankita@nvidia.com>
 <20231123003513.24292-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231123003513.24292-4-ankita@nvidia.com>

On Thu, Nov 23, 2023 at 06:05:11AM +0530, ankita@nvidia.com wrote:
> -	pfn = PHYS_PFN(physical_addr);
> -	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
> -		pr_warn_ratelimited(FW_WARN GHES_PFX
> -		"Invalid address in generic error data: %#llx\n",
> -		physical_addr);
> -		return false;
> -	}

You don't just remove a pfn valid test just because your weird device
can't stomach it - you extend it, like

  3ad6fd77a2d6 ("x86/sgx: Add check for SGX pages to ghes_do_memory_failure()")

did, for example.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

