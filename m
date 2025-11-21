Return-Path: <kvm+bounces-64128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA65C791C9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 021C94EB68F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FC4342538;
	Fri, 21 Nov 2025 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UOEDSpjc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EDE33508F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763729981; cv=none; b=SdqT1eA0sfDetL8J1j3W9PWnxHXDfz2MBiclQKrYA3YLkVoBg3JBdz6uCLgtK9ixpAJZOsm+xn7ygAPiYv7kM00cK3S0D8ZiATkfAOu03OdCmq9Q/QykZxO1uLjwszXGwHNPVUUOZCZynAcSJoJiQO1UCiw7S/v4JRInCghZglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763729981; c=relaxed/simple;
	bh=bo3RU0NbD+9B56nW+ClC5oRDP5U7wCNg0gCTVOI74S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdJAq1BBnOXUHLUThV6NXoh0eoMcf+kpBXOUcrgeB6Hlv96MfMiXuUUDw5oUGblUSQJ/FXUN26HmymyYIDqU6VfWiuYdTGHaDwQUsJ8IE6j46JawN0UgWUzetbYg/7Oa0C36ov5lcBVXl9sZiQcEqTeL2AslVbfoEka4rN+sycE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UOEDSpjc; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640d0ec9651so3188672a12.3
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 04:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1763729977; x=1764334777; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VUS4RDUiWMMssplcdPAoI/8GZpALDL5ZO+NAxT+b4uA=;
        b=UOEDSpjcTk2cinxhJcUvsVWP55Ashfhc+YHE3hRT3PJH4+zUrWTcTbJd3wvxpXQThS
         gAYzwDBu9UE9Khid+t/eNAWEwXOuaF++vD2NR6SzRizi13LYHel0Q2qwK4f2aPHrWqUp
         /Hcy/T30efE9vmTSjWsrZDYb+JevsoOr5OuzdhXzG80kBKBcm4xYEeDR4zL/M+YdKFKu
         cPHxvd4yX15h0lKptbhtlE3gKtGn7YrjN09wWbRo3TNyxk2K8225egKLlOhTzuNpTySp
         qcH9600SFT8QMmI2gJ2aQfpAMwDZiReflF/WbcaHci5WhlmW4wW5KlFgFIfSpzhzxkoK
         XJVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763729977; x=1764334777;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VUS4RDUiWMMssplcdPAoI/8GZpALDL5ZO+NAxT+b4uA=;
        b=NMrWw0yb2p7otmOpf8oNn6UBncG8O0n70dcZA0AQ7pqA4mLGhh+oKPu4IAjNZPy+a9
         Dz+ffZV+bKw6uNc3n9Ov7E/Ie3f6acZ+SngIYTXQWGsIQ0KgbBblrK0GvSmk3toDUOtq
         HRFfiDpBqSP8qtMQr+Xh4vhgEK4KMeesoJKZKDo9EoLKVJvR6pZu8FN9/3Gg8ABHbF4Y
         9rvbaZNDVcBq5LwPwCc34woDyhdLZ0cpnVkoTakYKPfy+p5AGbMCRoCsmQMVTWge5HFa
         eRexOXsZw3TUhLrYbKipvsP9wy+MorugHNxN370C0zSOku7BeToj+lpBpWzWNmlM5av+
         xeLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL0cKg2Mm3W1x2ui7hW1cS1UxR9TbAi6P5MgOV6t7NPozT3fdpvzEAO/IsAaur/E6UuzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAGSBVBr8N6hQowdq/kBX6qFOTIsxksvc2MfbK3HjOrdqQz+6n
	zxtYhs8uM7f+fKmsgWQZYM3q91cHoJtEh2vEY9Cbo3skrJclGtGBCGtF0HFL4UT/fXY=
X-Gm-Gg: ASbGncsM2CpNqQAkli1+GHqX3ZASYN5RRjf0RaaOfg0iaSgcayDnwCRQCdTE3HcaE+X
	fClub9Ojme/tBD5k/VHp4I5TkR9HBjhUFqckTMh0rqoC/mms2RVQprkxVNKugWx1XsY20FqCYfD
	HthkOmu0X2FultkmP5vZWI6tbsUz8Ebjo9W9G22GofpqrwfvOBIhjpbAqDxlQOOy3GLJN1zgudc
	6+74seGV8qCOK9Zf18Exli84zGuDY0OKyThG6u977R1IHYnxj9zv4rZfr779bXg0y1+l6cbdoj/
	VtkrXY8cP+Cix9YlD8zW1ntxqrKNRQLpfaSWQTd4pPjHkyXjWL8ZDd1ZAYtLOZDmSvEMDh7g+jR
	815pPT5GdR2cr/woqk8dWvTuIZnyvtvGQVOXb8XQWviN9j1+aKOx7Qqe6l8BNn7NCUUBpPo8Dqe
	UDPgNm5W9T/HQZbhzVZtwgAIoyFFMY5PEdCNOo
X-Google-Smtp-Source: AGHT+IHZ0r93X3U12dngBecBoBpPc6i11hVKR1jvpmIb2jLwVg71TaGfBGA5VG88Hka55GK3WEatzA==
X-Received: by 2002:a17:906:ef03:b0:b73:737e:2a21 with SMTP id a640c23a62f3a-b7671b12c6emr203743566b.54.1763729976830;
        Fri, 21 Nov 2025 04:59:36 -0800 (PST)
Received: from [192.168.0.20] (nborisov.ddns.nbis.net. [85.187.216.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdd5ebsm457196566b.14.2025.11.21.04.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 04:59:36 -0800 (PST)
Message-ID: <ebf8f16d-3d48-474b-a620-98456d31b4cc@suse.com>
Date: Fri, 21 Nov 2025 14:59:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/11] x86/vmscape: Use write_ibpb() instead of
 indirect_branch_prediction_barrier()
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
 <20251119-vmscape-bhb-v4-7-1adad4e69ddc@linux.intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251119-vmscape-bhb-v4-7-1adad4e69ddc@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/20/25 08:19, Pawan Gupta wrote:
> indirect_branch_prediction_barrier() is a wrapper to write_ibpb(), which
> also checks if the CPU supports IBPB. For VMSCAPE, call to
> indirect_branch_prediction_barrier() is only possible when CPU supports
> IBPB.
> 
> Simply call write_ibpb() directly to avoid unnecessary alternative
> patching.
> 
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

