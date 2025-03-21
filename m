Return-Path: <kvm+bounces-41707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D7CA6C203
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1F61B60CFA
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3C922E41B;
	Fri, 21 Mar 2025 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yuWiwugY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA5122B8D7
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580141; cv=none; b=tLVfQYi1aIDhxesKQKjb/Yxi7ihh+Hj3tQ0Lkqh3DzQFgOs64C2Cm2oFlJxFWs4tm9Gzs5x3hIvhWIJVJy2yJB3ut43QJUTBuksZnpIRWMn8BloFc693RkhsUjuSXA9y7Tnmz+MlgDK0Vy3uduRtL/d0/Pw333lYVEpoRsVhyY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580141; c=relaxed/simple;
	bh=hxtnyaEpNvrnURB6bG523pgF4GaNkibU9SjRhF599JI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkY6Cve976K2/Hb4W8NmmQEKKEVbi+m3wsSFHBjYoJ+BkXQhVAiPXM8fFMfmLewmXLXzvqAxR9RkXyOZyQZvrLpMJ6B/y8MHR++AWwkfsZHYsXbGJoZKVtS4GAAgvDp0boHLpbv1V6CVF8ASIaxI4Qkr55RfDjY+yMJW1N3KI5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yuWiwugY; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223a7065ff8so16544935ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580139; x=1743184939; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A9wfgTNVwbh5MviuCEEjiqNP7cX1EHVYoRPAjNSeYzY=;
        b=yuWiwugYGBDDfVHxwO0bQofjlltpHWnpx++M/WnWt2xiUoLnYetaECkSRmE5FHcjbl
         p8ivxVBNZj/bynSAUFyXOwJx1/8zkrAcZ32LVrveEawShBrtAaanMS4sZHN3yDWhWQ4o
         ioTRm4nQ4r2+lXE5Sg8QeJ5jNkT9yqiS6XwUe2ERfsycgzSmW6NmLC7by6RL2LEeInBW
         cSDAIHOX3FiHz+3jZ0fCkC4cs273gzXuagfBihuiv/DhdxtZJY2rQanLjEdwsjwO05Yu
         6aQIywKznaDg1Mq5dne0s0kWVESq8gaZjeacdxFUOg7jri2b7EHtzBGNd5pMkYTKshNw
         +h6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580139; x=1743184939;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A9wfgTNVwbh5MviuCEEjiqNP7cX1EHVYoRPAjNSeYzY=;
        b=lue2VWHqI14AJjoxrpfy0ZMFg0fRlHYulMmI4XvMaj592k0of9dR2BJJLMBSFIkzMP
         oAEyH0LBt2yUZZ9YtHhFjXfFk31HiUAMhKr4Mnr/aR3YHwSP6CfiRVVU7ptw+VbuVpq+
         jnRdfyMOafyR0xyNbXDC4gAQF1e0exFwMuIQrREuvwTZvMjwmN2zCI7oyZgbS3dqJiKE
         vAoBHIdZA5z622EovuV7kjE2YFADA7Xqq4TlkCDCV0qoTfSv2udAszUe0O5hg5OgFkF4
         39fxBhBLvoHSSujPQLogHBRfL2fphlLtEsYpHDgKumRzHhTKbK1APYtq9LvQuMiY7BRZ
         UlWw==
X-Gm-Message-State: AOJu0Yy+IJZbNy3UhFEfmiDbzwyvbnbDqQbzoFRIa/VJJptwa0tNdHpg
	obCRi9ley42mjP4V2JS3xquS98dpswQqK/PRWBsqGG46wSk1uaWrm+h57UatSpM=
X-Gm-Gg: ASbGncuDnpmQgY+CeocHRenLfwTi63R/2zrPtBaR113qETj0jAE6ajaC6yFxu35xUPV
	5Wahl5I1kp4skpPQWcNU4UqBe5BCsvWfbjx0EegZWMqriNUCn6okN0E5BMSsDnShhP1O25fFMS9
	yOs/oxjWEBiSN8PCIXmClSnpWZiKil0NiNLhHvD2+IPAKL16eT2UCirx6PfNeAFHDPHHn17jBGW
	hbDOoPlBNaTgsSVbs1Q5Wn6fh200k7DJa/k2NfQ+I7UZod2i9GOVKBk25ducR+WXLQKBF/WYMGm
	rDc05IHT6ykJPbo6F3qrrS0sfMmSglTx5+0ydRPbMc2xbSlT/s0EqpigLWhD3raboq+OEJ5HsBn
	PiFgVMkLH
X-Google-Smtp-Source: AGHT+IHbW47WrFwn8bPtk5JBZarkAnDdE580JK1jViCoJJP9Ixi4V6AItwt378nhBF0j1KTuI5MAIw==
X-Received: by 2002:a05:6a21:e545:b0:1fa:9819:b064 with SMTP id adf61e73a8af0-1fe42f2cd03mr7722012637.18.1742580139449;
        Fri, 21 Mar 2025 11:02:19 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a292b1ffsm2070387a12.61.2025.03.21.11.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:02:19 -0700 (PDT)
Message-ID: <a5104aeb-6b4e-4634-9d46-9dab4e09595f@linaro.org>
Date: Fri, 21 Mar 2025 11:02:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/30] accel/tcg: fix missing includes for
 TARGET_HAS_PRECISE_SMC
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-14-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-14-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> We prepare to remove cpu.h from cpu-all.h, which will transitively
> remove it from accel/tcg/tb-internal.h, and thus from most of tcg
> compilation units.
> 
> Note: this was caught by a test regression for s390x-softmmu.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/poison.h | 1 +
>   accel/tcg/tb-maint.c  | 1 +
>   accel/tcg/user-exec.c | 1 +
>   3 files changed, 3 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

