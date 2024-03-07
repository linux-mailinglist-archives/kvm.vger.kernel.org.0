Return-Path: <kvm+bounces-11249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CA5874627
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 531D3B203B7
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AB563D0;
	Thu,  7 Mar 2024 02:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YQ8kCEYk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEB310FD
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 02:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709779159; cv=none; b=TmH8fkrfuBDe7jLq60nwW8BOPh61F4V/ITDBaLs1GJqz+TfzlK4TnMYLijLvQnGsNLtPwygEaKgCP7rg38iOnafNzXDhYp+NHMfuwSIcc4FpyWH298wq1bMGqbGJVLBUnqDzASh5rv1J1aM+VGOdS3HreKUnpo4iUYVOD9LEYow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709779159; c=relaxed/simple;
	bh=ZoPyxcOT0+8ZByT6br7pG2XGpoOYWHZWzr4sILHr5a8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhfXCWEH4OWRQ/HdMmYLipXHgO2nzWeO5r5Qjtqj6xCYntSCaVvGaT8vzG5h7mSLYQxtG9feBXn4XOLnLwPCPoU1Mpogzk0Xs9U4oMfuqQotgYExmx7i+89tSAwkcwke/u6vnMaYv3BehCCBNQpUZe5V/u+g/tly9+Hs88EYA/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YQ8kCEYk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709779156;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pXsc1bKFWtbHuFyWBXyzFWmEgl+KeYAh4ptHDJM4aFc=;
	b=YQ8kCEYk+j1c4A2diExAgIXcgSjMJFTlmlXs5jPJCrBRLEVsdqQxsH+6Td3/zmg0wMn+Bu
	4/c7ZQmHgB/biFGrqEKkrqrflI25wjXUyosIlERuVsngKDJmubMorssp7qNvfMQOHZFxij
	bdBd4HqMdi6dLhGZzTzgwHgMGM4wypk=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-YiByRfPlM0q2qI6NtnIqjw-1; Wed, 06 Mar 2024 21:39:15 -0500
X-MC-Unique: YiByRfPlM0q2qI6NtnIqjw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5cf8663f2d6so115212a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 18:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709779154; x=1710383954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXsc1bKFWtbHuFyWBXyzFWmEgl+KeYAh4ptHDJM4aFc=;
        b=Joroe2UHroHKWp14y/hiPSBpWdCoxWRJPhG8A4L60dLo9TS5P7PKz7uZ0kRcSwOTFu
         FCPfLSqjkgqOv12wJpPvxL8/7dttSH8rfkO1qAJKpxNNQ6HhHC1Lx9WZ2aNEZ19NYUd8
         QNnPrlyQARsEkkLV/4MZ33Ihh3xwZl6nLZ6WrdkjRPgctzAbweoJU4YQOmeUuwM4UsHB
         3JeRGGZWFhiwMsuvOepu8O2ogXCM19gr9qvttTSfol6HL0X+1QqYc7fVOBlQV+SvGVIE
         ozbmlbgpnfGrFvl7ioIV3jFl+TgUD2mmt406EsmZWJAwNvOVKTALDNbDLphg/2vpIW4b
         pATw==
X-Forwarded-Encrypted: i=1; AJvYcCWDzXmtc+d0TASnCeLEoC3aZhAyzW7p+jlHhH6xGkgAUXv5NTeGo7zOMs3BrPX8DCl+Feo25n/OX8ErmoVyNzLcH180
X-Gm-Message-State: AOJu0YyoSTQGQ0gkObXpAiiFUeO0hoK7Dg7GcE9QQmp/mMVbtyLS479q
	5YKl71XbS6rqo425pAimTdqPpZ9Vavc9PsPZR7D6A8aXgl5YCmFleKdVwc6hZ4AJSvhtAudMZX9
	3FoYP2gjZxhTZl9fMHE/NA/shwGCtMbijaW9rF9qdwniLtUkJ6w==
X-Received: by 2002:a05:6a00:1888:b0:6e6:4578:e309 with SMTP id x8-20020a056a00188800b006e64578e309mr1028142pfh.0.1709779153861;
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiF6tBcOzSAvvkZL2vc2u/gS+WpXHPhEPgJibtc0/SwQQV2GfVWmNSjpQIAS5yzJgyN5a3VQ==
X-Received: by 2002:a05:6a00:1888:b0:6e6:4578:e309 with SMTP id x8-20020a056a00188800b006e64578e309mr1028126pfh.0.1709779153532;
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p8-20020a63e648000000b005d68962e1a7sm11750397pgj.24.2024.03.06.18.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 18:39:13 -0800 (PST)
Message-ID: <c678ec42-b6a6-4ec5-b7e4-f5e5bc9542e0@redhat.com>
Date: Thu, 7 Mar 2024 10:39:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 02/18] runtime: Add yet another 'no
 kernel' error message
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, nikos.nikoleris@arm.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240305164623.379149-20-andrew.jones@linux.dev>
 <20240305164623.379149-22-andrew.jones@linux.dev>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20240305164623.379149-22-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/6/24 00:46, Andrew Jones wrote:
> When booting an Arm machine with the -bios command line option we
> get yet another error message from QEMU when using _NO_FILE_4Uhere_
> to probe command line support. Add it to the check in
> premature_failure()
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   scripts/runtime.bash | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index f2e43bb1ed60..255e756f2cb2 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -18,7 +18,7 @@ premature_failure()
>       local log="$(eval "$(get_cmdline _NO_FILE_4Uhere_)" 2>&1)"
>   
>       echo "$log" | grep "_NO_FILE_4Uhere_" |
> -        grep -q -e "could not \(load\|open\) kernel" -e "error loading" &&
> +        grep -q -e "could not \(load\|open\) kernel" -e "error loading" -e "failed to load" &&
>           return 1
>   
>       RUNTIME_log_stderr <<< "$log"

-- 
Shaoqin


