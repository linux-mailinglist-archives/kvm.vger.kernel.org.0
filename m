Return-Path: <kvm+bounces-51673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FC8AFB6EB
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 17:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0219217A4F1
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 15:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41BA2E264F;
	Mon,  7 Jul 2025 15:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="TWDTloO/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3DF13D53B
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751901052; cv=none; b=HKxxtYj+GiB78RYVrhh57q+CITt6xMtz6B9aITNaoWADOLYloLaxQDBhM2gKTfxbQglvp3VIibo7AxdkI/eEwoOwJf3YyWYptAUBW9JzBHQfWEM3eqs07FNzmihbxiHH5dCC1RS1IxKD/S82HqgoHUt101GTI0GftfRAXthK7vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751901052; c=relaxed/simple;
	bh=NzO+0IozOEcDQn3l700QnEk39i5XxNG9MwjqeGJpu78=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tBHx6nXqhMARrnel4oU/cZxCikvA4LJkPwyDbAYrty37cJOM27G6vtQLavSZyssd00Wp4znKOIa4+WYJ9DZSTTND+FbYt8JAzaEGn8D8GwXyCz3gwXxWHeL3AfPKllp1kh7mjPz9HiGWvCFmIQzfSu4mKa3L9lBmLLPkLNXj/0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=TWDTloO/; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-401c43671ecso1751062b6e.0
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 08:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1751901050; x=1752505850; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnKl3T+2/Gli3SYuDP6kSnPnrKRp+JeV5lf6ObCVcU4=;
        b=TWDTloO/hjrKJx6bTKQPZNVB4IG/qw76yj+FhaOjj8IvSx0KssGtegKTn46eSWR2S+
         FnlG/Ia8OAfROEkLrlSxxymHqIj5+1CyO1P0h0ffEyQede8pYlXrIyAJQNymgDg5I4N0
         Aq7JhOEFjNw9LDYuG0c7nnKX3sPPC5RGqagPvwY6ZgD5+D22RzoS+lF9/2rPwwgduIp8
         pY2pxucKzY2OkAo2YR+KloRsZ2+sWFD2CrnxI6VVLVBvVw7dK4AjfLHW3DYQ9FPVV9nX
         Tlo9IJ77M1v6akW7U9MXUlmabNkvvRr57WlvtOwwBcv4w7o1mKYN/OChsEHMddWT2muP
         G6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751901050; x=1752505850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnKl3T+2/Gli3SYuDP6kSnPnrKRp+JeV5lf6ObCVcU4=;
        b=tsn6gfC7ou2mhC+KrQrzWnB6nQts6fltfRni12OTrA7EdC/LQ7IkMx+PswacxQ3sAM
         3UIcMJWbY6UVa2y03hbjehElCQZIbSBJ3OvWvK57Dv70Nd3KWsvfC6BK4wb37U03mRXT
         MNitXO1uF8TzwF4YX7ndkFWsncpt305SO4wRk+qkHR/Jd1fxu+aYO+N9gFjKJVfWCMw5
         qyuAo0WDVvAaB8MgTZw9JLnfyXf3xAxM7ovcMV36wFfD5kKI2/eOdxGxPOuzeae92+MP
         C5KVT0lhfCPK7OlY/qfoYJLc1g4lce479Ve6u3sTgXe+k8Xa9Cz1658FENlN/KPqEMnC
         OJQQ==
X-Gm-Message-State: AOJu0YzuevIDIgds2XnhF4oC4xpk/Jv+9SHDRHiZxI0fUUt60deR1+GV
	nSKl2lYAUHY3kmM0w/f9ZUM0NMikin1d3M32i8GUiDCKGjdPfOs08qQQ/Cu8ZRPowfQi2dX+pQk
	3PMAvgi+SsCEhazR6BJTENIqCrazQAU7m/TvG8Kd3Ig==
X-Gm-Gg: ASbGnculVwIb7C8XoJw0dX1xe5+Gy8195IrJMZOODi4xEjmD1fpOb1bk/dSIY+RW28R
	+zC7zIklZZTqyw14WNIgnVOE9/Y31+oLwegWwZcOWpSdz60GyY6UNrr2FyNjQKQcK13/LX3Glgs
	kGGiCPVHoO+LhB7qu7ZcJQd4HafnC+BSzq8NtZ4Nb1KhkT
X-Google-Smtp-Source: AGHT+IG+z1QRmX52XgvUvuibShCH4JxPGne+61lfX2+6MXnE61ffxBITvW1KTHFtHy3R5JyQX8kD9a85pxlYxun9pQI=
X-Received: by 2002:a05:6808:4fc7:b0:407:9a0a:3f54 with SMTP id
 5614622812f47-40d02a5655cmr8571934b6e.14.1751901049892; Mon, 07 Jul 2025
 08:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250704151254.100351-4-andrew.jones@linux.dev> <20250704151254.100351-5-andrew.jones@linux.dev>
In-Reply-To: <20250704151254.100351-5-andrew.jones@linux.dev>
From: Jesse Taube <jesse@rivosinc.com>
Date: Mon, 7 Jul 2025 08:10:39 -0700
X-Gm-Features: Ac12FXxjT-qZ8EUAqkDvvy6G3RYe4XxmKy5JhKeSLnukbAx50LvwhUxZI1axAGE
Message-ID: <CALSpo=ZU9Eb0E0cq1Um1t3bmbAt05K0q6e_PLpWAn0Oibd6hLQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm/arm64: Ensure proper host arch
 with kvmtool
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	alexandru.elisei@arm.com, cleger@rivosinc.com, jamestiotio@gmail.com, 
	Atish Patra <atishp@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 4, 2025 at 8:13=E2=80=AFAM Andrew Jones <andrew.jones@linux.dev=
> wrote:
>
> When running on non-arm (e.g. an x86 machine) if the framework is
> configured to use kvmtool then, unlike with QEMU, it can't work.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Jesse Taube <jesse@rivosinc.com>

> ---
>  arm/run | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arm/run b/arm/run
> index 9ee795ae424c..858333fce465 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -97,6 +97,11 @@ function arch_run_kvmtool()
>  {
>         local command
>
> +       if [ "$HOST" !=3D "arm" ] && [ "$HOST" !=3D "aarch64" ]; then
> +               echo "kvmtool requires KVM but the host ('$HOST') is not =
arm" >&2
> +               exit 2
> +       fi
> +
>         kvmtool=3D$(search_kvmtool_binary) ||
>                 exit $?
>
> --
> 2.49.0
>

