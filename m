Return-Path: <kvm+bounces-63027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2138C58C92
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 17:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ED7E3A2F9F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 16:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110A130AAC4;
	Thu, 13 Nov 2025 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="THPvzLqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3BB2F5316;
	Thu, 13 Nov 2025 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763050811; cv=none; b=ScMRuh7O/XuNcXHR95aRDPGj5CDC1Dpzczy8dG68HeNtnsgC4zD+1x9m7SjOjNJHy0I5CJwx3KHaiDQxf62FXOgQllJ13eT1xgefLtvi1Zyy3nQHyaqu8jDDapsIYINsQEheVVcbgH4YuUUMnsBTcSTDUlUyG2PhGnAbLil0Nrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763050811; c=relaxed/simple;
	bh=iju4UxEjC6Er8r/XHnOtVmZHRm/BGYvhT4UITzxjpng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKWz/uXdNWUqJlj89shqdYVEZyVaNpiK3eTCLZn1GI1hGY2hr02riGd/fLWblC2H5311i5y1TU0riIFlAw7ZS9PDbZcbBjYzPVfYfbaRqzf7Aa94L6f8qYuGt3F9ZB1qkjq1yT8KXpqdknEYkUdDcX4cYJwcJ0llZQ2y9vpPGV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=THPvzLqh; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CFE2E40E022E;
	Thu, 13 Nov 2025 16:20:05 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lDaDVhbwhSWZ; Thu, 13 Nov 2025 16:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763050800; bh=Brp04zwnPVYxaZ0H/+uagz7v1Dnnya1p0aoJs22dp1A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=THPvzLqhPkn3Wt23XC2uI3hZGvvRgIv3UyS6fOAsoha+bU+Q+u1jF1b/USaruVPC6
	 d2hkGzv4jOAzcnAtOobIWNsEhrmHZc7wz5bP37PnFbmSJ8JLoHlSufZUZprIebzBHf
	 BivaqLNzINTNmIgZD2tJ23UlmowLAI0HWXHVj+aejUF9KXWlXyI4rqySXwWBzVntii
	 ePZV2GYT1ZO39IP5RYZZibHI1qQbYobGpknY0jOYK2IKD7p8TSojy+1YQqykIMaOby
	 QRXVs91tNvzpQ4elB9HT0sE8XFDCnwTAsh4bgc6DIcIu846ziIIrMYiEH9QQMdJHzO
	 7eIPRX7GhlvPsBU9WgNabBOaEme2plVzOQGyxClmn2CghBuVivD7hTG/BRkKvrpm0k
	 XLnfx/uly+JdaeimJvYulHRTw+BRTPaEGJOAlRBnwRXUPTcyq959IEnT3Ttk3zumBK
	 rlrYAWJola05IJ4IPw0G+SDxboE8QOvjac32hRy4BiugrK+OtNDkW0Mi6MGu8Qmytl
	 BEbhXHjy+VrxgQdGMQOpuR0DJQSQKcb2+ynPnTRf08MpexodWp67ua3Wg5EQ+3FNpl
	 9inu/0DUL8farDMYp/u4qhKCQsSLb4Wet1njmST1hj05jgFHEr5bbIDWtFaNZvJXb2
	 c5zlZiGR8jpOoNUEIZddz7uA=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id E30A040E0216;
	Thu, 13 Nov 2025 16:19:50 +0000 (UTC)
Date: Thu, 13 Nov 2025 17:19:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 5/8] x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM
 as SVM_CLEAR_CPU_BUFFERS
Message-ID: <20251113161944.GDaRYFIFXihcRSSBkU@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-6-seanjc@google.com>
 <20251113150309.GCaRXzLS0X5lvy7Xlb@fat_crate.local>
 <aRX7UDGm3LHFnPAg@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRX7UDGm3LHFnPAg@google.com>

On Thu, Nov 13, 2025 at 07:37:52AM -0800, Sean Christopherson wrote:
> On Thu, Nov 13, 2025, Borislav Petkov wrote:
> > On Thu, Oct 30, 2025 at 05:30:37PM -0700, Sean Christopherson wrote:
> > > Now that VMX encodes its own sequency for clearing CPU buffers, move
> > 
> > Now that VMX encodes its own sequency for clearing CPU buffers, move
> > Unknown word [sequency] in commit message.
> > Suggestions: ['sequence',
> > 
> > Please introduce a spellchecker into your patch creation workflow. :)
> 
> I use codespell, but it's obviously imperfect.  Do you use something fancier?

Fancy? no.

Homegrown and thus moldable as time provides? Yeah:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/tree/.tip/bin/vp.py?h=vp&id=880f7f0393ae7d10643aeab32234086ee253687a#n815

That's my patch checker.

I also have enabled spellchecking in vim when I write the commit message.

But meh, typos will slip from time to time regardless...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

