Return-Path: <kvm+bounces-26326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EF49740AA
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 19:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B4471C2590C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2F91AE038;
	Tue, 10 Sep 2024 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVyk15YC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA41A38CE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725989601; cv=none; b=FaUBidCia38xIDehkCQUy3sQP+Wr9FaacVdByIzhKEeNQLGsFB/kCgOZJGj8BT7s/BoKs8aPUTZcC5lXtiBS1NZGm9rsfp7VZ6R4PjFjgC1NhWI2B+vMDIc/RwsFRtphXZ1sk2gz2ZRwglVLFprHJSdhjTH6CvdGmMZllpOxeIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725989601; c=relaxed/simple;
	bh=us5qbw1rIakwrbuY34rPo5XV/bUOWD6ruRrPJUaoCTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CHUU7mYCXn0pWu3S4h5iX7y7MKGYV82wBGakB/tDySB2mpnT0T8toKpLOuM67cUjW5N4jgbAdEkh0on3I1zInJwaaHqIQWGFX4nXpEHUj/XCV+m0Gafo9tUFcpYSW2sIxCx0XM1slliqbgOL8NBn0ySh6Xr1cp3BoPoD1TIsp2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVyk15YC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725989597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HnmkLlU+5fvR+S4Bm7cPH3+t+REDtoUy8WqBEqzX/5U=;
	b=VVyk15YCDF0OhLP7EzqRoQwjEFdn7xOk/Cuabh2Vn+g+jp7c7CN+bOAv2quhKWDoc2o2Ty
	Cgy0aW9iB0XYurQjdy6M7HjKf5AYu8HiUhdRiEX6Wfz/XsDfOFYTHbOJDTimvaKu0VJyr3
	X07vtRDWR9SjEDxebt+bBdCn8jwiuGY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-lStQFP24NBOjfspLjpehtA-1; Tue, 10 Sep 2024 13:33:16 -0400
X-MC-Unique: lStQFP24NBOjfspLjpehtA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-374cbbaf315so25629f8f.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725989595; x=1726594395;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HnmkLlU+5fvR+S4Bm7cPH3+t+REDtoUy8WqBEqzX/5U=;
        b=LcTeNn8Mpai20GNTepMWBWJ08/Lzg1kbJeLNs5Q+Xw81E/HhpAYznsx33+clJI1pM2
         BjIA/hFpw79uXZfkVttXFVhx3XzGF2w8Humc20IdeJ47Q1JqmMdLVkJ/8+tjeu2xnn7s
         j5+9/8ffXLKw4LcKwaJnFkVq5ovsEtNN8N9VymDBxBq6vjJFpUV9fNcLO5EI/7VidFx9
         zUdn+Mrg6T74EQCKI7OA+BvDYxhL+oWQcSFy48RkY4QzIbBhtB+MlfFFERwvfcSuB+qD
         A0N3XF6gUsa7H6BqGfW1E0FX7nDVVEz90LwjESShniNxpqWkg8S+uqML7wXsQjVrRvIr
         E4Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXNX4Kui/1OAWgTzhkN6AlwBYLBU2gPlgrBzZEYNG695LzVbcvVZiTkTTdB7/AytNXdADs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUm+UV5VgGlp1nwhdqq7wzPw0gfM6Bi6gKhNpqT+c3ddYIBVNv
	XVMvCiYCnFVRcmgX+qfYpZpLrXSMnSXS5lKRZvkN+BRBT2X02mKr0C+Q6axy9gOE1MwNswy+6Fj
	pqhcKbXOkNu9Z0Xvpu5x9jyazFRVEyWGAAI0LCMttN0PehxAeoA==
X-Received: by 2002:a05:6000:8a:b0:374:badf:3017 with SMTP id ffacd0b85a97d-378a8a84a0fmr2051071f8f.33.1725989595061;
        Tue, 10 Sep 2024 10:33:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH//BrUy5noFJlQWtRqYXISxgtqzNUygz8Ow85NRuWHaaKDxyu95lioGkW6mT4JSyPVvgMCNA==
X-Received: by 2002:a05:6000:8a:b0:374:badf:3017 with SMTP id ffacd0b85a97d-378a8a84a0fmr2051060f8f.33.1725989594580;
        Tue, 10 Sep 2024 10:33:14 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956654e8sm9489147f8f.41.2024.09.10.10.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 10:33:13 -0700 (PDT)
Message-ID: <1b694939-0738-4165-8dd6-5da2770bb3f9@redhat.com>
Date: Tue, 10 Sep 2024 19:33:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/25] KVM: x86/mmu: Taking guest pa into consideration
 when calculate tdp level
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-24-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240812224820.34826-24-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 00:48, Rick Edgecombe wrote:
> +	int maxpa = 0;
> +
> +	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM)
> +		maxpa = cpuid_query_maxguestphyaddr(vcpu);

I think the "if" should be in cpuid_query_maxguestphyaddr(), or 
alternatively the test below should become an "else".  The current 
combination is not the clearest.

Otherwise,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> +	if (!maxpa)
> +		maxpa = cpuid_maxphyaddr(vcpu);
> +



