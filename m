Return-Path: <kvm+bounces-65955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C74ECBCF43
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 09:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 96403300A8CE
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 08:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BAF329C4B;
	Mon, 15 Dec 2025 08:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DdqbTRt9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DdqbTRt9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F9E26B74A
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 08:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765787246; cv=none; b=S9ncisYlwz32W6D4Pco8bQh2PkaqLvI7B+9n/dG3OSavXhx5L7jGdr2SyyY+hKk3VUm8rnLdmSdprml+sktKduYdqBG6Nimr7fd1uYXCnq0vtdThPwUIq6dQgejFmFvtgELlzBMmCBuZAEWkjy01b/vclfV6+WM+uOfhUrG77YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765787246; c=relaxed/simple;
	bh=D1PdhQq0nBnBcE4r6WkXIXGsHurVAm+uRoVHZnq7238=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qpwx0rJbkg4zXt299rZR/xsW8jQEbOVZzcL4z4fXlbLOwiE3i4WMXXkMc3mro8yS6f0kGNWVtQ0tspj/lLiSWSnZMjhbwlmCbf/iEvbMRVSEnBEkvbriUllfX25EW/0MinReSDH+vhqVihqmS1eClsmJbvhe0HCEmkaaOkcq788=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DdqbTRt9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DdqbTRt9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 030925BD16;
	Mon, 15 Dec 2025 08:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765787241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D1PdhQq0nBnBcE4r6WkXIXGsHurVAm+uRoVHZnq7238=;
	b=DdqbTRt9mhUwvQFkLZ7Lv1xTepgxpApbXxc3dyfkCV1zTa8YlL4VXizbUVIrd5CnikZtqz
	DYCI4iKlXEPLtBCZ2lhvBt40qs6FrJw3G+eba1AAHW5bZR59AxejJKkjGynQjweQ8V/WFs
	XOo8n+/QGs/IytB8fDvXfderPttfQUw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DdqbTRt9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765787241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=D1PdhQq0nBnBcE4r6WkXIXGsHurVAm+uRoVHZnq7238=;
	b=DdqbTRt9mhUwvQFkLZ7Lv1xTepgxpApbXxc3dyfkCV1zTa8YlL4VXizbUVIrd5CnikZtqz
	DYCI4iKlXEPLtBCZ2lhvBt40qs6FrJw3G+eba1AAHW5bZR59AxejJKkjGynQjweQ8V/WFs
	XOo8n+/QGs/IytB8fDvXfderPttfQUw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ABC183EA63;
	Mon, 15 Dec 2025 08:27:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N2AAJ2bGP2nxVQAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 15 Dec 2025 08:27:18 +0000
Message-ID: <e1fc4cbd-0a7a-4453-bc0c-f9aba15c8150@suse.com>
Date: Mon, 15 Dec 2025 09:27:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/21] paravirt: cleanup and reorg
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>, Jiri Kosina <jikos@kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, Oleg Nesterov <oleg@redhat.com>
References: <20251127070844.21919-1-jgross@suse.com>
Content-Language: en-US
From: Juergen Gross <jgross@suse.com>
Autocrypt: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==
In-Reply-To: <20251127070844.21919-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YyphMvfItp3TyHBNEvp0WSxz"
X-Spam-Flag: NO
X-Spam-Score: -3.91
X-Rspamd-Queue-Id: 030925BD16
X-Spamd-Result: default: False [-3.91 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FROM_HAS_DN(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linutronix.de,redhat.com,alien8.de,linux.intel.com,zytor.com,microsoft.com,infradead.org,gmail.com,oracle.com,lists.xenproject.org,broadcom.com,armlinux.org.uk,arm.com,xen0n.name,linux.ibm.com,ellerman.id.au,csgroup.eu,dabbelt.com,eecs.berkeley.edu,ghiti.fr,linaro.org,goodmis.org,google.com,suse.de,lists.infradead.org,epam.com];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[56];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YyphMvfItp3TyHBNEvp0WSxz
Content-Type: multipart/mixed; boundary="------------dmv0z0qelhOAJxC2cC0LuZyw";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>, Jiri Kosina <jikos@kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Russell King
 <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, Oleg Nesterov <oleg@redhat.com>
Message-ID: <e1fc4cbd-0a7a-4453-bc0c-f9aba15c8150@suse.com>
Subject: Re: [PATCH v4 00/21] paravirt: cleanup and reorg
References: <20251127070844.21919-1-jgross@suse.com>
In-Reply-To: <20251127070844.21919-1-jgross@suse.com>

--------------dmv0z0qelhOAJxC2cC0LuZyw
Content-Type: multipart/mixed; boundary="------------vwtdjJ2TzsEgHt1ivKzjZJmN"

--------------vwtdjJ2TzsEgHt1ivKzjZJmN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QXQgbGVhc3QgZm9yIHBhdGNoZXMgMS0xMjogUGluZz8NCg0KV291bGQgYmUgbmljZSB0byBo
YXZlIHNvbWUgZmVlZGJhY2sgZm9yIDEzLTIxLCB0b28gKHBhdGNoIDIxIG5lZWRzIGFuDQp1
cGRhdGUsIHRob3VnaCkuDQoNCg0KSnVlcmdlbg0KDQpPbiAyNy4xMS4yNSAwODowOCwgSnVl
cmdlbiBHcm9zcyB3cm90ZToNCj4gU29tZSBjbGVhbnVwcyBhbmQgcmVvcmcgb2YgcGFyYXZp
cnQgY29kZSBhbmQgaGVhZGVyczoNCj4gDQo+IC0gVGhlIGZpcnN0IDIgcGF0Y2hlcyBzaG91
bGQgYmUgbm90IGNvbnRyb3ZlcnNpYWwgYXQgYWxsLCBhcyB0aGV5DQo+ICAgIHJlbW92ZSBq
dXN0IHNvbWUgbm8gbG9uZ2VyIG5lZWRlZCAjaW5jbHVkZSBhbmQgc3RydWN0IGZvcndhcmQN
Cj4gICAgZGVjbGFyYXRpb25zLg0KPiANCj4gLSBUaGUgM3JkIHBhdGNoIGlzIHJlbW92aW5n
IENPTkZJR19QQVJBVklSVF9ERUJVRywgd2hpY2ggSU1PIGhhcw0KPiAgICBubyByZWFsIHZh
bHVlLCBhcyBpdCBqdXN0IGNoYW5nZXMgYSBjcmFzaCB0byBhIEJVRygpICh0aGUgc3RhY2sN
Cj4gICAgdHJhY2Ugd2lsbCBiYXNpY2FsbHkgYmUgdGhlIHNhbWUpLiBBcyB0aGUgbWFpbnRh
aW5lciBvZiB0aGUgbWFpbg0KPiAgICBwYXJhdmlydCB1c2VyIChYZW4pIEkgaGF2ZSBuZXZl
ciBzZWVuIHRoaXMgY3Jhc2gvQlVHKCkgdG8gaGFwcGVuLg0KPiANCj4gLSBUaGUgNHRoIHBh
dGNoIGlzIGp1c3QgYSBtb3ZlbWVudCBvZiBjb2RlLg0KPiANCj4gLSBJIGRvbid0IGtub3cg
Zm9yIHdoYXQgcmVhc29uIGFzbS9wYXJhdmlydF9hcGlfY2xvY2suaCB3YXMgYWRkZWQsDQo+
ICAgIGFzIGFsbCBhcmNocyBzdXBwb3J0aW5nIGl0IGRvIGl0IGV4YWN0bHkgaW4gdGhlIHNh
bWUgd2F5LiBQYXRjaA0KPiAgICA1IGlzIHJlbW92aW5nIGl0Lg0KPiANCj4gLSBQYXRjaGVz
IDYtMTQgYXJlIHN0cmVhbWxpbmluZyB0aGUgcGFyYXZpcnQgY2xvY2sgaW50ZXJmYWNlcyBi
eQ0KPiAgICB1c2luZyBhIGNvbW1vbiBpbXBsZW1lbnRhdGlvbiBhY3Jvc3MgYXJjaGl0ZWN0
dXJlcyB3aGVyZSBwb3NzaWJsZQ0KPiAgICBhbmQgYnkgbW92aW5nIHRoZSByZWxhdGVkIGNv
ZGUgaW50byBjb21tb24gc2NoZWQgY29kZSwgYXMgdGhpcyBpcw0KPiAgICB3aGVyZSBpdCBz
aG91bGQgbGl2ZS4NCj4gDQo+IC0gUGF0Y2hlcyAxNS0yMCBhcmUgbW9yZSBsaWtlIFJGQyBt
YXRlcmlhbCBwcmVwYXJpbmcgdGhlIHBhcmF2aXJ0DQo+ICAgIGluZnJhc3RydWN0dXJlIHRv
IHN1cHBvcnQgbXVsdGlwbGUgcHZfb3BzIGZ1bmN0aW9uIGFycmF5cy4NCj4gICAgQXMgYSBw
cmVyZXF1aXNpdGUgZm9yIHRoYXQgaXQgbWFrZXMgbGlmZSBpbiBvYmp0b29sIG11Y2ggZWFz
aWVyDQo+ICAgIHdpdGggZHJvcHBpbmcgdGhlIFhlbiBzdGF0aWMgaW5pdGlhbGl6ZXJzIG9m
IHRoZSBwdl9vcHMgc3ViLQ0KPiAgICBzdHJ1Y3R1cmVzLCB3aGljaCBpcyBkb25lIGluIHBh
dGNoZXMgMTUtMTcuDQo+ICAgIFBhdGNoZXMgMTgtMjAgYXJlIGRvaW5nIHRoZSByZWFsIHBy
ZXBhcmF0aW9ucyBmb3IgbXVsdGlwbGUgcHZfb3BzDQo+ICAgIGFycmF5cyBhbmQgdXNpbmcg
dGhvc2UgYXJyYXlzIGluIG11bHRpcGxlIGhlYWRlcnMuDQo+IA0KPiAtIFBhdGNoIDIxIGlz
IGFuIGV4YW1wbGUgaG93IHRoZSBuZXcgc2NoZW1lIGNhbiBsb29rIGxpa2UgdXNpbmcgdGhl
DQo+ICAgIFBWLXNwaW5sb2Nrcy4NCj4gDQo+IENoYW5nZXMgaW4gVjI6DQo+IC0gbmV3IHBh
dGNoZXMgMTMtMTggYW5kIDIwDQo+IC0gY29tcGxldGUgcmV3b3JrIG9mIHBhdGNoIDIxDQo+
IA0KPiBDaGFuZ2VzIGluIFYzOg0KPiAtIGZpeGVkIDIgaXNzdWVzIGRldGVjdGVkIGJ5IGtl
cm5lbCB0ZXN0IHJvYm90DQo+IA0KPiBDaGFuZ2VzIGluIFY0Og0KPiAtIGZpeGVkIG9uZSBi
dWlsZCBpc3N1ZQ0KPiANCj4gSnVlcmdlbiBHcm9zcyAoMjEpOg0KPiAgICB4ODYvcGFyYXZp
cnQ6IFJlbW92ZSBub3QgbmVlZGVkIGluY2x1ZGVzIG9mIHBhcmF2aXJ0LmgNCj4gICAgeDg2
L3BhcmF2aXJ0OiBSZW1vdmUgc29tZSB1bm5lZWRlZCBzdHJ1Y3QgZGVjbGFyYXRpb25zDQo+
ICAgIHg4Ni9wYXJhdmlydDogUmVtb3ZlIFBBUkFWSVJUX0RFQlVHIGNvbmZpZyBvcHRpb24N
Cj4gICAgeDg2L3BhcmF2aXJ0OiBNb3ZlIHRodW5rIG1hY3JvcyB0byBwYXJhdmlydF90eXBl
cy5oDQo+ICAgIHBhcmF2aXJ0OiBSZW1vdmUgYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+
ICAgIHNjaGVkOiBNb3ZlIGNsb2NrIHJlbGF0ZWQgcGFyYXZpcnQgY29kZSB0byBrZXJuZWwv
c2NoZWQNCj4gICAgYXJtL3BhcmF2aXJ0OiBVc2UgY29tbW9uIGNvZGUgZm9yIHBhcmF2aXJ0
X3N0ZWFsX2Nsb2NrKCkNCj4gICAgYXJtNjQvcGFyYXZpcnQ6IFVzZSBjb21tb24gY29kZSBm
b3IgcGFyYXZpcnRfc3RlYWxfY2xvY2soKQ0KPiAgICBsb29uZ2FyY2gvcGFyYXZpcnQ6IFVz
ZSBjb21tb24gY29kZSBmb3IgcGFyYXZpcnRfc3RlYWxfY2xvY2soKQ0KPiAgICByaXNjdi9w
YXJhdmlydDogVXNlIGNvbW1vbiBjb2RlIGZvciBwYXJhdmlydF9zdGVhbF9jbG9jaygpDQo+
ICAgIHg4Ni9wYXJhdmlydDogVXNlIGNvbW1vbiBjb2RlIGZvciBwYXJhdmlydF9zdGVhbF9j
bG9jaygpDQo+ICAgIHg4Ni9wYXJhdmlydDogTW92ZSBwYXJhdmlydF9zY2hlZF9jbG9jaygp
IHJlbGF0ZWQgY29kZSBpbnRvIHRzYy5jDQo+ICAgIHg4Ni9wYXJhdmlydDogSW50cm9kdWNl
IG5ldyBwYXJhdmlydC1iYXNlLmggaGVhZGVyDQo+ICAgIHg4Ni9wYXJhdmlydDogTW92ZSBw
dl9uYXRpdmVfKigpIHByb3RvdHlwZXMgdG8gcGFyYXZpcnQuYw0KPiAgICB4ODYveGVuOiBE
cm9wIHhlbl9pcnFfb3BzDQo+ICAgIHg4Ni94ZW46IERyb3AgeGVuX2NwdV9vcHMNCj4gICAg
eDg2L3hlbjogRHJvcCB4ZW5fbW11X29wcw0KPiAgICBvYmp0b29sOiBBbGxvdyBtdWx0aXBs
ZSBwdl9vcHMgYXJyYXlzDQo+ICAgIHg4Ni9wYXJhdmlydDogQWxsb3cgcHYtY2FsbHMgb3V0
c2lkZSBwYXJhdmlydC5oDQo+ICAgIHg4Ni9wYXJhdmlydDogU3BlY2lmeSBwdl9vcHMgYXJy
YXkgaW4gcGFyYXZpcnQgbWFjcm9zDQo+ICAgIHg4Ni9wdmxvY2tzOiBNb3ZlIHBhcmF2aXJ0
IHNwaW5sb2NrIGZ1bmN0aW9ucyBpbnRvIG93biBoZWFkZXINCj4gDQo+ICAgYXJjaC9LY29u
ZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAzICsNCj4gICBhcmNo
L2FybS9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAg
IGFyY2gvYXJtL2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICAgICAgICB8ICAyMiAt
LQ0KPiAgIGFyY2gvYXJtL2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oICAgICB8
ICAgMSAtDQo+ICAgYXJjaC9hcm0va2VybmVsL01ha2VmaWxlICAgICAgICAgICAgICAgICAg
ICAgIHwgICAxIC0NCj4gICBhcmNoL2FybS9rZXJuZWwvcGFyYXZpcnQuYyAgICAgICAgICAg
ICAgICAgICAgfCAgMjMgLS0NCj4gICBhcmNoL2FybTY0L0tjb25maWcgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vcGFy
YXZpcnQuaCAgICAgICAgICAgICB8ICAxNCAtDQo+ICAgYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9wYXJhdmlydF9hcGlfY2xvY2suaCAgIHwgICAxIC0NCj4gICBhcmNoL2FybTY0L2tlcm5l
bC9wYXJhdmlydC5jICAgICAgICAgICAgICAgICAgfCAgMTEgKy0NCj4gICBhcmNoL2xvb25n
YXJjaC9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiAgIGFyY2gv
bG9vbmdhcmNoL2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICB8ICAxMyAtDQo+ICAg
Li4uL2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oICAgICAgICAgIHwgICAxIC0N
Cj4gICBhcmNoL2xvb25nYXJjaC9rZXJuZWwvcGFyYXZpcnQuYyAgICAgICAgICAgICAgfCAg
MTAgKy0NCj4gICBhcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vcGFyYXZpcnQuaCAgICAgICAg
ICAgfCAgIDMgLQ0KPiAgIGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9wYXJhdmlydF9hcGlf
Y2xvY2suaCB8ICAgMiAtDQo+ICAgYXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9wc2VyaWVzL3Nl
dHVwLmMgICAgICAgIHwgICA0ICstDQo+ICAgYXJjaC9yaXNjdi9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNt
L3BhcmF2aXJ0LmggICAgICAgICAgICAgfCAgMTQgLQ0KPiAgIGFyY2gvcmlzY3YvaW5jbHVk
ZS9hc20vcGFyYXZpcnRfYXBpX2Nsb2NrLmggICB8ICAgMSAtDQo+ICAgYXJjaC9yaXNjdi9r
ZXJuZWwvcGFyYXZpcnQuYyAgICAgICAgICAgICAgICAgIHwgIDExICstDQo+ICAgYXJjaC94
ODYvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA4ICstDQo+ICAg
YXJjaC94ODYvZW50cnkvZW50cnlfNjQuUyAgICAgICAgICAgICAgICAgICAgIHwgICAxIC0N
Cj4gICBhcmNoL3g4Ni9lbnRyeS92c3lzY2FsbC92c3lzY2FsbF82NC5jICAgICAgICAgfCAg
IDEgLQ0KPiAgIGFyY2gveDg2L2h5cGVydi9odl9zcGlubG9jay5jICAgICAgICAgICAgICAg
ICB8ICAxMSArLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL2FwaWMuaCAgICAgICAgICAg
ICAgICAgICB8ICAgNCAtDQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vaGlnaG1lbS5oICAg
ICAgICAgICAgICAgIHwgICAxIC0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9tc2h5cGVy
di5oICAgICAgICAgICAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3Bh
cmF2aXJ0LWJhc2UuaCAgICAgICAgICB8ICAyOSArKw0KPiAgIGFyY2gveDg2L2luY2x1ZGUv
YXNtL3BhcmF2aXJ0LXNwaW5sb2NrLmggICAgICB8IDE0NiArKysrKysrKw0KPiAgIGFyY2gv
eDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICAgICAgICB8IDMzMSArKysrKy0t
LS0tLS0tLS0tLS0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF9hcGlfY2xv
Y2suaCAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X3R5
cGVzLmggICAgICAgICB8IDI2OSArKysrKysrLS0tLS0tLQ0KPiAgIGFyY2gveDg2L2luY2x1
ZGUvYXNtL3BndGFibGVfMzIuaCAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC94ODYv
aW5jbHVkZS9hc20vcHRyYWNlLmggICAgICAgICAgICAgICAgIHwgICAyICstDQo+ICAgYXJj
aC94ODYvaW5jbHVkZS9hc20vcXNwaW5sb2NrLmggICAgICAgICAgICAgIHwgIDg5ICstLS0t
DQo+ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vc3BpbmxvY2suaCAgICAgICAgICAgICAgIHwg
ICAxIC0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90aW1lci5oICAgICAgICAgICAgICAg
ICAgfCAgIDEgKw0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3RsYmZsdXNoLmggICAgICAg
ICAgICAgICB8ICAgNCAtDQo+ICAgYXJjaC94ODYva2VybmVsL01ha2VmaWxlICAgICAgICAg
ICAgICAgICAgICAgIHwgICAyICstDQo+ICAgYXJjaC94ODYva2VybmVsL2FwbV8zMi5jICAg
ICAgICAgICAgICAgICAgICAgIHwgICAxIC0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY2FsbHRo
dW5rcy5jICAgICAgICAgICAgICAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9j
cHUvYnVncy5jICAgICAgICAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC94ODYva2Vy
bmVsL2NwdS92bXdhcmUuYyAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL3g4
Ni9rZXJuZWwva3ZtLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTMgKy0NCj4gICBh
cmNoL3g4Ni9rZXJuZWwva3ZtY2xvY2suYyAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0K
PiAgIGFyY2gveDg2L2tlcm5lbC9wYXJhdmlydC1zcGlubG9ja3MuYyAgICAgICAgICB8ICAy
NiArLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9wYXJhdmlydC5jICAgICAgICAgICAgICAgICAg
ICB8ICA0MiArLS0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvdHNjLmMgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgMTAgKy0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvdnNtcF82NC5jICAgICAg
ICAgICAgICAgICAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2xpYi9jYWNoZS1zbXAuYyAg
ICAgICAgICAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC94ODYvbW0vaW5pdC5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxIC0NCj4gICBhcmNoL3g4Ni94ZW4vZW5s
aWdodGVuX3B2LmMgICAgICAgICAgICAgICAgICAgfCAgODIgKystLS0NCj4gICBhcmNoL3g4
Ni94ZW4vaXJxLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjAgKy0NCj4gICBh
cmNoL3g4Ni94ZW4vbW11X3B2LmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMDAgKyst
LS0tDQo+ICAgYXJjaC94ODYveGVuL3NwaW5sb2NrLmMgICAgICAgICAgICAgICAgICAgICAg
IHwgIDExICstDQo+ICAgYXJjaC94ODYveGVuL3RpbWUuYyAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAyICsNCj4gICBkcml2ZXJzL2Nsb2Nrc291cmNlL2h5cGVydl90aW1lci5j
ICAgICAgICAgICAgfCAgIDIgKw0KPiAgIGRyaXZlcnMveGVuL3RpbWUuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KPiAgIGluY2x1ZGUvbGludXgvc2NoZWQvY3B1
dGltZS5oICAgICAgICAgICAgICAgICB8ICAxOCArDQo+ICAga2VybmVsL3NjaGVkL2NvcmUu
YyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICA1ICsNCj4gICBrZXJuZWwvc2NoZWQv
Y3B1dGltZS5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTMgKw0KPiAgIGtlcm5lbC9z
Y2hlZC9zY2hlZC5oICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMyArLQ0KPiAgIHRv
b2xzL29ianRvb2wvYXJjaC94ODYvZGVjb2RlLmMgICAgICAgICAgICAgICB8ICAgOCArLQ0K
PiAgIHRvb2xzL29ianRvb2wvY2hlY2suYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3
OCArKysrLQ0KPiAgIHRvb2xzL29ianRvb2wvaW5jbHVkZS9vYmp0b29sL2NoZWNrLmggICAg
ICAgICB8ICAgMiArDQo+ICAgNjYgZmlsZXMgY2hhbmdlZCwgNjYxIGluc2VydGlvbnMoKyks
IDgyNiBkZWxldGlvbnMoLSkNCj4gICBkZWxldGUgbW9kZSAxMDA2NDQgYXJjaC9hcm0vaW5j
bHVkZS9hc20vcGFyYXZpcnQuaA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybS9p
bmNsdWRlL2FzbS9wYXJhdmlydF9hcGlfY2xvY2suaA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0
NCBhcmNoL2FybS9rZXJuZWwvcGFyYXZpcnQuYw0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBh
cmNoL2FybTY0L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+ICAgZGVsZXRl
IG1vZGUgMTAwNjQ0IGFyY2gvbG9vbmdhcmNoL2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9j
bG9jay5oDQo+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IGFyY2gvcG93ZXJwYy9pbmNsdWRlL2Fz
bS9wYXJhdmlydF9hcGlfY2xvY2suaA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL3Jp
c2N2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+ICAgY3JlYXRlIG1vZGUg
MTAwNjQ0IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LWJhc2UuaA0KPiAgIGNyZWF0
ZSBtb2RlIDEwMDY0NCBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC1zcGlubG9jay5o
DQo+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0
X2FwaV9jbG9jay5oDQo+IA0KDQo=
--------------vwtdjJ2TzsEgHt1ivKzjZJmN
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjri
oyspZKOBycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2
kaV2KL9650I1SJvedYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i
1TXkH09XSSI8mEQ/ouNcMvIJNwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/B
BLUVbDa4+gmzDC9ezlZkTZG2t14zWPvxXP3FAp2pkW0xqG7/377qptDmrk42GlSK
N4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEBAAHNHEp1ZXJnZW4gR3Jvc3Mg
PGpnQHBmdXBmLm5ldD7CwHkEEwECACMFAlOMcBYCGwMHCwkIBwMCAQYVCAIJCgsE
FgIDAQIeAQIXgAAKCRCw3p3WKL8TL0KdB/93FcIZ3GCNwFU0u3EjNbNjmXBKDY4F
UGNQH2lvWAUy+dnyThpwdtF/jQ6j9RwE8VP0+NXcYpGJDWlNb9/JmYqLiX2Q3Tye
vpB0CA3dbBQp0OW0fgCetToGIQrg0MbD1C/sEOv8Mr4NAfbauXjZlvTj30H2jO0u
+6WGM6nHwbh2l5O8ZiHkH32iaSTfN7Eu5RnNVUJbvoPHZ8SlM4KWm8rG+lIkGurq
qu5gu8q8ZMKdsdGC4bBxdQKDKHEFExLJK/nRPFmAuGlId1E3fe10v5QL+qHI3EIP
tyfE7i9Hz6rVwi7lWKgh7pe0ZvatAudZ+JNIlBKptb64FaiIOAWDCx1SzR9KdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+wsB5BBMBAgAjBQJTjHCvAhsDBwsJ
CAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/Ey/HmQf/RtI7kv5A2PS4
RF7HoZhPVPogNVbC4YA6lW7DrWf0teC0RR3MzXfy6pJ+7KLgkqMlrAbN/8Dvjoz7
8X+5vhH/rDLa9BuZQlhFmvcGtCF8eR0T1v0nC/nuAFVGy+67q2DH8As3KPu0344T
BDpAvr2uYM4tSqxK4DURx5INz4ZZ0WNFHcqsfvlGJALDeE0LhITTd9jLzdDad1pQ
SToCnLl6SBJZjDOX9QQcyUigZFtCXFst4dlsvddrxyqT1f17+2cFSdu7+ynLmXBK
7abQ3rwJY8SbRO2iRulogc5vr/RLMMlscDAiDkaFQWLoqHHOdfO9rURssHNN8WkM
nQfvUewRz80hSnVlcmdlbiBHcm9zcyA8amdyb3NzQG5vdmVsbC5jb20+wsB5BBMB
AgAjBQJTjHDXAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgECF4AACgkQsN6d1ii/
Ey8PUQf/ehmgCI9jB9hlgexLvgOtf7PJnFOXgMLdBQgBlVPO3/D9R8LtF9DBAFPN
hlrsfIG/SqICoRCqUcJ96Pn3P7UUinFG/I0ECGF4EvTE1jnDkfJZr6jrbjgyoZHi
w/4BNwSTL9rWASyLgqlA8u1mf+c2yUwcGhgkRAd1gOwungxcwzwqgljf0N51N5Jf
VRHRtyfwq/ge+YEkDGcTU6Y0sPOuj4Dyfm8fJzdfHNQsWq3PnczLVELStJNdapwP
OoE+lotufe3AM2vAEYJ9rTz3Cki4JFUsgLkHFqGZarrPGi1eyQcXeluldO3m91NK
/1xMI3/+8jbO0tsn1tqSEUGIJi7ox80eSnVlcmdlbiBHcm9zcyA8amdyb3NzQHN1
c2UuZGU+wsB5BBMBAgAjBQJTjHDrAhsDBwsJCAcDAgEGFQgCCQoLBBYCAwECHgEC
F4AACgkQsN6d1ii/Ey+LhQf9GL45eU5vOowA2u5N3g3OZUEBmDHVVbqMtzwlmNC4
k9Kx39r5s2vcFl4tXqW7g9/ViXYuiDXb0RfUpZiIUW89siKrkzmQ5dM7wRqzgJpJ
wK8Bn2MIxAKArekWpiCKvBOB/Cc+3EXE78XdlxLyOi/NrmSGRIov0karw2RzMNOu
5D+jLRZQd1Sv27AR+IP3I8U4aqnhLpwhK7MEy9oCILlgZ1QZe49kpcumcZKORmzB
TNh30FVKK1EvmV2xAKDoaEOgQB4iFQLhJCdP1I5aSgM5IVFdn7v5YgEYuJYx37Io
N1EblHI//x/e2AaIHpzK5h88NEawQsaNRpNSrcfbFmAg987ATQRTjHAWAQgAyzH6
AOODMBjgfWE9VeCgsrwH3exNAU32gLq2xvjpWnHIs98ndPUDpnoxWQugJ6MpMncr
0xSwFmHEgnSEjK/PAjppgmyc57BwKII3sV4on+gDVFJR6Y8ZRwgnBC5mVM6JjQ5x
Dk8WRXljExRfUX9pNhdE5eBOZJrDRoLUmmjDtKzWaDhIg/+1Hzz93X4fCQkNVbVF
LELU9bMaLPBG/x5q4iYZ2k2ex6d47YE1ZFdMm6YBYMOljGkZKwYde5ldM9mo45mm
we0icXKLkpEdIXKTZeKDO+Hdv1aqFuAcccTg9RXDQjmwhC3yEmrmcfl0+rPghO0I
v3OOImwTEe4co3c1mwARAQABwsBfBBgBAgAJBQJTjHAWAhsMAAoJELDendYovxMv
Q/gH/1ha96vm4P/L+bQpJwrZ/dneZcmEwTbe8YFsw2V/Buv6Z4Mysln3nQK5ZadD
534CF7TDVft7fC4tU4PONxF5D+/tvgkPfDAfF77zy2AH1vJzQ1fOU8lYFpZXTXIH
b+559UqvIB8AdgR3SAJGHHt4RKA0F7f5ipYBBrC6cyXJyyoprT10EMvU8VGiwXvT
yJz3fjoYsdFzpWPlJEBRMedCot60g5dmbdrZ5DWClAr0yau47zpWj3enf1tLWaqc
suylWsviuGjKGw7KHQd3bxALOknAp4dN3QwBYCKuZ7AddY9yjynVaD5X7nF9nO5B
jR/i1DG86lem3iBDXzXsZDn8R3/CwO0EGAEIACAWIQSFEmdy6PYElKXQl/ew3p3W
KL8TLwUCWt3w0AIbAgCBCRCw3p3WKL8TL3YgBBkWCAAdFiEEUy2wekH2OPMeOLge
gFxhu0/YY74FAlrd8NAACgkQgFxhu0/YY75NiwD/fQf/RXpyv9ZX4n8UJrKDq422
bcwkujisT6jix2mOOwYBAKiip9+mAD6W5NPXdhk1XraECcIspcf2ff5kCAlG0DIN
aTUH/RIwNWzXDG58yQoLdD/UPcFgi8GWtNUp0Fhc/GeBxGipXYnvuWxwS+Qs1Qay
7/Nbal/v4/eZZaWs8wl2VtrHTS96/IF6q2o0qMey0dq2AxnZbQIULiEndgR625EF
RFg+IbO4ldSkB3trsF2ypYLij4ZObm2casLIP7iB8NKmQ5PndL8Y07TtiQ+Sb/wn
g4GgV+BJoKdDWLPCAlCMilwbZ88Ijb+HF/aipc9hsqvW/hnXC2GajJSAY3Qs9Mib
4Hm91jzbAjmp7243pQ4bJMfYHemFFBRaoLC7ayqQjcsttN2ufINlqLFPZPR/i3IX
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------vwtdjJ2TzsEgHt1ivKzjZJmN--

--------------dmv0z0qelhOAJxC2cC0LuZyw--

--------------YyphMvfItp3TyHBNEvp0WSxz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmk/xmYFAwAAAAAACgkQsN6d1ii/Ey/P
nAf+Lyp90BcZbjyFdqh1h33G0Yhk4IoRkWvYHwyHlyXo/RJu1/DT3tR31UtdoAxXicV5RSwgcedk
iUyeBignFMYMWXdt4YU4kBI8wWwrvoeYkAeRgbppgUFF5uk1IXCtih7aAGdz7epM9Wh7vvINWV02
6xHmwWRAvpldD6h2wfEupMcVV+X7Mf0DM5+N6D4IKDM6wthepUbp+0kDl6Iy38tVD4+oZgKGT8ID
aJ8ucRl0IPUKDf+tKzRx/0c+eMwqWkOCiqMfGcSG0BypXEkRkl9XiqC4kedCYElYhAJ8m7rNyxCw
OIxbjQQTSqWCtfOeXpGcg4fhi4zbQsAWJMq8wOpgGQ==
=cQgu
-----END PGP SIGNATURE-----

--------------YyphMvfItp3TyHBNEvp0WSxz--

