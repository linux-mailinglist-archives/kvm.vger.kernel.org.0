Return-Path: <kvm+bounces-18660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335C48D84CB
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 522DC1C21C6C
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA55A12EBC6;
	Mon,  3 Jun 2024 14:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZoM53N+z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F7A757E0
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 14:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717424403; cv=none; b=GnkFnHDd3JxhmT/OVfZ/6IsJo6VwpP7/WsWYj/ThKpR/cFeUZtiH3lwHclJuo6pElrla6AW0q6RaBlibnRG2SN2/9ZAb1hjWe4QR9DWS/N4zQyJhpqUgNU8LpTF/pnzvXC7wf4Dm+v3rFoVK1ob+u0uY2SOdat2B+Ht+wRXXbZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717424403; c=relaxed/simple;
	bh=YGTEQ6nmz5y0KplpDlBxxuNWRh8CAUPnbwUoc4LIThs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WF//ClIuEc4ER2bxFFz75LOi5xI6MeM7iESw1+IKAieDHeQAlsg2A7CORTOrW3vve0TFZ8FHzrd3OCBV8ySHiV42PXakk2TWB3IeZsT1fbw+DOfBGA3yQjgKa5Esbh2OGnFUafiXiLSm2m4CBU2QR1m/hPK827bXz9Eron/EIwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZoM53N+z; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57a52dfd081so1529544a12.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 07:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717424400; x=1718029200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fcPdkpRWp56Gkr8DQ3RfeedzRUWF4Qj2aToRrp6ZnS0=;
        b=ZoM53N+zUSkYbXOef3N9Bfz754Y9dqoWWiDV9fVrSaIrgE/pjqOKTbVSdRsj+/gCTb
         qVjSHKuznFkNAToLhp6j+VrA0Z5HbM/C5JtNkfQ6AIOliWOh4C0I0J8aDkTXxLb2aObi
         /iw4jICSYOpDqdtcVXPao2mkJAzbuLMmQdb3U6ssdPj8T7y36VsTHsLtIcv3hULbp5f4
         T4wzIvH7XvxWzw8MkLsN8E4QspopSe//84Gvbja06Iv5h/9sqwNFuVMahp0C3e69ATve
         gWPpDRJhZUndh5jON4RlYGo97BQFoAIQYNaxDnR0j6q7C2EdevYNumnCePOYqI4QvXUf
         HxEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717424400; x=1718029200;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcPdkpRWp56Gkr8DQ3RfeedzRUWF4Qj2aToRrp6ZnS0=;
        b=dEcElmXJF/dXFXuSBF5qiM44u3EsLRVLoh/MnR23FkAtURxkhqtG6sK3BuXaDUxU/K
         v/ZkH03oGChUDEtE+0uddB2d9ZmGpDVp+Fd7h+bQf8dVumLPoQBlDlls4CikUY1AM5LR
         XyFAWKRyty3PbgPYDHNywtwbT6Cwsp8GNZbcJQbGkbAQWA9EDPE1I8mFPSRI12I/shMi
         A0+qD4e/CKK3RCsu0k+upN71qyMqj3OUmkO9923KGXGLRsmvCDXi6+i+mLMV4ZHVcfNH
         exYf1zNWIeni/6OZoEwM0YZdZdmRQBVm6FGL/z81xG8hbIHdYK7majv5P0ERtLxbkDA3
         9Dbg==
X-Forwarded-Encrypted: i=1; AJvYcCUm9hxwYTm233Qei0U1QcXapoCx9Az9NljKKOX5+nDR3wUcYK6Xoa8bb8MI6n4NKFeUc9RNSJ33DCFGK0x9fPIqli6K
X-Gm-Message-State: AOJu0YyQmx64Y17j+E6pUePv0PVigbA2WzKK2V4JQpLid6KrWSErbfvP
	A8xqgBVT+hQ84qPEDAWZKwnxONXQQ9COvSPY71xLelSB7q1de64L8EQME6MBbAQ=
X-Google-Smtp-Source: AGHT+IGtxUcz5Jn3s4N4L7hQt1Rb6KtzRJuNUUTb5gXSMDjmOSvQ4MZJrc68H8z6sbOUSEFfMNAzRg==
X-Received: by 2002:a17:907:7241:b0:a67:910d:1b4a with SMTP id a640c23a62f3a-a6821982261mr681149066b.62.1717424400410;
        Mon, 03 Jun 2024 07:20:00 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a68fcb85d66sm219983266b.34.2024.06.03.07.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 07:19:59 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 4732A5F860;
	Mon,  3 Jun 2024 15:19:59 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  Cameron Esfahani <dirty@apple.com>,  Alexandre Iooss <erdnaxe@crans.org>,
  Yanan Wang <wangyanan55@huawei.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Sunil
 Muthuswamy <sunilmut@microsoft.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  Mahmoud Mandour <ma.mandourr@gmail.com>,
  Reinoud Zandijk <reinoud@netbsd.org>,  kvm@vger.kernel.org,  Roman
 Bolshakov <rbolshakov@ddn.com>
Subject: Re: [PATCH 4/5] plugins: remove special casing for cpu->realized
In-Reply-To: <0a76250f-db5b-4c94-941a-cbec1f2e1db6@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 3 Jun 2024 13:31:07
 +0200")
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
	<20240530194250.1801701-5-alex.bennee@linaro.org>
	<0a76250f-db5b-4c94-941a-cbec1f2e1db6@linaro.org>
Date: Mon, 03 Jun 2024 15:19:59 +0100
Message-ID: <87bk4iglbk.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> On 30/5/24 21:42, Alex Benn=C3=A9e wrote:
>> Now the condition variable is initialised early on we don't need to go
>> through hoops to avoid calling async_run_on_cpu.
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>   plugins/core.c | 6 +-----
>>   1 file changed, 1 insertion(+), 5 deletions(-)
>> diff --git a/plugins/core.c b/plugins/core.c
>> index 0726bc7f25..badede28cf 100644
>> --- a/plugins/core.c
>> +++ b/plugins/core.c
>> @@ -65,11 +65,7 @@ static void plugin_cpu_update__locked(gpointer k, gpo=
inter v, gpointer udata)
>>       CPUState *cpu =3D container_of(k, CPUState, cpu_index);
>>       run_on_cpu_data mask =3D RUN_ON_CPU_HOST_ULONG(*plugin.mask);
>>   -    if (DEVICE(cpu)->realized) {
>
> We could assert() this to protect future refactors.

No because the CPU can still not be realized but it will be able to
queue async work.

>
> Reviewed-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>
>> -        async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
>> -    } else {
>> -        plugin_cpu_update__async(cpu, mask);
>> -    }
>> +    async_run_on_cpu(cpu, plugin_cpu_update__async, mask);
>>   }
>>     void plugin_unregister_cb__locked(struct qemu_plugin_ctx *ctx,

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

