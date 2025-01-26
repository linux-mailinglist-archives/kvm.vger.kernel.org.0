Return-Path: <kvm+bounces-36634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F15BA1CEC4
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3C573A5067
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43A517C21B;
	Sun, 26 Jan 2025 21:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RSttA6wi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D026A33B
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926339; cv=none; b=C/E3q2sJDhXRr9st2J5lxu5BF7HTtP/HCZkzYYbls4z0aiS2Bp8y2GFxMUSKiRg3vyadYl6e/EsymZTNQe1qtytwxslybERvWjxqPdwMyTiA4uXsaj4CoZdstUJoIrV8p/XdM2xWoxWlZhzuPYpdd4+NAwRC5S3ozhd816uQvLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926339; c=relaxed/simple;
	bh=XBM6SmxwtGpcvn0UGZoTw/cVsO4A6ilMYL5yQTxIPDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbkQoLIgsoJiWSCLT2A+3EB2Op4DC/fBBjyxXZVZBiYWqfWCdkZTAa9YQOxKt/OCCH/dQZtBxWieYJb1fHpH3alfbVKbZ2wKfwZL6AQWa4uDEGSUyFDeOUyCSaoe90KanGUvnq6zGe4RmESgCjb8N6etHuOjCngSl1AT3Xp8Txg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RSttA6wi; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-21619108a6bso62501385ad.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737926337; x=1738531137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+G0ryUleEoZxvXmUvLzmbIUvRMHYbb2l6B2uT5mTT0=;
        b=RSttA6wiRPc1JNXtNl05M5Fcbi4WX4tC+IPuwFalrs2K6wq0NswCGzrTk8X+YzXchu
         URLIN8oAUey1t5cqabzzvz33udYH7iUsTKmdWmDRbgk0ZRGmeBndHY81jR9s5I7GE0B4
         0M7ZFfSgP2ThSaDR0ZDZ8kk0w26wJSE8U0VlWvsWgiDuj1j0Diecw4/UwxgY0zz4+7bh
         D1MNPu6su6OzHsSEdmuIs8cd1X4PMbWfLjFErr7U5Url6shaeiMuZ66bNz605Xm4L34/
         0hnUSnZig17QOR1zo0vA171LtoAH/OUUR4iIvHR0qsnJYQu03xrgFhtg90HSOs64gEOI
         AWVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737926337; x=1738531137;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X+G0ryUleEoZxvXmUvLzmbIUvRMHYbb2l6B2uT5mTT0=;
        b=k05L0ABE0+Vqguz8e3TF6YoUcfE+DPajBOlPK72AkOYFKqMeS3bFy9nlq8AqwGnezq
         hAogoK01u5aRjfPc7pxUmD5BMYe1KpVd3sbthtCMPvPD4c3MqUjamyZ8GEiw2En8MSZs
         +g0uKAoI1OOYCJmkAIbk0z6t40RJy5mkes4Wyn8+lpnjC2O50ut/iI3Y9f7vC8PhSy5a
         SOegxEarylyBV3BHFeBjblMc49lIkGxNymDI0NeIheQ7WfD/f0SXXMK1iHhMCHTSei3n
         dBu9Ypb8HmpgwDrlsl4dl8+ZV0YpFyCwmoMi6uQ+d419HM9OUnDFCtmJgUIv217Y3mYx
         fpdg==
X-Forwarded-Encrypted: i=1; AJvYcCXF+0jRm7or91U53UC78h3M/sS2UZXuhNl7qAbipxi7N2jAWje5ZE3Lj90RhpDYLXnFPyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHu+FBT9uqWWy05lEKTulvb/RY+grm2+OTl2/0EHR3B2eEzT22
	8P1HsQYiazNFEDDmR26Cw3E9k4xbxhOYgakkU3WATD+2mZ7/F5YLiazrk5VEK0M=
X-Gm-Gg: ASbGnctUJiZ6Ac10VUMVKL1JZa0YxT7cDbeia+SxRyIHauOK0vj+2Yr8uODvbU5Gxzl
	4R5j9dsFIYSMh8df/+HCo+w5f8uqrlFUc+Z9+1ccHrrNDjGNEXLtNW3ISDh+c/XeQRWoQVGULv+
	R5+BYpAFhsYHL/Rbi/Hq5evxP6HyL5QynVc3dYS91EdK5BUO3ZRM+ClHT5YPmvrGzJEWInOe/0t
	N07DxMrHwFSOFjrwyBl8oxiU9TXh1NcLMPTW3liIVCTtW4hXTvRkDLdVqfz3aNOe7E8fW40tBp4
	uu8DcVlhgFzUZP3IkblJbzmdkAiQpF8hADc0PvwMt4CiTUhZr8CPqO4yuA==
X-Google-Smtp-Source: AGHT+IFqQ9SrCqtaqHBxnEeUe9wIIgiFAi160abwNWKtJLcX5dR1YlfbX/KbmypQ71AFHncXjFvVWg==
X-Received: by 2002:a17:902:db0e:b0:215:522d:72d6 with SMTP id d9443c01a7336-21c355bae02mr611350715ad.38.1737926336707;
        Sun, 26 Jan 2025 13:18:56 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3d9db91sm50141815ad.48.2025.01.26.13.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:18:55 -0800 (PST)
Message-ID: <39ee3338-aa9b-4cdf-a06c-ab25341d3cd2@linaro.org>
Date: Sun, 26 Jan 2025 13:18:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/20] cpus: Have cpu_class_init_props() per user / system
 emulation
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-18-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-18-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Rather than maintaining a mix of system / user code for CPU
> class properties, move system properties to cpu-system.c
> and user ones to the new cpu-user.c unit.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   cpu-target.c         | 58 --------------------------------------------
>   hw/core/cpu-system.c | 40 ++++++++++++++++++++++++++++++
>   hw/core/cpu-user.c   | 27 +++++++++++++++++++++
>   hw/core/meson.build  |  5 +++-
>   4 files changed, 71 insertions(+), 59 deletions(-)
>   create mode 100644 hw/core/cpu-user.c

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

