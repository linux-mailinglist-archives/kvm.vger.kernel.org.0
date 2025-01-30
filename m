Return-Path: <kvm+bounces-36922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 671BAA22CC5
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 13:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E20221889453
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 12:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AED51C07E2;
	Thu, 30 Jan 2025 12:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HI23s8ww"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D37135A53
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 12:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738238536; cv=none; b=f3XQ197s5ntaBWnjSThyEfB5gYSXwWzp0FkxkrT6Di2MzTf210PSSMCHvgmPnXlImyne5oDtBePo9Sz9kMQdy+SxKd7S52ssihm0VoyOlv/Yt4xNipGKAkOOaP8BkYzWrAjLAsTbu2KD1cfZO5VYsUKULgWp9OPWC+d5kTfCAag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738238536; c=relaxed/simple;
	bh=FvsUTUpT78Yr+OXOaCM87kqW6xyaSmU2x1POulx/S7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UJ9PZsgcXqFj8e6iQH/iXdMf/AqqjWvaHy3s47NYMrMUnTw5qnVUlmrhwllAaNsL+xZX+P795rxHEuPwN4pGNA5wC0MFSupI5iU24BciPfMwvdWNYhPAF7LjWa73j9Tm9df7zbpxn2TdF5jctBcaUrlDy2YB8DrUyhQIZ5+LZD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HI23s8ww; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738238533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tthXxwJ9fuw9xyqBmp8bg2z2kCO9zZkxXy5p5fv+zVY=;
	b=HI23s8wwI8+QSLFZ6vXlrlskVL1xls5Q6KReIa/zVWtuM1SFpza7nWF/PpkgQhAG/eG81f
	S1+Bn70r/jIuubQbzrtDihl2Lw0ZMutbTc3hZT2JsgLs0gc7jAjT8zB/BMZrgRx1hGMaB4
	9lpPK3qSdRYB5HdizsFyvXaU8AO9u4Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-KQPC60vpMrWxscWvEizsUQ-1; Thu, 30 Jan 2025 07:02:11 -0500
X-MC-Unique: KQPC60vpMrWxscWvEizsUQ-1
X-Mimecast-MFC-AGG-ID: KQPC60vpMrWxscWvEizsUQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-386333ea577so329538f8f.1
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 04:02:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738238531; x=1738843331;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tthXxwJ9fuw9xyqBmp8bg2z2kCO9zZkxXy5p5fv+zVY=;
        b=cXscUXdTPxK74u7InKD/qicF0qaTSD5w/XsQyq6SoI5Gji+Q9pcoDys7QnBy/yYtgx
         5p8vhT9WcLkLty0lUdymD4rR7kFBiMho4CWZkyPUJmki0NCj2E3AZkRF/kbmm+J3XFGx
         dI2CfH5WbIURngNzr8J0CXMbr9CCL7yg5DpbTOq03UUC9wavAgcrHGLMQX8XIHRQ6Wtz
         8GRnaN0DiFw/Ci+lWxjYBa2HyQlmVnZIbCdt2JrOiZ7oDCMFqf1voNHRfQu4Iu0qeb1H
         s934+TVKL5XazzBxVjybD715swC4nEEM8Si6yul5Gv5PHL5MOFw+IzhDKcmnXNfe9am0
         AjBw==
X-Forwarded-Encrypted: i=1; AJvYcCUPOR/6CNNZA7juQ9AuhJ+9GGoHGmaJsaH++nArUTqkhL2xo9DcJVgS1rqHzbC0zfmbuX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJPMC6ddBfVygMV4pCD7H9tl0Qo+Wo5rKt07rPF7eqGnW1hrTg
	5QW8vNyTOkZHOYk+FMw0aQI7GWYIygzn5FJOX2tPzr87jKTl/hsm5PVUJe60esZJtMFru7GInwN
	iKnCWlkA5KV5JUAZOp2IhiYnrFwrUX415M1TmHTNmM78cuYJusg==
X-Gm-Gg: ASbGnctpWVDUOyRlk9UwwF7o1ysD++SLOIuJRAG5ypLJwdbwuRMwPWa84kM7zFWu8EY
	7NOxaiIMC9yvs34J1IUN0zN520ZAiG/Ty7NCDyvTiI3Snrd9xC4rpuCYLnSmQIBrZ1wGC7MC9hr
	tG0oe68FJFAY0p4s3lTCsC+TeZ1KBY081+XvWxOrXZNF7nMD5nHRqyObhwIUWKRKTdrLGgU+z2h
	IKDCzhL5Nq+5vVZeIO1G6U+67JdLEAR/C/gJtdpnM15tSm3eIftnuidkO1yYIaSzPqEEhGgds20
	ZszepDhZTgCrShd+9IKt0jUvoy4CpcMb7ybvzga9mViKeAkiF8ri1Nw/pHhS9PFlECc5AQc00nV
	Zs9UR2pR7Z9jvGTdFVNXFFaIquowJavpR
X-Received: by 2002:adf:cc92:0:b0:386:366d:5d0b with SMTP id ffacd0b85a97d-38c520c2edbmr4784179f8f.55.1738238530777;
        Thu, 30 Jan 2025 04:02:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFFxEA8huAXyCCPWFJeXna894GJsv+xkPSLaiBu0PqsJooL8+3C4l1JFblk2LvJaotRrJLcgw==
X-Received: by 2002:adf:cc92:0:b0:386:366d:5d0b with SMTP id ffacd0b85a97d-38c520c2edbmr4784143f8f.55.1738238530407;
        Thu, 30 Jan 2025 04:02:10 -0800 (PST)
Received: from ?IPV6:2003:cb:c713:3b00:16ce:8f1c:dd50:90fb? (p200300cbc7133b0016ce8f1cdd5090fb.dip0.t-ipconnect.de. [2003:cb:c713:3b00:16ce:8f1c:dd50:90fb])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c5c1cf560sm1738223f8f.89.2025.01.30.04.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 04:02:09 -0800 (PST)
Message-ID: <f6254a03-1bf2-4027-8e1d-ba400984807a@redhat.com>
Date: Thu, 30 Jan 2025 13:02:07 +0100
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

Empty line missing.

> +        if (ps > TARGET_PAGE_SIZE) {
> +            uint64_t offset = ram_addr - rb_info.offset;

Empty line missing.

Don't you have to align the fd_offset also down?

I suggest doing the alignment already when calculating "uint64_t offset"

-- 
Cheers,

David / dhildenb


