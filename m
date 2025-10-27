Return-Path: <kvm+bounces-61194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD9CC0F66B
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:43:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9404F18857A0
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AC67311C32;
	Mon, 27 Oct 2025 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WZ3AN6gk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708D930CD9D
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761583373; cv=none; b=F+pDkv+mIlv7iwcZ1o0UWlBhJfNHnu/QgktrvzRkOkU2ZpaIT+hNsYmZ/TVcUsRk+694NRYuIBPlRdDEtRn591UoB2JFuItVtOLlQWHT+rYPcy4Vi4hHVQ28oguZNQBcXsd+KXIckf3+61d3dEIyaqu/OpZklmnGqa2mk+Nvbng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761583373; c=relaxed/simple;
	bh=UUysKEeNz7Tgg2dxFbmWl3NmClv4oF03ZgJirQL/j1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PlErfAhFgxmKa+2/5433AIWOTbUx4sjGpj56+LGnQcqE/jerKzAh19uDRuoVHNgffKBhv/5SsEBE/XzXtR6G/dDpZH6vkLRXBTr5AXJ1NNkMAiLFo6T9zZUDiwllAa0/1+NmhZngiCkTFo8rNICAukXhNZLTS6y5EB62eLCTxEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WZ3AN6gk; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-63bbf5f77daso5401234d50.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761583370; x=1762188170; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iIqSimi39klofHZtZnL5Vj2K3y0rXxrFl3z6jktwTZo=;
        b=WZ3AN6gkIk8/oqHC88KSniHSTxG1OTCbYnboXbMuj6sH82324Iq0mZKwSVbwmYY+IM
         7ozLDAN26NnQVjMJPR2En97iL2X5/+fJ9HXjshePD9ZhoI7d9m+/DWPuODS4YUwbZ3gH
         6sHXl+7LDEuUIubpcfjqIFKoJuhwMiu1GdfLW9NmSK3J+gQ1m3fiw0G3bRva0O9hvgpv
         ROw4lIicmg91yQkS7wxQBmeWKwBcfuJIF2sXiu50VIgavWEx/I1BqdwTfBHJxQMk5pHA
         h9uxRfHQczs47EUFu37SbwspsPLWqGk3YpVo8N3NgDIZMbKCtXDw9rxLGa+dQOHmrAOZ
         Qt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761583370; x=1762188170;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iIqSimi39klofHZtZnL5Vj2K3y0rXxrFl3z6jktwTZo=;
        b=dnhffxr7e6WPye7J28aOkx56pA9lU6bZhbO+ru1A0psE23N1YrlD9qOG7RPwT3NYqv
         wZ1jTAtVNkItCgVGs6IlOaDgwZZdZ4WTbIjXhMxbsPa3i3ovza8XFEmR6SlAQxmh6KW5
         06x64cT/GNCRsxb7MelpeMWF0+PyPdh16T/t/PJn+hRAbw8DfOb/4zL07v5vMJ49J1iz
         7HV5XKC6zsY27zQdGrYpXwV4J/IEhgSkcVl91/n8d7z4iGL5a115rB9j+VuwoM4bohEG
         8nM9RRdpV7OfdayofMnOG8oB7X1UHtCbbR01YqnUoCTqZ7a00kCvIqhokLUXqh3a1CqL
         mWVA==
X-Forwarded-Encrypted: i=1; AJvYcCUyyZwbZv+3yXQZPFclnidR0qMnYYrLtmLbkGC6+JgN35HoXvoyYu5xcXkUA+dGxWaIDoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnYaRxgfaVcIGavL6P7CNeO36l7FU+rxXqpSDrqarRasvfhPu5
	IV0PU6xVGG9pjklAamcIxgnZ/z7c2pVIJOzWpwie3fACsn30uSYgxmdJLJdbdHY3GWLhoyilVPD
	rj1i7zzeTcM4krK9mNEs8KkHwKW2qDZB18BNPBzfXmQ==
X-Gm-Gg: ASbGnct2i+aTqX/KHiSBT+5EUz8Bh9lANNyR5KUQEV7ZvUp8jhlA2Nhcjf2lP+2ABjN
	NMMAVx1Eh46pEKvxdIg3wQtJbSw60LiYcQDCYW0QXRg22cIdrBBau5MEDgyc8EASN9YTIynrwfC
	NE+aoEiPblYdre/x3z3tlqvp8hiPenEskGiu0vEyeftN9iMMiXvu+CHbVA19gbPK4PcAfQaP0o3
	SVxrI2IKjUbvR2cJoImikpBR9O8WV5r97sX9vbjHApOBoEQaQSXVszCHj/lJA==
X-Google-Smtp-Source: AGHT+IFnTy4GuL39gQqo5cO5/AtjK3ueLANt8SL8mKD6Wd3Al0HmUJPCwVFv88tqthud15vc4T2fVPU5v7ZGG0ZTM0s=
X-Received: by 2002:a05:690c:a90:b0:784:a6d4:dc21 with SMTP id
 00721157ae682-7861838ccc5mr3677497b3.52.1761583370329; Mon, 27 Oct 2025
 09:42:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com> <20250911144923.24259-3-sebott@redhat.com>
In-Reply-To: <20250911144923.24259-3-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 27 Oct 2025 16:42:39 +0000
X-Gm-Features: AWmQ_bnGFe7efhNQOt02HzPY7w4uzHv-6KQOwTPx1B30MSJa7HImhr0NK5nCCdw
Message-ID: <CAFEAcA-urFX=V7kuRA3cRik7PifFQER5eoXC_CZ2jKg7OZz9iA@mail.gmail.com>
Subject: Re: [PATCH 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 70 +++++++++++++++++++++++++++++++-
>  3 files changed, 80 insertions(+), 1 deletion(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index c15d79a106..44292aab32 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -974,6 +974,12 @@ struct ArchCPU {
>       */
>      uint32_t psci_version;
>
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t prop_psci_version;
> +
>      /* Current power state, access guarded by BQL */
>      ARMPSCIState power_state;
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6672344855..bc6073f395 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -483,6 +483,59 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const char *val;
> +
> +    switch (cpu->prop_psci_version) {
> +    case QEMU_PSCI_VERSION_0_1:
> +        val = "0.1";
> +        break;
> +    case QEMU_PSCI_VERSION_0_2:
> +        val = "0.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_0:
> +        val = "1.0";
> +        break;
> +    case QEMU_PSCI_VERSION_1_1:
> +        val = "1.1";
> +        break;
> +    case QEMU_PSCI_VERSION_1_2:
> +        val = "1.2";
> +        break;
> +    case QEMU_PSCI_VERSION_1_3:
> +        val = "1.3";
> +        break;
> +    default:
> +        val = "0.2";
> +        break;
> +    }
> +    return g_strdup(val);
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    if (!strcmp(value, "0.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_1;
> +    } else if (!strcmp(value, "0.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_0_2;
> +    } else if (!strcmp(value, "1.0")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_0;
> +    } else if (!strcmp(value, "1.1")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_1;
> +    } else if (!strcmp(value, "1.2")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_2;
> +    } else if (!strcmp(value, "1.3")) {
> +        cpu->prop_psci_version = QEMU_PSCI_VERSION_1_3;

We already have six values here and it's not implausible
we might end up with more in future; maybe we should make the
mapping between string and constant data-driven rather
than having code written out longhand in the get and set
functions?

> +    } else {
> +        error_setg(errp, "Invalid PSCI-version value");
> +        error_append_hint(errp, "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3\n");
> +    }
> +}

thanks
-- PMM

