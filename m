Return-Path: <kvm+bounces-30484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C2B9BB070
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:59:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E214628183D
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB701AF0C8;
	Mon,  4 Nov 2024 09:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GR5U+lli"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F29382
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 09:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730714339; cv=none; b=j0Waa7zz7ftAe5u6wLNeIfVPOUtxsHE+1JaRYlry4dnHcPe0R0bvDzE4WhTJOXA1DJInyzSoNr8vnpc8IH6C4mXfoS5lI4cTAZTY2jg5re9RksavJEAKk+GCJnjtcTvPgC9yJm8TyiEDm2rZUYRFEHeBt7Cf0kLdrugwNR2U25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730714339; c=relaxed/simple;
	bh=oPIM2Ejl9q/Q28Gg1E6jOm6FY3vOapXN9hCz8tBUj/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVZZN+SRWkcAAHrHIDU7gJHofpgWD8ikezlZLc1iZszvSP6t2woBwyU6tvD/gYwH0uNZQ3RU9bjIg70+vD5vmHwwhXJhKjapwXJO49JINnKt8Pig0TAmX8EK50FXT5W4lUtkDxJTProcRvS1XH4Wh37N3enuILwcWVdiMLJAHLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GR5U+lli; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4334640E0220;
	Mon,  4 Nov 2024 09:58:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GqoBv4eiko_Q; Mon,  4 Nov 2024 09:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730714331; bh=hlPxuVLPf8XlaWeHmR9XzldHKjWQzxKu4ZP2wva3CnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GR5U+llitCODPid7IDrP2wiNWmgguDf8T1CQ98fGYT7V/iAH29MHq+aiuYJPS0DLi
	 BPOOY206cYw0HBUobC67PZGvYk5TRn6TOLfDB/F8TIAudWKRIavOKcF/PQ+q48fZgJ
	 ghVeTmhv61Z5NsSZMt3A5hA5sCkbXoX2CUoXsJPms/ClUcW6TWKdKcDptO9J4O2vv9
	 bSEN8TDlfknsg6YODWYyOI57L764iuPIA9XMIsJ+q3s4CMByCZkjZGkdjyraSpPOEa
	 dXc+aXY0KMiUGleI8cBLNdiqBhjgzg2ohCtjrz85JJWFgqeQQp/EvpYaiKaM4ZytvU
	 d6q2zJ52Smnh9z57U7288H6Tb85H1UduU9CEL1BoU6wiqmoSq6vgdnvZirtLL+Ev64
	 UR2dJyan5X5Jqmrs5hb8UnMHeS2Y9878oVlHORBfeDylmY59jLisTtILGI7XUxvfPj
	 c0OA1QhJ+fpP3dEbrhivr8gNYFn7o3PkJbAlPEJKGjddJwwFbra2zlkdW0+5KAudHO
	 ALK5dkYVUgMWPA5dOWPl+Zns1P+SZ9zVD8r1NqaPULi2hD6ehWU8OMsTtT6H0Cs0RA
	 OBSqPrkNi075rlTV8kQyCSfrCLW0uoxzcoW+fzB3chvQVuvpPyJgoQLINgWpw0gaqD
	 /G/UfMx9gcQ+h0UdP6sRFvp8=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2EC3540E0263;
	Mon,  4 Nov 2024 09:58:41 +0000 (UTC)
Date: Mon, 4 Nov 2024 10:58:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, dave.hansen@linux.intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, jiaan.lu@intel.com,
	xuelian.guo@intel.com
Subject: Re: [PATCH 0/4] Advertise CPUID for new instructions in Clearwater
 Forest
Message-ID: <20241104095834.GBZyiaytJCvXylJgc2@fat_crate.local>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
 <20241104065147.GAZyhvAyYCD0GdSMD5@fat_crate.local>
 <ZyhyCU16iZysIFSc@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyhyCU16iZysIFSc@linux.bj.intel.com>

On Mon, Nov 04, 2024 at 03:04:41PM +0800, Tao Su wrote:
> Would it be better if I attach rev, chapter and section?

Put enough information from the document so that one can find it doing a web
search. So that even if the vendor URL changes, a search engine will index it
shortly after again.

> I mainly referred to the previous patch set [*] which is very similar to
> this one.

That patch set is doing more than just adding bits although I still would've
merged patches 3-8 as they're simply adding feature bits and are obvious.

> If you think a patch is better, I can send a v2 with only one
> patch.

Yes please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

