Return-Path: <kvm+bounces-33339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFB9B9EA0C2
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 21:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DDBB28286E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 20:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4DA19C556;
	Mon,  9 Dec 2024 20:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Eb/MkI8F"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6781E515;
	Mon,  9 Dec 2024 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777985; cv=none; b=q0S+ZESQ+OFTf4fteN0J3BaQSO9CNBk5JYd/+m9m8R04DrhM9JEFpoDOJ13I6xqAat35VmN0RpXKgv4nTevTJT+n3HzPA9wtGgi3OWc2MeoseLqwnhlVVerrzX79WdBohKcjztcEzlm2+QxauiT7tcyzmoeUmtv8d4SW7igKLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777985; c=relaxed/simple;
	bh=6F253q1bP4hFQ4CTX7E3Gj9voPgKJMAgyH5Brvg1QNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fugwuSvHShBUq/EfCFL0iBHjSzSMEnIR9ZUtq6q9VxEFDbnDi0ltHVzMfYaKpP33W5cE+zy+zngQfRFxVr5wxJlOejNb6LkfcTjuPMcR/tm2v083oXVm9SGqEhrksSLTthd+dZ6dRMOY2XUE3G2K7EQ5NDkpJPeSS0TnpNJggD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Eb/MkI8F; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A071440E0163;
	Mon,  9 Dec 2024 20:59:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q-MttY1gMkCC; Mon,  9 Dec 2024 20:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733777977; bh=j34DbBopasUmlYopaVk4hmicBSqH6pZ3N5IXLDb1yhQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eb/MkI8F483Qp8p/u5ipAyCKcd3iIqkWKkfuy2ffDG5Cexw2tA5+WYplHEzAhUhrR
	 WLcrQbFg4c6/GynUahfzl9YgXh6IKMjP9VLE9X1GkS4xj7YOO1X8U/uqYuZy7k05Hr
	 /aiwzzwWSi77cFsMyHW32maU7hHUhZBfGOeoJ/xX6L/jCkP16McADTwuWmV4ChUyjP
	 HbnWM++hIS1zs3fAGWhsr+UB0dNNsC5TgOCp+pycgMC1EKk7KXdoj/lFj9xQAaOi35
	 EZSfPhQxyLoKvqftu2qC2baMsam62L3WB4ViHwQJ7WKwzmHdY0bfwje2Usqoqx8wG1
	 1mEbPDvGwOGhYMg+lsD0yyNtUBJQ6OJrRjhPPIv96ePQJAfaMYH4uT2XattrZxH4ui
	 XMlx/qu0h0VvAHDXGVFsi2mqXp2A+VQ+mdabkwmiOMNKH6F2p7obegHZJBbiJqmLEm
	 EcGyWzdrCddKSW6A8uQeRDwn+9b99nIalNpJx2JHGDg8oHp303gqWkBgBXSJTRKVWz
	 Xkk+MfjF0IKwTzcYcPT38S31HAl+4VUA0+nmh4qoZdlSRmqxUZAvlizozuZWIyxyuH
	 3Qnimj9eJQxWWqqfAvsS8VzZWKbzG5JSfyyxhP0RvsPMTMju1R309YDdvtz7uk+nJ+
	 jCzacfw5YOkn9tagyipIiKNo=
Received: from zn.tnic (p200300EA971F9307329c23FFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8095640E015E;
	Mon,  9 Dec 2024 20:59:29 +0000 (UTC)
Date: Mon, 9 Dec 2024 21:59:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, x86@kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: Hitting AUTOIBRS WARN_ON_ONCE() in init_amd() booting 32-bit
 kernel under KVM
Message-ID: <20241209205923.GJZ1daK9ItN2sOp0MK@fat_crate.local>
References: <20241205220604.GA2054199@thelio-3990X>
 <Z1MkNofJjt7Oq0G6@google.com>
 <20241209204414.psmh3yyllnwbrc4y@jpoimboe>
 <Z1dZAD4_kgmm-B-_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1dZAD4_kgmm-B-_@google.com>

On Mon, Dec 09, 2024 at 12:54:24PM -0800, Sean Christopherson wrote:
> In Boris I trust :-)

Oh wow. Like I'm on money and stuff. :-P

It should actually be

s/Boris/Ingo/

who fished it out.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

