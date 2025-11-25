Return-Path: <kvm+bounces-64468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CADCC8375C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 760DB3AD642
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74063286425;
	Tue, 25 Nov 2025 06:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="csNLumHD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAA220FA81
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051868; cv=none; b=fu+9F8KBNs4JKKu/lJ+2ZSi0CxOHs27ZpUitmJbY/bOpyW2n2BrCPmIuKs9GfGrcGSYczTo5KbOhsXMaXtoXxJAsPLNgTdB/D77/GF81v9SnOAnLTEQcRiGNbXfXUbQojsKmY50SLXsV3yUAgKTYt0FqCCFHgL7EhusH+tlXqgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051868; c=relaxed/simple;
	bh=UuPQRrNvyCidyJ1hhrjMGMBDX8NrJGv0LxGiyTYu2Ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRmI+n8cOpeCQXbuJpCfJ3nDcNp/7rTUrpC16Ie4KvDwQdUjMBcWoMV9vzDkWaoiF/gf6Da58FOrjKyG9ylqJlnIzWMhK2bi4gkuIT8dapGn3rOonMmlU+QTmi+XmTeNUhJY39n62RU2PKgPMl1xSKzCThitYh4xYlk+hJvFArg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=csNLumHD; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42b47f662a0so2653526f8f.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051865; x=1764656665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vq1z7uETBPWyiFMQkSi+G7SH23QCq9t1LMUTYPMDnpc=;
        b=csNLumHDdRa/vmj6HPjXhMJ6It9aqTCC0AREok+iVl9LK/Loj1OnOVcosAS6Ja/mp5
         FA31W0v3oSeL2yoCTepzP0BMTrBFnaeOqTu+2qesqljtxLApmRGBIwJUTcBPof9dzohz
         U0lKusUZ7fkOdoeVbGQ5AFAA4aFbyXRomwxME54fd6Pa9WPDJ3p7i9Upt7Y0mV7a5jTF
         mICdkhI6bZt8noxJ1tKXImyaBy0iTnQJgK8roX20hxkQS1hPF+QXQDLSVhbDiu5cxEoc
         DltwK5PjE7dvOtzQ6ICEhV95dIawTPStgVDEJi7P6Nqc83VA3jPlXD9xMFkfPCueHHHt
         TjKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051865; x=1764656665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vq1z7uETBPWyiFMQkSi+G7SH23QCq9t1LMUTYPMDnpc=;
        b=FPbRgo4XEsX1vWlzcAH4jvb2C8Yh2QaAxyPTJQ2gpgKktW8x+ixqq1r1nIWWNdMpZS
         iCOhQDrNVfT+X2x0+1BVcKAwMBATnqoAX3UH8pd99Qh3/jYj3c4tKN3qPZLqm++gxCFX
         K8C64faFa/eZWUqZebHeSP3ODFnobXxP+FqJtyE0SGroBgPkyYxYQLxQj+bii8WOKwXZ
         QRoRt6bKfGgCLLzkpcuyCLL90R8b6ziiSBt+Rd+rd81AUT1dPAE5OWGSw3dg8xyQwZb6
         0jaW2PF4yF+cQObaLtzNazYAPOx+9ZM2+5x3YdP5BdIzPvAfpfAhbn+qRaazaHqs6DX3
         TS+w==
X-Forwarded-Encrypted: i=1; AJvYcCXnvRpgOmkaUhlenR2whPL29jSDQ4P+soCo8BdoixRAerFSaIRv6DsfObnCIJDseaVnO9w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz/gP1IzC2EV606a91AufYaFDj2MC7ZxzxpbFk6jCI3bVaKraG
	NhCjtNtycowvMNAH5T+QSXtpNaa+sGsptT2G+3JJMBokW+xoqKO9TyykrWljp9sHc5s=
X-Gm-Gg: ASbGnctTZIQwuBdk0dGZiuQz4xcf8D8tWrZzfHlZKTauEKMnY/IbkSwYOKc/8lR0hdf
	jYB7NR9Nzr1sVKvHaJZs1G+0Is8x4Hq7inMk64z4TDHLd1rftlIScSKC33YCxExW3EnXuie/NWM
	eBRKpSQ6hHGMvOa0qQvhTMU1Xu8cIMHFz2juy+gC5AX1xg4z6GrniY9iwEVFMDWQjHzOl2uczWJ
	icyMr0XqaMyaHgW/mLnnSyskrU/PY6Nl6WkQLowseSnEVjB41KlzsaGXsEAROQDy3dhjUTsQQqi
	7e2ysJBiDbACCFeP9QTVB8C+F8Tu8x94Y+qWHER2hqgf/cALZnta8NSCPUa7WCsZ1fCv9lDDhZF
	8fQzsmwsZ0FIj4c8pENBA9aFdzrfWxJRihCAqbTs8LZTF7hKGs9/VD3bcpBMRHwB+W3ak1a50Lm
	wr7eD7Du19DKDtGIaZXJJq7rX2QSV/GeXgoKtRam0DvOBRMXQT/rWyK+7DXFWB00rt
X-Google-Smtp-Source: AGHT+IEaf9VPAlvbB+DJWu+zfTWBlEbYA/AGQ5BPVvtwmDg4JvdCIECBmvF4Zcsn6awffVSNfsJ6Hw==
X-Received: by 2002:a05:6000:228a:b0:429:cc39:99c0 with SMTP id ffacd0b85a97d-42cc12f1bddmr17201116f8f.1.1764051865045;
        Mon, 24 Nov 2025 22:24:25 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fd8d97sm31796036f8f.42.2025.11.24.22.24.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:24:24 -0800 (PST)
Message-ID: <f356b3c8-ed08-4ec9-93c8-dc9dc6accc59@linaro.org>
Date: Tue, 25 Nov 2025 07:24:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/15] qga/commands-win32: Use error_setg_win32() for
 better error messages
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
 <20251121121438.1249498-15-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-15-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> We include numeric GetLastError() codes in error messages in a few
> places, like this:
> 
>      error_setg(errp, "GRIPE: %d", (int)GetLastError());
> 
> Show text instead, like this:
> 
>      error_setg_win32(errp, GetLastError(), "GRIPE");
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   qga/commands-win32.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


