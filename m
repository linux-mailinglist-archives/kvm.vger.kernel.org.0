Return-Path: <kvm+bounces-64460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8226FC83701
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 158F43AE415
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F0D280309;
	Tue, 25 Nov 2025 06:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BoWMFm5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE89157487
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051344; cv=none; b=plXZV7Y0zd5letTlst9ZhVuPBVyr+MbeZ9gWwASyZl4WLPRYeuKJdwR4VoEXs3pltzdHZ82KFQDuqN/qOBU4hLo8qNdTICEqMz+uf8/hcQy30PMv9XoY2bzqUuB4XkQRuxraFmi3AVZN1U155HXRuZuEgET7Z3qTv6sRaReQJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051344; c=relaxed/simple;
	bh=tzGx43RNSKt6hsz/OxIGvU5qRjrYSOuX4EGxehGbyVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GQZE9HTola9g+e3gmcNfdAyV/40M+c3mpQ9Q9UVmYAyAKuDyxvQQ0qbo6E7PrmRdENtHEn5GeDn1l0fktAil31sikT11ymSjiE+Weu0XhW1AJUXjhKfgDV0X5YyyeV9LBXuKZjKCuifVQKg/TmtBugLmNfwQ61bp1ttTYymLpBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BoWMFm5L; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b31507ed8so4303121f8f.1
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051341; x=1764656141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0f/9Y7JR60Swip/dFOGxc5iPJjQDRvPRSNeJxakP8wk=;
        b=BoWMFm5LNk8eSLq9K7a+CMA9o7b4w/yMzNNKhQC3R5liEYrnlfhoWHfI7wXXeS8vT6
         gkvx5qsD80+cGbJKmaY6jOqC5fPYY2VSO4rq4XNLb5VwrF3HNqduYK/HO31Np1N33kek
         tPprmWMPfhnzJbCmV/q3cHDXHWQAgaEolFbgcc7cMB/NMazkO+szJsPy5236SpPRkeiH
         NBTqynd3/td0tll0HhRjwQR0awmS46TMluePZF9FsaiRcElmeoBuml1KNHqY4exKJDCW
         OQtaYYGkeYgnkQULiaoviUAjf/ThCLHw6OVHEMbJo6/BOVcnnqAyyndCO0URqBlWLDJF
         r0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051341; x=1764656141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0f/9Y7JR60Swip/dFOGxc5iPJjQDRvPRSNeJxakP8wk=;
        b=JVn75MnlRqZ/KChmWPBADK6eyBezt816kaP8pkEj9TkBawDS2fQhtBZ9utNvonQUtG
         E0DzvsA7z3exbzjCnYn+7z0IBoY0Qx031Um9xo0E3VdCCFx/fP2IAJuMy9arrFYTtx48
         oMXCF8eNnKxdTkmEfnZX7SVllR3+SGMxcmH1QMrWaOd9IR/gAZT/iAmyHHHRZSYDWz0V
         YMa9wTEOxK+Z5Qux2exm5ELsljDYNz8SdQYRZHce83Isxdm8HgeiGQpxYy4qN86qjjEm
         EoxD6H0XG+LKUXBZxn/TtbTVgdHXLtWDgGEI7gk4n5rO13BOlnx3lKcZi7NWNSZKnrU+
         El6A==
X-Forwarded-Encrypted: i=1; AJvYcCU37AKX+gi6YYEIS0jSCOAOgy5EELq/5yD3J6CWjZBN3esSYsPVQAkI+T/u5F8BPF8SPOo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkwZmY9LHi3CREXciiC0GvSvasHQtdS4SU1jpQTtiqq8coGbUc
	YBkg18trIA129Kxn5Kip6KGFP9DbfYYtLl+3whWQ7FgKagNZbqWiqzXS/yi8vSaOglo=
X-Gm-Gg: ASbGncsd1TAss4+GkU9AwnxzNUk1n66BMqzgmwc0lIayFQH523H9ymgzewpxsah0N/K
	yBJdpJ2supyLuTTUeZldlPBkx1YsuSzRwHjRf/j53yf4unZqf9KnQyzgIFPA+nBoaZiwS1WYJeI
	1+3Dk4fPemqC/E4E6W63wpHzq5kU5BX5WVwQ72YEKVUYutxZHRUwmBXY3fVtAPHv9bWA0TsAaIZ
	poVKkpH6FfzmxMHezp1l+MkWfvf0jDpQTuqtSPl5jPGQTx2bKXCmfkfyFHVwPG6Hy6ju7iNYTx8
	dLqKPkE+vOezo1q+R9BZpdervnpXPXYa0VwMfKGgCuWDKNFkfnhL6p3bd+XETod66D/Mf/Ib/ko
	id5TGDSToJsZrfvqH0barZMFo36hmLf9wPShCDs8PET0d4vwy6at8tuIF44Wabu4ALMfOz0+DVj
	LmW6yc730DaRUdLKelxmxs82SD7ps+MQfXzAF1meX0HQQPXXTT/5ikdA==
X-Google-Smtp-Source: AGHT+IHZNFdwNkAyt39hw1XEKeec2HDhjScGvIOI1PKKSdFRbVG0BYsnK8PrGv30KDcQUn6wPGJ2MA==
X-Received: by 2002:a05:6000:4028:b0:42b:3366:632a with SMTP id ffacd0b85a97d-42e0f355caamr1135311f8f.39.1764051341155;
        Mon, 24 Nov 2025 22:15:41 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e574sm32156895f8f.3.2025.11.24.22.15.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:15:40 -0800 (PST)
Message-ID: <7984cbbd-905e-4e03-84fa-1cc2a1261a80@linaro.org>
Date: Tue, 25 Nov 2025 07:15:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/15] error: Strip trailing '\n' from error string
 arguments (again)
Content-Language: en-US
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: arei.gonglei@huawei.com, zhenwei.pi@linux.dev, alistair.francis@wdc.com,
 stefanb@linux.vnet.ibm.com, kwolf@redhat.com, hreitz@redhat.com,
 sw@weilnetz.de, qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
 imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
 shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
 sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
 edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 sgarzare@redhat.com, pbonzini@redhat.com, fam@euphon.net, alex@shazbot.org,
 clg@redhat.com, peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
 dave@treblig.org, jasowang@redhat.com, samuel.thibault@ens-lyon.org,
 michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
 mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
 liwei1518@gmail.com, dbarboza@ventanamicro.com,
 zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
 qemu-block@nongnu.org, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org,
 kvm@vger.kernel.org, qemu-riscv@nongnu.org
References: <20251121121438.1249498-1-armbru@redhat.com>
 <20251121121438.1249498-2-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-2-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Tracked down with scripts/coccinelle/err-bad-newline.cocci.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   hw/audio/es1370.c | 2 +-
>   ui/gtk.c          | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


