Return-Path: <kvm+bounces-44972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B98AA5428
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:51:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB7A23B9255
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC3C2266F16;
	Wed, 30 Apr 2025 18:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HlrUZpvV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9484524A047
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746039084; cv=none; b=RbNS8JZ+dtZLrkVDSKzf919XlObdN8CiDLVvIYXEs842ShVy8PUOBGX4vY+84hW2W18phVYroo82aCkfuRtv2eUV0oJLMis9TH/sZosEnDJI1ulr5CiWH0Mn8gsvD6gNmGT+oN/TrtbMFXJ/btTok2MVTcQpo1ylLP03NNInw8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746039084; c=relaxed/simple;
	bh=jPtAYX5rPdlFFzlBhLr65GyIA8O5AciW/zmkCd4kIN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkmqiVtcpDDhAIdrANRtODTXv73zvoNK15odsaTiHOzWesGIXp7MBXlocu3Q4G5hP/a3rQ60Xy4qcv2nCZnTEyllqVKFRU8ubdvM20OBredmAVG1zsgs/mR03mPwLz5GJlPgMq32GY3p5Dm2ZBsWGdoOV/QRyHn49vH4qMXdZQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HlrUZpvV; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-227d6b530d8so2163105ad.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746039081; x=1746643881; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hxOJ9FBHYIfa8vp94TfzK7vL4Nw0T38BsxJdpM9mzsA=;
        b=HlrUZpvVi1nQ2Vd5QiKBpuoMjNqFgNMQ2Fl8AIYnwfBdh7ggrr98qhGC72PxjGAPw2
         QVUZRyGaYitqe5xSut/IcSIwB6HkmXtjj04kiCrfRs3tAB7XyHFI4FMpT7GngBmxJ5Bw
         U53b/qYJvGz+KtoTC4uoBCNBIBtPZzenVYY+MTGTN8UU3DIxaJqF4I7UopIbIwzCtcGb
         JL3lH2K4DUVMIc0RhBmVpryxDiphf+3/LYU/IJ4LKPbW/FeYpx7NaDIZlWcE7O9rzaFY
         Lcp/xV1ybL9yh4DXwArQyLVyxcXOaXwJUXmYNyo9vqUVH1QhLGRWUqZarbLBmkbfjdO/
         927g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746039081; x=1746643881;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hxOJ9FBHYIfa8vp94TfzK7vL4Nw0T38BsxJdpM9mzsA=;
        b=POu6ry987UC/1jQWkN4XBSs67sD28yXxXXrXoLllxoMqCVzzWR66cm0NvrMQecmted
         cNBBNH7O7sd5167MV67iaAHsufYWdrEMce3KWAUEUzPtNr+PRexoIk/LODr1ItmAG7MM
         BbSxwrC9MKywnekIDafwGpe1radKkhvmvlBPgDYb8RcvqqyZtw5iNLvM8q2MggB/pKhn
         N4dNbf9AftE2pMCpOLwpgRsF+dq/32FzcdqXuJtq7xr6kpX8uCewz4puJxKacLb5pwMu
         /xZIvqz0BcnDg5bBHjwMYjaJ/qTVdjT/J9KZ7Kcc9YD+hbI/kgpJn2qJy3yxnSfKYj1j
         4hAg==
X-Forwarded-Encrypted: i=1; AJvYcCU4rFpk9dNRMpJldbduhi5BTj9/zgVa/CSuTAqbVXVDYmnPlcqJjMY8Prfx5JL7xLhVsdY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW2pzGwTjZlOZPuE81oQu5xKSwotkRljxX5PnhET38RgmCv2WP
	8dFPtFHoiySq/DTKcuy8wnD94uMZqhcZXnVAk/PSCe7C90o23EAQAf1fkGmpxWk=
X-Gm-Gg: ASbGncujg6lu7N82CBYzOg/mYhhgXjiPYXxjpRVpU738w3R6wbMcc5BUksu2lHddkyy
	WzLGqdrAW9myJzqeasaMMNbOZj/TVBbjbvDNTJgAszy1rZi2UPkLZTPTxNOpwFWOwYTCp7kTvqJ
	awpNiyB4EWStcvE7mGz5dx39j8WNVCx3xDse0w3o6dK3rInKgOF/Iz0BZPtl52D+zDHfRWRkj+g
	nlBPOo/MEBN2FZkLk1D5R6uStdMl2nYzPm0l907Nc0Fs0Szdgy/1rp1C9VycUo+5v1ZrfJBshjA
	V74pFEZWHhkOIBHuxhvO8+PPUSJ0627ts+7brSr3l4bkwyiA2jolv+vNopg4yuTppPARj5jgE6q
	4qYdbpQUWr03ouQqIXw==
X-Google-Smtp-Source: AGHT+IEzWhuZd+fIFVzMg6dFdi+Ij1B5/pyHqYfzImCAOcoYiW7nODxF971GqI2yyzrn7iFeWN/CkQ==
X-Received: by 2002:a17:903:1a6f:b0:223:517c:bfa1 with SMTP id d9443c01a7336-22df3590ef6mr73173675ad.38.1746039080897;
        Wed, 30 Apr 2025 11:51:20 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db52214fdsm125468425ad.251.2025.04.30.11.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:51:20 -0700 (PDT)
Message-ID: <344ca5a0-acaf-4934-841c-481aafb03052@linaro.org>
Date: Wed, 30 Apr 2025 11:51:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] target/arm/cpu32-stubs.c: compile file twice
 (user, system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-13-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> It could be squashed with commit introducing it, but I would prefer to
> introduce target/arm/cpu.c first.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

