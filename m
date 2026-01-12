Return-Path: <kvm+bounces-67705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9182CD116BA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:12:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BCFA3064C1A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BD534678B;
	Mon, 12 Jan 2026 09:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BY1YUvB6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVaP63HT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A60330BF60
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768208996; cv=none; b=YaZ37ZS27Hz76UxuxvB4Cd/B/zcnByz2BTz9rd67CHGdR4X9xNYathhjqLwP+lZecOsruqxKITG0wTouOAFiQdtgXiJ0KWYxXSbeeYJOYBQ4VnU5TvyQrcXiN6zAqFH5Mv9AqpQ+FQHvt9bbp3oUvmRbLyBs3DhXZSlZz7/Y9G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768208996; c=relaxed/simple;
	bh=VpvGzelGV1JA5CERLxcVxH60hjfr7JyLWJ63zWqqGIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESacAsTvKK2SytNTR9M6+hVl+sz6pK0mOyeZuCyezNLbPd71yo5TokJJ8PJd75GwrPncjYTpE1X5J4blz+T9SpWKDcNhoZIzEZsPQCcLbT1d0vqmy5erWhN9dZXDBUCEL6d5LnhK6fC3JAVycoI6l7Y7PNFHk9bDRopzt3IXChY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BY1YUvB6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YVaP63HT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768208994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZSuT/0CZJUlxPAoAkk/Cbo2iXK2663iq+mn9uRQOZp8=;
	b=BY1YUvB6PwxeTDUoEcl1adToW8x8oVLX5sSscjyQU0+ktazZPRO3zZNQFWPjaFIpYJ8sC5
	JUNV68QJ5xP13bgbOmDhdTXOQgxFRwK4fKxAqkhXmuvc+Al4b5orJR6ctYTZSj1eK21Iot
	D09elPhdd0beVNsBpoxHFy2YnM8ICg4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-JMMYQ6avOkWMTzZlvNIoZQ-1; Mon, 12 Jan 2026 04:09:52 -0500
X-MC-Unique: JMMYQ6avOkWMTzZlvNIoZQ-1
X-Mimecast-MFC-AGG-ID: JMMYQ6avOkWMTzZlvNIoZQ_1768208991
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430f527f5easo2657482f8f.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 01:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768208991; x=1768813791; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSuT/0CZJUlxPAoAkk/Cbo2iXK2663iq+mn9uRQOZp8=;
        b=YVaP63HTzOVHf3d5wlFsPzS/DdOGjS/1FWgIQGyOsRurf0oePEj/v31hiQw0f9GBqF
         dPCGlOZMsqKPFuPrrjZcjVsbkyh+R0P2gpvgBOPt/VZ+k2f8Rq4Gfyo2MSGS13dJNOsA
         cR8zzAesCPnopnpW9OrvKV6RGU3bPI91SoNubHzWttJOqBBqynBkTxBmkF5x2+X5L3vc
         Px8SP+Z6tZ2FQwr4xzBvGOff37wrZLSsxHLTNL4frcFgEpxN1D+tswLWMNrvAD+wpx2s
         pFzCSYEMY40UBveLAOnJU5wWNDqNwwr3QdB3bV9BUEkKHeVGgD6QHLJlj+IKtuGNGwGY
         sZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768208991; x=1768813791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZSuT/0CZJUlxPAoAkk/Cbo2iXK2663iq+mn9uRQOZp8=;
        b=Re5Ku7pWaOrs0GPTCOUJaM7irrHe4f5seYPaLhoSmorldCD5zmx1r+d/shXq0DJ/xf
         a7KDrOkAEy+aeK3+h4jfvty3Zchm23VEo5R7E+7CSYEPEWQiRo1MdqDyxjytzT0tFmRx
         QaNMGS5WJRW0xPWmDmLzrS9YxRiOL8/8w4+b7QHOEnd5vyHy1NTIfbXeGpve40DcBJy7
         B/tfKpu79bbFN1Nx4jKxfplGHKEqxvGO6fvQP1mpEslTtMBqyxbZJBSqTIlPRvodCuIe
         e8MauVmJPLVQZtOz9Tw1jDkqLzIipZCE8bJ6uYR5744pJOuW7Br+XGS65JvppwSQxXS/
         qRmg==
X-Forwarded-Encrypted: i=1; AJvYcCWxU//1NFblVx70cD8K38i33p+lp2GQiVRHYnqPULmzlx8sTwHYutj5W7FUbfSCub/Kpwk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3nf7osErxC+6LlqcXu4e0tDcEkO2NNeSezxdt0ekBfXnibyxo
	pNPiOz1WQ7/mKLc6fWMe4WmUVB7GriTRuctGJMAuZ4L+Xq551F41tfoHAaETqlT9KkFrUcj0d58
	/iZQTfJLbEBFH6DZWvsFuHfdG83Y248LeYoqFbYkrSAdEVn+/GhEyqw==
X-Gm-Gg: AY/fxX4mPVo34MmDE7Vdv+IBy0W/Xteo4qCaOf3GiQKs71KB5TsfyI0j1AjpOdGWXSk
	5A6/AH6UPQWKgUbeqNhD22gxesnez3D/ns0jQeG94fisvd70qLMwo2Y2LZw4o9PyKZkLiRhcE51
	UgbxyhZEH4ph80vlsZP7iMghwKIRe/c5GgV22ib7+tVucKLTcFyxL/QBT+WNHPi2nhVdJ4vBcLg
	4UobOmtnd2nItlZTKyrw95CelVjyMxrZrJcmZM/mdJsa0OyuiYucorTiKajc3bhhW+I7fZWOApa
	HQK0yuWs/FmfWnKrGwx3+/X4ketDiwgC6QVYkmmcgUwBR20O3Iz/KKFc73ENpQQT2d/hO2xg0Hv
	BGlw7+zUNxj5R6xo=
X-Received: by 2002:a5d:588e:0:b0:432:dcb1:68bc with SMTP id ffacd0b85a97d-432dcb168f0mr9994003f8f.23.1768208990800;
        Mon, 12 Jan 2026 01:09:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEou46/tWfcOz7Gf/aBTaWgoyngU5ScXeNfqrgld1bOD14Qw8AG6MvtX59+5RA8ur25K5gxiA==
X-Received: by 2002:a5d:588e:0:b0:432:dcb1:68bc with SMTP id ffacd0b85a97d-432dcb168f0mr9993968f8f.23.1768208990364;
        Mon, 12 Jan 2026 01:09:50 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e16f4sm38411242f8f.11.2026.01.12.01.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 01:09:49 -0800 (PST)
Date: Mon, 12 Jan 2026 10:09:40 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 5/6] igvm: Pass machine state to IGVM file processing
Message-ID: <aWS51gJnoQTIDIaO@leonardi-redhat>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-6-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260109143413.293593-6-osteffen@redhat.com>

On Fri, Jan 09, 2026 at 03:34:12PM +0100, Oliver Steffen wrote:
>Add a new MachineState* parameter to qigvm_process_file()
>to make the machine state available in the IGVM processing
>context. We will use it later to generate MADT data there
>to pass to the guest as IGVM parameter.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm-cfg.c       | 2 +-
> backends/igvm.c           | 6 +++++-
> include/system/igvm-cfg.h | 3 ++-
> include/system/igvm.h     | 3 ++-
> target/i386/sev.c         | 2 +-
> 5 files changed, 11 insertions(+), 5 deletions(-)
>
>diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
>index c1b45401f4..d79bdecab1 100644
>--- a/backends/igvm-cfg.c
>+++ b/backends/igvm-cfg.c
>@@ -51,7 +51,7 @@ static void igvm_reset_hold(Object *obj, ResetType type)
>
>     trace_igvm_reset_hold(type);
>
>-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
>+    qigvm_process_file(igvm, ms->cgs, false, ms, &error_fatal);
> }
>
> static void igvm_reset_exit(Object *obj, ResetType type)
>diff --git a/backends/igvm.c b/backends/igvm.c
>index a797bd741c..7390dee734 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -11,6 +11,7 @@
>
> #include "qemu/osdep.h"
>
>+#include "hw/boards.h"
> #include "qapi/error.h"
> #include "qemu/target-info-qapi.h"
> #include "system/igvm.h"
>@@ -93,6 +94,7 @@ typedef struct QIgvm {
>     unsigned region_start_index;
>     unsigned region_last_index;
>     unsigned region_page_count;
>+    MachineState *machine_state;
> } QIgvm;
>
> static QIgvmParameterData *qigvm_find_param_entry(QIgvm *igvm, const IGVM_VHS_PARAMETER *param) {
>@@ -906,7 +908,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
> }
>
> int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>-                       bool onlyVpContext, Error **errp)
>+                       bool onlyVpContext, MachineState *machine_state, Error **errp)
> {
>     int32_t header_count;
>     QIgvmParameterData *parameter;
>@@ -929,6 +931,8 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>     ctx.cgs = cgs;
>     ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
>
>+    ctx.machine_state = machine_state;
>+
>     /*
>      * Check that the IGVM file provides configuration for the current
>      * platform
>diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
>index 7dc48677fd..2783fc542e 100644
>--- a/include/system/igvm-cfg.h
>+++ b/include/system/igvm-cfg.h
>@@ -12,6 +12,7 @@
> #ifndef QEMU_IGVM_CFG_H
> #define QEMU_IGVM_CFG_H
>
>+#include "hw/boards.h"
> #include "qom/object.h"
> #include "hw/resettable.h"
>
>@@ -43,7 +44,7 @@ typedef struct IgvmCfgClass {
>      * Returns 0 for ok and -1 on error.
>      */
>     int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>-                   bool onlyVpContext, Error **errp);
>+                   bool onlyVpContext, MachineState *machine_state, Error **errp);
>
> } IgvmCfgClass;
>
>diff --git a/include/system/igvm.h b/include/system/igvm.h
>index ec2538daa0..0afe784a17 100644
>--- a/include/system/igvm.h
>+++ b/include/system/igvm.h
>@@ -14,11 +14,12 @@
>
> #include "system/confidential-guest-support.h"
> #include "system/igvm-cfg.h"
>+#include "hw/boards.h"
> #include "qapi/error.h"
>
> IgvmHandle qigvm_file_init(char *filename, Error **errp);
> int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
>-                      bool onlyVpContext, Error **errp);
>+                      bool onlyVpContext, MachineState *machine_state, Error **errp);
>
> /* x86 native */
> int qigvm_x86_get_mem_map_entry(int index,
>diff --git a/target/i386/sev.c b/target/i386/sev.c
>index fd2dada013..a733868043 100644
>--- a/target/i386/sev.c
>+++ b/target/i386/sev.c
>@@ -1892,7 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          */
>         if (x86machine->igvm) {
>             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
>+                    ->process(x86machine->igvm, machine->cgs, true, machine, errp) ==

`cgs` is part of the machine state. WDYT about dropping it?

Luigi


