Return-Path: <kvm+bounces-18060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C8608CD721
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CABE1F22210
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94187125C1;
	Thu, 23 May 2024 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="oC/stCBm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F021170F
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 15:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478454; cv=none; b=sBZCKZ+aFayD3b7aF9bTWj02IzaVAu/dhxFjJFCdK/SH+8/oZbBIgsqzejxWa4atNlUDlxQu2dgF+n15pNnpsPF2/qfbk518L8UeIxnTwLcz3ZZL/JltWuESZcLTd3c7D9ph+cN/v9oNwDcA0CSV5HtewrFB7MJe8ENWbl81IQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478454; c=relaxed/simple;
	bh=OMal/ed/lGH3bPNe6acjKpomMrRdM5MAjqoN2jZ1j04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hpakc7HdXheRLmFIeaL7BihMPgZBXF4klUaMitfbLk4fzIkIJ7U0WNfTboGiB/hO0ciK6H0ZKLdks2jaWuiJVjAef6LRU7BVKqu6ufeShmEieWH/kqsqg6GZYLSveGr+pr6Xuzdk5Ey/tGIFIZlgPik7qc2kh7l7CZ8zAGiIfMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=oC/stCBm; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a59c0a6415fso1210026066b.1
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 08:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1716478451; x=1717083251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OMal/ed/lGH3bPNe6acjKpomMrRdM5MAjqoN2jZ1j04=;
        b=oC/stCBmvA7lx8xr8E+VOt6Mgw2D4aTRqpoQk3I+Ki2j+RTQczlfsNz4ttTXBZyQbB
         j1ybV6bJknPlFJiJjOtL6aGdwKZk8QuZT6I6lvsaMnQl3Wimtjojgq5g6KoIKyP/4COT
         r+UVL9EiW6k/k8bZR4+qg4FQ20/G/mrWHbVl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716478451; x=1717083251;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMal/ed/lGH3bPNe6acjKpomMrRdM5MAjqoN2jZ1j04=;
        b=S3JHK8+Wi79TgV72G/YXtarxvm4ViqZk4qvlWb372QvSTfyfNI8LqMp+6ws6AcziUe
         Gd2pdfyNZaOxTyT2jrL1KsGisVLaEWCWBqTVgb3njbd9tIf1U9AOUZc+6zHnYux3eGe9
         iw8VvrEWTg2vSNEUJ+GylfH4UMvomSwHeNbGLgze5Jxc1FkyJxyTWoYKRkTTxtrX9wh/
         pxpkm2q3qv1wZOi33ePP/tHzjNod4aDMtx/ZG8tODBWFdHMXfjagSdM7WTAOUR48eQxo
         1McdzJvADWwQW32qByp4+rm10/L/4Bi2W+TspzaK/poIg1EcBxV+VNTYX9dEYABbABb5
         uYkw==
X-Forwarded-Encrypted: i=1; AJvYcCWd4sanRa5pMepAtyxtejC8dxpEYllUEe+IxPeTLEZrhX12wVuxv98xoGRR2EVI9jGvylz2++nX1ujfbmyPDpSIeP3K
X-Gm-Message-State: AOJu0YyEdH//skZf1N8VK33y1zxdUNt99mKN1fW62Pik5R0ZSyRvuVeE
	UNsQ+RhwoDD8h5q/E3Y/IcvntEGqACyL+JO5DWZLxYn3Zv+LpbIAQ4fw+d2euZ8=
X-Google-Smtp-Source: AGHT+IGUIe8BnbhMl6MI4v9lEdkVrwoQMcaDxqEJpPKDCq1/FQgOPAuTqkr3BftbxLNAmXDNNF8nZw==
X-Received: by 2002:a17:906:231a:b0:a62:2cef:95e6 with SMTP id a640c23a62f3a-a622cef97b9mr332133266b.14.1716478451515;
        Thu, 23 May 2024 08:34:11 -0700 (PDT)
Received: from [10.125.231.30] ([217.156.233.157])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5df00490cfsm794685866b.159.2024.05.23.08.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 08:34:11 -0700 (PDT)
Message-ID: <d592b997-54f6-4119-bcf1-ff180713d6be@citrix.com>
Date: Thu, 23 May 2024 16:34:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
 Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
 <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/05/2024 3:52 pm, Alexandre Chartre wrote:
>
> On 5/23/24 16:28, Dave Hansen wrote:
>> On 5/23/24 05:33, Alexandre Chartre wrote:
>>> The problem can be reproduced with the following sequence:
>>>
>>>   $ cat sysenter_step.c
>>>   int main()
>>>   { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }
>>>
>>>   $ gcc -o sysenter_step sysenter_step.c
>>>
>>>   $ ./sysenter_step
>>>   Segmentation fault (core dumped)
>>>
>>> The program is expected to crash, and the #DB handler will issue a
>>> warning.
>>
>> Should we wrap up this gem and put it with the other entry selftests?
>
> It looks like tools/testing/selftests/x86/single_step_syscall.c tests
> sysenter with TF set but it doesn't check if the kernel issues any
> warning.

But shouldn't the SIGSEGV still cause the selftest to notice?

Also, there should be a selftest for NT.  (mis)handling of that will
take the entire kernel down.

AC for good measure too, as that's the other flag handled specially.

~Andrew

