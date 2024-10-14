Return-Path: <kvm+bounces-28810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A4A99D757
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 21:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7A041C2257B
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F040A1CDA1C;
	Mon, 14 Oct 2024 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CbPIdNnh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE881CCEDC
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 19:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728933972; cv=none; b=K3b1/L4D0wCaLOpJx2151eeEZCv89oZP2AY6N3nFnti+w9m9tlJemiVaZoj7gSrE9goDLo+PF/ES1rqdGkgiTopFlPloo4vhiqhXHwrCGm6+eM6msEuKr8k5aP9Pb2tjLaEAjbXOdQ0miCqSoqss494t1arFAuxPmgc3MB8uXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728933972; c=relaxed/simple;
	bh=mzpLzrClCHVleqISh7AUGsmPYpB2iOLEtRLRcBrdom0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnfrD6QprHrhKDOgszqbzNchv2n18YJYDDFlj15vYUxGMiQ5CJJVl9HloGmlejIlHnAqSwSnYJ3ejW+vpTr4rQ8eSd74xTqysWmdCJ2h/JwSuK/Nw7gEH69TVA9+madS3P+cnjJWUs1Ci2TCGt1pj3Q0+e3Teh4MnmvZ2swcyaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CbPIdNnh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728933969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DuTddS/X2ZHJjeoQk4qhcSOa+j0yfxlG1Fj2goHGJ/Y=;
	b=CbPIdNnh9wvx45Mn4frFWLq1WJElW7SyMo9etggN2GUS8j82EFClWGnmoAQFpBJ6CHQVoD
	T/v31QUn/9il3o/B+b4GnmAs2zxwydsGH0m1u0PLSCcTz5mxqUhq58PNF363A1Y9zC6aSN
	DeVzV6IokRnil+JhGHAyyKKJeZzyscM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-ZwlXJWNCMvOLCRkZdVBBDA-1; Mon, 14 Oct 2024 15:26:08 -0400
X-MC-Unique: ZwlXJWNCMvOLCRkZdVBBDA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d533a484aso1558413f8f.0
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 12:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728933967; x=1729538767;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DuTddS/X2ZHJjeoQk4qhcSOa+j0yfxlG1Fj2goHGJ/Y=;
        b=NJ7fyZXn9X1bLPn5oVKJjSVx/AYTRdR9GEQgO5giF3Z60gke3HEbVLkBdyj0FmU1vP
         DX1Ntsco0Y3JmO3jZbuk+6IDoKxTJybBlBog6cDHseLHkuweX/flyLeo6f0VoZ61+yAU
         RondkAvKT4DSkfW23l9Dt626de9oIJq5+rc+1yqln9ngPyafsD3oQuORyWEr0Si/nln5
         GXup8Zice4DxBCQmkvRTB2BkCgMuXw4CWUZu4BOaLcEBTfC3YVO16HxeR5u5msZ0bXsA
         0rkDKA7pBdFMu+i/gjoWbE06cIGet/w6FmCp5gYOz38p/As9eBOmPAFE9Iq9yPcrlRtx
         ovxA==
X-Forwarded-Encrypted: i=1; AJvYcCXFO3tFhQguPLVaSNHWyRZNYUzYuTCPgLOjJ4Xn2BqRI4hGPggswgQHAzQqGvEW9mSK5DA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV+1H0M+OsusYdvPvGUs/llVw7CM787zwJcih8Wq30yhzaObCp
	8P0dfPvd7J+CICF2yfocvnq7dg6lVBlXzHHpjmfqDBilp6IL09uboYO5XHuJjCWLsYB0aZfiPqv
	pg4BWJXCNje73TyqyDlglhLhDFGyNuFLypROV3WaB7euDLUJiUg==
X-Received: by 2002:a5d:6502:0:b0:37d:321e:ef0c with SMTP id ffacd0b85a97d-37d481749f6mr13355019f8f.11.1728933966972;
        Mon, 14 Oct 2024 12:26:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGSqIUDVAQ8yDJ3M4cXNcdYJWjEhFZPZWWc8/QCZ41ZlMC+nT4x3VWwvTySfdaFjPhnyy97+Q==
X-Received: by 2002:a5d:6502:0:b0:37d:321e:ef0c with SMTP id ffacd0b85a97d-37d481749f6mr13355004f8f.11.1728933966496;
        Mon, 14 Oct 2024 12:26:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71e:600:9fbb:f0bf:d958:5c70? (p200300cbc71e06009fbbf0bfd9585c70.dip0.t-ipconnect.de. [2003:cb:c71e:600:9fbb:f0bf:d958:5c70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-431182ffd14sm128833165e9.18.2024.10.14.12.26.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 12:26:05 -0700 (PDT)
Message-ID: <f93b2c89-821a-4da1-8953-73ccd129a074@redhat.com>
Date: Mon, 14 Oct 2024 21:26:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
 linux-doc@vger.kernel.org, kvm@vger.kernel.org,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-2-david@redhat.com>
 <20241014182054.10447-D-hca@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241014182054.10447-D-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.10.24 20:20, Heiko Carstens wrote:
> On Mon, Oct 14, 2024 at 04:46:13PM +0200, David Hildenbrand wrote:
>> s390 currently always results in is_kdump_kernel() == false, because
>> it sets "elfcorehdr_addr = ELFCORE_ADDR_MAX;" early during setup_arch to
>> deactivate the elfcorehdr= kernel parameter.
>>
>> Let's follow the powerpc example and implement our own logic.
>>
>> This is required for virtio-mem to reliably identify a kdump
>> environment to not try hotplugging memory.
>>
>> Tested-by: Mario Casquero <mcasquer@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   arch/s390/include/asm/kexec.h | 4 ++++
>>   arch/s390/kernel/crash_dump.c | 6 ++++++
>>   2 files changed, 10 insertions(+)
> 
> Looks like this could work. But the comment in smp.c above
> dump_available() needs to be updated.

A right, I remember that there was some outdated documentation.

> 
> Are you willing to do that, or should I provide an addon patch?
> 

I can squash the following:

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 4df56fdb2488..a4f538876462 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -587,16 +587,16 @@ int smp_store_status(int cpu)
   *    with sigp stop-and-store-status. The firmware or the boot-loader
   *    stored the registers of the boot CPU in the absolute lowcore in the
   *    memory of the old system.
- * 3) kdump and the old kernel did not store the CPU state,
- *    or stand-alone kdump for DASD
- *    condition: OLDMEM_BASE != NULL && !is_kdump_kernel()
+ * 3) kdump or stand-alone kdump for DASD
+ *    condition: OLDMEM_BASE != NULL && !is_ipl_type_dump() == false
   *    The state for all CPUs except the boot CPU needs to be collected
   *    with sigp stop-and-store-status. The kexec code or the boot-loader
   *    stored the registers of the boot CPU in the memory of the old system.
- * 4) kdump and the old kernel stored the CPU state
- *    condition: OLDMEM_BASE != NULL && is_kdump_kernel()
- *    This case does not exist for s390 anymore, setup_arch explicitly
- *    deactivates the elfcorehdr= kernel parameter
+ *
+ * Note that the old Kdump mode where the old kernel stored the CPU state
+ * does no longer exist: setup_arch explicitly deactivates the elfcorehdr=
+ * kernel parameter. The is_kudmp_kernel() implementation on s390 is independent
+ * of the elfcorehdr= parameter.
   */
  static bool dump_available(void)
  {


Does that sound reasonable? I'm not so sure about the "2) stand-alone kdump for
SCSI/NVMe (zfcp/nvme dump with swapped memory)": is that really "kdump" ?

-- 
Cheers,

David / dhildenb


