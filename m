Return-Path: <kvm+bounces-64334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A63C7FAF7
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C43C24E429F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F7302F6566;
	Mon, 24 Nov 2025 09:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="A+sGL1dr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="A+sGL1dr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E3C2F616E
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763977381; cv=none; b=ReNuYokqMXwkl0dMkQzcctKLOMFs0yV4Yr7/G2f4vPRLytYPzDCj2ajgeALpNLXPjZCEUUS3ETHuhqqWL1l8rTvrqbm3scuzGo9c+6lFQpIapbX57AENAxjNYsFQ/+nnGr0LtAtd5JcQ6l9NC561nENpmniZkddlxeNEUQM+qbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763977381; c=relaxed/simple;
	bh=A5ow2gR7SRrzbwsXPsB6yI+XFTtoV4Lp3zqNxZd9nls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qGVHfjKMs3z0FeCcSPFDoke7WaoOeF+riBUdyyXDUXtX2Eo+Vl+R8l9PYtM7dnWxVmze8jvaGS1vNIl5vjUMbleg5lgxMd+EM7ODS/IlKmm2ZAWahM4WxfNSt7l+DWy+cMwtVFY2Z7C/7QmCBir8TlQU39lgwqxGykbNh6UwRms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=A+sGL1dr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=A+sGL1dr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6481F5BD77;
	Mon, 24 Nov 2025 09:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1763977376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A5ow2gR7SRrzbwsXPsB6yI+XFTtoV4Lp3zqNxZd9nls=;
	b=A+sGL1dr7l7VmjFaYtu7yyZBJCek1xS229QbJpQRyY0SEaWfHyv2//EQQVdRujsF6rF5wN
	sg7Pf9VAroDESXffx7PYVw+JqzxjV7klIF2/ubCUBv7uK/1e9yLRarAJrga56WxGZvJyPq
	Mppynsla7GTPRm+lYgBhw7nIOqMiGlc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1763977376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A5ow2gR7SRrzbwsXPsB6yI+XFTtoV4Lp3zqNxZd9nls=;
	b=A+sGL1dr7l7VmjFaYtu7yyZBJCek1xS229QbJpQRyY0SEaWfHyv2//EQQVdRujsF6rF5wN
	sg7Pf9VAroDESXffx7PYVw+JqzxjV7klIF2/ubCUBv7uK/1e9yLRarAJrga56WxGZvJyPq
	Mppynsla7GTPRm+lYgBhw7nIOqMiGlc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C413E3EA61;
	Mon, 24 Nov 2025 09:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZutXLp4oJGlpeAAAD6G6ig
	(envelope-from <jgross@suse.com>); Mon, 24 Nov 2025 09:42:54 +0000
Message-ID: <dec8ee2c-3a00-4027-b762-aada7bc99bd9@suse.com>
Date: Mon, 24 Nov 2025 10:42:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/21] paravirt: cleanup and reorg
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
References: <20251006074606.1266-1-jgross@suse.com>
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
In-Reply-To: <20251006074606.1266-1-jgross@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------We5fW6EZMtlKny0A4cau12FQ"
X-Spam-Level: 
X-Spamd-Result: default: False [-3.70 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FREEMAIL_CC(0.00)[kernel.org,linutronix.de,redhat.com,alien8.de,linux.intel.com,zytor.com,microsoft.com,infradead.org,gmail.com,oracle.com,lists.xenproject.org,broadcom.com,armlinux.org.uk,arm.com,xen0n.name,linux.ibm.com,ellerman.id.au,csgroup.eu,dabbelt.com,eecs.berkeley.edu,ghiti.fr,linaro.org,goodmis.org,google.com,suse.de,lists.infradead.org,epam.com];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	HAS_ATTACHMENT(0.00)[];
	RCPT_COUNT_GT_50(0.00)[56];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -3.70

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------We5fW6EZMtlKny0A4cau12FQ
Content-Type: multipart/mixed; boundary="------------DrSPxjHRDVvfvpOSxXEGqtrJ";
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
Message-ID: <dec8ee2c-3a00-4027-b762-aada7bc99bd9@suse.com>
Subject: Re: [PATCH v3 00/21] paravirt: cleanup and reorg
References: <20251006074606.1266-1-jgross@suse.com>
In-Reply-To: <20251006074606.1266-1-jgross@suse.com>

--------------DrSPxjHRDVvfvpOSxXEGqtrJ
Content-Type: multipart/mixed; boundary="------------0mve0WRCUDOgkf9JsJIojBKK"

--------------0mve0WRCUDOgkf9JsJIojBKK
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

UGluZz8NCg0KSSB0aGluayBhdCBsZWFzdCB0aGUgZmlyc3QgMTIgcGF0Y2hlcyBjYW4ganVz
dCBnbyBpbi4NCg0KVGhlIG90aGVycyBzdGlsbCBsYWNrIHJldmlldy4NCg0KDQpKdWVyZ2Vu
DQoNCk9uIDA2LjEwLjI1IDA5OjQ1LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPiBTb21lIGNs
ZWFudXBzIGFuZCByZW9yZyBvZiBwYXJhdmlydCBjb2RlIGFuZCBoZWFkZXJzOg0KPiANCj4g
LSBUaGUgZmlyc3QgMiBwYXRjaGVzIHNob3VsZCBiZSBub3QgY29udHJvdmVyc2lhbCBhdCBh
bGwsIGFzIHRoZXkNCj4gICAgcmVtb3ZlIGp1c3Qgc29tZSBubyBsb25nZXIgbmVlZGVkICNp
bmNsdWRlIGFuZCBzdHJ1Y3QgZm9yd2FyZA0KPiAgICBkZWNsYXJhdGlvbnMuDQo+IA0KPiAt
IFRoZSAzcmQgcGF0Y2ggaXMgcmVtb3ZpbmcgQ09ORklHX1BBUkFWSVJUX0RFQlVHLCB3aGlj
aCBJTU8gaGFzDQo+ICAgIG5vIHJlYWwgdmFsdWUsIGFzIGl0IGp1c3QgY2hhbmdlcyBhIGNy
YXNoIHRvIGEgQlVHKCkgKHRoZSBzdGFjaw0KPiAgICB0cmFjZSB3aWxsIGJhc2ljYWxseSBi
ZSB0aGUgc2FtZSkuIEFzIHRoZSBtYWludGFpbmVyIG9mIHRoZSBtYWluDQo+ICAgIHBhcmF2
aXJ0IHVzZXIgKFhlbikgSSBoYXZlIG5ldmVyIHNlZW4gdGhpcyBjcmFzaC9CVUcoKSB0byBo
YXBwZW4uDQo+IA0KPiAtIFRoZSA0dGggcGF0Y2ggaXMganVzdCBhIG1vdmVtZW50IG9mIGNv
ZGUuDQo+IA0KPiAtIEkgZG9uJ3Qga25vdyBmb3Igd2hhdCByZWFzb24gYXNtL3BhcmF2aXJ0
X2FwaV9jbG9jay5oIHdhcyBhZGRlZCwNCj4gICAgYXMgYWxsIGFyY2hzIHN1cHBvcnRpbmcg
aXQgZG8gaXQgZXhhY3RseSBpbiB0aGUgc2FtZSB3YXkuIFBhdGNoDQo+ICAgIDUgaXMgcmVt
b3ZpbmcgaXQuDQo+IA0KPiAtIFBhdGNoZXMgNi0xNCBhcmUgc3RyZWFtbGluaW5nIHRoZSBw
YXJhdmlydCBjbG9jayBpbnRlcmZhY2VzIGJ5DQo+ICAgIHVzaW5nIGEgY29tbW9uIGltcGxl
bWVudGF0aW9uIGFjcm9zcyBhcmNoaXRlY3R1cmVzIHdoZXJlIHBvc3NpYmxlDQo+ICAgIGFu
ZCBieSBtb3ZpbmcgdGhlIHJlbGF0ZWQgY29kZSBpbnRvIGNvbW1vbiBzY2hlZCBjb2RlLCBh
cyB0aGlzIGlzDQo+ICAgIHdoZXJlIGl0IHNob3VsZCBsaXZlLg0KPiANCj4gLSBQYXRjaGVz
IDE1LTIwIGFyZSBtb3JlIGxpa2UgUkZDIG1hdGVyaWFsIHByZXBhcmluZyB0aGUgcGFyYXZp
cnQNCj4gICAgaW5mcmFzdHJ1Y3R1cmUgdG8gc3VwcG9ydCBtdWx0aXBsZSBwdl9vcHMgZnVu
Y3Rpb24gYXJyYXlzLg0KPiAgICBBcyBhIHByZXJlcXVpc2l0ZSBmb3IgdGhhdCBpdCBtYWtl
cyBsaWZlIGluIG9ianRvb2wgbXVjaCBlYXNpZXINCj4gICAgd2l0aCBkcm9wcGluZyB0aGUg
WGVuIHN0YXRpYyBpbml0aWFsaXplcnMgb2YgdGhlIHB2X29wcyBzdWItDQo+ICAgIHN0cnVj
dHVyZXMsIHdoaWNoIGlzIGRvbmUgaW4gcGF0Y2hlcyAxNS0xNy4NCj4gICAgUGF0Y2hlcyAx
OC0yMCBhcmUgZG9pbmcgdGhlIHJlYWwgcHJlcGFyYXRpb25zIGZvciBtdWx0aXBsZSBwdl9v
cHMNCj4gICAgYXJyYXlzIGFuZCB1c2luZyB0aG9zZSBhcnJheXMgaW4gbXVsdGlwbGUgaGVh
ZGVycy4NCj4gDQo+IC0gUGF0Y2ggMjEgaXMgYW4gZXhhbXBsZSBob3cgdGhlIG5ldyBzY2hl
bWUgY2FuIGxvb2sgbGlrZSB1c2luZyB0aGUNCj4gICAgUFYtc3BpbmxvY2tzLg0KPiANCj4g
Q2hhbmdlcyBpbiBWMjoNCj4gLSBuZXcgcGF0Y2hlcyAxMy0xOCBhbmQgMjANCj4gLSBjb21w
bGV0ZSByZXdvcmsgb2YgcGF0Y2ggMjENCj4gDQo+IENoYW5nZXMgaW4gVjM6DQo+IC0gZml4
ZWQgMiBpc3N1ZXMgZGV0ZWN0ZWQgYnkga2VybmVsIHRlc3Qgcm9ib3QNCj4gDQo+IEp1ZXJn
ZW4gR3Jvc3MgKDIxKToNCj4gICAgeDg2L3BhcmF2aXJ0OiBSZW1vdmUgbm90IG5lZWRlZCBp
bmNsdWRlcyBvZiBwYXJhdmlydC5oDQo+ICAgIHg4Ni9wYXJhdmlydDogUmVtb3ZlIHNvbWUg
dW5uZWVkZWQgc3RydWN0IGRlY2xhcmF0aW9ucw0KPiAgICB4ODYvcGFyYXZpcnQ6IFJlbW92
ZSBQQVJBVklSVF9ERUJVRyBjb25maWcgb3B0aW9uDQo+ICAgIHg4Ni9wYXJhdmlydDogTW92
ZSB0aHVuayBtYWNyb3MgdG8gcGFyYXZpcnRfdHlwZXMuaA0KPiAgICBwYXJhdmlydDogUmVt
b3ZlIGFzbS9wYXJhdmlydF9hcGlfY2xvY2suaA0KPiAgICBzY2hlZDogTW92ZSBjbG9jayBy
ZWxhdGVkIHBhcmF2aXJ0IGNvZGUgdG8ga2VybmVsL3NjaGVkDQo+ICAgIGFybS9wYXJhdmly
dDogVXNlIGNvbW1vbiBjb2RlIGZvciBwYXJhdmlydF9zdGVhbF9jbG9jaygpDQo+ICAgIGFy
bTY0L3BhcmF2aXJ0OiBVc2UgY29tbW9uIGNvZGUgZm9yIHBhcmF2aXJ0X3N0ZWFsX2Nsb2Nr
KCkNCj4gICAgbG9vbmdhcmNoL3BhcmF2aXJ0OiBVc2UgY29tbW9uIGNvZGUgZm9yIHBhcmF2
aXJ0X3N0ZWFsX2Nsb2NrKCkNCj4gICAgcmlzY3YvcGFyYXZpcnQ6IFVzZSBjb21tb24gY29k
ZSBmb3IgcGFyYXZpcnRfc3RlYWxfY2xvY2soKQ0KPiAgICB4ODYvcGFyYXZpcnQ6IFVzZSBj
b21tb24gY29kZSBmb3IgcGFyYXZpcnRfc3RlYWxfY2xvY2soKQ0KPiAgICB4ODYvcGFyYXZp
cnQ6IE1vdmUgcGFyYXZpcnRfc2NoZWRfY2xvY2soKSByZWxhdGVkIGNvZGUgaW50byB0c2Mu
Yw0KPiAgICB4ODYvcGFyYXZpcnQ6IEludHJvZHVjZSBuZXcgcGFyYXZpcnQtYmFzZS5oIGhl
YWRlcg0KPiAgICB4ODYvcGFyYXZpcnQ6IE1vdmUgcHZfbmF0aXZlXyooKSBwcm90b3R5cGVz
IHRvIHBhcmF2aXJ0LmMNCj4gICAgeDg2L3hlbjogRHJvcCB4ZW5faXJxX29wcw0KPiAgICB4
ODYveGVuOiBEcm9wIHhlbl9jcHVfb3BzDQo+ICAgIHg4Ni94ZW46IERyb3AgeGVuX21tdV9v
cHMNCj4gICAgb2JqdG9vbDogQWxsb3cgbXVsdGlwbGUgcHZfb3BzIGFycmF5cw0KPiAgICB4
ODYvcGFyYXZpcnQ6IEFsbG93IHB2LWNhbGxzIG91dHNpZGUgcGFyYXZpcnQuaA0KPiAgICB4
ODYvcGFyYXZpcnQ6IFNwZWNpZnkgcHZfb3BzIGFycmF5IGluIHBhcmF2aXJ0IG1hY3Jvcw0K
PiAgICB4ODYvcHZsb2NrczogTW92ZSBwYXJhdmlydCBzcGlubG9jayBmdW5jdGlvbnMgaW50
byBvd24gaGVhZGVyDQo+IA0KPiAgIGFyY2gvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgMyArDQo+ICAgYXJjaC9hcm0vS2NvbmZpZyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL2FybS9pbmNsdWRlL2FzbS9w
YXJhdmlydC5oICAgICAgICAgICAgICAgfCAgMjIgLS0NCj4gICBhcmNoL2FybS9pbmNsdWRl
L2FzbS9wYXJhdmlydF9hcGlfY2xvY2suaCAgICAgfCAgIDEgLQ0KPiAgIGFyY2gvYXJtL2tl
cm5lbC9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC9h
cm0va2VybmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICAgICAgICAgIHwgIDIzIC0tDQo+ICAg
YXJjaC9hcm02NC9LY29uZmlnICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsN
Cj4gICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICAgICAgfCAg
MTQgLQ0KPiAgIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vcGFyYXZpcnRfYXBpX2Nsb2NrLmgg
ICB8ICAgMSAtDQo+ICAgYXJjaC9hcm02NC9rZXJuZWwvcGFyYXZpcnQuYyAgICAgICAgICAg
ICAgICAgIHwgIDExICstDQo+ICAgYXJjaC9sb29uZ2FyY2gvS2NvbmZpZyAgICAgICAgICAg
ICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL2xvb25nYXJjaC9pbmNsdWRlL2FzbS9w
YXJhdmlydC5oICAgICAgICAgfCAgMTMgLQ0KPiAgIC4uLi9pbmNsdWRlL2FzbS9wYXJhdmly
dF9hcGlfY2xvY2suaCAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC9sb29uZ2FyY2gva2Vy
bmVsL3BhcmF2aXJ0LmMgICAgICAgICAgICAgIHwgIDEwICstDQo+ICAgYXJjaC9wb3dlcnBj
L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICAgIHwgICAzIC0NCj4gICBhcmNoL3Bv
d2VycGMvaW5jbHVkZS9hc20vcGFyYXZpcnRfYXBpX2Nsb2NrLmggfCAgIDIgLQ0KPiAgIGFy
Y2gvcG93ZXJwYy9wbGF0Zm9ybXMvcHNlcmllcy9zZXR1cC5jICAgICAgICB8ICAgNCArLQ0K
PiAgIGFyY2gvcmlzY3YvS2NvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAg
MSArDQo+ICAgYXJjaC9yaXNjdi9pbmNsdWRlL2FzbS9wYXJhdmlydC5oICAgICAgICAgICAg
IHwgIDE0IC0NCj4gICBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9j
ay5oICAgfCAgIDEgLQ0KPiAgIGFyY2gvcmlzY3Yva2VybmVsL3BhcmF2aXJ0LmMgICAgICAg
ICAgICAgICAgICB8ICAxMSArLQ0KPiAgIGFyY2gveDg2L0tjb25maWcgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB8ICAgOCArLQ0KPiAgIGFyY2gveDg2L2VudHJ5L2VudHJ5XzY0
LlMgICAgICAgICAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC94ODYvZW50cnkvdnN5
c2NhbGwvdnN5c2NhbGxfNjQuYyAgICAgICAgIHwgICAxIC0NCj4gICBhcmNoL3g4Ni9oeXBl
cnYvaHZfc3BpbmxvY2suYyAgICAgICAgICAgICAgICAgfCAgMTEgKy0NCj4gICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS9hcGljLmggICAgICAgICAgICAgICAgICAgfCAgIDQgLQ0KPiAgIGFy
Y2gveDg2L2luY2x1ZGUvYXNtL2hpZ2htZW0uaCAgICAgICAgICAgICAgICB8ICAgMSAtDQo+
ICAgYXJjaC94ODYvaW5jbHVkZS9hc20vbXNoeXBlcnYuaCAgICAgICAgICAgICAgIHwgICAx
IC0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC1iYXNlLmggICAgICAgICAg
fCAgMjkgKysNCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC1zcGlubG9jay5o
ICAgICAgfCAxNDYgKysrKysrKysNCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmly
dC5oICAgICAgICAgICAgICAgfCAzMzEgKysrKystLS0tLS0tLS0tLS0tDQo+ICAgYXJjaC94
ODYvaW5jbHVkZS9hc20vcGFyYXZpcnRfYXBpX2Nsb2NrLmggICAgIHwgICAxIC0NCj4gICBh
cmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5oICAgICAgICAgfCAyNjkgKysr
KysrKy0tLS0tLS0NCj4gICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wZ3RhYmxlXzMyLmggICAg
ICAgICAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3B0cmFjZS5oICAg
ICAgICAgICAgICAgICB8ICAgMiArLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUvYXNtL3FzcGlu
bG9jay5oICAgICAgICAgICAgICB8ICA4OSArLS0tLQ0KPiAgIGFyY2gveDg2L2luY2x1ZGUv
YXNtL3NwaW5sb2NrLmggICAgICAgICAgICAgICB8ICAgMSAtDQo+ICAgYXJjaC94ODYvaW5j
bHVkZS9hc20vdGltZXIuaCAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL3g4
Ni9pbmNsdWRlL2FzbS90bGJmbHVzaC5oICAgICAgICAgICAgICAgfCAgIDQgLQ0KPiAgIGFy
Y2gveDg2L2tlcm5lbC9NYWtlZmlsZSAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQ0K
PiAgIGFyY2gveDg2L2tlcm5lbC9hcG1fMzIuYyAgICAgICAgICAgICAgICAgICAgICB8ICAg
MSAtDQo+ICAgYXJjaC94ODYva2VybmVsL2NhbGx0aHVua3MuYyAgICAgICAgICAgICAgICAg
IHwgICAxIC0NCj4gICBhcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYyAgICAgICAgICAgICAg
ICAgICAgfCAgIDEgLQ0KPiAgIGFyY2gveDg2L2tlcm5lbC9jcHUvdm13YXJlLmMgICAgICAg
ICAgICAgICAgICB8ICAgMSArDQo+ICAgYXJjaC94ODYva2VybmVsL2t2bS5jICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgIDExICstDQo+ICAgYXJjaC94ODYva2VybmVsL2t2bWNsb2Nr
LmMgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gICBhcmNoL3g4Ni9rZXJuZWwvcGFy
YXZpcnQtc3BpbmxvY2tzLmMgICAgICAgICAgfCAgMjYgKy0NCj4gICBhcmNoL3g4Ni9rZXJu
ZWwvcGFyYXZpcnQuYyAgICAgICAgICAgICAgICAgICAgfCAgNDIgKy0tDQo+ICAgYXJjaC94
ODYva2VybmVsL3RzYy5jICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDEwICstDQo+ICAg
YXJjaC94ODYva2VybmVsL3ZzbXBfNjQuYyAgICAgICAgICAgICAgICAgICAgIHwgICAxIC0N
Cj4gICBhcmNoL3g4Ni9rZXJuZWwveDg2X2luaXQuYyAgICAgICAgICAgICAgICAgICAgfCAg
IDEgLQ0KPiAgIGFyY2gveDg2L2xpYi9jYWNoZS1zbXAuYyAgICAgICAgICAgICAgICAgICAg
ICB8ICAgMSAtDQo+ICAgYXJjaC94ODYvbW0vaW5pdC5jICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAxIC0NCj4gICBhcmNoL3g4Ni94ZW4vZW5saWdodGVuX3B2LmMgICAgICAg
ICAgICAgICAgICAgfCAgODIgKystLS0NCj4gICBhcmNoL3g4Ni94ZW4vaXJxLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgMjAgKy0NCj4gICBhcmNoL3g4Ni94ZW4vbW11X3B2
LmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMDAgKystLS0tDQo+ICAgYXJjaC94ODYv
eGVuL3NwaW5sb2NrLmMgICAgICAgICAgICAgICAgICAgICAgIHwgIDExICstDQo+ICAgYXJj
aC94ODYveGVuL3RpbWUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsNCj4g
ICBkcml2ZXJzL2Nsb2Nrc291cmNlL2h5cGVydl90aW1lci5jICAgICAgICAgICAgfCAgIDIg
Kw0KPiAgIGRyaXZlcnMveGVuL3RpbWUuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgMiArLQ0KPiAgIGluY2x1ZGUvbGludXgvc2NoZWQvY3B1dGltZS5oICAgICAgICAgICAg
ICAgICB8ICAxOCArDQo+ICAga2VybmVsL3NjaGVkL2NvcmUuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICA1ICsNCj4gICBrZXJuZWwvc2NoZWQvY3B1dGltZS5jICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMTMgKw0KPiAgIGtlcm5lbC9zY2hlZC9zY2hlZC5oICAgICAg
ICAgICAgICAgICAgICAgICAgICB8ICAgMyArLQ0KPiAgIHRvb2xzL29ianRvb2wvYXJjaC94
ODYvZGVjb2RlLmMgICAgICAgICAgICAgICB8ICAgOCArLQ0KPiAgIHRvb2xzL29ianRvb2wv
Y2hlY2suYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICA3OCArKysrLQ0KPiAgIHRvb2xz
L29ianRvb2wvaW5jbHVkZS9vYmp0b29sL2NoZWNrLmggICAgICAgICB8ICAgMiArDQo+ICAg
NjcgZmlsZXMgY2hhbmdlZCwgNjU5IGluc2VydGlvbnMoKyksIDgyNyBkZWxldGlvbnMoLSkN
Cj4gICBkZWxldGUgbW9kZSAxMDA2NDQgYXJjaC9hcm0vaW5jbHVkZS9hc20vcGFyYXZpcnQu
aA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybS9pbmNsdWRlL2FzbS9wYXJhdmly
dF9hcGlfY2xvY2suaA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybS9rZXJuZWwv
cGFyYXZpcnQuYw0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL2FybTY0L2luY2x1ZGUv
YXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+ICAgZGVsZXRlIG1vZGUgMTAwNjQ0IGFyY2gv
bG9vbmdhcmNoL2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+ICAgZGVsZXRl
IG1vZGUgMTAwNjQ0IGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9wYXJhdmlydF9hcGlfY2xv
Y2suaA0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCBhcmNoL3Jpc2N2L2luY2x1ZGUvYXNtL3Bh
cmF2aXJ0X2FwaV9jbG9jay5oDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL3BhcmF2aXJ0LWJhc2UuaA0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNo
L3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydC1zcGlubG9jay5oDQo+ICAgZGVsZXRlIG1vZGUg
MTAwNjQ0IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0X2FwaV9jbG9jay5oDQo+IA0K
DQo=
--------------0mve0WRCUDOgkf9JsJIojBKK
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
kt+z4drzFUyEjLM1vVvIMjkUoJs=3D
=3DeeAB
-----END PGP PUBLIC KEY BLOCK-----

--------------0mve0WRCUDOgkf9JsJIojBKK--

--------------DrSPxjHRDVvfvpOSxXEGqtrJ--

--------------We5fW6EZMtlKny0A4cau12FQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmkkKJ4FAwAAAAAACgkQsN6d1ii/Ey96
XQf/SZ63IJyquodbQLgO7UOlhatNR0JUxtLBGXtzzD9lLJ9MGtRZn78fU/peXEGHNZEA2wJlcKOY
+2AJ32Xsn9JL/9ZmbQyt014ovVTablifIrv8xlTgAgN99kTtFi2NiYD/AF98VCabwNRx+QK9Vo4n
N4Eb1eW7YQFGLSAya7T7u2xWNW41xgedaRvQNEMOvGajK6VExI9lo9cXSp5bS+VKZqQWygNsQjAy
BYg/u1+1sDr7L56331yDxmStB00H20evlCYda5vlv1qP2WpF3CuT+rpLAfQ4Wf1YCS+2ZW6UvLfy
A6h35oFwyf1ohDIh7OysCxTH57L6hrDqciTpulba8Q==
=JJbu
-----END PGP SIGNATURE-----

--------------We5fW6EZMtlKny0A4cau12FQ--

