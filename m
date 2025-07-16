Return-Path: <kvm+bounces-52608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6665B072E0
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:13:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8027016BFFA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8255720E704;
	Wed, 16 Jul 2025 10:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NLXCIL+X"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAAC2F2729
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 10:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660793; cv=none; b=ksOvn9ltf+0y1YCDaa3MbxLpTzkiXZct0e8yWTkjw2RS2RAdG95g7nvKmCK5dl1rbDbyKPtYTSxAYhPBsgx1I2i1nJP0/1L8hIAcgB4PS8dnbP0fkiu5ZTKPAiYzK4pSdRibTiC/w6dd1tXrlYj3C1/BlGQe24svQVLYTu3sDvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660793; c=relaxed/simple;
	bh=U6T/gcOoV36c1Jvwp0E3qMt53Io5hl5phQ2S0ZlB2Ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZiPrpekNDIX9I+g5lhkTFp0jpCukNr5c9j2yfRi3syGqfTvHOnUdb5zZhn9CPCwFp6KRyQTGD4LWQRf2Ft9aOf5hrDiPNg6FClNHOv2tJD0UNvUfgh6AR92ygbEuT2WrksgYzKxuge53a7CDOjYIJ+lqtEclmiH+xq31i3IXFv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NLXCIL+X; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752660790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SDg9fNKVULSPywM4snHAHkQlAePZyW2iPDo8IaasA5s=;
	b=NLXCIL+X7haQbsn1SAUW2Z1/FId+UpOQiQYpOLseTPX3BRwzouO6vwxcgoOGC94HYScICJ
	hwWkXVRttybA5nNbne7EqhRK9qzFXKXgSdjSoq7dFdiTuh9GM+axhpydWDYqhDA1hLnAf6
	sErt/8qYnj8ho7jSJx18fIAcmZqL9v4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-7HXvHoaMPIm2B7ZYo4WqaQ-1; Wed, 16 Jul 2025 06:13:09 -0400
X-MC-Unique: 7HXvHoaMPIm2B7ZYo4WqaQ-1
X-Mimecast-MFC-AGG-ID: 7HXvHoaMPIm2B7ZYo4WqaQ_1752660788
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4e713e05bso2749132f8f.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 03:13:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752660788; x=1753265588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDg9fNKVULSPywM4snHAHkQlAePZyW2iPDo8IaasA5s=;
        b=ID4nqjFcSZ3GuY4gAMVf1EvSLoGT+jIDsmUMKs8qtcTqhu4xxZnPjgfBIalIBFXmOp
         S9KECwnusCTtu3xmEB9/e7S3AQ4JOK+iAfg08tJr1aaK6/Ey5B89zJqmx3ZY4hjggLY5
         tz/Yzun/u1lbjq9Cmxq5hIMVEwccaBx/ub4JUj2OnA3Uo2304EBFYS9eWzgW9z++4Lsk
         t15/f8SVngbpitI6VaOxl7yZSwUpZjDhaRIfaUQyax2srlSHpd8u11pyJlL7M13GGGEy
         h0fKxub3vbE38KN+UzLmvcJnxPLjLQhrZmQgoIPj89VJySnG04BmYic3J50FmaloyVMj
         0Grw==
X-Forwarded-Encrypted: i=1; AJvYcCUn/bYoJBI8aFZUp/5AQmVteEXtHEodI/uf7PWwLLIePaYsJcsyDON1d4C7+8ZKecTiEt8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTXfQ8XycPzYtyYvnr38kjHEfu2a3PKRmI9l/xQDRqDuhIh0/n
	VTs9Fs374YsArWqIkJD6SBdgxoS7Eq25tGyHp9OdHrDPaH7LvyNSmyPAl7SMxnX6MK9i56YyWI9
	MgAVjSOpnVzaRmbFB9Cq3kACwKW2FCPAHg4ssbcpibRt2gm1sEZ5btQ==
X-Gm-Gg: ASbGncvAwt2qr8FF/IOsNYSaVUKpYwKrAqY86qCkTQHX1HGyP5EF5+1X4s0SKCqlwHa
	XoWkuTyZtAenW60Z8DAW+PCT4489OdYAfPioNAU9A4etUojRJt8YjH/weXdE6B4v7y7xbuxI2u1
	TapKU0EnRn/TeoqZgKrXt7JW76WCMhSJ503rPEfSOI6QYMgDBYx4K426zU6CehwmU+KBd/UJsHn
	Fsbhl/+z36IV84Ix3XNOcT/o1EzhtN9xEcUBxqN3AjykT8pDdhfdJ/z0dZAtvAP7SmRqnaWl3xZ
	sHZylUaXDW2//45Tnh4YYFhg7lVwkSuZ+eIhrl0PymY/LcUyFEYPT6OKOpMNhz6URoADIMcHO64
	f6Iody9k4EY8=
X-Received: by 2002:a05:6000:22c2:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3b60e523c46mr1553375f8f.27.1752660787778;
        Wed, 16 Jul 2025 03:13:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoGu1ZMJP681KqUVqeq25FjmKb96lWRRkwj0gCeExoWeI/XqpEHgo8aaGRe7lLpQzLbwrMAA==
X-Received: by 2002:a05:6000:22c2:b0:3a4:eef9:818a with SMTP id ffacd0b85a97d-3b60e523c46mr1553350f8f.27.1752660787282;
        Wed, 16 Jul 2025 03:13:07 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0dc3esm17279608f8f.47.2025.07.16.03.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 03:13:06 -0700 (PDT)
Message-ID: <1d582df4-2995-423c-8b6c-351beaf94139@redhat.com>
Date: Wed, 16 Jul 2025 12:13:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 13/13] net: implement UDP tunnel features
 offloading
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>, Jason Wang
 <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>, Vincenzo Maffione <v.maffione@gmail.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <509e49207e4dc4a10ef36492a2ee1f90f3c2c237.1752229731.git.pabeni@redhat.com>
 <f266ffe9-f601-46cc-85be-515475cbfe12@rsg.ci.i.u-tokyo.ac.jp>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <f266ffe9-f601-46cc-85be-515475cbfe12@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 10:07 AM, Akihiko Odaki wrote:
> On 2025/07/11 22:02, Paolo Abeni wrote:
>> When any host or guest GSO over UDP tunnel offload is enabled the
>> virtio net header includes the additional tunnel-related fields,
>> update the size accordingly.
>>
>> Push the GSO over UDP tunnel offloads all the way down to the tap
>> device extending the newly introduced NetFeatures struct, and
>> eventually enable the associated features.
>>
>> As per virtio specification, to convert features bit to offload bit,
>> map the extended features into the reserved range.
>>
>> Finally, make the vhost backend aware of the exact header layout, to
>> copy it correctly. The tunnel-related field are present if either
>> the guest or the host negotiated any UDP tunnel related feature:
>> add them to host kernel supported features list, to allow qemu
>> transfer to such backend the needed information.
> 
> Please also update: hw/virtio/virtio-qmp.c

Do you mean by adding FEATURE_ENTRY() for
{GUEST,HOST}_UDP_TUNNEL_GSO{,_CSUM} ?

Such entries are added in patch 8/13 "qmp: update virtio features map to
support extended features". Even if the features are not supported yet
in such patch, I think the code could already parse their name.

Do you prefer I move the features entry definition here?

Thanks,

Paolo


