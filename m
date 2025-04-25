Return-Path: <kvm+bounces-44317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA518A9C9B2
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C3CA3BA28C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0925C24C08D;
	Fri, 25 Apr 2025 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOK/qVWD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847BA24C084
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585851; cv=none; b=U8L4PQvXatPjG/rwxxIkCemtb62u56xHlotJvuaDcep5HhrJvOWKwKYnW3KsatHkmCVJUobJKnFvc8WeZ4SXd17Ifx4xLXTBD4HA2bFcj2zurSa43UeTuK9EjrBpUHK1e/5IGJo1u2rX/2EHUifv9jR7nhq7m8TwOOjzLC5ke+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585851; c=relaxed/simple;
	bh=jCuihx5BPqe/CTf/k4Ai2H3MDHgCOWeMLVcdMXVoUNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bmyow8RC5bHNtLF598KrVeIRM6KN1h7NIsRDusks4qTLurEUMvdvvu4ZyO/yWzkxpGD64ZewAiTkRaUcbRaf8UqkCVMDz41AFVm+46w5ehJMg8VKj+WC8o5bEuq3hUP0l+9gLdlp0TP6FpuZN8Ua5VBoYQNhlni7gUM9hv9z4xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOK/qVWD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745585848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=h58LUJy8iPHhq/L+pCKUO6w/IzaNql/KMsgP3+Af0xI=;
	b=HOK/qVWD9xxSmQE08bRPw2j5nWj7nFGx15SDTfTeR8+w1o8chUYwTWMppY+rNu9R9dp/pU
	NDaK3IJtUMrqgglmabzJVSmVZ2Zbdt4a2m5Rj7AfQ2reKf9NNDhxlNpQ9Hm9l0BhTOBAgP
	WfV6fiA61EI8KdWr7y3ZTNl3fJKzWWE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-LOWwgHiUOAW6WUzAa0E4sA-1; Fri, 25 Apr 2025 08:57:26 -0400
X-MC-Unique: LOWwgHiUOAW6WUzAa0E4sA-1
X-Mimecast-MFC-AGG-ID: LOWwgHiUOAW6WUzAa0E4sA_1745585846
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so9392165e9.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585845; x=1746190645;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h58LUJy8iPHhq/L+pCKUO6w/IzaNql/KMsgP3+Af0xI=;
        b=VtjaME+dOxxEoUC700PupwloksWvEEV5UNsKDV+MEgloIJQF+sum1hMmG7DExWAjQy
         2af0iNYhTnfD4xggpARQwmT/66liKxKk0Qypz3uVQG/v6odymtQXE6N1vxCitNss6kzy
         BEZIeYxykf5P1M6dAoi3dTLpqGhyRTLmoYsU3+3Oc9toMVXk721F3Svzo6ZgewNK6OOy
         Ze6IPc+bFYDH8eb55ZjY+15B1S4ZUOjRuEozf8yCpJ3DeHl1ZvRvqG6Hh1yXXup6hPad
         rZl2hOn2IshWfxQDGoc5TifwGfw5ltGazXRJJeYDhaaypG8LDlDMgkmsn3Km5j4F6S1p
         SneQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBrX3J7YlIS3HLU9BfdSlYcoOqWoMJdJcyfzZx2HR0ov6g7yU3kA4yxntFBSXSJG5RRew=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzxo4WOi4ED+z0tGIY0prgV3qO2nA7oyAPrwCPsFFzR2UN4tLv
	FBvrTDMR1YRSBpeOYR8jTjkMO1/qHRutpPqiVbg/djU0oTQYgp6rkY8vPfDeiEZ4U/QbZ5VhwKV
	cyG90VZQa07EqiIJycCbhwz7/po/yJv7063H2M5Y+A6vq57L7DQ==
X-Gm-Gg: ASbGncuI3AJJfKbWQ29XX8lwro/1vFBMVJCVpJkUKJ14KQy60L1Iva6jc256eIxd9cq
	BdZuDr8LU1QNSz4e5uYG+2e000+vEpqousyPxU6b7sOLx01haJieRbrWb3VNYNqSumsReGuIaPv
	A7hblzJPa736sFGEbYsIHHSS3PkWPcfSvfhTr2kLmvq3aorWohyPAMtAS+9k7KAlX5O163FtpRL
	j3UJv5zjT6DVwZy5qn/eggGN0eJIW2eoynCsalrC6P6oLVZnm7DODwQVtryhrgj43hCFfHBxJeC
	jSP3XScU8pY5IYg4ORwm4Vb/FVcizuCX502b/dCWgs8RotY5iKEsvuhOcNk8SKxhiaglWiRF5Eh
	xtx39IPPQc75Pk9v9muZE/VSHvRdTdOcPPyrc
X-Received: by 2002:a05:600c:45c9:b0:43d:1840:a13f with SMTP id 5b1f17b1804b1-440a66abe3cmr15855805e9.25.1745585845710;
        Fri, 25 Apr 2025 05:57:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0LzIglHJlELu8r0G8MLIQmarOZdUGha0s1cwmSQ6ozpqVfMzGl9LqN4UpbjYikq29TWTJow==
X-Received: by 2002:a05:600c:45c9:b0:43d:1840:a13f with SMTP id 5b1f17b1804b1-440a66abe3cmr15855615e9.25.1745585845394;
        Fri, 25 Apr 2025 05:57:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70f:6900:6c56:80f8:c14:6d2a? (p200300cbc70f69006c5680f80c146d2a.dip0.t-ipconnect.de. [2003:cb:c70f:6900:6c56:80f8:c14:6d2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a538f9c6sm24019705e9.39.2025.04.25.05.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 05:57:24 -0700 (PDT)
Message-ID: <5ab45e5c-93cd-4053-8c26-253d27176fab@redhat.com>
Date: Fri, 25 Apr 2025 14:57:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface
 as child of GenericStateManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-6-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250407074939.18657-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07.04.25 09:49, Chenyi Qiang wrote:
> To manage the private and shared RAM states in confidential VMs,
> introduce a new class of PrivateShareManager as a child of
> GenericStateManager, which inherits the six interface callbacks. With a
> different interface type, it can be distinguished from the
> RamDiscardManager object and provide the flexibility for addressing
> specific requirements of confidential VMs in the future.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---

See my other mail, likely this is going into the wrong direction.

If we want to abstract more into a RamStateManager, then it would have 
to have two two sets of states, and allow for registering a provider for 
each of the states.

It would then merge these informations.

But the private vs. shared provider and the plugged vs. unplugged 
provider would not be a subclass of the RamStateManager.

They would have a different interface.

(e.g., RamDiscardStateProvider vs. RamPrivateStateProvider)

-- 
Cheers,

David / dhildenb


