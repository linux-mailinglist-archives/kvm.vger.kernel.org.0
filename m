Return-Path: <kvm+bounces-69536-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKAVCAJAe2mNCwIAu9opvQ
	(envelope-from <kvm+bounces-69536-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:09:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A00AF6EE
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 725303007488
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 11:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38280385EC3;
	Thu, 29 Jan 2026 11:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ue2yBGOv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BLBuKwbJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE1838550B
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 11:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684990; cv=none; b=fZ/oQYYTJrcR3/KIhFng2o8yqOUr8aW0Uo88xknBj/jX2VkhpjdAhJpsTbEdUMHUpjG4u8T7G86WaMPGLrnxsQzBF/eyvKujSFjR9vuyWIZRqSg56DiHiZuuCKq608m6N8Ub2SzYX6vZ5AdtxgAXdKtQgDFthkj2fCBA7QpoJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684990; c=relaxed/simple;
	bh=rWaHL/+Aa4jJNN4A3anGYGHsLCdOxfo24cK2Eyqyj10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GcS998zIICD0RL4tWtTceKSrVukksN02lotuEixcAX8vLArYK2GL6yPOYkJEXX8LvIVTcuPwC3z/MqYUb2WPlyMPla999X46pkEbTnMcc413NaeuZEPiaUXfBVjP6liKkwM7Mhw6Y/sC8xNH+Ff/ydYyB2LWiNTkY60DXlp+9OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ue2yBGOv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BLBuKwbJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769684987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TkHgRwXBNoQjtv8jea8xR991tHIKZLt4Po4JRLHOOp8=;
	b=Ue2yBGOvGu4N9/ZDZTyWrqh6lbhupYkXBhO/3Fqhav5MCB/3phwZpfmbLM8+lvWv7PH2XZ
	n1kPtG0UeLeuWJYrLW3S3FIN3uw2GGiqvIaCctVWikGYtCSrYXnWc/XvLpjAUNCbJtBbpb
	Hho/GvKpyr5nRGzdZuWX2G+2Fu99OUY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-CSnWXIFGN1638LeD2938ow-1; Thu, 29 Jan 2026 06:09:46 -0500
X-MC-Unique: CSnWXIFGN1638LeD2938ow-1
X-Mimecast-MFC-AGG-ID: CSnWXIFGN1638LeD2938ow_1769684985
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48069a43217so7918625e9.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 03:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769684985; x=1770289785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkHgRwXBNoQjtv8jea8xR991tHIKZLt4Po4JRLHOOp8=;
        b=BLBuKwbJaet8OCZiBwRsLc5tDUGBf8kb4xkA+KKAk1A+l4TFtZ+kJujxmkNcuRWqAO
         8CtEnQSTZA0NwAwaQmbUL1WBm3hFCUCP5KLPVBkjJqFlloLvAmwkOhEoSdATMDL9PTjp
         2V0aFxlfZktW+ZutvPgpS5o/b9bQJO/6/Tf0ETYwjiCXX8nDz5X+EnZhDONdp2NIkWBN
         /mKULJOWN9dOgzFZVRBvHaKbZ0KEDm3uHf32LjrgZCmsNBDKCpov/CFkAoz7ziHub6vF
         GNXUyCejMX+V9r5SHxSrUnde4fqIg6Dgep0X4zNThMVjl1qtNHtqURTlO7vdab85wmXG
         tCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769684985; x=1770289785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TkHgRwXBNoQjtv8jea8xR991tHIKZLt4Po4JRLHOOp8=;
        b=lZgFxXog11UHdStOu6wc34HMtadL7cHAmUGiSl/BD29sP1oAsHQ+OqeUdqutkcEYEE
         X6PsKahmfYUWNlcgZ/+HaosqOGDM2gujCV8nGsAvQ0k/xy7lvY/28IbUATTsrewASsXn
         MI3TQ/qdheZi8628EJAloAjkVHRUZNun4gSEezXpKmuFMauQvqmP2EEpG1mOUzA6GDLS
         YwUzF737mbt3A5l+4wsin9A93WeWpS2vKkiE6n96PkHX4Rx7pRe55sG0c+gsx2b3ZhTa
         FuH2fgOkzhPNnMRjNx2ZGHbNJehqwOO7VSwPxwC9LyHw4WtOX/hlI3FSnYGWyP56a28b
         u/dg==
X-Forwarded-Encrypted: i=1; AJvYcCUfc97CQx7Qq+AG9AsnCgcLH43ok3MqqXv57zkXeZ6REqTZ67F6Edzj7AVvX5t6y4T88IU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7k7/Au45tcqyfy9Hvo+7esunyzKBS3fPejCw+EwRJ5834m1kC
	VCxpdQoIrSJkDiOH0Rc87RA5HVG2CpXnAn43pqE14Eh7bZtBtjnB/yweYD2x64swGzcoK3msGoi
	OUbri8CMhIMzrgEVTpN+yPqFrAWplIPxUdIo7DIEmaHZRHAj4/kL44A==
X-Gm-Gg: AZuq6aJOHkSlgDoPZkHGz4K+AbtAWxI6MouxW+cGM1Iq86EzkMeZGUeXAVQWJ7QR0s5
	vCKgQiIS3KUWsiuaL8FviwyhWNd9trzNz/XYHCcQOhzyuRdX1hxP9oLaGy7SSGnid3l706ifQ6O
	dbgH/Ru+gc0yeecnBFD9bAVCClkY0+hBdYVPvzETo7jd+P2aLrYX2xxo5ljVIVFGDScjLihoY61
	8v6cGUpJyhWJu/wrvLSNI6x/rwOavEOsiq8jsuP4AVy4O80s0weUGNK+1HXmPBMNbr3mwV+qJIm
	RULEMYdHBU8xxcKmHGisofahVrjNoPy7M1frFU7QfDDPgO5jK68tS1HgH/w5ck4Ddt7oSvJdZ30
	/wH/DbO/T9N4mzg==
X-Received: by 2002:a05:600c:c83:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-48069c9a4e2mr100868875e9.29.1769684985037;
        Thu, 29 Jan 2026 03:09:45 -0800 (PST)
X-Received: by 2002:a05:600c:c83:b0:476:d494:41d2 with SMTP id 5b1f17b1804b1-48069c9a4e2mr100868495e9.29.1769684984536;
        Thu, 29 Jan 2026 03:09:44 -0800 (PST)
Received: from leonardi-redhat ([176.206.38.57])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee562sm13967057f8f.18.2026.01.29.03.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 03:09:43 -0800 (PST)
Date: Thu, 29 Jan 2026 12:09:41 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Igor Mammedov <imammedo@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Ani Sinha <anisinha@redhat.com>, kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH v5 3/6] igvm: Add common function for finding parameter
 entries
Message-ID: <aXs_30LoEwVjCSg1@leonardi-redhat>
References: <20260127100257.1074104-1-osteffen@redhat.com>
 <20260127100257.1074104-4-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260127100257.1074104-4-osteffen@redhat.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69536-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[nongnu.org,redhat.com,habkost.net,intel.com,gmail.com,linaro.org,vger.kernel.org,amd.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leonardi@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B2A00AF6EE
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 11:02:54AM +0100, Oliver Steffen wrote:
>Move repeating code for finding the parameter entries in the IGVM
>backend out of the parameter handlers into a common function.
>
>A warning message is emitted in case a no parameter entry can be found
>for a given index.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm.c | 143 ++++++++++++++++++++++++++----------------------
> 1 file changed, 77 insertions(+), 66 deletions(-)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index 4cf7b57234..213c9d337e 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -12,6 +12,7 @@
> #include "qemu/osdep.h"
>
> #include "qapi/error.h"
>+#include "qemu/error-report.h"
> #include "qemu/target-info-qapi.h"
> #include "system/igvm.h"
> #include "system/igvm-cfg.h"
>@@ -97,6 +98,20 @@ typedef struct QIgvm {
>     unsigned region_page_count;
> } QIgvm;
>
>+static QIgvmParameterData*
>+qigvm_find_param_entry(QIgvm *igvm, uint32_t parameter_area_index)
>+{
>+    QIgvmParameterData *param_entry;
>+    QTAILQ_FOREACH(param_entry, &igvm->parameter_data, next)
>+    {
>+        if (param_entry->index == parameter_area_index) {
>+            return param_entry;
>+        }
>+    }
>+    warn_report("IGVM: No parameter area for index %u", parameter_area_index);
>+    return NULL;
>+}
>+
> static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
>                                      Error **errp);
> static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
>@@ -571,58 +586,54 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
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
>+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
>+    if (param_entry == NULL) {
>+        return 0;
>+    }
>+
>+    max_entry_count = param_entry->size / sizeof(IGVM_VHS_MEMORY_MAP_ENTRY);
>+    mm_entry = (IGVM_VHS_MEMORY_MAP_ENTRY *)param_entry->data;
>+
>+    retval = get_mem_map_entry(entry, &cgmm_entry, errp);
>+    while (retval == 0) {
>+        if (entry >= max_entry_count) {
>+            error_setg(
>+                errp,
>+                "IGVM: guest memory map size exceeds parameter area defined "
>+                "in IGVM file");
>+            return -1;
>+        }
>+        mm_entry[entry].starting_gpa_page_number = cgmm_entry.gpa >> 12;
>+        mm_entry[entry].number_of_pages = cgmm_entry.size >> 12;
>
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
>+    }
>+    if (retval < 0) {
>+        return retval;
>     }
>+    /* The entries need to be sorted */
>+    qsort(mm_entry, entry, sizeof(IGVM_VHS_MEMORY_MAP_ENTRY),
>+          qigvm_cmp_mm_entry);
>     return 0;
> }
>
>@@ -634,18 +645,18 @@ static int qigvm_directive_vp_count(QIgvm *ctx, const uint8_t *header_data,
>     uint32_t *vp_count;
>     CPUState *cpu;
>
>-    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
>+    if (param_entry == NULL) {
>+        return 0;
>+    }
>+
>+    vp_count = (uint32_t *)(param_entry->data + param->byte_offset);
>+    *vp_count = 0;
>+    CPU_FOREACH(cpu)
>     {
>-        if (param_entry->index == param->parameter_area_index) {
>-            vp_count = (uint32_t *)(param_entry->data + param->byte_offset);
>-            *vp_count = 0;
>-            CPU_FOREACH(cpu)
>-            {
>-                (*vp_count)++;
>-            }
>-            break;
>-        }
>+        (*vp_count)++;
>     }
>+
>     return 0;
> }
>
>@@ -657,15 +668,15 @@ static int qigvm_directive_environment_info(QIgvm *ctx,
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
>+    param_entry = qigvm_find_param_entry(ctx, param->parameter_area_index);
>+    if (param_entry == NULL) {
>+        return 0;
>     }
>+
>+    environmental_state =
>+        (IgvmEnvironmentInfo *)(param_entry->data + param->byte_offset);
>+    environmental_state->memory_is_shared = 1;
>+
>     return 0;
> }
>
>-- 
>2.52.0
>

LGTM!

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>


