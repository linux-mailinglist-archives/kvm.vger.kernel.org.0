Return-Path: <kvm+bounces-21505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8777C92FAF5
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F8951C22255
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 13:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359D416F850;
	Fri, 12 Jul 2024 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dv6kVzvF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E215AC4
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720790042; cv=none; b=UOt7UdHCxEQya0VxY/28sfvx76BkngvfEC1539Kh16/X4gNnLhVggxfW0sout/bwx9IyehhctVWLcQI5d+h4Wv5UpBWvqIW2qqNXXMLhXexmcgT0vvQMyQnsU420+0qzjBPw5SbPsY1nW1bTdKBFUq6tagUVa5REI2UIHVQUK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720790042; c=relaxed/simple;
	bh=k3tzp56DPV01v5QocRUSkEcGhlAFhNOGZjUzeNf1IFE=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=swgFp6c0HTDhqQIXSgywJoxmBi442cx1JI1RDgBxYcQJEgeI/ozBjA5zLtzOYDzDm7w6i8TImWXtFcIA/OYfGoL+gvCEtUvN8oCxciCzsGd7vv+f9iwAPw3QXW5O9WzyeF+/76qCXTZOtS1FaSav6W8BmqZ52unVhyAg4L8c31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dv6kVzvF; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2eaafda3b5cso18819121fa.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 06:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720790039; x=1721394839; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NwXCdeYpe+37wtJzXPEsSaL6MjZ9Yz9E2xpcybzMrbQ=;
        b=dv6kVzvFRvnjZN/WeqpoqkWJYHCpImY+Fho/eIHNgvECawpCcf4oFYTsA5WLHTS8vG
         HmCDM8lclnfs9TKpTN0xuzuyBIulwe0ZzTMsihOQE1JrpB/CKRuMcnNMWHWWiP6YrD8b
         OqdjgWoS5MXlOpCTu6OFRHp34I7fL/d0O8hVWosYegG1Mys8F9SCaEKrBa03jswvw4MO
         udyMhKGaicTnjcUzdewdLwnH6CahLG1U/DLIF+pNUBrlbOKYKEUE83Nh1Ge6TOeKBK/6
         QWBQ+x8Zjv/2vBl4z/2RrOSlGraBhopsX0t/gSW0CWm/HMs3deBdlRLNGN1LTbx0M0n6
         EuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720790039; x=1721394839;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwXCdeYpe+37wtJzXPEsSaL6MjZ9Yz9E2xpcybzMrbQ=;
        b=w7ed5KNJqIy1HRXXiq38W9KS+lZzQv3G5iVrxoqU0VE5akgK7BO4SEM5/lBh2GxDNh
         Mqd8CxzyfHA1fX9YQZ+irIcsVcW/gsmEqBMH9vXp8NnuPLkZT6B0FKIbg1FAFdJojleq
         vAdU3Xlsf/JvvktrYmjB7nzliGiocNU4nKTedDsH0DclnNIlHx7/BWONOtRBlpDvmBSj
         QbUdG7OOIkewZY7C5qQAxHp0r1QoogMkXqv19ONwtEyg1o3KhXDCNgpy4p/X7FKtoAAx
         spxEzpEPWq9Dr3r1yTVuLDZX6QHg8/ntWmF5mTpZe68Ntz4vCLV1IgSP/5lB9f+AN8nG
         +vxw==
X-Forwarded-Encrypted: i=1; AJvYcCWnRUiuIIdRQyYh7dyxT6lOYcJ1RNbIJ3rK9UV5O1o2mAqB34AsANOxsQW9udAGfY+MyGvjdlA9L5B2eanRcxmRd+cv
X-Gm-Message-State: AOJu0YzdrPsBWU9H68I7GjcfOrUP5NeA0duy0bglW5YtdMucX3ic71oH
	jL+seXi0nN75W5IKoRDm/Y6t1HuX0OB3nl8bEMJoYeBpV5UTPOu4M1/YbKZCrrE=
X-Google-Smtp-Source: AGHT+IFfdDwdxEFRsLw8NPDpQrPtKjOqEAaxI6MsH9zv3XvVvHskhFk02bUS0FPVVGjq1utf0Ctjlg==
X-Received: by 2002:a2e:9bd5:0:b0:2ee:5ed4:792f with SMTP id 38308e7fff4ca-2eeb30b8416mr74607101fa.2.1720790038625;
        Fri, 12 Jul 2024 06:13:58 -0700 (PDT)
Received: from [192.168.9.51] (54-240-197-232.amazon.com. [54.240.197.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2ba622sm23367745e9.33.2024.07.12.06.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 06:13:58 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <97925631-851e-4d97-bdb5-a02a9f63a898@xen.org>
Date: Fri, 12 Jul 2024 15:13:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, Laurent.Vivier@bull.net,
 ghaskins@novell.com, avi@redhat.com, mst@redhat.com,
 levinsasha928@gmail.com, peng.hao2@zte.com.cn, nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-2-ilstam@amazon.com>
Content-Language: en-US
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <20240710085259.2125131-2-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2024 10:52, Ilias Stamatis wrote:
> The following calculation used in coalesced_mmio_has_room() to check
> whether the ring buffer is full is wrong and only allows half the buffer
> to be used.
> 
> avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
> if (avail == 0)
> 	/* full */
> 
> The % operator in C is not the modulo operator but the remainder
> operator. Modulo and remainder operators differ with respect to negative
> values. But all values are unsigned in this case anyway.
> 
> The above might have worked as expected in python for example:
>>>> (-86) % 170
> 84
> 
> However it doesn't work the same way in C.
> 
> printf("avail: %d\n", (-86) % 170);
> printf("avail: %u\n", (-86) % 170);
> printf("avail: %u\n", (-86u) % 170u);
> 
> Using gcc-11 these print:
> 
> avail: -86
> avail: 4294967210
> avail: 0
> 
> Fix the calculation and allow all but one entries in the buffer to be
> used as originally intended.
> 
> Fixes: 105f8d40a737 ("KVM: Calculate available entries in coalesced mmio ring")
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>   virt/kvm/coalesced_mmio.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


