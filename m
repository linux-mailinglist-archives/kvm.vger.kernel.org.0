Return-Path: <kvm+bounces-20182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F70B9115C7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 00:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70C18B21728
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 22:38:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF92913FD86;
	Thu, 20 Jun 2024 22:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZsaEMas"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27A464A98
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 22:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718923108; cv=none; b=cdQbj8SLLc5E6PB0aDD+SLS2GK4e9lJRywNXQDU2fvDXSp5fq9QveMuOtRWRdl9rG290KW9mGyUFp4jGzGEEkr4Ow6e1Yn+cCQzl4pTltuz8gggp8FtuWn0/j0DdvC6I0qsNAvzvqq7j0ylqvg6tDVIZvNRgcyzTWQJsrYF9/fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718923108; c=relaxed/simple;
	bh=VOuCa+MPCCl3givMRzpSCjpRslsZff9GQepro4NAr6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PG3drWA2ydERmeQYhTDHRfRVt22iw8DIJgBfrG0ma8LIzw8jElK8CK/FiFkTT4PVEcjHj3sMA8nqaCxeuMK2cRsyxSec1uZyRFjHmVQCFChUOsFSINpMgokySgUkDg17UDliWBUbvqU2PYslskNbnfVZTVw/aO6G82jN/ScDTjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZsaEMas; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718923105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=t8D3dmzG19niJdL2hQsK7/5l5eZyzfyE93p8lztrR+c=;
	b=KZsaEMasP4NBT63ByNlHpO1tMyY+VKkSdHpXRRmvU2Zj60YZrQnP6eMQBnUcMOYUAQ3HX/
	TdowX61ZMxd0rS8dXMxDOAoydF6yI0tlgQ7zXBgqArv3eRdMSHGNQsV7/43WIMIGbms/2T
	1CKQcBsriZSiR/7HulSD3g+lYqSCSUE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-wE77e-i1PqanVibPlUJHdQ-1; Thu, 20 Jun 2024 18:38:24 -0400
X-MC-Unique: wE77e-i1PqanVibPlUJHdQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3643d0e3831so976857f8f.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718923103; x=1719527903;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t8D3dmzG19niJdL2hQsK7/5l5eZyzfyE93p8lztrR+c=;
        b=UifQiFMs7Wy2gDrtRz7ca8PrW/uhD3HgXFce+csMXr4fNTx+cG0gvhrqZQxJBZZsft
         dfDdSdoqcRL/srX7K2aNORD7rcES7w6NbW4tw2O3YxohRfqeXfXlyDbbz8B+ymaEBC4h
         jSRLkfWNecroFVfqbviwZjoviBFknvNHwQGbvZ0QzhSTB/9B31lLLd1NIk5OJcuyfdeM
         AVkBFbhjmYPfYX59G8Z5P+19AMil4YIKXavMXPqA8HNVO0BXud35pMMwQ48q+TOd7WCH
         crOKg7r53u2FtH8nFtvua6KxUVBabmABN6NyA6Pz2OioqvNTi2spYv98WzzVC+iaXmZD
         S7sQ==
X-Gm-Message-State: AOJu0Ywe27qg2/rZgu0JvcZLB9lWrr2BSO4uXTVq/ICBH8dcYkO36wDv
	B6g63T40OLlZNvvLuwBW8Z6NuZd4UyMWGBMShDurjzoxrwbJ+JgBp1F1MdPIXp7pc83U1W26r8h
	Y6qIeDGO2ktATFJu0ATGS0iEsrxyU6/B3SrTdggYxwNW4AJk9lQ==
X-Received: by 2002:a5d:452d:0:b0:355:230:e2d3 with SMTP id ffacd0b85a97d-363177a3d04mr5005665f8f.20.1718923102930;
        Thu, 20 Jun 2024 15:38:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpv8Gz8XlnT3+hH/f//Vbpx5NsdgRvBQ/T9v2WZfpjdrlEaO0H7Ue+ITy+SKzENggG57KoxQ==
X-Received: by 2002:a5d:452d:0:b0:355:230:e2d3 with SMTP id ffacd0b85a97d-363177a3d04mr5005659f8f.20.1718923102557;
        Thu, 20 Jun 2024 15:38:22 -0700 (PDT)
Received: from [192.168.10.81] ([151.62.196.71])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a6fcf5605aesm16068866b.151.2024.06.20.15.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 15:38:22 -0700 (PDT)
Message-ID: <45dade46-c45f-47f0-bfae-ae526d02651a@redhat.com>
Date: Fri, 21 Jun 2024 00:38:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] KVM: x86: Ensure a full memory barrier is emitted in
 the VM-Exit path
To: Sean Christopherson <seanjc@google.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Yiwei Zhang <zzyiwei@google.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240309010929.1403984-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/24 02:09, Sean Christopherson wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Ensure a full memory barrier is emitted in the VM-Exit path, as a full
> barrier is required on Intel CPUs to evict WC buffers.  This will allow
> unconditionally honoring guest PAT on Intel CPUs that support self-snoop.
> 
> As srcu_read_lock() is always called in the VM-Exit path and it internally
> has a smp_mb(), call smp_mb__after_srcu_read_lock() to avoid adding a
> second fence and make sure smp_mb() is called without dependency on
> implementation details of srcu_read_lock().

Do you really need mfence or is a locked operation enough?  mfence is 
mb(), not smp_mb().

Paolo

> +	/*
> +	 * Call this to ensure WC buffers in guest are evicted after each VM
> +	 * Exit, so that the evicted WC writes can be snooped across all cpus
> +	 */
> +	smp_mb__after_srcu_read_lock();


