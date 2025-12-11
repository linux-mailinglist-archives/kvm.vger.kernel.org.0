Return-Path: <kvm+bounces-65746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 001DFCB55B4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AE716301394C
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AAB32F691B;
	Thu, 11 Dec 2025 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aUfVXXKe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QovNNGYP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CB72E62C3
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 09:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765445092; cv=none; b=VTze6UqRJSoJ8lWXoobtGthlpWN4UpV6WiHwjwAXP2w59av5Vb1MzEiIrCUl2xj6VBY2kma5UfbcQd2EiBGPsLA6rwa47wENXHNxvt366MgscVab+ZcXN37WgjddbsFxezYFfsm5655h9qTEMezF6JeOMDDD/g6LdvTc7LLF7sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765445092; c=relaxed/simple;
	bh=q0QZZa/5lghuPj56lCuS3I5n7DQlBfUD+babd/i6LuE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jl/oGPCKoLeDChKITwdT5i7diC81u5YSeKvATSRd6O/qZUOXhIVkRx3fLNIhAeUMhkfeKCOiOivw7gGGhJF5/QfSW7xBUXT9XismQF9bGMYTWA6mgIS4SH4jUCzwNtmhsW3ax7/pJnVaDqxat8Dg6VvwsllwiBSfPN07uLnPKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aUfVXXKe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QovNNGYP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765445089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0snxFkyLEAfiYVoWaiM2k5L4Pd3JDbOzuok+0AcP2Oc=;
	b=aUfVXXKeHowps9+4WdcGQFC7cQPvD33usxcQDDs2JqDudSjwcY1CTdMFkyIBjfyP3fcI1R
	4Vc75M8r1BPHluQsgfgdPVn62EAsNBnC2t8Yk1O1/HPq47yinT93gJjqUI96KsPVQzBPFe
	zDWWUtdHl7oUHWjwYf94HhaqCkd1pXw=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-akhC2PYyP2-gyRvp_DOdsw-1; Thu, 11 Dec 2025 04:24:48 -0500
X-MC-Unique: akhC2PYyP2-gyRvp_DOdsw-1
X-Mimecast-MFC-AGG-ID: akhC2PYyP2-gyRvp_DOdsw_1765445087
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-644721f9e7aso860828d50.3
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 01:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765445087; x=1766049887; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0snxFkyLEAfiYVoWaiM2k5L4Pd3JDbOzuok+0AcP2Oc=;
        b=QovNNGYPBBFyv4bFvpatZEDozE1VIPzCIdKc6xfailJ+zVLOUfB6u/jXroWmBHegY+
         af5jqeJfe8mOl5HlGIZ5HRglijMlLjZQzKC97xpjz8nRZXHGPUlxkbFAF7tlHuRY3b5R
         9+1VuEibnPXJOx4nTZp+crxdxNkenpgjmTRSY6q41Rtxx6qRLsreUSitmD/ogNcW96WF
         exIrD1n8sLfRY9Pn1eqgRRxivx0McRqudNx8rVhH6fgRdIam41J/YMp4jCAtgEJ1ocY4
         MXYScMGhGyqCK8uYzwvF4l+nlcBHhXg0IVM71FlJPY/5XTW9pbGgIvV9GE9doVcStneR
         jueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765445087; x=1766049887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0snxFkyLEAfiYVoWaiM2k5L4Pd3JDbOzuok+0AcP2Oc=;
        b=oXgJ3vrsIlfRX78EimpcqUTTR0h3fsBGyA+wnh8lwnHthEUvhIsQeLCkiOoHmKRRtX
         gwlTo57+AqKfGZ3K4ZjpSYHI4zIfnS3+q/cGWCcffhEWSuyVSsOv+iRA70DdDYtk3rpV
         16WxLOItdjV4ob3nJLEOigqcftm/TeG5BRX7BUPlyOcQXKTGr1BQE47Xin5s5GE3CNkR
         s3hD1LmZ+XuKQlBcylSfzV0yNaToFd5taFiDngHrfWRL57+iiAz7EkDnUiyYTudCB/Uo
         +ObvW/4NHg0pHb1IwNnQZznMIEjfBpGU56SxllU8bOwO1xG7OLYK0+xhksZ6AoYOSW5T
         2jIw==
X-Forwarded-Encrypted: i=1; AJvYcCWVxijOqoMIATZxH4qTebE9NEFTEyPeSW4GiPZSZuRP4M8DecMvNqQKFh5aulYuhJHFFeQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH6H2yzx7dUIGqwGsFvFfOhxNxf4qDs4L5HuMPIluyt7QayFiz
	RPETBgpGQdflPfdJyh5SCnXZkYpcPLPCSIIO1lAqCCcRkRdRIBIcG2vSNy0ApAcogltAGTzUGPL
	CwMhi7ekAzpJ7ujuuxOxp9BZyf9htUwiKxbF7NPMpI0qVUoiifVH+d6FAHNY42xH2QjDTEhTd+g
	Osg9LqdQLbhfppf1BIGSfDZJt13pkB
X-Gm-Gg: AY/fxX4cBS13l2DKc3JJELXzkNaNubfjoaDXYDCqjs/xJNZ6suj+Y1tjJPG8HoBepJU
	mXnqT+CDXd431I1sz7cjc759A1juli/IJi7QNGU1UywphGq1Uii+GpPMUOWZH9ShZaQzMvs+/Hj
	PAN71NB6xubz9U0ciBtGmD7QVZ45vN5PDmtIO+DX9HIqhUmscVMDfoM8ekla2TcBwZ+pTrxKwL9
	umQNe2yL42lQZiYHpWqbFE15w==
X-Received: by 2002:a05:690e:169c:b0:644:4b86:e7d1 with SMTP id 956f58d0204a3-6446e9112cdmr4390103d50.10.1765445087543;
        Thu, 11 Dec 2025 01:24:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHuU+tJU4RQI4z4yFpZ1UYeqalsybBdqY89RuI7I4f/urGG/hT/MLALuw19mg01Z/CyuoXg5Nl/u6DdbBEpUwM=
X-Received: by 2002:a05:690e:169c:b0:644:4b86:e7d1 with SMTP id
 956f58d0204a3-6446e9112cdmr4390087d50.10.1765445087159; Thu, 11 Dec 2025
 01:24:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211081517.1546957-1-osteffen@redhat.com> <20251211081517.1546957-4-osteffen@redhat.com>
 <26ptyaovy6mlbvuzri4v2ea3xhyvdc5elqsau34upvswarrbop@bhtzvxpb5aad>
In-Reply-To: <26ptyaovy6mlbvuzri4v2ea3xhyvdc5elqsau34upvswarrbop@bhtzvxpb5aad>
From: Oliver Steffen <osteffen@redhat.com>
Date: Thu, 11 Dec 2025 10:24:35 +0100
X-Gm-Features: AQt7F2o4BrxakdvFlwlUEfCcnANEG9Lzb5oq3NPgqEav-Whxr7VdFlfL-f-2z9w
Message-ID: <CA+bRGFqnT=Es1GE6w4U2edaJXpDaSV1bhZ89vcaP5TDfFU8a+Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] igvm: Fill MADT IGVM parameter field
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: qemu-devel@nongnu.org, Joerg Roedel <joerg.roedel@amd.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	Richard Henderson <richard.henderson@linaro.org>, Zhao Liu <zhao1.liu@intel.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Ani Sinha <anisinha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Luigi Leonardi <leonardi@redhat.com>, 
	Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 9:46=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Thu, Dec 11, 2025 at 09:15:17AM +0100, Oliver Steffen wrote:
> >Use the new acpi_build_madt_standalone() function to fill the MADT
> >parameter field.
>
> The cover letter will not usually be part of the git history, so IMO it
> is better to include also here the information that you have rightly
> written there, explaining why we are adding this change.

Will do.

> >
> >Signed-off-by: Oliver Steffen <osteffen@redhat.com>
> >---
> > backends/igvm-cfg.c       |  8 +++++++-
> > backends/igvm.c           | 37 ++++++++++++++++++++++++++++++++++++-
> > include/system/igvm-cfg.h |  4 ++--
> > include/system/igvm.h     |  2 +-
> > target/i386/sev.c         |  2 +-
> > 5 files changed, 47 insertions(+), 6 deletions(-)
> >
> >diff --git a/backends/igvm-cfg.c b/backends/igvm-cfg.c
> >index c1b45401f4..0a77f7b7a1 100644
> >--- a/backends/igvm-cfg.c
> >+++ b/backends/igvm-cfg.c
> >@@ -17,6 +17,7 @@
> > #include "qom/object_interfaces.h"
> > #include "hw/qdev-core.h"
> > #include "hw/boards.h"
> >+#include "hw/i386/acpi-build.h"
> >
> > #include "trace.h"
> >
> >@@ -48,10 +49,15 @@ static void igvm_reset_hold(Object *obj, ResetType t=
ype)
> > {
> >     MachineState *ms =3D MACHINE(qdev_get_machine());
> >     IgvmCfg *igvm =3D IGVM_CFG(obj);
> >+    GArray *madt =3D NULL;
> >
> >     trace_igvm_reset_hold(type);
> >
> >-    qigvm_process_file(igvm, ms->cgs, false, &error_fatal);
> >+    madt =3D acpi_build_madt_standalone(ms);
> >+
> >+    qigvm_process_file(igvm, ms->cgs, false, madt, &error_fatal);
> >+
> >+    g_array_free(madt, true);
> > }
> >
> > static void igvm_reset_exit(Object *obj, ResetType type)
> >diff --git a/backends/igvm.c b/backends/igvm.c
> >index a350c890cc..7e56b19b0a 100644
> >--- a/backends/igvm.c
> >+++ b/backends/igvm.c
> >@@ -93,6 +93,7 @@ typedef struct QIgvm {
> >     unsigned region_start_index;
> >     unsigned region_last_index;
> >     unsigned region_page_count;
> >+    GArray *madt;
> > } QIgvm;
> >
> > static int qigvm_directive_page_data(QIgvm *ctx, const uint8_t *header_=
data,
> >@@ -120,6 +121,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, =
const uint8_t *header_data,
> > static int qigvm_initialization_guest_policy(QIgvm *ctx,
> >                                        const uint8_t *header_data,
> >                                        Error **errp);
> >+static int qigvm_initialization_madt(QIgvm *ctx,
> >+                                     const uint8_t *header_data, Error =
**errp);
> >
> > struct QIGVMHandler {
> >     uint32_t type;
> >@@ -148,6 +151,8 @@ static struct QIGVMHandler handlers[] =3D {
> >       qigvm_directive_snp_id_block },
> >     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
> >       qigvm_initialization_guest_policy },
> >+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
> >+      qigvm_initialization_madt },
> > };
> >
> > static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
> >@@ -764,6 +769,34 @@ static int qigvm_initialization_guest_policy(QIgvm =
*ctx,
> >     return 0;
> > }
> >
> >+static int qigvm_initialization_madt(QIgvm *ctx,
> >+                                     const uint8_t *header_data, Error =
**errp)
> >+{
> >+    const IGVM_VHS_PARAMETER *param =3D (const IGVM_VHS_PARAMETER *)hea=
der_data;
> >+    QIgvmParameterData *param_entry;
> >+
> >+    if (ctx->madt =3D=3D NULL) {
> >+        return 0;
> >+    }
> >+
> >+    /* Find the parameter area that should hold the device tree */
> >+    QTAILQ_FOREACH(param_entry, &ctx->parameter_data, next)
> >+    {
> >+        if (param_entry->index =3D=3D param->parameter_area_index) {
> >+
> >+            if (ctx->madt->len > param_entry->size) {
> >+                error_setg(
> >+                    errp,
> >+                    "IGVM: MADT size exceeds parameter area defined in =
IGVM file");
> >+                return -1;
> >+            }
> >+            memcpy(param_entry->data, ctx->madt->data, ctx->madt->len);
> >+            break;
> >+        }
> >+    }
> >+    return 0;
> >+}
> >+
> > static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **err=
p)
> > {
> >     int32_t header_count;
> >@@ -892,7 +925,7 @@ IgvmHandle qigvm_file_init(char *filename, Error **e=
rrp)
> > }
> >
> > int qigvm_process_file(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
> >-                       bool onlyVpContext, Error **errp)
> >+                       bool onlyVpContext, GArray *madt, Error **errp)
> > {
> >     int32_t header_count;
> >     QIgvmParameterData *parameter;
> >@@ -915,6 +948,8 @@ int qigvm_process_file(IgvmCfg *cfg, ConfidentialGue=
stSupport *cgs,
> >     ctx.cgs =3D cgs;
> >     ctx.cgsc =3D cgs ? CONFIDENTIAL_GUEST_SUPPORT_GET_CLASS(cgs) : NULL=
;
> >
> >+    ctx.madt =3D madt;
> >+
> >     /*
> >      * Check that the IGVM file provides configuration for the current
> >      * platform
> >diff --git a/include/system/igvm-cfg.h b/include/system/igvm-cfg.h
> >index 7dc48677fd..1a04302beb 100644
> >--- a/include/system/igvm-cfg.h
> >+++ b/include/system/igvm-cfg.h
> >@@ -42,8 +42,8 @@ typedef struct IgvmCfgClass {
> >      *
> >      * Returns 0 for ok and -1 on error.
> >      */
>
> Should we update the documentation of this function now that we have a
> new parameter, also explaining that it's optional.
>
Will do.

> >-    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
> >-                   bool onlyVpContext, Error **errp);
> >+    int (*process)(IgvmCfg *cfg, ConfidentialGuestSupport *cgs,
> >+                   bool onlyVpContext, GArray *madt, Error **errp);
> >
> > } IgvmCfgClass;
> >
> >diff --git a/include/system/igvm.h b/include/system/igvm.h
> >index ec2538daa0..f2e580e4ee 100644
> >--- a/include/system/igvm.h
> >+++ b/include/system/igvm.h
> >@@ -18,7 +18,7 @@
> >
> > IgvmHandle qigvm_file_init(char *filename, Error **errp);
> > int qigvm_process_file(IgvmCfg *igvm, ConfidentialGuestSupport *cgs,
> >-                      bool onlyVpContext, Error **errp);
> >+                      bool onlyVpContext, GArray *madt, Error **errp);
> >
> > /* x86 native */
> > int qigvm_x86_get_mem_map_entry(int index,
> >diff --git a/target/i386/sev.c b/target/i386/sev.c
> >index fd2dada013..ffeb9f52a2 100644
> >--- a/target/i386/sev.c
> >+++ b/target/i386/sev.c
> >@@ -1892,7 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSu=
pport *cgs, Error **errp)
> >          */
> >         if (x86machine->igvm) {
> >             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
> >-                    ->process(x86machine->igvm, machine->cgs, true, err=
p) =3D=3D
> >+                    ->process(x86machine->igvm, machine->cgs, true, NUL=
L, errp) =3D=3D
>
> Why here we don't need to pass it?

Here we only read the IGVM to figure out the initial vcpu configuration
(the `onlyVpContext` parameter is true) to initialize kvm,
The actual IGVM processing is done later.
Should I mention in the comment above why madt is NULL here ?

>
> Thanks,
> Stefano
>
> >                 -1) {
> >                 return -1;
> >             }
> >--
> >2.52.0
> >
>


