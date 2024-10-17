Return-Path: <kvm+bounces-29092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 328649A2872
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:21:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 392C2B26A95
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2B21DED5A;
	Thu, 17 Oct 2024 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NVp9zqYc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15316C147
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 16:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729182010; cv=none; b=dop+Fo61gLWC8JtLOYEfmIVzrBvIcpDYTDVCPAAPK8jc0ubi5R/HJxRywFwO28IfbBOz1U2W9TQUZ/9Jngup+HZ6mL9fNUrq3k7eJdTWbLngpK1Ix8vM06lXYfL9ZSBauFw5uShyjnsBusPuot7J7JE36aNBQ8miPFU8zXfvkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729182010; c=relaxed/simple;
	bh=3EhA60t5/cZxS/Ia0kaMQ0SG2HopI8A2rPPkAc3SweM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1C/BVOvl1+UiIP84XqQZbR2eZoPoOHavPTWPJU1vJ6pOHcJpQDTFS0C+S4sJNSJv6CYNBwPNJGjiy7Sm4RXhzNYOTPpmjGSzzxHeMAGbbbH9zcnzcOEt6sA2N1BYF234Aar6tyUHM1rWTT/SmlM0ay+0mFP/PMH6QkHGQOEIu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NVp9zqYc; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so1681131a12.2
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 09:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729182007; x=1729786807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HmpBTcOE0ntFZvS0kQpWXmflr4NC+lD3no9yEdxNmiI=;
        b=NVp9zqYczNSlLexcYCWXBMsPcaVrhDmft5dm2KMPpuFOCYAiCjnd82X6T0eV94/F9i
         1NH2htTvXmlbWBUOYsCieLl0e5LsDoIevCbyIow0cRsXab5i8FWzXfirxsEjGt+C/l7B
         IZvCaZUUBCKtMqpA7ZfvwNw8QOJS3TlLLLdXRbpF6PT6aJ7v8VVgjncqKIBSvVOZnbAA
         Ci7EIGEJlZyNjVYTmkM/IKeSpUuuSow5GYgdQgvHWFDOs+o/LXA5+0+9sjNIjqDft3CN
         nP4PZkUZBBZbXA9srnR3mnBVjxzGZVgQ4dqBLf/DumLLfxcJJZQVlKlgQGe6DRzibooe
         XeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729182007; x=1729786807;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HmpBTcOE0ntFZvS0kQpWXmflr4NC+lD3no9yEdxNmiI=;
        b=DoE+pMq0NpgMPOB0ghzv09gDhK8/6z40d+rzAZy+TiSihhX3upU0ip2DguTvVaFk9E
         ndcXmZx9wBVwGTBVAg6nqCsSfgiXtWdMwzfikOVPXO9CkzByhs+IFu6VLDpn6jIRzfcq
         sy2XVUWDg8xkMMhUXjLOOSpA3WpXG4lJREDyLRy/UPkgev9GHiXlsOuCRL4DUEHnlW3z
         TMMc5VrgdH7PDMD/uK7KuGrI+aLzrWLRUB9CwgHM+aU8JlkaF34GGNeydh+IuiLxv9Ae
         hmXiWJjyihYwDxvjsAZRMFSoLj4Q2UpJMyC5XwiKszoP9re883FG+GaXH9lWEc3W76Sd
         BS6w==
X-Forwarded-Encrypted: i=1; AJvYcCW+onH495lobOtIOUPB3/YxQwtQybHp0Krx9JAWJRAH0YNpNRoI+H7CTMiIdoNkZ3LxOm4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVHMhyiRwpyvyNGMSG2LW+9yXOO47QQM+xlWyu9QnTUTB9Np6U
	FdeqZieNhlpZRWkqo+O9PScdBGOU19O1QnYdAwjhGj2WmyZdJGngRz3gKKoFkk0=
X-Google-Smtp-Source: AGHT+IGSttzxUaUhDZZgaCdVEeYQp2df1z3HHJBSILlLsGRR43kbRiALvs1wI4UZ6o20hU9GQ5z7pg==
X-Received: by 2002:a17:907:2da4:b0:a99:ffb5:1db6 with SMTP id a640c23a62f3a-a99ffb55507mr1572531666b.24.1729182007247;
        Thu, 17 Oct 2024 09:20:07 -0700 (PDT)
Received: from [192.168.210.26] (83.11.13.124.ipv4.supernova.orange.pl. [83.11.13.124])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a29844425sm310087366b.168.2024.10.17.09.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 09:20:06 -0700 (PDT)
Message-ID: <0b884126-1fcb-40d2-9fc2-ab0944370fd9@linaro.org>
Date: Thu, 17 Oct 2024 18:19:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] hw/core: Make CPU topology enumeration
 arch-agnostic
To: Zhao Liu <zhao1.liu@intel.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Sia Jee Heng <jeeheng.sia@starfivetech.com>,
 Alireza Sanaee <alireza.sanaee@huawei.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-riscv@nongnu.org,
 qemu-arm@nongnu.org, Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>
References: <20241012104429.1048908-1-zhao1.liu@intel.com>
 <20241012104429.1048908-2-zhao1.liu@intel.com>
From: Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>
Content-Language: pl-PL, en-GB
Organization: Linaro
In-Reply-To: <20241012104429.1048908-2-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

W dniu 12.10.2024 o 12:44, Zhao Liu pisze:
> Cache topology needs to be defined based on CPU topology levels. Thus,
> define CPU topology enumeration in qapi/machine.json to make it generic
> for all architectures.

I have a question: how to create other than default cache topology in C 
source?

If I would like to change default cache structure for sbsa-ref then how 
would I do it?

QEMU has powerful set of command line options. But it is hard to convert 
set of cli options into C code.

