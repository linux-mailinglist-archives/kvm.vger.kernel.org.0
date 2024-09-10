Return-Path: <kvm+bounces-26327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE359740C3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4199C1C25963
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFE21A4F20;
	Tue, 10 Sep 2024 17:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ewv4p/TI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D011A3BAF
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989768; cv=none; b=bA6vwE3QZVQafcpCTSYkaJbR0Ta9/eSWnkTeoqaX7/PCVrBrcuX8YaZNIK2Bsej0RQnTtgsTbuaOW9XyNmadnvtAB2UMrVLcdvUlxq55xQkc2Ba0U3kky9u0KwtH7K/uLN4fs/0U6gISg2NGacycv9nrAz2XfpFiBd2718pDHd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989768; c=relaxed/simple;
	bh=gGmwWNkb7X9IcLdAb4i6xtsiWbKqXSL8gjAYa5ULFDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzRnQw/4/I/COR6fO/KUt5XYNf1xvFbORu7O+0kDFEo5g02A+wcFA8L9tfkXA83elM0Yp7EDuRc2RDk6i9nNXcRovh7JB+AzNBv7tD7h58XNyv+kONXp/eS5mUdpvhieXYv+5j7unlDevAxVI2LtGgjIS3lUAjdTrtH19OZS1+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ewv4p/TI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725989765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6j+AAlTwoPTrJSZ2EtbnnKh435cb2m9WmbTK55uDcrI=;
	b=Ewv4p/TIAxI42FBXLTdVHTg86To3798ZBfE9CCruQ1mzRIqxj71K2MbZ/mIOU0pCJ1B+ry
	a/wBU/NjZvrxfw3o/UX1XVE0bJhBOcT3PjeaJgU8dls4qBsJHF45GSFqOOh4khqaAUZepJ
	gGwM59AfTsavGOX7L1ZMcTjOSmmVwcI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-48Wh_RJCPfSGGpRBgE9tnw-1; Tue, 10 Sep 2024 13:36:04 -0400
X-MC-Unique: 48Wh_RJCPfSGGpRBgE9tnw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3756212a589so3920100f8f.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725989763; x=1726594563;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6j+AAlTwoPTrJSZ2EtbnnKh435cb2m9WmbTK55uDcrI=;
        b=YDTWixv+VXrtJYuLd7Cfnbpm25bGUtRltgBCQIJ87GzKDYWFfCbY4hF/E+wQnjetS+
         57v0VulI2kVkgs1vriK1cZ0YWTFCIKDhNTYKh5uDUuK/QNvaStgBw7o/DHMX/8uIKTZI
         nxaVSRdhL48+MYrijZRnSIiLUre0BZzZkOtz2PtuZJp0qqLETSJLh3PWUcRPhuARGU6s
         kPW5ytNjswAgkcSML83ORZzeKqP9310+O4QCkR4+rqo9vCAyAcdgHWNaqulEYuw1PsB0
         CkH0Xbuv5Skx6wg28fN8YLl1mn68xqG6JegPkLcKhbmWlzsMkLE3QLvyBOqbHaLXKEV/
         TcRg==
X-Forwarded-Encrypted: i=1; AJvYcCWncF9jI/lft6sKPgZOz2WH4FbNbPhnWm7HKpicVDRD5fIjs5uEwvGPTN3a/niH5Hpw5n0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzcENo85cHk2CpgtJdPiHpeSWwJO7zYb9+FaARjoE0WVq/lNcd
	Dtjfv6aBnT5k1XkDMgBnPKIsrjWlWyCaIh17CLNZmWzjUu0EQLmQxBlTTv1+jVyr9ib+IFRApki
	ye4omUpbUad6jOsMaorXxsl+hCPzod5zoe02DYCZBI6VXCmQVrg==
X-Received: by 2002:a5d:66d1:0:b0:376:f482:8fdf with SMTP id ffacd0b85a97d-3789229b089mr8893662f8f.4.1725989762927;
        Tue, 10 Sep 2024 10:36:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1ul+JVf5qzaHHD427uksE9QrWJzIkCDQbnRTeJjUVJVl9CgbYtaENlX0I+ODWQwym3oyjJQ==
X-Received: by 2002:a5d:66d1:0:b0:376:f482:8fdf with SMTP id ffacd0b85a97d-3789229b089mr8893642f8f.4.1725989762449;
        Tue, 10 Sep 2024 10:36:02 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37895665762sm9498696f8f.45.2024.09.10.10.36.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:36:01 -0700 (PDT)
Message-ID: <dc87af84-d531-4938-a525-9bbbf7d714ec@redhat.com>
Date: Tue, 10 Sep 2024 19:36:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 24/25] KVM: x86: Filter directly configurable TDX CPUID
 bits
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-25-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240812224820.34826-25-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> +
> +		cpuid_e = kvm_find_cpuid_entry2(supported_cpuid->entries, supported_cpuid->nent,
> +						dest->leaf, dest->sub_leaf);
> +		if (!cpuid_e) {
> +			dest->eax = dest->ebx = dest->ecx = dest->edx = 0;
> +		} else {
> +			dest->eax &= cpuid_e->eax;
> +			dest->ebx &= cpuid_e->ebx;
> +			dest->ecx &= cpuid_e->ecx;
> +			dest->edx &= cpuid_e->edx;
> +		}

This can only work with CPUID entries that consists of 4*32 features, so 
it has to be done specifically for each leaf, unfortunately.  I suggest 
defining a kvm_merge_cpuid_entries in cpuid.c that takes two struct 
cpuid_entry2* that refer to the same leaf and subleaf.

Paolo


