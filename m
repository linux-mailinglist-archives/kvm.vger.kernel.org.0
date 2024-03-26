Return-Path: <kvm+bounces-12689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D26FF88BF1E
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86C781F62D2B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCA36BB39;
	Tue, 26 Mar 2024 10:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ItdxkdOe"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922A7EAF6;
	Tue, 26 Mar 2024 10:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711448240; cv=none; b=qzmMfqKVaFObqiR7eXXMUgBDUKggpeJDlpS7OWrJaiFlpAFbtej27uOLDShkks7abhcm7KRfU06JfzBwUjmadhXNUvTj+vN/xgaUjMdBTPK5CFAQZ7kvMh2mt60C9GUrt4UV9AGImRnLDoAIrnpzSffprTqCXmOEj2nckzH9fuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711448240; c=relaxed/simple;
	bh=f8P+HvRNSxwumEsUKb4t+yPV/HhejyzHEDnEZXjEd1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzFiULKDRhWFzecEbSf47lmwZ4wNfVr7TVWWofP5SkGu779sCSsljctvqjS0j46CugNwJAvnkrUcj4EkPfzQkmdJV58SmjhxyJw3C31SNtWBWaiNJEW5m/0m+wbU888oNS6P2UslXJpFMsaPBGMewhzzOd877ZhIrs3ue1WdIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ItdxkdOe; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9A44840E024C;
	Tue, 26 Mar 2024 10:17:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NfdiRrir3uHM; Tue, 26 Mar 2024 10:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1711448229; bh=CDmK/0QYSIOIpZwH6go7HxA/MlzIItJgpVzSJbzTjCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ItdxkdOebiOZcO2glgj9DRQyiSPYumneMfig51XeVVNYwEHdJgq9ar+rwNG1WgnGr
	 w307OggfvCRulmidXKSHutFuUykq5gPqFTVJWf5Vg3OSUhy/uymWxTw4LzEyLt5TkQ
	 mEnFlJ0Lp9bjiqR6i8AWQqyYnGA3SY3c2jyueID7NT0iIjvKMDKFJbVUV1NVq4b1zC
	 0Q8ZsaPxdUfUnmq9IR7XD2JPwKm5AYuUv93QTm8+5ZhlOjlCjvepT3M3Ll5YhsIhF1
	 JiPClqwXr5nqNf3kyKHQqemMauaoxwYmZSYxs3GYIgxRZ40IQDhx2csWRSDPMQdGUf
	 NPosDN6vj/m3ubr4vATQpNbhjl3xbRnE+dhQqZpgYFKnlO4vd7VwdioWxF4w5g4j+y
	 lfyM/U9SNWXHJABlWu55+Xht1+K2DKOMV7oIa8oBTLdQkjTRUiey4R04RiqagjFioS
	 tg41yPJ2K2nSliMprEbOydXf3n0UHL9smJnaK3XaJHZAp9wWZFnDVmq1OrFR+YmycR
	 kgAJpS7PC6o4XlbiOzMuhyFAoK0cpSJHOWsFGvmyXIiDm1ammvUOzCDloTzvKKwElG
	 lI9AX8ynroWDaBPYNjQSPFAZoWr0XSYBLFIcZ/6cZSb93ktFRTYftnRb7SpDzPTPmr
	 kPlsWj2T3kBiLm3GV19+Ip5w=
Received: from zn.tnic (p5de8ecf7.dip0.t-ipconnect.de [93.232.236.247])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8D69840E02A2;
	Tue, 26 Mar 2024 10:16:51 +0000 (UTC)
Date: Tue, 26 Mar 2024 11:16:42 +0100
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
Message-ID: <20240326101642.GAZgKgisKXLvggu8Cz@fat_crate.local>
References: <1d10cd73-2ae7-42d5-a318-2f9facc42bbe@alu.unizg.hr>
 <20240318202124.GCZfiiRGVV0angYI9j@fat_crate.local>
 <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12619bd4-9e9e-4883-8706-55d050a4d11a@alu.unizg.hr>

On Wed, Mar 20, 2024 at 02:28:57AM +0100, Mirsad Todorovac wrote:
> Please find the kernel .config attached.

Thanks, that's one huuuge kernel you're building. :)

> I got another one of these "Unpatched thunk" and it seems connected
> with selftest/kvm.
>
> But running selftests/kvm one by one did not trigger the bug.

Which commands are you exactly running?

I'll try to reproduce here.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

