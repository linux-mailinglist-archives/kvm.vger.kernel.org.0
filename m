Return-Path: <kvm+bounces-64465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D39AC83738
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6B51434BEB5
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F25283FDD;
	Tue, 25 Nov 2025 06:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vc4nV8Ox"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100A5EAF9
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051660; cv=none; b=uJa8aqJVvQ38Uyh1Vlm+5Qv/fvouK1qY3py/izf1RgN3dVNTY+TcXBDuEk+YzUG6oJd7xGfhdIJn0emh69VDGplAzi1nC6h/f+ENFaezAo/hU2JSaqsAnFk7x4HR8oYFO3RH+7lK96w4UVEZhMQ5d06tYq0+IIsH/DgyX7j51x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051660; c=relaxed/simple;
	bh=foGbEz7jpkjQFZxRtODuI8h9XhhNkS4H7UhT4ZUDWtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfYu+b9Vl94CU2OfVrPqlIlMdr3BfpCTMz0GQ81LiQLVbP0yVK1O4tlqo8/8PO+qRdrLoyD9F7RvMIfSMyV5s8bJUBftsXtzVS7KwIVuM9Dm4j/GsoQPZ/2v+MAQnRtPrXQAAUPEoGEtCVyx3/4BJQIZJlCPDkgJuzSkO0YuOcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vc4nV8Ox; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477b91680f8so40362015e9.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051657; x=1764656457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IHdaIX7rwIeWEffIotS9OpDD12xZA8o++Mo+VV+T6/Y=;
        b=Vc4nV8OxitOCR+jMgiaitpx7CJuq9qs/T45Ls85G2uNI+IWX41AQoYEI8kuuvFP+CH
         CnrIB5MzR6KcxKALO+gqvi63kbgaQ1cedA99/O94IzDZ1MyR5Sczf9pOxQ+362IvcoQA
         EPdX0jy98nRNMAtIDIRrm9IVwqqheNz6Sdbd+vHO8wCM8cZt0h7HteBvjzSl37ZRWpya
         0/cxASrrrl7YZpWlDy8/Bvjns7m2AicStAlC/LXE+5Gt6dqqzLE5EslRG2FYPLECsWF1
         JIs01C/QTsAo77i/Im/y/O3kyRDW39trtq4hQ8vMAjlXz47km/7ETdyzCEiqBiVu/yvk
         l78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051657; x=1764656457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHdaIX7rwIeWEffIotS9OpDD12xZA8o++Mo+VV+T6/Y=;
        b=M9ObVu9ElkyGDkM7h5fhgm65LGwwnbHniIEz2xaJeElIpj7zFTw+pcmtUmPwllwYsA
         Z9Y6bLOQgCC5Ljot+5x+UrbGrk9t/eFHAQQrSgJScZ2dl7bWYTXLG8ndKjhcqWARBVTR
         VBh13xBvJWuxEcHLUnQWUorp4BI8d4vjq3OfIFFzJ71tx6U9VwzFTeVZeT2zIIB5JZNn
         U86ZzSxIH3LXqup5VY6sfrQJpVBRoVRVsuzIPcPrDFlJtG5cFmA8y71HOwhL6sH2K/O3
         6fwcdCu/oIsadYPDlQhVX4Qb7sJRe2DmLDSCjTmEdiozx8Rg+bHOFw6UyKA6VDlpb14k
         1DaA==
X-Forwarded-Encrypted: i=1; AJvYcCXAdbXfJlRFKh4IzSybUx8BcMANCm9hVj53H6rjaqIn6LWfThywK33ETiydqB4lFfxkZmc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyNtRSZiBWxtOWLDrnMErw2SHZUAeJ/L+247gk0juAglkDHU2U
	gg9kPZffRcbdwmKhtSLB4RCJA237yUCU5MIVmMPLee2qbmNZjSCmiJhSAq4uy3Y+Ajc=
X-Gm-Gg: ASbGncuQWGBZHCML95vGkpUi4Vy7pNuCs/V/F43RAU3/j0VK47hHSsQuAv++GYinBTA
	SgEAaGK067XhnHigo+rGfg05ptG1LXRWX8ekJxm+oh0wCo1aq35DtTZN1+RIVVkGd2bl5Z2zHWb
	wjjX1OjzXYJUfwrfS3AR3G/jkw/4SqdkOI8X7lNU9w4K2aFVe5hi30Aal4clVgKzdxJlkkntVF1
	V3vfogO2yxRJ+qPgaWdeRZork0ZqR0QlSaEKUKme4JutZwy9pYhg9yCjMWT0qmBjB31uRgr55K4
	46Vbmy090U3NBazlyUp9QfWc3Kf8YRJa0uxpAMxXZ8p0/euWE8wqiKg+HMD6k6Q9O6STrN3RsF3
	FuLmQ/7qMKRxeRcMYbA9xIFX8Wp4+X3chuJObG3WVk4B5x6PstUN5+rYXFNxzDwjvm9RcUjPn+a
	0ozTebRAz5zWcoXKtZpI37lhepziZp3cnXseD1icikC5+gfG9SwNdHrw==
X-Google-Smtp-Source: AGHT+IGHe0GiKC1Okv4GPlfi6I2wY+Fb1eNjMNxPpHleM142ga2JmmwQ8xf+kkSIPlYpCGBLlQhrpQ==
X-Received: by 2002:a05:600c:45d1:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-477c1123afcmr152637055e9.23.1764051657266;
        Mon, 24 Nov 2025 22:20:57 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052a7330sm7911945e9.3.2025.11.24.22.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:20:56 -0800 (PST)
Message-ID: <ff36ffaa-1a17-41b0-bed2-0fa38fead91e@linaro.org>
Date: Tue, 25 Nov 2025 07:20:54 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/15] net/slirp: Improve file open error message
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
 <20251121121438.1249498-12-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-12-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> This error reports failure to create a temporary file, and
> error_setg_file_open() would probably be too terse, so merely switch
> to error_setg_errno() to add errno information.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   net/slirp.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


