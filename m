Return-Path: <kvm+bounces-63587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A8EC6B4D1
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 19:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6E81835C164
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9E562DC323;
	Tue, 18 Nov 2025 18:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iM96ixMF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774922773EC
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763492010; cv=none; b=sTGun4NsMYq9gBamTEMSVuYwOXhD8q5EmLzdy+hb0VXB6HYipePhkipdRzRXkILzSYMyDmKReJ/quYg0NArMaNQBGYkthlHeTsFSrXJflZ7XcQh8m4nkykEenlVJha7qKlqDKl7rmspDuHPt8WkWYbs2k4oQTW22tIDGRQWsy54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763492010; c=relaxed/simple;
	bh=UItmGhUaQ55ZwKA03ZJgnZgKPXfjMN+emOntxAadXTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLGnKlda94BGpZdr4MjfouxEzMePchWL9edQ33CNXaZE/jUsNj/lVio2i/g21VEy+3XMDe5l6xd9DCQ1kzr3T5wY8LkV3FtcFpWgpJiDsKyOZT4WFUuFeSkuzHSmyouE5OG+ExsMO9h4ewg1Qicn/q9mkG0TiQRtDC5dqejfFXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iM96ixMF; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-4332381ba9bso41692745ab.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 10:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1763492007; x=1764096807; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8GLwJmWvrt4bcGSSoXGY/Vb9/ivbKv9lxIJWO+fpSjI=;
        b=iM96ixMFCzwxBBN6uN8uryVzVWrBb3wTGNBpMcJN3F2ZbUfjmy2LQQ6TY/bQCQ4mP+
         TEOEPboEjnb9cq8oHuKy4S2BtO3zA5E67e/J6a+/W4RTZa0IvYIIwPPoTYpNiEaLq7GZ
         HYv2XrVBYZFxMvZMpY6s317J+57h5zuJVrd6PpZ75TZqvpwcWfYoWwP6YNrarXyRcHtn
         xEioVtuRyC79rc9xr5GcoCA3dRoGEfwO4xkJB6AE/PDNwJsvKlappKpbi6DYWbOngAqg
         lBNXKjDRC4FU0UBEBojZ2wq9dHl5l6A01CDYtV/ga6RHaQWbgIiIzSOv6mhHplIeGQ6u
         pC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763492007; x=1764096807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8GLwJmWvrt4bcGSSoXGY/Vb9/ivbKv9lxIJWO+fpSjI=;
        b=vzZy+VByDW6sYMaLlbEtY83l20CzZTnOVUCuwtbdAb8scsAH/r0bfBpnOmOT1dOUNg
         C/qLj8VsMP53u8JSpdIC8t4IjFbUcKvLLuIRi3PzShW5hNNS6IajMy6syMGrcqFaQRg7
         C4YdeTgjBqVNl8Qn2MlkMAGPEicsUuehATbcTwBS6wy4g0HIfSkTcGYs9h5TwlNjS/4J
         6QX5WrBkqiTF24ersGLkX6Jucv5vwxF+kEDP22fGqsPHArWu4C18vQwugxTsCtWM9Kjn
         FGMYncgd2/xxCHrv0J3H3rRHMeojpv/XaSaodz8ikDmIdk6nE8s6jQfkCPVDdktUGHtS
         DiLg==
X-Gm-Message-State: AOJu0YyaHDgbSvQBFPpPGpt61HE7JNGiLYGaxPUsGK+e29jP8BlqrtaP
	TvtrDPhb2Js5KPT1xTjTusYaZsjUVcUuLWaYzmC7sTCaS751itFk7R+zhZqe/Zj8f8M=
X-Gm-Gg: ASbGncsrO2bDVzZ4UoKPZFZIjGnV9H84rGM+nH/ijxXcC2JhD2sAg3IqKELdKxuYbrL
	IYUgZPoe/o6xmFMrRLIBpSCFWENjHqbIy21J/S4jJWwsRmAWlihygJNmv9RGgJNxkn5aQhXcCpa
	r6WysjYLZkqyg5DnoMMes/q3BIZFernOtLml03WZt26qULcuK5Z0PIjOXhRdDZhBpHZJUcpQogT
	ttpTJIzOwtacsmOqOcu6fGqXUbCL1ydXQDRVA0AAz5UaE77Iharwq1USL8nePCyD1Zws6akLumx
	02YRSBRpHuZ/lalj/RDaekj8v1uHmRtvnT2zlt8m9TSilBSrvybyYCuBGe83KKnnVdwXqr4KZZL
	g7oBM2plllBWYaYiEwOnvdgGeTrPYakIE9sfLSuKO/A7Pw89VIJ3KZ6P0NHq6f14yC+4JLmubHh
	8TFhvNDeBYJXA/mvkquYJQE+A=
X-Google-Smtp-Source: AGHT+IEWlFg/itUVM5Nvd3f/pHC8HhckQFg8kaLgzbRmqMQqRO364KskAjZI0HfwYtXDT/vzSXxBRg==
X-Received: by 2002:a05:6e02:33a0:b0:433:3487:ea1d with SMTP id e9e14a558f8ab-4348c86dbfbmr229227265ab.7.1763492007516;
        Tue, 18 Nov 2025 10:53:27 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-948d2b4265esm763154339f.4.2025.11.18.10.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 10:53:26 -0800 (PST)
Date: Tue, 18 Nov 2025 12:53:26 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, yosryahmed@google.com, andrew.jones@linux.dev, 
	thuth@redhat.com, pbonzini@redhat.com, seanjc@google.com
Subject: Re: [kvm-unit-tests PATCH V2] scripts/runtime.bash: Fix TIMEOUT env
 var override
Message-ID: <20251118-b33d4fb548706933d73d4c49@orel>
References: <20251118173401.2079382-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118173401.2079382-1-chengkev@google.com>

On Tue, Nov 18, 2025 at 05:34:01PM +0000, Kevin Cheng wrote:
> According to unittests.txt timeout deinition, the TIMEOUT environment
> variable should override the optional timeout specified in
> unittests.cfg. Fix this by defaulting the timeout in run() to the
> TIMEOUT env var, followed by the timeout in unittests.cfg, and lastly by
> the previously defined default of 90s.
> 
> Fixes: fd149358c491 ("run scripts: add timeout support")
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  scripts/runtime.bash | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 6805e97f90c8f..0704a390bfe1e 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -1,6 +1,5 @@
>  : "${RUNTIME_arch_run?}"
>  : "${MAX_SMP:=$(getconf _NPROCESSORS_ONLN)}"
> -: "${TIMEOUT:=90s}"
> 
>  PASS() { echo -ne "\e[32mPASS\e[0m"; }
>  SKIP() { echo -ne "\e[33mSKIP\e[0m"; }
> @@ -82,7 +81,7 @@ function run()
>      local machine="$8"
>      local check="${CHECK:-$9}"
>      local accel="${10}"
> -    local timeout="${11:-$TIMEOUT}" # unittests.cfg overrides the default
> +    local timeout="${TIMEOUT:-${11:-90s}}" # TIMEOUT env var overrides unittests.cfg
>      local disabled_if="${12}"
> 
>      if [ "${CONFIG_EFI}" == "y" ]; then
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

Merged.

Thanks,
drew

