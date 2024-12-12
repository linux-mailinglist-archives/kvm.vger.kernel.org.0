Return-Path: <kvm+bounces-33581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB739EE797
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 14:20:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41519282B76
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 13:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7EE2144B5;
	Thu, 12 Dec 2024 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G0+gJTno";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cuEiBk2+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="G0+gJTno";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cuEiBk2+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26DC8460;
	Thu, 12 Dec 2024 13:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734009622; cv=none; b=LyoF6o7eNY+xJ0SejtgdVMRZU9UeIAR7cfARpMNuijQ6RNBDk2zs7snK5AgneYuSa7XGjm0BTFaq5QFKg+ZEBpmpcttbYPcjQaf60aFUtFjKwi2wxUz72/7NDgwpoutXJtxaxNfGfgfCjPHWp8vBLNHSyP9hlUuSqSzylL/jTJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734009622; c=relaxed/simple;
	bh=RuBZZVZR/zpDr6wQTF/Q6Eb3oLViIXkKqpAw7lRRL7A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NZTlDcAlDKpHGJ5hAYWShAekNBjdOJ/wVg94Oyw0D5mz5WTXVKihZVCs43HL2ZR6t8RaFzGDgQJ+yvbp5v5jbxnalAbwlckjoTnIWv3euDSBahn73oppPAH0aQ+CpPg77A//GhoCFhl67Kksyxb/sWtKiHmW5V6dpbYUNFFXDts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G0+gJTno; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cuEiBk2+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=G0+gJTno; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cuEiBk2+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from hawking.nue2.suse.org (unknown [IPv6:2a07:de40:a101:3:92b1:1cff:fe69:ddc])
	by smtp-out1.suse.de (Postfix) with ESMTP id BB45D21101;
	Thu, 12 Dec 2024 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734009616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c/BWGvQPrZx2VHJH6gXJ70AF/i/mUx48F5PDLOR50PU=;
	b=G0+gJTnoNUBFKzXQ4WQdL/D4JqMKS8EvUtjFsiWsyUm2pLxNLogguxPwUo2ZeXJFBmlzkz
	fbThzBNsG1+RTFxx51a5DGee6Ph9hN35lTzzAQwhKqV2+YClrk/wODGK96uN2SeHTmDF+p
	tNAvs4XCtfSI0A7s+4ViFDLou/bg0mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734009616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c/BWGvQPrZx2VHJH6gXJ70AF/i/mUx48F5PDLOR50PU=;
	b=cuEiBk2+3CQcFyPi+Uu6D+a4mOnk4kxWb1z60nRnw4qTO0YlaBwz++/xEghS/mwF1Ji+rw
	nwAbqgS963ggK/CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=G0+gJTno;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cuEiBk2+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1734009616; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c/BWGvQPrZx2VHJH6gXJ70AF/i/mUx48F5PDLOR50PU=;
	b=G0+gJTnoNUBFKzXQ4WQdL/D4JqMKS8EvUtjFsiWsyUm2pLxNLogguxPwUo2ZeXJFBmlzkz
	fbThzBNsG1+RTFxx51a5DGee6Ph9hN35lTzzAQwhKqV2+YClrk/wODGK96uN2SeHTmDF+p
	tNAvs4XCtfSI0A7s+4ViFDLou/bg0mA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1734009616;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c/BWGvQPrZx2VHJH6gXJ70AF/i/mUx48F5PDLOR50PU=;
	b=cuEiBk2+3CQcFyPi+Uu6D+a4mOnk4kxWb1z60nRnw4qTO0YlaBwz++/xEghS/mwF1Ji+rw
	nwAbqgS963ggK/CQ==
Received: by hawking.nue2.suse.org (Postfix, from userid 17005)
	id 4187A4A05D9; Thu, 12 Dec 2024 14:20:16 +0100 (CET)
From: Andreas Schwab <schwab@suse.de>
To: Arnd Bergmann <arnd@kernel.org>
Cc: kvm@vger.kernel.org,  Arnd Bergmann <arnd@arndb.de>,  Thomas
 Bogendoerfer <tsbogend@alpha.franken.de>,  Huacai Chen
 <chenhuacai@kernel.org>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Michael
 Ellerman <mpe@ellerman.id.au>,  Nicholas Piggin <npiggin@gmail.com>,
  Christophe Leroy <christophe.leroy@csgroup.eu>,  Naveen N Rao
 <naveen@kernel.org>,  Madhavan Srinivasan <maddy@linux.ibm.com>,
  Alexander Graf <graf@amazon.com>,  Crystal Wood <crwood@redhat.com>,
  Anup Patel <anup@brainfault.org>,  Atish Patra <atishp@atishpatra.org>,
  Paul Walmsley <paul.walmsley@sifive.com>,  Palmer Dabbelt
 <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,  Sean
 Christopherson <seanjc@google.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  Thomas Gleixner <tglx@linutronix.de>,  Ingo Molnar <mingo@redhat.com>,
  Borislav Petkov <bp@alien8.de>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Vitaly Kuznetsov <vkuznets@redhat.com>,  David Woodhouse
 <dwmw2@infradead.org>,  Paul Durrant <paul@xen.org>,  Marc Zyngier
 <maz@kernel.org>,  linux-kernel@vger.kernel.org,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org
Subject: Re: [RFC 1/5] mips: kvm: drop support for 32-bit hosts
In-Reply-To: <20241212125516.467123-2-arnd@kernel.org> (Arnd Bergmann's
	message of "Thu, 12 Dec 2024 13:55:12 +0100")
References: <20241212125516.467123-1-arnd@kernel.org>
	<20241212125516.467123-2-arnd@kernel.org>
Date: Thu, 12 Dec 2024 14:20:16 +0100
Message-ID: <mvm4j39ghrj.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: **
X-Spamd-Result: default: False [2.59 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	RDNS_NONE(2.00)[];
	ONCE_RECEIVED(1.20)[];
	HFILTER_HELO_IP_A(1.00)[hawking.nue2.suse.org];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[hawking.nue2.suse.org];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_NO_TLS_LAST(0.10)[];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[35];
	DIRECT_TO_MX(0.00)[Gnus/5.13 (Gnus v5.13)];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,arndb.de,alpha.franken.de,kernel.org,flygoat.com,ellerman.id.au,gmail.com,csgroup.eu,linux.ibm.com,amazon.com,redhat.com,brainfault.org,atishpatra.org,sifive.com,dabbelt.com,eecs.berkeley.edu,google.com,linutronix.de,alien8.de,linux.intel.com,zytor.com,infradead.org,xen.org,lists.ozlabs.org,lists.infradead.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLrhtxphh58n7g1ptxk8ecsouj),from(RLajr16mudzow8bnf6sy)];
	RCVD_COUNT_ONE(0.00)[1];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid]
X-Spam-Score: 2.59
X-Spamd-Bar: ++
X-Rspamd-Queue-Id: BB45D21101
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO

On Dez 12 2024, Arnd Bergmann wrote:

> KVM support on MIPS was added in 2012 with both 32-bit and 32-bit mode

s/32-bit/64-bit/ (once)

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."

