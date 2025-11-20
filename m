Return-Path: <kvm+bounces-63888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 655A8C7589D
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A074B354504
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:03:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB59369983;
	Thu, 20 Nov 2025 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QGXBS62n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124935C1B1
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 17:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658174; cv=none; b=gYfm6zm0myevun4TVKf8gmguoVaDRuDtR/q8whoHcUpUBxE+wg/prpXFmDisNKiKbS4H8q7Q7sn2aroz0e8I9o9NEDbVkf7PF5xcZVtddvOmJxD8lChDk8WYP49t2i2Hdbq4+AtpATg8lxSlE6w6CLnEA4cCa/8Vl2KQI0X4qzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658174; c=relaxed/simple;
	bh=prnoehSyj4m8ypO0ivrszk1DyMOfH4hAFqfn8XEJ2c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vx+P1cgqSGdPC2kbb0QHnDnl4hnMbOBopqzJcCSZ21QnwlChXPa9Rs5fg7Fpmw8tCgXEuuXe3/9cYS0FkBg4Tyi44aMiX4lK/rpcGNFGw7+SaqIIfGRP9iwaZ0k29dHaRUtVUeRVChhWvFU1xsW0aYoQiFe3hRXa/Dg82D/5UBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QGXBS62n; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b73875aa527so181773366b.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 09:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763658170; x=1764262970; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Bl+OC1MiS0Cnn5dK6DVLMuhKkpdCxqrqbBE3OQ+sZDY=;
        b=QGXBS62n+9hDnoYjPXt7wMVsJeNOLQwYKmJRWiv4F5hLd7EnIkvtYoEQaRqzZG17b7
         iLyRLu7koBWukLnLTKH6cg1A0ckn7P6myQ5flYekT6z8oHPrqbPeDfq+3fyNEEvvSASA
         AVDPNeuHYASHm5bkSMVns6yksC/niVAR+6RLeqSzPKzmn/Pn9986uTwRSyh30ASlyjy5
         AciGI0sETCa+uBpz9xrKCjMCXzEvAzYsscFxrQBOHT7But+Px6f40Eo8qiahe2ennkXh
         PrZv3LQ5cUWbHEZGEVjzV5ekZhQYbIOgqBNo0KF+vZjs4aFR3XNBNXRF8jd4/bF56yVq
         qWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763658170; x=1764262970;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bl+OC1MiS0Cnn5dK6DVLMuhKkpdCxqrqbBE3OQ+sZDY=;
        b=qnzIOChgW0b3gPPPAGJ/QgWfnm+tAyPUSVNHJjFWFl+7jROzPfo1k1kIZqA2Y+VbMG
         tJ4QsYWQSevlY52twQPDPvDtlOqaccIqy7SqzmX+1imlh/o12vMh6OhQrnLVxDcoLkTc
         Djow/b/RdGOaKrcd3r1/Gu2MmrTUNQS6gtrmlW0CCU/PLqdO2GMZp1JWHRYy5cyXPY82
         NrsxXAcYotzl3FbjnZr+b/Ikhc9l18RQglJV0vBszhlzM+SxRaDWYBzOykBkJSa3bEbw
         Pt+mVgIfDR8I01LO9asV96anbw2KgFLDZrhBLoBEAVvDPhJjv7KHVuuEiPYgels2SbQ+
         tYhw==
X-Forwarded-Encrypted: i=1; AJvYcCVfIn5VX09wAAWBVUvE/m87BOTEguUTK2jMuuFvSgoEcHdsPtzfGTe1FOo96o98Mrls6ws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxetMw+JB4IxhSCohIU3sZJiWP1qOljRAUf/+9zVfA30MPPLx2L
	0+Pdhf/85Xynni0fPeV8IUs3TyHLWjULE5641inO1bLOGMRlmdJOGwyqWIliKw3+S38=
X-Gm-Gg: ASbGncsrFU8GPsSrMIaQOAohZm/7emCEh+jcxVupT8EVzdeR/yzqA3enYy3UDzHbwom
	T8HFAh2GhCMj65eBjgSqHtTHXjQ/p7QY0ytskf/wdkEIgOzFVUhx+h/s3iPXJPKi8NAdfe6YjGD
	PUSnaLOLVHw7may3apU75SQFHEVWbQEHA2dcpg+5fiZ6eTeDPokoCeqTztswpl8yuTBx9qPjLC6
	X5hjoQcrm01mg6wipWx2DZR1esD/5Jwju70Wjdet/iHHH1SZf351n+4lxY2qeNeFVkr+vFgm0zj
	3HTR70FsbeDi51n5z/d2fs92CY6TmH0LTbZenV5wV9870G0SCkiQurlmtotuVhS80uKF7D9YR1g
	SozKiCxAcarNSe5rVQQng01ASr8GLBvWEvU+fLZ8uqhUYWjKLKRFrR9KRK2lZh9WX22Dnk5mx8m
	T3jmcX2OaO3jjT2KtWyzumZYqc4t1AKYo+Y8Je
X-Google-Smtp-Source: AGHT+IHxRCGNYcYOTr5xQ+EnAVFmCGZq+XQp/LseGIfeRHCydH1yH/nxDz4v0W3I70bpR45uWAt9Ww==
X-Received: by 2002:a17:907:7246:b0:b76:4c8f:2cd8 with SMTP id a640c23a62f3a-b766ac652eemr23630466b.55.1763658169851;
        Thu, 20 Nov 2025 09:02:49 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654fd4f14sm242168366b.35.2025.11.20.09.02.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 09:02:49 -0800 (PST)
Message-ID: <7a9f0bae-9a5a-4ece-ade6-68a6b01d4c68@suse.com>
Date: Thu, 20 Nov 2025 19:02:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/11] x86/bhi: Make the depth of BHB-clearing
 configurable
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-3-1adad4e69ddc@linux.intel.com>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-3-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:18, Pawan Gupta wrote:
> The BHB clearing sequence has two nested loops that determine the depth of
> BHB to be cleared. Introduce an argument to the macro to allow the loop
> count (and hence the depth) to be controlled from outside the macro.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

