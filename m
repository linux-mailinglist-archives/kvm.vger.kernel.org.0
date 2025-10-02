Return-Path: <kvm+bounces-59393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9269ABB2BB6
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 09:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4886C4232CE
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 07:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5572D0C73;
	Thu,  2 Oct 2025 07:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ksmrQUKY";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ksmrQUKY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9D238166
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 07:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759391220; cv=none; b=jk12da7HIfNbXfc+oxkRWPgniv7eqeHy+QaRhnK9KprwHkVrkGrOWBsEgjnTgpQbG7S3q+9DC+cnjnttBbnYccNIVR8YPcrJFHyEA2qnBP1aAxwvDgwsJ+jnRr7HcpOIEiTC0ddPPl3yuncaKNrFq7a3JJkvFqUfqn4g+ksjyX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759391220; c=relaxed/simple;
	bh=HbUDv50SZcajdTpZlbZra6ry+wsVkSq/kY4OBLKyqKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itjKHJeOu60rq4q+zepfTykMPaAycYzcjbWVkSzm04KgU84QjUO50121V5jTL5H7qSy2UgjgDNnsUyA9ud9AqYaxNeyzdbtLV2sLe1VuUfOl5BGaFhuwNoZp010WUUHIaHQmtyFm9fH/q60y6aL7zj3DiuszFiWPifVaKTqUZpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ksmrQUKY; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ksmrQUKY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5E0681F8D4;
	Thu,  2 Oct 2025 07:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1759391216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HbUDv50SZcajdTpZlbZra6ry+wsVkSq/kY4OBLKyqKI=;
	b=ksmrQUKY+gWdiS0+kn1fKoGHBNMTBvASbqmplyXXb92RJ/yu9tBetMsfC9VV0YopE5Itf/
	ZE4N+uGzIAeCCEyO229VbN0R1oxa0YiPGEv6FaN/kvjWjxUnNwK694C/p7CgxInlguCmFr
	NTUPsnpa6G5JGhxSWSazGNKVq77TRsA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1759391216; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HbUDv50SZcajdTpZlbZra6ry+wsVkSq/kY4OBLKyqKI=;
	b=ksmrQUKY+gWdiS0+kn1fKoGHBNMTBvASbqmplyXXb92RJ/yu9tBetMsfC9VV0YopE5Itf/
	ZE4N+uGzIAeCCEyO229VbN0R1oxa0YiPGEv6FaN/kvjWjxUnNwK694C/p7CgxInlguCmFr
	NTUPsnpa6G5JGhxSWSazGNKVq77TRsA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 724FC1395B;
	Thu,  2 Oct 2025 07:46:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sIoUGu8t3mjARwAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 02 Oct 2025 07:46:55 +0000
Message-ID: <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
Date: Thu, 2 Oct 2025 09:46:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "Hansen, Dave" <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Huang, Kai" <kai.huang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "Gao, Chao"
 <chao.gao@intel.com>, "sagis@google.com" <sagis@google.com>,
 "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
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
In-Reply-To: <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8Kvnz2vWSuar3VVm72WJ3lkr"
X-Spamd-Result: default: False [-6.20 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_BASE64_TEXT(0.10)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[27];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	HAS_ATTACHMENT(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -6.20

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8Kvnz2vWSuar3VVm72WJ3lkr
Content-Type: multipart/mixed; boundary="------------bRM7eILUcb7tiYuilz9WTFd7";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "Hansen, Dave" <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Huang, Kai" <kai.huang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>, "Gao, Chao"
 <chao.gao@intel.com>, "sagis@google.com" <sagis@google.com>,
 "Chen, Farrah" <farrah.chen@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <27d19ea5-d078-405b-a963-91d19b4229c8@suse.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
References: <20250901160930.1785244-1-pbonzini@redhat.com>
 <20250901160930.1785244-5-pbonzini@redhat.com>
 <CAGtprH__G96uUmiDkK0iYM2miXb31vYje9aN+J=stJQqLUUXEg@mail.gmail.com>
 <74a390a1-42a7-4e6b-a76a-f88f49323c93@intel.com>
 <CAGtprH-mb0Cw+OzBj-gSWenA9kSJyu-xgXhsTjjzyY6Qi4E=aw@mail.gmail.com>
 <a2042a7b-2e12-4893-ac8d-50c0f77f26e9@intel.com>
 <CAGtprH_nTBdX-VtMQJM4-y8KcB_F4CnafqpDX7ktASwhO0sxAg@mail.gmail.com>
 <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB575071F87791817215355DD8E7E7A@DM8PR11MB5750.namprd11.prod.outlook.com>

--------------bRM7eILUcb7tiYuilz9WTFd7
Content-Type: multipart/mixed; boundary="------------UyQCERjKhD3gmelcdITVzU3t"

--------------UyQCERjKhD3gmelcdITVzU3t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDIuMTAuMjUgMDg6NTksIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+PiBPbiBXZWQs
IE9jdCAxLCAyMDI1IGF0IDc6MzLigK9BTSBEYXZlIEhhbnNlbiA8ZGF2ZS5oYW5zZW5AaW50
ZWwuY29tPg0KPj4gd3JvdGU6DQo+Pj4NCj4+PiBPbiA5LzMwLzI1IDE5OjA1LCBWaXNoYWwg
QW5uYXB1cnZlIHdyb3RlOg0KPj4+IC4uLg0KPj4+Pj4gQW55IHdvcmthcm91bmRzIGFyZSBn
b2luZyB0byBiZSBzbG93IGFuZCBwcm9iYWJseSBpbXBlcmZlY3QuIFRoYXQncyBub3QNCj4+
Pj4NCj4+Pj4gRG8gd2UgcmVhbGx5IG5lZWQgdG8gZGVwbG95IHdvcmthcm91bmRzIHRoYXQg
YXJlIGNvbXBsZXggYW5kIHNsb3cgdG8NCj4+Pj4gZ2V0IGtkdW1wIHdvcmtpbmcgZm9yIHRo
ZSBtYWpvcml0eSBvZiB0aGUgc2NlbmFyaW9zPyBJcyB0aGVyZSBhbnkNCj4+Pj4gYW5hbHlz
aXMgZG9uZSBmb3IgdGhlIHJpc2sgd2l0aCBpbXBlcmZlY3QgYW5kIHNpbXBsZXIgd29ya2Fy
b3VuZHMgdnMNCj4+Pj4gYmVuZWZpdHMgb2Yga2R1bXAgZnVuY3Rpb25hbGl0eT8NCj4+Pj4N
Cj4+Pj4+IGEgZ3JlYXQgbWF0Y2ggZm9yIGtkdW1wLiBJJ20gcGVyZmVjdGx5IGhhcHB5IHdh
aXRpbmcgZm9yIGZpeGVkIGhhcmR3YXJlDQo+Pj4+PiBmcm9tIHdoYXQgSSd2ZSBzZWVuLg0K
Pj4+Pg0KPj4+PiBJSVVDIFNQUi9FTVIgLSB0d28gQ1BVIGdlbmVyYXRpb25zIG91dCB0aGVy
ZSBhcmUgaW1wYWN0ZWQgYnkgdGhpcw0KPj4+PiBlcnJhdHVtIGFuZCBqdXN0IGRpc2FibGlu
ZyBrZHVtcCBmdW5jdGlvbmFsaXR5IElNTyBpcyBub3QgdGhlIGJlc3QNCj4+Pj4gc29sdXRp
b24gaGVyZS4NCj4+Pg0KPj4+IFRoYXQncyBhbiBlbWluZW50bHkgcmVhc29uYWJsZSBwb3Np
dGlvbi4gQnV0IHdlJ3JlIHNwZWFraW5nIGluIGJyb2FkDQo+Pj4gZ2VuZXJhbGl0aWVzIGFu
ZCBJJ20gdW5zdXJlIHdoYXQgeW91IGRvbid0IGxpa2UgYWJvdXQgdGhlIHN0YXR1cyBxdW8g
b3INCj4+PiBob3cgeW91J2QgbGlrZSB0byBzZWUgdGhpbmdzIGNoYW5nZS4NCj4+DQo+PiBM
b29rcyBsaWtlIHRoZSBkZWNpc2lvbiB0byBkaXNhYmxlIGtkdW1wIHdhcyB0YWtlbiBiZXR3
ZWVuIFsxXSAtPiBbMl0uDQo+PiAiVGhlIGtlcm5lbCBjdXJyZW50bHkgZG9lc24ndCB0cmFj
ayB3aGljaCBwYWdlIGlzIFREWCBwcml2YXRlIG1lbW9yeS4NCj4+IEl0J3Mgbm90IHRyaXZp
YWwgdG8gcmVzZXQgVERYIHByaXZhdGUgbWVtb3J5LiAgRm9yIHNpbXBsaWNpdHksIHRoaXMN
Cj4+IHNlcmllcyBzaW1wbHkgZGlzYWJsZXMga2V4ZWMva2R1bXAgZm9yIHN1Y2ggcGxhdGZv
cm1zLiAgVGhpcyB3aWxsIGJlDQo+PiBlbmhhbmNlZCBpbiB0aGUgZnV0dXJlLiINCj4+DQo+
PiBBIHBhdGNoIFszXSBmcm9tIHRoZSBzZXJpZXNbMV0sIGRlc2NyaWJlcyB0aGUgaXNzdWUg
YXM6DQo+PiAiVGhpcyBwcm9ibGVtIGlzIHRyaWdnZXJlZCBieSAicGFydGlhbCIgd3JpdGVz
IHdoZXJlIGEgd3JpdGUgdHJhbnNhY3Rpb24NCj4+IG9mIGxlc3MgdGhhbiBjYWNoZWxpbmUg
bGFuZHMgYXQgdGhlIG1lbW9yeSBjb250cm9sbGVyLiAgVGhlIENQVSBkb2VzDQo+PiB0aGVz
ZSB2aWEgbm9uLXRlbXBvcmFsIHdyaXRlIGluc3RydWN0aW9ucyAobGlrZSBNT1ZOVEkpLCBv
ciB0aHJvdWdoDQo+PiBVQy9XQyBtZW1vcnkgbWFwcGluZ3MuICBUaGUgaXNzdWUgY2FuIGFs
c28gYmUgdHJpZ2dlcmVkIGF3YXkgZnJvbSB0aGUNCj4+IENQVSBieSBkZXZpY2VzIGRvaW5n
IHBhcnRpYWwgd3JpdGVzIHZpYSBETUEuIg0KPj4NCj4+IEFuZCBhbHNvIG1lbnRpb25zOg0K
Pj4gIkFsc28gbm90ZSBvbmx5IHRoZSBub3JtYWwga2V4ZWMgbmVlZHMgdG8gd29ycnkgYWJv
dXQgdGhpcyBwcm9ibGVtLCBidXQNCj4+IG5vdCB0aGUgY3Jhc2gga2V4ZWM6IDEpIFRoZSBr
ZHVtcCBrZXJuZWwgb25seSB1c2VzIHRoZSBzcGVjaWFsIG1lbW9yeQ0KPj4gcmVzZXJ2ZWQg
YnkgdGhlIGZpcnN0IGtlcm5lbCwgYW5kIHRoZSByZXNlcnZlZCBtZW1vcnkgY2FuIG5ldmVy
IGJlIHVzZWQNCj4+IGJ5IFREWCBpbiB0aGUgZmlyc3Qga2VybmVsOyAyKSBUaGUgL3Byb2Mv
dm1jb3JlLCB3aGljaCByZWZsZWN0cyB0aGUNCj4+IGZpcnN0IChjcmFzaGVkKSBrZXJuZWwn
cyBtZW1vcnksIGlzIG9ubHkgZm9yIHJlYWQuICBUaGUgcmVhZCB3aWxsIG5ldmVyDQo+PiAi
cG9pc29uIiBURFggbWVtb3J5IHRodXMgY2F1c2UgdW5leHBlY3RlZCBtYWNoaW5lIGNoZWNr
IChvbmx5IHBhcnRpYWwNCj4+IHdyaXRlIGRvZXMpLiINCj4gDQo+IFdoaWxlIHRoZSBzdGF0
ZW1lbnQgdGhhdCB0aGUgcmVhZCB3aWxsIG5ldmVyIHBvaXNvbiB0aGUgbWVtb3J5IGlzIGNv
cnJlY3QsDQo+IHRoZSBzaXR1YXRpb24gd2UgY2FuIHRoZW9yZXRpY2FsbHkgd29ycnkgYWJv
dXQgaXMgdGhlIGZvbGxvd2luZyBpbiBteSB1bmRlcnN0YW5kaW5nOg0KPiANCj4gMS4gRHVy
aW5nIGl0cyBleGVjdXRpb24gb24gcGxhdGZvcm0gd2l0aCBwYXJ0aWFsIHdyaXRlIHByb2Js
ZW0sIGhvc3QgT1Mgb3Igb3RoZXINCj4gYWN0b3IgZXhlY3V0aW5nIG91dHNpZGUgb2YgU0VB
TSBtb2RlIHRyaWdnZXJzIHBhcnRpYWwgd3JpdGUgaW50byBhIGNhY2hlIGxpbmUgdGhhdA0K
PiBvcmlnaW5hbGx5IGJlbG9uZ2VkIHRvIFREWCBwcml2YXRlIG1lbW9yeS4NCj4gVGhpcyBp
cyBzbXRoIHRoYXQgaG9zdCBPUyBvciBvdGhlciBlbnRpdGllcyBzaG91bGQgbm90IGRvLCBi
dXQgaXQgY291bGQgaGFwcGVuIGR1ZQ0KPiB0byBob3N0IE9TIGJ1Z3MsIGV0Yy4NCj4gMi4g
VGhlIGFib3ZlIGNhdXNlcyB0aGUgc3BlY2lmaWVkIGNhY2hlIGxpbmUgdG8gYmUgcG9pc29u
ZWQgYnkgbWVtIGNvbnRyb2xsZXIuDQo+IEhvd2V2ZXIsIGhlcmUgd2UgYXNzdW1lIHRoYXQg
bm8gb25lIGFjY2Vzc2VzIHRoaXMgY2FjaGUgbGluZSBmcm9tIFREWCBtb2R1bGUsDQo+IFRE
IGd1ZXN0cyBvciBIb3N0IE9TIGZvciB0aGUgdGltZSBiZWluZyBhbmQgdGhlIHByb2JsZW0g
cmVtYWlucyBoaWRkZW4uDQo+IDMuIEhvc3QgT1MgY3Jhc2hlcyBkdWUgdG8gc29tZSBvdGhl
ciBpc3N1ZSwga2R1bXAgY3Jhc2gga2VybmVsIGlzIHRyaWdnZXJlZCwNCj4gYW5kIGtkdW1w
IHN0YXJ0cyB0byByZWFkIGFsbCB0aGUgbWVtb3J5IGZyb20gdGhlIHByZXZpb3VzIGhvc3Qg
a2VybmVsIHRvIGR1bXANCj4gdGhlIGRpYWdub3N0aWNzIGluZm8uDQo+IDQuIEF0IHNvbWUg
cG9pbnQgb2YgdGltZSwga2R1bXAgY3Jhc2gga2VybmVsIHJlYWNoZXMgdGhlIG1lbW9yeSB3
aXRoIHRoZSBwb2lzb25lZA0KPiBjYWNoZSBsaW5lLCBjb25zdW1lcyBwb2lzb24sIGFuZCB0
aGUgI01DIGlzIGlzc3VlZCBmb3IgdGhlIGtlcm5lbCBzcGFjZS4NCj4gDQo+IElzbid0IHRo
aXMgdGhlIHJlYXNvbiBmb3IgYWxzbyBkaXNhYmxpbmcga2R1bXA/IE9yIGRvIEkgbWlzcyBz
bXRoPw0KDQpTbyBsZXRzIGNvbXBhcmUgdGhlIDIgY2FzZXMgd2l0aCBrZHVtcCBlbmFibGVk
IGFuZCBkaXNhYmxlZCBpbiB5b3VyIHNjZW5hcmlvDQooY3Jhc2ggb2YgdGhlIGhvc3QgT1Mp
Og0KDQprZHVtcCBlbmFibGVkOiBObyBkdW1wIGNhbiBiZSBwcm9kdWNlZCBkdWUgdG8gdGhl
ICNNQyBhbmQgc3lzdGVtIGlzIHJlYm9vdGVkLg0KDQprZHVtcCBkaXNhYmxlZDogTm8gZHVt
cCBpcyBwcm9kdWNlZCBhbmQgc3lzdGVtIGlzIHJlYm9vdGVkIGFmdGVyIGNyYXNoLg0KDQpX
aGF0IGlzIHRoZSBtYWluIGNvbmNlcm4gd2l0aCBrZHVtcCBlbmFibGVkPyBJIGRvbid0IHNl
ZSBhbnkgZGlzYWR2YW50YWdlIHdpdGgNCmVuYWJsaW5nIGl0LCBqdXN0IHRoZSBhZHZhbnRh
Z2UgdGhhdCBpbiBtYW55IGNhc2VzIGEgZHVtcCB3aWxsIGJlIHdyaXR0ZW4uDQoNCg0KSnVl
cmdlbg0K
--------------UyQCERjKhD3gmelcdITVzU3t
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

--------------UyQCERjKhD3gmelcdITVzU3t--

--------------bRM7eILUcb7tiYuilz9WTFd7--

--------------8Kvnz2vWSuar3VVm72WJ3lkr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmjeLe4FAwAAAAAACgkQsN6d1ii/Ey+O
tQf+JlGyu78uiqtQprjWGnZUSLnoc5bpJ4jugzyEuSsAREHHra+ykY6tiFyB8CIGczTZgOpYLb/0
+mFc/IF5I/cwaeWOXwfRLOkCrYsYqoXhGCBBb2miFcfmU0PmwXVvXcyb8b/83VmGEd9MfDKxPPaM
bFA7SaJiPvjSq44dw28wqsazlMos9r5AErczL3LtslzAZHpy48y4dwJfI4yzrnWlWlGzut3Zn//U
IAlgua54SuKNqTUX82wDqAke79bTQJ+GxsHahUDYGk0KcX1IgfSPd4ZyITLJbEuTIsclOAyyQYmM
wNcsRufcII/fKnzAQy1/34qip1m2u062CzfsDx102g==
=zZKx
-----END PGP SIGNATURE-----

--------------8Kvnz2vWSuar3VVm72WJ3lkr--

