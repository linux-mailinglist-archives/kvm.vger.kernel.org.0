Return-Path: <kvm+bounces-59093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 781C7BABCF3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09ECB1926462
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B1A27AC3D;
	Tue, 30 Sep 2025 07:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tEp3IPqQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46C2066DE
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 07:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759217120; cv=none; b=h8zAGdIu6WLGSoE/YdlXqRZg0/OkS+beAu2NbLM8LB1B0/LOViMQzUa7tXulH37vOrLE7L5qxGBYl9sQ0CVgfE5bPpI8pSW7HxrMVnYkNaM2yfe/7uHaz/zAZq0frIhi6hI10iZcUR6i8r9y8WwQvVdiXg9n1wi5z8VmsJEZXzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759217120; c=relaxed/simple;
	bh=8/P/ykpGRoPMofrsFHnWZapQv1VX4QKPersr7a8xyc4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=kWh2hFJ7WVWEPiK64BBzpCIgzFYc0NCEzDwEYoRXNxDT4OfuQx7u4R8vcvesQYDIi7/SRm/hsSnESw7IpVz8o59JTH1wXStyODdkpPhoKD+kHr8H7CwojIssjLE49HLgO07QMK0pgpVBHvD7I7JmxxDVGfjX+VZAaT/KT+5KzcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tEp3IPqQ; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3f0134ccc0cso3772948f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759217117; x=1759821917; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KXfoHJKzAEoZlm7EIBN8HZ0wCcnvYyoGTCHOMSnDlqg=;
        b=tEp3IPqQgY0gSkFMbehgbM1+n8U/DZcdyHbTaChThxwGlJ4WVtQZWtq/X8MfypuvHy
         Wsj4+4CDorqfw0kZHE0r1ZvkOy5Q5VEha4xtZ+ZD7Lke3+ASObMZkNYphwTaCMPmOWjA
         re6/bpBP9dvqx85EgY1+fJ0L4gi3AhKwk7K7cnX8PSCB5bPdnOITAlx1MGn5IIzK5GsO
         DtrVbJy1Hh/6F+utJI5iX9JvqJybAqeayn1IiDrErmdI04Ci0OGFmS1yBhKmkhwfdbBV
         RHWq4Uh82VYHncYkNyjAfPyeqp1VPQ6fEPni6DTc27H0jizoRaSvsBIgbtjBIH93LR9F
         sErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759217117; x=1759821917;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KXfoHJKzAEoZlm7EIBN8HZ0wCcnvYyoGTCHOMSnDlqg=;
        b=dykBtBW9YxggSx+jPaPARfuIqFcxr1qsBGtp4qLnSr59hdO+/YNwM+PJ3gbQhHD4TX
         46Or3XxEdx0Y73txIyc0tUiuN8f4S2OnBrrw2ar68+kcKTFMj/al8FUqLC7ArNgclzDK
         mN3jZIJAewGC1y7l9mMgdM9mtwlpIoyM/QfrixhmLW1lMGPAFftREXS63mlHue9p8xZI
         wNa2cmfc8Oyrg7LH8wQkYkJx/dUMB1GgU8k8uklOaxvKqiAs8R0AOapXBPlGdZC/7nZB
         yCB/E/ZcKoXsNKRmAamnGHwXWVRrlwWnCnzdXvHN9WcxbaXOOEwRvAaeb/VuyjLcy8KH
         x6iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgFnrj1rTT+IL4k6wCV1fVCaTL/bxd/fIFUmPa6EMEtcXiDigaKhewQI5JvMLbQVIyvmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQZV4CxNO7VuqeoyvN3E1TNeJRljg2topuo592Ip3CKkkxSgwV
	B1Efd1Rxu6W6RAgCcxIIab88f9pLgoHP2lh96SMrD184X1ZsJt1B13r3oSc0jLpjIcQ=
X-Gm-Gg: ASbGncvQcePNl3MLZk87DyfRcFuWusUEBBbbqByG/PY7Tgme7GqZOAmp2evJmRC8Xg7
	f/pAm5YxvvvcW4+zObYok8vm9ww3igb+etefejOLElG7YLF8Sha1QdeQt1ze4fgUDN/gXZ9CSot
	D9vpDZtmLxwGrTC+gTTJtUbzEYNYYUKzYUVTPu/0RFjOVSJkbZ46GabnLYpVaDOi1ypYoQA2/5H
	st49CbksI5tKRieJbDkmnEqVgWtFWsk6vQS+FCba9IYouQELixHz8Yo2TCDPWFRa40MwMSOpSsY
	n11fRlzuWdjaMjosij7a1epEh79TFu/YS5/zj2NsNiTQUPeoTtxeTE2ed98+Fl/fvwHqm7yYEUO
	EqQWQ1e8bf15HgYlVHVfO5DSVmJLSB7uZCyZ7yEQnkA+P0HZrmv7X2MUZegjHH1zN3lEXRc4T7E
	1wwFctaycS/CuAWhYAELXH0JpY
X-Google-Smtp-Source: AGHT+IEGShYXZImSoJS6MrCCwqqS6lghItgATnZgdwGJCwRUeVTX2I6q+QeiUjF2A7MJ30GqrUAwEw==
X-Received: by 2002:adf:e646:0:b0:415:b650:a775 with SMTP id ffacd0b85a97d-415b650aca7mr8753025f8f.0.1759217116998;
        Tue, 30 Sep 2025 00:25:16 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5602f15sm21415396f8f.39.2025.09.30.00.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 00:25:16 -0700 (PDT)
Message-ID: <04098b7f-c9bd-4531-87f1-2ea26d4a2a53@linaro.org>
Date: Tue, 30 Sep 2025 09:25:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/17] system/physmem: Un-inline
 cpu_physical_memory_read/write()
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-15-philmd@linaro.org>
 <193cd8a8-2c4c-4c2c-af22-622b74c332ee@redhat.com>
 <61c31076-5330-426a-9c28-b2400bec44f6@linaro.org>
In-Reply-To: <61c31076-5330-426a-9c28-b2400bec44f6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/9/25 09:23, Philippe Mathieu-Daudé wrote:
> On 30/9/25 07:02, Thomas Huth wrote:
>> On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
>>> Un-inline cpu_physical_memory_read() and cpu_physical_memory_write().
>>
>> What's the reasoning for this patch?
> 
> Remove cpu_physical_memory_rw() in the next patch without having
> to inline the address_space_read/address_space_write() calls in
> "exec/cpu-common.h".
> 
> Maybe better squashing both together?

That would be:

-- >8 --
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 6c7d84aacb4..910e1c2afb9 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -131,18 +131,8 @@ void cpu_address_space_init(CPUState *cpu, int asidx,
   */
  void cpu_address_space_destroy(CPUState *cpu, int asidx);

-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write);
-static inline void cpu_physical_memory_read(hwaddr addr,
-                                            void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, buf, len, false);
-}
-static inline void cpu_physical_memory_write(hwaddr addr,
-                                             const void *buf, hwaddr len)
-{
-    cpu_physical_memory_rw(addr, (void *)buf, len, true);
-}
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len);
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len);
  void *cpu_physical_memory_map(hwaddr addr,
                                hwaddr *plen,
                                bool is_write);
diff --git a/system/physmem.c b/system/physmem.c
index 70b02675b93..a654b2af2a3 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -3181,11 +3181,16 @@ MemTxResult address_space_set(AddressSpace *as, 
hwaddr addr,
      return error;
  }

-void cpu_physical_memory_rw(hwaddr addr, void *buf,
-                            hwaddr len, bool is_write)
+void cpu_physical_memory_read(hwaddr addr, void *buf, hwaddr len)
  {
-    address_space_rw(&address_space_memory, addr, MEMTXATTRS_UNSPECIFIED,
-                     buf, len, is_write);
+    address_space_read(&address_space_memory, addr,
+                       MEMTXATTRS_UNSPECIFIED, buf, len);
+}
+
+void cpu_physical_memory_write(hwaddr addr, const void *buf, hwaddr len)
+{
+    address_space_write(&address_space_memory, addr,
+                        MEMTXATTRS_UNSPECIFIED, buf, len);
  }

  /* used for ROM loading : can write in RAM and ROM */
---

