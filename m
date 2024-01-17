Return-Path: <kvm+bounces-6387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C9E98304A4
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 12:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F10288F90
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 11:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCED11DFCC;
	Wed, 17 Jan 2024 11:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O99Y2TUi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BBD1DFC3
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 11:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705491573; cv=none; b=OFsxV8afkjFis5b5Ww1Ji6p80c0F0BgsiwTYSoMPVpWrodJXJj+90EN2EVFhm5WW6ClPfFcIgY43RVkIsk7negeCXqZ1ZjtHJ6YbeupPhdKhvAQfELxOjfXCU64HhaTybLtdR0Vo3poIGRI3N1Qf29yhNUnabWSsd0zVzVQ+ZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705491573; c=relaxed/simple;
	bh=T9KRxSQfE72TxGPGf27x1G5s84+vet0cu6P/7fWj8hA=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Received:
	 X-Google-Smtp-Source:X-Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:Content-Type; b=j0TNO3iYNZE7VndEjjcnDEE4E9RshB63OEUTA13AtI7Fe5beqqZ4CYy6BepuoVscLQ+IvTFhiwIXugZyz801RO1ARSpc0+oDcGiCViMploLBh8DRX9Y38cPdhdksMoXUD+mj7/TGC+I0MtU1d2cvgwZLj0RCEDGMVGnnc7TrleE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O99Y2TUi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705491569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CH626pSqKFSD+Kp2qukzp0Y/x3O//9WPmqfkQBgYC4E=;
	b=O99Y2TUiP+PIn5ZPGgAbsRxA08SEm9TbLspHF2zKI7Ow9NgZgLb+9HRou5wQC6Vw4P1iyW
	sGYwzN0YVJ4uCxr7SFBYz3xM8K1m5tPKsBLuI33wuQBd16rvFaTQyEx2DT3O49f1XclOcn
	0uLu8xyVgiGLHqTJNR4iG5DdywHjv2Y=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-kaI5fTgiO0mHhcTU-XUNGA-1; Wed, 17 Jan 2024 06:39:28 -0500
X-MC-Unique: kaI5fTgiO0mHhcTU-XUNGA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-428205848e9so161648001cf.2
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 03:39:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705491566; x=1706096366;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CH626pSqKFSD+Kp2qukzp0Y/x3O//9WPmqfkQBgYC4E=;
        b=B9xbhkoRII1GVxVUCnZMh3Z94wQnLWgurECABgVYlssKwh+4WY6FEZ45AfVZW7hB4g
         f5OJ86Z62Bv3DSt7Ok44zTnp0uFLGL4es90ohhDZkpcxPH66zT0061CHYpw6DvUWkrhB
         rehupUBLbXIKIN7JBlblGlFJ8/NTNSLwe2rHHmFa+f3SJOCfOg0in8jinPZACdsmo2xP
         c1LnsRNg1gvFlkGwRFIq99RfrR12oSJkEkIFoHnWKBZx42B2sL9AX9om70OirixMVKRS
         LtueD78vmO5M4FkMTLsOhlYLWKcAVlAcBwqNo5ZSLG13Xcf3E49lKScUHBElRskAes4u
         8BRw==
X-Gm-Message-State: AOJu0YwTpQT98sGAos5iD/kSUs27nvcOldXVNJQCeO4uKFos2Q05STki
	4iXOFyB3R1HA/Gt7F9wVF0oa+D2zVpMQJ4Hq7xYddTE0Ni99cMddLHNXa3vRn+wvapjA2cbz56A
	6lhmo8U2Q3AzjAh0zR7qB
X-Received: by 2002:a05:622a:1045:b0:429:7536:60a with SMTP id f5-20020a05622a104500b004297536060amr11218306qte.9.1705491566764;
        Wed, 17 Jan 2024 03:39:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFjyYd7TVFZ9RUZ/mmwqBFGqktSN/tkqg9ofBVdteqCohddRy4jWXtee54vCY5ApDEycDKOJQ==
X-Received: by 2002:a05:622a:1045:b0:429:7536:60a with SMTP id f5-20020a05622a104500b004297536060amr11218298qte.9.1705491566541;
        Wed, 17 Jan 2024 03:39:26 -0800 (PST)
Received: from rh (p200300c93f0273004f0fe90936098834.dip0.t-ipconnect.de. [2003:c9:3f02:7300:4f0f:e909:3609:8834])
        by smtp.gmail.com with ESMTPSA id h7-20020ac87767000000b004260b65b4f7sm5677357qtu.97.2024.01.17.03.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jan 2024 03:39:26 -0800 (PST)
Date: Wed, 17 Jan 2024 12:39:21 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>, 
    Gavin Shan <gshan@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
    kvm@vger.kernel.org
Subject: Re: [PATCH v5] arm/kvm: Enable support for
 KVM_ARM_VCPU_PMU_V3_FILTER
In-Reply-To: <20240115080144.44944-1-shahuang@redhat.com>
Message-ID: <71625f0a-da2d-92aa-0055-72140257b665@redhat.com>
References: <20240115080144.44944-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 15 Jan 2024, Shaoqin Huang wrote:
> The KVM_ARM_VCPU_PMU_V3_FILTER provides the ability to let the VMM decide
> which PMU events are provided to the guest. Add a new option
> `kvm-pmu-filter` as -cpu sub-option to set the PMU Event Filtering.
> Without the filter, all PMU events are exposed from host to guest by
> default. The usage of the new sub-option can be found from the updated
> document (docs/system/arm/cpu-features.rst).
>
> Here is an example shows how to use the PMU Event Filtering, when
> we launch a guest by use kvm, add such command line:
>
>  # qemu-system-aarch64 \
>        -accel kvm \
>        -cpu host,kvm-pmu-filter="D:0x11-0x11"
>
> Since the first action is deny, we have a global allow policy. This
> disables the filtering of the cycle counter (event 0x11 being CPU_CYCLES).
>
> And then in guest, use the perf to count the cycle:
>
>  # perf stat sleep 1
>
>   Performance counter stats for 'sleep 1':
>
>              1.22 msec task-clock                       #    0.001 CPUs utilized
>                 1      context-switches                 #  820.695 /sec
>                 0      cpu-migrations                   #    0.000 /sec
>                55      page-faults                      #   45.138 K/sec
>   <not supported>      cycles
>           1128954      instructions
>            227031      branches                         #  186.323 M/sec
>              8686      branch-misses                    #    3.83% of all branches
>
>       1.002492480 seconds time elapsed
>
>       0.001752000 seconds user
>       0.000000000 seconds sys
>
> As we can see, the cycle counter has been disabled in the guest, but
> other pmu events are still work.
>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>


