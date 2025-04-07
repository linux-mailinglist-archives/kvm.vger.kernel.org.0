Return-Path: <kvm+bounces-42836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62A60A7DBCB
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:04:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E6D416CE52
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 11:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6B2235347;
	Mon,  7 Apr 2025 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lcf1HckV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lcf1HckV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB3D237A3C
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 11:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744023833; cv=none; b=CQ39FRll1ptH+ZCvuOr+nLne19zd2D9/gFVGX3VQ6ssTLwruJJsjIXcTOAZdFm+pDfWfC0DWHnWOlOI+4PiHakRTKKPPjDt/8F4DnhdTi7us3KFNQYyrE1UMci20YSTYS4ouLQxGPHhKEtUNCqfirtEkPmkruQopq/QdGnQPPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744023833; c=relaxed/simple;
	bh=nL/ZeCV1shSmAfX309aBT9cdakbwHuwGDQsRkHmiogs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aruVcRR5ajrZn/NnV8GJldo49L21vD8kSufDVX92Ewmk5aJVCGxhD0Mhse0HtR9ayIVSoOvipLhiNf1vg6RXij8BDg5kHo2qz9JGkGbdP4B9m5q0vDs6DJ9aUyK/L4YANd/JPVyKLsmGCQyoWkAPiEJockkDlHvWV0Ngf8FrRJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lcf1HckV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lcf1HckV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F21021174;
	Mon,  7 Apr 2025 11:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744023829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nL/ZeCV1shSmAfX309aBT9cdakbwHuwGDQsRkHmiogs=;
	b=Lcf1HckVbLcT4mnv1AB2HAgtagSsOEAghzSL9iDqYIBum6BFEKDiWyAWJsw718EQH2V0xa
	ZLHk6kZ111MxtARdXizuLjKHMBNxJkssQQDfH+kX7kSSKXvKJPJIJys+5l65IIzhXZiuK9
	IlVXuTJa9rwIyJiSrxO/DPFoi+SS+no=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Lcf1HckV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744023829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nL/ZeCV1shSmAfX309aBT9cdakbwHuwGDQsRkHmiogs=;
	b=Lcf1HckVbLcT4mnv1AB2HAgtagSsOEAghzSL9iDqYIBum6BFEKDiWyAWJsw718EQH2V0xa
	ZLHk6kZ111MxtARdXizuLjKHMBNxJkssQQDfH+kX7kSSKXvKJPJIJys+5l65IIzhXZiuK9
	IlVXuTJa9rwIyJiSrxO/DPFoi+SS+no=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 23B8613691;
	Mon,  7 Apr 2025 11:03:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4rtsBhWx82cPYwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 07 Apr 2025 11:03:49 +0000
Message-ID: <2759dd5a-8612-4c7b-9282-c5a2aaa96e26@suse.com>
Date: Mon, 7 Apr 2025 13:03:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
 Dario Faggioli <dfaggioli@suse.com>, Fabiano Rosas <farosas@suse.de>,
 lkml <linux-kernel@vger.kernel.org>, Claudio Fontana <cfontana@suse.de>
References: <20240807172334.1006-1-cfontana@suse.de>
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
In-Reply-To: <20240807172334.1006-1-cfontana@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YMejfMLM0cY9eGg0vDB0LoQ5"
X-Rspamd-Queue-Id: 6F21021174
X-Spam-Score: -4.38
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.38 / 50.00];
	SIGNED_PGP(-2.00)[];
	BAYES_HAM(-1.97)[94.85%];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YMejfMLM0cY9eGg0vDB0LoQ5
Content-Type: multipart/mixed; boundary="------------4NDTpmfm0ICQyRA0xNqHCxe4";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
 Dario Faggioli <dfaggioli@suse.com>, Fabiano Rosas <farosas@suse.de>,
 lkml <linux-kernel@vger.kernel.org>, Claudio Fontana <cfontana@suse.de>
Message-ID: <2759dd5a-8612-4c7b-9282-c5a2aaa96e26@suse.com>
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
References: <20240807172334.1006-1-cfontana@suse.de>
In-Reply-To: <20240807172334.1006-1-cfontana@suse.de>

--------------4NDTpmfm0ICQyRA0xNqHCxe4
Content-Type: multipart/mixed; boundary="------------LSBkf0ayfCbxcL0Z33JLzym3"

--------------LSBkf0ayfCbxcL0Z33JLzym3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QmVsb3cgcGF0Y2ggd2FzIEFja2VkIGluIEF1Z3VzdCBsYXN0IHllYXIsIGFuZCBkZXNwaXRl
IGEgcGluZyBieSBtZQ0KaW4gT2N0b2JlciBpdCB3YXNuJ3QgY29tbWl0dGVkIHlldC4NCg0K
UGFibG8sIGRvIHlvdSBoYXZlIGFueSBjb25jZXJucyB3aXRoIHRoaXMgcGF0Y2g/IE9yIGFy
ZSB5b3UganVzdA0Kbm8gbG9uZ2VyIGludGVyZXN0ZWQgaW4gbWFpbnRhaW5pbmcga3ZtX3N0
YXQ/DQoNCkFzIHRoaXMgcGF0Y2ggaXMgZml4aW5nIGEgcmVhbCBidWcgd2hpY2ggd2UgYXQg
U1VTRSB3b3VsZCBsaWtlIHRvDQpzZWUgZml4ZWQsIHBsZWFzZSB0YWtlIHRoZSBwYXRjaCBv
ciB0ZWxsIHVzIHdoYXQgdG8gZG8gdG8gZ2V0IGl0DQp1cHN0cmVhbS4NCg0KSW4gY2FzZSB5
b3UganVzdCBkb24ndCBtaW5kLCBJIGNvdWxkIG9mZmVyIHRvIG1lcmdlIGl0IHZpYSB0aGUg
WGVuDQp0cmVlLCBldmVuIGlmIHRoaXMgcGF0Y2ggZG9lc24ndCByZWFsbHkgYmVsb25nIHRo
ZXJlLg0KDQoNCkp1ZXJnZW4NCg0KT24gMDcuMDguMjQgMTk6MjMsIENsYXVkaW8gRm9udGFu
YSB3cm90ZToNCj4gRm9yIHRoZSAtbCBhbmQgLUwgb3B0aW9ucyAobG9nZ2luZyBtb2RlKSwg
cmVwbGFjZSB0aGUgdXNlIG9mIHRoZQ0KPiBLZXlib2FyZEludGVycnVwdCBleGNlcHRpb24g
dG8gZ3JhY2VmdWxseSB0ZXJtaW5hdGUgaW4gZmF2b3INCj4gb2YgaGFuZGxpbmcgdGhlIFNJ
R0lOVCBhbmQgU0lHVEVSTSBzaWduYWxzLg0KPiANCj4gVGhpcyBhbGxvd3MgdGhlIHByb2dy
YW0gdG8gYmUgcnVuIGZyb20gc2NyaXB0cyBhbmQgc3RpbGwgYmUNCj4gc2lnbmFsZWQgdG8g
Z3JhY2VmdWxseSB0ZXJtaW5hdGUgd2l0aG91dCBhbiBpbnRlcmFjdGl2ZSB0ZXJtaW5hbC4N
Cj4gDQo+IEJlZm9yZSB0aGlzIGNoYW5nZSwgc29tZXRoaW5nIGxpa2UgdGhpcyBzY3JpcHQ6
DQo+IA0KPiBrdm1fc3RhdCAtcCA4NTg5NiAtZCAtdCAtcyAxIC1jIC1MIGt2bV9zdGF0Xzg1
ODk2LmNzdiAmDQo+IHNsZWVwIDEwDQo+IHBraWxsIC1URVJNIC1QICQkDQo+IA0KPiB3b3Vs
ZCB5aWVsZCBhbiBlbXB0eSBsb2c6DQo+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgICAgIDAg
QXVnICA3IDE2OjE3IGt2bV9zdGF0Xzg1ODk2LmNzdg0KPiANCj4gYWZ0ZXIgdGhpcyBjb21t
aXQ6DQo+IC1ydy1yLS1yLS0gMSByb290IHJvb3QgMTM0NjYgQXVnICA3IDE2OjU3IGt2bV9z
dGF0Xzg1ODk2LmNzdg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2xhdWRpbyBGb250YW5hIDxj
Zm9udGFuYUBzdXNlLmRlPg0KPiBDYzogRGFyaW8gRmFnZ2lvbGkgPGRmYWdnaW9saUBzdXNl
LmNvbT4NCj4gQ2M6IEZhYmlhbm8gUm9zYXMgPGZhcm9zYXNAc3VzZS5kZT4NCj4gLS0tDQo+
ICAgdG9vbHMva3ZtL2t2bV9zdGF0L2t2bV9zdGF0ICAgICB8IDY0ICsrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIHRvb2xzL2t2bS9rdm1fc3RhdC9rdm1fc3RhdC50
eHQgfCAxMiArKysrKysrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCsp
LCAzMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS90b29scy9rdm0va3ZtX3N0
YXQva3ZtX3N0YXQgYi90b29scy9rdm0va3ZtX3N0YXQva3ZtX3N0YXQNCj4gaW5kZXggMTVi
ZjAwZTc5ZTNmLi4yY2YyZGEzZWQwMDIgMTAwNzU1DQo+IC0tLSBhL3Rvb2xzL2t2bS9rdm1f
c3RhdC9rdm1fc3RhdA0KPiArKysgYi90b29scy9rdm0va3ZtX3N0YXQva3ZtX3N0YXQNCj4g
QEAgLTI5Nyw4ICsyOTcsNiBAQCBJT0NUTF9OVU1CRVJTID0gew0KPiAgICAgICAnUkVTRVQn
OiAgICAgICAweDAwMDAyNDAzLA0KPiAgIH0NCj4gICANCj4gLXNpZ25hbF9yZWNlaXZlZCA9
IEZhbHNlDQo+IC0NCj4gICBFTkNPRElORyA9IGxvY2FsZS5nZXRwcmVmZXJyZWRlbmNvZGlu
ZyhGYWxzZSkNCj4gICBUUkFDRV9GSUxURVIgPSByZS5jb21waWxlKHInXlteXChdKiQnKQ0K
PiAgIA0KPiBAQCAtMTU5OCw3ICsxNTk2LDE5IEBAIGNsYXNzIENTVkZvcm1hdChvYmplY3Qp
Og0KPiAgIA0KPiAgIGRlZiBsb2coc3RhdHMsIG9wdHMsIGZybXQsIGtleXMpOg0KPiAgICAg
ICAiIiJQcmludHMgc3RhdGlzdGljcyBhcyByZWl0ZXJhdGluZyBrZXkgYmxvY2ssIG11bHRp
cGxlIHZhbHVlIGJsb2Nrcy4iIiINCj4gLSAgICBnbG9iYWwgc2lnbmFsX3JlY2VpdmVkDQo+
ICsgICAgc2lnbmFsX3JlY2VpdmVkID0gZGVmYXVsdGRpY3QoYm9vbCkNCj4gKw0KPiArICAg
IGRlZiBoYW5kbGVfc2lnbmFsKHNpZywgZnJhbWUpOg0KPiArICAgICAgICBub25sb2NhbCBz
aWduYWxfcmVjZWl2ZWQNCj4gKyAgICAgICAgc2lnbmFsX3JlY2VpdmVkW3NpZ10gPSBUcnVl
DQo+ICsgICAgICAgIHJldHVybg0KPiArDQo+ICsNCj4gKyAgICBzaWduYWwuc2lnbmFsKHNp
Z25hbC5TSUdJTlQsIGhhbmRsZV9zaWduYWwpDQo+ICsgICAgc2lnbmFsLnNpZ25hbChzaWdu
YWwuU0lHVEVSTSwgaGFuZGxlX3NpZ25hbCkNCj4gKyAgICBpZiBvcHRzLmxvZ190b19maWxl
Og0KPiArICAgICAgICBzaWduYWwuc2lnbmFsKHNpZ25hbC5TSUdIVVAsIGhhbmRsZV9zaWdu
YWwpDQo+ICsNCj4gICAgICAgbGluZSA9IDANCj4gICAgICAgYmFubmVyX3JlcGVhdCA9IDIw
DQo+ICAgICAgIGYgPSBOb25lDQo+IEBAIC0xNjI0LDM5ICsxNjM0LDMxIEBAIGRlZiBsb2co
c3RhdHMsIG9wdHMsIGZybXQsIGtleXMpOg0KPiAgICAgICBkb19iYW5uZXIob3B0cykNCj4g
ICAgICAgYmFubmVyX3ByaW50ZWQgPSBUcnVlDQo+ICAgICAgIHdoaWxlIFRydWU6DQo+IC0g
ICAgICAgIHRyeToNCj4gLSAgICAgICAgICAgIHRpbWUuc2xlZXAob3B0cy5zZXRfZGVsYXkp
DQo+IC0gICAgICAgICAgICBpZiBzaWduYWxfcmVjZWl2ZWQ6DQo+IC0gICAgICAgICAgICAg
ICAgYmFubmVyX3ByaW50ZWQgPSBUcnVlDQo+IC0gICAgICAgICAgICAgICAgbGluZSA9IDAN
Cj4gLSAgICAgICAgICAgICAgICBmLmNsb3NlKCkNCj4gLSAgICAgICAgICAgICAgICBkb19i
YW5uZXIob3B0cykNCj4gLSAgICAgICAgICAgICAgICBzaWduYWxfcmVjZWl2ZWQgPSBGYWxz
ZQ0KPiAtICAgICAgICAgICAgaWYgKGxpbmUgJSBiYW5uZXJfcmVwZWF0ID09IDAgYW5kIG5v
dCBiYW5uZXJfcHJpbnRlZCBhbmQNCj4gLSAgICAgICAgICAgICAgICBub3QgKG9wdHMubG9n
X3RvX2ZpbGUgYW5kIGlzaW5zdGFuY2UoZnJtdCwgQ1NWRm9ybWF0KSkpOg0KPiAtICAgICAg
ICAgICAgICAgIGRvX2Jhbm5lcihvcHRzKQ0KPiAtICAgICAgICAgICAgICAgIGJhbm5lcl9w
cmludGVkID0gVHJ1ZQ0KPiAtICAgICAgICAgICAgdmFsdWVzID0gc3RhdHMuZ2V0KCkNCj4g
LSAgICAgICAgICAgIGlmIChub3Qgb3B0cy5za2lwX3plcm9fcmVjb3JkcyBvcg0KPiAtICAg
ICAgICAgICAgICAgIGFueSh2YWx1ZXNba10uZGVsdGEgIT0gMCBmb3IgayBpbiBrZXlzKSk6
DQo+IC0gICAgICAgICAgICAgICAgZG9fc3RhdGxpbmUob3B0cywgdmFsdWVzKQ0KPiAtICAg
ICAgICAgICAgICAgIGxpbmUgKz0gMQ0KPiAtICAgICAgICAgICAgICAgIGJhbm5lcl9wcmlu
dGVkID0gRmFsc2UNCj4gLSAgICAgICAgZXhjZXB0IEtleWJvYXJkSW50ZXJydXB0Og0KPiAr
ICAgICAgICB0aW1lLnNsZWVwKG9wdHMuc2V0X2RlbGF5KQ0KPiArICAgICAgICAjIERvIG5v
dCB1c2UgdGhlIEtleWJvYXJkSW50ZXJydXB0IGV4Y2VwdGlvbiwgYmVjYXVzZSB3ZSBtYXkg
YmUgcnVubmluZyB3aXRob3V0IGEgdGVybWluYWwNCj4gKyAgICAgICAgaWYgKHNpZ25hbF9y
ZWNlaXZlZFtzaWduYWwuU0lHSU5UXSBvciBzaWduYWxfcmVjZWl2ZWRbc2lnbmFsLlNJR1RF
Uk1dKToNCj4gICAgICAgICAgICAgICBicmVhaw0KPiArICAgICAgICBpZiBzaWduYWxfcmVj
ZWl2ZWRbc2lnbmFsLlNJR0hVUF06DQo+ICsgICAgICAgICAgICBiYW5uZXJfcHJpbnRlZCA9
IFRydWUNCj4gKyAgICAgICAgICAgIGxpbmUgPSAwDQo+ICsgICAgICAgICAgICBmLmNsb3Nl
KCkNCj4gKyAgICAgICAgICAgIGRvX2Jhbm5lcihvcHRzKQ0KPiArICAgICAgICAgICAgc2ln
bmFsX3JlY2VpdmVkW3NpZ25hbC5TSUdIVVBdID0gRmFsc2UNCj4gKyAgICAgICAgaWYgKGxp
bmUgJSBiYW5uZXJfcmVwZWF0ID09IDAgYW5kIG5vdCBiYW5uZXJfcHJpbnRlZCBhbmQNCj4g
KyAgICAgICAgICAgIG5vdCAob3B0cy5sb2dfdG9fZmlsZSBhbmQgaXNpbnN0YW5jZShmcm10
LCBDU1ZGb3JtYXQpKSk6DQo+ICsgICAgICAgICAgICBkb19iYW5uZXIob3B0cykNCj4gKyAg
ICAgICAgICAgIGJhbm5lcl9wcmludGVkID0gVHJ1ZQ0KPiArICAgICAgICB2YWx1ZXMgPSBz
dGF0cy5nZXQoKQ0KPiArICAgICAgICBpZiAobm90IG9wdHMuc2tpcF96ZXJvX3JlY29yZHMg
b3INCj4gKyAgICAgICAgICAgIGFueSh2YWx1ZXNba10uZGVsdGEgIT0gMCBmb3IgayBpbiBr
ZXlzKSk6DQo+ICsgICAgICAgICAgICBkb19zdGF0bGluZShvcHRzLCB2YWx1ZXMpDQo+ICsg
ICAgICAgICAgICBsaW5lICs9IDENCj4gKyAgICAgICAgICAgIGJhbm5lcl9wcmludGVkID0g
RmFsc2UNCj4gICANCj4gICAgICAgaWYgb3B0cy5sb2dfdG9fZmlsZToNCj4gICAgICAgICAg
IGYuY2xvc2UoKQ0KPiAgIA0KPiAgIA0KPiAtZGVmIGhhbmRsZV9zaWduYWwoc2lnLCBmcmFt
ZSk6DQo+IC0gICAgZ2xvYmFsIHNpZ25hbF9yZWNlaXZlZA0KPiAtDQo+IC0gICAgc2lnbmFs
X3JlY2VpdmVkID0gVHJ1ZQ0KPiAtDQo+IC0gICAgcmV0dXJuDQo+IC0NCj4gLQ0KPiAgIGRl
ZiBpc19kZWxheV92YWxpZChkZWxheSk6DQo+ICAgICAgICIiIlZlcmlmeSBkZWxheSBpcyBp
biB2YWxpZCB2YWx1ZSByYW5nZS4iIiINCj4gICAgICAgbXNnID0gTm9uZQ0KPiBAQCAtMTg2
OSw4ICsxODcxLDYgQEAgZGVmIG1haW4oKToNCj4gICAgICAgICAgIHN5cy5leGl0KDApDQo+
ICAgDQo+ICAgICAgIGlmIG9wdGlvbnMubG9nIG9yIG9wdGlvbnMubG9nX3RvX2ZpbGU6DQo+
IC0gICAgICAgIGlmIG9wdGlvbnMubG9nX3RvX2ZpbGU6DQo+IC0gICAgICAgICAgICBzaWdu
YWwuc2lnbmFsKHNpZ25hbC5TSUdIVVAsIGhhbmRsZV9zaWduYWwpDQo+ICAgICAgICAgICBr
ZXlzID0gc29ydGVkKHN0YXRzLmdldCgpLmtleXMoKSkNCj4gICAgICAgICAgIGlmIG9wdGlv
bnMuY3N2Og0KPiAgICAgICAgICAgICAgIGZybXQgPSBDU1ZGb3JtYXQoa2V5cykNCj4gZGlm
ZiAtLWdpdCBhL3Rvb2xzL2t2bS9rdm1fc3RhdC9rdm1fc3RhdC50eHQgYi90b29scy9rdm0v
a3ZtX3N0YXQva3ZtX3N0YXQudHh0DQo+IGluZGV4IDNhOWYyMDM3YmQyMy4uNGE5OWExMTFh
OTNjIDEwMDY0NA0KPiAtLS0gYS90b29scy9rdm0va3ZtX3N0YXQva3ZtX3N0YXQudHh0DQo+
ICsrKyBiL3Rvb2xzL2t2bS9rdm1fc3RhdC9rdm1fc3RhdC50eHQNCj4gQEAgLTExNSw2ICsx
MTUsMTggQEAgT1BUSU9OUw0KPiAgIC0tc2tpcC16ZXJvLXJlY29yZHM6Og0KPiAgICAgICAg
ICAgb21pdCByZWNvcmRzIHdpdGggYWxsIHplcm9zIGluIGxvZ2dpbmcgbW9kZQ0KPiAgIA0K
PiArDQo+ICtTSUdOQUxTDQo+ICstLS0tLS0tDQo+ICt3aGVuIGt2bV9zdGF0IGlzIHJ1bm5p
bmcgaW4gbG9nZ2luZyBtb2RlIChlaXRoZXIgd2l0aCAtbCBvciB3aXRoIC1MKSwNCj4gK2l0
IGhhbmRsZXMgdGhlIGZvbGxvd2luZyBzaWduYWxzOg0KPiArDQo+ICtTSUdIVVAgLSBjbG9z
ZXMgYW5kIHJlb3BlbnMgdGhlIGxvZyBmaWxlICgtTCBvbmx5KSwgdGhlbiBjb250aW51ZXMu
DQo+ICsNCj4gK1NJR0lOVCAtIGNsb3NlcyB0aGUgbG9nIGZpbGUgYW5kIHRlcm1pbmF0ZXMu
DQo+ICtTSUdURVJNIC0gY2xvc2VzIHRoZSBsb2cgZmlsZSBhbmQgdGVybWluYXRlcy4NCj4g
Kw0KPiArDQo+ICAgU0VFIEFMU08NCj4gICAtLS0tLS0tLQ0KPiAgICdwZXJmJygxKSwgJ3Ry
YWNlLWNtZCcoMSkNCg0K
--------------LSBkf0ayfCbxcL0Z33JLzym3
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------LSBkf0ayfCbxcL0Z33JLzym3--

--------------4NDTpmfm0ICQyRA0xNqHCxe4--

--------------YMejfMLM0cY9eGg0vDB0LoQ5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmfzsRQFAwAAAAAACgkQsN6d1ii/Ey+v
Iwf9GW9szXuqwr8m0uN2jv5DCVe74DLQgP+mbQbQAFUzTEonmP8HptcSSYDzQ0S4UG2DjujnrULE
eV5flxMiLZMP/3KwsKdYyCe5wIKeBtoVjOE3Ogky+hWSXMzESJ8eMQiCZwvw+1GihUPhcvLUukqd
AqQLiY5nKBZgCyXoA+7lfcRDDn52e21jp7N0wcelp65OHGkLt2cK4uHzeDHFTOFPr2M7aLmE7dzH
2VUQhyJdOOTXTmtqWCJWtAbqEpQS1uHooEC4v8mORcEwsMjGAz6EVcpwBEpvMiy2j4hbsQnD5xe0
xfa62j6vHir0z5pP9BbBAEI4hNxfOJ9+YqJb4UT2ug==
=fCna
-----END PGP SIGNATURE-----

--------------YMejfMLM0cY9eGg0vDB0LoQ5--

