Return-Path: <kvm+bounces-12020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4490D87F115
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 21:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D91C01F2414C
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 20:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B1D57882;
	Mon, 18 Mar 2024 20:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="IOHKA6hc"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A810538395;
	Mon, 18 Mar 2024 20:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710793323; cv=none; b=nJsornJ05b4oV0YJt6310io/J37v+GVlB3A9E6elGSeLjRXYU0fQlMfL9AGVqDfDinOkurMN5chX+m06VMYf23UuqdA3ahy88RS3o5W67Nd7QwrNTBeNh1mz+cx8hMGOuI+vGSjvtJNVKrk+FveUChEx03IPIpfJobro4eSRTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710793323; c=relaxed/simple;
	bh=DfLx4MCfxXP9EcZzXdlUj+8HOLfw4rLVu4UL/Qa8UL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p1ddoyzmj+hClhUlo2jr+P1yPmG5nEJ+eA1Zd1utpuwnYzTVzYJpSmJoqx7VW9DODVBK9+NU2+Kh74lJJ17k2omfPAFXtNBvpb4PiUVYVwVisiUayI46hwfyFZbA+JbmaAxY97zuygdUQilfaQcd8cBCc5ahH7YFtcn84NSabvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=IOHKA6hc; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D950F40E0140;
	Mon, 18 Mar 2024 20:21:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id aEJSuwqi6nMp; Mon, 18 Mar 2024 20:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1710793312; bh=9S7B89ex3wmSeSlcaPgVJHiZJD5MpmWiVmVp92JMtEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IOHKA6hc66upLBhuiNhxTLcNjwz6jMIuG9eC9D5L4aUPEYYRyBurrllOzBXDoLbH+
	 2F4Xv44hFUhn73AMZA96n5gSlb7dDj6lwXWA5vejF0+48ts2g7HLkQtJID5dH4Zo2B
	 SNmS1f0nNBbTm7tVaCfq5KDwVulBXZIXDN2gL2v+qDYhGEBkUygU+o2VwGpeylMgvC
	 QW5kRkWpJkdHG3STwcEpX18IQT6/f9i29c3HeebU8V+ReyHrHNd0E/iV30Bh3oUreP
	 WBFxtc9I+pNJRc2eLjXU73wkf81yMOdg45OPbMHGyjC759d49o9l0j7KrO6vspusXG
	 znGuxB+jxmtPEpN9kEOFlcZ5WAC/eNZAqsGQSMocdC8k3dFaji1AOPuh7zxqaO6MQh
	 y6fr+xje1opTtCwPzHGmlBqeaVxfU73s+LAVA9LGMTC+2c+IsorKi/ISJ007+xHWdT
	 5XIKhZb40sl/+VbqrzHxOIAbzGk6vAqL3kyoBi4buMFfQv9FPaTo5AB9EvRta7+wcV
	 bmyt8wQnFIHC/VNGtA2esqsKmXZySAmXWisVLNo3lyHg+ft0Iy7ZzFHKkGRQeBsqmt
	 /9vtAS6yf4TNeP9xfHK2xWaLmt/PLMvjNthQaBkfILztjLs+vKNABXyter1dGMPt7J
	 WVcSXTN7pOeXL9DkSXCJSmyk=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 954DF40E016B;
	Mon, 18 Mar 2024 20:21:34 +0000 (UTC)
Date: Mon, 18 Mar 2024 21:21:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>, Marc Zyngier <maz@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	David Matlack <dmatlack@google.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Breno Leitao <leitao@debian.org>, kvm@vger.kernel.org
Subject: Re: [BUG net-next] arch/x86/kernel/cpu/bugs.c:2935: "Unpatched
 return thunk in use. This should not happen!" [STACKTRACE]
Message-ID: <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>

On Mon, Mar 18, 2024 at 08:47:26PM +0100, Mirsad Todorovac wrote:
> With the latest net-next v6.8-5204-g237bb5f7f7f5 kernel, while running kselftest, there was this
> trap and stacktrace:

Send your kernel .config and how exactly you're triggering it, please.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

