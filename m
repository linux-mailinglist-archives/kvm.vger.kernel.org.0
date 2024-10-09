Return-Path: <kvm+bounces-28223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFCC9966B5
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 12:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 223D41F22F77
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 10:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06A3191489;
	Wed,  9 Oct 2024 10:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="ffodqbRU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cPzper/j"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A2718E750;
	Wed,  9 Oct 2024 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728468672; cv=none; b=a0iklJorCbKGgLh9QMprVTdbcMALTMr+k0W4ZFEsWDOlW0p3yZTvJ6cI0z5xcBLetQ6r3EpHyY3PnpqpLv50cxbZaPKQNhdCGAPONp/upVRSwqr4+TzaU4z++isOa60NOzsw7ZMEBYp29XIvpPAwHzEqyNAuZEbihQcvv+/M++4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728468672; c=relaxed/simple;
	bh=v2nhH4U7+pRaikn9lz83A6uasD9Dg5SjNELX0FjgBCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GJOaApRcVcAYttue67s26yTrTdD8+LsqnOEOeK4lmZAteamfrdUuZCSaJ+mapxd+aUB4VcD0snAvYCnRec/7c/H/aLP9HziCKobS0CqmzT4LTCfak0/QxEoYPBATsa8jqMM4s2jgovXZZ3+9jRXjIasERNqrc19xqW86evNLyl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=ffodqbRU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cPzper/j; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id E766113806C1;
	Wed,  9 Oct 2024 06:11:09 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Wed, 09 Oct 2024 06:11:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1728468669; x=
	1728555069; bh=RyIYYgkZHDkV5usg9WzH6NVr4irSdm1yZQbwtmB/jUM=; b=f
	fodqbRUF4pxa7Ke1pfJx1vo7rnbBIM11phY1BAZjuJyd0SFX2G6vBXQ7rE3JYZZr
	IMoAU0/+HmDdcuScrCrqsikUwM1aeokwKZHfQXUEQU14HUdCa8gNEUO3SjI7+Eh2
	Kgzpb1gMo3XL0rSl1EJkzx8dvBu2Qz22PP4Oz9C7R/OwQ/7yxglUP+RibDhR1YRd
	WZNW4XoNF47eM/ES/qTIrz+Ioq9eYkYH73dieENr3VmSAFIgsdB8wRtfBfy+n7fC
	FsenkpefsgkHcsVpoTJ55F89SNTRwu1HCUn4kdO2rtzCqVYlGsgudE5XMx1yXW6Y
	DQCeEPPNNgf1kLgxl5dIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1728468669; x=1728555069; bh=RyIYYgkZHDkV5usg9WzH6NVr4irS
	dm1yZQbwtmB/jUM=; b=cPzper/jYXuRhVCVcH+gi3MxiERvQwmW1nfVcLAEXHUd
	aAHGq3iiPYMHjpKKGg7uqq23rphoUbfbk01hqdsCPCEfesLzACCjbdtdpSPq9/cy
	k5GxPKjkePzojQBdZ8cbEy50QN2rY/GJ092mLLtveXCOA3KvEAlFVf1fM9UxoS4J
	Mbcp3VqKi3jmk+z4ebHlipgtwGwHFt6/xkfQhowtZ+CLSD0EkWxHDFQLyrkIsvEm
	VQ6jOrVkMVa5FOlKs7HFh5gulxtuHeyHH1J3pwoQThrh4pBxJlxCIsSZHdqpEwcB
	YkpAetRkLxJm2Vv2wdIxC8pr9OLXNa3XpcFgvgvZuA==
X-ME-Sender: <xms:vVYGZ-td6euj-nebkwjw9CNCf9hCf8JJbLTVdFa4boc_vUueFePHlw>
    <xme:vVYGZzc7WMO4sNH1qD6MAv7_0NiH2FlCQKVTElNDLwWpI62xB7YFCTt-65z7MT83U
    pjocComileVxn7HfIg>
X-ME-Received: <xmr:vVYGZ5z42LH5BBycVER84Ec1koPKYWqKq_AMLPey78j04J_KVASAdf3qxc2oPAO4pO5Y4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdeffedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvden
    ucfhrhhomhepfdfmihhrihhllhcutedrucfuhhhuthgvmhhovhdfuceokhhirhhilhhlse
    hshhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeffvdevueetudfhhfff
    veelhfetfeevveekleevjeduudevvdduvdelteduvefhkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepudekpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehnvggvrhgrjhdruhhprgguhhihrgihsegrmhgurdgtohhmpdhrtghpthhtohep
    sghpsegrlhhivghnkedruggvpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvgh
    gvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhglhigsehlihhnuhhtrhhonhhi
    gidruggvpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtoh
    epuggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthho
    pehthhhomhgrshdrlhgvnhgurggtkhihsegrmhgurdgtohhmpdhrtghpthhtohepnhhikh
    hunhhjsegrmhgurdgtohhmpdhrtghpthhtohepshgrnhhtohhshhdrshhhuhhklhgrsegr
    mhgurdgtohhm
X-ME-Proxy: <xmx:vVYGZ5NucWVhCjtxdHuRas6mlOuFs-Cv1KlsN9ipchXPHFXrxO2SvA>
    <xmx:vVYGZ-_qa8CvnR4CzX3TbW7IQr2T49GN2EuatEZlsvSV_Y-GnkvXVQ>
    <xmx:vVYGZxVeQDoeYhjXjlgFnTkQmdAOfwt5pjLUuejCoQcT38tTS93NTw>
    <xmx:vVYGZ3d-6AWNVysadjRD7ZcQWmuTK43vvT6GN6BD_aijpKgzdVU0Jg>
    <xmx:vVYGZx0Lb6t5kf3XhUwDW1xQeOEqtz6E8Fcyn__etrlwAqUec1-IHawM>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Oct 2024 06:11:03 -0400 (EDT)
Date: Wed, 9 Oct 2024 13:10:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, bp@alien8.de
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com, 
	Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, 
	x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 01/14] x86/apic: Add new driver for Secure AVIC
Message-ID: <sng54pb3ck25773jnajmnci3buczq4tnvuofht6rnqbfqpu77s@vucyk6py2wyf>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913113705.419146-2-Neeraj.Upadhyay@amd.com>

On Fri, Sep 13, 2024 at 05:06:52PM +0530, Neeraj Upadhyay wrote:
> diff --git a/include/linux/cc_platform.h b/include/linux/cc_platform.h
> index caa4b4430634..801208678450 100644
> --- a/include/linux/cc_platform.h
> +++ b/include/linux/cc_platform.h
> @@ -88,6 +88,14 @@ enum cc_attr {
>  	 * enabled to run SEV-SNP guests.
>  	 */
>  	CC_ATTR_HOST_SEV_SNP,
> +
> +	/**
> +	 * @CC_ATTR_SNP_SECURE_AVIC: Secure AVIC mode is active.
> +	 *
> +	 * The host kernel is running with the necessary features enabled
> +	 * to run SEV-SNP guests with full Secure AVIC capabilities.
> +	 */
> +	CC_ATTR_SNP_SECURE_AVIC,

I don't think CC attributes is the right way to track this kind of
features. My understanding of cc_platform interface is that it has to be
used to advertise some kind of property of the platform that generic code
and be interested in, not a specific implementation.

For the same reason, I think CC_ATTR_GUEST/HOST_SEV_SNP is also a bad use
of the interface.

Borislav, I know we had different view on this. What is your criteria on
what should and shouldn't be a CC attribute? I don't think we want a
parallel X86_FEATURE_*.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

