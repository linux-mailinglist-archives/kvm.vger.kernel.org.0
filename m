Return-Path: <kvm+bounces-41244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA088A657DD
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 17:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03DC13B48B1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 16:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AC519DFA7;
	Mon, 17 Mar 2025 16:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AYIoaZwj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF8119DF9A
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742228544; cv=none; b=kOysJKl5L0WmCs3/RqL/rY95t0lKHPW6AzU8CZFifXeRopkaM5EwMSQiF2fDt7Ww3BvERDOoW6rnnkGkr0954cPF2luuYCjI9oXf3dPBdI48pxrBMMhVaG1G1sy5QvrrnH2z9d6I7bYgAT4Ls/ZSdM9g+ACxxrm/r72lt6XwP70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742228544; c=relaxed/simple;
	bh=my6biimi5IEo5okR5nzazovv5Cg5d/ZY2emtViVNui8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HYgWFePl06DuTlMZSM8hRye6E2Wi3cqahbYZ5b2B6lwQhhurWvorzyigNYAbIRjg++gOBwTLGIyXlJMXuh+Pzw2+0Mi5nwcbIzWoF4ITdqXPUJ0k9RmHoFK4s+c8Ribd9iyklwBJ5TXfAJbrgqx8xNghzCfEMUQgi0RLY9abQCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AYIoaZwj; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cfecdd8b2so16887955e9.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 09:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742228541; x=1742833341; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WBWphq/OPjakrsPO4SntQfTseOUfZZyLOvc4sgW9R8E=;
        b=AYIoaZwjPMORHdstR8+HFtH/BoCWll/7QKxsuiRgePkL4sgkuo+f2Nq427qS3Rf3a9
         3W5iu3DDrX/3RmYf1PWHKj32EgmUkD3y8DR5HrL+uMRt2JpoCOZYyaPqhYLXCv8fD4jp
         69Zrzyw+3EILm1aiZwS8JOFaN+EIdDWCbTBbYi8hXOn4wxCwEpCv+By/rcjqqFNHBY9r
         9A6tlVZ+I3B2vmO/yvbVnF0LGgCsPGOkRxot8ALYRfIIqQjquOpMDlS8EvuupPvDv+rj
         lr2s870MQHftWet68bxA7u4GUMX2O2sfabCb8hO6ehvESN4gT3cLZfwAgBqGw0nsCgOK
         vtmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742228541; x=1742833341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBWphq/OPjakrsPO4SntQfTseOUfZZyLOvc4sgW9R8E=;
        b=b2yF93DFBB2s3QsTqd6qpmDU0adR6LX/VFgqYSc7t7rplzUCw6oXK688HrqqbFX8yi
         eduWh4Bvi3t1jBfPUvBiqalz9KgZSD6ZpO2k/vBJkeFiOnxpJp5rsQu6MtI/WsKlvsKR
         mTNmjQqYx3AiCrX0PlT8UdDqs6rGCRQxS4T7a4CldsCRC30ZUTXshGmX05KVAVN8mUFA
         pCjJQHUXpbHWjz2uw1Y60xgRzqXb3YO75759wHCk/IZ3e8KcBAtjyCVM/QINB6KxPxaP
         wcBm9mAUJWhTd70B+LOcStN+yaK5r2/pAinmStjCjO7SYnbavIlgSCMc0Va4U5JDCbxQ
         ovLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDdKiEakPr3CATj5rWiASOcmOMyW10dpIX+rxmGK6PexIgSjHQcxYak5j/DEjoYvPTkfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG1i8HBMajSpZC7hX4Qhl2tJe2dW7oFqeCZlLCkHWyKIczAnBQ
	/jiLyzzs0JOrWiXpoa/14DOLIaD3fLbgpfQ9SkKNrGIf1gOz94xelpTup0ikVkY=
X-Gm-Gg: ASbGnct9ZVIXgB+vJ8qOxTA8zmsdTca3exOKfCiWA6vFqFxSGsI8MHQmnkaOf2qw/N0
	DWGQigSWIXm6TU9hPK+LE7J5iwHm/nAyIXLdPZIdbBnq8XG2GOXtMiV2Qz+uRKUmxIp5O4YKDgZ
	/tW+Zj2bdOObzL4yqlnrio1pNPI23aPc6UR/Sf2ILe5uO6udA1ylLM7oiET9fT4UtwlAPs6Cpus
	4+a+pp1hSBlVdeNy/JYYh2mbW6nLVSAxmuQbCjZ2/2Fg5B2gKje0QyJh5bihrDqjG/SdjOlbU5I
	ZV85Py6Y/gOk6Gh1Z/N8MwgXa+Jh1n+K/n6XdzcHCsC03bwlwfLG1uqV1hoBKeOJzBLdYfXnhe7
	96gSA2Lb3Pg==
X-Google-Smtp-Source: AGHT+IFVNxcAnyCyAJ8pmBaH3OaDkbaFSIvHPQaBVVLvnxipFVeLkYJbNl97a+qtcZml3R72Eig+Jw==
X-Received: by 2002:a05:600c:46c8:b0:43c:ebc4:36a5 with SMTP id 5b1f17b1804b1-43d1ec6946cmr141436605e9.7.1742228541177;
        Mon, 17 Mar 2025 09:22:21 -0700 (PDT)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fdbc36dsm69896975e9.0.2025.03.17.09.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 09:22:20 -0700 (PDT)
Message-ID: <9c55662e-0c45-4bb6-83bf-54b131e30f48@linaro.org>
Date: Mon, 17 Mar 2025 17:22:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/17] exec/ram_addr: call xen_hvm_modified_memory only
 if xen is enabled
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
 <20250314173139.2122904-12-pierrick.bouvier@linaro.org>
 <ad7cdcaf-46d6-460f-8593-a9b74c600784@linaro.org>
 <edc3bc03-b34f-4bed-be0d-b0fb776a115b@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <edc3bc03-b34f-4bed-be0d-b0fb776a115b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 17/3/25 17:07, Pierrick Bouvier wrote:
> On 3/17/25 08:50, Philippe Mathieu-Daudé wrote:
>> On 14/3/25 18:31, Pierrick Bouvier wrote:
>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    include/exec/ram_addr.h | 8 ++++++--
>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
>>> index f5d574261a3..92e8708af76 100644
>>> --- a/include/exec/ram_addr.h
>>> +++ b/include/exec/ram_addr.h
>>> @@ -339,7 +339,9 @@ static inline void 
>>> cpu_physical_memory_set_dirty_range(ram_addr_t start,
>>>            }
>>>        }
>>> -    xen_hvm_modified_memory(start, length);
>>> +    if (xen_enabled()) {
>>> +        xen_hvm_modified_memory(start, length);
>>
>> Please remove the stub altogether.
>>
> 
> We can eventually ifdef this code under CONFIG_XEN, but it may still be 
> available or not. The matching stub for xen_hvm_modified_memory() will 
> assert in case it is reached.
> 
> Which change would you expect precisely?

-- >8 --
diff --git a/include/system/xen-mapcache.h b/include/system/xen-mapcache.h
index b68f196ddd5..bb454a7c96c 100644
--- a/include/system/xen-mapcache.h
+++ b/include/system/xen-mapcache.h
@@ -14,8 +14,6 @@

  typedef hwaddr (*phys_offset_to_gaddr_t)(hwaddr phys_offset,
                                           ram_addr_t size);
-#ifdef CONFIG_XEN_IS_POSSIBLE
-
  void xen_map_cache_init(phys_offset_to_gaddr_t f,
                          void *opaque);
  uint8_t *xen_map_cache(MemoryRegion *mr, hwaddr phys_addr, hwaddr size,
@@ -28,44 +26,5 @@ void xen_invalidate_map_cache(void);
  uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
                                   hwaddr new_phys_addr,
                                   hwaddr size);
-#else
-
-static inline void xen_map_cache_init(phys_offset_to_gaddr_t f,
-                                      void *opaque)
-{
-}
-
-static inline uint8_t *xen_map_cache(MemoryRegion *mr,
-                                     hwaddr phys_addr,
-                                     hwaddr size,
-                                     ram_addr_t ram_addr_offset,
-                                     uint8_t lock,
-                                     bool dma,
-                                     bool is_write)
-{
-    abort();
-}
-
-static inline ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
-{
-    abort();
-}
-
-static inline void xen_invalidate_map_cache_entry(uint8_t *buffer)
-{
-}
-
-static inline void xen_invalidate_map_cache(void)
-{
-}
-
-static inline uint8_t *xen_replace_cache_entry(hwaddr old_phys_addr,
-                                               hwaddr new_phys_addr,
-                                               hwaddr size)
-{
-    abort();
-}
-
-#endif

  #endif /* XEN_MAPCACHE_H */
diff --git a/include/system/xen.h b/include/system/xen.h
index 990c19a8ef0..04fe30cca50 100644
--- a/include/system/xen.h
+++ b/include/system/xen.h
@@ -30,25 +30,16 @@ extern bool xen_allowed;

  #define xen_enabled()           (xen_allowed)

-void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
-void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
-                   struct MemoryRegion *mr, Error **errp);
-
  #else /* !CONFIG_XEN_IS_POSSIBLE */

  #define xen_enabled() 0
-static inline void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t 
length)
-{
-    /* nothing */
-}
-static inline void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
-                                 MemoryRegion *mr, Error **errp)
-{
-    g_assert_not_reached();
-}

  #endif /* CONFIG_XEN_IS_POSSIBLE */

+void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length);
+void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
+                   MemoryRegion *mr, Error **errp);
+
  bool xen_mr_is_memory(MemoryRegion *mr);
  bool xen_mr_is_grants(MemoryRegion *mr);
  #endif
---

