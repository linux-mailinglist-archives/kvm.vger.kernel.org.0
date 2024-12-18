Return-Path: <kvm+bounces-34061-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F3D39F6AB3
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:04:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C623D1887D0F
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD7E1C2304;
	Wed, 18 Dec 2024 16:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="abb/tyBM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0561B12A177
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537878; cv=none; b=IShEpjz70035KxKMM7CWv2nK1q10rEm6lnycZFiare+QidDUJv86WMI0B+z1P/imd5HFlf70EkIOGdy6Hwxtyxs1ORyOmTKbcsVKC/PLS54vqzNUpQmTb2ymBpumhh40b43275bVROww+I2M8sjFKMHTHdyfG4NT4QTC1ITfI4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537878; c=relaxed/simple;
	bh=bJh6OhQpvFhgsFqWFSGrLYgOQ1NX6UEY5Zu1RMI3Bkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q3iV+7igKS9GJbLswP4oL2pZH87Zo+lgweGQD/Af4srMrFkoBtUXUYqqMyj+8H//Kxc/PqCVdd54PHTYdtnvbnMrT+sXuZ1XLz4H6066AcWg34VNXemz9SHDjSx7hKDYX9hIvySprLBrMJumAd3PEcrT8k4iMUL1ztOOwTLQhc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=abb/tyBM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734537876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eijY6uFF4aHcithl4FrOqhaAxTgCEPVuy4PHaqDgwrY=;
	b=abb/tyBMp0rjyowEJQ8KLuyqyFAHQh5wtG9ZW7sRdKtpMqyJcxcNJaLuTDOUBBjwREXIOA
	wD7uxonpgIA87i1A3lXGPcCSJxAkUY9DRT2WYj0X1ygaVs+vqVoWlywxg2iy27V28D13KQ
	hb2YXLZqyrpAY8cDajzs3jkx3ijSb48=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-CjOFIUk6OrCuZ5qh-Glgew-1; Wed, 18 Dec 2024 11:04:34 -0500
X-MC-Unique: CjOFIUk6OrCuZ5qh-Glgew-1
X-Mimecast-MFC-AGG-ID: CjOFIUk6OrCuZ5qh-Glgew
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-467b19b5641so95823171cf.3
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:04:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734537874; x=1735142674;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eijY6uFF4aHcithl4FrOqhaAxTgCEPVuy4PHaqDgwrY=;
        b=ObWqhk7VQw2XFRtnjR/R+daSroBvVLpI/zK4w6V2jvIHs+AbnAK0ylD/9y/H05VtCM
         wYwEXZcH3Je0yzfeyKETh8JVCUTQISOp2c39Nr5DcIuVGfhoPAoMOCYXh9Y0kYbXeA7k
         CcoXOpEgGHfwpA9Evf+yxlRlR6gwwPhEge1Y4UPscKPJ3unUYyec/ucZ/C5HoJ68jnhZ
         K07j66aXvct9g3tLEFhc0DGy4pqsQN52/xh+fg7z//CvGqi4hXk+2plYUyWxHOqIM1RS
         0dZfmVGVw3rFlJlC+5Fa/adlzWD3nl8MfRLI46bhTlt2sBjJ2Kig0adAPXev7sEtljsm
         D7vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCxPFzYOvbrJwti+4GlVY2uLEajyghhxuhuty31oISDONGnYnPYAWRgxN+3xxS82skl28=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy83t4sLR5XRmTy8scNCCoz547tl54loeH65GFaUvD38pNGv7AZ
	hvNgYmDDgfrAzUm0iZbXnPJGaGXpEC9lkWQHM8dpYkMzHgRvzEu7g6DAoqxgYXrSio3+lJyDsWM
	aK3bxjSaLb4moDqiCNoTLuMx/d0MZTGdtGC6GvLGZVLLt39rMhQ==
X-Gm-Gg: ASbGncvMitF/1GvHe86dSnLFK7EN4QniF56PJREO2+TEU3u4MA+/WPDcX4DtY0df0DC
	W7Dymhd7SDZv/67HU05GyeLAJkW3S0fyt8OKw7V0Be6iPhLbCXc4VVzXeESCBS002KFTW1EH0aJ
	oFDZuKDvbwPm39iNU0x4WOTgSYDQ1ewaSeCkIkNnPO0yCpmHXbkAUG84XPQLiS5L/fix5gx2G5P
	n/TFiXrrmAuHXWf3Q57RfxWUknwQ05cl4OnfKwjzqupLrs1TkVghG+7Ctt5zRytCHhidgnfS+sh
	t0V9aLLqbEa2
X-Received: by 2002:ac8:5d09:0:b0:463:788e:7912 with SMTP id d75a77b69052e-46a3a8dc8d7mr263051cf.56.1734537874025;
        Wed, 18 Dec 2024 08:04:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH5eVeUSsIFvvfwdP4DtQxkyrCvGf5+mj8b7Ot8GVwFXCI/qUzKVfb7SeZDSgBcKmd4E/+UEQ==
X-Received: by 2002:ac8:5d09:0:b0:463:788e:7912 with SMTP id d75a77b69052e-46a3a8dc8d7mr262521cf.56.1734537873547;
        Wed, 18 Dec 2024 08:04:33 -0800 (PST)
Received: from [192.168.0.6] (ip-109-42-49-186.web.vodafone.de. [109.42.49.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-467b2e8097asm52098001cf.63.2024.12.18.08.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 08:04:33 -0800 (PST)
Message-ID: <b126810a-c6a8-492d-8fdd-652019dd0b7b@redhat.com>
Date: Wed, 18 Dec 2024 17:04:27 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, qemu-s390x@nongnu.org,
 Yanan Wang <wangyanan55@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-3-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20241218155913.72288-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/12/2024 16.59, Philippe Mathieu-Daudé wrote:
> "system/confidential-guest-support.h" is not needed,
> remove it. Reorder #ifdef'ry to reduce declarations
> exposed on user emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/sev.h  | 29 ++++++++++++++++-------------
>   hw/i386/pc_sysfw.c |  2 +-
>   2 files changed, 17 insertions(+), 14 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


