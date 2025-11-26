Return-Path: <kvm+bounces-64620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5419AC887CF
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EB5A3B1E29
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:47:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356D928643A;
	Wed, 26 Nov 2025 07:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d9JQkke2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FF6800
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 07:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764143245; cv=none; b=GzvqfI/MsEGng3f3YEcVvoq8UTX7m6JsDN4TcL9Ory9ERjs8tBd8XiXR9uc1hifnYlk6wqB8VkbEmG3q1XNHa59v8cpjbMcCd8p/tRf3Pn96O99r4W22dKbSKh1yogLcSdsNm3VJG/+TlEbzM72AL3PznL0WGTswovKGyDm9LFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764143245; c=relaxed/simple;
	bh=/5+5jgTmbIxw0SZMMH8NegQ1N+8rTN78izhvoNVOLPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PzGZ9slm1LzinrepPit6BXy6TEfgea+Sd1PvFX2eAWItib2Sjqh0G/e4Ny1mVyv9AkhH1LDAJWEv6zVF0l9xk1NjVuvL8mZ3wxUT676SERzVZF0vFTYj5HbR2ljzA7qLixqo23ww6IIzcfFsP7eeQkHAHOJeYhk5qnLvrv/6E/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d9JQkke2; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b387483bbso4783270f8f.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 23:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764143242; x=1764748042; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zsieY7w1fxjIpAfjZ3y4sG5vS6LVcOFLLmGd+GcbgpU=;
        b=d9JQkke2WDEG6ncFlv8UApvZ3NN24yxtBDzgyl8uN8rnazrB6fiMh+hvfxuDWEZU13
         AK0WlnKe6psCJEqZaM3p0mo3y0xlanK0bqpQMoVpTgplMMQoHUElO4xND8gDsP3Ck963
         EpMtXbO9tGCJMgkkz5HYxL0dNmoijcMOADtI5s1tnWMkVGM4tiZk06sg2V0i8bO02Snt
         ba+Z7h5dZDQnAw1aXSzdB/C4mPyvzgNhZETgz+5W0f8d5B80O230EHaxtgzdryjFwPGc
         EeuQx9OY4gtqiV/Enp78ybEonqC9AAI5SqD6kq/MrfITGGZ/axa2NqTUe2g1W/GpNF4+
         U5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764143242; x=1764748042;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsieY7w1fxjIpAfjZ3y4sG5vS6LVcOFLLmGd+GcbgpU=;
        b=Ty9u2GP9lc5VL29OdOUBM4529/s6RwcGR5maOzmvFoTdboLAKkvkGlz1/qZyhRTp++
         xEUMeCCiClX5RXjDN43/ucjBcFKN+CPl171vz4N/JfulTHznsfmVRUhHTcDBO/TFh1/C
         O7soOrRdq0uNC97PeM6UtmHKPEwZFqjcwLABerd+FQlo1rhY8AnP4AWk8vydStHkgd+L
         os9OI9VMjEA+kdmaOrkAZEMks82UoNWtwAXPdMKT5Ez7K70xzqidINbERBnQF5GK+zNK
         b+8QIVb6Jh7khliGv0mMTnCs/Ux3I3Azu+jkdiQH0OUq0x+KBLPOOgkHsO8jNo6IGbGq
         UbUA==
X-Forwarded-Encrypted: i=1; AJvYcCX9m4xjESk6QyCRhGVFNT+XZBXXX2fCc/OuK/cfpHhq9wgujEtt71+HpjFk7Tup/pah+74=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQFcALj2uZ94ArPmuz3zjnkskrHho1V7vJDjecWaIRgVJAds0A
	qDxxWjhs2aPRpks4keYYOGZI5ovh2i6d1gHy3dffFci8WmT6iVyxtzyf8e5cCB3zwFI=
X-Gm-Gg: ASbGnctXsjbGIBE7QrRHi1MovggmKHv0OSutzHHAbdOZh3gHqdPAhxVSkztAMYneJwL
	vbmPsoh9zoeSJA9cjLMMa3Oi+SdwSAmNaiBYNaqPtvSgr4kTr00qZea7leo6NbsmaMchuq9qCRd
	ZtTtXIvrzTaMRXm01Ji+Tl8td0+VsxYROxUvKGgJHg0aS6k5Vo/pDOfC+b3VFeAdfw1sSM+vgUW
	D42I631mhkEyKus/P9X4IoUXCZGBc2F6lVbzNVtBoRoMVGOLo5ZT0piY3Mfss3InvHh8ExzEVIa
	LOlEFRhMx4KpmVPuQEYHJ9Fe64A6ljYz44zCE+bSORLWgPg9zZvBFs/SMOIMrQjwLG+Sb+bswrg
	0kpr4P6vuzWJszWBuCoplk+lMzTCqAnqBRuYWrpAk4bxR1KGTQgjD4UKlbRnwmY3mKzhwMNmu/F
	3y3uWRz8xDAR/Vne+ux6A41vyxJ58JIzP4KFNb8trTeGX7goFc7f1LZw==
X-Google-Smtp-Source: AGHT+IH2GXe3uOHdS28Ob+Jmg5+KHh4tMhOG/Rv+GpKOzuevWPWxYjVQGr2hWKaJgLZVaJdz6qu+XA==
X-Received: by 2002:a05:6000:2681:b0:429:c8e4:b691 with SMTP id ffacd0b85a97d-42cc1d5239amr18461831f8f.55.1764143241928;
        Tue, 25 Nov 2025 23:47:21 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f2e454sm38740426f8f.2.2025.11.25.23.47.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 23:47:21 -0800 (PST)
Message-ID: <2bed91d0-8574-42ee-8d7d-e85f3ae40c1f@linaro.org>
Date: Wed, 26 Nov 2025 08:47:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/15] Error message improvements
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-1-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/11/25 13:14, Markus Armbruster wrote:

> Markus Armbruster (15):

>    hw/usb: Convert to qemu_create() for a better error message

>    hw/scsi: Use error_setg_file_open() for a better error message
>    hw/virtio: Use error_setg_file_open() for a better error message

Queued these 3, thanks.

