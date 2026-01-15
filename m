Return-Path: <kvm+bounces-68175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 929E9D244DF
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B33FF30A768B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 11:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34566389E13;
	Thu, 15 Jan 2026 11:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/GYHkQN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RHy/8z0g"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D534A3803DA
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 11:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477467; cv=none; b=ZPVHS/gMrFs6Qatqjoz4lEZHHwezf+KaCQGiKDZk9CBKB0VIgVlFQnitqFwPggQCeXbl5SBfBzrhyok6TKKnmNEM4JmSype++vvPcgltZ8VOitcOTm7GZRWy99TxBJU/ppNilaOut0EL+72D3wsH+c3BAc8DaS8UfsC5hMhNgbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477467; c=relaxed/simple;
	bh=OE+Zb0KPf3u1WwOekjCRCTfCXnSX88Wa2F1s+0jdhpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0WjSEDTgirFDpCt+vteUW6SSXAjNhBINy4DkXL8gJcAOfpvlg+KObP5+aIefw0wL/xD/bOgWEILIjYasOHSjt6j70/kSAp5N8s3kIvRXXEKtfFEU1CAe4pMjMaVChpyBsAe2b/FSssfbeX4XxP5i49ba9JIeWhEXehjeNFWUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/GYHkQN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RHy/8z0g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768477460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B0mUnKqTDPYeGBq3J7FxGI1fg8tXB/i7Hy7CrdeMHoE=;
	b=A/GYHkQNcY7BfqD4qLCbnRMzK0/Mt2t7n9+mXXMxHLH/4fOz37KL0S23FdUmghG5BeQNkK
	dymn6T4HdCCrrapaX3h4oAyYFzTDdSLea9Kh8XHJTmPz1uXZ/rmL0ata3G2Cv69iz0xa65
	/zfPGohky0ZsH+Ins4j7HZrjC+d2wrE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-BVl24qmoM4OS4fBXDn1Fgg-1; Thu, 15 Jan 2026 06:44:19 -0500
X-MC-Unique: BVl24qmoM4OS4fBXDn1Fgg-1
X-Mimecast-MFC-AGG-ID: BVl24qmoM4OS4fBXDn1Fgg_1768477458
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4325aa61c6bso511208f8f.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 03:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768477458; x=1769082258; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0mUnKqTDPYeGBq3J7FxGI1fg8tXB/i7Hy7CrdeMHoE=;
        b=RHy/8z0gwciW6zJ7Oe9Hws629dbOiKm3wffMY8Gun8K5DwCAeWA9XgOUxibzvg4Qbd
         XXay2UD+ehQqfG3WNRyP+W//PhysyQFGBK6pkVEZ4ErE6qVWyK2c8htAWafcviI1977B
         F4eSCX7G3/7NMeEF+gdCfTkmdBWpheJWE2KNOPIj0Bh/+7Ocvjf4pCFfNK8/Igq8v4Rh
         9NnaI13conCpoBEiUt6CYL6SLqjqNcQwKb1bI8/gWgkPzBds30q7yu8N2SHOgWOQ9Bqy
         wktwpr4SpHLvXIxU8XBPfbPygDtcrkwZC06IlnPfmf4cD+PbfmiuPgNDAaQg79aiV3xC
         6lKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477458; x=1769082258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0mUnKqTDPYeGBq3J7FxGI1fg8tXB/i7Hy7CrdeMHoE=;
        b=cylzRd0ZQDC8Cc7UFs0ew9ySIWxY9ZNG9nv8OZCVDZIcy8PAPCQkle3ERSU7RElt8r
         WH0qNzMdvyBkzI5gcrZjCUHS4cRUk9Rm0WjbUDNVvypUm9oRQGCeXVBMGC12hGuyWox2
         oi06/nj1wMWWVwvl5fVMI88/ZDYVjko9yqPXZwAp7dwGnXnqMMNUkaGwhv3ehtLcQU0F
         En47daPw6pqV71h4qdtvwCFpiqa3XtLp3wLS3un3i0R6a31x3jYW87lJxzcBrSbJvuRX
         YxPxO23WTolGw9C77RYDBy3nNBaXlWc60WvIdQHZ4JQ1Rv/ker0os3ba1wwRvAeE52Nm
         +l1A==
X-Forwarded-Encrypted: i=1; AJvYcCX0bwXU0dukh5NeVVb4dOln4Y/jKzpQ2OUWPFJ3g2OhDEzoafeyto2bXx71ZtHZpAyDvms=@vger.kernel.org
X-Gm-Message-State: AOJu0YweRE/1lS+T4m09mRS6BdB/D5QfrJJjUZGYL1YvcIcS31lRLWun
	ht4GH1bpkGLwBwi6FytZmTbOrL8zkPmCoAn3SO3cArRT9vrumGl0Nlg5jmRx9JSHxN5V0SvLuMo
	bdLURqHUhE1uVHlcJJBDNuyJTofyXISLrT11VfQaZMfEk45joLv9U6A==
X-Gm-Gg: AY/fxX4btEcmYuy8qjfbdGnwfcmNZh4e8qVD3KzrLH212NAdo3yUIlduyu4noiOeaUD
	w7lB4FvFD4s1z6mBepGLABZxUn2eoHKrY5IA63CIoIuPOvhggPMh8oQ0yJsKUv9MU0LH50szkgf
	DJ5ckgaUei8vrs79f7aMz1i9Uc5cUQ30PG5j9SqO8GqYQFR9W0SEKJaaolMmhw0VMeZqNO8+cvg
	9pC08l1y0hxEWuYC1Tw3PnhE7HiYQvL+Ke1zlDn9JF9Thgni4rB68De9odppqh488anPAbgsiN3
	KAYpGAWv4mAcWxbyDWDXjit+zUQNUznNEgKG+IvgyXqbcJqQA0OGqbNYd82+/ZBlyTyksXSuv7s
	bxnbpykteUW1atMc=
X-Received: by 2002:a05:6000:26c6:b0:430:f40f:61b9 with SMTP id ffacd0b85a97d-4342c4ef09emr6865165f8f.4.1768477458371;
        Thu, 15 Jan 2026 03:44:18 -0800 (PST)
X-Received: by 2002:a05:6000:26c6:b0:430:f40f:61b9 with SMTP id ffacd0b85a97d-4342c4ef09emr6865132f8f.4.1768477457900;
        Thu, 15 Jan 2026 03:44:17 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af6b143fsm5374205f8f.25.2026.01.15.03.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:44:17 -0800 (PST)
Date: Thu, 15 Jan 2026 12:44:14 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Richard Henderson <richard.henderson@linaro.org>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v4 3/5] igvm: Add common function for finding parameter
 entries
Message-ID: <aWjQyUrF_bLIhm9H@leonardi-redhat>
References: <20260114175007.90845-1-osteffen@redhat.com>
 <20260114175007.90845-4-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260114175007.90845-4-osteffen@redhat.com>

Hi Oliver,

On Wed, Jan 14, 2026 at 06:50:05PM +0100, Oliver Steffen wrote:
>Move repeating code for finding the parameter entries in the IGVM
>backend out of the parameter handlers into a common function.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm.c | 117 +++++++++++++++++++++++++-----------------------
> 1 file changed, 61 insertions(+), 56 deletions(-)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index a350c890cc..ccb2f51cd9 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -95,6 +95,19 @@ typedef struct QIgvm {
>     unsigned region_page_count;
> } QIgvm;
>
>+static QIgvmParameterData*
>+qigvm_find_param_entry(QIgvm *igvm, const IGVM_VHS_PARAMETER *param)
>+{
>+    QIgvmParameterData *param_entry;
>+    QTAILQ_FOREACH(param_entry, &igvm->parameter_data, next)
>+    {
>+        if (param_entry->index == param->parameter_area_index) {
>+            return param_entry;
>+        }
>+    }
>+    return NULL;
>+}
>+
> static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
>                                      Error **errp);
> static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
>@@ -569,58 +582,53 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
>     }
>
>     /* Find the parameter area that should hold the memory map */
>-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>-    {
>-        if (param_entry->index == param->parameter_area_index) {
>-            max_entry_count =
>-                param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
>-            mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
>-
>-            retval = get_mem_map_entry(entry, &cgmm_entry, errp);
>-            while (retval == 0) {
>-                if (entry >= max_entry_count) {
>-                    error_setg(
>-                        errp,
>-                        "IGVM: guest memory map size exceeds parameter area defined in IGVM file");
>-                    return -1;
>-                }
>-                mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
>-                mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
>-
>-                switch (cgmm_entry.type) {
>-                case CGS_MEM_RAM:
>-                    mm_entry[entry].entry_type =
>-                        IGVM_MEMORY_MAP_ENTRY_TYPE_MEMORY;
>-                    break;
>-                case CGS_MEM_RESERVED:
>-                    mm_entry[entry].entry_type =
>-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>-                    break;
>-                case CGS_MEM_ACPI:
>-                    mm_entry[entry].entry_type =
>-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>-                    break;
>-                case CGS_MEM_NVS:
>-                    mm_entry[entry].entry_type =
>-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PERSISTENT;
>-                    break;
>-                case CGS_MEM_UNUSABLE:
>-                    mm_entry[entry].entry_type =
>-                        IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>-                    break;
>-                }
>-                retval = get_mem_map_entry(++entry, &cgmm_entry, errp);
>-            }
>-            if (retval < 0) {
>-                return retval;
>-            }
>-            /* The entries need to be sorted */
>-            qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
>-                  qigvm_cmp_mm_entry);
>+    param_entry = qigvm_find_param_entry(ctx, param);
>+    if (param_entry == NULL) {
>+        return 0;
>+    }
>+
>+    max_entry_count = param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
>+    mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
>
>+    retval = get_mem_map_entry(entry, &cgmm_entry, errp);
>+    while (retval == 0) {
>+        if (entry >= max_entry_count) {
>+            error_setg(
>+                errp,
>+                "IGVM: guest memory map size exceeds parameter area defined in IGVM file");
>+            return -1;
>+        }
>+        mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
>+        mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
>+
>+        switch (cgmm_entry.type) {
>+        case CGS_MEM_RAM:
>+            mm_entry[entry].entry_type = IGVM_MEMORY_MAP_ENTRY_TYPE_MEMORY;
>+            break;
>+        case CGS_MEM_RESERVED:
>+            mm_entry[entry].entry_type =
>+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>+            break;
>+        case CGS_MEM_ACPI:
>+            mm_entry[entry].entry_type =
>+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>+            break;
>+        case CGS_MEM_NVS:
>+            mm_entry[entry].entry_type = IGVM_MEMORY_MAP_ENTRY_TYPE_PERSISTENT;
>+            break;
>+        case CGS_MEM_UNUSABLE:
>+            mm_entry[entry].entry_type =
>+                IGVM_MEMORY_MAP_ENTRY_TYPE_PLATFORM_RESERVED;
>             break;
>         }
>+        retval = get_mem_map_entry(++entry, &cgmm_entry, errp);
>     }
>+    if (retval < 0) {
>+        return retval;
>+    }
>+    /* The entries need to be sorted */
>+    qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
>+          qigvm_cmp_mm_entry);
>     return 0;
> }
>
>@@ -655,14 +663,11 @@ static int qigvm_directive_environment_info(QIgvm *ctx,
>     QIgvmParameterData *param_entry;
>     IgvmEnvironmentInfo *environmental_state;
>
>-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>-    {
>-        if (param_entry->index == param->parameter_area_index) {
>-            environmental_state =
>-                (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
>-            environmental_state->memory_is_shared = 1;
>-            break;
>-        }
>+    param_entry = qigvm_find_param_entry(ctx, param);
>+    if (param_entry != NULL) {

What about an early return?

>+        environmental_state =
>+            (IgvmEnvironmentInfo *)(param_entry->data + 
>param->byte_offset);
>+        environmental_state->memory_is_shared = 1;
>     }
>     return 0;
> }
>-- 2.52.0
>

Can we reuse `qigvm_find_param_entry` for 
`qigvm_directive_parameter_insert` and `qigvm_directive_vp_count` as 
well?

Luigi


