Return-Path: <kvm+bounces-36796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1378BA211C7
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 19:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67BA01650F2
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 18:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15561DE8A5;
	Tue, 28 Jan 2025 18:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CtUMvNRI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E092BA27
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738089930; cv=none; b=WOsqYYXCeXS7XHAz9DYIQjgxESwcCRPTfhsaSOK7YRA3uEnMwUNjshLTH0CVv/F/USkYH3nK3z218XkzP8F46a8/dzhZ6oPnpkDY81BY/Kb+VRkD0nuGXxyqS72i/OV20F6irXryWwMgpHcFB/ggfvzaSlr4xc3CJjKbpQt6VvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738089930; c=relaxed/simple;
	bh=lK/UGxtTfuY4YviCjpzea9hieFXvu94jOAdTz/C7VGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=otD4YC4YIxvgj8ZPkiCzEpOET81WwD6sfo529IKdyMUS8mXCvmF8v0ZoHmQgt7FJe4Knr7h8prqpgymKg4Tzd+FjoQTHslchX3gaT4uKk6wF3RG7RvUEJSrNBds3/LkFtqaGIg35vr88iM7lLz+gHPRXNYzenk86Y3ga8B6Y/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CtUMvNRI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738089927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=q27/2aSdx5lOP1NOJSSPYwY+yJxfdisInLm4qJVtMyQ=;
	b=CtUMvNRIyyS/yifOPG1yNXthPdQdaE2L47H7VBAhHq5uNGXTRpDjD5JF/pWUzeKGlsB/b7
	D78C9joVxO3je2yPHAyWNGoyXs9/T290VZdK2w61MDdbTlQAx4DAHwBlx7axWD+vbiRSvD
	nzvgqdvfGt1oYCIG6a/VzseduqZsgZA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-sIXYPNN8O_2OL5fp5oZ2pg-1; Tue, 28 Jan 2025 13:45:25 -0500
X-MC-Unique: sIXYPNN8O_2OL5fp5oZ2pg-1
X-Mimecast-MFC-AGG-ID: sIXYPNN8O_2OL5fp5oZ2pg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436248d1240so28387055e9.0
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 10:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738089924; x=1738694724;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q27/2aSdx5lOP1NOJSSPYwY+yJxfdisInLm4qJVtMyQ=;
        b=cykdvg2tICVJMzzf55eMQj97IK2bB72fLP+Q9iNL+0Sae/DryXIUDFcy8HD2MRiUYZ
         1QbFFH85D/1y7kx1N4r3OazCtSQ3iqm2I7PW/MK4gKEY9V+oDMkKefZYurADyTF9NlWD
         0GG6xoTi9JRJ4I4N6BiBxvSum4Kp3IlIkKxgc1iBB3GF2QDS2pNnSSLEtwE7BCfhu8oo
         5jfeoMnnql7J+1Q+EfCTlzOxidkly6j0VJFeByLan7HcroaUhza4iy4dEmtTd/Aqj7KR
         v57OdcFia4h16gPEW9ylKB9jkayXEDkJbiRAiYRPXencNOqFF7Y+zFki4igyCTzL5LPd
         9Saw==
X-Forwarded-Encrypted: i=1; AJvYcCXzvm2HxaFGkQVnSvMIDseLx2IpQAiBlk/4pkM117yf7XixE4MwBAp4BY3EQc4wfSubzIw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz26cMscb0nZTubD8cm3Y2OBQDyN/bFodCJ39U88LzPmPMIQqQ
	8BCg/LaUYR42WhSik4IMQ7QendYnPniZ6N4AKm59KsVmg4cb5p0s/OyA0zaDl/1t+gt2Cpwlt8S
	tfOZSYU32dBMmuT8EsKaoeiSQkS1k21hnMf34N30gERm9oH0Eaw==
X-Gm-Gg: ASbGncuwMGB8YhPJiKr1sIRbkHAAA/ZVy0umiN1U0Vbv49X3MR153+aarPUB18x4Y8T
	prgxuEGJ7UKPjOlaKSnrCViQGGl70Qcwg+C3/ksG5qG19WlSli/ZofnLjODeDmUIdO0n4dViiSl
	BXn9+u71usc86Yq9lasRoMKQE5f8Dg6VhiSrBFVvJaWkuG+8jxA1dwSrZSc3heC7jH/xo1Cz12j
	7LFZYnLAdu5iFAIbO1dI53Vz6mtrsJUTdBKFSMFLST38JHnUlufw4fooDhf++PlTbquR2pZNlRh
	Vf2azM6zMsvQgj2iYAZvYY7fKuLedH6eOg==
X-Received: by 2002:a05:600c:4fc1:b0:434:9d62:aa23 with SMTP id 5b1f17b1804b1-438dc40d296mr127525e9.20.1738089924275;
        Tue, 28 Jan 2025 10:45:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTtwo6F6zljjBDh6dKdeA1KgNaFsPiCxAmJFPUWRJvyVet/1WRthdnHf28NqFFYxVmTx10hA==
X-Received: by 2002:a05:600c:4fc1:b0:434:9d62:aa23 with SMTP id 5b1f17b1804b1-438dc40d296mr127345e9.20.1738089923853;
        Tue, 28 Jan 2025 10:45:23 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6662.dip0.t-ipconnect.de. [91.12.102.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd5023acsm179953565e9.16.2025.01.28.10.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 10:45:22 -0800 (PST)
Message-ID: <5dd69f1b-7ef8-4d4a-b7f3-a6f3a5db410b@redhat.com>
Date: Tue, 28 Jan 2025 19:45:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] accel/kvm: Report the loss of a large memory page
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-4-william.roche@oracle.com>
 <39b26b64-deaa-4c52-8656-b334e992c28c@redhat.com>
 <df085742-3a10-4a84-8828-15a4d3f97405@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <df085742-3a10-4a84-8828-15a4d3f97405@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> Yes, we can collect the information from the block associated to this
> ram_addr. But instead of duplicating the necessary code into both i386
> and ARM, I came back to adding the change into the
> kvm_hwpoison_page_add() function called from both i386 and ARM specific
> code.
> 
> I also needed a new possibility to retrieve the information while we are
> dealing with the SIGBUS signal, and created a new function to gather the
> information from the RAMBlock:
> qemu_ram_block_location_info_from_addr(ram_addr_t ram_addr,
>                                          struct RAMBlockInfo *b_info)
> with the associated struct.
> 
> So that we can use the RCU_READ_LOCK_GUARD() and retrieve all the data.

Makes sense.

> 
> 
> Note about ARM failing on large pages:
> ----------=====----------------------
> I could test that ARM VMs impacted by memory errors on a large
> underlying memory page, can end up looping on reporting the error:
> The VM encountering an error has a high probability to crash and can try
> to save a vmcore with a kdump phase.

Yeah, that's what I thought. If you rip out 1 GiB of memory, your VM is 
going to have a bad time :/

> 
> This fix introduces qemu messages reporting errors when they are relayed
> to the VM.
> A large page being poisoned by an error on ARM can make a VM loop on the
> vmcore collection phase and the console would show messages like that
> appearing every 10 seconds (before the change):
> 
>    vvv
>            Starting Kdump Vmcore Save Service...
> [    3.095399] kdump[445]: Kdump is using the default log level(3).
> [    3.173998] kdump[481]: saving to
> /sysroot/var/crash/127.0.0.1-2025-01-27-20:17:40/
> [    3.189683] kdump[486]: saving vmcore-dmesg.txt to
> /sysroot/var/crash/127.0.0.1-2025-01-27-20:17:40/
> [    3.213584] kdump[492]: saving vmcore-dmesg.txt complete
> [    3.220295] kdump[494]: saving vmcore
> [   10.029515] EDAC MC0: 1 UE unknown on unknown memory ( page:0x116c60
> offset:0x0 grain:1 - APEI location: )
> [   10.033647] [Firmware Warn]: GHES: Invalid address in generic error
> data: 0x116c60000
> [   10.036974] {2}[Hardware Error]: Hardware error from APEI Generic
> Hardware Error Source: 0
> [   10.040514] {2}[Hardware Error]: event severity: recoverable
> [   10.042911] {2}[Hardware Error]:  Error 0, type: recoverable
> [   10.045310] {2}[Hardware Error]:   section_type: memory error
> [   10.047666] {2}[Hardware Error]:   physical_address: 0x0000000116c60000
> [   10.050486] {2}[Hardware Error]:   error_type: 0, unknown
> [   20.053205] EDAC MC0: 1 UE unknown on unknown memory ( page:0x116c60
> offset:0x0 grain:1 - APEI location: )
> [   20.057416] [Firmware Warn]: GHES: Invalid address in generic error
> data: 0x116c60000
> [   20.060781] {3}[Hardware Error]: Hardware error from APEI Generic
> Hardware Error Source: 0
> [   20.065472] {3}[Hardware Error]: event severity: recoverable
> [   20.067878] {3}[Hardware Error]:  Error 0, type: recoverable
> [   20.070273] {3}[Hardware Error]:   section_type: memory error
> [   20.072686] {3}[Hardware Error]:   physical_address: 0x0000000116c60000
> [   20.075590] {3}[Hardware Error]:   error_type: 0, unknown
>    ^^^
> 
> with the fix, we now have a flood of messages like:
> 
>    vvv
> qemu-system-aarch64: Memory Error on large page from
> ram-node1:d5e00000+0 +200000
> qemu-system-aarch64: Guest Memory Error at QEMU addr 0xffff35c79000 and
> GUEST addr 0x115e79000 of type BUS_MCEERR_AR injected
> qemu-system-aarch64: Memory Error on large page from
> ram-node1:d5e00000+0 +200000
> qemu-system-aarch64: Guest Memory Error at QEMU addr 0xffff35c79000 and
> GUEST addr 0x115e79000 of type BUS_MCEERR_AR injected
> qemu-system-aarch64: Memory Error on large page from
> ram-node1:d5e00000+0 +200000
> qemu-system-aarch64: Guest Memory Error at QEMU addr 0xffff35c79000 and
> GUEST addr 0x115e79000 of type BUS_MCEERR_AR injected
>    ^^^
> 
> 
> In both cases, this situation loops indefinitely !
> 
> I'm just informing of a change of behavior, fixing this issue would most
> probably require VM kernel modifications  or a work-around in qemu when
> errors are reported too often, but is out of the scope of this current
> qemu fix.

Agreed. I think one problem is that kdump cannot really cope with new 
memory errors (it tries to not touch pages that had a memory error in 
the old kernel).

Maybe this is also due to the fact that we inform the kernel only about 
a single page vanishing, whereby actually a whole 1 GiB is vanishing.

-- 
Cheers,

David / dhildenb


