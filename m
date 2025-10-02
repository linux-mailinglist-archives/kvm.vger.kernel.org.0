Return-Path: <kvm+bounces-59389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC05BB284B
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 07:16:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 955F77B0DE6
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 05:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D5861E5B72;
	Thu,  2 Oct 2025 05:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gx2yPDYz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730AF2AF1D
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 05:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759382205; cv=none; b=q4iEVk73FhZuKx/Z60TsLY8sSJbGrFUj8qjMsyjThJKBcPRytRX+TNWAEjbDZMJjhdiNaaKMGnHIuYIkYl6UvFCMHn71CMjYMT6jJN18PNPpddGUx7iDpI3vcf6uKHdCGw756tWpaPjli93MOmluUncR0F+ZydCSKrFhFCT9AmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759382205; c=relaxed/simple;
	bh=uLxLwFOE/rQGNhrBcHl0yxHQQEm07KXFtX9lK1L5xIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDczVzrtFmq3zBqx4YiFw0sa++4W/J95wGlhMEwIe/rpfwM+TwhBil1PIHK9x8mwDBK9tU0B5Jita1OJRi4xMvnD9fstiTZKF9tlAbHzX5mbYQ0026FyiE20nSOJbO1j27Bz5B07orllERy9ACFHokUz5lTC1DRi++wGDVNB/s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gx2yPDYz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso3202225e9.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 22:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759382202; x=1759987002; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nP44d4h1jekHn6mFqnHJmhmS/9Do5wl9GUaQdd3lrCA=;
        b=gx2yPDYzjnOUYff5czycMnSucYvN33t29IEMGCzdodhWAk/fqkOiNa4a2El2myD0u0
         vQlxnYXaq6OysY56lZuqhqx0OnB77STPIlD8HlYG/RGNZ0bh7ioLJIIjUopXzM7SEvAs
         c+1q1760nAiMjt7gMrkkSeAGMyYDVIJ5Cs2d18qMbHUVfDwr5OBio+uX7QkFTd6lcx0z
         OSskkF0xKBXRLz23jMDhnsrMBENyu5m5QgrH75R5GTC/apzGLjgy2BDraleL7a2ukQsS
         FhIAx1fCOTyU2adHHLMUTfyIYv9XcJzGSqJhRJkAxEB6umG4QKb3NNvW1JNmloalU2JL
         tqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759382202; x=1759987002;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nP44d4h1jekHn6mFqnHJmhmS/9Do5wl9GUaQdd3lrCA=;
        b=XdhqEvZzNgpxhYzQ9qhCpWFqm91FG7uVIyRVylVNnGUXL8A3cSbPCNjQcT+u0EqWlB
         ZjRjE6YVmybxxbeGG7hj/BXPeIa5hdpNkrWRwqLSbXK6d/M2PAtQw2DhMlwzg7y8k0RM
         tEUM18LMZwWd3BsQ6TtI+RpMaX088fzbovUbJ494KnW1XuNAXIvecxVJBNqlT0fxQ6Wg
         tv8L8Roo3Ut0N4VRhvSAlO2LAJWHJ/R2JvMmjhy8Td6U8CzGcPvmC6XIj3W5DrH3hkt3
         GhFLqTSUPIxK8d/WQ8npzZYXzqRw7xyJf4qYQOtNacYCq6CHTkcSD/n1GwY2/8f7XYp2
         YAQA==
X-Forwarded-Encrypted: i=1; AJvYcCWkKcQ3cnqUBSRShYuzos98a4/gQg1g4HkjxTtRc4ZhAx8yycEkEUdWFFOkLdK3adTmm5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeiWSAgiAeN04r+i0knG3ahSqivzDdER1SUhf1pzvhijhO58G8
	ZUgTvcaEomRket5+eFg9IlGeH2Bj/nam33VpLuRucu2yYUhYCLxmTlgo51ng9ztMXaA=
X-Gm-Gg: ASbGncslosCVVms7FDv/nkXInZPVUcCgFZfsNiBg6huVD97sHy3EwrtNO9rn4JbkF2A
	52ya0qI9Id/YNtDlvhamyHNjA2bqP80CbDz7IgYlfv7CGtwCTNGBRzl3b8fLyx1R84DcGV6fB4S
	VloLvkS7g5CdKY28GRYSL9bKBpCJ0r/dLbRddKFNJpjWAHleiunnFchxfLFxGuOhSoc/lYFo9aa
	tUkm+Ssbhof32EwHCall8YexQnmjiFTiKEt8l7EPIKU1zbqM5+fsirWZY9XqY9J3C/2He5yxDX2
	qo0cZfIns8mBD8rAa8ZCB2Pv5AfT9v3u1j0w8WVJOY/8luAITaD5oJCjzHUlSIY5/pHGCq/nef1
	Fz7TjM92BulAk/OrjqEVxxgoHmoxw9nywXDAJ3m1YCqlyEM/zGb3QxEGPFrEn6KKq8AYTtfpDhP
	f+2Us68Ag4IMuxK/IrEmwSuFk=
X-Google-Smtp-Source: AGHT+IFTCkFMkkXlWMIq3Vgvzt5IFWI271cdWtVJqy/RZz/1PwzpzG3SNgfPDaXsmuZn+VswPUUmHA==
X-Received: by 2002:a05:600c:3544:b0:46e:5df4:6f16 with SMTP id 5b1f17b1804b1-46e61294d1emr46097095e9.35.1759382201614;
        Wed, 01 Oct 2025 22:16:41 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a022d8sm62129355e9.12.2025.10.01.22.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 22:16:41 -0700 (PDT)
Message-ID: <b85d3293-0fcc-40ef-a170-256a20eb91cb@linaro.org>
Date: Thu, 2 Oct 2025 07:16:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/23] whpx: copy over memory management logic from hvf
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
Cc: Shannon Zhao <shannon.zhaosl@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, Phil Dennis-Jordan
 <phil@philjordan.eu>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Mads Ynddal <mads@ynddal.dk>,
 Cameron Esfahani <dirty@apple.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 kvm@vger.kernel.org, Igor Mammedov <imammedo@redhat.com>,
 qemu-arm@nongnu.org, Roman Bolshakov <rbolshakov@ddn.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Alexander Graf <agraf@csgraf.de>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
References: <20250920140124.63046-1-mohamed@unpredictable.fr>
 <20250920140124.63046-13-mohamed@unpredictable.fr>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250920140124.63046-13-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/9/25 16:01, Mohamed Mediouni wrote:
> This allows edk2 to work, although u-boot is still not functional.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   accel/whpx/whpx-common.c | 201 ++++++++++++++++++++++++++++-----------
>   1 file changed, 147 insertions(+), 54 deletions(-)
> 
> diff --git a/accel/whpx/whpx-common.c b/accel/whpx/whpx-common.c
> index c69792e638..f324f5c146 100644
> --- a/accel/whpx/whpx-common.c
> +++ b/accel/whpx/whpx-common.c
> @@ -258,89 +258,174 @@ void whpx_vcpu_kick(CPUState *cpu)
>    * Memory support.
>    */
>   
> -static void whpx_update_mapping(hwaddr start_pa, ram_addr_t size,
> -                                void *host_va, int add, int rom,
> -                                const char *name)
> + /* whpx_slot flags */
> +#define WHPX_SLOT_LOG (1 << 0)
> +typedef struct whpx_slot {
> +    uint64_t start;
> +    uint64_t size;
> +    uint8_t *mem;
> +    int slot_id;
> +    uint32_t flags;
> +    MemoryRegion *region;
> +} whpx_slot;
> +
> +typedef struct WHPXState {
> +    whpx_slot slots[32];
> +    int num_slots;
> +} WHPXState;
> +
> + WHPXState *whpx_state;
> +
> + struct mac_slot {
> +    int present;
> +    uint64_t size;
> +    uint64_t gpa_start;
> +    uint64_t gva;
> +};
> +
> +struct mac_slot mac_slots[32];
> +
> +static int do_whpx_set_memory(whpx_slot *slot, WHV_MAP_GPA_RANGE_FLAGS flags)
>   {
>       struct whpx_state *whpx = &whpx_global;
> +    struct mac_slot *macslot;
>       HRESULT hr;
>   
> -    /*
> -    if (add) {
> -        printf("WHPX: ADD PA:%p Size:%p, Host:%p, %s, '%s'\n",
> -               (void*)start_pa, (void*)size, host_va,
> -               (rom ? "ROM" : "RAM"), name);
> -    } else {
> -        printf("WHPX: DEL PA:%p Size:%p, Host:%p,      '%s'\n",
> -               (void*)start_pa, (void*)size, host_va, name);
> +    macslot = &mac_slots[slot->slot_id];
> +
> +    if (macslot->present) {
> +        if (macslot->size != slot->size) {
> +            macslot->present = 0;
> +            hr = whp_dispatch.WHvUnmapGpaRange(whpx->partition,
> +                 macslot->gpa_start, macslot->size);
> +            if (FAILED(hr)) {
> +                abort();
> +            }
> +        }
>       }
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
> +
> +    if (!slot->size) {
> +        return 0;
>       }
>   
> -    if (FAILED(hr)) {
> -        error_report("WHPX: Failed to %s GPA range '%s' PA:%p, Size:%p bytes,"
> -                     " Host:%p, hr=%08lx",
> -                     (add ? "MAP" : "UNMAP"), name,
> -                     (void *)(uintptr_t)start_pa, (void *)size, host_va, hr);
> +    macslot->present = 1;
> +    macslot->gpa_start = slot->start;
> +    macslot->size = slot->size;
> +    hr = whp_dispatch.WHvMapGpaRange(whpx->partition,
> +         slot->mem, slot->start, slot->size, flags);
> +    return 0;
> +}

[...]

This HVF code is bogus and Richard has been heavily reworking it. We
haven't posted the changes so far, but IMHO it is worth waiting them
to compare before proceeding with this series. I'll let Richard briefly
explain what we had to change ;)

Regards,

Phil.

