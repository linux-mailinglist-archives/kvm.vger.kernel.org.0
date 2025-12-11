Return-Path: <kvm+bounces-65743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF34CB5288
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3DBCC3019851
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B27092F12DA;
	Thu, 11 Dec 2025 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y8yMaTg/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xj7rKgZM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDF02EB86D
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765442785; cv=none; b=hbVpq3424/mpVefOV308NkGwCd3e+QWo4UqArAVOhBzS88/1KcCg77ldT6fg6gR/mSvy0y5NBbx9yiExgX/sRV1G+FW/fH1hP7VMOsAkMi4Mz+BO2M0ARMOW0qGPbUfRIvCjxDj71EkL4BKrE/Sl2Yns6fQt2kk8YZNJ4NoFOTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765442785; c=relaxed/simple;
	bh=uIpoGVRTv19i3po+DT5gycevN7FEPLnYE4n3/Yw5FCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mbfTroVMJOhxDJxWFnSkxOpkbfn4WnF2Qky+bV+1wh4Fhr6Y1Qh1kJKQ7A8jMewQha9rsFoNmAH5RFrKmGTZTcjAk3NsOQxnT4o79AIE4AWzjocuXbKq4lRZslzOPfeWVbtLn+AbaER5XlJB3xe/oqxUDABRA8ofl74bur9ms0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y8yMaTg/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xj7rKgZM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765442782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TPUMXRO/jw+TRLjOlgLwUQu+W4zj0DlSLRqa6k2iv2I=;
	b=Y8yMaTg/NlxJet3tiHJeFRUk/MPxbtumsGbJGO+15Ng+PSO+gFN2nu2Wp0LQMC7nvN4BCO
	BKwCSYW2678mglO10Hn07FFXjOIz6elajm2bySfPBDZb7nuCmamftHalFtBA0Awft+wXtw
	Le9e7HnoIgwoXYJ2rjYmLgxkgpEFWkE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-lSP6SSYUP1GgaOfqKab65Q-1; Thu, 11 Dec 2025 03:46:19 -0500
X-MC-Unique: lSP6SSYUP1GgaOfqKab65Q-1
X-Mimecast-MFC-AGG-ID: lSP6SSYUP1GgaOfqKab65Q_1765442778
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b79fddf8e75so70826666b.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 00:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765442778; x=1766047578; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TPUMXRO/jw+TRLjOlgLwUQu+W4zj0DlSLRqa6k2iv2I=;
        b=Xj7rKgZMD0CyVvPvHgQJ9x0uD+2XOsSeVAZyIlrZh14jQ0l6Gpp98K7U/v56gA7ZnE
         fg1JtdklWxtnT4K5wAzKhnWa1qveryzQv5kTOcx9tUZzHQeK/6x7IfRuJIZ0xW8QFYxN
         wB2hg85XPSyvNeryLOqJ7k1zKor+y8kzBxXbPExSXlcdp62UAtt/5UfT5mslO15+Y7DN
         ZUkZk+sFEKiT+FbNzj0TIrVNrKfSCVcUYb2EK2hRy4z6nNjx2OjUAQoHgVyU9Ewz5TAR
         ZkCkEAwJr0/p7I3l0lQjCvgBXcLQfrTNW80HOoBWon7hO/RRpBoBhGa2DEz234RGq2SH
         AB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765442778; x=1766047578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPUMXRO/jw+TRLjOlgLwUQu+W4zj0DlSLRqa6k2iv2I=;
        b=cltP2lhLPBGdi70HAKumBdSaPVcM5+cAPRQ2ouvHjH04hRZCpeCQQqn2Urf9BzPaRg
         wW1MNF1M2h8sbx0uGBChDGDBsx8YD8li4wmqTJPDpO06ioMBVm4EnWpM1QnO6W9YwEPZ
         WOzQ48uPnj6UmhIBelyvZ78oUJZs+vqTkLRDejqSM8QMqCFcHGUYzL9sPPBAwoyA3zeU
         bgOAyFRm4p4k6YM8qwPyZLnLhYqj7is6IYZCzoQSi0YSQT9OTnm4w2oqFg1EZ8Ut79AN
         YWpklTwWjRHRW3mAbgfzz0rjgnWftnGdsPqHZfj35BeUwWGNrwlOVE7n+m8+0kSi/cZ5
         lPVg==
X-Forwarded-Encrypted: i=1; AJvYcCWMnAnv8nf0BCGl1sE4FfecQPyKS8oqAksL1cAMRL4lYJaFPIyyYQ1r7w/0ivQ8FDYoYBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcbgKpEz6Lim+8gwqfCOPCv1YthlMW0PKNPCtcStCGV0xozJ2Z
	XWDpZCAjtHzKtIzQReaByusq6Qu7JAaABLwBSdWNZ2QchjO9sZt0WpkCmi4lyDDtLKF/o/aiU5p
	81JJlju6WFVgF2lP7598rHvO93yoINE9U/qOxAVwzNUNiI7bIaf9AIw==
X-Gm-Gg: AY/fxX40eYvRfWqkdNWFRAHBH+o/YCQV0FWJqo6sCU4dhZuTH1td2aAxK09PDa5V0V5
	XtW0EyYNuZlp+qqxCY2RSzsPHvPfhEx/BWoJMS3JNVFpcoqIvlNqwsQO22ZelVmLw7K1LgSpqNa
	uNmjWedsApdPUGpko3WOWu6qx2RwiikRvcxbDbDsDyvV2EgIYKdqOtbgpUv/avd6MM57nVgx5Ny
	+HrD7c00RhSffrTYcU8nP/8qtfGETf5YWYldsGjSnj4J7lEOR4mdlTaMh2uY8hvuFrQn2EUu0dz
	iJdgqF+gAwFhymVJ539cjs5bztreIpl6Fdm1MPMXGj2DEQLdC2HBHZ6d3Wxg/969jyP6MHsPbeC
	A/jbWfY37xcC0omBHTM4D4SNvdyUtARpVlhs4fZwWg1Tywua3ruGM7kZyAUsg1w==
X-Received: by 2002:a17:906:c148:b0:b6d:573d:bbc5 with SMTP id a640c23a62f3a-b7ce83c410cmr560153166b.37.1765442777996;
        Thu, 11 Dec 2025 00:46:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqgLL+tnOEFfhd7vsF3bDWS7giZs3MPN6uzgFnyKJZQJYkZQCQwhm1877AgMDHElkxPd0I7w==
X-Received: by 2002:a17:906:c148:b0:b6d:573d:bbc5 with SMTP id a640c23a62f3a-b7ce83c410cmr560149666b.37.1765442777364;
        Thu, 11 Dec 2025 00:46:17 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa5c9d22sm206613966b.61.2025.12.11.00.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 00:46:16 -0800 (PST)
Date: Thu, 11 Dec 2025 09:46:11 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Joerg Roedel <joerg.roedel@amd.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Luigi Leonardi <leonardi@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH 3/3] igvm: Fill MADT IGVM parameter field
Message-ID: <26ptyaovy6mlbvuzri4v2ea3xhyvdc5elqsau34upvswarrbop@bhtzvxpb5aad>
References: <20251211081517.1546957-1-osteffen@redhat.com>
 <20251211081517.1546957-4-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251211081517.1546957-4-osteffen@redhat.com>

On Thu, Dec 11, 2025 at 09:15:17AM +0100, Oliver Steffen wrote:
>Use the new acpi_build_madt_standalone() function to fill the MADT
>parameter field.

The cover letter will not usually be part of the git history, so IMO it 
is better to include also here the information that you have rightly 
written there, explaining why we are adding this change.

>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm-cfg.c       |  8 +++++++-
> backends/igvm.c           | 37 ++++++++++++++++++++++++++++++++++++-
> include/system/igvm-cfg.h |  4 ++--
> include/system/igvm.h     |  2 +-
> target/i386/sev.c         |  2 +-
> 5 files changed, 47 insertions(+), 6 deletions(-)
>
>diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
>index c1b45401f4..0a77f7b7a1 100644
>--- a/backends/igvm-cfg.c
>+++ b/backends/igvm-cfg.c
>@@ -17,6 +17,7 @@
> #include "qom/object_interfaces.h"
> #include "hw/qdev-core.h"
> #include "hw/boards.h"
>+#include "hw/i386/acpi-build.h"
>
> #include "trace.h"
>
>@@ -48,10 +49,15 @@ static void igvm_reset_hold(Object *obj, ResetType type)
> {
>     MachineState *ms = MACHINE(qdev_get_machine());
>     IgvmCfg *igvm = IGVM_CFG(obj);
>+    GArray *madt = NULL;
>
>     trace_igvm_reset_hold(type);
>
>-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
>+    madt = acpi_build_madt_standalone(ms);
>+
>+    qigvm_process_file(igvm, ms->cgs, false, madt, &error_fatal);
>+
>+    g_array_free(madt, true);
> }
>
> static void igvm_reset_exit(Object *obj, ResetType type)
>diff --git a/backends/igvm.c b/backends/igvm.c
>index a350c890cc..7e56b19b0a 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -93,6 +93,7 @@ typedef struct QIgvm {
>     unsigned region_start_index;
>     unsigned region_last_index;
>     unsigned region_page_count;
>+    GArray *madt;
> } QIgvm;
>
> static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_data,
>@@ -120,6 +121,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
> static int qigvm_initialization_guest_policy(QIgvm *ctx,
>                                        const uint8_t *header_data,
>                                        Error **errp);
>+static int qigvm_initialization_madt(QIgvm *ctx,
>+                                     const uint8_t *header_data, Error **errp);
>
> struct QIGVMHandler {
>     uint32_t type;
>@@ -148,6 +151,8 @@ static struct QIGVMHandler handlers[] = {
>       qigvm_directive_snp_id_block },
>     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
>       qigvm_initialization_guest_policy },
>+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
>+      qigvm_initialization_madt },
> };
>
> static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
>@@ -764,6 +769,34 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
>     return 0;
> }
>
>+static int qigvm_initialization_madt(QIgvm *ctx,
>+                                     const uint8_t *header_data, Error **errp)
>+{
>+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
>+    QIgvmParameterData *param_entry;
>+
>+    if (ctx->madt == NULL) {
>+        return 0;
>+    }
>+
>+    /* Find the parameter area that should hold the device tree */
>+    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
>+    {
>+        if (param_entry->index == param->parameter_area_index) {
>+
>+            if (ctx->madt->len > param_entry->size) {
>+                error_setg(
>+                    errp,
>+                    "IGVM: MADT size exceeds parameter area defined in IGVM file");
>+                return -1;
>+            }
>+            memcpy(param_entry->data, ctx->madt->data, ctx->madt->len);
>+            break;
>+        }
>+    }
>+    return 0;
>+}
>+
> static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
> {
>     int32_t header_count;
>@@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **errp)
> }
>
> int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>-                       bool onlyVpContext, Error **errp)
>+                       bool onlyVpContext, GArray *madt, Error **errp)
> {
>     int32_t header_count;
>     QIgvmParameterData *parameter;
>@@ -915,6 +948,8 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>     ctx.cgs = cgs;
>     ctx.cgsc = cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL;
>
>+    ctx.madt = madt;
>+
>     /*
>      * Check that the IGVM file provides configuration for the current
>      * platform
>diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
>index 7dc48677fd..1a04302beb 100644
>--- a/include/system/igvm-cfg.h
>+++ b/include/system/igvm-cfg.h
>@@ -42,8 +42,8 @@ typedef struct IgvmCfgClass {
>      *
>      * Returns 0 for ok and -1 on error.
>      */

Should we update the documentation of this function now that we have a 
new parameter, also explaining that it's optional.

>-    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>-                   bool onlyVpContext, Error **errp);
>+    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
>+                   bool onlyVpContext, GArray *madt, Error **errp);
>
> } IgvmCfgClass;
>
>diff --git a/include/system/igvm.h b/include/system/igvm.h
>index ec2538daa0..f2e580e4ee 100644
>--- a/include/system/igvm.h
>+++ b/include/system/igvm.h
>@@ -18,7 +18,7 @@
>
> IgvmHandle qigvm_file_init(char *filename, Error **errp);
> int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
>-                      bool onlyVpContext, Error **errp);
>+                      bool onlyVpContext, GArray *madt, Error **errp);
>
> /* x86 native */
> int qigvm_x86_get_mem_map_entry(int index,
>diff --git a/target/i386/sev.c b/target/i386/sev.c
>index fd2dada013..ffeb9f52a2 100644
>--- a/target/i386/sev.c
>+++ b/target/i386/sev.c
>@@ -1892,7 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>          */
>         if (x86machine->igvm) {
>             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
>+                    ->process(x86machine->igvm, machine->cgs, true, NULL, errp) ==

Why here we don't need to pass it?

Thanks,
Stefano

>                 -1) {
>                 return -1;
>             }
>-- 
>2.52.0
>


