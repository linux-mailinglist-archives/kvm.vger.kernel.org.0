Return-Path: <kvm+bounces-44093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA57A9A503
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EF1A189A6D5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95421F419B;
	Thu, 24 Apr 2025 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="YAwADi+h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="m0gLsZFK"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4681F4187;
	Thu, 24 Apr 2025 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745481367; cv=none; b=Sceg4nrjIppb4d60oo8K758rV/9TzrRAe2SBkT+dUOLG5mPkpbatCAVOGJ0JooMQ8PAgkttW7ILCvAEe2gEiTR3ADrZsGPbIu3pzOODAUqS6xieT1K7C+venyi/qcbE0tjT3ijL8wDSzUf+y4l9EU7ZR/QtE0uAj+F++6MXguKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745481367; c=relaxed/simple;
	bh=De9UShe1/X3LNdWVN26pT+PmYrdXKnozkBuEegsfHFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fB5ctPmacr3aKXvlv1B9Ju9Qf09j9pr/e4DcbSGRMScfkxz3PmQiIOuyFauooA7DlS9RFfzCbHDMhl7zM12ZyR5aLPG9FLJLMAOizucJ9J+b9rrdOeKKAyweyXACgC0dYe4jByu0LXxKGENueHqw65QXHTWW0h5ucF+zxal2+jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=YAwADi+h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=m0gLsZFK; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id D232B1380773;
	Thu, 24 Apr 2025 03:56:04 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 24 Apr 2025 03:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1745481364; x=
	1745567764; bh=4tkLLmFEY+c9SdxK/vQyV8fujxfOxzgi0/53sas8r0M=; b=Y
	AwADi+h6kNC89D9yEj9u/umkCp68ghlQOzsVVVK7G8xVKP0Giuog5Ve8H3bOE1Sd
	QBhqp0dVxIYhcV23KBk3ln3sAwBuiWqpVfFlbmv6n4G20OCUhmFMaE9JxqykuHgm
	Z3zicH24hln/ah9q3Y4LH9XNP8qw2TxpQ8sEP+zDoVw5dPMWgQjjZOvbB5n7wjJM
	E08BZ7+m1P/+skOCb/tlz6+6/EhhHYCRNXeqyZgeJ3Z02GJDruxMKqu0ml7eg/Dn
	4E09dKnTlmSBxJuAgk6qSjoEmmfuFj4Hz60NbG6iSg6Ea14INdo3ljDNOBtmCRHr
	KAIkxpaBKqc5WJksEPytg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745481364; x=1745567764; bh=4tkLLmFEY+c9SdxK/vQyV8fujxfOxzgi0/5
	3sas8r0M=; b=m0gLsZFKIZPACqMiT2XxXdKSpr4scaqNRcI+3SgbBUoEpwxEF9E
	P5e1RWn6eKMaeHLxXOwIkyL0aKYBCKxNam0PUJrNbq9wpRaYqGrruNjUkdFidBtu
	auw3+U6Ca11xyl2PiDsGaAaYWeAi8w75tr9psiKcykiPTjNL6HTuKOLSxohsgBjC
	uZILv9t1omLZOaVHwyf5BytycEyaNBzhuANTN/CjTtvhqa72TCY57apPJCqbFoYb
	UY0TdObP1EbLWX4j4U9pQQ5qU97RR24nchRJotoAQNf7OiL6OIyDjTLPjQ4635Qf
	QzuJfYh1UxNpncJhUPsmdBQ5BR1mQT9uw+g==
X-ME-Sender: <xms:lO4JaGP-ZMhtd6XhI56X6omJi4P3NB-9ByBeEzDCzxeHO4eccpkJVQ>
    <xme:lO4JaE9ex7T2cGlQUeDHz8T7p_GJxy0ENuOAM6l0FwixbUjFaDQbCXFO-izCERegr
    KAMVEcnfwoZEMTCW6I>
X-ME-Received: <xmr:lO4JaNR50oHnpCrS3xuu4kdnYI4TS0rlEzSPE0HXqPmqZEBcb9TeccSuAiRrEbEp9CDxvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeekleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddt
    vdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilh
    hlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfh
    hfffveelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdejpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehp
    sghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhitghk
    rdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkihhrihhllhdrshhhuhht
    vghmohhvsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:lO4JaGvDZcyIUMKmHbMjiKceP6rKNglh6Dzo0t02V_lgUHaWxiuGMQ>
    <xmx:lO4JaOcazqGjG6oLpmMKDnEW4E7COSB18qKyfCPeKz1DDsjGfhJu7g>
    <xmx:lO4JaK2ax7DSdB4FmgImL3AayLZWv28pO3f7QaauCNaMWKQfcqgZOw>
    <xmx:lO4JaC_bDaoBVcVleMCqs1PUntR5ntmWOL52mPFz58rW85FsGkrzzA>
    <xmx:lO4JaIJqD7XPkWuLv0JF_xwciiLHzIeOOX3p69iZgQKIk8VoscvPQqjV>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 03:55:56 -0400 (EDT)
Date: Thu, 24 Apr 2025 10:55:53 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com, 
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, xiaoyao.li@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Message-ID: <g3htfhtzg23aynnmv4pqwothiub5ojewvm3xgoyfn7rpfwru5j@fdnrdiz3to7a>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030500.32720-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424030500.32720-1-yan.y.zhao@intel.com>

On Thu, Apr 24, 2025 at 11:05:00AM +0800, Yan Zhao wrote:
> During the TD build phase (i.e., before the TD becomes RUNNABLE), enforce a
> 4KB mapping level both in the S-EPT managed by the TDX module and the
> mirror page table managed by KVM.
> 
> During this phase, TD's memory is added via tdh_mem_page_add(), which only
> accepts 4KB granularity. Therefore, return PG_LEVEL_4K in TDX's
> .private_max_mapping_level hook to ensure KVM maps at the 4KB level in the
> mirror page table. Meanwhile, iterate over each 4KB page of a large gmem
> backend page in tdx_gmem_post_populate() and invoke tdh_mem_page_add() to
> map at the 4KB level in the S-EPT.
> 
> Still allow huge pages in gmem backend during TD build time. Based on [1],
> which gmem series allows 2MB TPH and non-in-place conversion, pass in

s/TPH/THP/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

