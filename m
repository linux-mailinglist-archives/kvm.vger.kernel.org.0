Return-Path: <kvm+bounces-6152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E2B82C3E0
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:47:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E006D28618C
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29EC877631;
	Fri, 12 Jan 2024 16:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P34o2gyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51846DD08
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e5701cbbaso18104775e9.0
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 08:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705078012; x=1705682812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGITxN2Vs9jNvuz/cjIb7hgvqAzvNaA/iSybUEu8SrU=;
        b=P34o2gyFOwFTvW1/zNI1LPASNsO6si39bLjlkn2j7QhnukwLMrzepMWwLijGmAFbWo
         rsD/9z/nqJQIbbtoDVJXozUzworkEfBkYNJV1NdnQpBeGqId35loLzkz0w8b1/vU2BkT
         dycRHhg1qj9rRYQnfBARJ6h3ZcfZDh3d/D+Vr65rrb8aBHvHPYC3kQycBTSxuP3ztDeU
         Hr/XyOudydjqETd/N8FQbaypzQo9G42DjJ1tw6LXglxwLPkKAifOeZT5z9tRBgyQpL+h
         g+yYCOxtQyJquoQBXKjQDgF9brM7NXl+6xNLxl6dAdFJESs9YAK1ip0Jw/SPuO8+c0O2
         FkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705078012; x=1705682812;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hGITxN2Vs9jNvuz/cjIb7hgvqAzvNaA/iSybUEu8SrU=;
        b=nekz8uk2/Pa4hxxVbhcQVEDWaT/NrqBhbRYI0Bi6uToj43xHUmWkeg4iPghua0S4sj
         W2PVcH9bodtBuYpOjJ5snhQIaTuE1uhXXaDist1SJh+XwsZUaW1Hro+PbhMoICKalyTJ
         tvMtr+nvkAfF5J+LZ/7r5PCysledmn+QDj/GVCnz8Cxb5isZB9lPwXh9WtGY2SiZ4Auc
         j1T36BwkECDU0nz6WygoyaTWOOGortBlqanwDxx53+NqvlsoYnRD09TnuqM1HkdmDVHA
         xhYkqh1WgMWDlDHfgx6yJRyDbCbP0f/Bu8QV38e5v1Bwdm9ffwuYBaOdmoJ9fuzojNog
         FQpg==
X-Gm-Message-State: AOJu0YyPIKPPH9fBrdwnVevxGrZIpI4mJY1djmIi9y5WyIbiOp9vucuM
	cu3qpB3O1fbo4JahwyjpwpLJBwEoVGFvGQ==
X-Google-Smtp-Source: AGHT+IFwELbfk61GZEWzU7kLkBC5Qu9uzr8sZPwcrTV/vTItwnOvjvYIp2u4iH81EOBpZI6D1/SN6A==
X-Received: by 2002:a7b:c44a:0:b0:40d:5b0d:cebe with SMTP id l10-20020a7bc44a000000b0040d5b0dcebemr880644wmi.39.1705078011910;
        Fri, 12 Jan 2024 08:46:51 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id c11-20020a05600c0a4b00b0040d53588d94sm10357998wmq.46.2024.01.12.08.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 08:46:51 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 3147A5F7A9;
	Fri, 12 Jan 2024 16:46:51 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Thomas Huth <thuth@redhat.com>
Cc: qemu-devel@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,
  qemu-s390x@nongnu.org,  qemu-ppc@nongnu.org,  Richard Henderson
 <richard.henderson@linaro.org>,  Song Gao <gaosong@loongson.cn>,
  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,  David
 Hildenbrand
 <david@redhat.com>,  Aurelien Jarno <aurelien@aurel32.net>,  Yoshinori
 Sato <ysato@users.sourceforge.jp>,  Yanan Wang <wangyanan55@huawei.com>,
  Bin Meng <bin.meng@windriver.com>,  Laurent Vivier <lvivier@redhat.com>,
  Michael Rolnik <mrolnik@gmail.com>,  Alexandre Iooss <erdnaxe@crans.org>,
  David Woodhouse <dwmw2@infradead.org>,  Laurent Vivier
 <laurent@vivier.eu>,  Paolo Bonzini <pbonzini@redhat.com>,  Brian Cain
 <bcain@quicinc.com>,  Daniel Henrique Barboza <danielhb413@gmail.com>,
  Beraldo Leal <bleal@redhat.com>,  Paul Durrant <paul@xen.org>,  Mahmoud
 Mandour <ma.mandourr@gmail.com>,  Liu Zhiwei
 <zhiwei_liu@linux.alibaba.com>,  Cleber Rosa <crosa@redhat.com>,
  kvm@vger.kernel.org,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  qemu-arm@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  John Snow
 <jsnow@redhat.com>,  Daniel
 Henrique Barboza <dbarboza@ventanamicro.com>,  Nicholas Piggin
 <npiggin@gmail.com>,  Palmer Dabbelt <palmer@dabbelt.com>,  Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>,  Ilya Leoshkevich
 <iii@linux.ibm.com>,  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
  "Edgar E.
 Iglesias" <edgar.iglesias@gmail.com>,  Eduardo Habkost
 <eduardo@habkost.net>,  Pierrick Bouvier <pierrick.bouvier@linaro.org>,
  qemu-riscv@nongnu.org,  Alistair Francis <alistair.francis@wdc.com>,
  Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Subject: Re: [PATCH v2 12/43] qtest: bump boot-serial-test timeout to 3 minutes
In-Reply-To: <cf617223-0a0b-4d42-84a3-cd323ea4c421@redhat.com> (Thomas Huth's
	message of "Fri, 12 Jan 2024 16:13:16 +0100")
References: <20240103173349.398526-1-alex.bennee@linaro.org>
	<20240103173349.398526-13-alex.bennee@linaro.org>
	<cf617223-0a0b-4d42-84a3-cd323ea4c421@redhat.com>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Fri, 12 Jan 2024 16:46:51 +0000
Message-ID: <871qamwlc4.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thomas Huth <thuth@redhat.com> writes:

> On 03/01/2024 18.33, Alex Benn=C3=A9e wrote:
>> From: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
>> The boot-serial-test takes about 1 + 1/2 minutes in a --enable-debug
>> build. Bumping to 3 minutes will give more headroom.
>> Signed-off-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> Message-ID: <20230717182859.707658-9-berrange@redhat.com>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> Message-Id: <20231215070357.10888-9-thuth@redhat.com>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>   tests/qtest/meson.build | 1 +
>>   1 file changed, 1 insertion(+)
>> diff --git a/tests/qtest/meson.build b/tests/qtest/meson.build
>> index c7944e8dbe9..dc1e6da5c7b 100644
>> --- a/tests/qtest/meson.build
>> +++ b/tests/qtest/meson.build
>> @@ -6,6 +6,7 @@ slow_qtests =3D {
>>     'test-hmp' : 240,
>>     'pxe-test': 600,
>>     'prom-env-test': 360,
>> +  'boot-serial-test': 180,
>>   }
>>     qtests_generic =3D [
>
> 3 minutes was obviously not enough:
>
>  https://gitlab.com/qemu-project/qemu/-/jobs/5918818492#L4984
>
> And in older runs, we can see that the boot-serial-test might take
> longer than 180s when run with TCI :
>
>  https://gitlab.com/qemu-project/qemu/-/jobs/5890481086#L4772
>
> So I think we should bump the timeout to 240s here. Alex, are you
> going to respin your pull request? If so, could you modify your patch?
> Otherwise I can also send a new version of this patch here, just let
> me know.

I'm travelling now so its tricky to respin. If you could send a new
version that would be great.


>
>  Thomas

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

