Return-Path: <kvm+bounces-36781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3228BA20C3E
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 15:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56A5F18882B8
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 14:49:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA931AA1D9;
	Tue, 28 Jan 2025 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wbaYumbz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0850F9F8
	for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738075731; cv=none; b=d96/DlBKqbFNMVg1htdk5YIGteX0EmUZ0m2VFWmtuK5czmmuJxcgmarrjUgQr95Kuwer/F2BIs/wTj5my3J9InPL5kwBXNp/Xx1m4jNYoNotZURHu4myzrb4EKFVD6kyx37askZRb39CrYclaJ1xY86W5GneUGZNMCAYJZ1LZsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738075731; c=relaxed/simple;
	bh=T8FENFY6wre3wqeISLzY4atBfsrYjsBccwKViNRlmFQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCrxThIA8Mny5A2g2ji2HAyWLbXdz0401FHjXniHkYpckqjbGttIrKD4GZbGXdopZAKRMIb7Rz8NY+49dyRthjtaG7bHQawvE9Zf1j9r4nlJ2UcmLbVKwiWf0F7RMQXnzsSo6rmCND5x0anD8RG9Sn0/Wu1t6t+cpaB3yamSFI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wbaYumbz; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e3a0acba5feso7897739276.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 06:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738075729; x=1738680529; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aJUCYvX3rMcr6GjYeBujEpQOfmkv12NhagSQAFdjln0=;
        b=wbaYumbz8rSqnKIAxm1v05q8xlatw0MIotBWczKaicxSks3yzAs1IM+ecAosDyNn9e
         ZEIM0AbI7mpiKYIqZEgBo/0xx3uaWhTWvWBn7boyGLM31wiNWeO9N0R7538HcTJ7rUfS
         DbQWt4oeHDS2itXgN3rShFWPEDwfOvhxZKv1LtSxOwVkxZHAJ8p1l9thG/4K87/yEfmM
         IfxFvzZwz6JAxKsqXfF9Sd41osdtVFyAtJ72rYRma0bjt/sfb1Xq+UvpaTImWvIsS55x
         jnKhbc43kafKHNbRthDFh4gglxVUUc9ejjz6H1OZ52zKamyhlGvmAj4QyPwH1UKxNACe
         octg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738075729; x=1738680529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJUCYvX3rMcr6GjYeBujEpQOfmkv12NhagSQAFdjln0=;
        b=Bz8KlP9jPatnn1b2kBWQr5yEGmMXQzPyq6XUbMVyKSrufYot16wifuGbS6eBDwzqMl
         zhdNJuLxU1Lk2yLKOYkZbjNtsK3YF1NJeeU3s7dxWLOFszh1amBOIxDw0/smbKUacl5a
         3xbAavZc9T2zyX27v2Yu9uLb8cqYvvsQKktblimVJjzSbtWRDSBOM8CK+HtdjGDZH47d
         fjle+iQcIf0swduG7ixQNCuXeYt1FlHQK48kIIJUGzLbPazyqDNEVlmUGuXAPNWTqOJ4
         ePKH8lxc1Gl9m/MrJb2UgwhaAwDDoM9hqS8+avu7NJjY5n6dIcuzE6RQ6wkz1dw1q2K5
         4yNA==
X-Forwarded-Encrypted: i=1; AJvYcCVT7tVOiYt10UWDoHXNPogrqS5LwPjHigDayMaWOSwsOkuhWXACCvrMd1xgBBaXZydHpVA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/BG0fKyzDwtUpqpRkKRl84+D9UGXVs/GNiM08N/iOR4K4MZrU
	ZP7w/ju0wk6ekA0JHw7Ansa09WtX4cJyaJTBhUoi1+BeHzhLX6vbBGOm9x2U1Bn3Rz5SDoj1/7K
	u6fzg6Ng4reu8PY2q291muyehQYIJeBe45oFWXw==
X-Gm-Gg: ASbGnctW3FfBtZYFtQOTBSFCNqOdiaU9muTNidOH4dOuF9PAHGf9yo/0sYzAbHV95Fq
	ZZEgUHHFtFnkKhC5J6Ow+rEM8QFw7U9uIJYxeFKNghEf0QRJFi8mUUi3/eslzpwDWL0pdNA9ymw
	==
X-Google-Smtp-Source: AGHT+IEQuz6Clbv5WDuz0z4V+Bs4pR5STmbY2gDPbv8scEBlvESvGCp6Lmzcd8cdkrnPa7ZBGK2jhs4Cxm1AMb8pc0w=
X-Received: by 2002:a05:6902:20c6:b0:e57:935d:380 with SMTP id
 3f1490d57ef6-e57b13310fcmr32632736276.47.1738075728870; Tue, 28 Jan 2025
 06:48:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250104-pmu-v5-1-be9c8777c786@daynix.com>
In-Reply-To: <20250104-pmu-v5-1-be9c8777c786@daynix.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 28 Jan 2025 14:48:37 +0000
X-Gm-Features: AWEUYZnuNraVr6I5i3m0D3BjF8hIuL06pYnzzd_BEQCeqolmWGXrA-CVlPFyblg
Message-ID: <CAFEAcA9NzHeo+V8FpXDBjPK9n2i+LDVCxe1AS8z7O9DX9Cvzuw@mail.gmail.com>
Subject: Re: [PATCH v5] target/arm: Always add pmu property for Armv7-A/R+
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"

On Sat, 4 Jan 2025 at 07:10, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> kvm-steal-time and sve properties are added for KVM even if the
> corresponding features are not available. Always add pmu property for
> Armv7+. Note that the property is added only for Armv7-A/R+ as QEMU
> currently emulates PMU only for such versions, and a different
> version may have a different definition of PMU or may not have one at
> all.

This isn't how we generally handle CPU properties corresponding
to features. The standard setup is:
 * if the CPU can't have feature foo, no property
 * if the CPU does have feature foo, define a property, so the
   user can turn it off

See also my longer explanation in reply to this patch in v4:

https://lore.kernel.org/all/CAFEAcA_HWfCU09NfZDf6EC=rpvHn148avySCztQ8PqPBMFx4_Q@mail.gmail.com/

> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
> The "pmu" property is added only when the PMU is available. This makes
> tests/qtest/arm-cpu-features.c fail as it reads the property to check
> the availability. Always add the property when the architecture defines
> the PMU even if it's not available to fix this.

This seems to me like a bug in the test.

> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index dcedadc89eaf..e76d42398eb2 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1761,6 +1761,10 @@ void arm_cpu_post_init(Object *obj)
>
>      if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
>          qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
> +
> +        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
> +            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
> +        }
>      }
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
> @@ -1790,7 +1794,6 @@ void arm_cpu_post_init(Object *obj)
>
>      if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>          cpu->has_pmu = true;
> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>      }
>
>      /*

This would allow the user to enable the PMU on a CPU that
says it doesn't have one. We don't generally permit that.

thanks
-- PMM

