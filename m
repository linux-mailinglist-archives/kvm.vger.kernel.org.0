Return-Path: <kvm+bounces-34173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 037A89F8295
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 18:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D76F0189ABBE
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 17:47:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBE91A3BC8;
	Thu, 19 Dec 2024 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RqB8omv0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F8519DF60
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734630136; cv=none; b=UjE0Axsyk0xXkTkcmzGnNx2AvFzj0BkkDfnM/UtmlKdqZV1CFN59K8+1SvdZ/uEkfs2iaTpjXry27WlQL6DVRyJnbYhD6q/54h6nUsJRBhIOrGcqWQiuNBfwlxZl0wC20QH0d1fI/+LkgOA4zMYnWvYIoiJFcaX1GfVwQBp+Tdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734630136; c=relaxed/simple;
	bh=pqUh8/DuhjjQHnnHFyQvxUse6CQcrYTaCynWmbWhJ+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dJ36IQms/xClxg+gwiX9FpJKgqBRYIbGHptCNtc1PXmUZciP/F8kPnMi0NbDpltJGPffUyb9++evPN0WBE/Q1nirkwapQLNa27yXi70PzFII1g1Gj86BDcyCfkijIJU2i4UK+SGRvb+ec+fXICE9ccM4bPuIqu3i80phRppBI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RqB8omv0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734630133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eIgj5uVTAx2mGU/V5Kcpjy6tXVDbCWzbkzXU5W6plgQ=;
	b=RqB8omv0SlfKV0cIhxFNh7vYdTz8eF00HVaWWczITySrJS0MiMnc3qGSzbsBi04SI/PvtK
	k5S/DNrYrucrdwhooaYWQMCQl5pJ4RZeL6APkQiqW/yyw8JN8nujnrcWtZjbX82+QXft6B
	+lU5MzKN6Kaww15Srqu+l/aSYUJcqWs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-H0-ePuBjNxO3xEMFM6C17Q-1; Thu, 19 Dec 2024 12:42:12 -0500
X-MC-Unique: H0-ePuBjNxO3xEMFM6C17Q-1
X-Mimecast-MFC-AGG-ID: H0-ePuBjNxO3xEMFM6C17Q
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43610eba55bso8642295e9.3
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 09:42:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734630131; x=1735234931;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eIgj5uVTAx2mGU/V5Kcpjy6tXVDbCWzbkzXU5W6plgQ=;
        b=Ldn9+hBCNfXRCwldS37Mj6M/YM8dIxYorUoWmNcY4XzfX7BFPygVxW8PsyU5WTenV4
         tT7Hto4mt/9sV3u8HK8nByA4maq/7xUatpN87vgaqgLM+jTxTiWXAYEuz6RRASqUXvFL
         +qd0bdVMdWI2m4g0owiCzmcTqlwsfEZBZSRw8f4TTCwAqkiNAunC9mUJa3XyIxD7tZ6u
         O2h7T/GKznfckcqU7Qyj92lB2sFQErekt3nQrXwXousSvZtsb4eEB2H4yym1WnG1E4ri
         kdg0YsCY3cpAJkAUxLjnIKxdK+uiZiVQhfT2fJ7J+/W1D+6l9C5rKDsrbK/b+2QCKha9
         Er3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/wDbQlgh9K21qFvNZQIHYYTvzaGJz0u9VlwvXqxFvZKIo8X1jLM4Oqq+QYhVy8O7T4ps=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQxYrhSmnoq4TeX/5ZZza7vBCAhtdmJyGzcFFDO3B7q/6EHlL7
	pWD+FbnCZ9EsgZuCaUWYT7wEaZZI69RvoIDbvIy1CXbf18jt0R9mbX3cz77wrRLFPOTJ63nA5us
	19tF9Aa2mkiUy9VIv2N9z/7UzRKFSk1OGTVNVHBUi+GX+ZEJizQ==
X-Gm-Gg: ASbGncszDyE3qRxg5x/NjAKVPmiAGtZ7O1oLt7C1o54MJJXdEJvd/vviexsCywmSQvm
	UNBCjTv9bQ/63HrqxMokDL8LEhUyMehgdzv/OS1mHdQar5yPQjqA7nvqIE41FTjke2IAsb8EtBu
	3RSY7nG4Kju2uF/mN76tSRoLDBk9eYEonCwGSahV/ysaDcZlY60L1zDDTYmS9wXRRy5Akm5zWRY
	gedVRrkcQzrMXvcOFGSAkAXMg3jLw7E3SmlVK65CeJ/rB+tcMpgmA4Zo7I=
X-Received: by 2002:a05:6000:704:b0:385:df2c:91b5 with SMTP id ffacd0b85a97d-38a2213d33emr10410f8f.0.1734630131105;
        Thu, 19 Dec 2024 09:42:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECn10GqpKtIxet4YjMA6L2x8RINhhH/WdNZXLUpqKw3Jb0XGZaNyEgRAbmfBetmHKVrfCUeA==
X-Received: by 2002:a05:6000:704:b0:385:df2c:91b5 with SMTP id ffacd0b85a97d-38a2213d33emr10377f8f.0.1734630130716;
        Thu, 19 Dec 2024 09:42:10 -0800 (PST)
Received: from [192.168.1.84] ([93.56.163.127])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8acb85sm2008871f8f.103.2024.12.19.09.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 09:42:10 -0800 (PST)
Message-ID: <fdb5aac8-a657-40ec-9e0b-5340bc144b7b@redhat.com>
Date: Thu, 19 Dec 2024 18:42:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Keith Busch <kbusch@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 michael.christie@oracle.com, Tejun Heo <tj@kernel.org>,
 Luca Boccassi <bluca@debian.org>
References: <20241108130737.126567-1-pbonzini@redhat.com>
 <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 18:32, Keith Busch wrote:
> This appears to be causing a user space regression. The library
> "minijail" is used by virtual machine manager "crossvm". crossvm uses
> minijail to fork processes, but the library requires the process be
> single threaded. Prior to this patch, the process was single threaded,
> but this change creates a relationship from the kvm thread to the user
> process that fails minijail's test.

Thanks for the report.

The minijail code has a flag that's documented like this:

     /// Disables the check that prevents forking in a multithreaded environment.
     /// This is only safe if the child process calls exec immediately after
     /// forking. The state of locks, and whether or not they will unlock
     /// is undefined. Additionally, objects allocated on other threads that
     /// expect to be dropped when those threads cease execution will not be
     /// dropped.
     /// Thus, nothing should be called that relies on shared synchronization
     /// primitives referenced outside of the current thread. The safest
     /// way to use this is to immediately exec in the child.

Is crosvm trying to do anything but exec?  If not, it should probably use the
flag.

> Fwiw, I think the single threaded check may be misguided, but just doing
> my due diligence to report the user space interaction.

I don't think the check itself is misguided, but if it can be improved to
only look at usermode threads somehow, that would be better.  In general
Linux is moving towards properly tracking the parent-child relationship
of kernel processes (for vhost and io_uring, and now for KVM).

Paolo


