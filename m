Return-Path: <kvm+bounces-55497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 220CDB3162C
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 13:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D02C13AD151
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 11:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55E92F6196;
	Fri, 22 Aug 2025 11:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="H4/Z6Pby"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BEA21C17D
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755861414; cv=none; b=DTxISRp18imEXzg4FMjMvgKGc6NM5gabagmaFtKasajR+fEfUwCosSaMDdJ2m7+6b3sQIzlJ8JIIyUclZ9O9sXivmdeqIykmsl9ZH4EEYWzhwVdAdpeOe37VOQeUMw711Z0ptsFYZMevbr8e41/g9YAPugIcRHO19Ot0p3e6FVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755861414; c=relaxed/simple;
	bh=EnVRyJysqSZwi8MQGqg2qst/Kg6P27YOfLXyF05YSm4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9ue0vn/uISigbC/iSyJUn3r2LRd1LChvLATehzyYJXLlXDJzpj/OVc4OOI4+xRjf03OzsN5R27f0zp3aS7bI4xo1iwciyIo0nooey/EY7WHrHv4rzQMhaZc0TlnvC/sumnrRKPJ6+vYHOI11JWyBY9Fh5N/0jOjyorAOtSIcQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=H4/Z6Pby; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3e9812c8315so4742215ab.1
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 04:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1755861412; x=1756466212; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Q/jRAhPC0Tmtp2ISTMDpD9VBCqxj20vPKIcSTLHsWE=;
        b=H4/Z6PbynrbE5e9mnQqSLoQ+BkUjEcilLRbMs+pdvSn+g+L11VnGuSPFqLABPJhTap
         eUNjp9a+f1B1rm28mqtECGzv+YXMTfSPfmrpXxZ1ggQn4+oksA01Gp3v82vkomo3/wgK
         UqG4t5rYJrt2x4xP8TLG0PatjNS2D7lRGlIF87rPoB+R3xodtMFOxj+pQho1lqYx05Su
         uDCysfhRebe1OTfEFFAoXwT8DwaL+PpdHD5vvveiqebtsgSKuXiVtJtouHkPMqBMlJH0
         hWtPt9w9fhwcMRcLFZeMgx4hRZ5fO9XTYJ/4Wl1bvF30iDoCETZv514NcBPxmp4745cD
         mY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755861412; x=1756466212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Q/jRAhPC0Tmtp2ISTMDpD9VBCqxj20vPKIcSTLHsWE=;
        b=mmG2RaQzreDzexKRZGukbeReHuOTT/ydTCQE+AlKtBLnBPRgUTkV+S2zIoAf3l2puK
         AgQucrCf7RpWGasIaCr063j/auXKN5ZR8AgQ85+0lfRxi8quP5TjKKvIlCwfuMVmNsIT
         SRwKlby2EIiZwvbqwy4vzfNx+nrQaLB5UWZ5CsWfsbB/jNBKDPuPnJ6f6kE08ywUF/XQ
         b5DaptsrDWZZocKXlQh+pQ+osUrnXBEqbZZXGGS72C1O2pHfmQyB1iaSkcEgd9kb+VVH
         EyUK97vWd/CUrRO1mSV7txERtlJZg+lehnXnX+eDI3AH5yBPQ5mpFR8zo1ReDyrdYPCv
         CrCg==
X-Forwarded-Encrypted: i=1; AJvYcCW6E3Nmo5M032zqBcneluQ+34CxupaCNZ7SBoTRWvkC4S3F1xRYZl2UvinzuEbp5lLNj9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU2NNbkLfrDwDiWX52r+RJI3ALaNIoU9rmOCCCFZXOGq05jSm2
	NvD8DhF5MCmzlONXjQ/VSCyIDonW7pawkYzYrEdOQGrrRE14qmU/yZNT193H2bH33eLENB1iN5m
	iY2FYwlHzDGptHwe+RpW14BdgHOqm9o2e7vGzZDJcvA==
X-Gm-Gg: ASbGnctuN6++LcMXF3djYJtiFprlaVDRgZDxSIQ/f7sBCrkHvCfQ/RSOTQJHyQWlq01
	RNL7CKgb26GdaS7kpxmI42+c5CSXc2MOIWNCh8WFILuzBrJRwHD7bTyCBAoJFI5e+BJg0HtjnGI
	Dl7yAcZXne+DMAIJIheQFtVwKADRWELiSWluiVfYZgKFUrzwYwxjaLhALGRWcuz8dTRQ4nfunXb
	WwLJ+VOv7mZXFDfmMU=
X-Google-Smtp-Source: AGHT+IEf3catLTwMZg08ITt9v+soiykhih7JmD1rfhONXLyWgFCvIw5fWgoyzMygsiEhsdJqKvljnLxwiGXIRXDHO7Q=
X-Received: by 2002:a05:6e02:220b:b0:3e9:eec4:9b7f with SMTP id
 e9e14a558f8ab-3e9eec4a13cmr7393215ab.30.1755861412296; Fri, 22 Aug 2025
 04:16:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <49680363098c45516ec4b305283d662d26fa9386.1754326285.git.zhouquan@iscas.ac.cn>
In-Reply-To: <49680363098c45516ec4b305283d662d26fa9386.1754326285.git.zhouquan@iscas.ac.cn>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 22 Aug 2025 16:46:39 +0530
X-Gm-Features: Ac12FXydDmBYaqaWI2oDhvXmh2nBQ17DyRxWSqA9fqFJ4rPMhrjf4Rw1RRPXrJg
Message-ID: <CAAhSdy0kpxEhz8AAiUUXapsEEGo4aMsDpSyMemr9khdYfy0OAw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Correct kvm_riscv_check_vcpu_requests() comment
To: zhouquan@iscas.ac.cn
Cc: ajones@ventanamicro.com, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 8:00=E2=80=AFAM <zhouquan@iscas.ac.cn> wrote:
>
> From: Quan Zhou <zhouquan@iscas.ac.cn>
>
> Correct `check_vcpu_requests` to `kvm_riscv_check_vcpu_requests`.
>
> Fixes: f55ffaf89636 ("RISC-V: KVM: Enable ring-based dirty memory trackin=
g")
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>

Queued this as fixes for Linux-6.17

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index f001e56403f9..3ebcfffaa978 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -683,7 +683,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  }
>
>  /**
> - * check_vcpu_requests - check and handle pending vCPU requests
> + * kvm_riscv_check_vcpu_requests - check and handle pending vCPU request=
s
>   * @vcpu:      the VCPU pointer
>   *
>   * Return: 1 if we should enter the guest
> --
> 2.34.1
>

