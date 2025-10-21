Return-Path: <kvm+bounces-60713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E0DBF8B88
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:32:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 622D84EE36D
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 481E5274FDF;
	Tue, 21 Oct 2025 20:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h5NPd6Qm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836BF350A38
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 20:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761078735; cv=none; b=LkMPfbn+tnCnNU3z7J2Y5cG8cyqGer8igQZS05BHlYOPo7LgS/v9RfMkoxujLQC1laNJ83W6pux6IKyN+bmXgbkRqPvg+BCkfMlIJdvDcTcLtBCYRmAm4tPloitpgcL4pOBQmxk84/4ImysxnvTbOMwqSnDz2J4swQFJ+87hlwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761078735; c=relaxed/simple;
	bh=XuRo9kd4pCasXqdM83blVeXFDKu8uR0X5WXT/p0P14M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Te5XTKthU+HnuHk9/85zOwHJxM/G/EpzUNyTquzcdNzSQjHOyk4X52fACl3UMu7owpcxOpxBEeFcdTNdL++I+ZaKKi5zO/FzwjFwrkTvkKbWixi4Czn62bGoajSzHXHz8bRynlQwhxSaoPOCc0mC8x5IO/jQa9mSRX5Tkv6XtkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=h5NPd6Qm; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4711825a02bso39692925e9.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 13:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761078732; x=1761683532; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TMQVGYbBwTPfjpT7yEW5e+oix7imfwHLBURkwy6U+Pc=;
        b=h5NPd6Qmrm5GkhxgCN2v+sNk1KwwOhg+p36JManrhBf1ffh7CJzLh8bAUO/wKK3OEf
         XflgJdBLSfoYDpNstP6L0O9FeExshZytLz1Rs7VmEkLEzF9gPMuei/nFzIPGO8a6n58x
         MS6syItcMZPSWDYAl5rEguAuuTow0yfoMePw6cOprelBadKOJS189AlIW1gRrSFJLB83
         hF0iK9JyTXn2ueGxSszCMLc5hJfCsNHobDmXuAZT3F7mlpWk3K64q2Ds6jZh+4e69gMK
         naZ0vYjoDy/k4migOFz/P2rzr+wsUXxNuQqecpzyDrsS2aeS2NX8zpzVGyCEuR9bwm1I
         GKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761078732; x=1761683532;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TMQVGYbBwTPfjpT7yEW5e+oix7imfwHLBURkwy6U+Pc=;
        b=AwI+yhcpF9YuNpF/LHqX7PLJYhqvNYsxAuhOtt4hM0MRPOARfCfxRbO1orgs7JKzSS
         Cm/bB2Gs/yFExXapdpovKpj55dCX2MpBMTIP7mUszcIchvz4507ywcMy+lJbID1JV8ez
         7boMwPlS0SrbhJ6mUX+MfeJsDA17++IhRy86fhykS7LYCtQayFVZCzLJeZLmCAFQ4AFA
         xfjzdxOuZqmfiE+i3MGsVg2HV3cxg94eNb+zAWKFHvl42h7t1aWg8lSbiIFt55XWMhVM
         Xl9mNBTJPsH+qzBqmmjjL3hlcrPpKkG3QIoiNWqPg05w1kbVOJYKVQ06ZXkIYexN/77R
         k9cg==
X-Forwarded-Encrypted: i=1; AJvYcCXN3VMZ0HbPqtCIzemZRG/OpFoKme6Irj8ocpd02fLBY2b21qQqEsEyCJC4wdVLz0wG3ow=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPFJrHWgHitz6vpkxnMEyNFYQgOrN7tcAeMHiGKVjQJivbbD5z
	lPji6Sd17sqo4HIU3buUU3Zwv2JuRX6g+dJxx87tghpFTweKtvJmm/r2VTm4Vf1nRv8=
X-Gm-Gg: ASbGncvbayktiVMuowZWFqlDVLxDPuee/K7C2LdaZXKCk9Qmd0RDUYFgn1FcQsBIAjt
	WfBSaeh5FWU3k0fwaWpB3J7EzZCDWhS/qr+wlQfL2L7zeACg7+XQ4AKd3hTj+z/suUrgJcDHC+e
	CdHj7t4t10UMHn8DHEmDm5o9ViKhxIP/6kuR6z+OHK24r2TJ9TXHNJz71ROLmbGqZrxc6KVxTmx
	6ox9KbbFlYIMWhs7990eaNKMw2ydmHLYQDEw1XUX+cZXCzEqCmfz3I21ORi1tZX038TR6bZyqNV
	BY19x3CDKEfD7SfcTMYyoMc+a6Ys1p4+5Ki63ojm0VGwHgewZSEHIDnfuud3UK1b+Ct2TAGaT9L
	os1vePgwdBpiD2+vBH4MwTUkHXwJMXcHExw2aY9HKDm91Nji4sXfRdeblouPbkpFDNzFPNFaa/p
	ijE+jlncKfOEaVAhsUzYA+T4wWU04T3SlbDXjaUZbErVM=
X-Google-Smtp-Source: AGHT+IFYOB9UU5ydnY3/Edq8wbAEHG0j1YT+12KSppxWMhpai3G1EDe90HqNzmCGoBLD7R/zfooiWA==
X-Received: by 2002:a05:600c:3e07:b0:46e:4783:1a7a with SMTP id 5b1f17b1804b1-471178705bbmr137925855e9.3.1761078731740;
        Tue, 21 Oct 2025 13:32:11 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c438caeesm8607715e9.18.2025.10.21.13.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 13:32:11 -0700 (PDT)
Message-ID: <e079b37a-34d9-4ff7-87a9-4dd9de49e49c@linaro.org>
Date: Tue, 21 Oct 2025 22:32:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] Cleanup patches, mostly PC-related
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
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
 <0e7af78a-6156-437a-b76d-8453898a5b57@linaro.org>
In-Reply-To: <0e7af78a-6156-437a-b76d-8453898a5b57@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/10/25 18:07, Philippe Mathieu-Daudé wrote:
> On 19/10/25 23:02, Bernhard Beschow wrote:
> 
>> Bernhard Beschow (10):
>>    hw/timer/i8254: Add I/O trace events
>>    hw/audio/pcspk: Add I/O trace events
>>    hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events
>>    hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
>>    hw/rtc/mc146818rtc: Assert correct usage of
>>      mc146818rtc_set_cmos_data()
>>    hw/ide/ide-internal: Move dma_buf_commit() into ide "namespace"
>>    hw/i386/apic: Prefer APICCommonState over DeviceState
>>    hw/i386/apic: Ensure own APIC use in apic_msr_{read,write}
>>    hw/intc/apic: Pass APICCommonState to apic_register_{read,write}
>>    tests/qtest/ds1338-test: Reuse from_bcd()
> 
> Thanks, except if Paolo/MST/Igor object, series queued squashing:
> 
> -- >8 --
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 67ff52a8b40..d981ca05977 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -29,2 +29,3 @@
>   #include "exec/memop.h"
> +#include "hw/i386/apic.h"
>   #include "hw/i386/topology.h"
> @@ -2352,3 +2352,3 @@ struct ArchCPU {
>          user */
> -    struct APICCommonState *apic_state;
> +    APICCommonState *apic_state;
>       struct MemoryRegion *cpu_as_root, *cpu_as_mem, *smram;
> diff --git a/target/i386/whpx/whpx-internal.h b/target/i386/whpx/whpx- 
> internal.h
> index 066e16bd8e2..2dcad1f5650 100644
> --- a/target/i386/whpx/whpx-internal.h
> +++ b/target/i386/whpx/whpx-internal.h
> @@ -7,2 +7,4 @@
> 
> +#include "hw/i386/apic.h"
> +
>   typedef enum WhpxBreakpointState {
> @@ -46,3 +48,3 @@ struct whpx_state {
>   extern struct whpx_state whpx_global;
> -void whpx_apic_get(struct APICCommonState *s);
> +void whpx_apic_get(APICCommonState *s);
> 
> ---

Also squashing:

-- >8 --
diff --git a/hw/intc/apic.c b/hw/intc/apic.c
index 077ef18686b..aad253af158 100644
--- a/hw/intc/apic.c
+++ b/hw/intc/apic.c
@@ -1056,4 +1055,0 @@ static void apic_mem_write(void *opaque, hwaddr 
addr, uint64_t val,
-    if (!s) {
-        return;
-    }
-
@@ -1072,0 +1069,4 @@ static void apic_mem_write(void *opaque, hwaddr 
addr, uint64_t val,
+    if (!s) {
+        return;
+    }
+
---

