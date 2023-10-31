Return-Path: <kvm+bounces-242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E2827DD648
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 19:48:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E677E281245
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB165210EC;
	Tue, 31 Oct 2023 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJnTQ/WR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298B120326
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 18:48:09 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9AAF4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:48:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-54357417e81so2444a12.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698778087; x=1699382887; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4SYutzdU2lYd0Ydt06asj331E5VhblLHsx51CrMqmA=;
        b=YJnTQ/WRC2U3bPZjGOWHbLsEkzSghyqbu7bDhyEcSK+kT+HuASVc8f38LejspYCeT3
         jsUo/y26VsoY7Bs9XRINtlGOuneO9zFdR5l9NN4rW0QTdhBmDDkGbjPKoZQP58Quf+R6
         s54wIqKDqqOQw6LKnN0hGsUtUO6onElpwCmrmg9vNBRGSkAyjtHiiu2gvP7TeD+7V5Ry
         rcminDem9Z/4gQ7vWhj07yZNQjnhcGNQ0QiXg7CoPuCVMC0o6t7hDBhGfHPlQ1D+2QHy
         uOXQPD4J+4ToaAaOxsyE5uNCBt07C/Y0By4NejQ82AvcYtiOWXXnt4Zt6QZyt1tc2r1P
         cHBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778087; x=1699382887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4SYutzdU2lYd0Ydt06asj331E5VhblLHsx51CrMqmA=;
        b=K5RWzA3SIRTi5e/kpmtupAcwBamAmQT9OsxHjJsJJN9dlKp8YY6Sh/nYg84HC4oPeK
         TMkj3piEP4akjH2h9iuH1L1XF1Dvs37flrwere62Y+hd+j04wkwF/AOgG1AKCvS6WOj2
         L/Tnq3AT8CXtv1AUB4L2upkjGBdRd90eMP9W1EYj6O4gRsX9DV3dUwFhdJrD7A3ukNbt
         93q/iEIgfnyR180T8QDdPGf7BponexuyhPbEH1u8uXYUm491PrG1MASg9sdbYlaAhS91
         Z2o9PcNSqtEO6UzMzcG3jVqIKWqj4xpVN1dLAdk66AA6xzaJrtG4B8tkA1IRArxm9wPE
         aCAQ==
X-Gm-Message-State: AOJu0YxjfBEle76L44aLgufodkxGxzB3jzaL65GxK5Mit3jhwShL89cO
	YKvuUF0azfVrnWNxUhkeOrecExe9w2ns7oXPy7vAjw==
X-Google-Smtp-Source: AGHT+IH8aQCcupadQGpdlmBqtD0mL9ohRx/4Q5A0bBK0kcOUvlee6GUiG1dAoGzqxix5jpbUy532ZaZqXpUondFIT1w=
X-Received: by 2002:a50:c04f:0:b0:542:d737:dc7e with SMTP id
 u15-20020a50c04f000000b00542d737dc7emr201265edd.0.1698778086580; Tue, 31 Oct
 2023 11:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231031092921.2885109-1-dapeng1.mi@linux.intel.com> <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
In-Reply-To: <20231031092921.2885109-5-dapeng1.mi@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 31 Oct 2023 11:47:54 -0700
Message-ID: <CALMp9eQ4Xj5D-kgqVMKUNmdF37rLcMRXyDYdQU339sRCKZ7d9A@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch v2 4/5] x86: pmu: Support validation for
 Intel PMU fixed counter 3
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 2:22=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.intel.c=
om> wrote:
>
> Intel CPUs, like Sapphire Rapids, introduces a new fixed counter
> (fixed counter 3) to counter/sample topdown.slots event, but current
> code still doesn't cover this new fixed counter.
>
> So this patch adds code to validate this new fixed counter can count
> slots event correctly.

I'm not convinced that this actually validates anything.

Suppose, for example, that KVM used fixed counter 1 when the guest
asked for fixed counter 3. Wouldn't this test still pass?

> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 6bd8f6d53f55..404dc7b62ac2 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -47,6 +47,7 @@ struct pmu_event {
>         {"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
>         {"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 500*N},
>         {"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 300*N},
> +       {"fixed 4", MSR_CORE_PERF_FIXED_CTR0 + 3, 1*N, 5000*N},
>  };
>
>  char *buf;
> --
> 2.34.1
>

