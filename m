Return-Path: <kvm+bounces-67714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D75D11B11
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 11:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B66C30F0340
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB8E527A122;
	Mon, 12 Jan 2026 09:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qy2Eh4/6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7xcw+u5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A456A2773FE
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211837; cv=none; b=fbuHr7GOpUndBWVmIMStfKD1bhQpXzPib+yWyeSCpjjQm/f+Gbnqyd1tRGaKeO+b1osoyseq8Q25ujZSFOlUfNu5Wqm8IZ169gFo0nA5kvIzFI65B4AyDfoqVzrL3adct1wVTnLW5Sva3Ux4cXfwvuVjW8TYxySZPCJl3nZkl+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211837; c=relaxed/simple;
	bh=xyQeF9HSCAoDcdmlhbM72QnwqlYZfGCQuv0K/KKrU5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Po7hIhmmYEhsZuiG9gksJYMiElEgsRPqE655STdO4+ODjVCojxyEA3IUebBikvgjPY+b8r4oLUkkIXwzw3dpz0iQb/W3FtbjR/HpAS9WiIdCTwzVZCyEMmaCo7LvFciT5KJGcOjEx1UzBgpRNKLJAktpWID4KmuwSCAK+XjKzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qy2Eh4/6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h7xcw+u5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768211834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IITw8Q3hu7/PKYDKqSgzmT4XoNE9pbceR1oZUqzeVRs=;
	b=Qy2Eh4/6/4W0kyMAoXfXyUga5C2jvrRezt755HeLYahq+aEcHalmYRB9vRrKIhDl9mJFmx
	mbcLDz8KYAbA+Q/AxYTxbQFRHNhfGg+KSuZi+P3o2f45C5UQPSxPqxo9PRJ8B//SgtR8JP
	+I5v8YY8OzrynTWRFPlIn/8ZsnRtOmU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-qFmDFSROO6izzGlC3aAHQQ-1; Mon, 12 Jan 2026 04:57:13 -0500
X-MC-Unique: qFmDFSROO6izzGlC3aAHQQ-1
X-Mimecast-MFC-AGG-ID: qFmDFSROO6izzGlC3aAHQQ_1768211832
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso75939805e9.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 01:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768211832; x=1768816632; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IITw8Q3hu7/PKYDKqSgzmT4XoNE9pbceR1oZUqzeVRs=;
        b=h7xcw+u5v5vfkA2mNixlIYE9YDLGLnk10F5cAFakiIVkBvCGq6ZdatU+F6XuhA+Tpy
         xMMLbmNgUFH1eXUYXqGeXEoA15uM7b2DcKd6egLBIu6fW3y8UC3nsM8HmEw775R3Tzvc
         Yf3BCq5viYCKe98f9LSI3+U5D2sQgruxAY7iHwPwGsleVLmfHa67xUyUB6dSncg2WkRx
         w4Q0APvJUJ+6fBIttdTXDyGhh/lfEV4j71/Z5wR7+lxrC8rSkuwg397XsMOup58w86QQ
         uSvHg/A4tg0MhMjUxDEBAnnuidYhLIwsJ9/tkRWYD2NF2EHTitVBGWdJJQq5z+LPY71X
         KYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768211832; x=1768816632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IITw8Q3hu7/PKYDKqSgzmT4XoNE9pbceR1oZUqzeVRs=;
        b=nzvAKBVLvGCBX1xP8bTEEq9NXOnuhlwhXgHu1/u7bZQdcKRP4dJZY2bIVxBOvVNljc
         IV+jrxP8RlvwcTFr6m50GAq/6cPk6davxka81QDay4aLUw+8dePSbHQH3khkWrkwc1cX
         8AuC5KAq9Plwcbl19vBYf+fUpMSs9IVmRIN2lSj/eDjaqksaln1yRQFr2KLf5HfBJbjw
         eOTmw3w3pJz+allIeihsktap8MlR614IPt4+xLETfDGoCWzKfvwGugDH/tuMAWGRKdDE
         CImjc1BwiukybownVGOidqgxzw+An+5ahPsWVNFZdOVuFGtMqty+EHbnXi67GQDYRVS7
         y6xg==
X-Forwarded-Encrypted: i=1; AJvYcCWrVo8GtmSUHrPVRxEwnJ6vyiVbbUL/j5woFJdcaYhEMP47Pb0GMUu1khT3sffEANoTQew=@vger.kernel.org
X-Gm-Message-State: AOJu0YyamLzoeYCUIiOd+v7V35PEA0It1nmVsMXZC0rj3ADifjNOmRX+
	OHzSzna8DJa8+vDrlN4lzJGtd1KE2TKlYeAUUUBesi1xvrvza0Vh/zeVjYarB9bz+KlxFNhF0W2
	s4iKiBKhbbx671bGox4qq7r3PIUi4al/uy+K7wZQyI8t9FvAqkEfsfg==
X-Gm-Gg: AY/fxX4gDX59qVgBcDq3aQ/Zaqzhx/7YdvR/jyGGj64nOxiyJTWa5sJgYbN6+6CubGS
	lr0D3WxpRm33E4XQ9zRMZx4bwclSOBDxkgk2v7f9LiWMIsgzi4XAOc6UX6BI+lYtE10/+1bJWfs
	RbiV397odGD/IRI8FW9MQsmnGPRZrH7/ZN6Kyg8Sweq4PFAlabUD3WwQw9Q+8l01J7pUGVMv/8b
	BOm2lg/canxptRjbBBM7dq/WIeIHaPz/4qu/gZp4ua8Ytbv3FvJFp1mMJpEi7odMJholIV9iPsS
	SxwgRw+uEVdD5w4lX7EtA/67KCRr4TToZ4yGAMu2mmZOrCX7bnyGQbWg9NAYeTXYgO65f+3GgDa
	xQOLGv44ynTfXeK8=
X-Received: by 2002:a05:6000:3112:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-432c38d0f5amr21762932f8f.58.1768211832057;
        Mon, 12 Jan 2026 01:57:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8nUpJjlfbThAz7uz78Ez10rox1svb/5PwHDzxi0eoRWJuwrkJOhDHai5qPKd7LGfg5rt0tg==
X-Received: by 2002:a05:6000:3112:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-432c38d0f5amr21762900f8f.58.1768211831597;
        Mon, 12 Jan 2026 01:57:11 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacd1sm37154626f8f.4.2026.01.12.01.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 01:57:11 -0800 (PST)
Date: Mon, 12 Jan 2026 10:57:08 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 6/6] igvm: Fill MADT IGVM parameter field
Message-ID: <aWTFR-sYjRIdDbId@leonardi-redhat>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-7-osteffen@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260109143413.293593-7-osteffen@redhat.com>

On Fri, Jan 09, 2026 at 03:34:13PM +0100, Oliver Steffen wrote:
>Use the new acpi_build_madt_standalone() function to fill the MADT
>parameter field.
>
>The IGVM parameter can be consumed by Coconut SVSM [1], instead of
>relying on the fw_cfg interface, which has caused problems before due to
>unexpected access [2,3]. Using IGVM parameters is the default way for
>Coconut SVSM; switching over would allow removing specialized code paths
>for QEMU in Coconut.
>
>In any case OVMF, which runs after SVSM has already been initialized,
>will continue reading all ACPI tables via fw_cfg and provide fixed up
>ACPI data to the OS as before.
>
>Generating the MADT twice (during ACPI table building and IGVM processing)
>seems acceptable, since there is no infrastructure to obtain the MADT
>out of the ACPI table memory area.
>
>[1] https://github.com/coconut-svsm/svsm/pull/858
>[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
>[3] https://github.com/coconut-svsm/svsm/issues/646
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>
>SQUASH: Rename madt parameter handler

Development leftover?

>---
> backends/igvm.c | 35 +++++++++++++++++++++++++++++++++++
> 1 file changed, 35 insertions(+)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index 7390dee734..90ea2c22fd 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -15,9 +15,11 @@
> #include "qapi/error.h"
> #include "qemu/target-info-qapi.h"
> #include "system/igvm.h"
>+#include "glib.h"

is this needed?

> #include "system/memory.h"
> #include "system/address-spaces.h"
> #include "hw/core/cpu.h"
>+#include "hw/i386/acpi-build.h"
>
> #include "trace.h"
>
>@@ -134,6 +136,8 @@ static int qigvm_directive_snp_id_block(QIgvm *ctx, const uint8_t *header_data,
> static int qigvm_initialization_guest_policy(QIgvm *ctx,
>                                        const uint8_t *header_data,
>                                        Error **errp);
>+static int qigvm_directive_madt(QIgvm *ctx,
>+                                     const uint8_t *header_data, Error **errp);
>
> struct QIGVMHandler {
>     uint32_t type;
>@@ -162,6 +166,8 @@ static struct QIGVMHandler handlers[] = {
>       qigvm_directive_snp_id_block },
>     { IGVM_VHT_GUEST_POLICY, IGVM_HEADER_SECTION_INITIALIZATION,
>       qigvm_initialization_guest_policy },
>+    { IGVM_VHT_MADT, IGVM_HEADER_SECTION_DIRECTIVE,
>+      qigvm_directive_madt },
> };
>
> static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
>@@ -780,6 +786,35 @@ static int qigvm_initialization_guest_policy(QIgvm *ctx,
>     return 0;
> }
>
>+static int qigvm_directive_madt(QIgvm *ctx,
>+                                     const uint8_t *header_data, Error **errp)
>+{
>+    const IGVM_VHS_PARAMETER *param = (const IGVM_VHS_PARAMETER *)header_data;
>+    QIgvmParameterData *param_entry;
>+
>+    if (ctx->machine_state == NULL) {
>+        return 0;
>+    }
>+
>+    /* Find the parameter area that should hold the MADT data */
>+    param_entry = qigvm_find_param_entry(ctx, param);
>+    if (param_entry != NULL) {
>+
>+        GArray *madt = acpi_build_madt_standalone(ctx->machine_state);
>+
>+        if (madt->len > param_entry->size) {
>+            error_setg(
>+                errp,
>+                "IGVM: MADT size exceeds parameter area defined in IGVM file");
>+            return -1;
>+        }
>+        memcpy(param_entry->data, madt->data, madt->len);
>+
>+        g_array_free(madt, true);
>+    }
>+    return 0;
>+}
>+
> static int qigvm_supported_platform_compat_mask(QIgvm *ctx, Error **errp)
> {
>     int32_t header_count;
>--
>2.52.0
>

Rest LGTM!

Luigi


