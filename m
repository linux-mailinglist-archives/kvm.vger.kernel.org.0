Return-Path: <kvm+bounces-29434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDAC9AB7A6
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6F7C1F23746
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 20:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D911CC15A;
	Tue, 22 Oct 2024 20:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q74WEgaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4081CBE94
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 20:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729629176; cv=none; b=taaa2uDFgeyBSKkL/Pf8Mpee9gkZy0g7+PmzlwUhL9YRu1Sq56Py0uvBdGFoBbq2xxTGdwmoD5hcutBjcx3sCWmMGTXshi4CqIoL0vffeVTKbcm12hOXG1SWGPW9MaJqmmsddVLHnQUNo+WWMOG7BzW369mJFXUXOAzxsOFy/SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729629176; c=relaxed/simple;
	bh=22iDYg801c8q/L8h63/ZCoe5iOUGaky+8DT+5jhBm58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4lcgaElhgnRxInstAMwjAajwrjX9HojvMEsrKdGvAd6jwg4wWvFUYWFSAyCImUzYhcwf3IhVYn+JCdLnTFfxtJv1Iep30F+VmcRm4K8gKF6z0scnatM8i8OeLoiiPGXbiA9F89IdKygjqwbnVuDdWOvQ350o256BWPfsVPTq8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q74WEgaw; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20ca388d242so43334865ad.2
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 13:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729629174; x=1730233974; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=22iDYg801c8q/L8h63/ZCoe5iOUGaky+8DT+5jhBm58=;
        b=q74WEgaw7EgVebQw5opxn8WdaXOlm9OJIm0oS0zhdq3+8ofE4/ZCYIF2ET2SybOGPB
         39m0BrUsKxHiIg+WsS3/TI3TApkZjHg2C+SazFv8ARhA/RyWiMFiWUcp1D01ig8/4xr+
         uysUjyMbIOM7Q+SVuoWiRxCSRCc6UrQwq87NMjZt9jyAdJZSjP2OJdmvhQ5lZEvPWSVp
         gOurR0WvgJQ+x5yPUSHWZf9m6mMEc6qLRaDyXp66QIC/ytzMfROHVDSAhsZRJEr5b9TN
         N2TYI49Pm0hT9adosM3Rp77sSWdqzFsF9AmFPGK2/cLjqVZoGGghrheHTjRgw4W/PFBX
         qahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729629174; x=1730233974;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=22iDYg801c8q/L8h63/ZCoe5iOUGaky+8DT+5jhBm58=;
        b=jAwFWSTbQ/85YU/tWKzE8jsHTJrCmmcfOYBc2fmq+NorxMbqID+z6Ogc5aeIl90zYF
         Rfnlqqfpm4H9vC4bRSmcxPYlMskPIyOFZDAuDrIJdPkPGQ/jFPJ6F0NzgJ9gQFzHcI1M
         VpIoLLaSWa7KQQ7lC4YhFmfAcCWacVK4zauEfGKl9Qg2ScJjl+z2RQHJ9zSV3OCqJcDA
         F1LxNv/VARlnjewnXzDyc/aWNfQ+wFnTW1dgIU5kEn8YlI6kx/VgC6aKAoYBWFd5WFQA
         wp2QLGGOEP5B7jJLsOSJhlrAHrikrc4uJaM3EmH+DjBSd+SsC0tUtM5XpB4DeUQ58efg
         qH5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVR+uv1E0nHqqYT6d0zYpK6/WORC2HH2VoX+B2gHGKsuKUTmZlLFbSj9nJV3umA9kxQgQg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjZKAUMoEz41aADXJLi/CeZ5HphlnFD5l2izzDThC6QGnxLgjG
	qgvmPKoEs3h/UJGX7tS9AeUpji0cbjomnP8Ro2vEdxaw8uN5YJywY33qqnJi68I=
X-Google-Smtp-Source: AGHT+IFaD76bQqjYlx7C1qxfp6VbhP5GE48tnyBe+LWy7d4tLOyRp3pZwxtrqk+0RelB7tsR0TfiQA==
X-Received: by 2002:a17:902:d2c6:b0:20b:6f04:486a with SMTP id d9443c01a7336-20fa9e785a8mr5423175ad.35.1729629173598;
        Tue, 22 Oct 2024 13:32:53 -0700 (PDT)
Received: from [192.168.1.67] (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bd42asm46422095ad.165.2024.10.22.13.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 13:32:53 -0700 (PDT)
Message-ID: <fdea845b-d38a-4cd8-b87f-098dd7a7adbb@linaro.org>
Date: Tue, 22 Oct 2024 13:32:52 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/20] scripts/ci: remove architecture checks for
 build-environment updates
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, Laurent Vivier <laurent@vivier.eu>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, Yanan Wang <wangyanan55@huawei.com>,
 Thomas Huth <thuth@redhat.com>, John Snow <jsnow@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 devel@lists.libvirt.org, Cleber Rosa <crosa@redhat.com>,
 kvm@vger.kernel.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Alexandre Iooss <erdnaxe@crans.org>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Riku Voipio <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
 <20241022105614.839199-7-alex.bennee@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20241022105614.839199-7-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjIvMjQgMDM6NTYsIEFsZXggQmVubsOpZSB3cm90ZToNCj4gV2Ugd2VyZSBtaXNz
aW5nIHMzOTB4IGhlcmUuIFRoZXJlIGlzbid0IG11Y2ggcG9pbnQgdGVzdGluZyBmb3IgdGhl
DQo+IGFyY2hpdGVjdHVyZSBoZXJlIGFzIHdlIHdpbGwgZmFpbCBhbnl3YXkgaWYgdGhlIGFw
cHJvcHJpYXRlIHBhY2thZ2UNCj4gbGlzdCBpcyBtaXNzaW5nLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPg0KPiAtLS0NCj4g
ICBzY3JpcHRzL2NpL3NldHVwL3VidW50dS9idWlsZC1lbnZpcm9ubWVudC55bWwgfCAyIC0t
DQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvc2NyaXB0cy9jaS9zZXR1cC91YnVudHUvYnVpbGQtZW52aXJvbm1lbnQueW1sIGIvc2Ny
aXB0cy9jaS9zZXR1cC91YnVudHUvYnVpbGQtZW52aXJvbm1lbnQueW1sDQo+IGluZGV4IGVk
ZjE5MDBiM2UuLjU2YjUxNjA5ZTMgMTAwNjQ0DQo+IC0tLSBhL3NjcmlwdHMvY2kvc2V0dXAv
dWJ1bnR1L2J1aWxkLWVudmlyb25tZW50LnltbA0KPiArKysgYi9zY3JpcHRzL2NpL3NldHVw
L3VidW50dS9idWlsZC1lbnZpcm9ubWVudC55bWwNCj4gQEAgLTM5LDcgKzM5LDYgQEANCj4g
ICAgICAgICB3aGVuOg0KPiAgICAgICAgICAgLSBhbnNpYmxlX2ZhY3RzWydkaXN0cmlidXRp
b24nXSA9PSAnVWJ1bnR1Jw0KPiAgICAgICAgICAgLSBhbnNpYmxlX2ZhY3RzWydkaXN0cmli
dXRpb25fdmVyc2lvbiddID09ICcyMi4wNCcNCj4gLSAgICAgICAgLSBhbnNpYmxlX2ZhY3Rz
WydhcmNoaXRlY3R1cmUnXSA9PSAnYWFyY2g2NCcgb3IgYW5zaWJsZV9mYWN0c1snYXJjaGl0
ZWN0dXJlJ10gPT0gJ3g4Nl82NCcNCj4gICANCj4gICAgICAgLSBuYW1lOiBJbnN0YWxsIHBh
Y2thZ2VzIGZvciBRRU1VIG9uIFVidW50dSAyMi4wNA0KPiAgICAgICAgIHBhY2thZ2U6DQo+
IEBAIC00Nyw3ICs0Niw2IEBADQo+ICAgICAgICAgd2hlbjoNCj4gICAgICAgICAgIC0gYW5z
aWJsZV9mYWN0c1snZGlzdHJpYnV0aW9uJ10gPT0gJ1VidW50dScNCj4gICAgICAgICAgIC0g
YW5zaWJsZV9mYWN0c1snZGlzdHJpYnV0aW9uX3ZlcnNpb24nXSA9PSAnMjIuMDQnDQo+IC0g
ICAgICAgIC0gYW5zaWJsZV9mYWN0c1snYXJjaGl0ZWN0dXJlJ10gPT0gJ2FhcmNoNjQnIG9y
IGFuc2libGVfZmFjdHNbJ2FyY2hpdGVjdHVyZSddID09ICd4ODZfNjQnDQo+ICAgDQo+ICAg
ICAgIC0gbmFtZTogSW5zdGFsbCBhcm1oZiBjcm9zcy1jb21waWxlIHBhY2thZ2VzIHRvIGJ1
aWxkIFFFTVUgb24gQUFyY2g2NCBVYnVudHUgMjIuMDQNCj4gICAgICAgICBwYWNrYWdlOg0K
DQpSZXZpZXdlZC1ieTogUGllcnJpY2sgQm91dmllciA8cGllcnJpY2suYm91dmllckBsaW5h
cm8ub3JnPg0K

