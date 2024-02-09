Return-Path: <kvm+bounces-8460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C27F684FBA3
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 19:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31BE91F23BA9
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE3280C0B;
	Fri,  9 Feb 2024 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQHPGWmP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCD37EF00
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707502154; cv=none; b=CMA3+RTW0Cp97XNIDUh8ce5wVOvbk8GYide5JuaZA2SUTA+zQQsTtk9n4nACCPZh/ooXTv+lF1GDK0DI+BDi9MwYpOhM8OTqMWO4yLPQX+Nsc26e5cq1AIuNSb/IEx8zFtSvG4M8DyJYR2heCqkHTT2/B2zyI0fYdGqRiXtNL28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707502154; c=relaxed/simple;
	bh=iHIuE205CtTkxTOJ8QBT9VX2BzHHxLYDd/fid54PptY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcMzuVy8HFjbcXDhwPsi8Cl5GR4jtKP0+1CXg2ZWIjuuWHu5LviXmYlkRoeCiM15QVuqLhrHsgjy/buyEDp9Vyt86pwbmRrDIKsJFfCu7R44tB1FDxfgX8vAtEZOinNwytGy2xv66mnF+mP7sELFtsUGR153/PZ6xZsW5EJNixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JQHPGWmP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707502151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qWJBAjq5kZHM63Q92oX8rd7RVwpgAQWVuCWuJw6H2GI=;
	b=JQHPGWmPbf9a22s9pyL5w8Y9pXiNV/y0OwXCGnXWepToDikQfSsndkquqGTkgaC2NSX5bk
	tofIbygtxFX4EsKbEKmw9HJEKv6PV0cgFIfIGJCQoZSU6UKV6r6mv5z9ZxiKcErNW+x7Ni
	CMHRJPYUxj3hVaqH6/Z8UE2zxq1AnM4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-wPdG0lSzOFWX5fru1EAv4Q-1; Fri, 09 Feb 2024 13:09:09 -0500
X-MC-Unique: wPdG0lSzOFWX5fru1EAv4Q-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-680b48a8189so16699586d6.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 10:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707502149; x=1708106949;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qWJBAjq5kZHM63Q92oX8rd7RVwpgAQWVuCWuJw6H2GI=;
        b=J8cvxgfSQQ/+pX2VdMZ6FmfpwD8Rcm1iXB6nSLu+OacR8Be6/gL0ZI+inELvjExLLI
         UdvSBOzamAvyu9qtv/KhN18EknI4EZCzPxvIsYCEpTs3CvN20bZmcYhZfeJkwV6r9fyV
         5nsBvWSmYdfMUCwCs0xJef8ouZ9vJDQogYnqXmVGKY9QzT+HjYTmJYcCKnmcj7DJVVbJ
         zYGBOre0uF5fG+gLXic0N3P7obpsEXiLv/UteK25pfONpT58YwzB29EdXxNu/Dnbpym5
         0AGZupCa5qpQPigOHYZz4UDISCkjppzsSH17fxSt8HpBJb0EVpdPCxU9iu2oCz/lkyr+
         2/2g==
X-Gm-Message-State: AOJu0Yxxh94kPhNA/N6jNC8+7VqQq2tzzYMdw5BJF11z1xbuu3yOuF8v
	6u+hp6DG0xRb3zbvd1PkPgb7EsvujVFYJnghP8nIOpGdQEgU049y5a5stj9TqeKaaf6C4y8yjbc
	Q2lhWayAwK1oQBThizzDLgiopfslzkZBDaxwleSveXe5JHAllaw==
X-Received: by 2002:ad4:5de8:0:b0:68c:8ee2:3fa0 with SMTP id jn8-20020ad45de8000000b0068c8ee23fa0mr2785581qvb.11.1707502149275;
        Fri, 09 Feb 2024 10:09:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtzks+e9Q2nimt+WHV4/eU5Wb7t5tJ07+77h0Wfr/SqqBOd3XyU6wdarwiFxt+G5VuHWYrMg==
X-Received: by 2002:ad4:5de8:0:b0:68c:8ee2:3fa0 with SMTP id jn8-20020ad45de8000000b0068c8ee23fa0mr2785554qvb.11.1707502149049;
        Fri, 09 Feb 2024 10:09:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWm4MgHh2FuocfMr0j0YAziH9jnpLxw46Vk1gOt4DPPwLZGIhOFvbtvc2/NiWd4RNK75vzcuho0FcXE876/WlhV32JQvZcs92n5psQ2MHVjJhkOnMZhtDfnlBlbEyjISh4Ki63oFKfhMZRzNE0YXFQVTnDHK4EuiQWSHTfcYtgBujW0y+WOniq1nh12MLWwXkry7LTR8a1JSfzQKZeEdTuRv2PEt5AibI09JqiKUTa6+3dvCZgAxHBnXYGbAYqrCe79U2CWjKHUeiN4WQ5LOqVWkBaWFIpsbfnW7RbQ8nUlM90s63Wf5D6WtoC1NpGmcCoWN8x2XRb/0P4vjhE0HXfnm9WPXwNKe3EdHAoPIO/+GcwI5Ln0ZPSxQSG2MmGK3tURNtcSNMsPjW8cM+BKpMVMt1HzkmXzcKg8KSkOQlRAWmIKyHq6a+9QMgm7oMb7bS0hUHzvOPTBx3kUUWWY06ik0mLyanfYuqeNFC+y718Zv57yIlofZac+3lzCWRXkoRvD6tPqHVKJF8aFGOMfHzaeCs1w
Received: from [192.168.0.9] (ip-109-43-177-145.web.vodafone.de. [109.43.177.145])
        by smtp.gmail.com with ESMTPSA id mc9-20020a056214554900b0068cb9a819a2sm1045597qvb.28.2024.02.09.10.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 10:09:08 -0800 (PST)
Message-ID: <62518aea-1214-4d33-8a15-41f1a494ee0b@redhat.com>
Date: Fri, 9 Feb 2024 19:09:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v4 6/8] migration: Add quiet migration
 support
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
 Shaoqin Huang <shahuang@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
 Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Marc Hartmayer
 <mhartmay@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, kvmarm@lists.linux.dev,
 kvm-riscv@lists.infradead.org
References: <20240209091134.600228-1-npiggin@gmail.com>
 <20240209091134.600228-7-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240209091134.600228-7-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/02/2024 10.11, Nicholas Piggin wrote:
> Console output required to support migration becomes quite noisy
> when doing lots of migrations. Provide a migrate_quiet() call that
> suppresses console output and doesn't log a message.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/migrate.c         | 11 +++++++++++
>   lib/migrate.h         |  1 +
>   scripts/arch-run.bash |  4 ++--
>   3 files changed, 14 insertions(+), 2 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



