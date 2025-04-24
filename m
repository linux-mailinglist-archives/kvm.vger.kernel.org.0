Return-Path: <kvm+bounces-44087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA98A9A46E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:43:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A4C716320B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 07:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CBD1F4701;
	Thu, 24 Apr 2025 07:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="sRRfuces";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cGG6XUO9"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FB51F4613;
	Thu, 24 Apr 2025 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745480162; cv=none; b=kN4Gdzingtd6FlhE/4YEXHZ8DS67SBCZ479jBigXquQDcbhdIfqOUNvDSJz0zcEfv1StWa3MQ7rVNRqDkVm8mk2Gp1OBYHw0KW70Id4u4WQaEW0f4Pf0MdwXtvQ8oy/JsVictFfN/czdc5o5eH7/tRER+S1Y9WqVtQSdkCnSRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745480162; c=relaxed/simple;
	bh=FwqWYvwhnEDcEU87VMGnMcVBX3KVPcm53vG0XZGk0fc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbocC9WymusU14Xbum0dXxTzf9BYxnW+rXVcZCHFofCOUbzP8fGYWTze2+q5FwnVEzBEiEFFYX/E5rtvAKvaZu2pcPnStQoes1XodvKwBXu2ZmlAtdgr/NXEHZUFLPb8PjqqJmw0ZTqfAO5a2WA2DTnNVGhpjbX41bqIgFkH4+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=sRRfuces; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cGG6XUO9; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id DB5011380770;
	Thu, 24 Apr 2025 03:35:58 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 24 Apr 2025 03:35:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1745480158; x=
	1745566558; bh=JmRRPNiHQTgvCph8cPeBpNXrdoLeFWx/bdL5x/UOzP0=; b=s
	RRfuces5HnFBihs0V54dB/XKjv3DXB4SBmxIX2yIb9XSvsqufkAEbZgOItp+Rsbb
	TtFSsMhJQcvrS8hpIQ+HpJnUhPG9nQOlahy4T0cgQk6GKYO/hYRc8kvOSzTrVh2S
	mcX6y1RxqM2x4DASRb+FxNTm40WC0fDELrYXnCh3yyZN/6qIV/nCrqRC1KD5ZdA3
	smgm2oQS7riENzrgTjM5uqSr73HLJU1gDnGO24WAffJOnhVf0gLNpeNv2u9cTsFe
	gCtgnnczqrfupXpERzGDnbI183et8On3dJF1osVmlo/koaufV8+dKlxTq6++W0Zf
	S9WBY5y7zwI2wr7eyTEkQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1745480158; x=1745566558; bh=JmRRPNiHQTgvCph8cPeBpNXrdoLeFWx/bdL
	5x/UOzP0=; b=cGG6XUO9SfnPnXzhOyuOP0jkCfqsImm6Q2SlBBGhUoAHZ8XJeY+
	1HEbPctkra3xjoVzEefia3Do72FQPRbAnGJQWY9uiQWFWBgFjWL9qp/fI3JRxW03
	N4B3VQhhrzBdoY4uFNAOwc7F8EPyWD+KqKUYoKq0pAumoVo02K1u8fMI+cSrfHu8
	DGOZzn8joT02I/w8HAKNowmpqiIQut3nSk3IA4HWzfsSETO2CG5CK2iCXI7PW/gQ
	28r9vMg5e14L6Db2RckLQCDvq8DzsLo/nDzTPBwqdsF+eeDXgaQfggybeBDlyIyC
	0e6bwIIWD17M3bMF54es2WKmOQOg6SEyTog==
X-ME-Sender: <xms:3ukJaJkfn20V6v8ezNxYYFxVr3dqY1ocB3vqi5T8-hpZkgmhMW7Y6g>
    <xme:3ukJaE0GJrpLffvqHjNuKcJ4gHry_oH3QxGTt8ZlCHv52BVycTSwscSnASZszZK0_
    iEuT1pYUhZht7Nuw10>
X-ME-Received: <xmr:3ukJaPo0NvjDBzaLw4WEgNAVuypRXe6SVBvrv3NVRyO2_VmZN5ybdWOPLJ6V1BKGiReExw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvgeekkeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddt
    vdenucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilh
    hlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfh
    hfffveelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghm
    ohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprh
    gtphhtthhopeihrghnrdihrdiihhgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehp
    sghonhiiihhnihesrhgvughhrghtrdgtohhmpdhrtghpthhtohepshgvrghnjhgtsehgoh
    hoghhlvgdrtghomhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhhitghk
    rdhprdgvughgvggtohhmsggvsehinhhtvghlrdgtohhmpdhrtghpthhtohepuggrvhgvrd
    hhrghnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkihhrihhllhdrshhhuhht
    vghmohhvsehinhhtvghlrdgtohhm
X-ME-Proxy: <xmx:3ukJaJmWCEpYhUScDD-TVhkuLNSZ4pYPDtSyFE_HWF_GjKljGOmBmg>
    <xmx:3ukJaH1ZRfya3jgmcf1Eti77RH_MyKimpbhXc3AvjPaYVXkPp9aJmQ>
    <xmx:3ukJaIsEEB5NfgYx39f0zMpkoWP5mzRelJp-GwIajjtFKcnkGS1j4A>
    <xmx:3ukJaLViqF3ZVED7kXMqrKalTrHepVS57JPnChqeVdGOF06BudZAdQ>
    <xmx:3ukJaPbW_RqprNhNq0MIPHBUBqBx-F3h4skszIu2MQ1ag42DK5jRxDhw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Apr 2025 03:35:50 -0400 (EDT)
Date: Thu, 24 Apr 2025 10:35:47 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, david@redhat.com, 
	vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	ira.weiny@intel.com, chao.p.peng@intel.com
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Message-ID: <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>

On Thu, Apr 24, 2025 at 11:00:32AM +0800, Yan Zhao wrote:
> Basic huge page mapping/unmapping
> ---------------------------------
> - TD build time
>   This series enforces that all private mappings be 4KB during the TD build
>   phase, due to the TDX module's requirement that tdh_mem_page_add(), the
>   SEAMCALL for adding private pages during TD build time, only supports 4KB
>   mappings. Enforcing 4KB mappings also simplifies the implementation of
>   code for TD build time, by eliminating the need to consider merging or
>   splitting in the mirror page table during TD build time.
>   
>   The underlying pages allocated from guest_memfd during TD build time
>   phase can still be large, allowing for potential merging into 2MB
>   mappings once the TD is running.

It can be done before TD is running. The merging is allowed on TD build
stage.

But, yes, for simplicity we can skip it for initial enabling.

> Page splitting (page demotion)
> ------------------------------
> Page splitting occurs in two paths:
> (a) with exclusive kvm->mmu_lock, triggered by zapping operations,
> 
>     For normal VMs, if zapping a narrow region that would need to split a
>     huge page, KVM can simply zap the surrounding GFNs rather than
>     splitting a huge page. The pages can then be faulted back in, where KVM
>     can handle mapping them at a 4KB level.
> 
>     The reason why TDX can't use the normal VM solution is that zapping
>     private memory that is accepted cannot easily be re-faulted, since it
>     can only be re-faulted as unaccepted. So KVM will have to sometimes do
>     the page splitting as part of the zapping operations.
> 
>     These zapping operations can occur for few reasons:
>     1. VM teardown.
>     2. Memslot removal.
>     3. Conversion of private pages to shared.
>     4. Userspace does a hole punch to guest_memfd for some reason.
> 
>     For case 1 and 2, splitting before zapping is unnecessary because
>     either the entire range will be zapped or huge pages do not span
>     memslots.
>     
>     Case 3 or case 4 requires splitting, which is also followed by a
>     backend page splitting in guest_memfd.
> 
> (b) with shared kvm->mmu_lock, triggered by fault.
> 
>     Splitting in this path is not accompanied by a backend page splitting
>     (since backend page splitting necessitates a splitting and zapping
>      operation in the former path).  It is triggered when KVM finds that a
>     non-leaf entry is replacing a huge entry in the fault path, which is
>     usually caused by vCPUs' concurrent ACCEPT operations at different
>     levels.

Hm. This sounds like funky behaviour on the guest side.

You only saw it in a synthetic test, right? No real guest OS should do
this.

It can only be possible if guest is reckless enough to be exposed to
double accept attacks.

We should consider putting a warning if we detect such case on KVM side.

>     This series simply ignores the splitting request in the fault path to
>     avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
>     at a lower level would finally figures out the page has been accepted
>     at a higher level by another vCPU.
> 
>     A rare case that could lead to splitting in the fault path is when a TD
>     is configured to receive #VE and accesses memory before the ACCEPT
>     operation. By the time a vCPU accesses a private GFN, due to the lack
>     of any guest preferred level, KVM could create a mapping at 2MB level.
>     If the TD then only performs the ACCEPT operation at 4KB level,
>     splitting in the fault path will be triggered. However, this is not
>     regarded as a typical use case, as usually TD always accepts pages in
>     the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
>     splitting request is an endless EPT violation. This would not happen
>     for a Linux guest, which does not expect any #VE.

Even if guest accepts memory in response to #VE, it still has to serialize
ACCEPT requests to the same memory block. And track what has been
accepted.

Double accept is a guest bug.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

