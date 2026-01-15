Return-Path: <kvm+bounces-68173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E3ED24166
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F9503114A14
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 11:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4044D36E49B;
	Thu, 15 Jan 2026 11:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUfEAo9M";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sRdyiIhZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC5029A33E
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768475221; cv=none; b=iKy1vR/m8r68+gxVFo2uSFjp5ihmY4Ocyi2WO8ehjV7sDAaRKURJ5Lsx6lk0P8z2Ma7yo2xlLqi6aNsqkHOkpRnWW61mOEKrC/sPgq2MUFuui1IiQVuY95s/dF9tv4ZaqaYmSZeCOlTIeLvpJSPKO9Of+Z5eyA+tc3rMh2cWLP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768475221; c=relaxed/simple;
	bh=VODjlpmWrnu1IUt1bDi00DP7it62a2iq3sOD9J5ACec=;
	h=Date:From:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gEhslooxp/yGuywFwvNTEy0J5hb929esG0frrUVk355pxLwTIwq5+odATkjHBv4bOqbdQeSiPlCrbCZiQMg0DB0jI+pfJaEdnFY9hZxVWuq9jI51CgDY6XiL/tfz3FKb9Eb8O0GZKHU70vsFXL9uiroXOvQ/qmxmz1FmfSufQxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IUfEAo9M; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sRdyiIhZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768475218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N28RU2ZYpiQPqQfOhsG1uELwhOhn2YTGjlElcsdJwnI=;
	b=IUfEAo9M6hEm3ROD/Be55LcbDg1xE+QtuFfhYhcoju8PYLMw+XM+GSPYsKn0D8dfz+67Ps
	0opxfkrndlGijJhoZb3tSMNezo96YMnZo7p9ooxoGA1mmYUPe6NCIPU6NRNRxTtSrI8abU
	FeTiGf14639YnAvWBtWkULK6e5GBp8A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-64NRtLHkOx2SVPDq6uCcKA-1; Thu, 15 Jan 2026 06:06:57 -0500
X-MC-Unique: 64NRtLHkOx2SVPDq6uCcKA-1
X-Mimecast-MFC-AGG-ID: 64NRtLHkOx2SVPDq6uCcKA_1768475216
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42fb1c2c403so545044f8f.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 03:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768475216; x=1769080016; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N28RU2ZYpiQPqQfOhsG1uELwhOhn2YTGjlElcsdJwnI=;
        b=sRdyiIhZdPIRqBuVD8dfXt2hYp99Iqu1/UQYwmb5U2+HJGjkmH1Fauv8ibzQOruxIX
         Y7QXhHfEmsk2oIl5S0ss+65aUyfdK583KnGoVJ+56mxQqC9v8nWphv4Kzpb0rCYORh0i
         4G5WMClrgkbajLOo/yxVaiigRn5wyIjEVoaOyx5StWg05uc5d+rU4jptsmJ8P5cB/Gl7
         JThCQ5pCgjl3xYKUp6ELdCIH/phb65Mh3JLiFmT9GzvYZ2rZUb4BXGqQhoQWWr2vQ9bu
         cpQBaYCSXnnCUSn0j1WOjoPIY4SYCKtq9gCTj71wwRgy0b3p5ibUitHDF3mNTeChn1nm
         vJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768475216; x=1769080016;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N28RU2ZYpiQPqQfOhsG1uELwhOhn2YTGjlElcsdJwnI=;
        b=IZ9VydL+ogh8l3gavWJFxP5TQOx8I6qOt0ljHXuSrvmoKQEGFIRE6QuEUz5zwD+YKE
         815ait69bbuDdrMudLyMp/8wm8YHlh1zz3g9KVp4bCSZji1PaUNGjcHGYkY9l0Sszoy6
         N5q6m65OI74wG+xtWEYihxV9iPieVjs9lKQ/3/1VCwwpD2nO/eKNHxCDHHkwxNASrLb/
         Hzv6zUbzS070bLlPN0E9/zkRw9T+soXHD1QTcd1Kb9ADVPFT5YE5V49skVHx7M3mBY2k
         jcY8jY7kyVQ0JzPNy+CcjjrOBhVZlDtW5scRR+khAtO4eRSnZaWKxFprz66EEtc3cDzW
         Or3A==
X-Forwarded-Encrypted: i=1; AJvYcCWj77ZwgHAIkDzEHrnhmKYRVdSYIRAd+6+ZpNnmn054GJoj2txJOtFXYotFf+d+4TCPXco=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8+goslwaw4zUD7YuvRZZLvkdGBCoGHbk2g7iw+EAdYYgpAw+t
	Masm5IyEYZPD0UPjo7SbBt5tkrNS71v22S394McLHJwnpV1ynUuJohFP8hk4s9Jj9WLhhhZD8v1
	tA143om9fiJ4GcAIucrVcj27DyHbpwwrZa/e6eeX0JRATaO690cUfdg==
X-Gm-Gg: AY/fxX45WEU/ycvIVaDeaRDfbXSsk4DbR0QepAR/bOhbt28G9+rm4g0A/Ll48mpEuuw
	LXFHjc5GcDgAwZ7vsdZeivPYGyX/Eci2pJy51GEjYfy6aCdZQ4V8WJvmXRfxDcjw3MvFvIlnINV
	u3785o1FZDOa1/f4rhwMBOL86J1VMf2wQxWNnImmnERQRusrXf75EQI6vgPHR+WLCfTI+2NOoVT
	LXnZz3AUhW2d/pElOe9QYCI2Pz54kzqKJSdUpvu3Wnwgc0Qcq4hpPcFLc95beggBtt9NPmK5uKv
	VacprCGCFjQTEngBi7tJtTyfKkqdERhUHyJZdQKcHUVyPcdQ/sx6FmJx9YWz0G18UFbpd7YdtIy
	k3/a/4hAiT5ByvME=
X-Received: by 2002:a05:6000:2910:b0:432:5c43:5d with SMTP id ffacd0b85a97d-4342d5c3701mr6467108f8f.36.1768475216108;
        Thu, 15 Jan 2026 03:06:56 -0800 (PST)
X-Received: by 2002:a05:6000:2910:b0:432:5c43:5d with SMTP id ffacd0b85a97d-4342d5c3701mr6467062f8f.36.1768475215679;
        Thu, 15 Jan 2026 03:06:55 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af64a650sm5248955f8f.4.2026.01.15.03.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:06:55 -0800 (PST)
Date: Thu, 15 Jan 2026 12:06:52 +0100
From: Luigi Leonardi <leonardi@redhat.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Richard Henderson <richard.henderson@linaro.org>, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v4 4/5] igvm: Pass machine state to IGVM file processing
Message-ID: <aWjKPMxjNKlnmYfB@leonardi-redhat>
References: <20260114175007.90845-1-osteffen@redhat.com>
 <20260114175007.90845-5-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260114175007.90845-5-osteffen@redhat.com>

On Wed, Jan 14, 2026 at 06:50:06PM +0100, Oliver Steffen wrote:
>Pass the full MachineState to the IGVM backend during file processing,
>instead of just the ConfidentialGuestSupport struct (which is a member
>of the MachineState).
>This replaces the cgs parameter of qigvm_process_file() with the machine
>state to make it available in the IGVM processing context.
>
>We will use it later to generate MADT data there to pass to the guest
>as IGVM parameter.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm-cfg.c       |  2 +-
> backends/igvm.c           | 30 +++++++++++++++++-------------
> include/system/igvm-cfg.h |  3 ++-
> include/system/igvm.h     |  5 +++--
> target/i386/sev.c         |  3 +--
> 5 files changed, 24 insertions(+), 19 deletions(-)
>
>diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
>index c1b45401f4..1b35dc0a49 100644
>--- a/backends/igvm-cfg.c
>+++ b/backends/igvm-cfg.c
>@@ -51,7 +51,7 @@ static void igvm_reset_hold(Object *obj, ResetType type)
>
>     trace_igvm_reset_hold(type);
>
>-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
>+    qigvm_process_file(igvm, ms, false, &error_fatal);
> }
>
> static void igvm_reset_exit(Object *obj, ResetType type)
>diff --git a/backends/igvm.c b/backends/igvm.c
>index ccb2f51cd9..cb2f997c87 100644
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
>@@ -70,7 +71,7 @@ struct QEMU_PACKED sev_id_authentication {
>  */
> typedef struct QIgvm {
>     IgvmHandle file;
>-    ConfidentialGuestSupport *cgs;
>+    MachineState *machine_state;
>     ConfidentialGuestSupportClass *cgsc;
>     uint32_t compatibility_mask;
>     unsigned current_header_index;
>@@ -235,7 +236,8 @@ static void *qigvm_prepare_memory(QIgvm *ctx, uint64_t addr, uint64_t size,
>         g_autofree char *region_name =
>             g_strdup_printf("igvm.%X", region_identifier);
>         igvm_pages = g_new0(MemoryRegion, 1);
>-        if (ctx->cgs && ctx->cgs->require_guest_memfd) {
>+        if (ctx->machine_state->cgs &&
>+            ctx->machine_state->cgs->require_guest_memfd) {
>             if (!memory_region_init_ram_guest_memfd(igvm_pages, NULL,
>                                                     region_name, size, errp)) {
>                 return NULL;
>@@ -355,7 +357,7 @@ static int qigvm_process_mem_region(QIgvm *ctx, unsigned start_index,
>      * If a confidential guest support object is provided then use it to set the
>      * guest state.
>      */
>-    if (ctx->cgs) {
>+    if (ctx->machine_state->cgs) {
>         cgs_page_type =
>             qigvm_type_to_cgs_type(page_type, flags->unmeasured, zero);
>         if (cgs_page_type < 0) {
>@@ -457,7 +459,7 @@ static int qigvm_directive_vp_context(QIgvm *ctx, const uint8_t *header_data,
>
>     data = (uint8_t *)igvm_get_buffer(ctx->file, data_handle);
>
>-    if (ctx->cgs) {
>+    if (ctx->machine_state->cgs) {
>         result = ctx->cgsc->set_guest_state(
>             vp_context->gpa, data, igvm_get_buffer_size(ctx->file, data_handle),
>             CGS_PAGE_TYPE_VMSA, vp_context->vp_index, errp);
>@@ -525,7 +527,7 @@ static int qigvm_directive_parameter_insert(QIgvm *ctx,
>              * If a confidential guest support object is provided then use it to
>              * set the guest state.
>              */
>-            if (ctx->cgs) {
>+            if (ctx->machine_state->cgs) {
>                 result = ctx->cgsc->set_guest_state(param->gpa, region,
>                                                     param_entry->size,
>                                                     CGS_PAGE_TYPE_UNMEASURED, 0,
>@@ -568,7 +570,7 @@ static int qigvm_directive_memory_map(QIgvm *ctx, const uint8_t *header_data,
>     ConfidentialGuestMemoryMapEntry cgmm_entry;
>     int retval = 0;
>
>-    if (ctx->cgs && ctx->cgsc->get_mem_map_entry) {
>+    if (ctx->machine_state->cgs && ctx->cgsc->get_mem_map_entry) {
>         get_mem_map_entry = ctx->cgsc->get_mem_map_entry;
>
>     } else if (target_arch() == SYS_EMU_TARGET_X86_64) {
>@@ -690,7 +692,7 @@ static int qigvm_directive_required_memory(QIgvm *ctx,
>     if (!region) {
>         return -1;
>     }
>-    if (ctx->cgs) {
>+    if (ctx->machine_state->cgs) {
>         result =
>             ctx->cgsc->set_guest_state(mem->gpa, region, mem->number_of_bytes,
>                                        CGS_PAGE_TYPE_REQUIRED_MEMORY, 0, errp);
>@@ -808,14 +810,14 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
>                                                 sizeof(
>                                                     IGVM_VHS_VARIABLE_HEADER));
>             if ((platform->platform_type == IGVM_PLATFORM_TYPE_SEV_ES) &&
>-                ctx->cgs) {
>+                ctx->machine_state->cgs) {
>                 if (ctx->cgsc->check_support(
>                         CGS_PLATFORM_SEV_ES, platform->platform_version,
>                         platform->highest_vtl, platform->shared_gpa_boundary)) {
>                     compatibility_mask_sev_es = platform->compatibility_mask;
>                 }
>             } else if ((platform->platform_type == IGVM_PLATFORM_TYPE_SEV) &&
>-                       ctx->cgs) {
>+                       ctx->machine_state->cgs) {
>                 if (ctx->cgsc->check_support(
>                         CGS_PLATFORM_SEV, platform->platform_version,
>                         platform->highest_vtl, platform->shared_gpa_boundary)) {
>@@ -823,7 +825,7 @@ static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
>                 }
>             } else if ((platform->platform_type ==
>                         IGVM_PLATFORM_TYPE_SEV_SNP) &&
>-                       ctx->cgs) {
>+                       ctx->machine_state->cgs) {
>                 if (ctx->cgsc->check_support(
>                         CGS_PLATFORM_SEV_SNP, platform->platform_version,
>                         platform->highest_vtl, platform->shared_gpa_boundary)) {
>@@ -896,7 +898,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
>     return igvm;
> }
>
>-int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>+int qigvm_process_file(IgvmCfg *cfg, MachineState *machine_state,
>                        bool onlyVpContext, Error **errp)
> {
>     int32_t header_count;
>@@ -917,8 +919,10 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>      * guest platform to perform extra processing, such as page measurement, on
>      * IGVM directives.
>      */
>-    ctx.cgs = cgs;
>-    ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
>+    ctx.machine_state = machine_state;
>+    ctx.cgsc = machine_state->cgs ?
>+                   CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(machine_state->cgs) :
>+                   NULL;
>
>     /*
>      * Check that the IGVM file provides configuration for the current
>diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
>index 7dc48677fd..51bf8d9844 100644
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
>@@ -42,7 +43,7 @@ typedef struct IgvmCfgClass {
>      *
>      * Returns 0 for ok and -1 on error.
>      */
>-    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>+    int (*process)(IgvmCfg *cfg, MachineState *machine_state,
>                    bool onlyVpContext, Error **errp);
>
> } IgvmCfgClass;
>diff --git a/include/system/igvm.h b/include/system/igvm.h
>index ec2538daa0..ce023fbc9e 100644
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
>-int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
>-                      bool onlyVpContext, Error **errp);
>+int qigvm_process_file(IgvmCfg *igvm, MachineState *machine_state,
>+                       bool onlyVpContext, Error **errp);
>
> /* x86 native */
> int qigvm_x86_get_mem_map_entry(int index,
>diff --git a/target/i386/sev.c b/target/i386/sev.c
>index fd2dada013..91a55ebd81 100644
>--- a/target/i386/sev.c
>+++ b/target/i386/sev.c
>@@ -1892,8 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          */
>         if (x86machine->igvm) {
>             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
>-                -1) {
>+                    ->process(x86machine->igvm, machine, true, errp) == -1) {
>                 return -1;
>             }
>             /*
>-- 
>2.52.0
>

LGTM

Reviewed-by: Luigi Leonardi <leonardi@redhat.com>


