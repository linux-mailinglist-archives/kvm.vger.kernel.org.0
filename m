Return-Path: <kvm+bounces-65750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA66CB5791
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 11:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A08A30221B4
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 10:11:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E039E2FF644;
	Thu, 11 Dec 2025 10:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPnGn7YB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pdIECG6N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E223FC41
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765447882; cv=none; b=mlj/oXwFyqrLm0IBkzHYqdNDkkUltAR+eBsW3JJdOs7LzR9B8gAtHTFBWDXjFaAdZETMtFWNSk8AIIK94jXLzTOqgIaUbMNPOFkp467H7B6Qex6D79wm56ZtZBrgrMMalG5PPeB5MPa53pYeY5XwYJil3freTGjdgyJkRcT3XAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765447882; c=relaxed/simple;
	bh=ieDEbKeIqGNM64mAYdwK4wgf7i2Wc2yIXAJzv0glOFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uopIZPK8byuec/lXUYTNPpHjLUF2LGUzSKlT89YchltG7iigiCTUwzBkAleKHfM0x+0N/aNelqVgVruKSBLyhwCWkSekHrwVqvL/uz7lAnnBYcBE9NuLT0NkVSYUUMuGBZN8UtwqIzywdKL1wndKFoSts4OSLJuGoii9jIgxFDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPnGn7YB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pdIECG6N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765447879;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nmgh047vTXzbL2NzUqcQqn0ZNP7gmgaU+Yt4vREzk4M=;
	b=VPnGn7YBqM/iGs959Y8T3ZLc2Ezc0c/qtVJ0I+AHwhSbrFMOQ8Y20sJs3lHVtaIdU9wNe8
	E3XwH1B56weeuhoqXf+cWsPpul1oQ32qcHkutVyu8+aiXkJX7n7XbOq+23OJYe0FdnsK7w
	8rFiK01RXfHYhpaAQvVy3Oolmb/Wc70=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-jHWy_XTFNm29Shkrrbh35g-1; Thu, 11 Dec 2025 05:11:16 -0500
X-MC-Unique: jHWy_XTFNm29Shkrrbh35g-1
X-Mimecast-MFC-AGG-ID: jHWy_XTFNm29Shkrrbh35g_1765447875
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-649839c5653so781807a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 02:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765447875; x=1766052675; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nmgh047vTXzbL2NzUqcQqn0ZNP7gmgaU+Yt4vREzk4M=;
        b=pdIECG6NThk4w5PMDhBJEa/GSse2btpYHPwQFmbh+wjn8ya7erDoZEcyCUe6lcoxik
         0+fZK3rjMz/KSUvq11KfEdNZdsfzCheadYtPQVbXDTqF1U/8YbWF4FSw5Ol3gx1uRxeq
         wp+vOaORVZ1Fepecqsn6950S6fVVkmQCGGFLyIcvN69aTHgjJkKqwru77fyOxbVuOv5R
         V5luiqeoOuit0k4b37BRrDn6l9RlYWc6jDrmiJaBph7Z/9KKwHxfC3DKv1OTQoKkVMUK
         yhdBnTykk1sr2/b6gztky+DO/A5sNGH7UCe2YUSKuJqqPCnpa3driCQzqP0lmxvcAiXp
         VZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765447875; x=1766052675;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nmgh047vTXzbL2NzUqcQqn0ZNP7gmgaU+Yt4vREzk4M=;
        b=gKmDe1q3aKGgT57Xb4PYLnoWtrOAXq6p50rQ7cEix9hG7s23OKBFKTmAHlyuPi5ali
         ikDOvy6jSpKOjNdpxB98XDbOfUjkTbnZzLqlsZkh2f7PyJOnyomKYQh21b6UNzr/a7O2
         8QiljLrxwCapfS0yzzyZXmfg91flO9CezFBUv0E55v4vbzwE1sKwnyXUJ3nLBLTa4OsD
         YzFWiyjLKtNtBhu4dWt4R7fhUnGvi2CJfTGsGZMo5XQZ0crrxZH48Cmg6+UPUzSY7JDF
         ugrczSa7cfk+GaKQIRVYDKlEOoDIjLyCpD5wIzCzIohheTAlXZBthFxPpYQTANDLuGav
         OwkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgwMBqzzFtHwOAKoFZJsa244omMHHiomzft/+q0N5NH1/tYocVMuTJ4R8AZLUXA9AlhDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyucriAJgMtmE9JKvjV+f3A8Njov7Rqo7twfe1L+DUCNmS6abYe
	mTVGXeMgVdCGVwOTkdGGpqdAp8QISSdThXBD/LDOGekEHxCFD3hGEWJQ6DtVMGIA3lBnZLWSqRh
	1/uLdOMcwJp4hjDqK3J5YlavcDtEmuP8knz7N919q8ODfLH0sTSUVjA==
X-Gm-Gg: AY/fxX45z6mdJd3RT/gTwbl+1C0Dq6twIDnNUUZMLin9X0qdIq0kBw5rb0j7IEfLu4y
	Da95LzWDutrwQyr3MkwOHry8tU2Gjin1X9u9hNHnWudfHn4lZssjOfIYmuUGnEZEUkqhwVaqh0h
	b7LDIRW3jG+LyFacZ2AwAtIIXMwVFIwlDCNB8g9M4DWEXuGCpt8O6WJeUAsJ0VY41Y0GjBAaIGJ
	DXM8nRFyEipiAHQV+2xfKOA3RhiCwHXQEGqOmv0j9Xfl2jqaKHoy4GQCWzd1B1GcabS5NwWF/GX
	8sVYLt4WLyvi1ibi+fqp0R2vBlpTF6Rj+sNt9EeeC+zJdCxdoOwV+EzqYga/MmjrMRGZbks7yey
	bewKmwpiuh8ZcM3IzhD0GI/tq1r+NXJ8odHQ73/xUVoTD53irIeEcB3hPFduq5g==
X-Received: by 2002:a05:6402:3806:b0:640:cc76:ae35 with SMTP id 4fb4d7f45d1cf-6496cc16e8dmr4273814a12.21.1765447875199;
        Thu, 11 Dec 2025 02:11:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEL9F2BGjWMptuXWE8ym5gN2gmqMqswdja2gDOQYxkXSnuOw6kLl/3ko+o6V7ALLN+WLcMTvQ==
X-Received: by 2002:a05:6402:3806:b0:640:cc76:ae35 with SMTP id 4fb4d7f45d1cf-6496cc16e8dmr4273786a12.21.1765447874682;
        Thu, 11 Dec 2025 02:11:14 -0800 (PST)
Received: from sgarzare-redhat (host-87-12-139-91.business.telecomitalia.it. [87.12.139.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6498210de23sm2068573a12.28.2025.12.11.02.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 02:11:13 -0800 (PST)
Date: Thu, 11 Dec 2025 11:11:08 +0100
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
Message-ID: <qlgmkqwjoupf63drmvrfv3qslp3wvrvphgiafnuluayfjtlj3m@vkecklsigqju>
References: <20251211081517.1546957-1-osteffen@redhat.com>
 <20251211081517.1546957-4-osteffen@redhat.com>
 <26ptyaovy6mlbvuzri4v2ea3xhyvdc5elqsau34upvswarrbop@bhtzvxpb5aad>
 <CA+bRGFqnT=Es1GE6w4U2edaJXpDaSV1bhZ89vcaP5TDfFU8a+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+bRGFqnT=Es1GE6w4U2edaJXpDaSV1bhZ89vcaP5TDfFU8a+Q@mail.gmail.com>

On Thu, Dec 11, 2025 at 10:24:35AM +0100, Oliver Steffen wrote:
>On Thu, Dec 11, 2025 at 9:46 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>> On Thu, Dec 11, 2025 at 09:15:17AM +0100, Oliver Steffen wrote:

[...]

>> >diff --git a/target/i386/sev.c b/target/i386/sev.c
>> >index fd2dada013..ffeb9f52a2 100644
>> >--- a/target/i386/sev.c
>> >+++ b/target/i386/sev.c
>> >@@ -1892,7 +1892,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>> >          */
>> >         if (x86machine->igvm) {
>> >             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>> >-                    ->process(x86machine->igvm, machine->cgs, true, errp) ==
>> >+                    ->process(x86machine->igvm, machine->cgs, true, NULL, errp) ==
>>
>> Why here we don't need to pass it?
>
>Here we only read the IGVM to figure out the initial vcpu configuration
>(the `onlyVpContext` parameter is true) to initialize kvm,
>The actual IGVM processing is done later.

okay, I see, thanks!

>Should I mention in the comment above why madt is NULL here ?

Yes, please :-)

Stefano


