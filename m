Return-Path: <kvm+bounces-45447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F53AA9BD8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7E61165666
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:45:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D89CA1AF0BC;
	Mon,  5 May 2025 18:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qo7DATZN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C273360
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470753; cv=none; b=VEnohJzKeWtFd6venBP0ilNowIaHYgn88EnstRLRhv8PvX2sb3IVkXpOTk2jwinMOcBdh5jmVfPiJmO9TNwh3S/n4Kw4xAd3rf9b9Gg+4an3ssyxEv36mxrDHxFcv05cG6i/3kpQFQDnhnxeNi8C28uwzPTyvMD9KL2d3dw49W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470753; c=relaxed/simple;
	bh=LJDyv/NyG2qWFz65zNCweqX039N/S/75rtBdjT3ugiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NP2aONS4DTADHFo6GI9B8qZyUAuIArWMnyC8zP+8Z+LlQ0lHL+RhEuwdaQSz0XfFeUugIXFLOlG3xGwA81x6RLaLNcS/fmsoWEOWz3/sv5qAETmyrlT4o6Y/5sQLjIYkPrvGVDF/0F0exVNHhPgLKiyTxM5chvuVVlU22tfgOAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qo7DATZN; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-736c3e7b390so5577806b3a.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470751; x=1747075551; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aWTftBhQdOlFYtj6OF8kiijXsH+rAoychvoACwsGJw4=;
        b=qo7DATZNV3uCFSKU6/5Z2k2m8BzGuBQUamOC8IfqTxVGfuIUPoMsDnJAOesg/m6pLA
         N5K8DUlIvjhzaB+OXNXmteDQWGN25umCc+s0MtQoPLnuIjLLD87W7DvkmqhSBhN63YzG
         W3PWiO0duyD7ZELjSAhdqQtHJKI+9Zi9Xi0OBYIgPIg7lvzwLiI7gsNFKErUu8//+4jP
         54ZZHSOm8JVwdgJdc1uUdGiS0IGUGjqOeLRc8JvsO4PX8JgoAa3Zvd4/muNB+GPGJvcv
         QWCpTozvNxHvPyaIK6WMx0uuJcMB/JmtFJqtXc1rcQJM9FgdwZvdnjBDVFfWW5Jdsnu7
         L8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470751; x=1747075551;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aWTftBhQdOlFYtj6OF8kiijXsH+rAoychvoACwsGJw4=;
        b=OxZZPYSQofZXC6kWhPGNizcyWVdIlA2bo0jEPBzAzGyy7WSe5zErRYpKwyd11TSaHa
         kLsNmJ+m0pBuGibHM1kFJf0APNR15y9VbcMyr4f823PCDnM8IdaLbhkD94Xo19vP1fdg
         Ln1yIA3XbXCCoLvI380wNIX61S441haXW08HsegR7VvQo8DJKzn/Dr0WLeTfwe9Lmuhy
         gLDkcRlbGXg4zG+qXLC/c74qf9Od3wrf93DJy7cZtodvP8UTADzZLSbQvXMg/FEc7BK0
         ZoNRyvwfmxG0BID+6RB8ptx/Glwpyzw+Ke6f8hey8oj444gG7SSAG3XBL/O70EUMZAVw
         ZmFg==
X-Forwarded-Encrypted: i=1; AJvYcCVNfc+wS9fsISVsWujpBF01zptfKrYpS7mIOsZESaffoXogdolnq5UF5cdFe4LmOpWFy3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjBCtoRKPvnisxncQ9IPsnEJj8wTCOlddvhR8a/I3gIqBVQxjB
	4zVakjhUxBECjyY6VMWsSqNfFZVnkHk8A/A9zkNlEBUMf8jV74vZ9J5wGM81Djc=
X-Gm-Gg: ASbGnctABfUY56oy3Mn6kaYo+MsDYffOwd8nG4MI1b9/dFtKb1fhN9KVtFaAFJbRvL9
	6Q2UERBNa9fPkIyW3j4YC8hgY8rxlirvS9Y4kJk4tggWDkYyp2N1FGT4LqaM60ogFFV7V0mqngJ
	HlWizrel1g2tuk6hOS9PcC74rZP4+1snlPdhGjGXaMkYE0wnctjh1fBtjGCQCni8wusn+QFE873
	d9zO4pbIKcmDFnVPYmldcZJb/QrLGiKKh0HdaQ7MCHP8tQ0dQmTpSOLv4ft9Oe4LeytpvbX/GP7
	O1eLWHduubg2uFk7pgWHIzzjqlG2eNmGfAXpOEKqOxQEjBJlxnnsjT0+sUnFO4nWmf3DyJJCOcP
	5MscyfGE=
X-Google-Smtp-Source: AGHT+IFBOsH5CpfTxma1JoQvpcL77zl4kO0LTsZyBNW1tuAbC5hqFDV3tzQd3HoxiOwVaQVcEYEh3A==
X-Received: by 2002:a05:6a20:1589:b0:1f5:6c94:2cc1 with SMTP id adf61e73a8af0-20e96ae6ab0mr12225551637.21.1746470750828;
        Mon, 05 May 2025 11:45:50 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020faesm7445748b3a.95.2025.05.05.11.45.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:45:50 -0700 (PDT)
Message-ID: <fa968652-f8ad-48a7-a320-c38c01a6bcc2@linaro.org>
Date: Mon, 5 May 2025 11:45:48 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 45/48] target/arm/tcg/tlb_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-46-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-46-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/tlb_helper.c | 3 ++-
>   target/arm/tcg/meson.build  | 3 ++-
>   2 files changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


