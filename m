Return-Path: <kvm+bounces-68179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64231D246F6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33CB4308E9AC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A24238A715;
	Thu, 15 Jan 2026 12:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bd9OIs0x"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A2239448D;
	Thu, 15 Jan 2026 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768479743; cv=none; b=Sq22l+fZC5DKXpLM5HZPP7EuhARa5XpGno1VybsT59a2hNcFDdXuPntk7lxIZk3Fq0mcecl8L9oZYLds0htegWiBO+9SNsO1fNKzoggpzL1QqTEqB8DtYAdpWrcmTcGW2oTXkVGH6ouP2r51qUXwwpz+QKzGIRuTdTIpsmOY5EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768479743; c=relaxed/simple;
	bh=KORvh1MyZgMzdPmPRb40/rhDwnPtKZUev0F1g4FCIcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jtYHVT0hosZm2wnq/UtE2tYMhpkOeBIH3ActAv1+tSOomfdQSKSMtpCln0meDnGiQjtTfAkop9I4VqaZGHpRi4E3xQwFNeCXg2l+EEWnU/tmn/wYv7JmtZpnfv/FW0wFpZSmIPCe8U/M54mA3WFgHxtkjw/Bcrkb7dCTftX6YCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bd9OIs0x; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ED31A40E0252;
	Thu, 15 Jan 2026 12:22:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id C8BwZ1faih1S; Thu, 15 Jan 2026 12:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1768479736; bh=HQDhVSHI3W24FOLXJfNfwsQ94RkXEs4kVh9VD8xEDq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bd9OIs0xbVOj84crKZbZVzWNMCMG71oHoSW40LtTAovORp/n08sbJ6AWrIIwitZAw
	 FSASiEGLcgKenkljlqIh3ifO/tjrZV+sL4MxCoN1bcXtnR9J8+aF8qW495eICUctDE
	 H7H7FooBq6Y631mkl0LnDe+ydSFTseFG/3OCeEDnFD4NvgP830dcVUlvaAarScNlt+
	 L9MB/2uGV9v2X61hOSMCvnnKLSWgBf/d7PEZFKqk6btIZzmsnXHfDlqCNiMo0G8cIJ
	 D2GdNm4Ftj9O9z/n75CEBjvSu9lHWbJ6WKUdRjhj7V9f1qk5UE79VRl6IZP3e9Fwxm
	 PVfGfiIw6xe0dHtn+9X/nWw5Iu5Ih7QQRoJV1dMBJsl1+hHtBpFwl7oJECkk4jqf7W
	 43F/pSQNLLNYXBGT+YF1xSwRNh/GjElaMJGzMXYMPw+21rLbfHoY2QjpKizsVm7UP0
	 h7+V9FWC0EHVzHywG7fCOviQZuv0NUlOXkSuxBXo5jrnMRC8XTPer9uldA1LOlNirp
	 qI9/s66F1qlFKIFKmcEz7qyUqaSOdi8k46iTFDolVRiJP+M0l1ezk5VlXRomNLT8b2
	 4zIpyDEEPKyxsx4QmmjbDYlTGD4CnuHZmf48/zeqKf66lv8nmj4LAFa9IScOaHBD6I
	 CgUJBwGwxUMhGM8MQMpCOOOY=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 3474840E0028;
	Thu, 15 Jan 2026 12:22:11 +0000 (UTC)
Date: Thu, 15 Jan 2026 13:22:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	x86@kernel.org
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
Message-ID: <20260115122204.GDaWjb7Npp80GK-mFn@fat_crate.local>
References: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>

On Thu, Jan 01, 2026 at 10:05:12AM +0100, Paolo Bonzini wrote:
> Fix a possible host panic, due to an unexpected #NM, when a KVM guest
> is using AMX features.
> 
> The guest's XFD value, which is stored in fpstate->xfd, is used for both
> guest execution and host XSAVE operations. 

This already sounds weird. Why?

Why don't we carry separate XFD copies - guest and host - which we use for the
guest and the host, respectively?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

