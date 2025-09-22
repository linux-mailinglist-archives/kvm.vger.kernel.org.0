Return-Path: <kvm+bounces-58374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EA46B8FBB2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 11:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 119867AA377
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2E0E287273;
	Mon, 22 Sep 2025 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pm7qG2F/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028CE286D70
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758532780; cv=none; b=agiNYWpzQIpcbS70ivOorOpNKj8ddWi2G00+fBvAWI7ddcHvvA5PyF9ne/Q4Z6u3pex7SQ7trjlmKzQtvcmFyL9TraPsA0SGpJIjbQfVewYr8RPmXXctpDpTqlzoEh1AbvM7h69u+dPitCZB8C4coRmcIGKXRdRopjnpfGNbD/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758532780; c=relaxed/simple;
	bh=mINGhUbFUw/UX9P3RSUq9mI62lRnSA0nxH723eCJjfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6gOPtRcpFCudvaaox6mh04xWPJzo7sfEmGE+Cmb0N6UGXiI2+aeagHVibGm+4HppEdk8DdfLSbgFbcDRJFD6XcxaYtUA6SsMRO1vjiqYyDtZegRzuFaKixzOka9jX2ppOAEk4xwvaABsSG6gZ6mC4aApmVIM4IRj1Y3f0A9GkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pm7qG2F/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32522C4CEF5;
	Mon, 22 Sep 2025 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758532779;
	bh=mINGhUbFUw/UX9P3RSUq9mI62lRnSA0nxH723eCJjfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pm7qG2F/ZTdpoKosKUufxtf7uavh5Bmvm9MHXCfzdQh1LdY23bSycQFMkpbihUDaw
	 PeN/xXjTfVVt4Za2Djx9eTvlh/yIbre5uf6Jeixww+wGGqdUoH1OcDi4eQ9yN5WsVH
	 DUPHX7oApQZNoI1P5FImyAHSJIbTJNim7BavteLpRR0lpo9rRFGMw4ZmU8CgkH+keK
	 VSYqMd+kci2TW6XOqIETHaSCaZqZG0b2A/iUI05Ng+qlwwjXXB3MF1IT+J2u67Ae3a
	 vPBAlaH+5g/lFBsUT5DYU7KRMiw1Knjwi1zZpRciMi3yPHcFv+0nNbruC6O1QnSjED
	 k/BbU92pmTYiw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 31CCAF40066;
	Mon, 22 Sep 2025 05:19:38 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 22 Sep 2025 05:19:38 -0400
X-ME-Sender: <xms:qhTRaJ126p4Yc6YNRcAVyKBG7A222hAachBICdVph9lu6BDr0JbM_A>
    <xme:qhTRaL_O3hf1aXez-o6Pc2OwwEqBaf2CUI49A32_W4hmXBN3GROjQ1mnYcQCy_w_x
    hrJKmDA4RU6Uy9oLjw>
X-ME-Received: <xmr:qhTRaCuyjQMnpRjlQJpM2RXAzltTFBBPAfQeV8iGYWAoPL9MBSdn74N1DvWGVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjeegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhieekteelledugefhffekfffgjedtveevgffgjeeffeegvdekteetudeggefgkeen
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdeg
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehnvggvrhgrjhdruhhprgguhhihrg
    ihsegrmhgurdgtohhmpdhrtghpthhtoheprhhitghkrdhprdgvughgvggtohhmsggvsehi
    nhhtvghlrdgtohhmpdhrtghpthhtohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmug
    drtghomhdprhgtphhtthhopehjohhhnhdrrghllhgvnhesrghmugdrtghomhdprhgtphht
    thhopegthhgrohdrghgrohesihhnthgvlhdrtghomhdprhgtphhtthhopehsvggrnhhjtg
    esghhoohhglhgvrdgtohhmpdhrtghpthhtohepgihirghohigrohdrlhhisehinhhtvghl
    rdgtohhmpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhhinhhiphhlihesghhrshgvtghurhhithihrdhnvght
X-ME-Proxy: <xmx:qhTRaPrQ0ykqtC-eguqLLVGJC66Xo9d61rcTi1qxSrZGd9R4WrA_Xw>
    <xmx:qhTRaFGosY7WaY-f_0e7ak2Ieqj5vX2fYgQPIHGX9OUsHCe7sMpKHw>
    <xmx:qhTRaK6Wehey6yNTfsUKAh5E-8BU6GQQz604sy83cbq7tpercYUb4w>
    <xmx:qhTRaACrnEdnUl8fMaD8syC2yLr-Qw9jdj2aBnRLIhlsL0aY3yLLhA>
    <xmx:qhTRaFQboQs5bWdo0Y6kL6kMPr-4Sthrse2PJPKwlzECDRBkQWbNqc_p>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Sep 2025 05:19:37 -0400 (EDT)
Date: Mon, 22 Sep 2025 10:19:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"john.allen@amd.com" <john.allen@amd.com>, "Gao, Chao" <chao.gao@intel.com>, 
	"seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "minipli@grsecurity.net" <minipli@grsecurity.net>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <7ds23x6ifdvpagt3h2to3z5gmmfb356au5emokdny7bcuivvql@3yl3frlj7ecb>
References: <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
 <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
 <aMxs2taghfiOQkTU@google.com>
 <aMxvHbhsRn40x-4g@google.com>
 <aMx4TwOLS62ccHTQ@AUSJOHALLEN.amd.com>
 <c64a667d9bcb35a7ffee07391b04334f16892305.camel@intel.com>
 <aMyFIDwbHV3UQUrx@AUSJOHALLEN.amd.com>
 <2661794f-748d-422a-b381-6577ee2729ee@amd.com>
 <bb3256d7c5ee2e84e26d71570db25b05ada8a59f.camel@intel.com>
 <ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecaaef65cf1cd90eb8f83e6a53d9689c8b0b9a22.camel@intel.com>

On Fri, Sep 19, 2025 at 08:58:45PM +0000, Edgecombe, Rick P wrote:
> +Kiryl, a CET selftest that does int80 fails on SEV-ES.
> 
> On Fri, 2025-09-19 at 10:29 -0700, Rick Edgecombe wrote:
> > PS, we don't support CET on TDX currently even though it doesn't require
> > everything in this series, but I just remembered (forehead slap) that on the way
> > upstream the extra CET-TDX exclusion got pulled out. After this series, it would
> > be allowed in TDX guests as well. So we need to do the same testing in TDX. Let
> > me see how the test goes in TDX and get back to you.
> 
> The test passes on a TDX guest:
> 
> [INFO]	new_ssp = 7f8c8d7ffff8, *new_ssp = 7f8c8d800001
> [INFO]	changing ssp from 7f8c8e1ffff0 to 7f8c8d7ffff8
> [INFO]	ssp is now 7f8c8d800000
> [OK]	Shadow stack pivot
> [OK]	Shadow stack faults
> [INFO]	Corrupting shadow stack
> [INFO]	Generated shadow stack violation successfully
> [OK]	Shadow stack violation test
> [INFO]	Gup read -> shstk access success
> [INFO]	Gup write -> shstk access success
> [INFO]	Violation from normal write
> [INFO]	Gup read -> write access success
> [INFO]	Violation from normal write
> [INFO]	Gup write -> write access success
> [INFO]	Cow gup write -> write access success
> [OK]	Shadow gup test
> [INFO]	Violation from shstk access
> [OK]	mprotect() test
> [OK]	Userfaultfd test
> [OK]	Guard gap test, other mapping's gaps
> [OK]	Guard gap test, placement mapping's gaps
> [OK]	Ptrace test
> [OK]	32 bit test
> [OK]	Uretprobe test
> 
> 
> I guess int 80 was re-enabled for TDX, after being disabled for both coco
> families. See commits starting back from f4116bfc4462 ("x86/tdx: Allow 32-bit
> emulation by default"). Not sure why it was done that way. If there is some way
> to re-enable int80 for SEV-ES too, we can leave the test as is. But if you
> decide to disable the 32 bit test to resolve this, please leave it working for
> TDX.

In TDX case, VAPIC state is protected VMM. It covers ISR, so guest can
safely check ISR to detect if the exception is external or internal.

IIUC, VAPIC state is controlled by VMM in SEV case and ISR is not
reliable.

I am not sure if Secure AVIC[1] changes the situation for AMD.

Neeraj?

[1] https://lore.kernel.org/all/20250811094444.203161-1-Neeraj.Upadhyay@amd.com/

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

