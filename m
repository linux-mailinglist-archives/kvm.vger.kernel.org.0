Return-Path: <kvm+bounces-67628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E213FD0BB4C
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 18:37:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 192D13002961
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 17:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFC218AE3;
	Fri,  9 Jan 2026 17:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ICplM2RQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWe1E8bQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BC2309EE2
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 17:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767980241; cv=none; b=AbiOAlAuPpq6A72W2MO4yHJMgWVv9Q5cgzltP33qcJ4TNwte3khU+1r6qMA09cjyTxswpIFyqxndK/hrFy8mHlWfLJt81Kjihou4Ocvy8GtgBXQrpInwkpiN5I0uT3R4asbKcCmejMwKPlZZZM8W8GT3jXdLSt4QqLVUrwP+xOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767980241; c=relaxed/simple;
	bh=U+8xCxyd7Rn3L3EYZP0HxvzAFurB71lGjd/rK3XY/TA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s8a+MLuJRchI3vi/e16Oa5l8/2DExUQIThI4f34YR/H7KVnwCKLGuyXREgmxQ2FtX3bIvEYUnTtkg0LosZsFUMneJnfHw+vCYwoa1ho6BtVFuj7L8nmjOEpWbatyHDDomYp7zoCgDRnNxLVlVMT0rad3l+STBRv1my/2+kZFSYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ICplM2RQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cWe1E8bQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767980236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGlJuAECP5RVFOi0B7pIIh4LfZmxJEZfIbuQk0LjIh8=;
	b=ICplM2RQ1YTJrP3VWyLESydTvIc4OrO4WWOwE+I/HtyBU+ghR4zkDLwrXkseCMvlzghpFE
	TjIt0sAeWVlTY2rc0U3uImM8F4IBLbFg0pQQwo3Nq2F0sgxjampzMXUdkuOJjqlEKaLZbD
	SoTEFie/TOupgaTaZeWXzNbzHySU2hc=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-E-qjxnJON7mPz-GZV5HzgA-1; Fri, 09 Jan 2026 12:37:15 -0500
X-MC-Unique: E-qjxnJON7mPz-GZV5HzgA-1
X-Mimecast-MFC-AGG-ID: E-qjxnJON7mPz-GZV5HzgA_1767980235
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63e0c5c5faeso6630980d50.0
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 09:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767980235; x=1768585035; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nGlJuAECP5RVFOi0B7pIIh4LfZmxJEZfIbuQk0LjIh8=;
        b=cWe1E8bQhrOIL+LWJW7XmM+MZcMYrooDmBOwqONnbiTut2T8hHx/eJopXc+4eLmTln
         zsm64ikeox4Hk5RJBT5Ugg9TyQsBsVCgF+YCo6DFcl5mwaF9xcSEPBjIWAoHF1seDYpY
         1lOGCLz8eLz7lDJX6XEqdxs2kJaPSZ0vbuLb2bSJmACzf4dN4RK0jWYugLEmvGbww4Bi
         xRjKzMX7EtLaY8TKkDFz8JNJo+4w9Gh+r2t61nnaAf3qc/YqdgxnrjsdSGl7xz+VyyLG
         HGoJvwqERUe/CIwYTJn3e6fKXNBd8akqO+ypIfpBmKerk+mV1RkQ51zs9b67X3u3G41j
         C+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767980235; x=1768585035;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGlJuAECP5RVFOi0B7pIIh4LfZmxJEZfIbuQk0LjIh8=;
        b=jyxuqqcLzY2hhc1hqL5va+ne1tKGwljvzHk65l4vJQNvGQsPU4GpkiwlOx7gc57bFV
         7LPvIce27HgI3d25ze2vgLYmGmNTco8scKV5nm6Xq43tDtHfSkTLjGWAAOaPVyzQXYGM
         rUiQJAJG3o2jyatmBa6uabAFSZMYoOtSO4CD+Df4IEuRUp+ngorFBN5nFKeBuf3JzWYF
         Pji1XEBANKwCJv4/NpTU8Zli2kfb6QEvGtKae8N3Ta2De4GIcazmjs8lctWz+nz1NW7F
         6TehHcIfoifqHjcfpBqVoZ1wq07mQlM0+zPrZG0RYPfXz7pjdCrSRBt00jx8G8VNefKj
         t6JQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIFVIyI9N+K8csw7QD+qj3Q02WSsBPAjUdaIyK4/uMtB8h+koD8lrdbC2wnaxn0RRgs3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqkYCPushjjyPDyWs/xTfmkj8uSRG5U2333EifTw8oPIVXRLz7
	arZ3mWD2UR4M4LcjG/uRaTiMZyuAeG7YpdSwzI5zdcSqimoeEKelbZw1VQ/fwAk1O8LufNhmAtP
	v4NcnWLJ426+fKgebPGKLBeTDEHmHQA03JRiEAAUhfgzta2UTy36m9hdeAaqSdbYRmBkqDC9LyZ
	sjtisjKGsKnkwnPU+IYhuamZlGq4vU
X-Gm-Gg: AY/fxX5v/PNVzLcjvRkrg5qXiJgu5vYUUmz3gJlrOCWENXSvPFa9bSL2kpuf6aPJU2M
	y9/7D/LZ5alvodwOPdsQz2oMHMRXDyoioWCQrA5kQmkOMaB0T3GFJuQkvcKixatHZcMJhbGjXoX
	UkY5B7OjLNNu/6HhKAQoNaq7Y6xTnzLnQ9Hsd7TMJgyf6KRVwwsgbU28yfisyMAbeXPNo=
X-Received: by 2002:a53:ac52:0:b0:63e:1ee2:eb03 with SMTP id 956f58d0204a3-64716c44ff8mr6829683d50.45.1767980235133;
        Fri, 09 Jan 2026 09:37:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaDuse1smMukXQ1jao6s4JVhTsVE3agPqyNoVuhcornHPk7Oh6l0MSW3HItJpIVH6fuNFbz/OXRwvg9tF/lvk=
X-Received: by 2002:a53:ac52:0:b0:63e:1ee2:eb03 with SMTP id
 956f58d0204a3-64716c44ff8mr6829654d50.45.1767980234802; Fri, 09 Jan 2026
 09:37:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109143413.293593-1-osteffen@redhat.com> <20260109143413.293593-4-osteffen@redhat.com>
In-Reply-To: <20260109143413.293593-4-osteffen@redhat.com>
From: Luigi Leonardi <leonardi@redhat.com>
Date: Fri, 9 Jan 2026 18:37:04 +0100
X-Gm-Features: AZwV_QhxT8wmn24EHLaBATVAerYOq5e7_fWePbVJH47-tb6Fs0SzPwwIlPTkNZ4
Message-ID: <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
To: Oliver Steffen <osteffen@redhat.com>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Igor Mammedov <imammedo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Ani Sinha <anisinha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 09, 2026 at 03:34:10PM +0100, Oliver Steffen wrote:
>Check for NULL pointer returned from igvm_get_buffer().
>Documentation for that function calls for that unconditionally.
>
>Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>---
> backends/igvm.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>
>diff --git a/backends/igvm.c b/backends/igvm.c
>index a350c890cc..dc1fd026cb 100644
>--- a/backends/igvm.c
>+++ b/backends/igvm.c
>@@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
>                 (int)header_handle);
>             return -1;
>         }
>-        header_data = igvm_get_buffer(ctx->file, header_handle) +
>-                      sizeof(IGVM_VHS_VARIABLE_HEADER);
>-        result = handlers[handler].handler(ctx, header_data, errp);
>+        header_data = igvm_get_buffer(ctx->file, header_handle);
>+        if (header_data == NULL) {
>+            error_setg(
>+                errp,
>+                "IGVM: Failed to get directive header data (code: %d)",
>+                (int)header_handle);
>+            result = -1;
>+        } else {
>+            result = handlers[handler].handler(ctx, header_data + sizeof(IGVM_VHS_VARIABLE_HEADER), errp);
>+        }
>         igvm_free_buffer(ctx->file, header_handle);
>         return result;
>     }
>-- 2.52.0
>

IMHO this should be sent a separate patch with the Fixes tag as you are
fixing a bug.

Luigi


