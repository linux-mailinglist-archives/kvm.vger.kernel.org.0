Return-Path: <kvm+bounces-60712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 645A3BF8B7F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C23444ECF95
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F123954918;
	Tue, 21 Oct 2025 20:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AXV1wZ5D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FBD1F3FED
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761078687; cv=none; b=msL99pp1PtwJOjn92ZiLfwjL6dX/LMOHSs4xsoBOWW7XdG08uTBaBHz9DzCJaj4HjqxO+0CM6ol5vePHJa6+CsIxhPq6dTtDvv/yZsInf4ElM9jaOOcM58imyPEmZlwpxg5fGX6bKTMYkHr/Dor6pm+HiufZyr0SaX7qCOzSh2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761078687; c=relaxed/simple;
	bh=dp33MWE5gJdoLmz0PclzlmTqR36Hd2AqV820ixOXVjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mS0kXYE8iTUcTl9FRxoNGRMzWqCFSo6gWM4T00xr9MWPrTICfV4wy8ysSCStb9XyHbBIMHSg1/bsnKRBs+t3T87EcB/8P7OHMePDNdBqIAO+kAjX6wKtQUZxaHNJMaQOwxdLoZjiAZn/RDgRvo8GEjTqB0J5J75W0ekBEbb7nbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AXV1wZ5D; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-474975af41dso9781385e9.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 13:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761078683; x=1761683483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e46Xpd7tLYIKXwBbt7lbuURVIUXwhDVyJ1/luhq2CqY=;
        b=AXV1wZ5D6hpWTa2Ob6WDiBeEVISzxng0lNxLysYdc8xPr79g6CbcfinwBQlFz8Dizw
         CeC326Bu286kqh4Kw7BMuz9Kx2Z79mrxl+fIQC+4p7lddoFR6D9pTenexj7FRIcxndCu
         bcvwjRe82zJu6ScLVRgF5JJD8eNbYvuzIfUzl47SV9oZanhV1kBWEL7wYoI9DwUc4pBi
         oaGqWODOCU8ZauRMnB0O0wdl3ZxmhQfCxX+d0Wx5GP4JRNBiG6rQfq9O/hBi0ig8ILPT
         fRVI2i5DIGW0+UXEaj3lbXoMK0OHliUU6jCv1ZtnMrPaBbZyMI5HemM4aPTI2EhcQhye
         OBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761078683; x=1761683483;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e46Xpd7tLYIKXwBbt7lbuURVIUXwhDVyJ1/luhq2CqY=;
        b=T390SZtTIFNeHIk5sBo4eBtNcx2UZ/FeTeXRt3K257qsSs/wOgLjb0lVsTJVQplS13
         5MsYmneaqRp01A62cBIgVo2rVqeMTvytIbaHHIBi8TQxwM3eD79eFd+P/AUfDE9kCZ2D
         AkP8fSy/LdcbixwJWYl04QtHauem4bJb9X+K7tiUOQI/gb3k7rl+HEGB0qzAFwAMxVV8
         40z8W7eZBPU3R4YZYOSdHETTu7XQoCNt4OusqYxB2t2NcSNQhp4v56qnyBTSiXbl4TVm
         e42zY0dBzplb5KDhp1ejysScIlDkQtHlYUMahNxWRMA4s3+XZ510qK7rnYKf3QQ+WV6d
         Jo8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWvShsq1Vp50/tGyU5yo0cuPyYtzwUwO1Mz487s0+zCE7bj8poRtST+pe/95lU1dDbvqtk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yws6pRU88Z24sJuIjGjRzuPLvNQ47amw2gkT6bxHoTqBcErRNK0
	ilL6/R2zR25gms6y0EJeURIZTQQwFiB/dyOvH85HWoCLVdPwBZRXh87KLYItSpP0+WE=
X-Gm-Gg: ASbGncuewyUlnybFDjIUI3CZUQ3sC9CwojDvh76mwC6Pip/j3VPfD1XSnwgwyYQfwIB
	o1ochiWWAnllaNzkV8cIdunZSq1H3gnmYetrVAGvC2Nh3RbRIAUg5uCNQEx+dZ9CLEItOvzzVaQ
	r97wWtvcb3giYrmuPoj7VaWFpdSr99HrV0Vxxrr/bMAf4EaWIEn+HKnMLJURqEzxuVF6EVyaCf0
	p+W+KzCMUt8sh+JeGmhIlNO4x4sN8aByFcljm0Bh/2rBb6s4k8QkuIEmCAMaEif4nbejc8jBSjm
	gEljxogzW/r6O3cdgrJXQU8sjW1olr2czoOJOY+9SnWqufNhpCKCke/zvFnZ7gCLSGWvybynfXQ
	NGA58JOGSGQec7V7PRZhQTSrylSgqMBj7Ueoqh6H//KaH1WP3lUQJGyAe2MW0xLLPrjzIG0OV5T
	z9acERavuDtxLSgjBRXcYS3CDJ4mItP2tg2wYi16Uj47yS+xg9dYGURw==
X-Google-Smtp-Source: AGHT+IH3MFgzooHeifTv6goalvSCOCkji2kNHftd9bPXF0cgSvPl9wwmDkwJqJSwTixMtYZTPoNSRQ==
X-Received: by 2002:a05:600c:190f:b0:470:feb2:e968 with SMTP id 5b1f17b1804b1-471178b125amr134414325e9.15.1761078683529;
        Tue, 21 Oct 2025 13:31:23 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496c14a26sm23142735e9.4.2025.10.21.13.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 13:31:22 -0700 (PDT)
Message-ID: <e2b73955-13b6-4987-a24c-1b8998597d07@linaro.org>
Date: Tue, 21 Oct 2025 22:31:21 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/10] hw/intc/apic: Pass APICCommonState to
 apic_register_{read, write}
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Laurent Vivier <laurent@vivier.eu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
 Cameron Esfahani <dirty@apple.com>, qemu-block@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-trivial@nongnu.org,
 Laurent Vivier <lvivier@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Roman Bolshakov <rbolshakov@ddn.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
References: <20251019210303.104718-1-shentey@gmail.com>
 <20251019210303.104718-10-shentey@gmail.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20251019210303.104718-10-shentey@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bernhard,

On 19/10/25 23:03, Bernhard Beschow wrote:
> As per the previous patch, the APIC instance is already available in
> apic_msr_{read,write}, so it can be passed along. It turns out that
> the call to cpu_get_current_apic() is only required in
> apic_mem_{read,write}, so it has been moved there. Longer term,
> cpu_get_current_apic() could be removed entirely if
> apic_mem_{read,write} is tied to a CPU's local address space.
> 
> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
> ---
>   hw/intc/apic.c | 35 ++++++++++++++++-------------------
>   1 file changed, 16 insertions(+), 19 deletions(-)


> @@ -1054,12 +1046,17 @@ static int apic_register_write(int index, uint64_t val)
>   static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
>                              unsigned size)
>   {
> +    APICCommonState *s = cpu_get_current_apic();
>       int index = (addr >> 4) & 0xff;
>   
>       if (size < 4) {
>           return;
>       }
>   
> +    if (!s) {
> +        return;
> +    }

This is not the correct place to return...

>       if (addr > 0xfff || !index) {
>           /*
>            * MSI and MMIO APIC are at the same memory location,

... because of this comment. See the (squashed) fix below.

> @@ -1073,7 +1070,7 @@ static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
>           return;
>       }
>   
> -    apic_register_write(index, val);
> +    apic_register_write(s, index, val);
>   }

-- >8 --
diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index 077ef18686b..aad253af158 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -1046,30 +1046,30 @@ static int apic_register_write(APICCommonState 
*s, int index, uint64_t val)
  static void apic_mem_write(void *opaque, hwaddr addr, uint64_t val,
                             unsigned size)
  {
      APICCommonState *s = cpu_get_current_apic();
      int index = (addr >> 4) & 0xff;

      if (size < 4) {
          return;
      }

-    if (!s) {
-        return;
-    }
-
      if (addr > 0xfff || !index) {
          /*
           * MSI and MMIO APIC are at the same memory location,
           * but actually not on the global bus: MSI is on PCI bus
           * APIC is connected directly to the CPU.
           * Mapping them on the global bus happens to work because
           * MSI registers are reserved in APIC MMIO and vice versa.
           */
          MSIMessage msi = { .address = addr, .data = val };
          apic_send_msi(&msi);
          return;
      }

+    if (!s) {
+        return;
+    }
+
      apic_register_write(s, index, val);
  }

---

