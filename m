Return-Path: <kvm+bounces-66796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 586D5CE7F64
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 19:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5306B300E479
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 18:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E902882B2;
	Mon, 29 Dec 2025 18:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AzzAZpCj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C942853F8
	for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767034077; cv=none; b=VGGWTQmTzqL3Wgf+D2xjSHwd7xdwED22+jvdfaD2sVqLaeoGx3Ln8OU4hcblmtvKX1Tm/+ilsb5J3r/e8NTkMMitg/HhTtdXNfeZl1jLtm58VyxofhYtfXyvTHfCGK53BVkX18O1OJ5S68SlyOau2In+BN4/hUdt7x3wp/VWMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767034077; c=relaxed/simple;
	bh=AUOtj0R2aG27+zRPLAM8MPEaafWGjVWNwCDbsus21Mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qZ1b4hpn5JAI2KjR0u+pm7ZapZIltZsOUTRwGhtreJ4nfeAFAKNl4IYHwYCRW8b6X7TErD9gHiziJ2N1CBAlHCioVdH3ntG6Fb0AiGGz6YAFzh+IPVhm/ouGI41QvpefUHlWEoDaMml4f6ryFb0Pu7QswvAT7mVAbCiAWPiBzAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AzzAZpCj; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so6902772b3a.0
        for <kvm@vger.kernel.org>; Mon, 29 Dec 2025 10:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1767034075; x=1767638875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HjlNaSuWDJGQZltEQ1Gr0JR+hacBIOSScxQel3kNd0c=;
        b=AzzAZpCj/6a2OdKhUn9VmBdGmE9YCNFS/rYp1c64gHK7U3IewKpW6bge5/pyj3wuuq
         z8qZ/YERVM+BCTC+gKz0XxBN1zyA7adafNQEZBsJ3wRzAtGKvLn243pMg9od00TJpKad
         qEMwYID3EtzqirHhUqikp6Y2eWHEwvbJ0JCjsDCbCuaw6tPLNEyMIuYKKlS5sLUBy0h4
         yEPfJOpT3yW54BG4W1FKmmXw9ETQVPkWbTHhsw4EH301+6T9nPOatpxK92sCCCO9rh0i
         mf2tBy4yY2e1Alc7H3JJdVxeGCUMkRpUNX410CBIV0wRgqT6qG5/a0DFs1/4S9Ff3T7A
         45Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767034075; x=1767638875;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HjlNaSuWDJGQZltEQ1Gr0JR+hacBIOSScxQel3kNd0c=;
        b=qCWs5LH0b/3eeTeTmTzWFApZDcmWxpQADggCWDslXCojsTuDj/B6PkCRDgNg9h85kL
         VhK42HLo2gqgQFlRVOIeTaAQCnWPxyOzmc/aXVvPWhMo6cdUFwVEXpzD2hWYZ3YtA9A3
         dPcv6pXsOLWtbVdcJRajQ1gQEcA/4/XMQUM/4kEPa8VIa8DBKHLkaRLaVFujEsqvbqdQ
         HG1H4qkmtz+FVdyY1yERpwVt92PLVnRO0YEMHwJboQqW9Sbmem/MqXZjtzD8I6kFmBjP
         2Vt5mGfwuCyngnTiott8gtlpPoKU9SGfbEVzXVoElzmFZrBdkEJ43zQ3i7ovmdYYu4Xx
         3UMg==
X-Forwarded-Encrypted: i=1; AJvYcCUgMAP/Ny5GwMUKqAGzOnaKYc1jyKvaorOVWFQwEGP0sugf/gEFFUwfWobA/PiSCT90l8s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1C5lCMEhZ85BGlWbbWRwFZpr7VEgVZt2GerypIsSyyDVUW8TP
	u3hTGh1EnJ+RQMys4nX9mF/3zzDcF3hNElZsMmx72ppChE2oIvV5qhqSCluEetLFZsk=
X-Gm-Gg: AY/fxX7UZUAaGyK1Oh0aUQ2rilpCrv8Qrvllt1lpjK1G8queUykEt1NCZsnz5SZSKsp
	EbJKjC/D1gag7K//Y9E4NWeVlEKWbZD/niHOxwoohg0o0XGRkyjMF5LBaMwnou2RC+WAfw79cQT
	WW9Ae2oyq+I1UdV1Mzd3ZK86X8hSYcaiJH60Jp+EGfVPDoYbqKCjGwSnPFep9HlU3xRh/DHU484
	gPjLOUKP+yO0VGxm6SUxWNmtW93GWz+APhM62Q/7WGOL//KXgtg174c6zU/fmN1vlHRM1ciJ/Gw
	JtSrtN643rHWI5F4VC6/pbBqly5y15zH/nDy9JWJ0HO/Iiby3zJD9N1YRssLpw2Uy9YD/wd3Kgi
	4qG++/+/WvFLhBznyPTVJ044dRBnJVmxIpxpVlX9L5g+maZ+20P30EvluffIxSCJ7856YtMd/Ae
	z/o1+j5Ke1OqzEtaugo6M2YJ6b2zoHJ5Fu7Qg4tVlu1L/RhNXLVT4pKquQ
X-Google-Smtp-Source: AGHT+IEUM+PySF9fE8H6bjy183pC3XDOTIMWhOvzxGMlStDSQ2Wun5rqsTGiiIaVABn6oh8OTNpFoA==
X-Received: by 2002:a05:6a00:e11:b0:7a2:6c61:23fc with SMTP id d2e1a72fcca58-7ff64ed12f8mr27507105b3a.10.1767034074553;
        Mon, 29 Dec 2025 10:47:54 -0800 (PST)
Received: from [192.168.1.87] (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19d8sm30113899b3a.42.2025.12.29.10.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 10:47:54 -0800 (PST)
Message-ID: <4344a029-90f1-4268-8822-779411de18ac@linaro.org>
Date: Mon, 29 Dec 2025 10:47:53 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/28] whpx: change memory management logic
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Zhao Liu <zhao1.liu@intel.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 kvm@vger.kernel.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, qemu-arm@nongnu.org,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, Peter Maydell
 <peter.maydell@linaro.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>
References: <20251228235422.30383-1-mohamed@unpredictable.fr>
 <20251228235422.30383-18-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251228235422.30383-18-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/25 3:54 PM, Mohamed Mediouni wrote:
> This allows edk2 to work on Arm, although u-boot is still not functional.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   accel/whpx/whpx-common.c | 97 +++++++++++++++-------------------------
>   1 file changed, 36 insertions(+), 61 deletions(-)
> 
> diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
> index 0d20b1d24c..e0db8ace4a 100644
> --- a/accel/whpx/whpx-common.c
> +++ b/accel/whpx/whpx-common.c
> @@ -259,89 +259,64 @@ void whpx_vcpu_kick(CPUState *cpu)
>    * Memory support.
>    */
>   
> -static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
> -                                void *host_va, int add, int rom,
> -                                const char *name)
> +static void whpx_set_phys_mem(MemoryRegionSection *section, bool add)
>   {
>       struct whpx_state *whpx = &whpx_global;
> +    MemoryRegion *area = section->mr;
> +    bool writable = !area->readonly && !area->rom_device;
> +    WHV_MAP_GPA_RANGE_FLAGS flags;
> +    uint64_t page_size = qemu_real_host_page_size();
> +    uint64_t gva = section->offset_within_address_space;
> +    uint64_t size = int128_get64(section->size);
>       HRESULT hr;
> +    void *mem;
>   
> -    /*
> -    if (add) {
> -        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
> -               (void*)start_pa, (void*)size, host_va,
> -               (rom ? "ROM" : "RAM"), name);
> -    } else {
> -        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
> -               (void*)start_pa, (void*)size, host_va, name);
> -    }
> -    */
> -
> -    if (add) {
> -        hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
> -                                         host_va,
> -                                         start_pa,
> -                                         size,
> -                                         (WHvMapGpaRangeFlagRead |
> -                                          WHvMapGpaRangeFlagExecute |
> -                                          (rom ? 0 : WHvMapGpaRangeFlagWrite)));
> -    } else {
> -        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
> -                                           start_pa,
> -                                           size);
> -    }
> -
> -    if (FAILED(hr)) {
> -        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
> -                     " Host:%p, hr=%08lx",
> -                     (add ? "MAP" : "UNMAP"), name,
> -                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
> +    if (!memory_region_is_ram(area)) {
> +        if (writable) {
> +            return;
> +        } else if (!memory_region_is_romd(area)) {
> +             add = false;
> +        }

ERROR: suspect code indent for conditional statements (8, 13)
#48: FILE: accel/whpx/whpx-common.c:277:
+        } else if (!memory_region_is_romd(area)) {
+             add = false;

Seems like a false positive from checkpatch, easier to write a second if 
to workaround this.

>       }
> -}
> -
> -static void whpx_process_section(MemoryRegionSection *section, int add)
> -{
> -    MemoryRegion *mr = section->mr;
> -    hwaddr start_pa = section->offset_within_address_space;
> -    ram_addr_t size = int128_get64(section->size);
> -    unsigned int delta;
> -    uint64_t host_va;
>   
> -    if (!memory_region_is_ram(mr)) {
> -        return;
> +    if (!QEMU_IS_ALIGNED(size, page_size) ||
> +        !QEMU_IS_ALIGNED(gva, page_size)) {
> +        /* Not page aligned, so we can not map as RAM */
> +        add = false;
>       }
>   
> -    delta = qemu_real_host_page_size() - (start_pa & ~qemu_real_host_page_mask());
> -    delta &= ~qemu_real_host_page_mask();
> -    if (delta > size) {
> -        return;
> -    }
> -    start_pa += delta;
> -    size -= delta;
> -    size &= qemu_real_host_page_mask();
> -    if (!size || (start_pa & ~qemu_real_host_page_mask())) {
> +    if (!add) {
> +        hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
> +                gva, size);
> +        if (FAILED(hr)) {
> +            error_report("WHPX: failed to unmap GPA range");
> +            abort();
> +        }
>           return;
>       }
>   
> -    host_va = (uintptr_t)memory_region_get_ram_ptr(mr)
> -            + section->offset_within_region + delta;
> +    flags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagExecute
> +     | (writable ? WHvMapGpaRangeFlagWrite : 0);
> +    mem = memory_region_get_ram_ptr(area) + section->offset_within_region;
>   
> -    whpx_update_mapping(start_pa, size, (void *)(uintptr_t)host_va, add,
> -                        memory_region_is_rom(mr), mr->name);
> +    hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
> +         mem, gva, size, flags);
> +    if (FAILED(hr)) {
> +        error_report("WHPX: failed to map GPA range");
> +        abort();
> +    }
>   }
>   
>   static void whpx_region_add(MemoryListener *listener,
>                              MemoryRegionSection *section)
>   {
> -    memory_region_ref(section->mr);
> -    whpx_process_section(section, 1);
> +    whpx_set_phys_mem(section, true);
>   }
>   
>   static void whpx_region_del(MemoryListener *listener,
>                              MemoryRegionSection *section)
>   {
> -    whpx_process_section(section, 0);
> -    memory_region_unref(section->mr);
> +    whpx_set_phys_mem(section, false);
>   }
>   
>   static void whpx_transaction_begin(MemoryListener *listener)


