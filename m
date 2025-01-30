Return-Path: <kvm+bounces-36938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5524AA23262
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 18:03:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80677165F05
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 17:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE311EE024;
	Thu, 30 Jan 2025 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQvjACez"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F202770C
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 17:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738256584; cv=none; b=Wq8UNwjsL4fYRuZLsiJwbJtnIA2R9JWNHAhFmWpP1zsA36saNn+jzkNuDGUE9BoUhFXWKQC5GhZEgpKvMrxyPVl+KU7JVUqMQK5YEFe6VvIpWlfE/i+E3ZkI6lF743tOlnmwIi9rElaKi/ckY1MkiXiBuKc65UgNpy2PdIK6cu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738256584; c=relaxed/simple;
	bh=4dNdGruZ/U77kz4d1ZqhcNCY63tU/eVhN497tOB4gGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FN0NVrsRdXcUcZTcwq5k0wmiw/jV1s+Xk6l4Kt9PZ4cfJyDmlWjCSiw3C7abN+iQCTgjwCb/CNXfpb0IrEmo0Es8RylcuN6ACjP4wBiwKHl+UZ0mn7d/YWil7P7UE1tTkSwfGrFGwy/QDw7GSFGneQPtYQkdxCAW03GKAM73qn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQvjACez; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738256581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Bfgt8miLEvmEJe4gjJtXIFBmltvv0Vs8icMg+ADIw2c=;
	b=hQvjACezrmxwGX6dc/YTRkw+UPtvuOLxqorl7Ob6WNyX44DMj07hXJKclJY4JJu8xouRiU
	9h+lQrrTexQ4IqngS5IasidXfa3HBvBBValMTELCUDkLigwiC9w1j9n4HCz4/L05AAm7aC
	bfX2Fc3+CrZkx39N6yQiYC3KHU3hBb0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-lPy0qGf2MZumDPgjZ-4qZg-1; Thu, 30 Jan 2025 12:02:59 -0500
X-MC-Unique: lPy0qGf2MZumDPgjZ-4qZg-1
X-Mimecast-MFC-AGG-ID: lPy0qGf2MZumDPgjZ-4qZg
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43621907030so8811035e9.1
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 09:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738256578; x=1738861378;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bfgt8miLEvmEJe4gjJtXIFBmltvv0Vs8icMg+ADIw2c=;
        b=XQdIjpuCwrPsUwnm0hbnlBv0UEO2hn6Pv9WG1Y54t1CIRMr28i+SPl4kxEpDCLA2E/
         3sDKrJ5SswbIDsLVq3iUVVXlLKQD3gZp35P7t0tAba1azrmfg8eek9oU1IK5pAZ8ddMT
         aG97BH/54MGkx2O3Rxz+VJKXzJpHnCsm+9tGKhua4S511RTKA5qtcwNn6iYmLWKmK85c
         A7MoyYJL7xHShXKaZfd1CIcpCmbyBd2AYkwTFqYHIK2a59YQhfEyL6MEO8jZBFq+BSTv
         vUvkgt62/oMymu3ZPzFZxDhEFohFMpUEnTVVJT3mSwbm9GbLAVnJhPkiphSNqRvPb8PV
         CgBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXxQv0lM75kx/OSj3KN4G0VS1NTPin89hzVNlR9s8p9I6yLGIV9DFan5SBUAYMAEc/Gyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgRV9LA5gmOCGoenSJb2wEFjSwZcddyb4FuW8akmDwFGV7/xoR
	hMKDyK50Ta7WlpdXrGmzdu+J2yVAAF2ZBFIfj6i2Z43gmzDbl5rEhgF+dVbAM+tWlM459/OnDU1
	4VsMqUeEruxj975ZlNL5TnmwbpyX9uFZZEQxZ6aLnkd7g42Dkeg==
X-Gm-Gg: ASbGncuiHuWhckZEGvvNUUCDyYasBomapA9jcCdLt3A/j8eMtuioLy+PhXH0q8cgnAw
	fQyqzvzEF83rfO0uUJcXSw5CthIooxP6WcvjWBOV4iaQZIbRNgrKHFoACeGx+4avn+SMT0t1VHH
	xufMZ/cx+XoqfERXdntD9JHjiI5NCAVghfgbhXwjjE5ZPWOqhqZdldLxeMGIyNkQyJfMjjixw6z
	pEyEsV4EJ9NWPgi2VQrCe+eTKkuEmfgsD0aHVN9PaXqdYNzmmD7xTxDFhlC3oRYThSpPqKroMCa
	S4XLFrmOeLLQK0c0R7/j0U1hEaXQJgpOb/lHQcTgsAFriGnOzs4s2ttq/JYO4+oKzmZQuPWT1xn
	T6PYmZ6/vC6xbOGvBsD76CRH+bIr+MMOZ
X-Received: by 2002:a05:600c:3b0a:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-438dc3cae6cmr84005345e9.17.1738256578459;
        Thu, 30 Jan 2025 09:02:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGJTMrJ+ZHtudEDY2UKFWTpuA46TyGJOceK2DiZsUkzLx3bBPGALFfhAxo0D71GP+vwZHTzQA==
X-Received: by 2002:a05:600c:3b0a:b0:434:f753:6012 with SMTP id 5b1f17b1804b1-438dc3cae6cmr84004615e9.17.1738256577933;
        Thu, 30 Jan 2025 09:02:57 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3b00:16ce:8f1c:dd50:90fb? (p200300cbc7133b0016ce8f1cdd5090fb.dip0.t-ipconnect.de. [2003:cb:c713:3b00:16ce:8f1c:dd50:90fb])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc81a39sm63674615e9.35.2025.01.30.09.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 09:02:57 -0800 (PST)
Message-ID: <ca2c2d71-e4c0-4ed2-afc0-04f21df1f82d@redhat.com>
Date: Thu, 30 Jan 2025 18:02:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/6] accel/kvm: Report the loss of a large memory page
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250127213107.3454680-1-william.roche@oracle.com>
 <20250127213107.3454680-4-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250127213107.3454680-4-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.01.25 22:31, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> In case of a large page impacted by a memory error, provide an
> information about the impacted large page before the memory
> error injection message.
> 
> This message would also appear on ras enabled ARM platforms, with
> the introduction of an x86 similar error injection message.
> 
> In the case of a large page impacted, we now report:
> Memory Error on large page from <backend>:<address>+<fd_offset> +<page_size>
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   accel/kvm/kvm-all.c       | 11 +++++++++++
>   include/exec/cpu-common.h |  9 +++++++++
>   system/physmem.c          | 21 +++++++++++++++++++++
>   target/arm/kvm.c          |  3 +++
>   4 files changed, 44 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index f89568bfa3..08e14f8960 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1296,6 +1296,17 @@ static void kvm_unpoison_all(void *param)
>   void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>   {
>       HWPoisonPage *page;
> +    struct RAMBlockInfo rb_info;
> +
> +    if (qemu_ram_block_location_info_from_addr(ram_addr, &rb_info)) {
> +        size_t ps = rb_info.page_size;
> +        if (ps > TARGET_PAGE_SIZE) {
> +            uint64_t offset = ram_addr - rb_info.offset;
> +            error_report("Memory Error on large page from %s:%" PRIx64
> +                         "+%" PRIx64 " +%zx", rb_info.idstr,
> +                         QEMU_ALIGN_DOWN(offset, ps), rb_info.fd_offset, ps);
> +        }
> +    }

Some smaller nits:

1) I'd call it qemu_ram_block_info_from_addr() --  drop the "_location"

2) Printing the fd_offset only makes sense if there is an fd, right? 
You'd have to communicate that information as well.



Apart from that, this series LGTM, thanks!

-- 
Cheers,

David / dhildenb


