Return-Path: <kvm+bounces-54972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A2DB2BE3E
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:59:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB9E3188C341
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4660C319844;
	Tue, 19 Aug 2025 09:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PeZcw8Jb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FD926C3BC
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597521; cv=none; b=QSpTEGpIRweidnyu9cje3/8EjpHxShYsYA2oXQIwG1oM1uB7jUWfChQL6W6bppo/w2lDjp8BI2Uo94QKm5YgGzStQGpln+1C+4YupRcpEa49RYorD9vD9uoQh7RHB/Z11xAW5uaYVJiBX5x1Z5SHaOVFpJGDrheh0T668vd5XtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597521; c=relaxed/simple;
	bh=sQ6/tcXzx45H4od67c10FCsVm8cOMVqLD5Z3dBKapwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJC+ak/IgTp5+nWDw+Ma6B23nWhc9MuKlCbTcKkO+TkhPHJli8A/1N28sP5wUyUyoCsBgw+ACU/wusPo4r7vNFI5iPs+iE0g+znraQEQDI9QGm5Er0K//h14jk+jANpRAlm8hsnePltgJ3nd+lyRPfvlyS50cUA3Gg3ii9J8a1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PeZcw8Jb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755597518;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DxidopYvtBYBSDXNlSF3PIBralIAf58Gt3+cUKvGLaU=;
	b=PeZcw8JbcLAXkMqIIJ3LsvK4kSQvigQt/zs1oUBPU7Q87EEO7H9JnYLWdMlFVLi922uLoG
	VrzVbTqCBgOrjOHUAv8bZc/LoXWsdQ8H7cY5OuLTEszDt0882HayhY1r1/CGMqkvYYth12
	u5VyuwjrqDuF1tytlAcNhT+qb3mwCuk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-JMqfXkUAMoO-CWfws6_5vw-1; Tue, 19 Aug 2025 05:58:37 -0400
X-MC-Unique: JMqfXkUAMoO-CWfws6_5vw-1
X-Mimecast-MFC-AGG-ID: JMqfXkUAMoO-CWfws6_5vw_1755597516
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b05d3c4so32669595e9.1
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755597516; x=1756202316;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DxidopYvtBYBSDXNlSF3PIBralIAf58Gt3+cUKvGLaU=;
        b=u+c5b1PNLIfzSsXz0dYYLdmUuD4jRF2VG4uYKivlc5am5p7F31OTEykFZpdEKgIoRC
         h5kXvJM4omcgjwY72stS6YxzpaDJzFU4qrvLBnXIoCEI17iIy1tk1HZSpGNUaKUXQrrJ
         f4fr3KPfgjGCkcwvvWZZUuX7QZXVcaFUx5FMrFztnsy3apPkpoYJwmApr9cJJKntLcnZ
         AUZb5IkW2xNzIf/BKrnEqlkKjSKjshMpzVQGOozLbXxQZ2pNNhzmFQa+ItSAt2m3JtVk
         dRwDscPU45hypEg8+2vzy01eSHN/pjpLvM+EGsuHh0/uWElu1WVy9evNlS3XHnzviqvl
         mxdw==
X-Gm-Message-State: AOJu0YxFFSTKeJ41OupW3MmkedhDEMDjOW5z9K3mi53Q+p4CKyIniAZ3
	/QH+HxuTKLpY+nYP1PT1lRvPbYaP7gzwLF6pVjKHV+m6pHRs7UhHquIpbRMgMci+Up/IuiPqwb5
	Eyino4MkQfd7X6zUDMVQvN3Uh6b3J7Z8F91QugFnNqp4SOmGJATAbzQ==
X-Gm-Gg: ASbGncscMeeA2UenzHh5/AlV0h9eTy1w5GKKIK9wmufhAsplZUHMX1J+MYtc97dN2rV
	rUNXqWzqiTtv1dwtyXvBsbAiCgzxxobG/8t6h7yjcUqKiJNVrjvTGSgKrbOEzGM5rb7c8xh7Z+3
	y6orXETO/WmQoRRZlhcO+cDriSZ5enrHIsTXfbb+/9g83KVgnXLE0ycFF5cTf2jdK/IClvHh5Ti
	DpEGoftYBQsXEarJyrcD5SW31PhuGwIjk7DcUezAhJOAc/aMpeUTPRAadshOexXGB7OKoSLyYs1
	0cCKDhU2Mi04Ljz7p0OmFgURVQWz2DAsmc8FhIUcchkK
X-Received: by 2002:a5d:64ca:0:b0:3ba:c0d2:3985 with SMTP id ffacd0b85a97d-3c0ea3cef57mr1620624f8f.7.1755597515583;
        Tue, 19 Aug 2025 02:58:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETKJM0Lx0P2KeZ9svQmo/bIxhq07BDsJl3YcUCuFjLNK+9A+rKmaTnKCDeiQKIVNGcr46XHQ==
X-Received: by 2002:a5d:64ca:0:b0:3ba:c0d2:3985 with SMTP id ffacd0b85a97d-3c0ea3cef57mr1620595f8f.7.1755597514982;
        Tue, 19 Aug 2025 02:58:34 -0700 (PDT)
Received: from [192.168.43.95] ([37.167.50.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43947sm3200958f8f.18.2025.08.19.02.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 02:58:34 -0700 (PDT)
Message-ID: <00001486-b43d-4c2b-a41c-35ab5e823f21@redhat.com>
Date: Tue, 19 Aug 2025 11:58:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Content-Language: en-US
To: Mostafa Saleh <smostafa@google.com>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
 <20250806170314.3768750-3-alex.williamson@redhat.com>
 <aJ9neYocl8sSjpOG@google.com>
 <20250818105242.4e6b96ed.alex.williamson@redhat.com>
 <aKNj4EUgHYCZ9Q4f@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <aKNj4EUgHYCZ9Q4f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Mostafa,

On 8/18/25 7:33 PM, Mostafa Saleh wrote:
> On Mon, Aug 18, 2025 at 10:52:42AM -0600, Alex Williamson wrote:
>> On Fri, 15 Aug 2025 16:59:37 +0000
>> Mostafa Saleh <smostafa@google.com> wrote:
>>
>>> Hi Alex,
>>>
>>> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
>>>> vfio-platform hasn't had a meaningful contribution in years.  In-tree
>>>> hardware support is predominantly only for devices which are long since
>>>> e-waste.  QEMU support for platform devices is slated for removal in
>>>> QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
>>>> driver and difficulties supporting new devices at KVM Forum 2024,
>>>> gaining some support for removal, some disagreement, but garnering no
>>>> new hardware support, leaving the driver in a state where it cannot
>>>> be tested.
>>>>
>>>> Mark as obsolete and subject to removal.  
>>> Recently(this year) in Android, we enabled VFIO-platform for protected KVM,
>>> and it’s supported in our VMM (CrosVM) [1].
>>> CrosVM support is different from Qemu, as it doesn't require any device
>>> specific logic in the VMM, however, it relies on loading a device tree
>>> template in runtime (with “compatiable” string...) and it will just
>>> override regs, irqs.. So it doesn’t need device knowledge (at least for now)
>>> Similarly, the kernel doesn’t need reset drivers as the hypervisor handles that.
>> I think what we attempt to achieve in vfio is repeatability and data
>> integrity independent of the hypervisor.  IOW, if we 'kill -9' the
>> hypervisor process, the kernel can bring the device back to a default
>> state where the device isn't wedged or leaking information through the
>> device to the next use case.  If the hypervisor wants to support
>> enhanced resets on top of that, that's great, but I think it becomes
>> difficult to argue that vfio-platform itself holds up its end of the
>> bargain if we're really trusting the hypervisor to handle these aspects.
> Sorry I was not clear, we only use that in Android for ARM64 and pKVM,
> where the hypervisor in this context means the code running in EL2 which
> is more privileged than the kernel, so it should be trusted.
> However, as I mentioned that code is not upstream yet, so it's a valid
> concern that the kernel still needs a reset driver.
>
>>> Unfortunately, there is no upstream support at the moment, we are making
>>> some -slow- progress on that [2][3]
>>>
>>> If it helps, I have access to HW that can run that and I can review/test
>>> changes, until upstream support lands; if you are open to keeping VFIO-platform.
>>> Or I can look into adding support for existing upstream HW(with platforms I am
>>> familiar with as Pixel-6)
>> Ultimately I'll lean on Eric to make the call.  I know he's concerned
>> about testing, but he raised that and various other concerns whether
>> platform device really have a future with vfio nearly a year ago and
>> nothing has changed.  Currently it requires a module option opt-in to
>> enable devices that the kernel doesn't know how to reset.  Is that
>> sufficient or should use of such a device taint the kernel?  If any
>> device beyond the few e-waste devices that we know how to reset taint
>> the kernel, should this support really even be in the kernel?  Thanks,
> I think with the way it’s supported at the moment we need the kernel
> to ensure that reset happens.

Effectively my main concern is I cannot test vfio-platform anymore. We
had some CVEs also impacting the vfio platform code base and it is a
major issue not being able to test. That's why I was obliged, last year,
to resume the integration of a new device (the tegra234 mgbe), nobody
seemed to be really interested in and this work could not be upstreamed
due to lack of traction and its hacky nature.

You did not really comment on which kind of devices were currently
integrated. Are they within the original scope of vfio (with DMA
capabilities and protected by an IOMMU)? Last discussion we had in
https://lore.kernel.org/all/ZvvLpLUZnj-Z_tEs@google.com/ led to the
conclusion that maybe VFIO was not the best suited framework.

In case we keep the driver in, I think we need to get a garantee that
you or someone else at Google commits to review and test potential
changes with a perspective to take over its maintenance.

Thanks

Eric

>
> But maybe instead of having that specific reset handler for VFIO, we
> can rely on the “shutdown” method already existing in "platform_driver"?
> I believe that should put the device in a state where it can be re-probed
> safely. Although not all devices implement that but it seems more generic
> and scalable.
>
> Thanks,
> Mostafa
>
>> Alex
>>


