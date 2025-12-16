Return-Path: <kvm+bounces-66092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 786B1CC52E8
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 22:10:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BAEC13041E1D
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 21:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFCF30E0F8;
	Tue, 16 Dec 2025 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BgeOt6IC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5231D30BF65
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765919430; cv=none; b=oJj4L7XY0W2DGUoEadk+wKcnSwgfMqSordbsL60ay4poahLSyA/4Sw+FY+3j2tM3lfNLCzA0qvoZcj3aIgfqjDHgZroaWuaLAdqv6ub32FNYmHMl1mziHLKqW9OaopCEJwsxdVK1MPVGxvfHY4ITvADSbJ99Sb/4/skRthQxJDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765919430; c=relaxed/simple;
	bh=hpR6qF9VFNRid5JrHWu/fzfTyYnxtmNW6ePUFmtN8BQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ol2wa6h8Aluw6WLduOOqkAXMSWR1YYV0m4WRbDCkROYHeUkvetpSXZKz1HSJuAk7wtvDVscwrOS8alstUtv9xFfwAvkKHzBUxrbQatchymwZBzCLoAJrzNEjYrnIh4Ssc9bI6ovvITOVcLM2+4sIPt4ZyDwHKCOMrFefz+1k83w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BgeOt6IC; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-7c7533dbd87so4353018a34.2
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 13:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765919428; x=1766524228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Enlbuobe2YRXZgnKXJaZ8w67rnE3bk5N8Rl7TAq3T2c=;
        b=WYJ/PciGZ3NZNvy3OK7BkoH5yXjUlycaMQwHtLiWiBwTyO9hCWR6c7z2KzDd85tR8v
         08OCtf8O34TimbPj5WYeXFEzWciT3+lVBBwePCS/xOOPvSQ5lHmx+hWkEpijBW9BRQpa
         9S/PSI+OPaqYjU+La3WPEqGekm7EMtrnnP1mGm6NEovZU05fCFFBvIxIGpdHS8UzLEpI
         a2P6O84o+/KrI4913iyejAcqdtzD2QdfTdQQiIxxh0F6PpkdajjU2g5bd1tyKgHBQs2Q
         VIFK5DF3i3KONB0sE1TwNll2b/2WUXtmpPflLFklWDQvft4abj/BRdAxpQQRMzGJAnSX
         NL3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjW+BaaMEYppoafA9tWo2isUI5QV0qv5TlQ3d51nvvNzgnbTl570wWtQmQdgxF6qy3xc8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/515mfHTpIOJsEXXfTkdGu/5tEXY55Utl4K+UA4tSN97SOd7n
	e9GOOMmAaTn3m2FVv0FmKDn5fkZjS7Z4xVM2sJ9jnj/DTlLI2vHC1wWIWF17KKNtHkmywwKdVXR
	0sB+fUCivP0JVAKJ+e9yoqp5TKqaDoNLWgXUg2YjaYraLJOZw6MLRILaTC60fDa9pmARg/6Mrfj
	AT/WKuy/UZoYDQnVQIRipVthKFTx2bySwcnb+7gvTWIiBKMEHIN/tPTzHUVsdgkfqltP96B2f9D
	trPwH8=
X-Gm-Gg: AY/fxX7kvzgtimKeNIpctjQVGRvrUr5QmylTKzkemStvxexppayuXfrxMjYIzBlYzuD
	xeHdFFovAa2HVUgQcMpvktIM7iTisvKkwHeC7IjzRpyADNwL0wz3RaJTBdMu9hJHMl0S1+HZELv
	6w7YzfY5QTtpgHBbpK0Xqf05mF1dzRtcceIT/WuyLRAkoCOJj1pOCr7ZB+jO7J3CvOFx8H9UcDL
	OYY7JcrrbyT0yF05gGtfKkGG9TvNDNGlR6gRX6AHv5XWeJc5f7XTKMkRYny7YZgRDqGJO48Ia7f
	/Jbzqgn3vJsSjmzgyHwEwWQqvlln0JiKr+TSUAbE59uBCxcfUyFR9bJRSBuaihEmkp3uAeAqWz0
	xdVBNcTVYZtpBcXozMS4kcPWx714YgYjxXJWKFDheGzOaEcE/zAIE1T0vHOQWZH5k8pGEpQ12hh
	DEweGSm3ssYf6rsLoho03ia7f+mHTKj2+2QjIiQtgtAw==
X-Google-Smtp-Source: AGHT+IHevfLDKkjfTRIZzuS1MQ1J0b+fOpyrjxc+Aw8eb4fL4GxwZMDhae4L68y7oBM4LCYlEkU2EjuG3bQT
X-Received: by 2002:a05:6830:411c:b0:7c7:59ce:d195 with SMTP id 46e09a7af769-7cae82cf7a0mr9384661a34.6.1765919428037;
        Tue, 16 Dec 2025 13:10:28 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7cadb328683sm2685811a34.7.2025.12.16.13.10.27
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Dec 2025 13:10:28 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430ffa9fd7fso1250707f8f.0
        for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 13:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1765919426; x=1766524226; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Enlbuobe2YRXZgnKXJaZ8w67rnE3bk5N8Rl7TAq3T2c=;
        b=BgeOt6ICJAk7Iu/f3HD1heZAOzfaaGqjP75YZRFU5tyDaqwE/GvGz2bgQhuPdaEojf
         BRpEmQ9RelwGJvrb7SUKLqMb8mMkpgjHiWPN6rpty4YUMnl2moA+dYJDkOpLVByhUTiy
         /Okk2SKVT5/JpU2X64HSK6vAE12scRQm5j6Qs=
X-Forwarded-Encrypted: i=1; AJvYcCVci5pBWyU93+oQUKvaURaO8UrDiE1s8NoQiw58i3qUvhiJZyJ6L7NptdaclUhYC1vi2Fo=@vger.kernel.org
X-Received: by 2002:a05:6000:2888:b0:430:8583:d196 with SMTP id ffacd0b85a97d-4308583d267mr14143117f8f.33.1765919426272;
        Tue, 16 Dec 2025 13:10:26 -0800 (PST)
X-Received: by 2002:a05:6000:2888:b0:430:8583:d196 with SMTP id
 ffacd0b85a97d-4308583d267mr14143105f8f.33.1765919425911; Tue, 16 Dec 2025
 13:10:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250816101308.2594298-1-dwmw2@infradead.org> <20250816101308.2594298-3-dwmw2@infradead.org>
 <aUHAqVLlIU_OwESM@google.com>
In-Reply-To: <aUHAqVLlIU_OwESM@google.com>
From: Doug Covelli <doug.covelli@broadcom.com>
Date: Tue, 16 Dec 2025 16:10:14 -0500
X-Gm-Features: AQt7F2r92HrLBCP79FAXFFnU4qsClMXYZFhkUewXZgwyZRXw9d-Msf0Dqpabsdc
Message-ID: <CADH9ctCEVJCC+_bZwDETmePhgfVy+jJvSb4Jz6bGLdmL9RSmUA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Provide TSC frequency in "generic"
 timing infomation CPUID leaf
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, graf@amazon.de, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, 
	Colin Percival <cperciva@tarsnap.com>, Zack Rusin <zack.rusin@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000208eca064618285f"

--000000000000208eca064618285f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 3:27=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +Doug and Zach
>
> VMware folks, TL;DR question for you:
>
>   Does VMware report TSC and APIC bus frequency in CPUID 0x40000010.{EAX,=
EBX},
>   or at the very least pinky swear not to use those outputs for anything =
else?

Yes, all 32-bits of 0x40000010.EAX is for TSC frequency and all
32-bits of 0x40000010.EBX is for APIC bus frequency.

Doug

--000000000000208eca064618285f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
g1HGFzyaocs0orxP7LdjhfpP9xT22P+vD0XjJh/FOAonZqTYtSFiamDxH6A4p7pXaHVZA7aX1cD2
RV7UIRe7Q9u1IL3ghbf8XIBU6tQ7lPpCJL/LFRoqK+huPRGTEtABOvxSPj5toZErqlJOsjBlF+fD
SLXZw5r15gNWKbnxkjGP9oPifjCIvzwv8MVqF22Oj0Jg5nsdOzuFk/LzvmIhaRTiV34PcancCYR/
jqEDHU2PsMsxUDgWqokEVvpMosFjILgU4uYQ63sCAwEAAaOCAd0wggHZMA4GA1UdDwEB/wQEAwIF
oDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3Nl
Y3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1Ud
IAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAy
hjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwJAYDVR0R
BB0wG4EZZG91Zy5jb3ZlbGxpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBQAKTaeXHq6D68tUC3boCOFGLCgkjAdBgNVHQ4EFgQU+5ORKbUAznt8VrWqyooawEnk
NeMwDQYJKoZIhvcNAQELBQADggIBALtAxbwVWBUdm0Jni7mpbN8QOQGYvWc2ZIFwALaKk8hroWkA
WstOpjRfnzPUN27GGr1/crviF1084J9wIvJGgu8ZS1h70pEt3glblnV10ZgNqtqOQBrlUj9wN17b
A9o/nqbv1THhNXrTQWHo9UF1tyeLRDNez1IeisX+xYagMowwUzyJL/4st339wDBIfOmHhxDWS7cq
j5zKPKJPA1xu9+2zxb2R6EKpwUJbqQ/b41UBVR2OkJm5yz+9JIpjUH5dJSQhCl05WuIH5AMlkq9l
wxoWtFoN5zqucs2eAYifauF2XAS3lVPVtNhl0HF4L4b44byx0tBiGmxZADWxfXybhhoS3Y+wQmjl
Ica/HH7rNLAPQN+Ll16i03wzxtvO9l5p35SETecjCAu2IUyBomBUz3iTqjBaM8Txkq6Puud9vgfi
yV2JGREJf6qQElUsen5NtZGehxVKshEo83oz5Z9ygeB9e00awWbmSvZfQ/UugoJ4fnYbsxwkd9kt
jcPIdr7bLNJ8KOxF5LBbuesksPqRbW18v8mpMPPRVQ41GdrC/2ZroPX63IlbS798r8UD26zVLPG8
27ddqVnvT+P/BYsyxiHgCn5RRbHhyAhP8RMRIrTIBolRXYLVw7ojeiLQPVW2i1k9Vubz/7h4YRNV
CFkCoyYvV3i7em06oRswDLYEBDOqMYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UE
ChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0Eg
MjAyMwIMEkPb91vwDVY/yg5wMA0GCWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDOjKrJ
iSpxDyQAVDheTq//f2MRIE8rZn7ql/FkGvM+NzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0yNTEyMTYyMTEwMjZaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBFjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCG
SAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAnp6DHpXMdwPaWVgwkJzZygORSa6Jar27y5bVYX6R5
HULYA9Hv6C7MvkznQPv6mvxXaKN40R2zeRTAVXooEUjj/WwWOEmDm0hAizBWWKC8JvXDGdGzuWQZ
h8r2laCWxUckn+WCprLnkv8jCNg3dgK3O/w1y6T5nFkne/qGDU17FRPlPYDdYTikkNW4BoXO5FcN
Z8yee4+RQ6dBSB+BkLOBvzlXLiFFKUP2g8nQaWJA1gWW7BRxYSDPD1Zd4INBCwwa/5/kgJLks27i
I8OheioVZzw0OtN0bcvzL0Xzf52S4WJuQjv9HsOmSyPp6WMsuKsEEwbQZ5GFVKwSHIm961P+
--000000000000208eca064618285f--

