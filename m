Return-Path: <kvm+bounces-35969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E342BA16AC5
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B96567A199F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 10:30:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164471B414F;
	Mon, 20 Jan 2025 10:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="dt3nFW16";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="vjrCs9sC"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA5814387B;
	Mon, 20 Jan 2025 10:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737369030; cv=none; b=cDtQsVXj26QFq5FKSDkwHp22jfGtCbThfZFBHYk3/F9mqjSheulpAuJHxlg280XodI6pnza+M4CKEkEjoCIjeETs+Hv72prXcvSsUwt9j20JmYwida/AGkj3AqvLvpmbxNVboniRHGSSlExtuYMqPK/DGCFnQTCpeUYlKhAoUnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737369030; c=relaxed/simple;
	bh=dPngGxiY4Q3XOjgFQ7vJUGs73DWP237S6SHJS49fkic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiGXFa/ZT62uHxtgCNCl4YYJEpXilILxOULjGNz15avtxk/jRZ80pHzRBakPgox1pEyTDsLTmcB3y98QNwgFt4ryJMZJID4eqMjQFZhZL3s3/ULCKeGFkoFOfVvXLEx9yVjzNtdrpaWkSnTLxqOsp44+3IcgnPNAov1KDK41bmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=dt3nFW16; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=vjrCs9sC; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailflow.phl.internal (Postfix) with ESMTP id 11015200EC5;
	Mon, 20 Jan 2025 05:30:27 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 20 Jan 2025 05:30:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1737369027; x=
	1737376227; bh=0ojkMCVyarP9L03GWogf+XnkAUBps3DAxMGuBvM8joI=; b=d
	t3nFW16YKmJEzF626fgPnJO+RgHZhRP27aLr6RJn8jFxx6S8njGTe3MZ9BI/THP1
	FHOPmNNmEktaWlyHMVMx24GRuE6s/HneKgesiTeeqiSvEHeXCWYKj6QlNPa1eHfF
	9BeERmUIxddgSUUf8WzYHJ1KWJNdiLnfRmy1At5yDK+8/BsQDI9xoFcvIen+tvTQ
	cg5NE4mSp04L/yRkVSpKCOlaqfk+w1v6SUdwmhx0zpaeg6ihu3kTiSvilkDprf8d
	xRcXc9KCGDhmt/7psKI8q/49uXx/J9eoVagnz3L0jsqZKfjp8BaHTkmp/Uvqfx2n
	vt2kxtsg4KSb1ZYAs+0FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1737369027; x=1737376227; bh=0ojkMCVyarP9L03GWogf+XnkAUBps3DAxMG
	uBvM8joI=; b=vjrCs9sCk67Ho93YcphGlBXipIuFEoQFKkzL+pW+SYq0LauV9DR
	Fez1bGmLWdR/699rL0M/YnDLXXQdPyQ7a4VHBBBRJALKj/EAVJ0iGczA0UW3/GJG
	y1oKsgjp1VO88PRgoPo7vi2gGSXwgy3bvQGjwHj6JfL0PnBLKASAhfHhGzP1shB1
	aRLr0l+uAfgutni0+92suOFC3bmh5EAHXN4UpKP60Gw+OFUBt2I6bXW5YIvhbQJi
	A108QMLG4kGWIqsSHDOr5GR55obqdXCvwIgdT2Fcq3BAFL74kaUA1R1847Agt/Y6
	kBF8hrdXNhKyG1aOZ9KflvsA3nkJ4+dXhCw==
X-ME-Sender: <xms:vyWOZ38D49SNhAfK4IIg7f6SA-9STbxNesVJ0FiYArvBoO5y0g3-wA>
    <xme:vyWOZzuz1jwqodfCUhTqqRpoXIOguk0_7pEvnCh6E_aLDM1zbEW1I4YnK99Cq8Dim
    4yhZYA7l2auTeEAwt8>
X-ME-Received: <xmr:vyWOZ1CqNSiMBcLuQnMyNjWrvdO4Xthzd7XrI-rEL6ZIOaAuovtjaoFDhadOL_ZehI4p6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeiledgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepiedupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtrggssggrsehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvhhmsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqmhhsmhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggt
    khdrohhrghdprhgtphhtthhopehpsghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtg
    hpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehm
    phgvsegvlhhlvghrmhgrnhdrihgurdgruhdprhgtphhtthhopegrnhhuphessghrrghinh
    hfrghulhhtrdhorhhgpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhi
    vhgvrdgtohhm
X-ME-Proxy: <xmx:wCWOZzfQgPyF6ajSH6NKEvxqc3awd1YhqjmlJV_cl-81IH3NeFuvkg>
    <xmx:wCWOZ8PV4R5Y0cRUGiDLVlRkfeV5Y0JkYstDijjqkRdzXrmVGKuQFQ>
    <xmx:wCWOZ1nS37ZS7N0aHMQOw2hyV_4I96abO4Eij1smo9--hcgw9Gz5Zw>
    <xmx:wCWOZ2sX8n5slNMCa4Hw83M4yIkBilPlKlVnijOrUr90SgHkt65T6w>
    <xmx:wyWOZzq54AbLbDNd5x-U5Akn19FD-RAKj42hXiREv7RkeRgYIvWfw3a5>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Jan 2025 05:30:06 -0500 (EST)
Date: Mon, 20 Jan 2025 12:30:03 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, 	paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, 	viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, 	akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, 	chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, 	vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, 	david@redhat.com, michael.roth@amd.com,
 wei.w.wang@intel.com, 	liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, 	suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com,
 	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, 	quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
 	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
 	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
 qperret@google.com, 	keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, 	jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com,
 	hughd@google.com, jthoughton@google.com
Subject: Re: [RFC PATCH v5 05/15] KVM: guest_memfd: Folio mappability states
 and functions that manage their transition
Message-ID: <r425iid27x5ybtm4awz3gx2sxibuhlsr6me3e6e3kjtl5nuwia@2xgh3frgoovs>
References: <20250117163001.2326672-1-tabba@google.com>
 <20250117163001.2326672-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117163001.2326672-6-tabba@google.com>

On Fri, Jan 17, 2025 at 04:29:51PM +0000, Fuad Tabba wrote:
> +/*
> + * Marks the range [start, end) as not mappable by the host. If the host doesn't
> + * have any references to a particular folio, then that folio is marked as
> + * mappable by the guest.
> + *
> + * However, if the host still has references to the folio, then the folio is
> + * marked and not mappable by anyone. Marking it is not mappable allows it to
> + * drain all references from the host, and to ensure that the hypervisor does
> + * not transition the folio to private, since the host still might access it.
> + *
> + * Usually called when guest unshares memory with the host.
> + */
> +static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
> +	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
> +	void *xval_none = xa_mk_value(KVM_GMEM_NONE_MAPPABLE);
> +	pgoff_t i;
> +	int r = 0;
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	for (i = start; i < end; i++) {
> +		struct folio *folio;
> +		int refcount = 0;
> +
> +		folio = filemap_lock_folio(inode->i_mapping, i);
> +		if (!IS_ERR(folio)) {
> +			refcount = folio_ref_count(folio);
> +		} else {
> +			r = PTR_ERR(folio);
> +			if (WARN_ON_ONCE(r != -ENOENT))
> +				break;
> +
> +			folio = NULL;
> +		}
> +
> +		/* +1 references are expected because of filemap_lock_folio(). */
> +		if (folio && refcount > folio_nr_pages(folio) + 1) {

Looks racy.

What prevent anybody from obtaining a reference just after check?

Lock on folio doesn't stop random filemap_get_entry() from elevating the
refcount.

folio_ref_freeze() might be required.

> +			/*
> +			 * Outstanding references, the folio cannot be faulted
> +			 * in by anyone until they're dropped.
> +			 */
> +			r = xa_err(xa_store(mappable_offsets, i, xval_none, GFP_KERNEL));
> +		} else {
> +			/*
> +			 * No outstanding references. Transition the folio to
> +			 * guest mappable immediately.
> +			 */
> +			r = xa_err(xa_store(mappable_offsets, i, xval_guest, GFP_KERNEL));
> +		}
> +
> +		if (folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +
> +		if (WARN_ON_ONCE(r))
> +			break;
> +	}
> +	filemap_invalidate_unlock(inode->i_mapping);
> +
> +	return r;
> +}

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

