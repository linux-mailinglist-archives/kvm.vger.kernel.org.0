Return-Path: <kvm+bounces-27542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A739986C67
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 08:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5114B251C7
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 06:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C155189913;
	Thu, 26 Sep 2024 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H2LOkvf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CC5178397
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 06:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727331684; cv=none; b=R4N8WCvwQeBHSx0vQh550mSOVHwrv6Ey6rkSqCefRItFQ3vpyqqV0AoBCqMH748DcWH5a4cw8Cfl8hw0bY5qODDYxP4KHpjprsya8Ujrd2E2RtEfqwIzF5/xYrJF/WJz7zJbB+EGx2ji4x7gQylWgjTFmrJTl+5wdKq4UNjSJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727331684; c=relaxed/simple;
	bh=1pLxbC8I7m5jJNxnqEC6sj7C1ca8cV6A29jVK2+lQFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f2UP71Ur2o8jUsfP8Wqh9Rlv5X27wYmkrRPi0G20QNWafVEZ/nmL3QJKtxe8Zp/OZF9NBrm7DgHniIxflb5a62g1jKKdNm0ywBQqa669WJd8Re5cpo3JtcseFulmLHLR3k2FB/RVCV5o7pDWdxsjAi6gq92y95U9mnpmQ3TZmVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H2LOkvf6; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8d29b7edc2so68408866b.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 23:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727331677; x=1727936477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oYMCwkQPVxKJ+cMHOHVL5c+5ytaGE64SeE8g5ixOBss=;
        b=H2LOkvf6723jQxMkj0NU2J6eql+i7LeBQKQvCat1N7UMPIXKjsNbUWeeW8xqmLtalZ
         NZ8rlt+785Jqhuc12DOF0JjbBzQaR6PD718oHoOfWD1ZsxdlKQtOsPT0B3YLuP8/4/2T
         n7tgZzoebTKdVmEbXKqTnqSsCs3V5/jdM0SfvylZf15iABMHkpFm3vfEjNizE+95QqTH
         yt+L22pElkbXqpnic8SBF9ElsSAiwtEU7NkRrkHEXcY11CMpnlu1waIQ6fflEd0bKWqZ
         wKsC5itTeWWkz1iT0fAixEHenRgtdobaFuBIxfPoG4D6s+f0OYURqbGs10k46QBrBAHS
         AxTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727331677; x=1727936477;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYMCwkQPVxKJ+cMHOHVL5c+5ytaGE64SeE8g5ixOBss=;
        b=U2hmHiHbED5g4Tk4rOK+a6ywID+R0m1M0u5WRhGzgWk8so4wjzsxv30K+RlA2wvr3U
         fCKUk9IEjmcflwkm8UBSL70cxdHGx686s6nfYdingy62q7cTphlYhVbVTByFJll2Ld5A
         rvZiKlbwqpPjWTqTjj1AHsDsR9DxKj3KovebVLZ89UnodESDuLwc/9sGkWOBONhL/8w0
         H7Q7PxJmWGnVQkOyiHmDxSrklXUPut5tVNGwZ8fp4/XupFeo8XzXipruzzw02Djkp6T2
         HvNSmz4HayfFCoEj7iOx9APxNUDoCBNbz3pNvq3++bgqpy2Gm1MYpAmCtQdY73Kg29oa
         wMQg==
X-Forwarded-Encrypted: i=1; AJvYcCV5pzATncAcJJpsGnqoxa5QYgAzKTZKlbntAV3yYN92xjdS/7Ox2wHpbWesjVG2NDAJeQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz840ErwCxAcd8ZRAgKyUxuQsBUYsoUlqEjU/B8u4LD5ElZHQpF
	z2a1Boi062/MZgtJgFulpFzMktibMNCrieutLYyYBfE0jIfjgIUFKEWcOeC6b6E=
X-Google-Smtp-Source: AGHT+IGq6JdSzSznwPxVPi2beVS6+2KfvKJjCPl73nGi+bdpGccswpYOVUmzs63z0PbobAmD2I0QlQ==
X-Received: by 2002:a17:907:940c:b0:a86:bb90:93fa with SMTP id a640c23a62f3a-a93a05e7e73mr470458966b.44.1727331677393;
        Wed, 25 Sep 2024 23:21:17 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:75b8:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:75b8:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9392f34076sm308151066b.7.2024.09.25.23.21.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2024 23:21:17 -0700 (PDT)
Message-ID: <d8351d41-b7ee-48b4-a11c-5d1cd7f39ae2@suse.com>
Date: Thu, 26 Sep 2024 09:21:15 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/8] x86/virt/tdx: Start to track all global metadata
 in one structure
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, adrian.hunter@intel.com
References: <cover.1727173372.git.kai.huang@intel.com>
 <014302e0bd2f0797aa7d27ed8b730603d2859c2d.1727173372.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <014302e0bd2f0797aa7d27ed8b730603d2859c2d.1727173372.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 24.09.24 г. 14:28 ч., Kai Huang wrote:
> The TDX module provides a set of "Global Metadata Fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sys_info' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Classes".  E.g.,
> the TDMR related fields are under class "TDMR Info".  Instead of making
> 'struct tdx_sys_info' a plain structure to contain all metadata fields,
> organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the construct_tdmr() can just take the
> structure which contains "TDMR Info" metadata fields.
> 
> Add a new function get_tdx_sys_info() as the placeholder to read all
> metadata fields, and call it at the beginning of init_tdx_module().  For
> now it only calls get_tdx_sys_info_tdmr() to read TDMR related fields.
> 
> Note there is a functional change: get_tdx_sys_info_tdmr() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

