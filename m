Return-Path: <kvm+bounces-64487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5C9C847E3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 11:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE48E4E8D5B
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:29:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BEA2FF644;
	Tue, 25 Nov 2025 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uzOSEe5u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396C22DCC1B
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 10:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764066545; cv=none; b=EY6jW5PPpr785XkF9pM1FLRLHNSEv6lazyaZQZ9TjTrKE/2gCCChdaqDidh2w9OFwJYqJszQRuURLjxpWD1HcoVWEHLAeoHboIisPEoeif34JiHzvigKK26QASJ9vIr1/CRwRWXfHCuGY6AntM3Do9tAnpI03IruCjrnH95Xgok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764066545; c=relaxed/simple;
	bh=BdhDEqPCbqJdt+abm4q3/FX7mkMSpI4uly0PjKdZ2+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATLia9P+BIlX9Sh0dH8c5RTB431hWzkOttqSi0mCf/N/u3KUwEx1XFrnvW2yJ8iV1JtTrzg8NWOybiTMSjcQA3t+F/EIQ+Zp1xMOw+4nwBsutrrGgXrqSgcaG9mMHRYnGelookrByI32db3z1nh20rY/+2Y0oZc2F4+kw0lD7iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uzOSEe5u; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b32a5494dso2786024f8f.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 02:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764066541; x=1764671341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FOtq6FkTjjV4xqPH8MCZhBCC4A3ygFQQRD95vDYNiQk=;
        b=uzOSEe5uRlVmxuaW3Q168iWAAvoucC81PtcrWh/+qM3PgM33KClb0w5KNR1/zQHLgf
         cA/qN0w2nxzmRcK5ghdcySQudX48kEiuOkEpKfjBdGcGTTymzOM4Hg735gv28A0pAoj4
         HNJLaoIyTXepP3YcxJuppa+WuWUUz+CbH30EZDXqgIRBsJQIJKoTzUUdxD6YdUSgogIc
         h9CEcUIubYibrBw02XTqGuL572vPCATy5w5Eseytro6vQp4JkKV5OfgpGnMVI4+GvPOy
         zKIMjP893fCQ17gwdcsFuJFBe1tp1rAd3VIeK0ju27VvLUlwkYx7/qWL4aa7MaL0jbDy
         lNXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764066541; x=1764671341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FOtq6FkTjjV4xqPH8MCZhBCC4A3ygFQQRD95vDYNiQk=;
        b=Iz+CE8mHl0nBcrtca9Rv/yboIt8Jx0ta5sGOs3jYTDlOBsdpQIjl5kUFpoVHWcb4ZA
         i5X18Nj6z+2kFyY/fzR1KQldsHdn44C25VFKrk376DEdo4p793xFaYx7WCZBAgv59mwf
         ng7aACipzmm0GPlrAjf8ctRgtMEAa1yIq/0AlNqAOmTzI8hYELD1nIyKB8sbTtu7ZpXS
         gwFIWxeNbB8bx39A72a+W4NmEqD/mognYsVAcmZtN2AEmQrQm7zWwIsL367aIBKE6Of5
         e8PQyA5NwadK0A9/QC9z3N6qRXucX/7JzNo3naJuehkIQB3qfXar2k7RhrGHKajmGook
         ITEQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzyaeQiM//hso73gaQ4oUxydjWdsGk7LkUugkZM4fvZvNSJ23pSJvfBp/dEkUZ7VzicoM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj/YrnOb72OPvwVCOPBheDbkxIC6YuFYdZvZFJ1YQZBR2l7WUR
	ahaGDmXEG84RMFBbglDXDLrnXiXMES/UvbPkS7aa2B4mbAXGCHP7ZgVwpn8HZUHmH2U=
X-Gm-Gg: ASbGncv97+pHpq7fMohRvchPdMPVrL64fc17eiGcSeamM2txuTeIpGcjjvlJdn0AtZp
	gi9fRPZXuVAANhUoOh+ZVHMzsKvxs/DFBztRd+jd4v92J9lDED6lPePnvkxO+VxabaCmLdIDU8H
	hEkkXOauHbImzaEHqdiom3PZZqhbvLkrRooIImxtS4NloscQ/RsHYPLmnbEbGppYBDja79nM2hq
	MIQbIV1NbpIXqj7GPON1Z39KNPDdxN0DagAXses3ky3VpC/AudeeGAh50o0iEdktb171WD9Wh94
	lkl9FeetyXrUGC5TdV5XwI6R2rAGpGVLmkV03VehyYyEtD9FPcsfRycvZS99t0dBkhOKEF1T4Ez
	Au5ObRgVTKHCpbyRZO7U2LlipbSCAXnYNNEgC5/k57DC2VggJGknNDnWKXPVu75VqXdi0QufLPK
	/JaAUsHx/v7sBMYveInLHAOXSwTm0zOWs0TWExBOg9Y15YV0nSDUqr9Q==
X-Google-Smtp-Source: AGHT+IEbJeTrLY46fCznAtjfXdYPHTUtYeQtitUWoI1YXftLHuYFMPldzZFqKU9cjG8M/We/w9d/JA==
X-Received: by 2002:a5d:588b:0:b0:42b:411b:e487 with SMTP id ffacd0b85a97d-42cc1cd920amr16516595f8f.2.1764066541445;
        Tue, 25 Nov 2025 02:29:01 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm33346517f8f.33.2025.11.25.02.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 02:29:00 -0800 (PST)
Message-ID: <9922cb86-5c48-464f-a811-05a7a4b4a9cb@linaro.org>
Date: Tue, 25 Nov 2025 11:28:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/15] qga: Use error_setg_file_open() for better error
 messages
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
 <20251121121438.1249498-6-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-6-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> Error messages change from
> 
>      open("FNAME"): REASON
> 
> to
> 
>      Could not open 'FNAME': REASON
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>
> Reviewed-by: Kostiantyn Kostiuk <kkostiuk@redhat.com>
> ---
>   qga/commands-linux.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


