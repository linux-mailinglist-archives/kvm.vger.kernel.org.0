Return-Path: <kvm+bounces-71336-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BWEKLWtlmlkjQIAu9opvQ
	(envelope-from <kvm+bounces-71336-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 07:29:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E2B15C630
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 07:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2B7EE3031300
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484BF2F9D98;
	Thu, 19 Feb 2026 06:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VzEV7aJ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A9C2F3C37
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 06:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771482532; cv=none; b=BjUdHxcYMvkQ/CsLQllYxMpGPmahgmeuqnzjWJzA0PGC14HzsMYVQGUq6ZrZ6Lixk+2v6546PFAEFwymqPdWFzyGphN3px0fCKvk9okLxcdSrO7QFTv9T7tPBl7+ah+3HSO4h2izUjU3zVYMIenPNKkG4uLHU3sDJewlBOdN0y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771482532; c=relaxed/simple;
	bh=xHkR2DNL8rqaZKFVAj81J2UIJJCt3Q5LF4NuA/QdKH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ox2WrQizB51vet7HZAJOGzKw5hRyJYhwMvElST7kULbek0q6Nsc8/ujULI4SMKmQeEbqKgqH04Ihaq6UBbSuyo0t27MjjHpiw8wf8kCrH3ef2uX79XuMWlf01TBiiIMBtAzRJrqqK5zk3HqZJS+P79NvM3JzJQxVhCNCLRiHCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VzEV7aJ6; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c20dc9577so926336a12.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 22:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771482529; x=1772087329; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xHkR2DNL8rqaZKFVAj81J2UIJJCt3Q5LF4NuA/QdKH0=;
        b=VzEV7aJ65iU9ymbWNKln7j9UbBtq8kv0d6AnP3Vtv6u1eG614IIYY/zYVcPn6sxFMD
         T6C4udizoeS8V1rRoDbKk8e8bahDUuv2OTXI8fyfKXSLKcAa/MQrYcf7GqFtjHweCKFa
         JG15W6/VYgDG2cd8mWtfHICas6/p3Ue7/xvmLkHzN7G5aimbUffprLOA4L8+bk7QJsdP
         Gcg0fkPpPSsYL4XIJ1x0FUS2PJmuXa5wIVVIdHNYblUvUS3nyGl6AnnA24553mqxyAL8
         Ph5Gai5lqwNpimkVpGJURrSFmAqDeKTznar+P0MPbYnnPDoUJL35Wxd7I6lDKT2LNJhC
         LjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771482529; x=1772087329;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xHkR2DNL8rqaZKFVAj81J2UIJJCt3Q5LF4NuA/QdKH0=;
        b=A25EF3x7i3bmBWnWWD071ZxDk2N6oZYg58K75P87dzMu3gEcmp8hJPxYwxQtlbP54g
         8GwVXSqw4oW7ZrV4QJ4BzVKjuXixmpKQQg/7U25M1J18oye6690AAlRLM4KBg22DMBqV
         Yg4FFkFXKx4udhnqVoYNfm+0MZIEa9qDyMeqB6SmFdHpCLLt/+MAxavjjNyY1rTERTmT
         CyGqKfcagNU6kQowi7f6uwPb/mJ12Kli9INPKS3V8jSqTmHpcdE16oWsXxP/W99IOxDS
         AN+tpTy0QaEydD/a7RSg1hb62nJmvyn36+B0ICGekGJylVk8L7I5MbyHg6A0Mlp5ylNk
         /B1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVX3su7l4w8iI2ipCe3eY2zkx/xSypYcxsPZxLugLz5mmkxXdBh8iwZEWpqaVazk0YShAU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxG/dJUUHzftO2tVXYZs2cNk2lrPDhoOa0g2IpzkHIC073KmY6U
	g2sMZzVFyltmxe2snJTIJpXaHd7AelIX8tkiXw0Igg8FdjXbvp+8gIcAeOEKbFbQmXo=
X-Gm-Gg: AZuq6aIoz/pEMV+rrexo6eBr+02WtOelMZkohlkDalorWqRXlQEbbBPcnDzgFGoZphS
	pa4iilq6nx+9c+dHv5L9s1HTBrzP/d3TVDz2YWiuomuFlYCn9IOR0omYXagi8SKYpL+I7/u+cjq
	QI+d1sWMexiLSRUQ2QXmQ52Xu3qq5LfLLuoGrYLHkAvVbKgS9NSffHQImOYy/agxKJrWuAtI9pQ
	LI5xnKULC5uraR6bxKY/a+CyVNtilvVRXjLFDMxwXK5W/czMIThpFupTV5m5N1kp2EGO0da85Ie
	mx8zRRXmg22m7ILH7UUDmXtvtq1D7ualw1Dr1P9GtA0gPn/2RR4CdbS08wHxlMR/ziellLasrVD
	8iVCmT9yhrr1hu8vXtt+LOKves+Pp44kxl6t2zbGxsSad+GLIsGop+MelfOpYxe9V3qSdA5y2nQ
	IJahIZrPawb+lfHLLkG/33eeuTLoS91yjUe9tzRMX11vxTvF6Phi2vr8ASdwjFyRBfHqB4LWBWN
	OT3Yk9Q12Dz9pGrEfIdnIZqSdZl9sKNa717TWc4uTmNE45sbiFRKKaGUzW+
X-Received: by 2002:a17:907:9808:b0:b90:48b:b53c with SMTP id a640c23a62f3a-b90048bb667mr697243266b.32.1771482528828;
        Wed, 18 Feb 2026 22:28:48 -0800 (PST)
Received: from ?IPV6:2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1? (2a00-12d0-af5b-2f01-4042-c03-ce4d-a5a1.ip.tng.de. [2a00:12d0:af5b:2f01:4042:c03:ce4d:a5a1])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc768ffc0sm543441666b.56.2026.02.18.22.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 22:28:48 -0800 (PST)
Message-ID: <bae9c067-b5f0-4904-8eab-957ff793e140@suse.com>
Date: Thu, 19 Feb 2026 07:28:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/16] x86/msr: Inline rdmsr/wrmsr instructions
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 llvm@lists.linux.dev
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Xin Li <xin@zytor.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, andy.cooper@citrix.com
References: <20260218082133.400602-1-jgross@suse.com>
 <3D1FE2A7-F237-4232-9E39-6AFC75F3A4F0@zytor.com>
Content-Language: en-US
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
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
In-Reply-To: <3D1FE2A7-F237-4232-9E39-6AFC75F3A4F0@zytor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------iM0WWoZER14TV00iL3mHiqfS"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.85 / 15.00];
	SIGNED_PGP(-2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	R_MIXED_CHARSET(0.71)[subject];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_UNKNOWN(0.10)[application/pgp-keys];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71336-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:+,4:~,5:~];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[36];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,alien8.de,linux.intel.com,intel.com,google.com,microsoft.com,oracle.com,lists.xenproject.org,broadcom.com,infradead.org,zytor.com,gmail.com,citrix.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DKIM_TRACE(0.00)[suse.com:+];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[jgross@suse.com,kvm@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm,lkml];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 02E2B15C630
X-Rspamd-Action: no action

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------iM0WWoZER14TV00iL3mHiqfS
Content-Type: multipart/mixed; boundary="------------IF9DvLhbTUfw0F0uwtC2r0ls";
 protected-headers="v1"
From: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 llvm@lists.linux.dev
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 xen-devel@lists.xenproject.org, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Xin Li <xin@zytor.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, andy.cooper@citrix.com
Message-ID: <bae9c067-b5f0-4904-8eab-957ff793e140@suse.com>
Subject: Re: [PATCH v3 00/16] x86/msr: Inline rdmsr/wrmsr instructions
References: <20260218082133.400602-1-jgross@suse.com>
 <3D1FE2A7-F237-4232-9E39-6AFC75F3A4F0@zytor.com>
In-Reply-To: <3D1FE2A7-F237-4232-9E39-6AFC75F3A4F0@zytor.com>

--------------IF9DvLhbTUfw0F0uwtC2r0ls
Content-Type: multipart/mixed; boundary="------------L0CZrd40rvK39oWo3hvXsB63"

--------------L0CZrd40rvK39oWo3hvXsB63
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTguMDIuMjYgMjE6MzcsIEguIFBldGVyIEFudmluIHdyb3RlOg0KPiBPbiBGZWJydWFy
eSAxOCwgMjAyNiAxMjoyMToxNyBBTSBQU1QsIEp1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNl
LmNvbT4gd3JvdGU6DQo+PiBXaGVuIGJ1aWxkaW5nIGEga2VybmVsIHdpdGggQ09ORklHX1BB
UkFWSVJUX1hYTCB0aGUgcGFyYXZpcnQNCj4+IGluZnJhc3RydWN0dXJlIHdpbGwgYWx3YXlz
IHVzZSBmdW5jdGlvbnMgZm9yIHJlYWRpbmcgb3Igd3JpdGluZyBNU1JzLA0KPj4gZXZlbiB3
aGVuIHJ1bm5pbmcgb24gYmFyZSBtZXRhbC4NCj4+DQo+PiBTd2l0Y2ggdG8gaW5saW5lIFJE
TVNSL1dSTVNSIGluc3RydWN0aW9ucyBpbiB0aGlzIGNhc2UsIHJlZHVjaW5nIHRoZQ0KPj4g
cGFyYXZpcnQgb3ZlcmhlYWQuDQo+Pg0KPj4gVGhlIGZpcnN0IHBhdGNoIGlzIGEgcHJlcmVx
dWlzaXRlIGZpeCBmb3IgYWx0ZXJuYXRpdmUgcGF0Y2hpbmcuIEl0cw0KPj4gaXMgbmVlZGVk
IGR1ZSB0byB0aGUgaW5pdGlhbCBpbmRpcmVjdCBjYWxsIG5lZWRzIHRvIGJlIHBhZGRlZCB3
aXRoDQo+PiBOT1BzIGluIHNvbWUgY2FzZXMgd2l0aCB0aGUgZm9sbG93aW5nIHBhdGNoZXMu
DQo+Pg0KPj4gSW4gb3JkZXIgdG8gbWFrZSB0aGlzIGxlc3MgaW50cnVzaXZlLCBzb21lIGZ1
cnRoZXIgcmVvcmdhbml6YXRpb24gb2YNCj4+IHRoZSBNU1IgYWNjZXNzIGhlbHBlcnMgaXMg
ZG9uZSBpbiB0aGUgcGF0Y2hlcyAxLTYuDQo+Pg0KPj4gVGhlIG5leHQgNCBwYXRjaGVzIGFy
ZSBjb252ZXJ0aW5nIHRoZSBub24tcGFyYXZpcnQgY2FzZSB0byB1c2UgZGlyZWN0DQo+PiBp
bmxpbmluZyBvZiB0aGUgTVNSIGFjY2VzcyBpbnN0cnVjdGlvbnMsIGluY2x1ZGluZyB0aGUg
V1JNU1JOUw0KPj4gaW5zdHJ1Y3Rpb24gYW5kIHRoZSBpbW1lZGlhdGUgdmFyaWFudHMgb2Yg
UkRNU1IgYW5kIFdSTVNSIGlmIHBvc3NpYmxlLg0KPj4NCj4+IFBhdGNoZXMgMTEtMTMgYXJl
IHNvbWUgZnVydGhlciBwcmVwYXJhdGlvbnMgZm9yIG1ha2luZyB0aGUgcmVhbCBzd2l0Y2gN
Cj4+IHRvIGRpcmVjdGx5IHBhdGNoIGluIHRoZSBuYXRpdmUgTVNSIGluc3RydWN0aW9ucyBl
YXNpZXIuDQo+Pg0KPj4gUGF0Y2ggMTQgaXMgc3dpdGNoaW5nIHRoZSBwYXJhdmlydCBNU1Ig
ZnVuY3Rpb24gaW50ZXJmYWNlIGZyb20gbm9ybWFsDQo+PiBjYWxsIEFCSSB0byBvbmUgbW9y
ZSBzaW1pbGFyIHRvIHRoZSBuYXRpdmUgTVNSIGluc3RydWN0aW9ucy4NCj4+DQo+PiBQYXRj
aCAxNSBpcyBhIGxpdHRsZSBjbGVhbnVwIHBhdGNoLg0KPj4NCj4+IFBhdGNoIDE2IGlzIHRo
ZSBmaW5hbCBzdGVwIGZvciBwYXRjaGluZyBpbiB0aGUgbmF0aXZlIE1TUiBpbnN0cnVjdGlv
bnMNCj4+IHdoZW4gbm90IHJ1bm5pbmcgYXMgYSBYZW4gUFYgZ3Vlc3QuDQo+Pg0KPj4gVGhp
cyBzZXJpZXMgaGFzIGJlZW4gdGVzdGVkIHRvIHdvcmsgd2l0aCBYZW4gUFYgYW5kIG9uIGJh
cmUgbWV0YWwuDQo+Pg0KPj4gTm90ZSB0aGF0IHRoZXJlIGlzIG1vcmUgcm9vbSBmb3IgaW1w
cm92ZW1lbnQuIFRoaXMgc2VyaWVzIGlzIHNlbnQgb3V0DQo+PiB0byBnZXQgYSBmaXJzdCBp
bXByZXNzaW9uIGhvdyB0aGUgY29kZSB3aWxsIGJhc2ljYWxseSBsb29rIGxpa2UuDQo+IA0K
PiBEb2VzIHRoYXQgbWVhbiB5b3UgYXJlIGNvbnNpZGVyaW5nIHRoaXMgcGF0Y2hzZXQgYW4g
UkZDPyBJZiBzbywgeW91IHNob3VsZCBwdXQgdGhhdCBpbiB0aGUgc3ViamVjdCBoZWFkZXIu
DQoNCkl0IGlzIG9uZSBwb3NzaWJsZSBzb2x1dGlvbi4NCg0KPiANCj4+IFJpZ2h0IG5vdyB0
aGUgc2FtZSBwcm9ibGVtIGlzIHNvbHZlZCBkaWZmZXJlbnRseSBmb3IgdGhlIHBhcmF2aXJ0
IGFuZA0KPj4gdGhlIG5vbi1wYXJhdmlydCBjYXNlcy4gSW4gY2FzZSB0aGlzIGlzIG5vdCBk
ZXNpcmVkLCB0aGVyZSBhcmUgdHdvDQo+PiBwb3NzaWJpbGl0aWVzIHRvIG1lcmdlIHRoZSB0
d28gaW1wbGVtZW50YXRpb25zLiBCb3RoIHNvbHV0aW9ucyBoYXZlDQo+PiB0aGUgY29tbW9u
IGlkZWEgdG8gaGF2ZSByYXRoZXIgc2ltaWxhciBjb2RlIGZvciBwYXJhdmlydCBhbmQNCj4+
IG5vbi1wYXJhdmlydCB2YXJpYW50cywgYnV0IGp1c3QgdXNlIGEgZGlmZmVyZW50IG1haW4g
bWFjcm8gZm9yDQo+PiBnZW5lcmF0aW5nIHRoZSByZXNwZWN0aXZlIGNvZGUuIEZvciBtYWtp
bmcgdGhlIGNvZGUgb2YgYm90aCBwb3NzaWJsZQ0KPj4gc2NlbmFyaW9zIG1vcmUgc2ltaWxh
ciwgdGhlIGZvbGxvd2luZyB2YXJpYW50cyBhcmUgcG9zc2libGU6DQo+Pg0KPj4gMS4gUmVt
b3ZlIHRoZSBtaWNyby1vcHRpbWl6YXRpb25zIG9mIHRoZSBub24tcGFyYXZpcnQgY2FzZSwg
bWFraW5nDQo+PiAgICBpdCBzaW1pbGFyIHRvIHRoZSBwYXJhdmlydCBjb2RlIGluIG15IHNl
cmllcy4gVGhpcyBoYXMgdGhlDQo+PiAgICBhZHZhbnRhZ2Ugb2YgYmVpbmcgbW9yZSBzaW1w
bGUsIGJ1dCBtaWdodCBoYXZlIGEgdmVyeSBzbWFsbA0KPj4gICAgbmVnYXRpdmUgcGVyZm9y
bWFuY2UgaW1wYWN0IChwcm9iYWJseSBub3QgcmVhbGx5IGRldGVjdGFibGUpLg0KPj4NCj4+
IDIuIEFkZCB0aGUgc2FtZSBtaWNyby1vcHRpbWl6YXRpb25zIHRvIHRoZSBwYXJhdmlydCBj
YXNlLCByZXF1aXJpbmcNCj4+ICAgIHRvIGVuaGFuY2UgcGFyYXZpcnQgcGF0Y2hpbmcgdG8g
c3VwcG9ydCBhIHRvIGJlIHBhdGNoZWQgaW5kaXJlY3QNCj4+ICAgIGNhbGwgaW4gdGhlIG1p
ZGRsZSBvZiB0aGUgaW5pdGlhbCBjb2RlIHNuaXBwbGV0Lg0KPj4NCj4+IEluIGJvdGggY2Fz
ZXMgdGhlIG5hdGl2ZSBNU1IgZnVuY3Rpb24gdmFyaWFudHMgd291bGQgbm8gbG9uZ2VyIGJl
DQo+PiB1c2FibGUgaW4gdGhlIHBhcmF2aXJ0IGNhc2UsIGJ1dCB0aGlzIHdvdWxkIG1vc3Rs
eSBhZmZlY3QgWGVuLCBhcyBpdA0KPj4gd291bGQgbmVlZCB0byBvcGVuIGNvZGUgdGhlIFdS
TVNSL1JETVNSIGluc3RydWN0aW9ucyB0byBiZSB1c2VkDQo+PiBpbnN0ZWFkIHRoZSBuYXRp
dmVfKm1zciooKSBmdW5jdGlvbnMuDQo+Pg0KPj4gQ2hhbmdlcyBzaW5jZSBWMjoNCj4+IC0g
c3dpdGNoIGJhY2sgdG8gdGhlIHBhcmF2aXJ0IGFwcHJvYWNoDQo+Pg0KPj4gQ2hhbmdlcyBz
aW5jZSBWMToNCj4+IC0gVXNlIFhpbiBMaSdzIGFwcHJvYWNoIGZvciBpbmxpbmluZw0KPj4g
LSBTZXZlcmFsIG5ldyBwYXRjaGVzDQo+Pg0KPj4gSnVlcmdlbiBHcm9zcyAoMTYpOg0KPj4g
ICB4ODYvYWx0ZXJuYXRpdmU6IFN1cHBvcnQgYWx0X3JlcGxhY2VfY2FsbCgpIHdpdGggaW5z
dHJ1Y3Rpb25zIGFmdGVyDQo+PiAgICAgY2FsbA0KPj4gICBjb2NvL3RkeDogUmVuYW1lIE1T
UiBhY2Nlc3MgaGVscGVycw0KPj4gICB4ODYvc2V2OiBSZXBsYWNlIGNhbGwgb2YgbmF0aXZl
X3dybXNyKCkgd2l0aCBuYXRpdmVfd3Jtc3JxKCkNCj4+ICAgS1ZNOiB4ODY6IFJlbW92ZSB0
aGUgS1ZNIHByaXZhdGUgcmVhZF9tc3IoKSBmdW5jdGlvbg0KPj4gICB4ODYvbXNyOiBNaW5p
bWl6ZSB1c2FnZSBvZiBuYXRpdmVfKigpIG1zciBhY2Nlc3MgZnVuY3Rpb25zDQo+PiAgIHg4
Ni9tc3I6IE1vdmUgTVNSIHRyYWNlIGNhbGxzIG9uZSBmdW5jdGlvbiBsZXZlbCB1cA0KPj4g
ICB4ODYvb3Bjb2RlOiBBZGQgaW1tZWRpYXRlIGZvcm0gTVNSIGluc3RydWN0aW9ucw0KPj4g
ICB4ODYvZXh0YWJsZTogQWRkIHN1cHBvcnQgZm9yIGltbWVkaWF0ZSBmb3JtIE1TUiBpbnN0
cnVjdGlvbnMNCj4+ICAgeDg2L21zcjogVXNlIHRoZSBhbHRlcm5hdGl2ZXMgbWVjaGFuaXNt
IGZvciBXUk1TUg0KPj4gICB4ODYvbXNyOiBVc2UgdGhlIGFsdGVybmF0aXZlcyBtZWNoYW5p
c20gZm9yIFJETVNSDQo+PiAgIHg4Ni9hbHRlcm5hdGl2ZXM6IEFkZCBBTFRFUk5BVElWRV80
KCkNCj4+ICAgeDg2L3BhcmF2aXJ0OiBTcGxpdCBvZmYgTVNSIHJlbGF0ZWQgaG9va3MgaW50
byBuZXcgaGVhZGVyDQo+PiAgIHg4Ni9wYXJhdmlydDogUHJlcGFyZSBzdXBwb3J0IG9mIE1T
UiBpbnN0cnVjdGlvbiBpbnRlcmZhY2VzDQo+PiAgIHg4Ni9wYXJhdmlydDogU3dpdGNoIE1T
UiBhY2Nlc3MgcHZfb3BzIGZ1bmN0aW9ucyB0byBpbnN0cnVjdGlvbg0KPj4gICAgIGludGVy
ZmFjZXMNCj4+ICAgeDg2L21zcjogUmVkdWNlIG51bWJlciBvZiBsb3cgbGV2ZWwgTVNSIGFj
Y2VzcyBoZWxwZXJzDQo+PiAgIHg4Ni9wYXJhdmlydDogVXNlIGFsdGVybmF0aXZlcyBmb3Ig
TVNSIGFjY2VzcyB3aXRoIHBhcmF2aXJ0DQo+Pg0KPj4gYXJjaC94ODYvY29jby9zZXYvaW50
ZXJuYWwuaCAgICAgICAgICAgICAgfCAgIDcgKy0NCj4+IGFyY2gveDg2L2NvY28vdGR4L3Rk
eC5jICAgICAgICAgICAgICAgICAgIHwgICA4ICstDQo+PiBhcmNoL3g4Ni9oeXBlcnYvaXZt
LmMgICAgICAgICAgICAgICAgICAgICB8ICAgMiArLQ0KPj4gYXJjaC94ODYvaW5jbHVkZS9h
c20vYWx0ZXJuYXRpdmUuaCAgICAgICAgfCAgIDYgKw0KPj4gYXJjaC94ODYvaW5jbHVkZS9h
c20vZnJlZC5oICAgICAgICAgICAgICAgfCAgIDIgKy0NCj4+IGFyY2gveDg2L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmggICAgICAgICAgIHwgIDEwIC0NCj4+IGFyY2gveDg2L2luY2x1ZGUv
YXNtL21zci5oICAgICAgICAgICAgICAgIHwgMzQ1ICsrKysrKysrKysrKysrKystLS0tLS0N
Cj4+IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LW1zci5oICAgICAgIHwgMTQ4ICsr
KysrKysrKysNCj4+IGFyY2gveDg2L2luY2x1ZGUvYXNtL3BhcmF2aXJ0LmggICAgICAgICAg
IHwgIDY3IC0tLS0tDQo+PiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9wYXJhdmlydF90eXBlcy5o
ICAgICB8ICA1NyArKy0tDQo+PiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9xc3BpbmxvY2tfcGFy
YXZpcnQuaCB8ICAgNCArLQ0KPj4gYXJjaC94ODYva2VybmVsL2FsdGVybmF0aXZlLmMgICAg
ICAgICAgICAgfCAgIDUgKy0NCj4+IGFyY2gveDg2L2tlcm5lbC9jcHUvbXNoeXBlcnYuYyAg
ICAgICAgICAgIHwgICA3ICstDQo+PiBhcmNoL3g4Ni9rZXJuZWwva3ZtY2xvY2suYyAgICAg
ICAgICAgICAgICB8ICAgMiArLQ0KPj4gYXJjaC94ODYva2VybmVsL3BhcmF2aXJ0LmMgICAg
ICAgICAgICAgICAgfCAgNDIgKystDQo+PiBhcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jICAgICAg
ICAgICAgICAgICAgICB8ICAxNiArLQ0KPj4gYXJjaC94ODYva3ZtL3ZteC90ZHguYyAgICAg
ICAgICAgICAgICAgICAgfCAgIDIgKy0NCj4+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgICAg
ICAgICAgICAgICAgICAgIHwgICA4ICstDQo+PiBhcmNoL3g4Ni9saWIveDg2LW9wY29kZS1t
YXAudHh0ICAgICAgICAgICB8ICAgNSArLQ0KPj4gYXJjaC94ODYvbW0vZXh0YWJsZS5jICAg
ICAgICAgICAgICAgICAgICAgfCAgMzUgKystDQo+PiBhcmNoL3g4Ni94ZW4vZW5saWdodGVu
X3B2LmMgICAgICAgICAgICAgICB8ICA1MiArKystDQo+PiBhcmNoL3g4Ni94ZW4vcG11LmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgNCArLQ0KPj4gdG9vbHMvYXJjaC94ODYvbGli
L3g4Ni1vcGNvZGUtbWFwLnR4dCAgICAgfCAgIDUgKy0NCj4+IHRvb2xzL29ianRvb2wvY2hl
Y2suYyAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4+IDI0IGZpbGVzIGNoYW5nZWQs
IDU3NiBpbnNlcnRpb25zKCspLCAyNjQgZGVsZXRpb25zKC0pDQo+PiBjcmVhdGUgbW9kZSAx
MDA2NDQgYXJjaC94ODYvaW5jbHVkZS9hc20vcGFyYXZpcnQtbXNyLmgNCj4+DQo+IA0KPiBD
b3VsZCB5b3UgY2xhcmlmeSAqb24gdGhlIGhpZ2ggZGVzaWduIGxldmVsKiB3aGF0ICJnbyBi
YWNrIHRvIHRoZSBwYXJhdmlydCBhcHByb2FjaCIgbWVhbnMsIGFuZCB0aGUgbW90aXZhdGlv
biBmb3IgdGhhdD8NCg0KVGhpcyBpcyByZWxhdGVkIHRvIFYyIG9mIHRoaXMgc2VyaWVzLCB3
aGVyZSBJIHVzZWQgYSBzdGF0aWMgYnJhbmNoIGZvcg0Kc3BlY2lhbCBjYXNpbmcgWGVuIFBW
Lg0KDQpQZXRlciBaaWpsc3RyYSBjb21tZW50ZWQgb24gdGhhdCBhc2tpbmcgdG8gdHJ5IGhh
cmRlciB1c2luZyB0aGUgcHZfb3BzDQpob29rcyBmb3IgWGVuIFBWLCB0b28uDQoNCj4gTm90
ZSB0aGF0IGZvciBYZW4gKm1vc3QqIE1TUnMgZmFsbCBpbiBvbmUgb2YgdHdvIGNhdGVnb3Jp
ZXM6IHRob3NlIHRoYXQgYXJlIGRyb3BwZWQgZW50aXJlbHkgYW5kIHRob3NlIHRoYXQgYXJl
IGp1c3QgcGFzc2VkIHN0cmFpZ2h0IG9uIHRvIHRoZSBoYXJkd2FyZS4NCj4gDQo+IEkgZG9u
J3Qga25vdyBpZiBhbnlvbmUgY2FyZXMgYWJvdXQgb3B0aW1pemluZyBQViBYZW4gYW55bW9y
ZSwgYnV0IGF0IGxlYXN0IGluIHRoZW9yeSBYZW4gY2FuIHVuLXBhcmF2aXJ0dWFsaXplIG1v
c3Qgc2l0ZXMuDQoNClRoZSBwcm9ibGVtIHdpdGggdGhhdCBpcywgdGhhdCB0aGlzIHdvdWxk
IG5lZWQgdG8gYmUgdGFrZW4gY2FyZSBhdCB0aGUNCmNhbGxlcnMnIHNpdGVzLCAicG9pc29u
aW5nIiBhIGxvdCBvZiBjb2RlIHdpdGggWGVuIHNwZWNpZmljIHBhdGhzLiBPciB3ZSdkDQpu
ZWVkIHRvIHVzZSB0aGUgbmF0aXZlIHZhcmlhbnRzIGV4cGxpY2l0bHkgYXQgYWxsIHBsYWNl
cyB3aGVyZSBYZW4gUFYNCndvdWxkIGp1c3QgdXNlIHRoZSBNU1IgaW5zdHJ1Y3Rpb25zIGl0
c2VsZi4gQnV0IHBsZWFzZSBiZSBhd2FyZSwgdGhhdA0KdGhlcmUgYXJlIHBsYW5zIHRvIGlu
dHJvZHVjZSBhIGh5cGVyY2FsbCBmb3IgWGVuIHRvIHNwZWVkIHVwIE1TUiBhY2Nlc3NlcywN
CndoaWNoIHdvdWxkIHJlZHVjZSB0aGUgInBhc3NlZCB0aHJvdWdoIHRvIGhhcmR3YXJlIiBj
YXNlcyB0byAwLg0KDQoNCkp1ZXJnZW4NCg==
--------------L0CZrd40rvK39oWo3hvXsB63
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

--------------L0CZrd40rvK39oWo3hvXsB63--

--------------IF9DvLhbTUfw0F0uwtC2r0ls--

--------------iM0WWoZER14TV00iL3mHiqfS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmmWrZ8FAwAAAAAACgkQsN6d1ii/Ey/x
Vgf9GNkMNv8ezbKDeFj0xYtdTYX2S1GrlV6rXyDgpg0M3mQBgVE2yh1rPyeRxG/Xow7fPeYvu6Wn
y/MUTm8BSevH+TFzFX0qZbm+rGfMWRK5DZj2aPhkz80vuJcYKKtsP7sG7M8gQAuIVKh0P7gam8WR
pJslPMIXDntG506kNq81nKET47SGPEmliUdFgY47kZv3Rky/F7Tx3J59kMA2GxYtkwLa+w4Pvn5V
qOo1fuHYjajMFU++hpm2fwPX/2X4mSDKJJEGkRkGtgdeWGMEahC6b4xFO8TCSVvwvl4sHRIDFCi3
aYWk5cPP1n6YQAYY9zjTRr7ywnjTWf06N9g2Kys27g==
=8M17
-----END PGP SIGNATURE-----

--------------iM0WWoZER14TV00iL3mHiqfS--

