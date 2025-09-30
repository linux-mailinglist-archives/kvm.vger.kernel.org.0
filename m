Return-Path: <kvm+bounces-59080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E165BAB701
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:00:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F52A3AA6AA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 05:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBAE25A2DA;
	Tue, 30 Sep 2025 05:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gl3v0jwv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014412EB10
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 05:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759208423; cv=none; b=Upaa2OezmEs2h2onwCzwY+y8PQzHXJiuSbkAZaEiPjjLfrGFHSoo1QiJbaCs+PT/94njn1waCcUSR6b12HjYx53Zk2jiHw4he8hKu+RRIwvXkOhZDTp3CwinAPtKomVDWz6x6FbIKGSK/baQxB2svDsEi6dAYkqR/nQ/xoUono0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759208423; c=relaxed/simple;
	bh=Jk9eBsMbtO9NAB5HQyiGEFFChF25It4CKqf9TpVaETk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EyuEyFiwoognE1y8PshF3CB8uYrvwMYBQ/JatH3WB4/wOhwAL4O7G9QzSHOlF4ajdNuA6dBiWtOKrfP5hve+fnfthomUqX+plvtzWHB16SBfVgA7UKeWlMHB1WlayqmtDFDQhCye2KU+aep9AQbw/Sl8ihWvCJpNZKOEGApP38I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gl3v0jwv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759208419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3xiFBQZdSxrBR3BZG3caEthJ8AMJq39BtL8Q95119s8=;
	b=Gl3v0jwv3fXdeuXdojsEWtiJXVswq4HBvnDOo1iXbO0kdCq8FM6fJX4av5sVIsDKEx2LTn
	RXSSPJ2c0Q/2bHTrPBUyxR8v/q5L5gdbyP6RkER6RzkVSh1FX7v/u6wJMXDOlX2EBTIsfr
	yW6RihWCn3JVecPhZ4I7Prg87gjP970=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-W7nADQy8Ok6Pzk3a1xxVgQ-1; Tue, 30 Sep 2025 01:00:17 -0400
X-MC-Unique: W7nADQy8Ok6Pzk3a1xxVgQ-1
X-Mimecast-MFC-AGG-ID: W7nADQy8Ok6Pzk3a1xxVgQ_1759208417
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-634bff4ccc6so4433309a12.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 22:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759208416; x=1759813216;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3xiFBQZdSxrBR3BZG3caEthJ8AMJq39BtL8Q95119s8=;
        b=iCOK1ngjz5nNAh9KTwcGsCYVClltYBXAQpe7/gxXtHa8n5EpQB5R9kyZ0/O3G59+Qe
         mbSxitnZz+w8FUODF4mHid/4YmizFM+eDiz4veTi55VsNJcApVforVRX4sTkZyvSyPYi
         cWyjGrwwV7ntc/T4CZ/p0JTcnD61s/txSdTRd5LmJ5qPa5B694ibWwedT07WTCxuofTv
         ebq8VmFA1SKRSmvfVLFmmA501wUyPa8oGfCXDQJ1aLhJmYD5JBmQnyoC3i0cftaQrKGM
         L2mBwCl03/Ve3LHeh3EPXjRgQuwBI/HCPJu5F1CVT4x3jDSpUeZqU5S3Gy5txVT3S3Cy
         Zr8A==
X-Forwarded-Encrypted: i=1; AJvYcCXa7sm3BMlivN5SBNq3/z44ppKbq4dXaTJ4vakRaEc3uvpVil06N+jWDGeJXNBKr9Nd0IA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9DJI1Pq9KPx1vr/l284/7eXXN4xVTgisKYxlWMNNukEO7jKyV
	vc7aXWpWx3KtRo4PTG63SH/LiuSfmDHbeBIzGkPSIB2T6x3faV2kHXZtbNPDsU+wUw3PNIyOvVV
	ieESfbiSGJ2kA76KzboYf/COOmtqYYDmXb4EHsygBougIDCgPm3HQIQ==
X-Gm-Gg: ASbGncvF0XHIQFxgy9Er4i3GFPuICGu89adNSSJfnNoIVRRcZNRkwOtGeWOYCJ3L8HO
	w66JglXwmR1c9Y93zGOX74nIJ8GiLtpb17f7l5WxQ0CYNnIi6BA/9MHi3UMI5lb2o/96zawmY7X
	Kc1MJIHqVe0ZcwGvr24d1gG7VvKIA4FPOUYBkkmamGhDzxLI15LDb1q8IeMoQJIjs+THnvU3kAb
	XSG/iLCh8HkG2R5ReV8q2ejpRnWAlztiHOHDCG5b1MwgpZ0UMCmq3H+MseBkKucBJMoZWJPvGiG
	Dc5RodEHNSN6ih0VkAdPIB+1s/nrvP+MvsKD/NQrsDqHrNRECkfuFKCs5NNyc3yz/IEJbzIshVm
	EaXDfvxu+zA==
X-Received: by 2002:a17:907:3da6:b0:b3e:f987:d6a8 with SMTP id a640c23a62f3a-b3ef987d997mr637745866b.44.1759208416644;
        Mon, 29 Sep 2025 22:00:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHa8KgJhbAbV0RRCkwD4pI/pD3HkfND1iGeihF86L8+aCZePSj+3WOJ+3YXP8Jeay5jFXCoTA==
X-Received: by 2002:a17:907:3da6:b0:b3e:f987:d6a8 with SMTP id a640c23a62f3a-b3ef987d997mr637742166b.44.1759208416253;
        Mon, 29 Sep 2025 22:00:16 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3d277598bdsm449199366b.3.2025.09.29.22.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 22:00:15 -0700 (PDT)
Message-ID: <6c7d7a37-c7e1-44af-839f-7d6d01fc843f@redhat.com>
Date: Tue, 30 Sep 2025 07:00:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/17] system/memory: Factor address_space_is_io() out
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-4-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250930041326.6448-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
> Factor address_space_is_io() out of cpu_physical_memory_is_io().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Thomas Huth <thuth@redhat.com>


