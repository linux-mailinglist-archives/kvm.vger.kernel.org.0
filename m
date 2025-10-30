Return-Path: <kvm+bounces-61464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 024BEC1EA7B
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BA83E4E6B66
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 06:59:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBF6332EB5;
	Thu, 30 Oct 2025 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lp+dX3yh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C65332908
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 06:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761807581; cv=none; b=Nn+/gpVH3Q9KR8P2vlntqJPmlyyKuxj7OhBsTGZ5RrCF820j9+1hV10+GoCA57pTJgtdFhIKQAKR4E9YanclL3S7zlmJe0qkFsvIQi/aYgjV75ciYSYtlbHXjCN6juosaBJrM6KBALr6s5Xk/iuL6InTm1y2RcvNlnTjNTHpZOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761807581; c=relaxed/simple;
	bh=su0oQI4QOzWItSKWQ8g0F+1/ZeshZxA11SqOEwqjvEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=noelya/elIXzttI1nUmtlC/zJjLLUVLHNaXcnBzbDErnP3LhWt/KCslubTPDuYaNdzsf/ymE/GyeEW+pfeBpEYKmqastk5Xj3ZfoYWpYE5bxufyxLAL2UXYpvFbfFwuVaJcxKRzBXgholCC29rPvTHf5ouFZoQUpJ5+2M7jP2+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lp+dX3yh; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so889556a12.3
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 23:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761807578; x=1762412378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJ/HO6pHQVocYwCqGJnhbN0FHbwRi34rNhDy730oj+I=;
        b=lp+dX3yhUw6LvmYzmufN9r7Zv8qKSL1D6/IsRJRVP4Sg52h0YECDEJP/F/Aeg0yV2a
         YjrqEazGQS24ab9ARRtpcnL1Fv4YJhik6vn63Pfb8j2ytE+rWo7MXhjsZghhZLi2BBRC
         eCD8AbzkXl6rO3qDmrKNHfGPM+qbzCoNyJ5t5yhfqbASEuPQKOAKAy5+4Tvn87425E95
         dbX04c4Ee8M6x1/tVsqFMGKXOkG8ULTg7TstnLaAYw59+tMGw/Z/Eyj/BVv/VMIwX+UK
         EyeqBGyJgsJ+7cHkuRN2vbXyWlN22BEtUakb4j6eIDvOt7tiFWW43wiqJ6Bgc9hxm1X/
         6IWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761807578; x=1762412378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJ/HO6pHQVocYwCqGJnhbN0FHbwRi34rNhDy730oj+I=;
        b=e7COUsvP/hi85EfHJ3fdfgGDQn3HCl3Ie71I07Xd6xUGU8hPKKCRKOe9mnYd9xZu2e
         sPqXVXi9ZoVAA2KRQF/34mfVMs/FxDqgB+/gJBT8N/exa+QHuSIKhQuXW4Ia0MF3sEWG
         z9GuzT5cckdY9jO612BqkdlRuAxsp1wTS06IKFBYPtvmhyR/fE2YN8qA3/jbhhP8tahj
         Axlgpwv6EUJmufK10nJTAzyFavLc1bnRPxWrvKhibS68lJDaF7lfsfEZki6CV//73CS3
         GhbZJhXrZWIm8mwqElMprLXOIJz4S07XQyP6k0fvaD7oVE4UuM1azwkws3KiOicb/uw6
         RT3w==
X-Forwarded-Encrypted: i=1; AJvYcCVs4gku8KVIR0kcfZM41NB3KZdbIhXwOB1j7cz+1EWWwOHfyHQbEqlgiL7ZV//chbRbN7s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtK1NC40tu5oA/2K1NqIkZcXPumUrmlkC9xuT7wFziwVI0ByQj
	SrIGJaFTerW9XFyH4hAmYeALz3IJ37P1ocHj+6SxLgj4G40Rk4OT6zVUPscoOqjSiLQgbxcjjAf
	IWc1qyQjsJ5PKEGCYhoQZOMF6SCrjb7qGl9u+bW8vIw==
X-Gm-Gg: ASbGncshbAiD1jH8fpeN3dGXsGGs6pJGybRXLujH1/Wz5vXwS/qKT/mcd1Vhc9puvLA
	+bmXBiR0uMjUghPGwUSj3y3bpXsVXAvFy/35jU2Iw7SwtzNFLpsZ4/rVgZZ7gsQisnhgPBbYf8C
	i1YuOQIXHi/uH4MwD3a5LEjg/6/aG3tB1Km4gf/+neWEUlgl+bHwaVa+gTScysPNWFRPXW28Pna
	fx37vbDe8USRpc0z+oS6pM1yMl0j3aW+UMup9x4vRpXTu1LtsaIoB8yQCFp4TQPIXrQNiA=
X-Google-Smtp-Source: AGHT+IH0xKtTOvXSj0w0p9pGjs44bfmfXmJe9ZjkC3NgIW10Mc0UYv7dQoY/VDKyF22Hv8KKVyDpPTiWdRNVg40T52w=
X-Received: by 2002:a05:6402:3506:b0:640:464a:56ce with SMTP id
 4fb4d7f45d1cf-64061a206bdmr1615343a12.2.1761807577663; Wed, 29 Oct 2025
 23:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250120061310.81368-1-philmd@linaro.org> <395c7c86-08b1-4af4-a5ca-012a9aa89339@linaro.org>
In-Reply-To: <395c7c86-08b1-4af4-a5ca-012a9aa89339@linaro.org>
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Date: Thu, 30 Oct 2025 08:59:11 +0200
X-Gm-Features: AWmQ_bl6hqBdTUMqfB1A4rR44hN5EJ76yR6SMau1gPDpmEtyNMVrsra4cLNQE5A
Message-ID: <CAAjaMXZSkxCgzdC6w-onUxVxU_ZW5fiBtW5-ioeKaXwD_7tJeQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] cpus: Constify some CPUState arguments
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>, 
	Kyle Evans <kevans@freebsd.org>, Warner Losh <imp@bsdimp.com>, kvm@vger.kernel.org, 
	Laurent Vivier <laurent@vivier.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 29, 2025 at 7:59=E2=80=AFPM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 20/1/25 07:13, Philippe Mathieu-Daud=C3=A9 wrote:
> > This is in preparation of making various CPUClass handlers
> > take a const CPUState argument.
> >
> > Philippe Mathieu-Daud=C3=A9 (7):
> >    qemu/thread: Constify qemu_thread_get_affinity() 'thread' argument
> >    qemu/thread: Constify qemu_thread_is_self() argument
> >    cpus: Constify qemu_cpu_is_self() argument
> >    cpus: Constify cpu_get_address_space() 'cpu' argument
> >    cpus: Constify cpu_is_stopped() argument
> >    cpus: Constify cpu_work_list_empty() argument
> >    accels: Constify AccelOpsClass::cpu_thread_is_idle() argument
>
> ping?
>

Hi Philippe, I can't find this series in my mailbox and it's not on
lore.kernel.org/patchew/lists.gnu.org either. Resend?

