Return-Path: <kvm+bounces-4155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E291180E5A6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 09:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86D991F2182E
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:13:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1425E18C2E;
	Tue, 12 Dec 2023 08:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="BA78m/qd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951E8C2
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:13:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1d06fffdb65so30909525ad.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 00:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1702368811; x=1702973611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aWeXIAcPVQudRWVNMCBKAFyfnETiLoRy/MoLakk4Nn4=;
        b=BA78m/qdFvbd7APVeeSrToBcEOT+Ux9ShTpS8RT9qYpY4Y5OpXBlMpomJDM/VW/Szq
         /tnQlNgZecNiBNTrYqEzUX3XWbp8ouwCZreXgSH35tasnPxmWrJ0eO++Ghkh9nrfTMhi
         BUVmpOvRvHlrjqb4S7UOgnm95WKEx0Qw1fLjWHA0K/8keWeFRCkOKENWu/SyaH7xXi/G
         7861V/4Ccl5NqVied70sNy1IGV69YicSd9Jpg2crfho3In9P+uH7OEL1jrRYceU8eNyP
         Bezfsd02ND6fK5OS52aTFH+nZSSVWwoZlnZIs5lMeOMfE28nAsdxWwl/FMZsx/8S/53H
         fDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702368811; x=1702973611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aWeXIAcPVQudRWVNMCBKAFyfnETiLoRy/MoLakk4Nn4=;
        b=hcTHpITFJYD64GfR88YD7oqUSXKpoBISMdWRNDNaRhqcUUT0rNZhuXqZ8ggtS44eMG
         1ifyQXqBLnPNkPJf+312mxG1GY53/cZ8695XoayC2ugrQEUtTn1L0Y6BUn/5a7NEMXUU
         irdIOg3ZbrFq3VOIEFS66r9qg4/AO3qkS6hk029pWwG1qTTAgMoWhiPQmzdp3syX/HZ9
         65+V12HdkiwpVnqSu6d+Vt8uqeUVq89XtVdrFqmuD5lpgO/ckA/amrjc3elayx9vY4Cn
         knzJpexksj+D+TPoB7Cv+GPISmduVuUxMdqRz+a4kdU5X+9PNnVp2kXFp+NgwN8POdwV
         k5wA==
X-Gm-Message-State: AOJu0YygLT3rkaC/LpTlGxKV70SdoyVJr3BeVDHCTpdMeMuy86oH8r4d
	/+Q9sRLfNY5GBEU8k/tPM0gVsQ==
X-Google-Smtp-Source: AGHT+IFvUmziIWBs1OJTpYO7C68nwt4JBi4XL8fGer5kyd+qMcd75C6AEDDD+1T+2txWVzO/tVeY5A==
X-Received: by 2002:a17:902:650e:b0:1d3:34cb:231a with SMTP id b14-20020a170902650e00b001d334cb231amr377063plk.70.1702368811100;
        Tue, 12 Dec 2023 00:13:31 -0800 (PST)
Received: from [157.82.205.15] ([157.82.205.15])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b001cfcf3dd317sm7999185plc.61.2023.12.12.00.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Dec 2023 00:13:30 -0800 (PST)
Message-ID: <85f0bd13-9fe3-420d-939f-695955427f5a@daynix.com>
Date: Tue, 12 Dec 2023 17:13:26 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] testa/avocado: test_arm_emcraft_sf2: handle RW
 requirements for asset
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-8-crosa@redhat.com>
 <5377419a-88dd-4e5c-8be4-1345f6c2115b@linaro.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <5377419a-88dd-4e5c-8be4-1345f6c2115b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2023/12/12 1:36, Philippe Mathieu-Daudé wrote:
> On 8/12/23 20:09, Cleber Rosa wrote:
>> The asset used in the mentioned test gets truncated before it's used
>> in the test.  This means that the file gets modified, and thus the
>> asset's expected hash doesn't match anymore.  This causes cache misses
>> and re-downloads every time the test is re-run.
>>
>> Let's make a copy of the asset so that the one in the cache is
>> preserved and the cache sees a hit on re-runs.
>>
>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>> ---
>>   tests/avocado/boot_linux_console.py | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tests/avocado/boot_linux_console.py 
>> b/tests/avocado/boot_linux_console.py
>> index f5c5d647a4..e2e928e703 100644
>> --- a/tests/avocado/boot_linux_console.py
>> +++ b/tests/avocado/boot_linux_console.py
>> @@ -414,14 +414,16 @@ def test_arm_emcraft_sf2(self):
>>                      'fe371d32e50ca682391e1e70ab98c2942aeffb01/spi.bin')
>>           spi_hash = '65523a1835949b6f4553be96dec1b6a38fb05501'
>>           spi_path = self.fetch_asset(spi_url, asset_hash=spi_hash)
>> +        spi_path_rw = os.path.join(self.workdir, 
>> os.path.basename(spi_path))
>> +        shutil.copy(spi_path, spi_path_rw)
> 
> This is an implementation detail. By default fetch_asset() should return
> a path to a read-only artifact. We should extend it to optionally return
> a writable file path, with the possibility to provide a dir/path.

Apparently it is not OK to abstract fetch_asset() away; it confuses some 
static analysis according to:
"[PATCH 02/10] tests/avocado: mips: add hint for fetchasset plugin"

That said, it is still nice to have a method that does os.path.join() 
and shutil.copy().

