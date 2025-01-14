Return-Path: <kvm+bounces-35390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20C2DA108CF
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:13:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49D7F1883685
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2382214658F;
	Tue, 14 Jan 2025 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VXUXscIO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92FA232423
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863958; cv=none; b=WBX5tTPPtozyi2bpg7LSzdQZT+7QekaJe6Q4ozT5SauVouJo2k/wQCzPptJQev8fQ8GxjQJsCogOa/UEtDGHzGECt8j+e+HkGm8zc0oCawGqDjPN1jFZkHn00Ii6u7sTQWMkVQ9P10L0r9wbu+uuw5q4oPyvOVQ4Tn5+uBHC+/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863958; c=relaxed/simple;
	bh=cmpvRiGtsDTPD+mln2zcmX/I8URcuN2p/JXI9D+ywSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEQDmidJ96OrTe0ArESPBHzwTlVRrv4wE5rZCJJnlODbv7lHqZX5t6UtpOkatOAF2DpFmxI21Yrrfx9Ld0dlZN0F22QCLgIrjjfwV7gQf62zL+zcbpACaBJEJTbNVWM8nhJWiVLLtPAlflhHU9J0SfBrmnlLrCIyanbjCPanlGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VXUXscIO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wrhM9Ztf7j0OqIoSmoHcycqKlZfh9DXw7/bTdUpQFVU=;
	b=VXUXscIOknT9RnMoCZHLs1bFzOFOiUKuB0H06fVHGeHba65ZLl8eEHuLUIcLvzfTON28Pw
	ZZyZRIY4QmGTgEwqXCztu9imzylFkhKRxK292LAo6QxV3zz7d5bzWhmaBc/8HgLYlbm7xF
	m0+2simg3jdHA9Ip+B6Qo7XsKIqQnwc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-4yrpwli5OnWte7_FITwbyg-1; Tue, 14 Jan 2025 09:12:34 -0500
X-MC-Unique: 4yrpwli5OnWte7_FITwbyg-1
X-Mimecast-MFC-AGG-ID: 4yrpwli5OnWte7_FITwbyg
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385d6ee042eso3340938f8f.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:12:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863953; x=1737468753;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wrhM9Ztf7j0OqIoSmoHcycqKlZfh9DXw7/bTdUpQFVU=;
        b=g/AKjHVtkAzM2/vmA+Im9OX1S1oewBc/vJ3fuR3N7MwrcznWyk22XvROn5EbLgrYwJ
         ItwT7XkXozg8OXtpUg0pALOsRD32ok6kpC6VOPJdNdecvgqkMIcRsiTmZfNE3ExVBtdt
         rPJ0QUvC+3ckx8kY3hc9TDGwuZYqZpLpfD0XWBDWKIcDV6Rc5PL4kK0pjjynjTr89kQC
         NxTlijr8qn2weY827BPUPgkAV7/YmeIXIdcBKZwfgz2lmZRO9VJZaewI76zod4/4veKw
         euTSsbVs12nR+Kz5Nir6Bt9N5BOHkYzdkhb1fd9h462T6XC90u48dPXsZaCJ9Bpk1F/H
         YDeA==
X-Forwarded-Encrypted: i=1; AJvYcCVIkU40JfqgKguxppPhXxJSct7gK7hj5O1mJhoR03pGW4Ldj3TiIPEGIWJBRDnfwA0G6qM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV56geumH2o7J/x9/uJj+VugxeCwaxPIL68am6c5QsWYMcuhY6
	mzhkOHzHrZ8A59/mXjY7zXX7J075bRvrXT7GNyrdBbK5NDFMHzgG0GOv7LbkVqY22UxdnXjMRPF
	J1dIy3tk3e28aPGfrA6WbkM7nVUOY/lNwTrKJbfZyTe9Y6JSrKA==
X-Gm-Gg: ASbGncvXUyM2jlBcJhP06S1sZ1k979338c4UzBsHtk6HUbBmtco9kyep9KMVrYi2isR
	rDrhpLc1jbG5nByv3dzb11yVqGp5ffJE1U8JKOX4aujwWW8HhvIJSoYLZ32Y6q6jBgy4IpU57yv
	K7vqaadPn06vnhv0Pu5rf3uT/JM4NgCZBABQ9Wrb+VRwsWyLx2TlvDpnIOuff1yJA5evlaPLAbI
	kzT891F+rH2wE/YlgWTwuOb1j9SZ97x4uB2/YtjpuLiaUMXw63y+ySXeYW9zASd4I6wRgxjsI/b
	jjiG9NFGLz+htv+T6jMv1An3LeTVLXAC2tHWdh0CqkRHRsdaN1Irv6A5YQOXxFp0vf39ZtpDj+M
	rjv0aaehU
X-Received: by 2002:adf:c04d:0:b0:38a:88ac:ed0d with SMTP id ffacd0b85a97d-38a88acee1dmr14379499f8f.12.1736863953038;
        Tue, 14 Jan 2025 06:12:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGoYl5GldX8beX/gtVPZPHAFWijIM5jXdEh1AP7xaxBbwa5OnvRZrIIjk3YwZ7/1gN7jYHnOA==
X-Received: by 2002:adf:c04d:0:b0:38a:88ac:ed0d with SMTP id ffacd0b85a97d-38a88acee1dmr14379475f8f.12.1736863952658;
        Tue, 14 Jan 2025 06:12:32 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4b81a4sm15278188f8f.68.2025.01.14.06.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:12:32 -0800 (PST)
Message-ID: <7d2765c1-8efb-485e-936b-ea047be7018e@redhat.com>
Date: Tue, 14 Jan 2025 15:12:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] Poisoned memory recovery on reboot
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110211405.2284121-1-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 22:13, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> Hello David,
> 
> I'm keeping the description of the patch set you already reviewed:

Hi,

one request, can you send it out next time (v6) *not* as reply to the 
previous thread, but just as a new thread to the ML?

This way, it doesn't all get buried in an RFC thread that a couple of 
people might just ignore.

-- 
Cheers,

David / dhildenb


