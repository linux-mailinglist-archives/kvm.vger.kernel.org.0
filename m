Return-Path: <kvm+bounces-49254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C093AD6D7A
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A242B1BC391C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 10:19:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDF4230BC2;
	Thu, 12 Jun 2025 10:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oj14FmZw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oj14FmZw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014F223DDA
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749723556; cv=none; b=uQqrdNaTQm/8Y3WgQz2ZtCJ4xcYt/Di49jIx/IOw0yPOExIO6wXYKBEKvL6vkVQUJuemJyK0HiBGbDs/Sm4FKWbXCUHW5ZvEBk7BFNwrxqiARJCNn4WM/cJMGeZam+h2XGpuLGbzuyD1c7/90+pP72D6qBgLh4ii/u5DpUR+di8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749723556; c=relaxed/simple;
	bh=mdhllsYptJzWpWRaCohWre8At5dUtUcWHkcMPixG5dA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u8HFxaQfurCeqLNo94LgC0xSXHR+BctcnsOLhhWM+hP5SeqRBfFYCGLmHEZW+xhmmwMlAa7IjcrKLZLpuTWfy/LQVQ7fr4zjJloPfM/TOmvdg5iAU7WCXREFpaXdcyz5kdvl/Ju7L5cUCGSKu7pXeFd2J3n84TBW+XzVVh37oGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oj14FmZw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oj14FmZw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2FFF21744;
	Thu, 12 Jun 2025 10:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1749723551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mdhllsYptJzWpWRaCohWre8At5dUtUcWHkcMPixG5dA=;
	b=oj14FmZwawggQFz/mpwdPbpGxwCSq2yPj3hGSfoo0OU/wstTt5Fn2/rZHE96f+GGsfXZNz
	ExJsQpevYaVkROYm3SA5qZq8slxwMNs6Ubm+g7AedPOk6tq42b2faUsAZONoDMO7D7SwIf
	2igyxskJsSksCKMTFbKdg8mOB2yntgw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1749723551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mdhllsYptJzWpWRaCohWre8At5dUtUcWHkcMPixG5dA=;
	b=oj14FmZwawggQFz/mpwdPbpGxwCSq2yPj3hGSfoo0OU/wstTt5Fn2/rZHE96f+GGsfXZNz
	ExJsQpevYaVkROYm3SA5qZq8slxwMNs6Ubm+g7AedPOk6tq42b2faUsAZONoDMO7D7SwIf
	2igyxskJsSksCKMTFbKdg8mOB2yntgw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1D23132D8;
	Thu, 12 Jun 2025 10:19:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qsicNZ2pSmglUAAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 12 Jun 2025 10:19:09 +0000
Message-ID: <84b14425-03e4-42be-8bd5-9bc010ebecda@suse.com>
Date: Thu, 12 Jun 2025 12:19:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: Fix build warnings about export.h
To: Zhenghan Cheng <chengzhenghan@uniontech.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 mario.limonciello@amd.com, yazen.ghannam@amd.com, jpoimboe@kernel.org,
 tony.luck@intel.com, jarkko@kernel.org, bhelgaas@google.com,
 pbonzini@redhat.com, oleg@redhat.com, jbaron@akamai.com, ning.sun@intel.com,
 seanjc@google.com, luto@kernel.org, andy@kernel.org, jim.cromie@gmail.com,
 kirill.shutemov@linux.intel.com
Cc: hpa@zytor.com, pawan.kumar.gupta@linux.intel.com, vkuznets@redhat.com,
 rostedt@goodmis.org, ardb@kernel.org, thomas.lendacky@amd.com,
 nikunj@amd.com, ashish.kalra@amd.com, kees@kernel.org,
 alexandre.chartre@oracle.com, rppt@kernel.org, steve.wahl@hpe.com,
 jirislaby@kernel.org, apatel@ventanamicro.com, bvanassche@acm.org,
 ptsm@linux.microsoft.com, Jonathan.Cameron@huawei.com,
 beata.michalska@arm.com, xin@zytor.com, davydov-max@yandex-team.ru,
 ravi.bangoria@amd.com, joel.granados@kernel.org, ffmancera@riseup.net,
 kprateek.nayak@amd.com, akpm@linux-foundation.org, bhe@redhat.com,
 brgerst@gmail.com, coxu@redhat.com, dmaluka@chromium.org,
 linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, tboot-devel@lists.sourceforge.net,
 nouveau@lists.freedesktop.org, linux-coco@lists.linux.dev,
 xen-devel@lists.xenproject.org, Huacai Chen <chenhuacai@loongson.cn>,
 Zhenghan Cheng <your_email@example.com>
References: <20250612093228.7655-1-chengzhenghan@uniontech.com>
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
In-Reply-To: <20250612093228.7655-1-chengzhenghan@uniontech.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------r5mQdgOt4Whh0CrWNE4SR5Wo"
X-Spamd-Result: default: False [-3.70 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-0.976];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[uniontech.com,linutronix.de,redhat.com,alien8.de,linux.intel.com,kernel.org,amd.com,intel.com,google.com,akamai.com,gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[zytor.com,linux.intel.com,redhat.com,goodmis.org,kernel.org,amd.com,oracle.com,hpe.com,ventanamicro.com,acm.org,linux.microsoft.com,huawei.com,arm.com,yandex-team.ru,riseup.net,linux-foundation.org,gmail.com,chromium.org,vger.kernel.org,lists.linux.dev,lists.sourceforge.net,lists.freedesktop.org,lists.xenproject.org,loongson.cn,example.com];
	HAS_ATTACHMENT(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_GT_50(0.00)[61];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.70

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------r5mQdgOt4Whh0CrWNE4SR5Wo
Content-Type: multipart/mixed; boundary="------------K0XYKHlxFzsICF9SMBfAUlSE";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Zhenghan Cheng <chengzhenghan@uniontech.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 mario.limonciello@amd.com, yazen.ghannam@amd.com, jpoimboe@kernel.org,
 tony.luck@intel.com, jarkko@kernel.org, bhelgaas@google.com,
 pbonzini@redhat.com, oleg@redhat.com, jbaron@akamai.com, ning.sun@intel.com,
 seanjc@google.com, luto@kernel.org, andy@kernel.org, jim.cromie@gmail.com,
 kirill.shutemov@linux.intel.com
Cc: hpa@zytor.com, pawan.kumar.gupta@linux.intel.com, vkuznets@redhat.com,
 rostedt@goodmis.org, ardb@kernel.org, thomas.lendacky@amd.com,
 nikunj@amd.com, ashish.kalra@amd.com, kees@kernel.org,
 alexandre.chartre@oracle.com, rppt@kernel.org, steve.wahl@hpe.com,
 jirislaby@kernel.org, apatel@ventanamicro.com, bvanassche@acm.org,
 ptsm@linux.microsoft.com, Jonathan.Cameron@huawei.com,
 beata.michalska@arm.com, xin@zytor.com, davydov-max@yandex-team.ru,
 ravi.bangoria@amd.com, joel.granados@kernel.org, ffmancera@riseup.net,
 kprateek.nayak@amd.com, akpm@linux-foundation.org, bhe@redhat.com,
 brgerst@gmail.com, coxu@redhat.com, dmaluka@chromium.org,
 linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
 linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, tboot-devel@lists.sourceforge.net,
 nouveau@lists.freedesktop.org, linux-coco@lists.linux.dev,
 xen-devel@lists.xenproject.org, Huacai Chen <chenhuacai@loongson.cn>,
 Zhenghan Cheng <your_email@example.com>
Message-ID: <84b14425-03e4-42be-8bd5-9bc010ebecda@suse.com>
Subject: Re: [PATCH] x86: Fix build warnings about export.h
References: <20250612093228.7655-1-chengzhenghan@uniontech.com>
In-Reply-To: <20250612093228.7655-1-chengzhenghan@uniontech.com>

--------------K0XYKHlxFzsICF9SMBfAUlSE
Content-Type: multipart/mixed; boundary="------------nwabp6M47v7PnA12GBXmtNk0"

--------------nwabp6M47v7PnA12GBXmtNk0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTIuMDYuMjUgMTE6MzIsIFpoZW5naGFuIENoZW5nIHdyb3RlOg0KPiBBZnRlciBjb21t
aXQgYTkzNGE1N2E0MmY2NGE0ICgic2NyaXB0cy9taXNjLWNoZWNrOg0KPiBjaGVjayBtaXNz
aW5nICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4gd2hlbiBXPTEiKQ0KPiBhbmQgY29tbWl0
IDdkOTU2ODBkNjRhYzhlODM2YyAoInNjcmlwdHMvbWlzYy1jaGVjazoNCj4gY2hlY2sgdW5u
ZWNlc3NhcnkgI2luY2x1ZGUgPGxpbnV4L2V4cG9ydC5oPiB3aGVuIFc9MSIpLA0KPiB3ZSBn
ZXQgc29tZSBidWlsZCB3YXJuaW5ncyB3aXRoIFc9MSxzdWNoIGFzOg0KPiANCj4gYXJjaC94
ODYvY29jby9zZXYvY29yZS5jOiB3YXJuaW5nOiBFWFBPUlRfU1lNQk9MKCkgaXMgdXNlZCwg
YnV0ICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4gaXMgbWlzc2luZw0KPiBhcmNoL3g4Ni9j
cnlwdG8vYXJpYV9hZXNuaV9hdngyX2dsdWUuYzogd2FybmluZzogRVhQT1JUX1NZTUJPTCgp
IGlzIHVzZWQsIGJ1dCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+IGlzIG1pc3NpbmcNCj4g
YXJjaC94ODYva2VybmVsL3Vud2luZF9vcmMuYzogd2FybmluZzogRVhQT1JUX1NZTUJPTCgp
IGlzIHVzZWQsIGJ1dCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+IGlzIG1pc3NpbmcNCj4g
YXJjaC94ODYva3ZtL2h5cGVydi5jOiB3YXJuaW5nOiBFWFBPUlRfU1lNQk9MKCkgaXMgdXNl
ZCwgYnV0ICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4gaXMgbWlzc2luZw0KPiBhcmNoL3g4
Ni9ldmVudHMvaW50ZWwvY29yZS5jOiB3YXJuaW5nOiBFWFBPUlRfU1lNQk9MKCkgaXMgbm90
IHVzZWQsIGJ1dCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+IGlzIHByZXNlbnQNCj4gYXJj
aC94ODYvZXZlbnRzL3poYW94aW4vY29yZS5jOiB3YXJuaW5nOiBFWFBPUlRfU1lNQk9MKCkg
aXMgbm90IHVzZWQsIGJ1dCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+IGlzIHByZXNlbnQN
Cj4gYXJjaC94ODYva2VybmVsL2NyYXNoLmM6IHdhcm5pbmc6IEVYUE9SVF9TWU1CT0woKSBp
cyBub3QgdXNlZCwgYnV0ICNpbmNsdWRlIDxsaW51eC9leHBvcnQuaD4gaXMgcHJlc2VudA0K
PiBhcmNoL3g4Ni9rZXJuZWwvZGV2aWNldHJlZS5jOiB3YXJuaW5nOiBFWFBPUlRfU1lNQk9M
KCkgaXMgbm90IHVzZWQsIGJ1dCAjaW5jbHVkZSA8bGludXgvZXhwb3J0Lmg+IGlzIHByZXNl
bnQNCj4gDQo+IHNvIGZpeCB0aGVzZSBidWlsZCB3YXJuaW5ncyBmb3IgeDg2Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogIlpoZW5naGFuIENoZW5nIiA8Y2hlbmd6aGVuZ2hhbkB1bmlvbnRl
Y2guY29tPg0KPiBTdWdnZXN0ZWQtYnk6ICJIdWFjYWkgQ2hlbiIgPGNoZW5odWFjYWlAbG9v
bmdzb24uY24+DQoNCkZvciBYZW4gYW5kIHBhcmF2aXJ0Og0KDQpBY2tlZC1ieTogSnVlcmdl
biBHcm9zcyA8amdyb3NzQHN1c2UuY29tPg0KDQpZb3VyIHBhdGNoIGlzIGxvb2tpbmcgYSBs
aXR0bGUgYml0IHN0cmFuZ2UsIGFzIHRoZSBsaXN0IG9mIG1vZGlmaWVkIGZpbGVzDQppcyBs
b2NhdGVkIGJldHdlZW4gdGhlIHBhdGNoIGh1bmtzLCBmb2xsb3dlZCBieSBhbm90aGVyICJT
aWduZWQtb2ZmLWJ5OiIuDQoNCg0KSnVlcmdlbg0K
--------------nwabp6M47v7PnA12GBXmtNk0
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------nwabp6M47v7PnA12GBXmtNk0--

--------------K0XYKHlxFzsICF9SMBfAUlSE--

--------------r5mQdgOt4Whh0CrWNE4SR5Wo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmhKqZ0FAwAAAAAACgkQsN6d1ii/Ey9X
VQf/R7PwyvgEHQL+aCN+trwA+f6BOxwLSPkJMa068wO/uqFIQUIrHnSm8vuItp8K4TbRoujnCAmD
qc6aLD0w2pHhHkmvJEUFNDGKVeqlukRm3AyTCVbqN1RMw7Nd+hcM8yJv1P6hxJznNVTeuamYww6n
jrWmU9VBqFABUMVuH42in3ngALypAG9sx3Sm05R0vn6DAV+GI3mrnpKCTF1ONoMcXQBPJEohtgLC
f0LvToJeeeHnNhc6c20AIKOrxbdMXjosMfS2hDhX3tTDPm9LELql34Z7n1nGuloLqgbq2/590hw6
4PZuTMy6Qxf5Pw92YW24Jc6NEWR5myQo2FWARFNaMw==
=FXNZ
-----END PGP SIGNATURE-----

--------------r5mQdgOt4Whh0CrWNE4SR5Wo--

