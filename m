Return-Path: <kvm+bounces-36055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64244A1719A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 18:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D3CC1887560
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9DCC1F3D29;
	Mon, 20 Jan 2025 17:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/36/Rce"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A65D1F2C2C
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737393707; cv=none; b=u4gkJmLYSO9fIiZzj7zvgfYTiFbJzsetRk5L+Lzb2xsrnLqK/aF+FKXM312R53wJUsWwCZlOQm5RSMl2PLOTnWVOHhNN8yHLuDCztT58Sxg7yoi+NVqq6yrcFhHLFEdTcyXvWhHO1bSojt+NPPGzcEyTSEgAtiQFTIvVgf4VdI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737393707; c=relaxed/simple;
	bh=kABN1dQ317fVEIHE8xhZAMiyvy8Xu0KwrWWtSJfrY9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inNjHM4jD88pXnVmmraWXzVQiPwMqY0YzIVuVp7twbG8OkyyY/07XG1GlGypFYhw/muq9ikNAyBGkmC5Lc3o0Em01PX0cj1Uu0MytKN+G8cA2+Xg/3hCdk18beLUjGz40bCLo+MDv0nm0GKr3nRQ4nh0ohsOpAY+dzjS2wPzmuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h/36/Rce; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737393704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mL5KsaA+J8HX4kylTc2rxPJqKAL2zEPRr2dApSOjV78=;
	b=h/36/RceN6+DKT1oBwIuYG34vLzXv4T8zuVBkR3Ea6Qo3p6Y5ZMUyJjbHGgifztBnRy8Q8
	API8DBVNoth6JVU3ETwfppX2zEPRvd/wJ5BB4s2cT3yhR6IaBsu/SHZahgLvHrI/Bs4vHJ
	pGVCaJcxYKqSKM8Zor2g/RayxqTtqFo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-56IWmy31PYm83OmbDa6ATg-1; Mon, 20 Jan 2025 12:21:43 -0500
X-MC-Unique: 56IWmy31PYm83OmbDa6ATg-1
X-Mimecast-MFC-AGG-ID: 56IWmy31PYm83OmbDa6ATg
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6eabd51cfso763775085a.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 09:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737393702; x=1737998502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mL5KsaA+J8HX4kylTc2rxPJqKAL2zEPRr2dApSOjV78=;
        b=u7/S8dg2HFHx9KMfA8/nlM1CQR9FWpKOjIdLkYn80Y0oxYOlc7J5uDkV/Rygl98q25
         WcsdwjHrIMEVNeBBDCQ7BTZ0pKQseQ6kSRVLvexzPjklrpJuFONTZVuFLV6xduCusmSj
         cPdrG0iSXtqTICOk4LNU263dywKXU8jFkY2tYdoGvBAQSKrtnJSld/eMwlUvQFpOob51
         YbLYlrNtlZ+gSznLL3JUkL1fpbkExL9c3/HKN3WF2jp0foeQZAfph2ZN/mHWbUFyD0v4
         5kkoDEKT13KNULV61iiaJagf+2Z3tEct/lgNm7UNcDKjOotD7FgJkh61/P3PiD+H+p2Y
         OrkA==
X-Forwarded-Encrypted: i=1; AJvYcCUvvmvQIdVZIYK8aTy0JKugFxXybis6oXb4hkkZ90YP99Kwu17DcSrTYz6yfx2aFdN1FfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2av63GZ4524lfmbuiygd6iqAZBRlY2soA1/HW9XTU5tAVNp17
	Wl9DQBmXD3RBRrnEI37hCtKfNxl8s/7Mk2gHcPG8pjIOLNjOQwCod01I2J3LcXR5dhjxUuXOEcN
	rBuHQBWiuC6STIett2ymfZBdYhyia4rfZtdl807USc9sxqJKRSQ==
X-Gm-Gg: ASbGnctoxFC4SAVyLBM9OSpCwZnECVuQXx5lz5IZ/eoshoMY77iWErLkW6aX7Q4pkVy
	Mpt6TrqN8HzcH0/1mAiHr2VCFIYCLWqJecLEVHfuoj/fr9E6lvP5o6gHAT6me8f89HCC23oz819
	K9mTvlHnULrJPX+vKwHbP3NIyUFS2d/fwzgThlry0u615uV60l7OB81YIHCaVWBoSpDSCvrM4yW
	X63aENEYBhj0wlDK542HgDBn90x8AA3r1Knj9osSieiWBKgjDHgdq+ePyqLuOHAsYO0VuYRoChc
	WSwVPg87knRZ/um9K9SiIlNl9J/uLxA=
X-Received: by 2002:a05:620a:2985:b0:7b6:dc1f:b98c with SMTP id af79cd13be357-7be63287f05mr2040738085a.52.1737393702404;
        Mon, 20 Jan 2025 09:21:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFNnJpd2iFAed03FBPaakMpDwUqsmMGvP5/UDmNrC09ir6dHFykZn418+CNUIU7gSz32XVIQ==
X-Received: by 2002:a05:620a:2985:b0:7b6:dc1f:b98c with SMTP id af79cd13be357-7be63287f05mr2040735185a.52.1737393702117;
        Mon, 20 Jan 2025 09:21:42 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be61486925sm462496585a.54.2025.01.20.09.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 09:21:41 -0800 (PST)
Date: Mon, 20 Jan 2025 12:21:38 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z46GIsAcXJTPQ8yN@x1n>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>

On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
> Sorry, I was traveling end of last week. I wrote a mail on the train and
> apparently it was swallowed somehow ...
> 
> > > Not sure that's the right place. Isn't it the (cc) machine that controls
> > > the state?
> > 
> > KVM does, via MemoryRegion->RAMBlock->guest_memfd.
> 
> Right; I consider KVM part of the machine.
> 
> 
> > 
> > > It's not really the memory backend, that's just the memory provider.
> > 
> > Sorry but is not "providing memory" the purpose of "memory backend"? :)
> 
> Hehe, what I wanted to say is that a memory backend is just something to
> create a RAMBlock. There are different ways to create a RAMBlock, even
> guest_memfd ones.
> 
> guest_memfd is stored per RAMBlock. I assume the state should be stored per
> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
> 
> Now, the question is, who is the manager?
> 
> 1) The machine. KVM requests the machine to perform the transition, and the
> machine takes care of updating the guest_memfd state and notifying any
> listeners.
> 
> 2) The RAMBlock. Then we need some other Object to trigger that. Maybe
> RAMBlock would have to become an object, or we allocate separate objects.
> 
> I'm leaning towards 1), but I might be missing something.

A pure question: how do we process the bios gmemfds?  I assume they're
shared when VM starts if QEMU needs to load the bios into it, but are they
always shared, or can they be converted to private later?

I wonder if it's possible (now, or in the future so it can be >2 fds) that
a VM can contain multiple guest_memfds, meanwhile they request different
security levels. Then it could be more future proof that such idea be
managed per-fd / per-ramblock / .. rather than per-VM. For example, always
shared gmemfds can avoid the manager but be treated like normal memories,
while some gmemfds can still be confidential to install the manager.

But I'd confess this is pretty much whild guesses as of now.

Thanks,

-- 
Peter Xu


