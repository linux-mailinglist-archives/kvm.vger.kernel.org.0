Return-Path: <kvm+bounces-62802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D85DC4F509
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 18:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CED5B4EB8C4
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 17:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7EA3A1CFA;
	Tue, 11 Nov 2025 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hWeApdl6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016082F261C
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 17:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762883414; cv=none; b=H/KiTfMT5Fl1ul0ZVQS4TMIZPnB5WFrONnFcXYA/EHZiDWYsth2riiunyvK2Z3vQmxMqB6aohPujO2hKcljFq65y/dRqH/L6AHqOfB4UYSK0KLd5L1EzqnKjkb0VuJmcgbVPhR6K8/QaaCqGtbQmdnjYXHOW+CC9Ym+ykyMVCjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762883414; c=relaxed/simple;
	bh=WWMmwhWdWNyNjLHmzBhq4csR610NwWHiadSzqjR/lWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jcghXJDqR5z83IK4+53lWhxCGOB31gvn3/ciIcbDWTTh6JyKy3fe5e1WxvVR1rvN0SwXlOuAr3TZxP3xXBGr+ELYsS9209F7Mu2glmW0rpvINQ+n9dmqlF8TNjd6g9iHWWe8xjkyNofBpoe6I8pYsq2C1NQGW6R6wA9md7bHZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hWeApdl6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762883411;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V5YdgpSepIM+Vu72ZmZR6JDazpPsxkKp2SzwOXtK9HQ=;
	b=hWeApdl6Raz+/kUtfVgtWcAsjtm7PP6DMAsqtsZGYmfyGng/ngNIvOxKQhRtuRCux4mUUA
	n3aW/YEFjHTZ55gaaZMUO6YLT5QZV1fNOWInhz1FNUrf8BNCPtxvPUqVWL+lvAPuV0L153
	cf+TPIBwelLhE7tYSU21GzkwJtGbis4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-106-1hLFQxmRMzKbprB-OgeFOw-1; Tue, 11 Nov 2025 12:50:10 -0500
X-MC-Unique: 1hLFQxmRMzKbprB-OgeFOw-1
X-Mimecast-MFC-AGG-ID: 1hLFQxmRMzKbprB-OgeFOw_1762883410
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8804b9afe30so105937076d6.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 09:50:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762883410; x=1763488210;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5YdgpSepIM+Vu72ZmZR6JDazpPsxkKp2SzwOXtK9HQ=;
        b=tXSwWaxIu6WSG9Y1Ss4qpdN+B28rsU0j+gkNqWHd7XhZg17LINkAUS2hkhcbePcgTO
         zfKEYLhRp1yBk4xePj0rl9CtppHoOUZ4KfAQtHGY/QILLJA7wLgpLzsA4+pNdBlcPEo1
         I0i+ZLvOgU3+lnxFJGJEIYeMUyJL6/zrGYhUpPz0bDc5vyh+vINim7WkkUpc0B/xbxFB
         sCNuWDK22ExfBNTht8R/xIzYLCo4a4KRO4gI5n0WsGpS+8/VCwTN0xPR5SdEagRoIvbe
         UuBAw3MPIeh2X2q46FcXF5Fb/ZNagy9PbNFy2oV9qdaFcqPDWT5fD0e2Zi5uiJkmgP2F
         NoYg==
X-Forwarded-Encrypted: i=1; AJvYcCWy4tQzEpsJvtp2Up4xDxf5XreRJHfGUAJErQeLSH12HqwDZ7BnzkRXKrr9yftAORl056I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc3W1NCz3qJ2l9L64umw8toVvI18aqwKUo81Bz8SiOCpYv+xBB
	PGdW4oL3Yoh70pVySQiuSZ9wl4BBY1xlJvKR/d64WEWtSapCuqdqTVMI2QK1mQc21hlUDncr+kF
	wf2vOw/MbX8l+ahsUGO5IQNJ/pkG7LDZikTgc2fHLYnd7x3DdQ31UPQ==
X-Gm-Gg: ASbGncuGA4fn5cwAvf2IfrwPZAZrWaIJqPgIoXiix3sIl8LATfcSATwUawKUbCh/Qzl
	/UeiKzVsTCt4yhenBimJJTqnq139cy7AKzjN4bVSrnIoDK8lyoQ1mcmghElpNbPhZn/PQsyrGjx
	XmeA/PTVA+WVke/5U8wcdX/pRFH+oHAcHDMubMhxnuvYyFQJs2caLBtogcXJiN2+4L/mwZCnYd/
	gup3kYXDqlEixLMa3MpP23qpPSOTRyLrLdzy2BxIs9nvkzgs4DRTvHiVZZVog0MNEGjgbvp21Mj
	R0y2PeMdQW1nM8um4k/VXLtVFEX9uYXzGe3OrwrIFumXKIlUzywp9mzFaFqhLxAtdqsXRjVm8kK
	4vNc1tLcv76IFitNijNdBZrocnZY3utcw+PYH35q3Y0RaEpksD0F5B7Fu
X-Received: by 2002:a05:6214:1256:b0:882:3828:fa33 with SMTP id 6a1803df08f44-8827195f622mr3497596d6.26.1762883410122;
        Tue, 11 Nov 2025 09:50:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0Ci9tdkmBBhpaJb4rkRghX6NZbIVWm0/hZnIdsIzeoWFuTuvMXuGLGtwGnZRnSZ7XXAbryQ==
X-Received: by 2002:a05:6214:1256:b0:882:3828:fa33 with SMTP id 6a1803df08f44-8827195f622mr3497326d6.26.1762883409798;
        Tue, 11 Nov 2025 09:50:09 -0800 (PST)
Received: from [10.188.251.182] (cust-east-par-46-193-65-163.cust.wifirst.net. [46.193.65.163])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88238baa0aesm76833956d6.60.2025.11.11.09.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:50:09 -0800 (PST)
Message-ID: <ad87bec9-e36d-4c5d-adf8-ae92917451a2@redhat.com>
Date: Tue, 11 Nov 2025 18:50:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/2] target/arm/kvm: add constants for new PSCI
 versions
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20251030165905.73295-1-sebott@redhat.com>
 <20251030165905.73295-2-sebott@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251030165905.73295-2-sebott@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Sebstian,

On 10/30/25 5:59 PM, Sebastian Ott wrote:
> Add constants for PSCI version 1_2 and 1_3.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  target/arm/kvm-consts.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/target/arm/kvm-consts.h b/target/arm/kvm-consts.h
> index 54ae5da7ce..9fba3e886d 100644
> --- a/target/arm/kvm-consts.h
> +++ b/target/arm/kvm-consts.h
> @@ -97,6 +97,8 @@ MISMATCH_CHECK(QEMU_PSCI_1_0_FN_PSCI_FEATURES, PSCI_1_0_FN_PSCI_FEATURES);
>  #define QEMU_PSCI_VERSION_0_2                     0x00002
>  #define QEMU_PSCI_VERSION_1_0                     0x10000
>  #define QEMU_PSCI_VERSION_1_1                     0x10001
> +#define QEMU_PSCI_VERSION_1_2                     0x10002
> +#define QEMU_PSCI_VERSION_1_3                     0x10003
>  
>  MISMATCH_CHECK(QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED, PSCI_0_2_TOS_MP);
>  /* We don't bother to check every possible version value */


