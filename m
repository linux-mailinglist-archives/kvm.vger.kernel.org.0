Return-Path: <kvm+bounces-8977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9F598592D0
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECE6A1C20FA3
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4DDA7F490;
	Sat, 17 Feb 2024 20:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WVfzaUFG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E6F1D6A4
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708202731; cv=none; b=kwujaM/pRJ18+uM7jK/WyYsID+ARMIfjHK6wUSDg4pSVv33S3SZX/og/3g+5/xAwSh6EeF7kXiecfYu21TSvZF5z7wB8F+B3tU2ozmDHroiEtzUNHO+wIBaJ2bORJ2q4LSNO0+Zb5SmMpyzwlhyUhXWxSlxq+TT2Maumhl/c2kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708202731; c=relaxed/simple;
	bh=NRcCcNrGSs6DgycF78Kmx0enC0lNWUE/s5XZjEF7bmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V48laQkPV2CA4IaPTSo2LSmVBG53WE+lDuQ8pVXrVhOguhNmYGDdgPIhg9+D7lTeZ3CLQEUHLb+tyTe6sH+Kqfl60fj2KVFHs9lHo2brozlTM7rkf/3d32DZAMvTx1J2Tx+BRpiCKbE/BKhuQp1ewBeicpgGRYB0J90rf7XbPkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WVfzaUFG; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6e2d83d2568so2123534a34.3
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708202729; x=1708807529; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BQkxEuZ1KKupyrZd7n2S/dtoK9dG9RrsFuLLvaqdWc8=;
        b=WVfzaUFGuTkuODnhEl65VT8M6LJnFSFfK52IPMI6GEWncKF1Y2NClyJowDLTo+lhSO
         +WuxOTJIDR+tVqK8/ZO94RD6f0Qx/myn9s1N7nULR6V5C/e9H6YkgQmJyuX7+miMosmp
         V+BcmdbNVM+8K00/5SB9n8HLfT0Xm9+KNpK8fEzh3GnbcNMLaTo33Dy1pDcTvCZn6TiR
         fAtvTBDzDB+RH/S0weVmoBF3pVty0cMSjZiGQq/jZRO7dY6128rhk+ETXT6njaD/Qnum
         T9MSXbR0gpPGyLmhm22yNOM7SmZ+keHy0xrNoZmxPDXTCuU4w3oK82oGUtsViGilXzVk
         Ud/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708202729; x=1708807529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BQkxEuZ1KKupyrZd7n2S/dtoK9dG9RrsFuLLvaqdWc8=;
        b=Fh/bfYPMscdVn/dsGmt36v1a04vE7iSvx4Typg0+ftpIbpuMVmEiqVetFfWgzvFFKx
         8G7VCcxcW/P4H647h4snLAF54qeBme+gPqLoekEu+vFBFRrzYFQvUwAnirKEcwPbs6xQ
         u0Q0EtwGJEUKnSdyA/0xAzkiORP+XS6HWEXwO577qW3xcKdx3Ks5khMyfbu2koPEnfn3
         P4FG1rx7d/vatbhy6c0O+YEynqXVi8DhO2cLuNGN/+XX6TQ7f2+ilmCMKlAKml0c0MJV
         DwYwGaJSkCJYzAgAOZ/AGH/CIpf+L/inVdQcUvBblCOtFgrtTgE2nk8SY9GBTAjUB8DT
         eWAA==
X-Forwarded-Encrypted: i=1; AJvYcCV153B/2G6RXKMrXkX0Vr7s+F8Kv/DZsx5LLQjOUuaolQemm26c8CrxtukFEIGLuPXusyFMpDUetGELiwh6VIudNjTL
X-Gm-Message-State: AOJu0Yz67bYah1f1n3S9kef0TBZ9Z+7WQxfu64KIawNQaV/H/O3Mvwh2
	PeymNP0ssK06stRjNIgOnSox8z4bxW7r/0aAXDw9SWiExsf7n56BoB99KYxl+fw=
X-Google-Smtp-Source: AGHT+IGFQWvIKwYozypTA3uyCZtbBkvzPp8/M73Rhaccz5bR72FAAO89LTRammDImYPkPdi1VOBlfg==
X-Received: by 2002:a05:6358:94a4:b0:176:6141:48e5 with SMTP id i36-20020a05635894a400b00176614148e5mr10359766rwb.10.1708202729365;
        Sat, 17 Feb 2024 12:45:29 -0800 (PST)
Received: from [172.20.1.19] (173-197-098-125.biz.spectrum.com. [173.197.98.125])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090aca8400b00296f2c1d2c9sm2227236pjt.18.2024.02.17.12.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 12:45:28 -0800 (PST)
Message-ID: <67ffa947-5538-4d10-80ca-024c9a62e229@linaro.org>
Date: Sat, 17 Feb 2024 10:45:26 -1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] hw/sysbus: Remove now unused sysbus_address_space()
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-7-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240216153517.49422-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 05:35, Philippe Mathieu-Daudé wrote:
> sysbus_address_space() is not more used, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   include/hw/sysbus.h | 1 -
>   hw/core/sysbus.c    | 5 -----
>   2 files changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

