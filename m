Return-Path: <kvm+bounces-43805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C139A96451
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 11:29:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC132189732B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 09:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A07C1FC0F3;
	Tue, 22 Apr 2025 09:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WJO0WAx6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WJO0WAx6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6F01F5827
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 09:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745314097; cv=none; b=ZtmIwURw79MHH5JEZlq9gHQTNTW1CY8q44PCapo6jnhKOmQOyhaQkXGyTXzrkZHNjL2vBIVsKrUxoz9d3ObCjJFnVKDsg2w5NXW+mqcfKfuy9/KuV+fCw0+nV9w70ofqQU25Vu0K4+p21fwG2UbRF+WzfJa4aj3t+czdVCU3N2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745314097; c=relaxed/simple;
	bh=Isqzsei5TyXRZ7Kh444KzkiTKqyDoqePoeCewqGXj1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O8zos5RpC6HZ1jolnrjDC7hC4HCqRkXDbG3SC0POoyhgzo/nicSO1vypnpUqet8a6i92oIc+pj+/FsU6gRpBFJLvokcpGxW6Re15x2Tkq9NwfRcP73kbeshjl+UAVlHv74N1Qp0Ih6ux9l8UUcZFs4t0nf/Nwx8lNEcgQn1Nfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WJO0WAx6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WJO0WAx6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18940211CA;
	Tue, 22 Apr 2025 09:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745314093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Isqzsei5TyXRZ7Kh444KzkiTKqyDoqePoeCewqGXj1c=;
	b=WJO0WAx6oCF3ikUvqpE4aCyYMLdmUQGcz2z4dJKnd9XzpuTcugFdktpSDAkX9XAgwweCu2
	Uz4plux39lNKV1A6iGt+Rjw4539GkLf1LJ2wDjvMINRyE67AEDK9IAEhWyUWlP3zxkw9Va
	z2oIqPwTDf76wchMhgotmuTVBPWyaNs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WJO0WAx6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745314093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Isqzsei5TyXRZ7Kh444KzkiTKqyDoqePoeCewqGXj1c=;
	b=WJO0WAx6oCF3ikUvqpE4aCyYMLdmUQGcz2z4dJKnd9XzpuTcugFdktpSDAkX9XAgwweCu2
	Uz4plux39lNKV1A6iGt+Rjw4539GkLf1LJ2wDjvMINRyE67AEDK9IAEhWyUWlP3zxkw9Va
	z2oIqPwTDf76wchMhgotmuTVBPWyaNs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4C20139D5;
	Tue, 22 Apr 2025 09:28:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOqAKithB2hIYwAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 22 Apr 2025 09:28:11 +0000
Message-ID: <bfeba521-0a49-42d0-bf83-15d031dfc6da@suse.com>
Date: Tue, 22 Apr 2025 11:28:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 06/34] x86/msr: Use the alternatives mechanism to
 read PMC
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-7-xin@zytor.com>
 <fbb509e8-0bd6-480f-be32-fd0895255a21@suse.com>
 <a482b4df-f662-4d5d-8100-ade07afcdc24@zytor.com>
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
In-Reply-To: <a482b4df-f662-4d5d-8100-ade07afcdc24@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------i1ufDKWM9txfyXVXpiWBIZPH"
X-Rspamd-Queue-Id: 18940211CA
X-Spam-Level: 
X-Spamd-Result: default: False [-6.41 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[41];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	R_RATELIMIT(0.00)[to_ip_from(RLkdkdrsxe9hqhhs5ask8616i6)];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -6.41
X-Spam-Flag: NO

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------i1ufDKWM9txfyXVXpiWBIZPH
Content-Type: multipart/mixed; boundary="------------t79jkH1vw0nTqZ7sc29K922g";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-edac@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-acpi@vger.kernel.org,
 linux-hwmon@vger.kernel.org, netdev@vger.kernel.org,
 platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, acme@kernel.org,
 andrew.cooper3@citrix.com, peterz@infradead.org, namhyung@kernel.org,
 mark.rutland@arm.com, alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
 wei.liu@kernel.org, ajay.kaher@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
 pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
 luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com
Message-ID: <bfeba521-0a49-42d0-bf83-15d031dfc6da@suse.com>
Subject: Re: [RFC PATCH v2 06/34] x86/msr: Use the alternatives mechanism to
 read PMC
References: <20250422082216.1954310-1-xin@zytor.com>
 <20250422082216.1954310-7-xin@zytor.com>
 <fbb509e8-0bd6-480f-be32-fd0895255a21@suse.com>
 <a482b4df-f662-4d5d-8100-ade07afcdc24@zytor.com>
In-Reply-To: <a482b4df-f662-4d5d-8100-ade07afcdc24@zytor.com>

--------------t79jkH1vw0nTqZ7sc29K922g
Content-Type: multipart/mixed; boundary="------------k2rhN54GrX7NriGRI3BHxg0x"

--------------k2rhN54GrX7NriGRI3BHxg0x
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDQuMjUgMTE6MTIsIFhpbiBMaSB3cm90ZToNCj4gT24gNC8yMi8yMDI1IDE6Mzgg
QU0sIErDvHJnZW4gR3Jvw58gd3JvdGU6DQo+PiBPbiAyMi4wNC4yNSAxMDoyMSwgWGluIExp
IChJbnRlbCkgd3JvdGU6DQo+Pj4gVG8gZWxpbWluYXRlIHRoZSBpbmRpcmVjdCBjYWxsIG92
ZXJoZWFkIGludHJvZHVjZWQgYnkgdGhlIHB2X29wcyBBUEksDQo+Pj4gdXNlIHRoZSBhbHRl
cm5hdGl2ZXMgbWVjaGFuaXNtIHRvIHJlYWQgUE1DOg0KPj4NCj4+IFdoaWNoIGluZGlyZWN0
IGNhbGwgb3ZlcmhlYWQ/IFRoZSBpbmRpcmVjdCBjYWxsIGlzIHBhdGNoZWQgdmlhIHRoZQ0K
Pj4gYWx0ZXJuYXRpdmUgbWVjaGFuaXNtIHRvIGEgZGlyZWN0IG9uZS4NCj4+DQo+IA0KPiBT
ZWUgYmVsb3cuDQo+IA0KPiANCj4+Pg0KPj4+IMKgwqDCoMKgIDEpIFdoZW4gYnVpbHQgd2l0
aCAhQ09ORklHX1hFTl9QViwgWDg2X0ZFQVRVUkVfWEVOUFYgYmVjb21lcyBhDQo+Pj4gwqDC
oMKgwqDCoMKgwqAgZGlzYWJsZWQgZmVhdHVyZSwgcHJldmVudGluZyB0aGUgWGVuIFBNQyBy
ZWFkIGNvZGUgZnJvbSBiZWluZw0KPj4+IMKgwqDCoMKgwqDCoMKgIGJ1aWx0IGFuZCBlbnN1
cmluZyB0aGUgbmF0aXZlIGNvZGUgaXMgZXhlY3V0ZWQgdW5jb25kaXRpb25hbGx5Lg0KPj4N
Cj4+IFdpdGhvdXQgQ09ORklHX1hFTl9QViBDT05GSUdfUEFSQVZJUlRfWFhMIGlzIG5vdCBz
ZWxlY3RlZCwgcmVzdWx0aW5nIGluDQo+PiBuYXRpdmUgY29kZSBhbnl3YXkuDQo+IA0KPiBZ
ZXMsIHRoaXMgaXMga2VwdCBpbiB0aGlzIHBhdGNoLCBidXQgaW4gYSBsaXR0bGUgZGlmZmVy
ZW50IHdheS4NCj4gDQo+Pg0KPj4+DQo+Pj4gwqDCoMKgwqAgMikgV2hlbiBidWlsdCB3aXRo
IENPTkZJR19YRU5fUFY6DQo+Pj4NCj4+PiDCoMKgwqDCoMKgwqDCoCAyLjEpIElmIG5vdCBy
dW5uaW5nIG9uIHRoZSBYZW4gaHlwZXJ2aXNvciAoIVg4Nl9GRUFUVVJFX1hFTlBWKSwNCj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGhlIGtlcm5lbCBydW50aW1lIGJpbmFyeSBp
cyBwYXRjaGVkIHRvIHVuY29uZGl0aW9uYWxseQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBqdW1wIHRvIHRoZSBuYXRpdmUgUE1DIHJlYWQgY29kZS4NCj4+Pg0KPj4+IMKgwqDC
oMKgwqDCoMKgIDIuMikgSWYgcnVubmluZyBvbiB0aGUgWGVuIGh5cGVydmlzb3IgKFg4Nl9G
RUFUVVJFX1hFTlBWKSwgdGhlDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtlcm5l
bCBydW50aW1lIGJpbmFyeSBpcyBwYXRjaGVkIHRvIHVuY29uZGl0aW9uYWxseSBqdW1wDQo+
Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHRvIHRoZSBYZW4gUE1DIHJlYWQgY29kZS4N
Cj4+Pg0KPj4+IENvbnNlcXVlbnRseSwgcmVtb3ZlIHRoZSBwdl9vcHMgUE1DIHJlYWQgQVBJ
Lg0KPj4NCj4+IEkgZG9uJ3Qgc2VlIHRoZSB2YWx1ZSBvZiB0aGlzIHBhdGNoLg0KPj4NCj4+
IEl0IGFkZHMgbW9yZSAjaWZkZWYgYW5kIGNvZGUgbGluZXMgd2l0aG91dCBhbnkgcmVhbCBn
YWluLg0KPj4NCj4+IEluIGNhc2UgdGhlIHg4NiBtYWludGFpbmVycyB0aGluayBpdCBpcyBz
dGlsbCB3b3J0aCBpdCwgSSB3b24ndCBvYmplY3QuDQo+IA0KPiBJIHRoaW5rIHdlIHdhbnQg
dG8gdG90YWxseSBieXBhc3MgcHZfb3BzIGluIHRoZSBjYXNlIDIuMSkuDQo+IA0KPiBEbyB5
b3UgbWVhbiB0aGUgaW5kaXJlY3QgY2FsbCBpcyBwYXRjaGVkIHRvIGNhbGwgbmF0aXZlIGNv
ZGUgKmRpcmVjdGx5Kg0KPiBmb3IgMi4xP8KgIEkgZG9uJ3Qga25vdyBpdCwgY2FuIHlvdSBw
bGVhc2UgZWxhYm9yYXRlPw0KDQpBbGwgcGFyYXZpcnQgaW5kaXJlY3QgY2FsbHMgYXJlIHBh
dGNoZWQgdG8gZGlyZWN0IGNhbGxzIHZpYSB0aGUgbm9ybWFsDQphbHRlcm5hdGl2ZSBwYXRj
aCBtZWNoYW5pc20uDQoNCkhhdmUgYSBsb29rIGF0IGFsdF9yZXBsYWNlX2NhbGwoKSBpbiBh
cmNoL3g4Ni9rZXJuZWwvYWx0ZXJuYXRpdmUuYw0KDQo+IEFGQUlLLCBYZW4gUFYgaGFzIGJl
ZW4gdGhlIHNvbGUgdXNlciBvZiBwdl9vcHMgZm9yIG5lYXJseSAyMCB5ZWFycy4gVGhpcw0K
DQpOb3QgcXVpdGUuIFRoZXJlIHdhcyBsZ3Vlc3QgdW50aWwgSSByaXBwZWQgaXQgb3V0LiA6
LSkNCg0KQW5kIHNvbWUgdXNlIGNhc2VzIGFyZSBsZWZ0IGZvciBLVk0gYW5kIEh5cGVyLVYg
Z3Vlc3RzIChJIGhhdmUga2VwdCB0aG9zZQ0KYmVoaW5kIENPTkZJR19QQVJBVklSVCwgd2hp
bGUgdGhlIFhlbi1zcGVjaWZpYyBwYXJ0cyBhcmUgYmVoaW5kDQpDT05GSUdfUEFSQVZJUlRf
WFhMIG5vdykuDQoNCj4gcmFpc2VzIHNpZ25pZmljYW50IGRvdWJ0cyBhYm91dCB3aGV0aGVy
IHB2X29wcyBwcm92aWRlcyBMaW51eCB3aXRoIHRoZQ0KPiB2YWx1ZSBvZiBiZWluZyBhIHdl
bGwtYWJzdHJhY3RlZCAiQ1BVIiBvciAiUGxhdGZvcm0iLsKgIEFuZCB0aGUgeDg2DQo+IG1h
aW50YWluZXJzIGhhdmUgc2FpZCB0aGF0IGl0J3MgYSBtYWludGVuYW5jZSBuaWdodG1hcmUu
DQoNCkkgaGF2ZSB3b3JrZWQgcmF0aGVyIGhhcmQgdG8gbWFrZSBpdCBsZXNzIGludHJ1c2l2
ZSwgZXNwZWNpYWxseSBieSByZW1vdmluZw0KdGhlIHBhcmF2aXJ0IHNwZWNpZmljIGNvZGUg
cGF0Y2hpbmcgKG5vdyBhbGwgZG9uZSB2aWEgYWx0ZXJuYXRpdmUgcGF0Y2hpbmcpDQphbmQg
YnkgcmVtb3ZpbmcgMzItYml0IFhlbiBQViBtb2RlLg0KDQoNCkp1ZXJnZW4NCg==
--------------k2rhN54GrX7NriGRI3BHxg0x
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------k2rhN54GrX7NriGRI3BHxg0x--

--------------t79jkH1vw0nTqZ7sc29K922g--

--------------i1ufDKWM9txfyXVXpiWBIZPH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmgHYSsFAwAAAAAACgkQsN6d1ii/Ey8t
BAf/Xay1uGeOD69VQbulD5vOfWkJTcR0Set2Ks1eR2Vni6kcV54vp/BhiSm/odLCaeK6XO/CupIM
hmeYc1rLkQuUKoS3D8zYmb2d6lilx6lmkEPIw2C1bz6ceEcYRgHk/nu0soK05iUQK4x4SoFUXJMu
oQ498RSAV8OhVpgYalYwt5h6l5sjqCeuOPeTqEokiLUB544rVfx21WTI6djKReonnep9/DZd9YC0
DYfrmMpBev4bopMQyF1Ac0JO7EOyMxKcVaBT+odf3yFSpeLuLk6Lnnbi2pNL9YXscx7PvHn7hr/h
qDUjlLIdezwa3/1AX1203eHNZvMLMJ8jag9r/EO1dg==
=N5ER
-----END PGP SIGNATURE-----

--------------i1ufDKWM9txfyXVXpiWBIZPH--

