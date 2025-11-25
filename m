Return-Path: <kvm+bounces-64462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 83062C8371A
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D483D34BD36
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00808283FDD;
	Tue, 25 Nov 2025 06:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FHBWVp5y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B5AEAF9
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051496; cv=none; b=i+XiNqGZDtsz/1VmVvr+7UVSO2mEpLcahMlt8lrP1UbnyUj6b8wx272CRYXq5DgLAEOwxM70/KolGBLxpMV1jMmw6vtcaDht+F6NZs3fo1OP0FZULT9tKsZZ6jxcpUZ7i69zWnIBmpnL1QgqiybLUMCDubAFHw1yMZWpVxdVLUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051496; c=relaxed/simple;
	bh=/bCtoub38iu9F/F03plziGkTwxG1Hl7RlvgLb34K8KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MvJAd9/Qi4T5m+pKryJQrxeQkedrjPMgRXDtQ00VzTMKwmFP/+QOXtuE2+DcQUtsunbtSXBNaz17MzZA68Ck6LdjsxOMl3KQ93RFeS82ZIRpmGVYec/fkjGW8DPCEBcbieveGbctjp/8mEaW30IvQnBkpt3J/+podc55t0EHdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FHBWVp5y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477770019e4so43557875e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051492; x=1764656292; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DGzD1fnYIa6B4Wk/+xHq8vM1YIpJLnhM/vaTxvSqse0=;
        b=FHBWVp5ytBKY0R2wovl3keZQpOaHX8kiDDyllaT2eey+4oNKLYSQkkvwjF1M2Q66RJ
         C3tET5s2X5nEWe78VlzSEyfIB8UZOY00ej4mm1qHPrAlNK3j4uHPPone3LvOmp94fEWT
         RZQNRmhCuf62ENzqWPqjmRv2B0k8yJxeLtFEkjxEIVHGVJ4I9qTKG4faXYv/s0ogEvPl
         hIeDgwY0/cieK+WaEMK9Jw4DgOQudzwJTdFZxEHbG1kK966iDNQuHuOiO5cLahAcDx6u
         EE3hump0vJn+2r+dY5kXbW1C3nX8uFLRLdkHxVJJE6pFF2HaO2ZWcl0XRYSbyUU2Jq4/
         sHWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051492; x=1764656292;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DGzD1fnYIa6B4Wk/+xHq8vM1YIpJLnhM/vaTxvSqse0=;
        b=KNnPChB+vEqllT62WGDtuLLtbA5G7PG40pPaLEcnoUv7zsFQXXfp5BFHmCt471c/x8
         JWsytqa4elyZ8oiiAYHPNV/Jadl/kexW8PiIEfUzS3Zqcuqj1Ptw+w0QTMRiNJ5lsIQO
         mXmB6vTIEQ/YiTSS9LJ/tZoRFUKZSpFTXu8NJn19sT0KvL21T1hJUYFxZ7+DtMiFip4W
         KuWjlVpGuHnzNyjU/qY1gS2IPgAIxqWPKgRqTbhBVc2jYtZaFV+3ZVztTNx56yA7ZcBq
         a6ykdnHn1QPPKiAsQR7Ho1hKahUdoiByHtFen3Q5eApKPhjL/uQoq7dXQhlFuvkXdGdG
         uNBg==
X-Forwarded-Encrypted: i=1; AJvYcCUv3fNSrde6xxGdHlzu/LPmAxTBaKZuwG9GiZ9ITBAKsLjFVe8eKofTPPvGzWsENcTuM2M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxajp3r8QoMHqQK4O+2nCRHTI4byU3tXYQfdxwbWvHx7lUTWvWV
	bM3NdOdP/BkYIC31YC4NO/gISRnx8ViFywXGhBlx0j5zhsxprlz3KQrbFSUn1BbNYXE=
X-Gm-Gg: ASbGncu6usK1e97lZrUWlHNm+7rwDUCHa9EOGPYdPkBcUdumo781vtY3dP8594id8LE
	nZehvSiQ4IpR4c45hW7jCFddATUiYekNF2abFjREj1YmLz9JAxG4Wugky89cCzeLJagb3LRLnSq
	optcDOHj/2j75tr1LGq9IJoyOW+LESm8+9bbip2JAoHae4GqVnIpVc9QE1boH4tUjn9dT73+pOl
	ZhZwBHvmTVtCnOm5ntqZkE9jsCh/b6Uuuydh57JYjCDwiwHXFJYGip0lGg9mt6Y8msbJTeSzoBt
	1/3xBnEZpxQjm9Nk0opYhJDWMGet2Ls2gJCoI97ZzXDHuPhNHIaHOlghGNYliKnHzSIlqZcbBB+
	atqCozXpwcGNGk9oOB1uIqg3+X6I+AjR13qVXwsk8nPpc+MuOzFqT3Sw47wQ17xMKNu5DMVpD7T
	5DIok7yz0FvE8W6yQV8a2PtcYCnQx3No9UhU1r8OfFpORPvo7VTIlj9UzJS1bGuDmg
X-Google-Smtp-Source: AGHT+IFEapOZrwVKXPqkXWl1ucGf2xeCrDksHj/tDIzv3GC9v5QhNc1aLWWWmC76do8k0bUg496w7A==
X-Received: by 2002:a05:600c:1c87:b0:477:98f7:2aec with SMTP id 5b1f17b1804b1-47904acef12mr14113255e9.3.1764051492559;
        Mon, 24 Nov 2025 22:18:12 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf22dfc1sm231064705e9.12.2025.11.24.22.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:18:12 -0800 (PST)
Message-ID: <37f651b9-06b5-4264-966d-f8c766df6be8@linaro.org>
Date: Tue, 25 Nov 2025 07:18:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/15] hw/scsi: Use error_setg_file_open() for a better
 error message
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
 <20251121121438.1249498-7-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-7-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      vhost-scsi: open vhost char device failed: REASON
> 
> to
> 
>      Could not open '/dev/vhost-scsi': REASON
> 
> I think the exact file name is more useful to know than the file's
> purpose.
> 
> We could put back the "vhost-scsi: " prefix with error_prepend().  Not
> worth the bother.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
> ---
>   hw/scsi/vhost-scsi.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


