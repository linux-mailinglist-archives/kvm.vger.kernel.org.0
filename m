Return-Path: <kvm+bounces-3377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A958038F7
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 16:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51995B20C76
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946552C86E;
	Mon,  4 Dec 2023 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UCrLi1yp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116DFB6;
	Mon,  4 Dec 2023 07:37:25 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A2B7240E024E;
	Mon,  4 Dec 2023 15:37:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 57rtjTuPDXSa; Mon,  4 Dec 2023 15:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1701704240; bh=kaO/sau2mcBySd1FCm7TU34cOIPXB62AwClHCJS5wzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCrLi1ypAd/XYvkwQQ7YfPFOXIME9Y6BGRO4HnAzbbz65mfnQXnZaBmWF/hyaLdhW
	 2eiNCRdqtuV75pLDUKfY/l3q2H3N/Sf0KB6TXR54l909KX0ylb3zytv8fjC8TLpRT/
	 0/K6Hv+U2u2g7HCZe/cluFhbJmsoxfYAf8UxhP2y9/KLk7QOTEAPwD7JXWUzzLPGl1
	 qKdFwAKTI24kGWKd6QCCQlUt1RhxmfCrWXgS7G/45YtAtFBg0+QGzl9Ps4YFqF/XkK
	 dsYGlV7VakK8U+my8ej9eDAsGEaifng25JOfzRPJdL0uZmj7PjrqYOVofipMoOweXs
	 dgvT2XWzGviloH8Lv66OREJDar/Tihdjc9hk7Jw6ID9+Pd+iWJJsGWbFKfoC8SItxi
	 kJdSI6MuPboMy+lBY5sr8Yz6VsuQy5sdeKmu1tNA45WF0l4tXE2jeKMHAyV3KEKLfK
	 +RJA3woPFCKAIu7b8afKztce7d5+Z7uTDXG/ZbTw0SqJylXoTNcbKUAollqo+sT6kX
	 fQLRNNdljwROMZ57Ss0sJyRhFLqdL3HCIEHSzVBAxeQqy+KavbKiuIkEOp538fIveD
	 wYoht3bG9RXpSHBQVwF9x42yiy6vj+MPjSFPsx6FDeXDyETHM8/O7FAinpw3PFnIEI
	 8TAQRWTaONKRLKtz+8wCgNGI=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6DA2840E0195;
	Mon,  4 Dec 2023 15:36:47 +0000 (UTC)
Date: Mon, 4 Dec 2023 16:36:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, alex.williamson@redhat.com, naoya.horiguchi@nec.com,
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
Message-ID: <20231204153646.GCZW3yDgal3gztpDRY@fat_crate.local>
References: <20231123003513.24292-1-ankita@nvidia.com>
 <20231123003513.24292-4-ankita@nvidia.com>
 <20231202232319.GAZWu8Z6gsLp1kI5Dw@fat_crate.local>
 <20231204143650.GB1493156@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231204143650.GB1493156@nvidia.com>

On Mon, Dec 04, 2023 at 10:36:50AM -0400, Jason Gunthorpe wrote:
> It wasn't removed. patch 1 moved it to memory_failure() where it makes
> a lot more sense.

Why is this a separate patch then?


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

