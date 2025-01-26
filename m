Return-Path: <kvm+bounces-36632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A78A1CEBC
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 22:14:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1165166A35
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:14:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36050172767;
	Sun, 26 Jan 2025 21:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EEvVMdiG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E156525A62A
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737926087; cv=none; b=ljI5Wzol4B+o3tEFBCc3SMCMK9Kw/qoQ/vcwzA7vvFwuTwB+5k0z18yaUci9nwVAR1iXRRvSEG3g2hhWNq8JAWGN4S5ignNOpWsZzqeBeW2MVcBVMZJPvAq3yoDmDnlHTr9Ep4TU+uWeQ+NJnJI+3bUJ1sQG8aDapp9fymgvM6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737926087; c=relaxed/simple;
	bh=jcpeGlFlAaU4EmfYRC/AK8Tkd/oE1LPuaW9Y9MOjy9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJoYEi1U1uCxIjsLskXha45+ocus5nYaQhxAmWDPc8fHAnCEaK7KqQN3xht2KQ6xaXfJ8+LCi6fzBfD52XtszKmKS36CfXAhVrFmPTGmJtvRdUXMPGU2uMAVJ8CNbHEqGHpHw2Og+fTpx/hMATcIAJ2P2RQBm4mjdfmbjz9TLPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EEvVMdiG; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ee989553c1so6504530a91.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 13:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737926085; x=1738530885; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dM482TolBOr/dYb2pXuY2SYJtabVGHzvURXSW1TjI40=;
        b=EEvVMdiGI4y2dfNJUDqlt0Ny+n5JkhGmoEQFLeGZzKo6DWBbZZdFvd55o9Fw9szUKi
         mc7BgsPciPnx4VifF66I8e6Bi1w3aZTVAEZ2/ayhy3AlbBcYZ41fvacppIAO/txYyqSx
         pX2kS4WE24QhB1pou1SOxDeBMTZOH6/REvuscXd8MgmOHckPJ+Vz03qZwzNtjJGG8sSU
         mNb/djWSKmdsNMiV5EGRsJ6CjBb31FNjskSrGhMHTakcMvWMb4ThAvqkrZm9/xKvWRVh
         qRxWmkEJvo/fdJhKzA1MduxApTAc6MN+vfIJq9rMGMFv/dLdnmUOg5dQ7OZ5jElZq/Jg
         vVCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737926085; x=1738530885;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dM482TolBOr/dYb2pXuY2SYJtabVGHzvURXSW1TjI40=;
        b=gyJlmgWGCIa7ihPLvOvp3O2XLb1cFH+n5Gj2dKfuOajMhhPZ4yr9HZpjzMH+1Ra/rO
         Pi/rtw61LapFtGI3DqYNsmwLLodMQsxx51rWKZo78mIgoDzasrbvwSXMkvsLpPqLhw/8
         NWNPkB0gketQT5wc5cRCTOcAdvZ8Vvc57J8lTZ5ZHv19VIABEFLf7LSiJ4SqwByOPdev
         zNO0ANEu0T0FnC++zYu4QtPTniU8zupwGAzys68P76uiX8Bdcy+wOIjWRQvlit1W2mNZ
         mVJ9sm+GoGhN0jxZ4qoZDsyBSV/CwGNnaAS+spOO+fTWTSYqQc5POY+Oen68QRtO+HV2
         hBYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+A7wXMYx1ZWDSHuIOM6b0xwbKWbpDKO/4gj/PeR+VS9TPH8HgjsIC1+CwGTFMt89jcbQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXwJ0YLKMirk6Nq0b9kZF4mmr+4nOTky9i597wBkdbJHPkYROc
	sodPpaxYSCTD2KzcQTxdgBph82RtJLkj7eJB4GG64ARfeDOaZSd5y9sF0vfcdGQ=
X-Gm-Gg: ASbGncuht3szn18KXTys2IAVBDuuv6Z3ki2ATGeWTaDanwrofjKztjSD803t/LKb2aG
	xj6qifv/wB79p2b9OLv8xSrXbveHlY+LNLhjUpXMacCq+Nk4nlulEyMnaEWFdKnl3nPnd9lrkLU
	LrlhRVG7cMhP3gz4BOqZiGgF6ukvD2JjWT7nf0hch84JTrXzF2+bD3ntaVsWJVg3y+luutq4I6j
	QUHX8CrM3as5nak9rHEGFQ6NnV0CZnhcZI0DwQF8K+ghVjq7A4HxX7V+tck5PogMiu+6oVPDkZt
	O1rFz9nzKf2FW4JNS7Q3azDQRi/YrNDeOQE41OvRBj7C7dk=
X-Google-Smtp-Source: AGHT+IE1AaZn04VsAmZoovvHskfFwwHs+/I0v2XJVpXr12XD+Jd8EH5sfL0xlHcxmhZL8x5QsccIOQ==
X-Received: by 2002:a17:90b:2f50:b0:2ee:fdf3:38ea with SMTP id 98e67ed59e1d1-2f782d32c45mr47771107a91.23.1737926085217;
        Sun, 26 Jan 2025 13:14:45 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffb193e1sm5644337a91.42.2025.01.26.13.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 13:14:44 -0800 (PST)
Message-ID: <f7c1590d-5c61-4408-92c9-7241aed2c6be@linaro.org>
Date: Sun, 26 Jan 2025 13:14:43 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/20] cpus: Fix style in cpu-target.c
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-16-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-16-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Fix style on code we are going to modify.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   cpu-target.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/cpu-target.c b/cpu-target.c
> index 6d8b7825746..a2999e7c3c0 100644
> --- a/cpu-target.c
> +++ b/cpu-target.c
> @@ -47,12 +47,15 @@ static int cpu_common_post_load(void *opaque, int version_id)
>   {
>       CPUState *cpu = opaque;
>   
> -    /* 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
> -       version_id is increased. */
> +    /*
> +     * 0x01 was CPU_INTERRUPT_EXIT. This line can be removed when the
> +     * version_id is increased.
> +     */
>       cpu->interrupt_request &= ~0x01;
>       tlb_flush(cpu);
>   
> -    /* loadvm has just updated the content of RAM, bypassing the
> +    /*
> +     * loadvm has just updated the content of RAM, bypassing the
>        * usual mechanisms that ensure we flush TBs for writes to
>        * memory we've translated code from. So we must flush all TBs,
>        * which will now be stale.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

