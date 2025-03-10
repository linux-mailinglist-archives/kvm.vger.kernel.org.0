Return-Path: <kvm+bounces-40653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4012A596BD
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 14:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC48F3A476E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3745E22A4D1;
	Mon, 10 Mar 2025 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2NcYi5v"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A9F22A1CD
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741614716; cv=none; b=BpGKRIWi5uj+hu3lw7dMN/7/BuQ776zkP18fj3LvQfstoAEhaRdN+VKrMbLQgyTnaWWIRE+LVhZEJJq1a4fGwkI9f15cC3eN5efh2RcOHHxe6MZC8CCijWzCyqy+ZmnaLa41dN5fS0hXNzwO5r3atZ3wlI6fxjOKobF1VW043o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741614716; c=relaxed/simple;
	bh=6Mzw8LqkG2z6GqifBItHbGPPTOybP8mo3tnvFL42pV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJCjnp5TiAy0R2lWtsvldRJJfTgE6cLrvl7UuPPc0KAvCdDzd5f0ET3wjLf3WAGBsidCRtMDShe1flKUGcI0G1No0LskQ2l7LvAV013rUa+TbBQTcviq8xH9+wF17mR+TOFKq3enSxqoeIcr5y+YHCrUjivouAXVKTRpQLkOiMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2NcYi5v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741614713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XXPykD1PpJG6hNH8QRnzKyM/h9qCy9GNid6QUj8zA8k=;
	b=U2NcYi5vtk4GLjMBBQN1GU+dC0BEuCSXpOjZo+W+toQBsrYy1di82z1tfDN5a7zqn2QC/V
	4f8Y8j+dkWN3CSWsNSoK1tbwZkIUZCqL4YYqkpzOah1ysTWO3GP5AIQP+RhQqsPiYnu0gC
	lRrbFX2qV3qjYti/79JSlA6lYKbRuec=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-9ebcZjA5NoC1lixcpPMMKQ-1; Mon, 10 Mar 2025 09:51:52 -0400
X-MC-Unique: 9ebcZjA5NoC1lixcpPMMKQ-1
X-Mimecast-MFC-AGG-ID: 9ebcZjA5NoC1lixcpPMMKQ_1741614711
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d007b2c79so1490485e9.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:51:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741614711; x=1742219511;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXPykD1PpJG6hNH8QRnzKyM/h9qCy9GNid6QUj8zA8k=;
        b=aArda4+aVs0mcvI46Ssllxv1CrOD+i1/Suu8ImqI33yT2O9XoJo2LhGyXA0lxJA5eO
         49p7+bIlptjJUzwQ5YkDbx7s99pFKtPobfHpN3Tg8rLlbZa+eUtnLqks+T9+83FgyLKQ
         Lr/I54Wxv1n9R+HnEshh9CUf8b5OshKaia54s+iRGJup7XLouO7TinkgL1bg2JjPoTYt
         iW97tMA2s2G7yrm5rekryAGeCXVC+3X6TQdidm5C9WYqISL67HdjqdXhP6rYMog6+n3r
         7MmIIb5lxTo4QP/9zKdcDzpgHzQHKRvwFqHdPttDbryLA4dgQ+Zol2kK3cEBoFIpfZi1
         9xqQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4GUntYxBszKgZjQiOAjelNR2L0dGawm60hcIOgIYcu3udFrpnfFDXEVWqiXcqihD6alU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdhyMsW2Z8ewzvmyZ4fLRb17EXCmx4tjRCMeE2xQXRF0+WVv8g
	Lh4lEXiFKl8o8Yg1LZzaPMzpzoNP48rDhb3/dOtPr/IWa/cnaODmkMgiYRajvahIPCZxkG4I4u+
	jT3vJVn4QYKuqj1QU4uDYelU87v19hFZCwr68mRh+h4vbIg3dkg==
X-Gm-Gg: ASbGnctaZ+6g1SW2CCOjin6o1bp+vwp1NLEbAFPovthTtlo9nkytgqdxzct05n9cJsV
	8JLyHnzt9XQxKBf6uo4VRr6VRKgxs4E/hPu6O6SV3nAqUj/gQvSPs2OYP3H4SHzIPLOir++8Q5F
	mjhUgxJ/yKVJ6BpaOeS/qNKlYGBj+gxEH30/fHlY07avOLdUre/KM64qnmgTD7FO9Xz43kk+98y
	2m5Btybnpjc4pK7z8XNVJnsHOvdvzdvR3IAJa7NkvucnE+ZSRCSHhaCkHA1JXPazKcvV+bAwp4D
	+HC4qWseyi6NusobMSADVAV2t/UreLoDlOzsfa8WQOApl/QeKwZdOA==
X-Received: by 2002:a05:6000:1564:b0:390:fe05:da85 with SMTP id ffacd0b85a97d-39132d1f9b9mr9831037f8f.16.1741614710925;
        Mon, 10 Mar 2025 06:51:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBrou+68AFLDaC70LmJA0jrrA+pkTeLERuHibyL9LeNbE6o7n/aWrLAd7ywC6I0b1XBFfEag==
X-Received: by 2002:a05:6000:1564:b0:390:fe05:da85 with SMTP id ffacd0b85a97d-39132d1f9b9mr9830993f8f.16.1741614710588;
        Mon, 10 Mar 2025 06:51:50 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01de21sm15153302f8f.59.2025.03.10.06.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 06:51:50 -0700 (PDT)
Message-ID: <8f62d7ac-7109-4975-84a2-4a7fa345dd74@redhat.com>
Date: Mon, 10 Mar 2025 14:51:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/21] hw/vfio/igd: Check CONFIG_VFIO_IGD at runtime
 using vfio_igd_builtin()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Eric Auger <eric.auger@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-13-philmd@linaro.org>
 <415339c1-8f83-4059-949e-63ef0c28b4b9@redhat.com>
 <7fc9e684-d677-4ae6-addb-9983f74166b3@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 xsFNBFu8o3UBEADP+oJVJaWm5vzZa/iLgpBAuzxSmNYhURZH+guITvSySk30YWfLYGBWQgeo
 8NzNXBY3cH7JX3/a0jzmhDc0U61qFxVgrPqs1PQOjp7yRSFuDAnjtRqNvWkvlnRWLFq4+U5t
 yzYe4SFMjFb6Oc0xkQmaK2flmiJNnnxPttYwKBPd98WfXMmjwAv7QfwW+OL3VlTPADgzkcqj
 53bfZ4VblAQrq6Ctbtu7JuUGAxSIL3XqeQlAwwLTfFGrmpY7MroE7n9Rl+hy/kuIrb/TO8n0
 ZxYXvvhT7OmRKvbYuc5Jze6o7op/bJHlufY+AquYQ4dPxjPPVUT/DLiUYJ3oVBWFYNbzfOrV
 RxEwNuRbycttMiZWxgflsQoHF06q/2l4ttS3zsV4TDZudMq0TbCH/uJFPFsbHUN91qwwaN/+
 gy1j7o6aWMz+Ib3O9dK2M/j/O/Ube95mdCqN4N/uSnDlca3YDEWrV9jO1mUS/ndOkjxa34ia
 70FjwiSQAsyIwqbRO3CGmiOJqDa9qNvd2TJgAaS2WCw/TlBALjVQ7AyoPEoBPj31K74Wc4GS
 Rm+FSch32ei61yFu6ACdZ12i5Edt+To+hkElzjt6db/UgRUeKfzlMB7PodK7o8NBD8outJGS
 tsL2GRX24QvvBuusJdMiLGpNz3uqyqwzC5w0Fd34E6G94806fwARAQABzSJDw6lkcmljIExl
 IEdvYXRlciA8Y2xnQHJlZGhhdC5jb20+wsGRBBMBCAA7FiEEoPZlSPBIlev+awtgUaNDx8/7
 7KEFAmTLlVECGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQUaNDx8/77KG0eg//
 S0zIzTcxkrwJ/9XgdcvVTnXLVF9V4/tZPfB7sCp8rpDCEseU6O0TkOVFoGWM39sEMiQBSvyY
 lHrP7p7E/JYQNNLh441MfaX8RJ5Ul3btluLapm8oHp/vbHKV2IhLcpNCfAqaQKdfk8yazYhh
 EdxTBlzxPcu+78uE5fF4wusmtutK0JG0sAgq0mHFZX7qKG6LIbdLdaQalZ8CCFMKUhLptW71
 xe+aNrn7hScBoOj2kTDRgf9CE7svmjGToJzUxgeh9mIkxAxTu7XU+8lmL28j2L5uNuDOq9vl
 hM30OT+pfHmyPLtLK8+GXfFDxjea5hZLF+2yolE/ATQFt9AmOmXC+YayrcO2ZvdnKExZS1o8
 VUKpZgRnkwMUUReaF/mTauRQGLuS4lDcI4DrARPyLGNbvYlpmJWnGRWCDguQ/LBPpbG7djoy
 k3NlvoeA757c4DgCzggViqLm0Bae320qEc6z9o0X0ePqSU2f7vcuWN49Uhox5kM5L86DzjEQ
 RHXndoJkeL8LmHx8DM+kx4aZt0zVfCHwmKTkSTQoAQakLpLte7tWXIio9ZKhUGPv/eHxXEoS
 0rOOAZ6np1U/xNR82QbF9qr9TrTVI3GtVe7Vxmff+qoSAxJiZQCo5kt0YlWwti2fFI4xvkOi
 V7lyhOA3+/3oRKpZYQ86Frlo61HU3r6d9wzOwU0EW7yjdQEQALyDNNMw/08/fsyWEWjfqVhW
 pOOrX2h+z4q0lOHkjxi/FRIRLfXeZjFfNQNLSoL8j1y2rQOs1j1g+NV3K5hrZYYcMs0xhmrZ
 KXAHjjDx7FW3sG3jcGjFW5Xk4olTrZwFsZVUcP8XZlArLmkAX3UyrrXEWPSBJCXxDIW1hzwp
 bV/nVbo/K9XBptT/wPd+RPiOTIIRptjypGY+S23HYBDND3mtfTz/uY0Jytaio9GETj+fFis6
 TxFjjbZNUxKpwftu/4RimZ7qL+uM1rG1lLWc9SPtFxRQ8uLvLOUFB1AqHixBcx7LIXSKZEFU
 CSLB2AE4wXQkJbApye48qnZ09zc929df5gU6hjgqV9Gk1rIfHxvTsYltA1jWalySEScmr0iS
 YBZjw8Nbd7SxeomAxzBv2l1Fk8fPzR7M616dtb3Z3HLjyvwAwxtfGD7VnvINPbzyibbe9c6g
 LxYCr23c2Ry0UfFXh6UKD83d5ybqnXrEJ5n/t1+TLGCYGzF2erVYGkQrReJe8Mld3iGVldB7
 JhuAU1+d88NS3aBpNF6TbGXqlXGF6Yua6n1cOY2Yb4lO/mDKgjXd3aviqlwVlodC8AwI0Sdu
 jWryzL5/AGEU2sIDQCHuv1QgzmKwhE58d475KdVX/3Vt5I9kTXpvEpfW18TjlFkdHGESM/Jx
 IqVsqvhAJkalABEBAAHCwV8EGAECAAkFAlu8o3UCGwwACgkQUaNDx8/77KEhwg//WqVopd5k
 8hQb9VVdk6RQOCTfo6wHhEqgjbXQGlaxKHoXywEQBi8eULbeMQf5l4+tHJWBxswQ93IHBQjK
 yKyNr4FXseUI5O20XVNYDJZUrhA4yn0e/Af0IX25d94HXQ5sMTWr1qlSK6Zu79lbH3R57w9j
 hQm9emQEp785ui3A5U2Lqp6nWYWXz0eUZ0Tad2zC71Gg9VazU9MXyWn749s0nXbVLcLS0yop
 s302Gf3ZmtgfXTX/W+M25hiVRRKCH88yr6it+OMJBUndQVAA/fE9hYom6t/zqA248j0QAV/p
 LHH3hSirE1mv+7jpQnhMvatrwUpeXrOiEw1nHzWCqOJUZ4SY+HmGFW0YirWV2mYKoaGO2YBU
 wYF7O9TI3GEEgRMBIRT98fHa0NPwtlTktVISl73LpgVscdW8yg9Gc82oe8FzU1uHjU8b10lU
 XOMHpqDDEV9//r4ZhkKZ9C4O+YZcTFu+mvAY3GlqivBNkmYsHYSlFsbxc37E1HpTEaSWsGfA
 HQoPn9qrDJgsgcbBVc1gkUT6hnxShKPp4PlsZVMNjvPAnr5TEBgHkk54HQRhhwcYv1T2QumQ
 izDiU6iOrUzBThaMhZO3i927SG2DwWDVzZltKrCMD1aMPvb3NU8FOYRhNmIFR3fcalYr+9gD
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <7fc9e684-d677-4ae6-addb-9983f74166b3@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/10/25 14:43, Philippe Mathieu-Daudé wrote:
> On 10/3/25 08:37, Cédric Le Goater wrote:
>> On 3/9/25 00:09, Philippe Mathieu-Daudé wrote:
>>> Convert the compile time check on the CONFIG_VFIO_IGD definition
>>> by a runtime one by calling vfio_igd_builtin(), which check
>>> whether VFIO_IGD is built in a qemu-system binary.
>>>
>>> Add stubs to avoid when VFIO_IGD is not built in:
>>
>> I thought we were trying to avoid stubs in QEMU build. Did that change ?
> 
> Hmm so you want remove the VFIO_IGD Kconfig symbol and have it always
> builtin with VFIO. It might make sense for quirks, since vfio_realize()
> already checks for the VFIO_FEATURE_ENABLE_IGD_OPREGION feature.

I have explored this option in the past and it's much more work.
Stubs are fine IMO, if we can have them, but I remember someone
telling me (you ?) that we were trying to remove them.


Thanks,

C.



> I'll see if there aren't other implications I missed.
> 
> Thanks,
> 
> Phil.
> 


