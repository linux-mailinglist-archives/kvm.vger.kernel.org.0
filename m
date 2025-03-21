Return-Path: <kvm+bounces-41721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ACD9A6C3FC
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD59A467C69
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8491C22FF2D;
	Fri, 21 Mar 2025 20:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OC2onSFi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C19A13774D
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742587900; cv=none; b=tkCgzkpvA9vPk+clW6rVJERlH1I2fBWEMZB2JFgfn1uk251sL66Xl1Wh3/nOqdFiwTx4wVFIYwIAlNuJqy1CGzXCjrjT3c22TY5UT7OJEJmnS7rLDyOS17hjN5ekfkhQ1DvsppNLVE80lJ+VFHdl+r1sCvZZGaRMy+1anYhRC6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742587900; c=relaxed/simple;
	bh=6T+1x5xOuQ2yJ3mt19MuTaHImZYpr22igEe7u5TyWMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uCqGbhphIZ2OTwcFm2CkmqRG8nsPbP1Iy1CtaXLhO3A8fvrag2NjcxEL8BGwZONcKZzpsi/e9gTf79EZ037bpBH3PzLDGIS48WsfbQv3wUhQARfWyKZijluxIkJKRpHWPJWbMV62S3XEa3fErifwgHohu/13v14VW/CtqJKWAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OC2onSFi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224171d6826so17369115ad.3
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742587898; x=1743192698; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6T+1x5xOuQ2yJ3mt19MuTaHImZYpr22igEe7u5TyWMg=;
        b=OC2onSFiQxeIafSlvX4Jnwtyhqnpq5guI7xiBZ1vmojEhTYxV1H5tNrIGzVd5H4xvD
         fzGe0hPSAzn9C+Fd02T71ufj/P7uSCp9AALztTxz2mo4pWPgdKOcixbEPPmJG5le3yTR
         W/4BuzZzfoGuhqO/APqjBgYP55FMeTkppbJn+UvFwS2J42kaNSZmpjgkh7W6b0pxVUQN
         YGEoOG+gTkn7toXKJUR6tc7qwxdeoVYQ+DbCYPra13wwa0kaLNmpEkizL4783pfb20tb
         aUwrXb85j6lfodbHjjnWXfFUwFJWXhpujL/XIIrxjRbF88uJ50xPyPZyunFDxR1QLUzW
         //qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742587898; x=1743192698;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6T+1x5xOuQ2yJ3mt19MuTaHImZYpr22igEe7u5TyWMg=;
        b=E5ZVWlIN2tjX8i/7SAFtrKAv2aVvO1DAUnFp4AxttLUCVdaEpSzHHsan5pfEAh3kG1
         IIOpvWDdPpKmidWjzskioAF/7ZcKo29Ieu9csHb6GKs83LbwYIjtsz/q7EEWmtXfaWx+
         IyL+CGIq5/82doHscO0JsgsPQWGmp8SPP4E0Cl1W1y1QvSS98pkzTF9ybiSW0VdwoXIF
         TeBX72ocMuzZH0s5BuLspBGeVeV8MvjfW7oWyF03EtvqSJap+wQIiLiSrbUMHffUNmCQ
         iqgmLkQb3xKjmlbWUQU4JEq/iWM35VkxAQiRxsMo92YPI4BUvdJFTvg3awmK0rsysFtH
         kMUQ==
X-Gm-Message-State: AOJu0YxoQuxBY/lgYzuYR5PHEJcDTSDKfvqxCJGtS96hFQ5TRv86ylSG
	ii2e8f4hGvjUGO0/OFJkT+6urcijMdE1bvyOCVO/iSijR4XfckH1ctoMsNDSols=
X-Gm-Gg: ASbGncuCZ+lCIkK2qphxNZ4BDKXUIe2muzOniWRHBD/9s2cTio003y7KgfU0feBKoD2
	5FtkCEuyQ/u2kHDM+O6wm9WwL+rTt1qsQCL1qwOkXV/ivxsIbqhcf89+Smhz+k41uMLTMmBX9JI
	YJKlgOIb6F11lX7MV9QzeLj0VXLdbkZwBgKdjxkC+CH6dtx5oxrmsWGOU5eTNXOelA+GW7cRF6/
	XrQgHsfijO1kmPzTusOLSJ3nuk4mYdTkZhmiCVVfH5qXvl4j/ubhaFwjFfEA+voxK/qmdQUSVph
	kBDoDqKrK/iatj+Q+QYYLuX3miNS3Gl2R52KAH6/JQ8uCEID+szSB+ZNAYS5fhA/b3CrwA==
X-Google-Smtp-Source: AGHT+IETv1gtDe0Tn14WdsrX20MpKLXdC8E2l3VUaPRnXb98rd0gWl5A1Eo5BTcwdnWAcDxnvNIVCQ==
X-Received: by 2002:a17:903:32c8:b0:224:1609:a74a with SMTP id d9443c01a7336-22780e14a50mr77491965ad.34.1742587898418;
        Fri, 21 Mar 2025 13:11:38 -0700 (PDT)
Received: from [172.16.224.217] ([209.53.90.26])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811da89csm21677065ad.193.2025.03.21.13.11.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:11:37 -0700 (PDT)
Message-ID: <216a39c6-384d-4f9e-b615-05af18c6ef59@linaro.org>
Date: Fri, 21 Mar 2025 13:11:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
 <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
 <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
 <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8yMS8yNSAxMjoyNywgUmljaGFyZCBIZW5kZXJzb24gd3JvdGU6DQo+IE9uIDMvMjEv
MjUgMTE6MDksIFBpZXJyaWNrIEJvdXZpZXIgd3JvdGU6DQo+Pj4gTW1tLCBvayBJIGd1ZXNz
LsKgIFllc3RlcmRheSBJIHdvdWxkIGhhdmUgc3VnZ2VzdGVkIG1lcmdpbmcgdGhpcyB3aXRo
IHBhZ2UtdmFyeS5oLCBidXQNCj4+PiB0b2RheSBJJ20gYWN0aXZlbHkgd29ya2luZyBvbiBt
YWtpbmcgVEFSR0VUX1BBR0VfQklUU19NSU4gYSBnbG9iYWwgY29uc3RhbnQuDQo+Pj4NCj4+
DQo+PiBXaGVuIHlvdSBtZW50aW9uIHRoaXMsIGRvIHlvdSBtZWFuICJjb25zdGFudCBhY2Ny
b3NzIGFsbCBhcmNoaXRlY3R1cmVzIiwgb3IgYSBnbG9iYWwNCj4+IChjb25zdCkgdmFyaWFi
bGUgdnMgaGF2aW5nIGEgZnVuY3Rpb24gY2FsbD8NCj4gVGhlIGZpcnN0IC0tIGNvbnN0YW50
IGFjcm9zcyBhbGwgYXJjaGl0ZWN0dXJlcy4NCj4NCg0KVGhhdCdzIGdyZWF0Lg0KRG9lcyBj
aG9vc2luZyB0aGUgbWluKHNldF9vZihUQVJHRVRfUEFHRV9CSVRTX01JTikpIGlzIHdoYXQg
d2Ugd2FudCANCnRoZXJlLCBvciBpcyB0aGUgYW5zd2VyIG1vcmUgc3VidGxlIHRoYW4gdGhh
dD8NCg0KSSB3ZW50IHRocm91Z2ggdGhhdCBxdWVzdGlvbiwgYW5kIHdhcyBub3Qgc3VyZSB3
aGF0IHNob3VsZCBiZSB0aGUgYW5zd2VyLg0KDQo+IA0KPiByfg0KDQo=

