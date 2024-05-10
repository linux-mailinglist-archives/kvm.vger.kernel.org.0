Return-Path: <kvm+bounces-17200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1FB8C290A
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 19:04:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1FD28303D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F0FC17C7F;
	Fri, 10 May 2024 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhC9e1dy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1441B17BA3
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715360641; cv=none; b=Z8eD8YilQ4XAy00zrZ0bskVxI9go/v1S2FSWCzR7jvFEa42HjVR0/DDmSittef4nCYvOYO2x2I5jDwJbrpdXbMc8+ViSu5PmFf+BW0PllZ1of5hV6Lzhhz9M9V+rYb2WsQXemX/RfdhHRfqCkW2oE1x/H6fFReWYqMkTahczdv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715360641; c=relaxed/simple;
	bh=mrAxYLN7YaKXLmK0pnZRcR4iGVsgpjNfTJqetsyp/K4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FtVgdpnSsnd+gfYgnoYpZHchy5Lqx5TkVmbnppXpiaHy8e6PVK0w/KZUWPhjge+Op/268a6Fm9a8m+LzCkeato2OaUkilK9GRSLBlK56jIox43JzraAQgrjOMjodgDPfBjwTYS0M+s6IHYn5CD23dOz2jXAscNCLref/UqlVE+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhC9e1dy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715360638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=f7sEcl6o9eRoGhOwSAHXKaKKxu23m+YNGmYQyYZJgpk=;
	b=HhC9e1dyNtfVednlOLVMrqhSWL0lfs0aKvXpR7BasFA1zARYnB6JW+yTS9mKduwP4Tsg4t
	GXN/gCwBaq9l3IgWdgATH5o9zN7MYWRTzUQoyuHo3ZAcLpKQeylH563L3TNsvEx52yKwx8
	dX7DOwcEz60Jd2oeK/RZFFOZGQ7eGC4=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-uwNkp6hyN3eHdpQ4hh9AWw-1; Fri, 10 May 2024 12:59:42 -0400
X-MC-Unique: uwNkp6hyN3eHdpQ4hh9AWw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a59cfaba975so76563566b.2
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 09:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715360381; x=1715965181;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f7sEcl6o9eRoGhOwSAHXKaKKxu23m+YNGmYQyYZJgpk=;
        b=GZ0VXHYIptvk3hFHHH1klnYUjJtpAgzR5Coo3wRIUOuP9snmaFk5VZcnkjd3JSE/yO
         3kV7wx6jQZoXzyKyaqXs+gKN6s/ZaRoImAFs+u/0JVCmiIo3c1lwmU6QDoFzf412Wlzx
         kBdEkYOslo+D2UJIL7j3CFdUaTGBBeorCLoGn/HTdfXV2QElg5rjpLAIA1J4EhkTA9lg
         IiALEY0Z/4slTOAqbw1W5+rMw9oWDYTddVvJybk7D03Dpqh3dpysNt3uYAnamJG4rGtw
         Oyxn0maJs6DTsJftEQCeMFecwCTZO9iadTs9UEWM3txPNGxqzPfTy9ynuZULfSOcSWvP
         xEAw==
X-Forwarded-Encrypted: i=1; AJvYcCWu9gIo5k866CrNZKPtZxmC5VEHlOsXdVvu31v/UKWclkfla1VgvNqsO+f15u7/Hjut9MOG+AUxGvfrgwWGVj2HR7yX
X-Gm-Message-State: AOJu0YyT5m0TA5FeJrwSS0MadrRaDa15Lmh+7AmYKN9FqktMZfeeXrJ3
	nwF4iPNc2WqnhBsTnptkYiIBd3AQvHX9eDNQwvZNb8ByZDOB81VQoWYLgc2TZYw0EiWcFct8+GG
	7V50TENS8MwMnPE46KmISE7VS3vRL8Ia7iqddoyXNN3GXQAFeYw==
X-Received: by 2002:a50:c012:0:b0:56d:f3f3:f61f with SMTP id 4fb4d7f45d1cf-5734d597da8mr3087112a12.9.1715360381264;
        Fri, 10 May 2024 09:59:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1NRP6cZSOa1XYwX9+D1CVHmUjYsL2urgesJf7rD62GMtL4OAvAaffXB16L2Ce76IP/7uSvw==
X-Received: by 2002:a50:c012:0:b0:56d:f3f3:f61f with SMTP id 4fb4d7f45d1cf-5734d597da8mr3087084a12.9.1715360380864;
        Fri, 10 May 2024 09:59:40 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5735a2490casm559601a12.32.2024.05.10.09.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 May 2024 09:59:39 -0700 (PDT)
Message-ID: <a47e7b49-96d2-4e7b-ae39-a3bfe6b0ed83@redhat.com>
Date: Fri, 10 May 2024 18:59:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
 dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
 peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
 rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
 vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
 tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
 alpergun@google.com, jarkko@kernel.org, ashish.kalra@amd.com,
 nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com,
 papaluri@amd.com
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-2-michael.roth@amd.com> <Zj4oFffc7OQivyV-@google.com>
 <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
 <20240510163719.pnwdwarsbgmcop3h@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240510163719.pnwdwarsbgmcop3h@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/24 18:37, Michael Roth wrote:
>> So, we're... a bit tight for 6.10 to include SNP and that is an
>> understatement.  My plan is to merge it for 6.11, but do so
>> immediately after the merge window ends.  In other words, it
>> is a delay in terms of release but not in terms of time.  I
>> don't want QEMU and kvm-unit-tests work to be delayed any
>> further, in particular.
>
> That's unfortunate, I'd thought from the PUCK call that we still had
> some time to stabilize things before merge window. But whatever you
> think is best.

Well, the merge window starts next sunday, doesn't it?  If there's an 
-rc8 I agree there's some leeway, but that is not too likely.

>> Once we sort out the loose ends of patches 21-23, you could send
>> it as a pull request.
> Ok, as a pull request against kvm/next, or kvm/queue?

Against kvm/next.

Paolo


