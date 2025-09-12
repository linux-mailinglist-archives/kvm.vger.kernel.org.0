Return-Path: <kvm+bounces-57428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D9EB55596
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4DFB567A90
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873C3329F1F;
	Fri, 12 Sep 2025 17:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUOanN+5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B033164CA
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757699216; cv=none; b=lSVWkL4OrmruaZ8Vt5m6PZVE48ptoh5WK7JC9o/wilMkB9Z7Md1enPD5vhu86ISiPqmay/8+Qp+M7KPRPV/FE6YbLoolZ/tslspZJKRUpsYgdVaTuqMFCvUPxxQZnwM965QHUcEkHIfGuH93X41uBdEAq/IyVjqACQHl/4m+24s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757699216; c=relaxed/simple;
	bh=yXpKDpLq79NEF1hQGcZKIQ2hI6B9J1p/owVaPT1sCKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QwXPkFXCQsKIXeO+ePAU9YnnFWng155vgg9T6085Sy8z+YtAGAtABNJI6MTF1863K8B9tOBJJYyNR7neDzgo1pWijMy/3Q/B0pMtSL4Foq48OuUzH49zGH9hCbRgyKFB+ZeBBbwmfxK6+JNk4ym59kQTI8FREKSORiY8fNfsrls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUOanN+5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A2DC4CEF4;
	Fri, 12 Sep 2025 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757699216;
	bh=yXpKDpLq79NEF1hQGcZKIQ2hI6B9J1p/owVaPT1sCKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kUOanN+5+k/E3YsPEoAouiDmcQwXo7ZQurJ7SjQ3Wyc7tfc8qEX8kjzgyFghYlPln
	 nV1emPtrEP0xEXYzeOj49YxDAYPYT6ONqPaySEVVNskoriTx6uhA3IhPVuPZg7MZBt
	 rUH+X6OZ+0w85fYBAH6Lhw7z8UENfWgZM4XU7gVlAc/E4O6BjioSIg5JyvLiQvtWSb
	 UvWiJtSTHxsPP9bWOg9p6e2VesyJpbDcUYeeMN3ZafCew1Lv521uXHmPUUNxJEMk/D
	 L0A9M3aaOGm2FZoorrOHYDNbYmeDzDLiSHyVevuPD5bZg755aIUC6PqxAjxykaKrfu
	 M8wY4HjpCFe1g==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id A1288F40066;
	Fri, 12 Sep 2025 13:46:54 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 12 Sep 2025 13:46:54 -0400
X-ME-Sender: <xms:jlzEaM4twokw5nZ8tnwPSqOaSxTr_8bTuCeRsUbKZxY8CBpMoPo9Og>
    <xme:jlzEaLyakXM2V4afacs9gIKxIefuv4PFYjWtslar77QVD9UQNVhKlIs3-gjfR6s1K
    Oj_jQQ6u2X8kkrJdH4>
X-ME-Received: <xmr:jlzEaEg-KV-CtAjrgy_KlH-hkV453AIRC8ReFU8VlS_ZVWZlgx40kKQbb6b5Hw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeikecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepgihirghohigrohdrlhhisehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhj
    tgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepphgsohhniihinhhisehrvgguhhgrth
    drtghomhdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphht
    thhopehmihhnghhosehrvgguhhgrthdrtghomhdprhgtphhtthhopegsphesrghlihgvnh
    ekrdguvgdprhgtphhtthhopehhphgrseiihihtohhrrdgtohhmpdhrtghpthhtoheplhhi
    nhhugidqtghotghosehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:jlzEaCaS9gcE-TuIRKgbsRQa-kr-9z_ykFekP6qw5FzV5jX-SLypcQ>
    <xmx:jlzEaIhgdm3tA846MT7f0J5E7pNSyUKB_3yF2jgV7V9fGutn35exag>
    <xmx:jlzEaKbbwQeEp05GgFVvFIUoMi6aikbLljvkJFcZVpvks7zuiVAO-A>
    <xmx:jlzEaJMoDPkIneKK-fJnLagaQtbKD9JjgGXFmsMEdFc6MDG3gHJrbw>
    <xmx:jlzEaMSGAhOffJTvTlZdoq2zch4ziEj_fkE0DSMdIr8KXzWEvr5AiIu4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 13:46:53 -0400 (EDT)
Date: Fri, 12 Sep 2025 18:46:52 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, binbin.wu@linux.intel.com, yan.y.zhao@intel.com, 
	reinette.chatre@intel.com, adrian.hunter@intel.com, tony.lindgren@intel.com
Subject: Re: [PATCH v3 4/4] KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to
 KVM_SUPPORTED_TDX_TD_ATTRS
Message-ID: <gldmdc2dvxi6n2cvlpl7ufdktfvxvkrgkkzjaqhfmsxsgqodrb@6uodife7r7cz>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
 <20250715091312.563773-5-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715091312.563773-5-xiaoyao.li@intel.com>

On Tue, Jul 15, 2025 at 05:13:12PM +0800, Xiaoyao Li wrote:
> Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS to include
> "TDX" in the name, making it clear that it pertains to TDX.
> 
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

