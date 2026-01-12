Return-Path: <kvm+bounces-67712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AB3D119C6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 10:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CDE3230082DA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 09:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C78274B28;
	Mon, 12 Jan 2026 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PjJvV1Gl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PpHIrxxp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9153275B1A
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768211403; cv=none; b=Sxz+IzODGHdHGrBEsm+/PRmBIzWo4lqdh7avQYaMKxrqOnruZzYjT1zV+aRjeRcElltY4Do1KRCGgex8fR0ENOsJGgy0SlRZ1tyu8Oq1u+Y8f+Jr0Otayhy8GgjHDoxoS4C83ypyHTxRHrDJe2MkpOTHnyQUdMjJ5qBoxd7nU28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768211403; c=relaxed/simple;
	bh=ptN+NGIu8cCGXyFp2lNt7IISPhTkwHH+7SoXxV2IXAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLsqzFWnw/WspZMhScfUyl0GoKs2j24F7/q0UllEZNAIoiY7uUC2rxbpuZ/92BNdR9GBeAEAuxJvRtiOTWFVR/3nBrWm3LXdC39cji0WaN1JaFDsgQAEUgBwAjd+spkiqWvKseQB+TM72qZTN0rMJ7OcI3wH+hAV02gvP7ZsnOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PjJvV1Gl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PpHIrxxp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768211398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8fgziFjFXA3dbeoUPDp41axuh7mx8q9dpfJJsooChSE=;
	b=PjJvV1Gl0g8TCLc/t7vlQUrqbA69tGWEu5LPZU7D+/twT6ppZU25dHarjaOkx8lwGKIwfx
	jAC/+xggY+Oq6oGQtwl9UT+ytjoo3/SGwbWawt+Zwvkg7SVyKoPNSapLN7fOQ7XcBqZAF+
	kV/Ynh8FdYtk6G74p1SxK9Q8x4iyUKs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-i9vQWOjONSuQvaGNCFDZFQ-1; Mon, 12 Jan 2026 04:49:55 -0500
X-MC-Unique: i9vQWOjONSuQvaGNCFDZFQ-1
X-Mimecast-MFC-AGG-ID: i9vQWOjONSuQvaGNCFDZFQ_1768211394
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4325aa61c6bso3832372f8f.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 01:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768211394; x=1768816194; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8fgziFjFXA3dbeoUPDp41axuh7mx8q9dpfJJsooChSE=;
        b=PpHIrxxp7UnFk2DQR/+j5/2nkeyglyRoaH9CvpgJSeON3EggPD+V5iKobRzslSBrzK
         nH15Huk09c6BH5HYJUPEThP3Mxvbpxez+04M6ozU8I6NxP5u24lMQTKIHbq/03KT1n/Z
         R1c+fF2QFVLNEfpKGEPGtMBwhtoS2l89dRY2yN3CIdJYKbgcGJ7qW2bUlLTECn9InGpn
         VuJIM/oEuASx4FUesfFSFEiO7sq1zOmUTCoEgGtgqxxslQvN1/n6xpQVILe4jVhj8z0N
         eblpTV9LtIJctUhq3DguQ5dMZ0jzj9hl7fPXDX/69K1Jx+2Exo1lQTiK+qNl7gT4MiZE
         wePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768211394; x=1768816194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fgziFjFXA3dbeoUPDp41axuh7mx8q9dpfJJsooChSE=;
        b=BPn96YMH9DS+5S5WPLAxObdOuACbIWBEOZHq+bvnisy/ZQty83H7G97dcKlJzfykU/
         W5qy2Hk7FGdcmh7a8k5hLLnceEUWbVXEmk/9UM/UlbO98ptnKrOVjOqH9J0Y6KfMHIlL
         pHeFrcrSYf/TnwbYx7j4zkaSl59BDBCA/Y53ynU/78EUyZhPCAG/EPnL5eR5hYaaYtse
         uIgqjnv3nsHi0AthsTUuaPqkNah/hbAuGjmqrgTAMZJqabh7I63PzJvtgsbuUKXdwRD+
         rRQ4ndsDM1pWw9VYBz6vw12KrzFhvUa+i8NeDcinuzNoVBSznnrDL8IXFHIEHT/l1Bzn
         DaPg==
X-Forwarded-Encrypted: i=1; AJvYcCX7j0e+E7bdvwu93oCm/UKQ8ONcaMIjYPUwZdIiXRyUhFeXODhBFYZvxJSHiFQGeoL5ZuU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNLBApnIEFa7gXSoDkyndwb0/TYTl+GtN73dkAcjq9yEZRzEFG
	Jl9owpbqgpSqVPVZITHnZA2NpwpFpSu6pyZD9NtYR7/BInX2s/E6ARqHPsGYPZ94y7PlfpXtWqA
	CyuZztSi45RkTlDHLAo9bLYtcWvGXDN0FNK/gEVFdmEt4Xa4V2yWkgQ==
X-Gm-Gg: AY/fxX5x/k8V5D+eAARCzXEXjTyAiCve1HeTGzGLObBhKYdm94y6VTA3OCQkCCvLRNn
	/0j9a1VkUQ6QY1BF9IUvrz1Il33hJG60vG49vEClY2mW9kJCBMAyr/tsVrhpvMxiqTeRQLarV97
	Q6Rvx36fVbNsVXOcHrDDP80nYfeRQvfnj9YkZOlGCb/8HQD6m7NJUb+UaVnzB9rl/CsShZxSCr+
	evIcBtEc6IMXwjTQ/VCL61CEyvW+jBPmwquqqHA5FcuY5Gaij6SOb5f950HMgEH/KZyYQKWpyzc
	gZ5y0NYQv1bGZJZeN/F0+bWm3XzhL1vMVNvibocILqweXFaCx1KMLi99xcscCzD/N5xrlvewReh
	7/j7LGppydP66ZqE=
X-Received: by 2002:a5d:64c4:0:b0:42f:bc44:1908 with SMTP id ffacd0b85a97d-432c3628318mr17245803f8f.6.1768211394225;
        Mon, 12 Jan 2026 01:49:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHA2tLcO8zjiGhtifDCpP9B3a2SPq9eEJVyExe2owev6ZeKkg5tfu87PbSStoOTFL1VHJ1QlA==
X-Received: by 2002:a5d:64c4:0:b0:42f:bc44:1908 with SMTP id ffacd0b85a97d-432c3628318mr17245770f8f.6.1768211393845;
        Mon, 12 Jan 2026 01:49:53 -0800 (PST)
Received: from leonardi-redhat ([176.206.16.134])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm37608927f8f.40.2026.01.12.01.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 01:49:53 -0800 (PST)
Date: Mon, 12 Jan 2026 10:49:50 +0100
From: Luigi Leonardi <leonardi@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Oliver Steffen <osteffen@redhat.com>, qemu-devel@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Igor Mammedov <imammedo@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Ani Sinha <anisinha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Zhao Liu <zhao1.liu@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org, 
	Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: Re: [PATCH v3 3/6] igvm: Add missing NULL check
Message-ID: <aWTDQZT4L3mX3Rfd@leonardi-redhat>
References: <20260109143413.293593-1-osteffen@redhat.com>
 <20260109143413.293593-4-osteffen@redhat.com>
 <CANo9s6muvcOrDH286o1zA06tRUvZBnOBqn03e0RiOEDC60W4sg@mail.gmail.com>
 <aWTBdSDO9KKpXLt4@sirius.home.kraxel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aWTBdSDO9KKpXLt4@sirius.home.kraxel.org>

On Mon, Jan 12, 2026 at 10:41:01AM +0100, Gerd Hoffmann wrote:
>On Fri, Jan 09, 2026 at 06:37:04PM +0100, Luigi Leonardi wrote:
>> On Fri, Jan 09, 2026 at 03:34:10PM +0100, Oliver Steffen wrote:
>> >Check for NULL pointer returned from igvm_get_buffer().
>> >Documentation for that function calls for that unconditionally.
>> >
>> >Signed-off-by: Oliver Steffen <osteffen@redhat.com>
>> >---
>> > backends/igvm.c | 13 ++++++++++---
>> > 1 file changed, 10 insertions(+), 3 deletions(-)
>> >
>> >diff --git a/backends/igvm.c b/backends/igvm.c
>> >index a350c890cc..dc1fd026cb 100644
>> >--- a/backends/igvm.c
>> >+++ b/backends/igvm.c
>> >@@ -170,9 +170,16 @@ static int qigvm_handler(QIgvm *ctx, uint32_t type, Error **errp)
>> >                 (int)header_handle);
>> >             return -1;
>> >         }
>> >-        header_data = igvm_get_buffer(ctx->file, header_handle) +
>> >-                      sizeof(IGVM_VHS_VARIABLE_HEADER);
>> >-        result = handlers[handler].handler(ctx, header_data, errp);
>> >+        header_data = igvm_get_buffer(ctx->file, header_handle);
>> >+        if (header_data == NULL) {
>> >+            error_setg(
>> >+                errp,
>> >+                "IGVM: Failed to get directive header data (code: %d)",
>> >+                (int)header_handle);
>> >+            result = -1;
>> >+        } else {
>> >+            result = handlers[handler].handler(ctx, header_data + sizeof(IGVM_VHS_VARIABLE_HEADER), errp);
>> >+        }
>> >         igvm_free_buffer(ctx->file, header_handle);
>> >         return result;
>> >     }
>> >-- 2.52.0
>> >
>>
>> IMHO this should be sent a separate patch
>
>Huh?  It /is/ a separate patch ...

Sorry, I meant outside of this series.

Luigi


