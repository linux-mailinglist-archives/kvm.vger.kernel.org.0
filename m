Return-Path: <kvm+bounces-46322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C12FEAB5112
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:09:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65DB84A5411
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:06:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB94B245032;
	Tue, 13 May 2025 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RDTyUCri"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65735242923
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130658; cv=none; b=Ma21Ha0POUipyb2bffzuc0ChYqT8xSIQRiBwpr7ljX8RB+rutdG2c8xBaSRYEqGxfkKakMKhd5FH9u2OgZZ1l2OGZ/A9DDjsCkVIm6BzgkXSy7ACKPyTHTUQDhwv3Z8t11ytpODi332z6mRpdyWR1QXIZ5zIn3hw8eKy38i0NB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130658; c=relaxed/simple;
	bh=lDcuXEGvaws1CFoeWM+QTEXptbBwoTQRJV2jAHrvMmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ul+Rv3ck9lKNPwO9483xsbY28tXHw/aICCxNNJKXM8ayjjdNqiSHM1d6tVGhyT1fdbWM6YXJzCTKTHj+SnqU6bYzAbj3I/4sumQFl55qXnzezKYyeFvPy4GPVJGMzIDDfMfGqOAtHNck7VGgLJ6XXSN5ROgLG5XwMLY7uP2SE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RDTyUCri; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so56068415e9.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130655; x=1747735455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O26A2fBk0skF5B7osCNfgV1APu4SFdINbgcxdHAht7g=;
        b=RDTyUCriHblh0ql3AXFO4d9W601ZJH3h5xGmJ4Lzcgqk9LVLe9MzvmicI736dbStc1
         WmgLrHsN0RqmAbFevFAaA8CeqkDyAmOYq0qGpV/ovCQlylrTrqxb/xLo09RT/65H/t3B
         Kb88uaUAFfhZ5ULwUTd0T9QEoW4qPTU14HNKyjpSLRUeBtwLXQP76SJaP94cTJH2at0Q
         wS9iFdqmgRlDEOf6ZDJjrDXY3cj5uQ5bzP3oYTM4Vl5UK/AMS37+olVL+YwLrGEM+rtX
         RvkOLbgGbI3qFEa0K5eqCPgkqqxsB41SEZjewSgW7F1X7+6/VT0q9CMzcqhomXa99LcS
         NFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130655; x=1747735455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O26A2fBk0skF5B7osCNfgV1APu4SFdINbgcxdHAht7g=;
        b=wZDjRvsGLUUV0EAPJkKh0AVeIK6rUEfy1vCQhyMJw8rZZiiMdHeGGj85BntUuUGOZZ
         dMWRlgtb6lQqOEEsjy0PdsV3vdM5RQUfKmRuxgxtpgyzVM2HEiejD41am3lMUB/nAnkr
         Nr6nF72asZGHW8Gl3k9RlT4c5ewoPpcWK1U2HTbVjpOXFX4XMv6dHN407TEdRmP34wPW
         BYFdvlLGNHaJMn3vsHSpBlaVjbq8k++TnPE/4CImGEBxnbg29r6Y7bX3QEyrrCgph9CO
         OxIC2pSxiO/GjrGq+qkTBzsZP3NLzLWHxfaq0DoTpkn9m+FCCc8c/sQr3y3bKXTKo0Hi
         Z8Dg==
X-Gm-Message-State: AOJu0YxIgNs5LHEKr++dXVLj6APTY1GN5rPpjmDjsHyR1gPm2pOM+Ty2
	GXSTgPUuU8x9YJLQIZ1N3nhrEfq/OC/i+F1ceewy2dH9a8T4Z7s0A7WX9GhwTyuVeX8srxb1b19
	okc9ieWfX
X-Gm-Gg: ASbGncuZm9hpO4ttAs0nvIyXI8eIAowA78FHVc3DSh5tkOxBiTFS0FQHnBIWQ5JVJeZ
	LAD2Db+c0CGM2QAO01phnCtkY9r9rK9dHwhIO2G6RJJgYAAp3Z1QR0mhkKhxxLcz2cFqRLFfecE
	7qsPDY3x1i8jHAdKUVxvkWL6CFsF1Pc3r3y2Z5ErCxHnW9+NBm8lsyxZgjd6oK/aPDZsDEBvVqm
	tXVzfbOelfd7E0qfZBIxBZu6HExHpFSu31fgUzTdyIAHk/w2ugYHWe/VmKN0L5LZ4JhnFnKOMrC
	UazcTgIogsItQXdtf6NOX7zoRQEpYWRNwdgK/ZW6ptSh1ubRMGUrceZ0aaJInv9z7geQJGkJfTd
	jEFLRZH5YCawLC9UsSA==
X-Google-Smtp-Source: AGHT+IEHDHtezTiJB5tUD8EfZ22mA3DyFbXAC/zzCzkc+WrSz4sdpni0P2osv+urenM/NTyI6Pgh9w==
X-Received: by 2002:a05:600c:c10:b0:43d:aed:f7d0 with SMTP id 5b1f17b1804b1-442d6dd23a6mr103613275e9.28.1747130654605;
        Tue, 13 May 2025 03:04:14 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58ebd6asm15839928f8f.35.2025.05.13.03.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:04:14 -0700 (PDT)
Message-ID: <7ab5b60a-a696-4133-97e9-ee37aed218f8@linaro.org>
Date: Tue, 13 May 2025 11:04:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 14/48] target/arm/helper: use vaddr instead of
 target_ulong for probe_access
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h        | 2 +-
>   target/arm/tcg/op_helper.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


