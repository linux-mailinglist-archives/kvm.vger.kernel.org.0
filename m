Return-Path: <kvm+bounces-64464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0078FC8372C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:19:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2E943AB3B2
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38782283FDD;
	Tue, 25 Nov 2025 06:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DaHeKcbg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9224DEAF9
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051575; cv=none; b=tfFbztlmeZdbluT9pUDrxlsBsv+PVL1SFAkOYYjbPzwCAL2ceQ0r8ccofhsgcbxSHYg7k2bCsX06Dfd8QWPXK6RbLZQfzmMm/IRHlEz/jjHphvkJlcPdvE8tN5Qjs7COk2fS3MxyDZjU/m3hFEa/JPAzzzdWfQVRLyxVJZSAT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051575; c=relaxed/simple;
	bh=hNGzw4u/MTfBtVJI1c7ALCaWwzA35cc6+PrNlY5G7qg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FaLZuJ5faI4upRMTpyAUd9iw+nadB6c1KzU77Xi41uWK527ogjGvCXKlkzWMBxq4tuZ809IjeJ6eTr7qz/qIAPx4hyNBWr2QF21CmfC3IpfWUy5goZ6zcxVZr/Q2KlWbxRIu+DREvCtr93NlURP9Ec+35vk8daXPiNfF8lK7B/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DaHeKcbg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so53533395e9.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051572; x=1764656372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ayCvkqAvPPz9n6xMxwdSlHGHuKgh4PUChBb7KqLIT+Q=;
        b=DaHeKcbgL1oY55S6FIrKjnxLjbTEpGkwZCDAfE39bwvLii6wtQc+yBWZkVKfGXuq6O
         fbMnvzeVn3+KPnNgwEoUqEXmhTdjJ7wMG3ex5mLgY2wBR+ENpqvlP2iIcY6v9/hcLriU
         RFaP3c43AsxEOX/iUw1iJO0DGo/JF0G3GvjqsLJMHeHld+y3s2lLYrc97X/DB8NqQEwW
         V98jIQ+AFXZJ9T//XG9340exsGMbAbXYoATUfA4y1kwJrxzAHHmyUu1P8LLohr5tmyau
         8s4T6Z+MRGsRd11ujW1jCjErE0RA+76j+Io31PHZcVSsOO8mhXbqTNhKgUpLPIXLPBh8
         jN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051572; x=1764656372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ayCvkqAvPPz9n6xMxwdSlHGHuKgh4PUChBb7KqLIT+Q=;
        b=FZIUPGVaMi0bptI8G++Wxa6F8thCxZHsbefvPyfpVE7K7bAZLe/BiOicAb0V+FAsQY
         x9M9y3Dfy2b/9b2GqRp8aRi+q2kBv5ntQkhMft8icqGuHXxJJfSjNPuOkte+McvCzbDd
         pYSB/SW+HWxp0ekw/jETSfgoicxbec+oxG0vOBNZQMXHrtTUiYYe8w6OTDMFykf/QGCz
         j61wgpSzw7JW98z8O3XnypYFnBucRtnECnzDURBCugRgM1ZZaxUZqFOhCQ63zkoe0be4
         Sfldz0IeGGRe47z5UOgno3e/UjCFSCXd81KgmXEW5Hwwx0HA2O5ANncAL1+On3YbFiEY
         NfvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIwR0uNDCTCkgMvzaHEVCHdUw1xwr+hqFp+LkN1Cu/eMdTYZX651F7oSNc6jkLxDZuk9w=@vger.kernel.org
X-Gm-Message-State: AOJu0YycIpiBry+V+dd/l4JBB1LhzZKwwtY9eovdTZqNBVUgUKw36A5H
	TnXFb7ZIOZIsUO4Lq4YfwNElLy1m7+BQgh0M01wrEVrsrkRkEFfMXqx1Ysaq828shSo=
X-Gm-Gg: ASbGncvlhZBa7sIACCBYnWTjhtI8gN62YGcmS8z8uTH0DOLreamgWyeHRIj2BEg7PXw
	0hmJrR5n8MzLfQp2ra82MNl+McNpilYuUkhxST/oYqRXwkah8xe8EMR+SYgYkRs5asr2RDVqKsw
	t5Pgtva1O1P+Rl+m/UZOuG5ZIKkTLIRM2UPDrP+85+80ANmlJK2zCjI+iCfUe5pgPpdoyCLu8Wh
	qM2RAx/hetKTaIGlDpqXr4wIKcsL5I9uy9dzc/HnzemukfOKG0VEGJobcEN4a8+hoypEt33QMKo
	waVy+S0SVCk08hQd8ifyIUoWlML/xn1G/kPb9pnmXxYki/R7zNSfZPR+UMFJBo8ySybpZvyc3tA
	3I18ijLKFqZ2xKixnhkX2sfKMFyhuhjWaFovzCiCd+U3B/MNE79tJruSVFigyRX4gKiUeW252a2
	4sj+Ni4/uXqY/u6P2zNl472FHAw9duTTC5IJQsUHuUMZ5zDDn+5jv3ug==
X-Google-Smtp-Source: AGHT+IGCGhdbHAxDlOenXxyfRDqxklvPY0q7ajM0L7BLu8g1ZJkCYTA/gCYbTbb1g7QtxJ0wSEDH8Q==
X-Received: by 2002:a05:600c:8b37:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47904b1ab30mr12611775e9.16.1764051571921;
        Mon, 24 Nov 2025 22:19:31 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3b4eb2sm230183655e9.12.2025.11.24.22.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:19:31 -0800 (PST)
Message-ID: <786d2523-7e15-4a41-afef-ee97adcc414a@linaro.org>
Date: Tue, 25 Nov 2025 07:19:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/15] net/tap: Use error_setg_file_open() for a better
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
 <20251121121438.1249498-9-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-9-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      tap: open vhost char device failed
> 
> to
> 
>      Could not open '/dev/vhost-net': REASON
> 
> I think the exact file name is more useful to know than the file's
> purpose.
> 
> We could put back the "tap: " prefix with error_prepend().  Not
> worth the bother.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   net/tap.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


