Return-Path: <kvm+bounces-34360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 036ED9FBFAE
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 16:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C6F018847C0
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA871D6DCC;
	Tue, 24 Dec 2024 15:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gn0l3NUS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C46F1BC3C
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 15:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735054370; cv=none; b=MnLn2LfN/jAh3Zydr6m6QzQ3j1pyp+Cb5NbB3D9GbcRgvlJW2oRZRr8ctlbYBbaUUV5gqzgDd4rrL38lXdWsWIjcqPQUpuQZmIIirar+pHbP9xya+E813icRI2sTEJl5NiRBLbHgpsGqIJ0Ce6k4SHjQFU/XHYMLQiQkoZ2I2Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735054370; c=relaxed/simple;
	bh=f8EHThXwKBmopgCY/8jxW1vrXnhRUWkAQkiOpWaMbas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k6Cyivwop5UicAN7WpmhVZ1hzfAcegcAqwV8eaXlt6HkZ/m8iiMxT4VZu9JrR3L9CFJzGPT8RqlwjmTrdBshQRdln7ZLjD+v1RbOjefGNYgZd/9zkB1pE9No/qkswucECwVqfjdcUGWEJGvSkot+0YnfiAeQdmQDOazDhjB3Pw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gn0l3NUS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735054367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LsjkuRBBttKS5dDHbwtUybu0HEbtAQyKBO1ZZH89czU=;
	b=gn0l3NUSFbspXzLgz3RQVjhjP+DWgQzDJ+OLbgtM+4SIKO3m67/uogFK5XpGhFYJb5eEHm
	PKQN3blSE4vlxZs/YtBSSAy68K8UpU5eZOxNQW1AdfYbMtPldo8Krrd8B21G42pXz4yyJ+
	FE9Mqf6R4M9j1HIG1SsH5vrHCHNGd5A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-Z27boLORNe-0PCQ325YWBA-1; Tue, 24 Dec 2024 10:32:46 -0500
X-MC-Unique: Z27boLORNe-0PCQ325YWBA-1
X-Mimecast-MFC-AGG-ID: Z27boLORNe-0PCQ325YWBA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385e3cbf308so2202749f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 07:32:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735054365; x=1735659165;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LsjkuRBBttKS5dDHbwtUybu0HEbtAQyKBO1ZZH89czU=;
        b=bWHa2XlqHNhePO0a4I5hKiVMIDGZU5PRPoe4077+kKigEutGT7yZl12rFBW2Kg0Gs4
         /NLI2lUj3p+Vt/YdfzY/IDbO1y3KyBhrSoXB0lL+LKJ6bZlqZ0ct9O0x69sPTd2g8OxB
         o47KcK6E1cjJiA/L16vFGn9MAZRRx05Of1tZzTpwRXjshUzTcBTNYENKZYuw2x1nU3Fd
         Qs+1+F3LGEdQlMrjGchOxmFkIMJqFkrxPjm4jYRSGRymopqxHGzclOLU991KQdzWq48p
         9zCGMKdHdJUXMm2n8sno/FYZNkXv+JBMnO4c4DATnZLiZphk+8n7QH1m/TUTT8QkbGnM
         oykQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSjNwVpWte1AUO7fhm9qlMY7Dv9TLIsioXCkuF/I5DKqX54zuvLHiHCbaJ+m5JUrHdMa8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCFQY7RGq/M3tnqaB+7Ii8jxlHaYsuX4ODgW/eN2NzytAhKhAu
	gqXdB4uwY2vJdt9SKEgriEGhUoL8N9fzDLI9b5q0zvQAi8S+3o6U8YA6msmbU65o89cQanGn4H0
	uTM9FHEIPdbFHYN1K8Ogu5owPNooeVXw/Gw5VxqNfZCJTcvbHQA==
X-Gm-Gg: ASbGncsDYwtr/hf328pqmksrW7YBEJZQSM4EpYRaj4Js2k/M17TCCRTr1ISDK3vYkO7
	rAlzpprpk+XxRwJWZ/zsKTcX8SjXx7q77OfkFiQgBeYUsaCpScbu1ump+8J/fcU5tvnUbRl+zqd
	oXuI5/FFerEkUgndPl/TvkTrNCvgcFWwfmHM4fGxTXthUZ0N1X0Pnsyh5sIx3kMf3tqmpQiABtt
	5+WZvqvv35XFtl4uqu0WAa+mvK/E9+8phrZEKqTzqzHhyUnE8yYFi40vomO
X-Received: by 2002:a05:6000:1a8f:b0:386:4034:f9a8 with SMTP id ffacd0b85a97d-38a223f5c51mr13366128f8f.38.1735054365363;
        Tue, 24 Dec 2024 07:32:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlR74QyzljNtLsUN0ihDUjhjueo7tcl12nKKAV/Fnd3xM7HvzOKCgCsRZ+z3U6rI8bhnooxg==
X-Received: by 2002:a05:6000:1a8f:b0:386:4034:f9a8 with SMTP id ffacd0b85a97d-38a223f5c51mr13366109f8f.38.1735054365065;
        Tue, 24 Dec 2024 07:32:45 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c828989sm14463909f8f.18.2024.12.24.07.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 07:32:44 -0800 (PST)
Message-ID: <af13d0c9-1d73-4cdd-8fd0-eff86a5711d3@redhat.com>
Date: Tue, 24 Dec 2024 16:32:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/11] target/i386/kvm: Save/load MSRs of kvmclock2
 (KVM_FEATURE_CLOCKSOURCE2)
To: Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-6-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241106030728.553238-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:07, Zhao Liu wrote:
> MSR_KVM_SYSTEM_TIME_NEW and MSR_KVM_WALL_CLOCK_NEW are bound to
> kvmclock2 (KVM_FEATURE_CLOCKSOURCE2).
> 
> Add the save/load support for these 2 MSRs just like kvmclock MSRs.

As mentioned in the previous patch, this is not necessary.  If it was 
needed, you'd have to also add VMSTATE fields in machine.c

Paolo


