Return-Path: <kvm+bounces-64463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 60342C83723
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 07:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0826B34B7CF
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 06:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08BC283FDD;
	Tue, 25 Nov 2025 06:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LUJOViMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A31EAF9
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 06:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764051549; cv=none; b=qJ2Bxo9xqhFBRDv+xIREIBvurSXXywG+2R2FR/I3zGkuGwx6373feQgoiBcYtcJEhXJZPFTpXifVjSP9pTu8jHJJr0g5oRJpNB2TKnhgK+wFvjrG0hG5ljznz2LuaYCbI+7gA5T4H2zk+N7rkYUYg0NwzMuLwQFZl86eZH9zwIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764051549; c=relaxed/simple;
	bh=RWmINcXdmd9KiF4E9BZP5xyCOL0+rbIju8QCQT+hRts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TMAZ86zFH7ZWtKbxK2BbjztNAHE45dGNoSJpNdhXmIfaCSHXoi70/CTB974r+vCQi8D2iUeScSjTF+lsGCOCjJ6MS3CzE0zXXGFEl1ngNJbtxqobj4tG49SYJtaEAQEnhRyrMxffgZ1HtU8ZvlI/5BK9b5qyCZVU81VTNoxHmY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LUJOViMW; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47118259fd8so44058455e9.3
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764051545; x=1764656345; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X30FMRBV6rs2CIsf7r6Mx7FRlGfIzbGDOF+dbbDNFAg=;
        b=LUJOViMWWehH8wx2vu/s55mKUFSR6Y2UxhY4F0Ywefaeh1KEL+XDODRtomc8VP+61k
         1cinfFKTKhPQWYDGsggreqUlB9eNlkRYgW4SrF57mL95x16YJkEvW2+HMYYZSxyScrzh
         7oFSKVKlo2qPQDxlKBvb8CE9y5dQWXBC9/xQ6ahZ91P6B7Ypzav8AfdreAWWRsdDioX3
         DsoczrSsz51NxNoUmKsJwR0J0EtDFun8kEoaVNhzeqKV1dZCOH36cvl0IVZC271l6SKY
         WjI+Eh9X7bOhyElL3/TDjQ68pxZrQQcU6UDafECIlr19tCvlnW5Bl7YpFUHJIu440lDW
         jB8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764051545; x=1764656345;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X30FMRBV6rs2CIsf7r6Mx7FRlGfIzbGDOF+dbbDNFAg=;
        b=eNwjjxpqswE30RJ2wKEHUHd2FV+pDj7Q8iiwoA9tSwpTK2yridnzdjRVml0GuvB6jA
         z0hwKe5D6PSa9qfNti1kMkwkoI2U5L9gS9W/lhxcOH/78NazAVznM6ioycwJOrJhAayv
         BYh9RiEEUUt71ZoRWimvWoF++jelX72yeb9/VlBWQZtd1Usqj3cHe/Mrsa7oTba36/QJ
         X4VE8XHUHLfyyLCWT7q179WjKcHZjMVlgvpqAodM8YJ7wXEh118tJXjBzUe+2ENE3ZlY
         OSXeoqqJI9RMDxMnyhExbmyttxWrP2KU0DzNvcGkhh2RnQAx34vsycoWx9djlUz+WDQ0
         Lo4w==
X-Forwarded-Encrypted: i=1; AJvYcCWsEb+XNQl13u5lBxP1bBBz4u82pQFEKnFoi2qJvFKWp6d8dVam0GCB6nsD0svGRKyPFz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmRpOppLXu6WjYyE7+yl+WlClwweCBTowBp8mQJ+CVkkbegs1J
	6KmhDSCxxxkRFgnBxtrRnOifZ8LE0gZ1H+PYTaRl4+SED6f2gyuTO0RM769oZkU+tt8=
X-Gm-Gg: ASbGncvzlHWzqLFRlHJr2Aq8mSgYvaIwQdaPtHbNYI8llx2xdJCAf+onaYlhrIPDMR/
	0hPvefs1fOzaDL24s/gY0uu1fMMxJxHwv1tlbWL8YvN83j6FGTis8meuMbxR0+co31wXYoHhR2G
	4ju5ChHo6UEmdMOQnllE23XspsdxsZArwJ0aSLHhetQHuLGNxLaW19hw0CkeCG+MvHsSVRWRMN+
	GZOS5J9rhMPaRowD1FwjLmt9NUlMpzaO1Al+u4SbPhg+W0JELbpmmj74DVoXzEPfl8VpTptxDRH
	weGoKOPV52VL7kW7AlhPBuTa37vIs02gRIbtkfS4PCZJ5QFTy0kek49DgCvEuAizXS9Rc2CPXTP
	AEqDIhE0q0/QqmsCfpFXRTM2oCeAx91y1ilFuwQtfJnsdPac/qOBLRa62HhPQ+KgLO0fuanDwyj
	IsIVvZx/1g4blZzpWwDD1JKKGIEkC9H6kVXpBcnNbfArZG0ldv6w3AQw==
X-Google-Smtp-Source: AGHT+IEAS/g3YIxold2M9P/q5H77arLENsXrfrsPawoV7IMsBeDbBm6FxQuMeLBU7nI1wau2acezwA==
X-Received: by 2002:a05:600c:c48e:b0:477:641a:1402 with SMTP id 5b1f17b1804b1-47904ac438bmr12859925e9.4.1764051545408;
        Mon, 24 Nov 2025 22:19:05 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479040cfe17sm10996785e9.5.2025.11.24.22.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Nov 2025 22:19:04 -0800 (PST)
Message-ID: <7a99da47-44fa-45cd-8cdc-60bef1fa9e60@linaro.org>
Date: Tue, 25 Nov 2025 07:19:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/15] hw/virtio: Use error_setg_file_open() for a
 better error message
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
 <20251121121438.1249498-8-armbru@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251121121438.1249498-8-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/11/25 13:14, Markus Armbruster wrote:
> The error message changes from
> 
>      vhost-vsock: failed to open vhost device: REASON
> 
> to
> 
>      Could not open '/dev/vhost-vsock': REASON
> 
> I think the exact file name is more useful to know than the file's
> purpose.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   hw/virtio/vhost-vsock.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


