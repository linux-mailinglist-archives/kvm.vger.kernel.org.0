Return-Path: <kvm+bounces-9862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B4E1867899
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E35A2292100
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44CD12AAE1;
	Mon, 26 Feb 2024 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s/cxEG32";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s/cxEG32"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB6F266D4;
	Mon, 26 Feb 2024 14:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708957976; cv=none; b=kqhIuBLVQ/pc9S/NNuedJjsZ9ab0ANcWn2NLjpuY1ikuamm08/ncst16aQLJdE7CiXsWTgjP9DkBn34BI6SDAo/fjDmBjFgqwlmwfbO0M3Hn7fKcXWCHdhN7e9jCN7SN7O1puwtbT62Zl0v+Mncd0Ky30p9B2TuAdvpPfz0NAWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708957976; c=relaxed/simple;
	bh=VA2MB0uadd7qswU+wG4Un/6KcrZKTbYmy9J521kELqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cE4ckewyMhYq/Z9bZ0dtO4p4PQY89r74cA+pQFLSnY3+rJQTqFXSIPJXmnKqi80GgnTasDyhrd1lsFV40s5lnpc83GO+VHLJajOD5kmxIfKjPu+1wxYvfI6BbzSyKqCnBqURMKQlu+pLiy+3M1zTf29VMv4oKg9yWmbgCbtbfVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s/cxEG32; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s/cxEG32; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B86E1FB5D;
	Mon, 26 Feb 2024 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1708957972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VA2MB0uadd7qswU+wG4Un/6KcrZKTbYmy9J521kELqY=;
	b=s/cxEG32LQV0ZUunNN+cUdRlINnVOwhuu26ourJ71XdRm0iWGGtLGlKT6u9k0gSLHBd+OG
	j0tgnLftYk+0hkwmc00yn653rnQvma5Fqg8BIPRDHswEHNiCkcVLR/zBXpgx5bAcLq51CQ
	UiAp3JwrRft/Kt94ON5QgrIUtJQESNI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1708957972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VA2MB0uadd7qswU+wG4Un/6KcrZKTbYmy9J521kELqY=;
	b=s/cxEG32LQV0ZUunNN+cUdRlINnVOwhuu26ourJ71XdRm0iWGGtLGlKT6u9k0gSLHBd+OG
	j0tgnLftYk+0hkwmc00yn653rnQvma5Fqg8BIPRDHswEHNiCkcVLR/zBXpgx5bAcLq51CQ
	UiAp3JwrRft/Kt94ON5QgrIUtJQESNI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91E5A13A58;
	Mon, 26 Feb 2024 14:32:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sk0DIhOh3GXZbwAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 26 Feb 2024 14:32:51 +0000
Message-ID: <b3f896bd-2931-4edc-b5da-3cc9561b897e@suse.com>
Date: Mon, 26 Feb 2024 15:32:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 004/130] x86/virt/tdx: Support global metadata read
 for all element sizes
Content-Language: en-US
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>
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
In-Reply-To: <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0qzto84v555WSmyXMEB6dzPr"
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -5.17
X-Spamd-Result: default: False [-5.17 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 TO_DN_SOME(0.00)[];
	 HAS_ATTACHMENT(0.00)[];
	 MIME_BASE64_TEXT_BOGUS(1.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 NEURAL_HAM_SHORT(-0.18)[-0.917];
	 MIME_BASE64_TEXT(0.10)[];
	 SIGNED_PGP(-2.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	 BAYES_HAM(-3.00)[100.00%];
	 MID_RHS_MATCH_FROM(0.00)[];
	 MIME_UNKNOWN(0.10)[application/pgp-keys];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 RCPT_COUNT_TWELVE(0.00)[12];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[gmail.com,redhat.com,google.com,intel.com];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0qzto84v555WSmyXMEB6dzPr
Content-Type: multipart/mixed; boundary="------------yazgFuAmOE2571cLGpU1p7y1";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
Message-ID: <b3f896bd-2931-4edc-b5da-3cc9561b897e@suse.com>
Subject: Re: [PATCH v19 004/130] x86/virt/tdx: Support global metadata read
 for all element sizes
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>

--------------yazgFuAmOE2571cLGpU1p7y1
Content-Type: multipart/mixed; boundary="------------9yZQw4dru00SgDu5KQoSz0pr"

--------------9yZQw4dru00SgDu5KQoSz0pr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjYuMDIuMjQgMDk6MjUsIGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbSB3cm90ZToNCj4g
RnJvbTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiANCj4gRm9yIG5vdyB0
aGUga2VybmVsIG9ubHkgcmVhZHMgVERNUiByZWxhdGVkIGdsb2JhbCBtZXRhZGF0YSBmaWVs
ZHMgZm9yDQo+IG1vZHVsZSBpbml0aWFsaXphdGlvbi4gIEFsbCB0aGVzZSBmaWVsZHMgYXJl
IDE2LWJpdHMsIGFuZCB0aGUga2VybmVsDQo+IG9ubHkgc3VwcG9ydHMgcmVhZGluZyAxNi1i
aXRzIGZpZWxkcy4NCj4gDQo+IEtWTSB3aWxsIG5lZWQgdG8gcmVhZCBhIGJ1bmNoIG9mIG5v
bi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEgdG8gY3JlYXRlIGFuZA0KPiBydW4gVERYIGd1ZXN0
cy4gIEl0J3MgZXNzZW50aWFsIHRvIHByb3ZpZGUgYSBnZW5lcmljIG1ldGFkYXRhIHJlYWQN
Cj4gaW5mcmFzdHJ1Y3R1cmUgd2hpY2ggc3VwcG9ydHMgcmVhZGluZyBhbGwgOC8xNi8zMi82
NCBiaXRzIGVsZW1lbnQgc2l6ZXMuDQo+IA0KPiBFeHRlbmQgdGhlIG1ldGFkYXRhIHJlYWQg
dG8gc3VwcG9ydCByZWFkaW5nIGFsbCB0aGVzZSBlbGVtZW50IHNpemVzLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiAt
LS0NCj4gICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMgfCA1OSArKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tDQo+ICAgYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5oIHwgIDIgLS0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDIx
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCBlYjIwOGRh
NGZmNjMuLmExOWFkYzg5OGRmNiAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAt
MjcxLDIzICsyNzEsMzUgQEAgc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YV9maWVsZCh1
NjQgZmllbGRfaWQsIHU2NCAqZGF0YSkNCj4gICAJcmV0dXJuIDA7DQo+ICAgfQ0KPiAgIA0K
PiAtc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YV9maWVsZDE2KHU2NCBmaWVsZF9pZCwN
Cj4gLQkJCQkgICAgIGludCBvZmZzZXQsDQo+IC0JCQkJICAgICB2b2lkICpzdGJ1ZikNCj4g
Ky8qIFJldHVybiB0aGUgbWV0YWRhdGEgZmllbGQgZWxlbWVudCBzaXplIGluIGJ5dGVzICov
DQo+ICtzdGF0aWMgaW50IGdldF9tZXRhZGF0YV9maWVsZF9ieXRlcyh1NjQgZmllbGRfaWQp
DQo+ICAgew0KPiAtCXUxNiAqc3RfbWVtYmVyID0gc3RidWYgKyBvZmZzZXQ7DQo+ICsJLyoN
Cj4gKwkgKiBURFggc3VwcG9ydHMgOC8xNi8zMi82NCBiaXRzIG1ldGFkYXRhIGZpZWxkIGVs
ZW1lbnQgc2l6ZXMuDQo+ICsJICogVERYIG1vZHVsZSBkZXRlcm1pbmVzIHRoZSBtZXRhZGF0
YSBlbGVtZW50IHNpemUgYmFzZWQgb24gdGhlDQo+ICsJICogImVsZW1lbnQgc2l6ZSBjb2Rl
IiBlbmNvZGVkIGluIHRoZSBmaWVsZCBJRCAoc2VlIHRoZSBjb21tZW50DQo+ICsJICogb2Yg
TURfRklFTERfSURfRUxFX1NJWkVfQ09ERSBtYWNybyBmb3Igc3BlY2lmaWMgZW5jb2Rpbmdz
KS4NCj4gKwkgKi8NCj4gKwlyZXR1cm4gMSA8PCBNRF9GSUVMRF9JRF9FTEVfU0laRV9DT0RF
KGZpZWxkX2lkKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBzdGJ1Zl9yZWFkX3N5c19t
ZXRhZGF0YV9maWVsZCh1NjQgZmllbGRfaWQsDQo+ICsJCQkJCSBpbnQgb2Zmc2V0LA0KPiAr
CQkJCQkgaW50IGJ5dGVzLA0KPiArCQkJCQkgdm9pZCAqc3RidWYpDQo+ICt7DQo+ICsJdm9p
ZCAqc3RfbWVtYmVyID0gc3RidWYgKyBvZmZzZXQ7DQo+ICAgCXU2NCB0bXA7DQo+ICAgCWlu
dCByZXQ7DQo+ICAgDQo+IC0JaWYgKFdBUk5fT05fT05DRShNRF9GSUVMRF9JRF9FTEVfU0la
RV9DT0RFKGZpZWxkX2lkKSAhPQ0KPiAtCQkJTURfRklFTERfSURfRUxFX1NJWkVfMTZCSVQp
KQ0KPiArCWlmIChXQVJOX09OX09OQ0UoZ2V0X21ldGFkYXRhX2ZpZWxkX2J5dGVzKGZpZWxk
X2lkKSAhPSBieXRlcykpDQo+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gICANCj4gICAJcmV0
ID0gcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoZmllbGRfaWQsICZ0bXApOw0KPiAgIAlpZiAo
cmV0KQ0KPiAgIAkJcmV0dXJuIHJldDsNCj4gICANCj4gLQkqc3RfbWVtYmVyID0gdG1wOw0K
PiArCW1lbWNweShzdF9tZW1iZXIsICZ0bXAsIGJ5dGVzKTsNCj4gICANCj4gICAJcmV0dXJu
IDA7DQo+ICAgfQ0KPiBAQCAtMjk1LDExICszMDcsMzAgQEAgc3RhdGljIGludCByZWFkX3N5
c19tZXRhZGF0YV9maWVsZDE2KHU2NCBmaWVsZF9pZCwNCj4gICBzdHJ1Y3QgZmllbGRfbWFw
cGluZyB7DQo+ICAgCXU2NCBmaWVsZF9pZDsNCj4gICAJaW50IG9mZnNldDsNCj4gKwlpbnQg
c2l6ZTsNCj4gICB9Ow0KPiAgIA0KPiAgICNkZWZpbmUgVERfU1lTSU5GT19NQVAoX2ZpZWxk
X2lkLCBfc3RydWN0LCBfbWVtYmVyKQlcDQo+ICAgCXsgLmZpZWxkX2lkID0gTURfRklFTERf
SURfIyNfZmllbGRfaWQsCQlcDQo+IC0JICAub2Zmc2V0ICAgPSBvZmZzZXRvZihfc3RydWN0
LCBfbWVtYmVyKSB9DQo+ICsJICAub2Zmc2V0ICAgPSBvZmZzZXRvZihfc3RydWN0LCBfbWVt
YmVyKSwJXA0KPiArCSAgLnNpemUgICAgID0gc2l6ZW9mKHR5cGVvZigoKF9zdHJ1Y3QgKikw
KS0+X21lbWJlcikpIH0NCj4gKw0KPiArc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0YShz
dHJ1Y3QgZmllbGRfbWFwcGluZyAqZmllbGRzLCBpbnQgbnJfZmllbGRzLA0KDQpUaGUgZmly
c3QgcGFyYW1ldGVyIHNob3VsZCBiZSAiY29uc3Qgc3RydWN0IGZpZWxkX21hcHBpbmcgKmZp
ZWxkcyIuDQoNCg0KSnVlcmdlbg0K
--------------9yZQw4dru00SgDu5KQoSz0pr
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------9yZQw4dru00SgDu5KQoSz0pr--

--------------yazgFuAmOE2571cLGpU1p7y1--

--------------0qzto84v555WSmyXMEB6dzPr
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmXcoRMFAwAAAAAACgkQsN6d1ii/Ey+k
vggAn4PheBIZzauBwAqJLlgmspukLkyQP3MKofXYMg9z3zoJ80dp5DQmqBtGMNY5TZn91Pn4NSyL
ieoO81taUwh7wL7cLYxD5jPQwVTnk+HMlrJjES1tSWE8TJoZWyIfpHpiw/oRBLrIjBv/olnR2PIE
8hS6z81go/++zjdGSVOWRoKFj2ixMm6efcfP0w9c4EJusdiP7jaNXwgWZf1cff+FWHyni6/8xBQO
TdgWQJKHieBA1n6Qshgg7F/8MhJ06YBYV/quS7vud9O+L5F1D9g84wVM5CugjPk2qORwXRVUEHXM
TYIWqZG03uDpYx6r6CDxaAbD1oXUjqp6fmwafF0Rhg==
=0zfD
-----END PGP SIGNATURE-----

--------------0qzto84v555WSmyXMEB6dzPr--

