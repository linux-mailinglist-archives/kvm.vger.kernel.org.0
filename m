Return-Path: <kvm+bounces-57979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F66DB830EE
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B1D516411B
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39E0E2D7D2A;
	Thu, 18 Sep 2025 05:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AtMbUHaC";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R4leFrKi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F150E246335
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 05:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758174998; cv=none; b=VDvBFzf67oYdUqh/8Rh0acf4HtJYiqucP3aWTA1fAAqRRvKQjPXxjdFUDoDrU+HIKH7LqUsAx14b+Z2iT7Bvo0/3Rp+0AiKlf3WqQdbVTsueApS7gu9d+WzR4MjaMI3MEFHMfee/lu96sYuzms9F+IubbFiBN6YUQ1jtUrK9eag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758174998; c=relaxed/simple;
	bh=lfjlZ5yEEW0FqZlSU5dEgD0szSxc6bYm56+XzUkjJTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tXVD9iCxknvr6wAGl7YuKuwYiSPrT6/tLSn1xAKx5MpgMDUGABOGlfuGJwmUF4mKSMLY/juJ8gZdAy+BbTdaEAlIlqbPdv627X79IohktrRjrRoJcnu1hB35Rg6sZBlDRGdSZ1K+t15uehsPsYejC1Dksn2smfyRZ5HEwKcMS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AtMbUHaC; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R4leFrKi; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2908333791;
	Thu, 18 Sep 2025 05:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758174993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lfjlZ5yEEW0FqZlSU5dEgD0szSxc6bYm56+XzUkjJTA=;
	b=AtMbUHaCjW8kIerM63RfMvkErkluHt/SoYLmUs6qb9k4NU1QSr5uWo9CkXYlH+YTU43Den
	2SWsUXvP/0Vt9uoqik9/L0vC3M6Z9G9AJAnbUrv7UO0QhwoTA03342SQ0Z9wQdLq4P6Gn+
	mimKXiWJmNXOH90iYfHk//qyq0p1d7E=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758174992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lfjlZ5yEEW0FqZlSU5dEgD0szSxc6bYm56+XzUkjJTA=;
	b=R4leFrKiL6F0zpBOylDqOymlaGvFjHox96zXAMsfFKHxD7x/Vo3F/XX22z8mE/rPgM16Uv
	3WtffFPPrzbns2Sv1emStnm5M6qP0x6+Gq+iS6MPYF54AFpaC+6zybzxbhjlNHWXv2w5we
	Q8PLRwdm5uiZnu+zJ7NwCq14UO3rf0k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3340013A51;
	Thu, 18 Sep 2025 05:56:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pxnVCg+fy2ivEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 18 Sep 2025 05:56:31 +0000
Message-ID: <078d5556-c5a9-40f5-906d-f96253a22739@suse.com>
Date: Thu, 18 Sep 2025 07:56:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
To: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, xen-devel@lists.xenproject.org
References: <20250917145220.31064-22-jgross@suse.com>
 <202509181008.MoLd2u4e-lkp@intel.com>
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
In-Reply-To: <202509181008.MoLd2u4e-lkp@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------d9VnNNakkD8gVqBNvxOXiPAE"
X-Spamd-Result: default: False [-5.20 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[01.org:url,imap1.dmz-prg2.suse.org:helo,suse.com:mid,intel.com:email,git-scm.com:url];
	HAS_ATTACHMENT(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -5.20

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------d9VnNNakkD8gVqBNvxOXiPAE
Content-Type: multipart/mixed; boundary="------------Csi8XDs0o0YVMq0XLmHh6km5";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-hyperv@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, xen-devel@lists.xenproject.org
Message-ID: <078d5556-c5a9-40f5-906d-f96253a22739@suse.com>
Subject: Re: [PATCH v2 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
References: <20250917145220.31064-22-jgross@suse.com>
 <202509181008.MoLd2u4e-lkp@intel.com>
In-Reply-To: <202509181008.MoLd2u4e-lkp@intel.com>

--------------Csi8XDs0o0YVMq0XLmHh6km5
Content-Type: multipart/mixed; boundary="------------zcB9cwd0ZBMDf0rsBpcDRZ9W"

--------------zcB9cwd0ZBMDf0rsBpcDRZ9W
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTguMDkuMjUgMDQ6NDUsIGtlcm5lbCB0ZXN0IHJvYm90IHdyb3RlOg0KPiBIaSBKdWVy
Z2VuLA0KPiANCj4ga2VybmVsIHRlc3Qgcm9ib3Qgbm90aWNlZCB0aGUgZm9sbG93aW5nIGJ1
aWxkIHdhcm5pbmdzOg0KPiANCj4gW2F1dG8gYnVpbGQgdGVzdCBXQVJOSU5HIG9uIHRpcC9z
Y2hlZC9jb3JlXQ0KPiBbYWxzbyBidWlsZCB0ZXN0IFdBUk5JTkcgb24ga3ZtL3F1ZXVlIGt2
bS9uZXh0IGxpbnVzL21hc3RlciB2Ni4xNy1yYzYgbmV4dC0yMDI1MDkxN10NCj4gW2Nhbm5v
dCBhcHBseSB0byB0aXAveDg2L2NvcmUga3ZtL2xpbnV4LW5leHRdDQo+IFtJZiB5b3VyIHBh
dGNoIGlzIGFwcGxpZWQgdG8gdGhlIHdyb25nIGdpdCB0cmVlLCBraW5kbHkgZHJvcCB1cyBh
IG5vdGUuDQo+IEFuZCB3aGVuIHN1Ym1pdHRpbmcgcGF0Y2gsIHdlIHN1Z2dlc3QgdG8gdXNl
ICctLWJhc2UnIGFzIGRvY3VtZW50ZWQgaW4NCj4gaHR0cHM6Ly9naXQtc2NtLmNvbS9kb2Nz
L2dpdC1mb3JtYXQtcGF0Y2gjX2Jhc2VfdHJlZV9pbmZvcm1hdGlvbl0NCj4gDQo+IHVybDog
ICAgaHR0cHM6Ly9naXRodWIuY29tL2ludGVsLWxhYi1sa3AvbGludXgvY29tbWl0cy9KdWVy
Z2VuLUdyb3NzL3g4Ni1wYXJhdmlydC1SZW1vdmUtbm90LW5lZWRlZC1pbmNsdWRlcy1vZi1w
YXJhdmlydC1oLzIwMjUwOTE3LTIzMDMyMQ0KPiBiYXNlOiAgIHRpcC9zY2hlZC9jb3JlDQo+
IHBhdGNoIGxpbms6ICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNTA5MTcxNDUy
MjAuMzEwNjQtMjItamdyb3NzJTQwc3VzZS5jb20NCj4gcGF0Y2ggc3ViamVjdDogW1BBVENI
IHYyIDIxLzIxXSB4ODYvcHZsb2NrczogTW92ZSBwYXJhdmlydCBzcGlubG9jayBmdW5jdGlv
bnMgaW50byBvd24gaGVhZGVyDQo+IGNvbmZpZzogeDg2XzY0LXJhbmRjb25maWctMDAzLTIw
MjUwOTE4IChodHRwczovL2Rvd25sb2FkLjAxLm9yZy8wZGF5LWNpL2FyY2hpdmUvMjAyNTA5
MTgvMjAyNTA5MTgxMDA4Lk1vTGQydTRlLWxrcEBpbnRlbC5jb20vY29uZmlnKQ0KPiBjb21w
aWxlcjogY2xhbmcgdmVyc2lvbiAyMC4xLjggKGh0dHBzOi8vZ2l0aHViLmNvbS9sbHZtL2xs
dm0tcHJvamVjdCA4N2YwMjI3Y2I2MDE0N2EyNmExZWViNGZiMDZlM2I1MDVlOWM3MjYxKQ0K
PiByZXByb2R1Y2UgKHRoaXMgaXMgYSBXPTEgYnVpbGQpOiAoaHR0cHM6Ly9kb3dubG9hZC4w
MS5vcmcvMGRheS1jaS9hcmNoaXZlLzIwMjUwOTE4LzIwMjUwOTE4MTAwOC5Nb0xkMnU0ZS1s
a3BAaW50ZWwuY29tL3JlcHJvZHVjZSkNCj4gDQo+IElmIHlvdSBmaXggdGhlIGlzc3VlIGlu
IGEgc2VwYXJhdGUgcGF0Y2gvY29tbWl0IChpLmUuIG5vdCBqdXN0IGEgbmV3IHZlcnNpb24g
b2YNCj4gdGhlIHNhbWUgcGF0Y2gvY29tbWl0KSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFn
cw0KPiB8IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4N
Cj4gfCBDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29lLWtidWlsZC1hbGwvMjAy
NTA5MTgxMDA4Lk1vTGQydTRlLWxrcEBpbnRlbC5jb20vDQo+IA0KPiBBbGwgd2FybmluZ3Mg
KG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KToNCj4gDQo+Pj4gYXJjaC94ODYva2VybmVsL3Bh
cmF2aXJ0LXNwaW5sb2Nrcy5jOjEzOjEzOiB3YXJuaW5nOiBubyBwcmV2aW91cyBwcm90b3R5
cGUgZm9yIGZ1bmN0aW9uICduYXRpdmVfcHZfbG9ja19pbml0JyBbLVdtaXNzaW5nLXByb3Rv
dHlwZXNdDQo+ICAgICAgICAxMyB8IHZvaWQgX19pbml0IG5hdGl2ZV9wdl9sb2NrX2luaXQo
dm9pZCkNCj4gICAgICAgICAgIHwgICAgICAgICAgICAgXg0KPiAgICAgYXJjaC94ODYva2Vy
bmVsL3BhcmF2aXJ0LXNwaW5sb2Nrcy5jOjEzOjE6IG5vdGU6IGRlY2xhcmUgJ3N0YXRpYycg
aWYgdGhlIGZ1bmN0aW9uIGlzIG5vdCBpbnRlbmRlZCB0byBiZSB1c2VkIG91dHNpZGUgb2Yg
dGhpcyB0cmFuc2xhdGlvbiB1bml0DQo+ICAgICAgICAxMyB8IHZvaWQgX19pbml0IG5hdGl2
ZV9wdl9sb2NrX2luaXQodm9pZCkNCj4gICAgICAgICAgIHwgXg0KPiAgICAgICAgICAgfCBz
dGF0aWMNCj4gICAgIDEgd2FybmluZyBnZW5lcmF0ZWQuDQoNCldpbGwgYmUgZml4ZWQgaW4g
VjMuDQoNCg0KSnVlcmdlbg0K
--------------zcB9cwd0ZBMDf0rsBpcDRZ9W
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------zcB9cwd0ZBMDf0rsBpcDRZ9W--

--------------Csi8XDs0o0YVMq0XLmHh6km5--

--------------d9VnNNakkD8gVqBNvxOXiPAE
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjLnw4FAwAAAAAACgkQsN6d1ii/Ey+x
CQf+IQ1ng7WiKO4LhrrXkz1rSgyDCT7guo7w2f3gI6ps+45ddPrXGGTIGK0NrAjgRJnZW57Jnolf
AGGN0NdoQQ3GLzherZQ5xl710Ed5WuWi6zWMEf0xgkcFRHsfWO3+Qo8O4kzARZMrxPCs4EgprQsr
pEjdEqx7QK7jGQuGYQn5i7ItiB+lc0xXMAO0r3kcqickyQBiOBvQNuerpHkkbG+tcAiqg5ykGqNe
y7cQ56AudOXRuZn46scyapBudBJLJGkMrZCiBggp0EFEmvVO9loIwF4Hnj4mnyDlv7H/A9oI5Tj6
XbaXkcJ6a3s9ctqNarLQl404rq00+9moguCVUiQd9g==
=EGob
-----END PGP SIGNATURE-----

--------------d9VnNNakkD8gVqBNvxOXiPAE--

