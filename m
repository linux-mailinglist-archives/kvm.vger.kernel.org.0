Return-Path: <kvm+bounces-29289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEC49A6A25
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 15:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55DF41C22B34
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 13:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC6B01F707B;
	Mon, 21 Oct 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kHEw1CR9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kHEw1CR9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6401E1C3B
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 13:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729517180; cv=none; b=MFma+h9mlXPYjkBfkEg+OFNEnsaZYLpWPD5hOIZKaSTpAWr5Bubkflfnr19fbeckX+oPdsc2ff54NMcSotMdc+fqQsTzTuQhOtcIoGuRPXk/jchqzOWbpgcTRmfhjc+J0uSasbZWcRyEe6LSnryKZFhw+h361thYlqS2pRwh4Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729517180; c=relaxed/simple;
	bh=bmrTrU+oNV2VwqIexnTsbMIh/NkVHyw1Jk2+N8eai8A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5VXH2N6ITkpx+RAmzHvAYt0MVgwrDIXVSnVi3odnfbWw8UDQJkqkNZDy6Rq+/BMT0bgJ/T3cwlDwp9Crh4zA5Xa3HIn9F6LRUh+4KKrptAQBTRxM1xjyS+ibatW8ex1y2asVZTDDpz7ydxFIgzUNg56/+0HCyiFnm0lNL5dmlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kHEw1CR9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kHEw1CR9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 677EF21C5E;
	Mon, 21 Oct 2024 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1729517176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bmrTrU+oNV2VwqIexnTsbMIh/NkVHyw1Jk2+N8eai8A=;
	b=kHEw1CR9ysNf0IyKKqDzK7ujCS/9Q8rfkVTk3Itq2d7kugDleVqchPazWu9kkWR6lASqwq
	HP51ImSwN2fIdzLba1w/qpu15h4LoMRUuwJzC6RzBfhClZOS+B3O9Kwht7+5Y+0dcXnFkp
	Q1PJUA7W/oql9dzApDXub2ch2Or4uds=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=kHEw1CR9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1729517176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bmrTrU+oNV2VwqIexnTsbMIh/NkVHyw1Jk2+N8eai8A=;
	b=kHEw1CR9ysNf0IyKKqDzK7ujCS/9Q8rfkVTk3Itq2d7kugDleVqchPazWu9kkWR6lASqwq
	HP51ImSwN2fIdzLba1w/qpu15h4LoMRUuwJzC6RzBfhClZOS+B3O9Kwht7+5Y+0dcXnFkp
	Q1PJUA7W/oql9dzApDXub2ch2Or4uds=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1AC5F136DC;
	Mon, 21 Oct 2024 13:26:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3HUTBXhWFmcyQQAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 21 Oct 2024 13:26:16 +0000
Message-ID: <e6461e14-ca65-4322-a818-88b66b58c5c1@suse.com>
Date: Mon, 21 Oct 2024 15:26:15 +0200
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
 Claudio Fontana <cfontana@suse.de>
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
 boundary="------------WAJpAm6VtTfBMpjT7mtFWEcV"
X-Rspamd-Queue-Id: 677EF21C5E
X-Spam-Score: -5.40
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.40 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SIGNED_PGP(-2.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.19)[-0.971];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	HAS_ATTACHMENT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email,suse.de:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------WAJpAm6VtTfBMpjT7mtFWEcV
Content-Type: multipart/mixed; boundary="------------abCZza9bJa7ktEtEkDR4G9Aq";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
 Dario Faggioli <dfaggioli@suse.com>, Fabiano Rosas <farosas@suse.de>,
 Claudio Fontana <cfontana@suse.de>
Message-ID: <e6461e14-ca65-4322-a818-88b66b58c5c1@suse.com>
Subject: Re: [PATCH] tools/kvm_stat: fix termination behavior when not on a
 terminal
References: <20240807172334.1006-1-cfontana@suse.de>
In-Reply-To: <20240807172334.1006-1-cfontana@suse.de>

--------------abCZza9bJa7ktEtEkDR4G9Aq
Content-Type: multipart/mixed; boundary="------------dEuYg109tgzS5FGIQhht8Vu3"

--------------dEuYg109tgzS5FGIQhht8Vu3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW55IHJlYXNvbiBub3QgdG8gY29tbWl0IHRoaXMgcGF0Y2g/IEl0IGhhcyBnb3QgYSBSZXZp
ZXdlZC1ieTogdGFnIGZyb20NClN0ZWZhbiBtb3JlIHRoYW4gMiBtb250aHMgYWdvLi4uDQoN
Ck9uIDA3LjA4LjI0IDE5OjIzLCBDbGF1ZGlvIEZvbnRhbmEgd3JvdGU6DQo+IEZvciB0aGUg
LWwgYW5kIC1MIG9wdGlvbnMgKGxvZ2dpbmcgbW9kZSksIHJlcGxhY2UgdGhlIHVzZSBvZiB0
aGUNCj4gS2V5Ym9hcmRJbnRlcnJ1cHQgZXhjZXB0aW9uIHRvIGdyYWNlZnVsbHkgdGVybWlu
YXRlIGluIGZhdm9yDQo+IG9mIGhhbmRsaW5nIHRoZSBTSUdJTlQgYW5kIFNJR1RFUk0gc2ln
bmFscy4NCj4gDQo+IFRoaXMgYWxsb3dzIHRoZSBwcm9ncmFtIHRvIGJlIHJ1biBmcm9tIHNj
cmlwdHMgYW5kIHN0aWxsIGJlDQo+IHNpZ25hbGVkIHRvIGdyYWNlZnVsbHkgdGVybWluYXRl
IHdpdGhvdXQgYW4gaW50ZXJhY3RpdmUgdGVybWluYWwuDQo+IA0KPiBCZWZvcmUgdGhpcyBj
aGFuZ2UsIHNvbWV0aGluZyBsaWtlIHRoaXMgc2NyaXB0Og0KPiANCj4ga3ZtX3N0YXQgLXAg
ODU4OTYgLWQgLXQgLXMgMSAtYyAtTCBrdm1fc3RhdF84NTg5Ni5jc3YgJg0KPiBzbGVlcCAx
MA0KPiBwa2lsbCAtVEVSTSAtUCAkJA0KPiANCj4gd291bGQgeWllbGQgYW4gZW1wdHkgbG9n
Og0KPiAtcnctci0tci0tIDEgcm9vdCByb290ICAgICAwIEF1ZyAgNyAxNjoxNyBrdm1fc3Rh
dF84NTg5Ni5jc3YNCj4gDQo+IGFmdGVyIHRoaXMgY29tbWl0Og0KPiAtcnctci0tci0tIDEg
cm9vdCByb290IDEzNDY2IEF1ZyAgNyAxNjo1NyBrdm1fc3RhdF84NTg5Ni5jc3YNCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IENsYXVkaW8gRm9udGFuYSA8Y2ZvbnRhbmFAc3VzZS5kZT4NCj4g
Q2M6IERhcmlvIEZhZ2dpb2xpIDxkZmFnZ2lvbGlAc3VzZS5jb20+DQo+IENjOiBGYWJpYW5v
IFJvc2FzIDxmYXJvc2FzQHN1c2UuZGU+DQo+IC0tLQ0KPiAgIHRvb2xzL2t2bS9rdm1fc3Rh
dC9rdm1fc3RhdCAgICAgfCA2NCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0N
Cj4gICB0b29scy9rdm0va3ZtX3N0YXQva3ZtX3N0YXQudHh0IHwgMTIgKysrKysrKw0KPiAg
IDIgZmlsZXMgY2hhbmdlZCwgNDQgaW5zZXJ0aW9ucygrKSwgMzIgZGVsZXRpb25zKC0pDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvdG9vbHMva3ZtL2t2bV9zdGF0L2t2bV9zdGF0IGIvdG9vbHMv
a3ZtL2t2bV9zdGF0L2t2bV9zdGF0DQo+IGluZGV4IDE1YmYwMGU3OWUzZi4uMmNmMmRhM2Vk
MDAyIDEwMDc1NQ0KPiAtLS0gYS90b29scy9rdm0va3ZtX3N0YXQva3ZtX3N0YXQNCj4gKysr
IGIvdG9vbHMva3ZtL2t2bV9zdGF0L2t2bV9zdGF0DQo+IEBAIC0yOTcsOCArMjk3LDYgQEAg
SU9DVExfTlVNQkVSUyA9IHsNCj4gICAgICAgJ1JFU0VUJzogICAgICAgMHgwMDAwMjQwMywN
Cj4gICB9DQo+ICAgDQo+IC1zaWduYWxfcmVjZWl2ZWQgPSBGYWxzZQ0KPiAtDQo+ICAgRU5D
T0RJTkcgPSBsb2NhbGUuZ2V0cHJlZmVycmVkZW5jb2RpbmcoRmFsc2UpDQo+ICAgVFJBQ0Vf
RklMVEVSID0gcmUuY29tcGlsZShyJ15bXlwoXSokJykNCj4gICANCj4gQEAgLTE1OTgsNyAr
MTU5NiwxOSBAQCBjbGFzcyBDU1ZGb3JtYXQob2JqZWN0KToNCj4gICANCj4gICBkZWYgbG9n
KHN0YXRzLCBvcHRzLCBmcm10LCBrZXlzKToNCj4gICAgICAgIiIiUHJpbnRzIHN0YXRpc3Rp
Y3MgYXMgcmVpdGVyYXRpbmcga2V5IGJsb2NrLCBtdWx0aXBsZSB2YWx1ZSBibG9ja3MuIiIi
DQo+IC0gICAgZ2xvYmFsIHNpZ25hbF9yZWNlaXZlZA0KPiArICAgIHNpZ25hbF9yZWNlaXZl
ZCA9IGRlZmF1bHRkaWN0KGJvb2wpDQo+ICsNCj4gKyAgICBkZWYgaGFuZGxlX3NpZ25hbChz
aWcsIGZyYW1lKToNCj4gKyAgICAgICAgbm9ubG9jYWwgc2lnbmFsX3JlY2VpdmVkDQo+ICsg
ICAgICAgIHNpZ25hbF9yZWNlaXZlZFtzaWddID0gVHJ1ZQ0KPiArICAgICAgICByZXR1cm4N
Cj4gKw0KPiArDQo+ICsgICAgc2lnbmFsLnNpZ25hbChzaWduYWwuU0lHSU5ULCBoYW5kbGVf
c2lnbmFsKQ0KPiArICAgIHNpZ25hbC5zaWduYWwoc2lnbmFsLlNJR1RFUk0sIGhhbmRsZV9z
aWduYWwpDQo+ICsgICAgaWYgb3B0cy5sb2dfdG9fZmlsZToNCj4gKyAgICAgICAgc2lnbmFs
LnNpZ25hbChzaWduYWwuU0lHSFVQLCBoYW5kbGVfc2lnbmFsKQ0KPiArDQo+ICAgICAgIGxp
bmUgPSAwDQo+ICAgICAgIGJhbm5lcl9yZXBlYXQgPSAyMA0KPiAgICAgICBmID0gTm9uZQ0K
PiBAQCAtMTYyNCwzOSArMTYzNCwzMSBAQCBkZWYgbG9nKHN0YXRzLCBvcHRzLCBmcm10LCBr
ZXlzKToNCj4gICAgICAgZG9fYmFubmVyKG9wdHMpDQo+ICAgICAgIGJhbm5lcl9wcmludGVk
ID0gVHJ1ZQ0KPiAgICAgICB3aGlsZSBUcnVlOg0KPiAtICAgICAgICB0cnk6DQo+IC0gICAg
ICAgICAgICB0aW1lLnNsZWVwKG9wdHMuc2V0X2RlbGF5KQ0KPiAtICAgICAgICAgICAgaWYg
c2lnbmFsX3JlY2VpdmVkOg0KPiAtICAgICAgICAgICAgICAgIGJhbm5lcl9wcmludGVkID0g
VHJ1ZQ0KPiAtICAgICAgICAgICAgICAgIGxpbmUgPSAwDQo+IC0gICAgICAgICAgICAgICAg
Zi5jbG9zZSgpDQo+IC0gICAgICAgICAgICAgICAgZG9fYmFubmVyKG9wdHMpDQo+IC0gICAg
ICAgICAgICAgICAgc2lnbmFsX3JlY2VpdmVkID0gRmFsc2UNCj4gLSAgICAgICAgICAgIGlm
IChsaW5lICUgYmFubmVyX3JlcGVhdCA9PSAwIGFuZCBub3QgYmFubmVyX3ByaW50ZWQgYW5k
DQo+IC0gICAgICAgICAgICAgICAgbm90IChvcHRzLmxvZ190b19maWxlIGFuZCBpc2luc3Rh
bmNlKGZybXQsIENTVkZvcm1hdCkpKToNCj4gLSAgICAgICAgICAgICAgICBkb19iYW5uZXIo
b3B0cykNCj4gLSAgICAgICAgICAgICAgICBiYW5uZXJfcHJpbnRlZCA9IFRydWUNCj4gLSAg
ICAgICAgICAgIHZhbHVlcyA9IHN0YXRzLmdldCgpDQo+IC0gICAgICAgICAgICBpZiAobm90
IG9wdHMuc2tpcF96ZXJvX3JlY29yZHMgb3INCj4gLSAgICAgICAgICAgICAgICBhbnkodmFs
dWVzW2tdLmRlbHRhICE9IDAgZm9yIGsgaW4ga2V5cykpOg0KPiAtICAgICAgICAgICAgICAg
IGRvX3N0YXRsaW5lKG9wdHMsIHZhbHVlcykNCj4gLSAgICAgICAgICAgICAgICBsaW5lICs9
IDENCj4gLSAgICAgICAgICAgICAgICBiYW5uZXJfcHJpbnRlZCA9IEZhbHNlDQo+IC0gICAg
ICAgIGV4Y2VwdCBLZXlib2FyZEludGVycnVwdDoNCj4gKyAgICAgICAgdGltZS5zbGVlcChv
cHRzLnNldF9kZWxheSkNCj4gKyAgICAgICAgIyBEbyBub3QgdXNlIHRoZSBLZXlib2FyZElu
dGVycnVwdCBleGNlcHRpb24sIGJlY2F1c2Ugd2UgbWF5IGJlIHJ1bm5pbmcgd2l0aG91dCBh
IHRlcm1pbmFsDQo+ICsgICAgICAgIGlmIChzaWduYWxfcmVjZWl2ZWRbc2lnbmFsLlNJR0lO
VF0gb3Igc2lnbmFsX3JlY2VpdmVkW3NpZ25hbC5TSUdURVJNXSk6DQo+ICAgICAgICAgICAg
ICAgYnJlYWsNCj4gKyAgICAgICAgaWYgc2lnbmFsX3JlY2VpdmVkW3NpZ25hbC5TSUdIVVBd
Og0KPiArICAgICAgICAgICAgYmFubmVyX3ByaW50ZWQgPSBUcnVlDQo+ICsgICAgICAgICAg
ICBsaW5lID0gMA0KPiArICAgICAgICAgICAgZi5jbG9zZSgpDQo+ICsgICAgICAgICAgICBk
b19iYW5uZXIob3B0cykNCj4gKyAgICAgICAgICAgIHNpZ25hbF9yZWNlaXZlZFtzaWduYWwu
U0lHSFVQXSA9IEZhbHNlDQo+ICsgICAgICAgIGlmIChsaW5lICUgYmFubmVyX3JlcGVhdCA9
PSAwIGFuZCBub3QgYmFubmVyX3ByaW50ZWQgYW5kDQo+ICsgICAgICAgICAgICBub3QgKG9w
dHMubG9nX3RvX2ZpbGUgYW5kIGlzaW5zdGFuY2UoZnJtdCwgQ1NWRm9ybWF0KSkpOg0KPiAr
ICAgICAgICAgICAgZG9fYmFubmVyKG9wdHMpDQo+ICsgICAgICAgICAgICBiYW5uZXJfcHJp
bnRlZCA9IFRydWUNCj4gKyAgICAgICAgdmFsdWVzID0gc3RhdHMuZ2V0KCkNCj4gKyAgICAg
ICAgaWYgKG5vdCBvcHRzLnNraXBfemVyb19yZWNvcmRzIG9yDQo+ICsgICAgICAgICAgICBh
bnkodmFsdWVzW2tdLmRlbHRhICE9IDAgZm9yIGsgaW4ga2V5cykpOg0KPiArICAgICAgICAg
ICAgZG9fc3RhdGxpbmUob3B0cywgdmFsdWVzKQ0KPiArICAgICAgICAgICAgbGluZSArPSAx
DQo+ICsgICAgICAgICAgICBiYW5uZXJfcHJpbnRlZCA9IEZhbHNlDQo+ICAgDQo+ICAgICAg
IGlmIG9wdHMubG9nX3RvX2ZpbGU6DQo+ICAgICAgICAgICBmLmNsb3NlKCkNCj4gICANCj4g
ICANCj4gLWRlZiBoYW5kbGVfc2lnbmFsKHNpZywgZnJhbWUpOg0KPiAtICAgIGdsb2JhbCBz
aWduYWxfcmVjZWl2ZWQNCj4gLQ0KPiAtICAgIHNpZ25hbF9yZWNlaXZlZCA9IFRydWUNCj4g
LQ0KPiAtICAgIHJldHVybg0KPiAtDQo+IC0NCj4gICBkZWYgaXNfZGVsYXlfdmFsaWQoZGVs
YXkpOg0KPiAgICAgICAiIiJWZXJpZnkgZGVsYXkgaXMgaW4gdmFsaWQgdmFsdWUgcmFuZ2Uu
IiIiDQo+ICAgICAgIG1zZyA9IE5vbmUNCj4gQEAgLTE4NjksOCArMTg3MSw2IEBAIGRlZiBt
YWluKCk6DQo+ICAgICAgICAgICBzeXMuZXhpdCgwKQ0KPiAgIA0KPiAgICAgICBpZiBvcHRp
b25zLmxvZyBvciBvcHRpb25zLmxvZ190b19maWxlOg0KPiAtICAgICAgICBpZiBvcHRpb25z
LmxvZ190b19maWxlOg0KPiAtICAgICAgICAgICAgc2lnbmFsLnNpZ25hbChzaWduYWwuU0lH
SFVQLCBoYW5kbGVfc2lnbmFsKQ0KPiAgICAgICAgICAga2V5cyA9IHNvcnRlZChzdGF0cy5n
ZXQoKS5rZXlzKCkpDQo+ICAgICAgICAgICBpZiBvcHRpb25zLmNzdjoNCj4gICAgICAgICAg
ICAgICBmcm10ID0gQ1NWRm9ybWF0KGtleXMpDQo+IGRpZmYgLS1naXQgYS90b29scy9rdm0v
a3ZtX3N0YXQva3ZtX3N0YXQudHh0IGIvdG9vbHMva3ZtL2t2bV9zdGF0L2t2bV9zdGF0LnR4
dA0KPiBpbmRleCAzYTlmMjAzN2JkMjMuLjRhOTlhMTExYTkzYyAxMDA2NDQNCj4gLS0tIGEv
dG9vbHMva3ZtL2t2bV9zdGF0L2t2bV9zdGF0LnR4dA0KPiArKysgYi90b29scy9rdm0va3Zt
X3N0YXQva3ZtX3N0YXQudHh0DQo+IEBAIC0xMTUsNiArMTE1LDE4IEBAIE9QVElPTlMNCj4g
ICAtLXNraXAtemVyby1yZWNvcmRzOjoNCj4gICAgICAgICAgIG9taXQgcmVjb3JkcyB3aXRo
IGFsbCB6ZXJvcyBpbiBsb2dnaW5nIG1vZGUNCj4gICANCj4gKw0KPiArU0lHTkFMUw0KPiAr
LS0tLS0tLQ0KPiArd2hlbiBrdm1fc3RhdCBpcyBydW5uaW5nIGluIGxvZ2dpbmcgbW9kZSAo
ZWl0aGVyIHdpdGggLWwgb3Igd2l0aCAtTCksDQo+ICtpdCBoYW5kbGVzIHRoZSBmb2xsb3dp
bmcgc2lnbmFsczoNCj4gKw0KPiArU0lHSFVQIC0gY2xvc2VzIGFuZCByZW9wZW5zIHRoZSBs
b2cgZmlsZSAoLUwgb25seSksIHRoZW4gY29udGludWVzLg0KPiArDQo+ICtTSUdJTlQgLSBj
bG9zZXMgdGhlIGxvZyBmaWxlIGFuZCB0ZXJtaW5hdGVzLg0KPiArU0lHVEVSTSAtIGNsb3Nl
cyB0aGUgbG9nIGZpbGUgYW5kIHRlcm1pbmF0ZXMuDQo+ICsNCj4gKw0KPiAgIFNFRSBBTFNP
DQo+ICAgLS0tLS0tLS0NCj4gICAncGVyZicoMSksICd0cmFjZS1jbWQnKDEpDQoNCg==
--------------dEuYg109tgzS5FGIQhht8Vu3
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

--------------dEuYg109tgzS5FGIQhht8Vu3--

--------------abCZza9bJa7ktEtEkDR4G9Aq--

--------------WAJpAm6VtTfBMpjT7mtFWEcV
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmcWVncFAwAAAAAACgkQsN6d1ii/Ey+5
2gf/XLbxeOmOtfD+Yw0f3q595NXElGNGUSCg9np4cFZSUhgDgmHJuNvxjTjoCPL1MSTJQJzo3Y80
HLx/pTjHxkPQ2sG017k57Y4fp2sAHCqKGgWImzDN69y18tubqE1rc8+Ljlkcv1TW88CCRHxOv6To
SweF5BwTF4QnLp1Lc7FDEZpa8fvE9/o1KjqowQIg8z403W2uuUkMlEzV/MO8ok3mnJ+Iz7sPjdWO
oQc5YPYlASvlf1iHNsSifqmPMI0nQhzacagQrqVHgWk/9tDoYN8jOkes5lbMl01gGPswIRemmDYZ
nDvDmV7Z89VgilZM4DrXSEY35NLdnL1BIDWyKMhAPA==
=u2OV
-----END PGP SIGNATURE-----

--------------WAJpAm6VtTfBMpjT7mtFWEcV--

