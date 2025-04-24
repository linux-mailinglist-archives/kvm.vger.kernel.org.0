Return-Path: <kvm+bounces-44108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC7FA9A772
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 11:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 992A9189DF1B
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 09:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CF821B9C4;
	Thu, 24 Apr 2025 09:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YpV0sqbe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YpV0sqbe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4C214A7F
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 09:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745485742; cv=none; b=kT1CUzkB1qdf+Fl+jljOFkrUBNf+B+TE5sL8mEi2fF41dzfhacTY0f7JOwQdXgnr/a4DTMKQUw42C5DvIZXniC/20evWK46WT2bQ99gh+lYDAnC2cwOzWApdNWFYGTPieEeBS/9cGrLQHN7w1BvA5Uxbk6iHF+nWFDHq4yhbuyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745485742; c=relaxed/simple;
	bh=UAsSnCZGsDqQTiTpVbn0ixPBpHqio4DIzSXgqkSakzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rn/Yl2K+CffzlPU7tc3QZYfdEPI5J/RoVkarMCuzNQSRLJ8PBNxMmW538ugU8c5ajGDhniVktCDf0k/x6nLDc0L4/+w0Tt5N9rleLhd3diyAPYnRkhoQNEzc1zAepi6XsZFDxq+Sye+A4XO16n88gB3FSBpeUBebWU6G1C/2E8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YpV0sqbe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YpV0sqbe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4F8C71F38C;
	Thu, 24 Apr 2025 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745485737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UAsSnCZGsDqQTiTpVbn0ixPBpHqio4DIzSXgqkSakzY=;
	b=YpV0sqbe2x7nb/576c0zEvJ6PxAv709DbUEyGvmPoYk55JlhxAy/vcQKJp4Vyc6ewneVCH
	xeaeCPHrlXaKwflFLLqgiVx6YF9r1du6UlllAyp4lNKXqoif5CMg5FHKCxrlJqMIFtIHlj
	31q4nhQgoDk/rz2AZR1FTBYZkI/KdrI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745485737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UAsSnCZGsDqQTiTpVbn0ixPBpHqio4DIzSXgqkSakzY=;
	b=YpV0sqbe2x7nb/576c0zEvJ6PxAv709DbUEyGvmPoYk55JlhxAy/vcQKJp4Vyc6ewneVCH
	xeaeCPHrlXaKwflFLLqgiVx6YF9r1du6UlllAyp4lNKXqoif5CMg5FHKCxrlJqMIFtIHlj
	31q4nhQgoDk/rz2AZR1FTBYZkI/KdrI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 789B5139D0;
	Thu, 24 Apr 2025 09:08:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HPTLG6j/CWgMFAAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 24 Apr 2025 09:08:56 +0000
Message-ID: <f7fe0d58-c6a0-4d25-8c5f-73f7b747970f@suse.com>
Date: Thu, 24 Apr 2025 11:08:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
 Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
 <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
 <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
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
In-Reply-To: <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UZ8TilJqpfLBedWDbrv00s83"
X-Spam-Level: 
X-Spamd-Result: default: False [-5.19 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-0.99)[-0.992];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	HAS_ATTACHMENT(0.00)[]
X-Spam-Score: -5.19
X-Spam-Flag: NO

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------UZ8TilJqpfLBedWDbrv00s83
Content-Type: multipart/mixed; boundary="------------OeOH79kSNo1j1oTSQ3Rt6NOY";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>,
 Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 chao.p.peng@intel.com
Message-ID: <f7fe0d58-c6a0-4d25-8c5f-73f7b747970f@suse.com>
Subject: Re: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <e735cpugrs3k5gncjcbjyycft3tuhkm75azpwv6ctwqfjr6gkg@rsf4lyq4gqoj>
 <aAn3SSocw0XvaRye@yzhao56-desk.sh.intel.com>
 <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>
In-Reply-To: <6vdj4mfxlyvypn743klxq5twda66tkugwzljdt275rug2gmwwl@zdziylxpre6y>

--------------OeOH79kSNo1j1oTSQ3Rt6NOY
Content-Type: multipart/mixed; boundary="------------nvtTbheBbcELWQCP8HZ2WejF"

--------------nvtTbheBbcELWQCP8HZ2WejF
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjQuMDQuMjUgMTE6MDUsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gT24gVGh1
LCBBcHIgMjQsIDIwMjUgYXQgMDQ6MzM6MTNQTSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+
PiBPbiBUaHUsIEFwciAyNCwgMjAyNSBhdCAxMDozNTo0N0FNICswMzAwLCBLaXJpbGwgQS4g
U2h1dGVtb3Ygd3JvdGU6DQo+Pj4gT24gVGh1LCBBcHIgMjQsIDIwMjUgYXQgMTE6MDA6MzJB
TSArMDgwMCwgWWFuIFpoYW8gd3JvdGU6DQo+Pj4+IEJhc2ljIGh1Z2UgcGFnZSBtYXBwaW5n
L3VubWFwcGluZw0KPj4+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+
Pj4gLSBURCBidWlsZCB0aW1lDQo+Pj4+ICAgIFRoaXMgc2VyaWVzIGVuZm9yY2VzIHRoYXQg
YWxsIHByaXZhdGUgbWFwcGluZ3MgYmUgNEtCIGR1cmluZyB0aGUgVEQgYnVpbGQNCj4+Pj4g
ICAgcGhhc2UsIGR1ZSB0byB0aGUgVERYIG1vZHVsZSdzIHJlcXVpcmVtZW50IHRoYXQgdGRo
X21lbV9wYWdlX2FkZCgpLCB0aGUNCj4+Pj4gICAgU0VBTUNBTEwgZm9yIGFkZGluZyBwcml2
YXRlIHBhZ2VzIGR1cmluZyBURCBidWlsZCB0aW1lLCBvbmx5IHN1cHBvcnRzIDRLQg0KPj4+
PiAgICBtYXBwaW5ncy4gRW5mb3JjaW5nIDRLQiBtYXBwaW5ncyBhbHNvIHNpbXBsaWZpZXMg
dGhlIGltcGxlbWVudGF0aW9uIG9mDQo+Pj4+ICAgIGNvZGUgZm9yIFREIGJ1aWxkIHRpbWUs
IGJ5IGVsaW1pbmF0aW5nIHRoZSBuZWVkIHRvIGNvbnNpZGVyIG1lcmdpbmcgb3INCj4+Pj4g
ICAgc3BsaXR0aW5nIGluIHRoZSBtaXJyb3IgcGFnZSB0YWJsZSBkdXJpbmcgVEQgYnVpbGQg
dGltZS4NCj4+Pj4gICAgDQo+Pj4+ICAgIFRoZSB1bmRlcmx5aW5nIHBhZ2VzIGFsbG9jYXRl
ZCBmcm9tIGd1ZXN0X21lbWZkIGR1cmluZyBURCBidWlsZCB0aW1lDQo+Pj4+ICAgIHBoYXNl
IGNhbiBzdGlsbCBiZSBsYXJnZSwgYWxsb3dpbmcgZm9yIHBvdGVudGlhbCBtZXJnaW5nIGlu
dG8gMk1CDQo+Pj4+ICAgIG1hcHBpbmdzIG9uY2UgdGhlIFREIGlzIHJ1bm5pbmcuDQo+Pj4N
Cj4+PiBJdCBjYW4gYmUgZG9uZSBiZWZvcmUgVEQgaXMgcnVubmluZy4gVGhlIG1lcmdpbmcg
aXMgYWxsb3dlZCBvbiBURCBidWlsZA0KPj4+IHN0YWdlLg0KPj4+DQo+Pj4gQnV0LCB5ZXMs
IGZvciBzaW1wbGljaXR5IHdlIGNhbiBza2lwIGl0IGZvciBpbml0aWFsIGVuYWJsaW5nLg0K
Pj4gWWVzLCB0byBhdm9pZCBjb21wbGljYXRpbmcga3ZtX3RkeC0+bnJfcHJlbWFwcGVkIGNh
bGN1bGF0aW9uLg0KPj4gSSBhbHNvIGRvbid0IHNlZSBhbnkgYmVuZWZpdCB0byBhbGxvdyBt
ZXJnaW5nIGR1cmluZyBURCBidWlsZCBzdGFnZS4NCj4+DQo+Pj4NCj4+Pj4gUGFnZSBzcGxp
dHRpbmcgKHBhZ2UgZGVtb3Rpb24pDQo+Pj4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPj4+PiBQYWdlIHNwbGl0dGluZyBvY2N1cnMgaW4gdHdvIHBhdGhzOg0KPj4+PiAo
YSkgd2l0aCBleGNsdXNpdmUga3ZtLT5tbXVfbG9jaywgdHJpZ2dlcmVkIGJ5IHphcHBpbmcg
b3BlcmF0aW9ucywNCj4+Pj4NCj4+Pj4gICAgICBGb3Igbm9ybWFsIFZNcywgaWYgemFwcGlu
ZyBhIG5hcnJvdyByZWdpb24gdGhhdCB3b3VsZCBuZWVkIHRvIHNwbGl0IGENCj4+Pj4gICAg
ICBodWdlIHBhZ2UsIEtWTSBjYW4gc2ltcGx5IHphcCB0aGUgc3Vycm91bmRpbmcgR0ZOcyBy
YXRoZXIgdGhhbg0KPj4+PiAgICAgIHNwbGl0dGluZyBhIGh1Z2UgcGFnZS4gVGhlIHBhZ2Vz
IGNhbiB0aGVuIGJlIGZhdWx0ZWQgYmFjayBpbiwgd2hlcmUgS1ZNDQo+Pj4+ICAgICAgY2Fu
IGhhbmRsZSBtYXBwaW5nIHRoZW0gYXQgYSA0S0IgbGV2ZWwuDQo+Pj4+DQo+Pj4+ICAgICAg
VGhlIHJlYXNvbiB3aHkgVERYIGNhbid0IHVzZSB0aGUgbm9ybWFsIFZNIHNvbHV0aW9uIGlz
IHRoYXQgemFwcGluZw0KPj4+PiAgICAgIHByaXZhdGUgbWVtb3J5IHRoYXQgaXMgYWNjZXB0
ZWQgY2Fubm90IGVhc2lseSBiZSByZS1mYXVsdGVkLCBzaW5jZSBpdA0KPj4+PiAgICAgIGNh
biBvbmx5IGJlIHJlLWZhdWx0ZWQgYXMgdW5hY2NlcHRlZC4gU28gS1ZNIHdpbGwgaGF2ZSB0
byBzb21ldGltZXMgZG8NCj4+Pj4gICAgICB0aGUgcGFnZSBzcGxpdHRpbmcgYXMgcGFydCBv
ZiB0aGUgemFwcGluZyBvcGVyYXRpb25zLg0KPj4+Pg0KPj4+PiAgICAgIFRoZXNlIHphcHBp
bmcgb3BlcmF0aW9ucyBjYW4gb2NjdXIgZm9yIGZldyByZWFzb25zOg0KPj4+PiAgICAgIDEu
IFZNIHRlYXJkb3duLg0KPj4+PiAgICAgIDIuIE1lbXNsb3QgcmVtb3ZhbC4NCj4+Pj4gICAg
ICAzLiBDb252ZXJzaW9uIG9mIHByaXZhdGUgcGFnZXMgdG8gc2hhcmVkLg0KPj4+PiAgICAg
IDQuIFVzZXJzcGFjZSBkb2VzIGEgaG9sZSBwdW5jaCB0byBndWVzdF9tZW1mZCBmb3Igc29t
ZSByZWFzb24uDQo+Pj4+DQo+Pj4+ICAgICAgRm9yIGNhc2UgMSBhbmQgMiwgc3BsaXR0aW5n
IGJlZm9yZSB6YXBwaW5nIGlzIHVubmVjZXNzYXJ5IGJlY2F1c2UNCj4+Pj4gICAgICBlaXRo
ZXIgdGhlIGVudGlyZSByYW5nZSB3aWxsIGJlIHphcHBlZCBvciBodWdlIHBhZ2VzIGRvIG5v
dCBzcGFuDQo+Pj4+ICAgICAgbWVtc2xvdHMuDQo+Pj4+ICAgICAgDQo+Pj4+ICAgICAgQ2Fz
ZSAzIG9yIGNhc2UgNCByZXF1aXJlcyBzcGxpdHRpbmcsIHdoaWNoIGlzIGFsc28gZm9sbG93
ZWQgYnkgYQ0KPj4+PiAgICAgIGJhY2tlbmQgcGFnZSBzcGxpdHRpbmcgaW4gZ3Vlc3RfbWVt
ZmQuDQo+Pj4+DQo+Pj4+IChiKSB3aXRoIHNoYXJlZCBrdm0tPm1tdV9sb2NrLCB0cmlnZ2Vy
ZWQgYnkgZmF1bHQuDQo+Pj4+DQo+Pj4+ICAgICAgU3BsaXR0aW5nIGluIHRoaXMgcGF0aCBp
cyBub3QgYWNjb21wYW5pZWQgYnkgYSBiYWNrZW5kIHBhZ2Ugc3BsaXR0aW5nDQo+Pj4+ICAg
ICAgKHNpbmNlIGJhY2tlbmQgcGFnZSBzcGxpdHRpbmcgbmVjZXNzaXRhdGVzIGEgc3BsaXR0
aW5nIGFuZCB6YXBwaW5nDQo+Pj4+ICAgICAgIG9wZXJhdGlvbiBpbiB0aGUgZm9ybWVyIHBh
dGgpLiAgSXQgaXMgdHJpZ2dlcmVkIHdoZW4gS1ZNIGZpbmRzIHRoYXQgYQ0KPj4+PiAgICAg
IG5vbi1sZWFmIGVudHJ5IGlzIHJlcGxhY2luZyBhIGh1Z2UgZW50cnkgaW4gdGhlIGZhdWx0
IHBhdGgsIHdoaWNoIGlzDQo+Pj4+ICAgICAgdXN1YWxseSBjYXVzZWQgYnkgdkNQVXMnIGNv
bmN1cnJlbnQgQUNDRVBUIG9wZXJhdGlvbnMgYXQgZGlmZmVyZW50DQo+Pj4+ICAgICAgbGV2
ZWxzLg0KPj4+DQo+Pj4gSG0uIFRoaXMgc291bmRzIGxpa2UgZnVua3kgYmVoYXZpb3VyIG9u
IHRoZSBndWVzdCBzaWRlLg0KPj4+DQo+Pj4gWW91IG9ubHkgc2F3IGl0IGluIGEgc3ludGhl
dGljIHRlc3QsIHJpZ2h0PyBObyByZWFsIGd1ZXN0IE9TIHNob3VsZCBkbw0KPj4+IHRoaXMu
DQo+PiBSaWdodC4gSW4gc2VsZnRlc3Qgb25seS4NCj4+IEFsc28gaW4gY2FzZSBvZiBhbnkg
Z3Vlc3QgYnVncy4NCj4+DQo+Pj4gSXQgY2FuIG9ubHkgYmUgcG9zc2libGUgaWYgZ3Vlc3Qg
aXMgcmVja2xlc3MgZW5vdWdoIHRvIGJlIGV4cG9zZWQgdG8NCj4+PiBkb3VibGUgYWNjZXB0
IGF0dGFja3MuDQo+Pj4NCj4+PiBXZSBzaG91bGQgY29uc2lkZXIgcHV0dGluZyBhIHdhcm5p
bmcgaWYgd2UgZGV0ZWN0IHN1Y2ggY2FzZSBvbiBLVk0gc2lkZS4NCj4+IElzIGl0IGFjY2Vw
dGFibGUgdG8gcHV0IHdhcm5pbmdzIGluIGhvc3Qga2VybmVsIGluIGNhc2Ugb2YgZ3Vlc3Qg
YnVncyBvcg0KPj4gYXR0YWNrcz8NCj4gDQo+IHByX3dhcm5fb25jZSgpIHNob3VsZG4ndCBi
ZSBhIGJpZyBkZWFsLg0KDQpTaG91bGRuJ3Qgc3VjaCBhIHdhcm5pbmcgYmUgb25jZSBwZXIg
Z3Vlc3Q/DQoNClNvIGVpdGhlciB3ZSBuZWVkIGEgcGVyIGd1ZXN0IGZsYWcsIG9yIHdlIGNv
dWxkIHVzZSBwcl93YXJuX3JhdGVsaW1pdGVkKCkuDQoNCg0KSnVlcmdlbg0K
--------------nvtTbheBbcELWQCP8HZ2WejF
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------nvtTbheBbcELWQCP8HZ2WejF--

--------------OeOH79kSNo1j1oTSQ3Rt6NOY--

--------------UZ8TilJqpfLBedWDbrv00s83
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgJ/6cFAwAAAAAACgkQsN6d1ii/Ey9e
xggAlJDAvofSl3cnDEsF0qZ5PDDp8B2JGDuhg/9mL8GOzyHmbBIDM4/kCgYtm0JNKe4op2YxORmz
u2c71CY+lfsOG9gKAAIegrQDlxeGX8u+lD6yeLApfeZumyWuBqvWppz83z7EO7G21YkQjxmW8knc
F/hWphHqU+HGj205GrjW37MeZ5qwEZxBYBV+WQkU4cTtRh4cmgcFdD8H0iWDa4PstgCDr7X3bPfJ
E4X34InObIwYCkvZ3XkMNS7WbhGZHQKx6ysKqhtsREC04vFXIU8Z7Vg3hXlPR++ZUsCkWWBNZDuT
LIy8tT8gv9hD/a7sA9zmf5qG7y0jHbTDG927scw76w==
=Ug5P
-----END PGP SIGNATURE-----

--------------UZ8TilJqpfLBedWDbrv00s83--

