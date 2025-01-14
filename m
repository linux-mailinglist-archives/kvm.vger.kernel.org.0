Return-Path: <kvm+bounces-35381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1821A1083C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:56:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A43793A8987
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 13:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22B249625;
	Tue, 14 Jan 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TYRQ0r+i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CF317557
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 13:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863007; cv=none; b=c1SHU/pkhsDd+HE4pPir2M6y7ywQdaOPl9xqImvrOIj1h6Mi5vw6ZT0bwehTYpHhNdhMECLltE0Y4SmH+LLup21NF0vXMJuji3BevTmFPK+xHpLALZaGfbP54Xs8ADlyZPVCQ9+B8/wgBSg7tPaUX+PeAHbcLzCAYXG/rBAWlUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863007; c=relaxed/simple;
	bh=E3igHNyJpMhUoHT+iRt9sRiDO0w4xrKa6vLd73RMXAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lW9qpiVjJojUG0dhUKzg2QZl+Ig3FuAvYgyLNDds3wXyp217QMMaWqI4Pv+i1iHIW3N055GSoXJu5xHwGAhK/OCGNE8wKuAhC76kuwu27dYWKAlxI/umgXgwhoWo8kII4gyWqa3IpT8X0yxW/cYw3M021Z/qSDwjn9VAC92YzCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TYRQ0r+i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=04hdS9EdI5M8MjBOo+JHrU5DWVhAC0TRFhb0/CfLM9I=;
	b=TYRQ0r+irKZQ1aK+snGkgX5XuH+w9rusrjDt8QzYFiEQi4t6kUsOMqMZp6mKr6EbMrrw5w
	4XRwfTtm6CiF/MYJMB9lPZRrj8HG8jyuhpErMb7mmU39+R1LlnTGt+td1VbbYbqp1PZxq9
	LiyD5zB+HEypMFpiHFZujWdYdn9Bl9k=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-1V3dfzLsMXCpeTr-jWwHKA-1; Tue, 14 Jan 2025 08:56:43 -0500
X-MC-Unique: 1V3dfzLsMXCpeTr-jWwHKA-1
X-Mimecast-MFC-AGG-ID: 1V3dfzLsMXCpeTr-jWwHKA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361eb83f46so44105485e9.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 05:56:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863002; x=1737467802;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=04hdS9EdI5M8MjBOo+JHrU5DWVhAC0TRFhb0/CfLM9I=;
        b=Wu4QnwGVQcN9H4XsJth2c+05GFTEHqzz4p+Cvtgrqltgfolyh+Tsi7it4CPFGuADb1
         xi4ptyCE14B12kzBxWfHgEInTeCtV3Qm04yQwNpZgRLTKuxzj3FDin2CSS0PUpbTpi9y
         iWftL1Q6MKJGJGTMg3EcPJItsN+P+Se+3Q1C3wowf2LEDtuBh3ZCXSI3NIQMIkf1i2Af
         Jc0xdCqz917weur5HSCLxxCRz2XdIojItNLECXv6ycss3gbqkIA6Rkqa6DkveB3kJPji
         JNIQAjxXKH194fCXHlH7acK9MCGGs7Q+IShzqnsJzARoKFPezkWGhfkY6EOQg8Hyml3r
         ul+w==
X-Forwarded-Encrypted: i=1; AJvYcCUjfPH/asGMw+0dwlUYloH9I2TP3ZojNF3ijPA7vttbdpVkoRIsVRDu5WgIdc4KOp5nzcE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yypa6XUE1zlKrEUxrWhxPapMPDJn/ZuEGqXdc5lBJblI4TYSl10
	G/yEpktd4dgrigd6BT3w//RNIu4C5MKoCCdIGuWhznYqKggJdSXJW9xmFvBVWfx6Bi6dOoHfTQ8
	D1WSQwDTHqIvp6MHiCIcwV7LL0DlzeRGTh53rUFX6kOsGtX+avg==
X-Gm-Gg: ASbGncuoQtJrJw55RdxMRK5ZsSLK54zxzSGWvsRMu58BgB8vaM5UJVZ27lKM0zHQPH/
	y9JIVGLshSSJk75+kqYCnATAcvq0B5aiYYsaXtSQmrJ9x4mEdyaP55zLw2ycfWxsBmWWuHvv88I
	G1hBHi+k7gBtUei8TT9UD4A7nMIXVczNd5opDyK5J3zKHRpKYbaquhMmNriwjZP8yivwczcu43Z
	LbCSA998FYFAmuVJmCJG0ZGpq4dOb+lFh803j6zJdYk+aiKIYwQ3Y5S67bZkRUMLNOkzY5D1Slo
	Jn5A5rY2UU0/v/8DOlOGKLAj5lwWLzPRU+U/T06TtQlosbDgz6Zsi+ljsKzP+NP7OI/NNw7CjR5
	d6Ht0ij6k
X-Received: by 2002:a05:6000:1f8d:b0:385:eb85:f111 with SMTP id ffacd0b85a97d-38a87305259mr22924547f8f.14.1736863001748;
        Tue, 14 Jan 2025 05:56:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeUs7O//Q6CzviBH+Gnx11JxFqaNxzMdnDmtyzbfTmXMuYjqiQ/elSkq6VtL8naR/CYpZ6Cw==
X-Received: by 2002:a05:6000:1f8d:b0:385:eb85:f111 with SMTP id ffacd0b85a97d-38a87305259mr22924523f8f.14.1736863001313;
        Tue, 14 Jan 2025 05:56:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e4c1f2esm14966876f8f.98.2025.01.14.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 05:56:40 -0800 (PST)
Message-ID: <0c3da624-aa20-4703-87a3-6b3bfabaab22@redhat.com>
Date: Tue, 14 Jan 2025 14:56:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] hwpoison_page_list and qemu_ram_remap are based on
 pages
To: William Roche <william.roche@oracle.com>, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-2-william.roche@oracle.com>
 <a00d6d67-c0a1-4d54-9932-bf3b3a7054d8@redhat.com>
 <c45033b9-2ca6-430d-9719-72b123095b64@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <c45033b9-2ca6-430d-9719-72b123095b64@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 21:56, William Roche wrote:
> On 1/8/25 22:34, David Hildenbrand wrote:
>> On 14.12.24 14:45, “William Roche wrote:
>>> From: William Roche <william.roche@oracle.com>
>>
>> Subject should likely start with "system/physmem:".
>>
>> Maybe
>>
>> "system/physmem: handle hugetlb correctly in qemu_ram_remap()"
> 
> I updated the commit title
> 
>>
>>>
>>> The list of hwpoison pages used to remap the memory on reset
>>> is based on the backend real page size. When dealing with
>>> hugepages, we create a single entry for the entire page.
>>
>> Maybe add something like:
>>
>> "To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete hugetlb
>> page; hugetlb pages cannot be partially mapped."
>>
> 
> Updated into the commit message
> 
>>>
>>> Co-developed-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>> ---
>>>    accel/kvm/kvm-all.c       |  6 +++++-
>>>    include/exec/cpu-common.h |  3 ++-
>>>    system/physmem.c          | 32 ++++++++++++++++++++++++++------
>>>    3 files changed, 33 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 801cff16a5..24c0c4ce3f 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
>>>        QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>>            QLIST_REMOVE(page, list);
>>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>>> +        qemu_ram_remap(page->ram_addr);
>>>            g_free(page);
>>>        }
>>>    }
>>> @@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
>>>    void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>>>    {
>>>        HWPoisonPage *page;
>>> +    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
>>> +
>>> +    if (page_size > TARGET_PAGE_SIZE)
>>> +        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
>>
>> Is that part still required? I thought it would be sufficient (at least
>> in the context of this patch) to handle it all in qemu_ram_remap().
>>
>> qemu_ram_remap() will calculate the range to process based on the
>> RAMBlock page size. IOW, the QEMU_ALIGN_DOWN() we do now in
>> qemu_ram_remap().
>>
>> Or am I missing something?
>>
>> (sorry if we discussed that already; if there is a good reason it might
>> make sense to state it in the patch description)
> 
> You are right, but at this patch level we still need to round up the

s/round up/align_down/

> address and doing it here is small enough.

Let me explain.

qemu_ram_remap() in this patch here doesn't need an aligned addr. It
will compute the offset into the block and align that down.

The only case where we need the addr besides from that is the
error_report(), where I am not 100% sure if that is actually what we
want to print. We want to print something like ram_block_discard_range().


Note that ram_addr_t is a weird, separate address space. The alignment
does not have any guarantees / semantics there.


See ram_block_add() where we set
	new_block->offset = find_ram_offset(new_block->max_length);

independent of any other RAMBlock properties.

The only alignment we do is
	candidate = ROUND_UP(candidate, BITS_PER_LONG << TARGET_PAGE_BITS);

There is no guarantee that new_block->offset will be aligned to 1 GiB with
a 1 GiB hugetlb mapping.


Note that there is another conceptual issue in this function: offset
should be of type uint64_t, it's not really ram_addr_t, but an
offset into the RAMBlock.

> Of course, the code changes on patch 3/7 where we change both x86 and
> ARM versions of the code to align the memory pointer correctly in both
> cases.

Thinking about it more, we should never try aligning ram_addr_t, only
the offset into the memory block or the virtual address.

So please remove this from this ram_addr_t alignment from this patch, and look into
aligning the virtual address / offset for the other user. Again, aligning
ram_addr_t is not guaranteed to work correctly.


So the patch itself should probably be (- patch description):


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
index 03d3618039..355588f5d5 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,17 +2167,35 @@ void qemu_ram_free(RAMBlock *block)
  }
  
  #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+/*
+ * qemu_ram_remap - remap a single RAM page
+ *
+ * @addr: address in ram_addr_t address space.
+ *
+ * This function will try remapping a single page of guest RAM identified by
+ * @addr, essentially discarding memory to recover from previously poisoned
+ * memory (MCE). The page size depends on the RAMBlock (i.e., hugetlb). @addr
+ * does not have to point at the start of the page.
+ *
+ * This function is only to be used during system resets; it will kill the
+ * VM if remapping failed.
+ */
+void qemu_ram_remap(ram_addr_t addr)
  {
      RAMBlock *block;
-    ram_addr_t offset;
+    uint64_t offset;
      int flags;
      void *area, *vaddr;
      int prot;
+    size_t page_size;
  
      RAMBLOCK_FOREACH(block) {
          offset = addr - block->offset;
          if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
              vaddr = ramblock_ptr(block, offset);
              if (block->flags & RAM_PREALLOC) {
                  ;
@@ -2191,21 +2209,22 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                  prot = PROT_READ;
                  prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                  if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                  offset + block->fd_offset);
                  } else {
                      flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                  }
                  if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                    error_report("Could not remap RAM %s:%" PRIx64 " +%zx",
+                                 block->idstr, offset, page_size);
                      exit(1);
                  }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
              }
+
+            break;
          }
      }
  }
-- 
2.47.1

-- 
Cheers,

David / dhildenb


