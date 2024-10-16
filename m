Return-Path: <kvm+bounces-29008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46B589A0F22
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 17:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B0CF1C22C17
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 15:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE5020F5D5;
	Wed, 16 Oct 2024 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TeDfqus/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAA81384B3
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729094106; cv=none; b=E/RbwAjhTbmd5L+MhhgxxxzxH3SjizFyYHvpxO+zDGk9KM4B5n0PyBN0e+mRYxWuHgRUId4+AHdVqTHwBjt1gTppzP6jbWQ0EaiYmOTNc++/JfLvflSbvtOjxAy/rIlG+rvmyZ+e/d9GHzIpjJs5hzWWnGSIiEyzWiYnblA7tv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729094106; c=relaxed/simple;
	bh=qYl2Sy0hY1O7mS4Yywghy4Pbib9+2/q8/iAS6YXwtjw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Ou/WaAyyRBNKn73DCrPAbgw4TMLXnpwuOVhGObrQb8pk1i001jm+jXCKo50IG+VzfPogx/lNzdxT/3YEj2BGXo3G5y+WGThcLTR9orlePX/DgM4i5H578CNGsEqsJcMGrWzMvdGxh+LCemavU5qkWj2jcSQ644/MHDNuUUvG4ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TeDfqus/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729094104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=48P55mGkCCxQ03xjhgzSLSsbrSXDZPkk4TcShvxlXM8=;
	b=TeDfqus/7IZXM2jHgTvVODWopD+Nb5G9a3FnwUbZOw0c8Qxm+v7gzOuz5Im9yaHLPZRCYC
	uRCrTGYDbiJhp8drqjvm+Okz4sqBZ77rBqG2tw7x7L/AvyimXBLuY6ew6PK7wJprHBNrPP
	sCJNrU9F7aSvPphf1TpZgd9zd/RWqbQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-HEGntZEAPMGJtmFFEkPvDA-1; Wed, 16 Oct 2024 11:55:03 -0400
X-MC-Unique: HEGntZEAPMGJtmFFEkPvDA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-37d563a1af4so2011730f8f.2
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 08:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729094100; x=1729698900;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=48P55mGkCCxQ03xjhgzSLSsbrSXDZPkk4TcShvxlXM8=;
        b=jjb8b5hbFVqYh5dsGdaOUTz3Wl86U+tqPYN1eUHnF540PxJCujp7bkbVGPNdkgYLyH
         0y7/U8qlwkI4i5AGP//+Y91erG6MMRustNJxrB12WghZaJPyfYeFSfLNi4OCBUpbBO7z
         PDpRsuCCtPtgN8L0pMzurciiVrD2zCCuHaJdKQoDve3gvtV6QffeE9mkffZG6TJ9e3cP
         T+qSiJwHhT2++QbkYqWYOVkSMKn5vJgWE99yP2YBawKsK+zRmpFNEl4HziMijYt+A4pM
         WBLWs4q+qB3i/YiwpcDB56UqCZVsCDqmlLuvICpCYQDqOm7FiZPMYCg5IfS8E+Vo/K7w
         BqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKtdTkAL6Ke/KY29iGF8bd7nb96TVNFCxc2wLM18fdmqwEMj1VnoVn5hHpatChtzkhkSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdPG+RZNX672cxrMwACuu/AriB89AOn6r8DrAuN9iwqipH7z7D
	HtfgEDz6HWg8YXNmSDHF0Oi1k0ItWCktUwFXhlAnP74pDiVh6FKu5uGLBAoKI2ihZQ5I+r5l4V0
	/1WhLcj5QjJ8qODBxf3Ubdhm19VTX87/v6lodlguqexOa3nwkUQ==
X-Received: by 2002:a05:6000:10c1:b0:37d:4a68:61a1 with SMTP id ffacd0b85a97d-37d601cd19amr10687169f8f.56.1729094100046;
        Wed, 16 Oct 2024 08:55:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQtbfVTBZ5NkmWo/03oyq9JfbDyRlPhDr0wCs2j6/mCMXk6wnjrnWGYEMTUmZ0bShmT8bRQQ==
X-Received: by 2002:a05:6000:10c1:b0:37d:4a68:61a1 with SMTP id ffacd0b85a97d-37d601cd19amr10687102f8f.56.1729094098224;
        Wed, 16 Oct 2024 08:54:58 -0700 (PDT)
Received: from ?IPV6:2003:cb:c74b:d000:3a9:de5c:9ae6:ccb3? (p200300cbc74bd00003a9de5c9ae6ccb3.dip0.t-ipconnect.de. [2003:cb:c74b:d000:3a9:de5c:9ae6:ccb3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a04asm4651030f8f.8.2024.10.16.08.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2024 08:54:57 -0700 (PDT)
Message-ID: <87956f31-472d-4091-8061-1e55fea7a3d7@redhat.com>
Date: Wed, 16 Oct 2024 17:54:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] s390/kdump: implement is_kdump_kernel()
From: David Hildenbrand <david@redhat.com>
To: Alexander Egorenkov <egorenar@linux.ibm.com>
Cc: agordeev@linux.ibm.com, akpm@linux-foundation.org,
 borntraeger@linux.ibm.com, cohuck@redhat.com, corbet@lwn.net,
 eperezma@redhat.com, frankja@linux.ibm.com, gor@linux.ibm.com,
 hca@linux.ibm.com, imbrenda@linux.ibm.com, jasowang@redhat.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, mcasquer@redhat.com, mst@redhat.com,
 svens@linux.ibm.com, thuth@redhat.com, virtualization@lists.linux.dev,
 xuanzhuo@linux.alibaba.com, zaslonko@linux.ibm.com
References: <87ed4g5fwk.fsf@li-0ccc18cc-2c67-11b2-a85c-a193851e4c5d.ibm.com>
 <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <76f4ed45-5a40-4ac4-af24-a40effe7725c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.10.24 17:47, David Hildenbrand wrote:
>>>
>>> When I wrote that code I was rather convinced that the variant in this patch
>>> is the right thing to do.
>>
>> A short explanation about what a stand-alone kdump is.
>>
>> * First, it's not really a _regular_ kdump activated with kexec-tools and
>>     executed by Linux itself but a regular stand-alone dump (SCSI) from the
>>     FW's perspective (one has to use HMC or dumpconf to execute it and not
>>     with kexec-tools like for the _regular_ kdump).
> 
> Ah, that makes sense.
> 
>> * One has to reserve crashkernel memory region in the old crashed kernel
>>     even if it remains unused until the dump starts.
>> * zipl uses regular kdump kernel and initramfs to create stand-alone
>>     dumper images and to write them to a dump disk which is used for
>>     IPLIng the stand-alone dumper.
>> * The zipl bootloader takes care of transferring the old kernel memory
>>     saved in HSA by the FW to the crashkernel memory region reserved by the old
>>     crashed kernel before it enters the dumper. The HSA memory is released
>>     by the zipl bootloader _before_ the dumper image is entered,
>>     therefore, we cannot use HSA to read old kernel memory, and instead
>>     use memory from crashkernel region, just like the regular kdump.
>> * is_ipl_type_dump() will be true for a stand-alone kdump because we IPL
>>     the dumper like a regular stand-alone dump (e.g. zfcpdump).
>> * Summarized, zipl bootloader prepares an environment which is expected by
>>     the regular kdump for a stand-alone kdump dumper before it is entered.
> 
> Thanks for the details!
> 
>>
>> In my opinion, the correct version of is_kdump_kernel() would be
>>
>> bool is_kdump_kernel(void)
>> {
>>           return oldmem_data.start;
>> }
>>
>> because Linux kernel doesn't differentiate between both the regular
>> and the stand-alone kdump where it matters while performing dumper
>> operations (e.g. reading saved old kernel memory from crashkernel memory region).
>>
> 
> Right, but if we consider "/proc/vmcore is available", a better version
> would IMHO be:
> 
> bool is_kdump_kernel(void)
> {
>             return dump_available();
> }
> 
> Because that is mostly (not completely) how is_kdump_kernel() would have
> worked right now *after* we had the elfcorehdr_alloc() during the
> fs_init call.
> 
> 
>> Furthermore, if i'm not mistaken then the purpose of is_kdump_kernel()
>> is to tell us whether Linux kernel runs in a kdump like environment and not
>> whether the current mode is identical to the proper and true kdump,
>> right ? And if stand-alone kdump swims like a duck, quacks like one, then it
>> is one, regardless how it was started, by kexecing or IPLing
>> from a disk.
> 
> Same thinking here.
> 
>>
>> The stand-alone kdump has a very special use case which most users will
>> never encounter. And usually, one just takes zfcpdump instead which is
>> more robust and much smaller considering how big kdump initrd can get.
>> stand-alone kdump dumper images cannot exceed HSA memory limit on a Z machine.
> 
> Makes sense, so it boils down to either
> 
> bool is_kdump_kernel(void)
> {
>            return oldmem_data.start;
> }
> 
> Which means is_kdump_kernel() can be "false" even though /proc/vmcore is
> available or
> 
> bool is_kdump_kernel(void)
> {
>            return dump_available();
> }
> 
> Which means is_kdump_kernel() can never be "false" if /proc/vmcore is
> available. There is the chance of is_kdump_kernel() being "true" if
> "elfcorehdr_alloc()" fails with -ENODEV.
> 
> 
> You're call :) Thanks!
> 

What I think we should do is the following (improved comment + patch
description), but I'll do whatever you think is better:


 From e86194b5195c743eff33f563796b9c725fecc65f Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Wed, 4 Sep 2024 14:57:10 +0200
Subject: [PATCH] s390/kdump: provide custom is_kdump_kernel()

s390 currently always results in is_kdump_kernel() == false until
vmcore_init()->elfcorehdr_alloc() ran, because it sets
"elfcorehdr_addr = ELFCORE_ADDR_MAX;" early during setup_arch to deactivate
any elfcorehdr= kernel parameter.

Let's follow the powerpc example and implement our own logic. Let's use
"dump_available()", because this is mostly (with one exception when
elfcorehdr_alloc() fails with -ENODEV) when we would create /proc/vmcore
and when is_kdump_kernel() would have returned "true" after
vmcore_init().

This is required for virtio-mem to reliably identify a kdump
environment before vmcore_init() was called to not try hotplugging memory.

Update the documentation above dump_available().

Tested-by: Mario Casquero <mcasquer@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
  arch/s390/include/asm/kexec.h |  4 ++++
  arch/s390/kernel/crash_dump.c |  6 ++++++
  arch/s390/kernel/smp.c        | 16 ++++++++--------
  3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 1bd08eb56d5f..bd20543515f5 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -94,6 +94,9 @@ void arch_kexec_protect_crashkres(void);
  
  void arch_kexec_unprotect_crashkres(void);
  #define arch_kexec_unprotect_crashkres arch_kexec_unprotect_crashkres
+
+bool is_kdump_kernel(void);
+#define is_kdump_kernel is_kdump_kernel
  #endif
  
  #ifdef CONFIG_KEXEC_FILE
@@ -107,4 +110,5 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
  int arch_kimage_file_post_load_cleanup(struct kimage *image);
  #define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
  #endif
+
  #endif /*_S390_KEXEC_H */
diff --git a/arch/s390/kernel/crash_dump.c b/arch/s390/kernel/crash_dump.c
index 51313ed7e617..43bbaf534dd2 100644
--- a/arch/s390/kernel/crash_dump.c
+++ b/arch/s390/kernel/crash_dump.c
@@ -237,6 +237,12 @@ int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
  						       prot);
  }
  
+bool is_kdump_kernel(void)
+{
+	return dump_available();
+}
+EXPORT_SYMBOL_GPL(is_kdump_kernel);
+
  static const char *nt_name(Elf64_Word type)
  {
  	const char *name = "LINUX";
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 4df56fdb2488..bd41e35a27a0 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -574,7 +574,7 @@ int smp_store_status(int cpu)
  
  /*
   * Collect CPU state of the previous, crashed system.
- * There are four cases:
+ * There are three cases:
   * 1) standard zfcp/nvme dump
   *    condition: OLDMEM_BASE == NULL && is_ipl_type_dump() == true
   *    The state for all CPUs except the boot CPU needs to be collected
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
+ * Note that the old kdump mode where the old kernel stored the CPU state
+ * does no longer exist: setup_arch explicitly deactivates the elfcorehdr=
+ * kernel parameter. The is_kdump_kernel() implementation on s390 is independent
+ * of the elfcorehdr= parameter, and is purely based on dump_available().
   */
  static bool dump_available(void)
  {
-- 
2.46.1


-- 
Cheers,

David / dhildenb


