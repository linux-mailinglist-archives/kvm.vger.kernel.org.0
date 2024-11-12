Return-Path: <kvm+bounces-31610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52DA39C53BD
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 11:33:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D241A1F225A4
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2B5214431;
	Tue, 12 Nov 2024 10:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GxNWNdVY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8281210184
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 10:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407462; cv=none; b=SyYZt16AkuLoi6ffPDaT/zLe71I/2w6d6xmeeBmvDXOHx+ZP8eQ+mY9TeXjzqvDUTUUoKXQgC2R7gopsFhc4LfspYQbX6L42swTx5AtCDWBy1amDaPUVvYzICOm7pztM8T+Erf9SMcQnXIZiq/9rvWMDSCxUcSpLZgrjbbpNjE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407462; c=relaxed/simple;
	bh=ynPyZE5ir7PJj4ohOV71nA75aGpmh7/6evOZIHgcQIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cKrR6wbux9+1KfbfnUtsvgi64V/WvBgLgOwqtMIg6viDnSma7ZYHpzFdJs3H1qIJVG9v/b6H0XUo3niEPWJNUHH2/P26GBws2LP3n3VoL0U5A4SfxonA73dX8V+0QbmLXI1vBj5lF9+36iQVNknGLJPIcuZcA+a4KcTfZ3vcYCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GxNWNdVY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731407459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ItVKEJ6DNsbBA6WbgZmKyzQ0BM3t6s9BpGdURucTWAo=;
	b=GxNWNdVY6mr/ueGesbHVrbe/PMvJUdUAIHv151/L6XLo5sf0+irGoQr37oi+0vQNiv7VEO
	PC1OBVUg03kOsmHVG3Z1H+6ltqmxMEcgtyzXR2MSYhTMFgP7J9sIzkmyyn8IkAf0p5pimx
	B0yiTCVA7j78VO4sqOF8T/UeHR51YX8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-3CSonAwrMZarTeX-7dz3PQ-1; Tue, 12 Nov 2024 05:30:58 -0500
X-MC-Unique: 3CSonAwrMZarTeX-7dz3PQ-1
X-Mimecast-MFC-AGG-ID: 3CSonAwrMZarTeX-7dz3PQ
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-37d56061a4cso3008832f8f.2
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 02:30:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731407457; x=1732012257;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ItVKEJ6DNsbBA6WbgZmKyzQ0BM3t6s9BpGdURucTWAo=;
        b=EdTscLZtCR90ebuhrQ4lA0oTGDc+kLBBqc98FkyLneTrLFikx6xSjZTk3Yi1KYXYYo
         KS/bZk2VmN0UhhWH7/sAaKdmYzGXZtm/kv9+SIlhNfieCKLQLmLADY0HyPvLdO+8Okxh
         oe5pbrWo16JEQ1Y8+YAVY4w6SECePmlYmZFEPYpRTtkuBWEK/TjYCezevzBhDyJQpYis
         jtgXFFBHXPi4otH+Xfw0Et8JSrqJzZvr0AaMk7F/4RHYxpUvF2vuRfiHJm3Yq5pgHJ8g
         xwrXuZAtIYS0fXmpeykothsTlnUMUb85chfmxSgP77Qe1YTvIshpKSNrE8RtMbrtvUIi
         4FzQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4GOaneZ6BQdMt7yVVrcqBjXbi+ZXBRdl62GsFdQQBSZ4A0jdw2tc9MNg4AUMJw7QqzEA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbt1j6e2/dcYjZ51PtvFE28sapV5wwyc50yeApLoeGLwl4t7wz
	C3xmP7SfR+r3tfWR56kRM/IWPAe7ThdddZxuBjX2oXNO9dbY/F1D+jvsFHttV22ejI4ddchXlZL
	f+MCXjthkik9SvIZR4wGYPnMmUamqHNBNeXynOKWCRtKtn5rs4g==
X-Received: by 2002:a05:6000:1567:b0:374:c17a:55b5 with SMTP id ffacd0b85a97d-3820810fdb5mr1653827f8f.14.1731407457290;
        Tue, 12 Nov 2024 02:30:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGt1xRF/ibbpecaA1gwnFRj6b3tKGiBxGA4KZNfn1ZqgVumzajk6B9GSuWFD3uJ1Yl0od7U4w==
X-Received: by 2002:a05:6000:1567:b0:374:c17a:55b5 with SMTP id ffacd0b85a97d-3820810fdb5mr1653787f8f.14.1731407456887;
        Tue, 12 Nov 2024 02:30:56 -0800 (PST)
Received: from ?IPV6:2003:cb:c739:8e00:7a46:1b8c:8b13:d3d? (p200300cbc7398e007a461b8c8b130d3d.dip0.t-ipconnect.de. [2003:cb:c739:8e00:7a46:1b8c:8b13:d3d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed987d33sm15293874f8f.43.2024.11.12.02.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 02:30:56 -0800 (PST)
Message-ID: <b4f07c74-4240-4b07-a8ce-7cd765d954e9@redhat.com>
Date: Tue, 12 Nov 2024 11:30:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-2-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20241107102126.2183152-2-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 07.11.24 11:21, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> When a memory page is added to the hwpoison_page_list, include
> the page size information.  This size is the backend real page
> size. To better deal with hugepages, we create a single entry
> for the entire page.
> 
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---
>   accel/kvm/kvm-all.c       |  8 +++++++-
>   include/exec/cpu-common.h |  1 +
>   system/physmem.c          | 13 +++++++++++++
>   3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5..6dd06f5edf 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
>    */
>   typedef struct HWPoisonPage {
>       ram_addr_t ram_addr;
> +    size_t     page_size;
>       QLIST_ENTRY(HWPoisonPage) list;
>   } HWPoisonPage;
>   
> @@ -1278,7 +1279,7 @@ static void kvm_unpoison_all(void *param)
>   
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr, page->page_size);
>           g_free(page);

I'm curious, can't we simply drop the size parameter from qemu_ram_remap()
completely and determine the page size internally from the RAMBlock that
we are looking up already?

This way, we avoid yet another lookup in qemu_ram_pagesize_from_addr(),
and can just handle it completely in qemu_ram_remap().

In particular, to be future proof, we should also align the offset down to
the pagesize.

I'm thinking about something like this:

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5..8a47aa7258 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
  
      QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
          QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
          g_free(page);
      }
  }
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 638dc806a5..50a829d31f 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
  
  /* memory API */
  
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
  /* This should not be used by devices.  */
  ram_addr_t qemu_ram_addr_from_host(void *ptr);
  ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
diff --git a/system/physmem.c b/system/physmem.c
index dc1db3a384..5f19bec089 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,10 +2167,10 @@ void qemu_ram_free(RAMBlock *block)
  }
  
  #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+void qemu_ram_remap(ram_addr_t addr)
  {
      RAMBlock *block;
-    ram_addr_t offset;
+    ram_addr_t offset, length;
      int flags;
      void *area, *vaddr;
      int prot;
@@ -2178,6 +2178,10 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
      RAMBLOCK_FOREACH(block) {
          offset = addr - block->offset;
          if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock. */
+            offset = QEMU_ALIGN_DOWN(offset, qemu_ram_pagesize(block));
+            length = qemu_ram_pagesize(block);
+
              vaddr = ramblock_ptr(block, offset);
              if (block->flags & RAM_PREALLOC) {
                  ;
@@ -2206,6 +2210,8 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                  memory_try_enable_merging(vaddr, length);
                  qemu_ram_setup_dump(vaddr, length);
              }
+
+            break;
          }
      }
  }


-- 
Cheers,

David / dhildenb


