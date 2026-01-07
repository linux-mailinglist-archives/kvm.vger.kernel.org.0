Return-Path: <kvm+bounces-67263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 74891CFFC52
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 20:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 81982300EDD7
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 19:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBCA334C04;
	Wed,  7 Jan 2026 19:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKqTNx/d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591183242B3
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767813988; cv=pass; b=li3Bfs1bWR2Wk2WXozQc/aRBNcd2U1T1Sz/0TABPQt47Ttf5zhOAqC9oxWfHkjN/rZYx33TeyXAjOub8LOb2gdWSFkK+9hEEOg/iYXuuVsmOKibuu8EPZIoYtpj7aBky/oecBSh3YtJtGmrA1O2nmRg/YWEscrlmca8Io3jkJgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767813988; c=relaxed/simple;
	bh=2LhpsPeSyE8bX8HA6xDr9D/rfFVNInchGx8D0QTzubs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m6N64IdT6+L7pTC4VBq1xFkAuXXaO44kWYigkSTaMEh6frFklTonaHp8o8zOqincgkBcC7qJxS0kBQRcSfi5lhyXg0u6O9I/yqg12RMsFMja8WjRyyu+lfV0V2+lFRWBBtWxJYzIepWt+pgxUwZ8j/M08WD+ka3Xt30AsSOUp48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKqTNx/d; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso481191cf.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 11:26:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767813984; cv=none;
        d=google.com; s=arc-20240605;
        b=MqLkcOFy1rcH8iDFEgPvhTgN5V6UyEO2abbJn1/ikM1Yr9HzegAyemV88J5dbWjUa9
         WthFVR8qC4p26PDiqARg1/mBxVnWT9uMBF/Bu+A8c+s2ekpOfHUcbb8C/if0eNBULMs8
         9eOITlSLVgNnx7Aoskw6/lhEEDwRNyrlok5IbbXf4v6OzCo5AP2XLqUh+M5AGZNFOVcI
         T/zL4d5BPlpOdyCPb8jVhN85F8gqxxsOAM32QbamrcZhgrmfc3Z8nUQKIk/KzwwqzdvF
         OhcirTKpbMRbtySEIbgq3GxHqJaS3UC7qYMZbK0MjgqECGXt9tdtMBdaEuwfYDx4DCHp
         pHPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        fh=dyX4SayUX9nyp+3J39dgCifNUpNxc7vpJon7xlJGWT4=;
        b=gVHUmG+D11LHpHylxn7DNElypoMOVNSAoM5abH9/sU2GAjCxLH5CnZ4rL0UtL4gmw9
         vrL4mpU0JCdRHFDGf+unGqQD5hMJCBeUscOHsDUVlzun4c9fp0BePdR30ivIRY8GvNBB
         PD26HM/GLoBnBnwl69HghrcAAoi1yjzNTeq7pF1axae4tZ1tt46TDmgqZhLTQy+7tYw4
         H52DWJvXRfTwI7wanAzFCfJ5uEfDovkrimuzeNAHzUO9SmTW0rxsbi8+qlhqUMsBQOoS
         m6kdohg7diFNGIN1tovK+859dBTwwWjsw5H9LrTJjTrj2FXJyjBmtzPaRzthhVucWcrO
         viaw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767813984; x=1768418784; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        b=BKqTNx/dRzg0zFWE+h3P30e/ZQqpYPrHRtHwoRfzxIAMhrBgKBcjzdydRIWKSg7SsE
         gtx/suaYozcBSsVPh/jsxJ8K4yYllQM04FpNTciw4x9uqYOPxzU4DagpLhl+AuOCVb6V
         n6vKWwcYnNdh/C/rtKnDVvRWHGhHqg4vk9NxYrAocwehf/0+1Jg7E05p1dt2alT3f5Se
         xY0Dd9X/odEq6muhhXAtLUZDliohR0oXSgivre+tCIuLte29h6eVCTefIOxnLpL68/jj
         hl1Elt21T+wHa26chyGvc5W/2or0/a+CTq8udA1rc+POmXxWfMzFQqmLa38dIxuob25S
         uJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767813984; x=1768418784;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWQBkRucMfj+8IZule2bckxNws/YyczMOLNESP4WNJk=;
        b=ddTXvshESj9vYX671Jeao1XR4xFVARM2Lq42xaBngbTqX7GHdixYv6pFthcMTMwTEg
         7nGcz0ePrkcJMYTiWntwjc+RvgpuHqJVRXwuY2ce6XBiVlRu1HdOAKteryuTYUu0PJWt
         RiqOENoTDT3JYKjz39+r0gXE4iXMBVy7SXjg2VS+99TmmVewaFXOVUuNrMck5o9Mmggm
         QHtEFMNCKzNCjuP20rwvcxBZXSaVv9dVyuaWIf1f+Sw4Rh4h6y64fXuUQhuxqzJyCXDk
         5xYfoGo7mXlV32pChl3rum22SCjaDh5u04YUPTSXaw5sw3781KzYprReD2wruuEsr2yG
         yYNA==
X-Forwarded-Encrypted: i=1; AJvYcCWvfyz8aNCMFFX7ZCvcGi7ABNCf4stExoR3/dSajS+4WtkWmEk3WE7EkoOPObF41RhgmsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC2IrvrRgTWMeTSITiArkLUgO9ocR+miFal/v9/Wx6om64FFn5
	l0rlsDV2arn4vJmMOm0HyIwMAY7/de94W70sMckvVDHcOWyM4BDlp2p6R4MOW2xqjhMZ7gySW6w
	2Kt63V/YkIFsPa7lTRmnyZ1PWdXV/7U+hgM5d7Dw3
X-Gm-Gg: AY/fxX4lDmcx51C97Sz0TrLZgsvFIsorI/s4BVLlhKRUuPKKNK3yOtf0qs/n7ciYa+F
	ewAwsOr+R6tk0nfeTtz6Xh3p8R8Kxc8qxRsNkiZxZBaxwtTpjlZiJq2FvD63cI564Tz6SXt1VnU
	pYQx6WBj96mZFvI23Z5B81OUs2KAdKNVU82jLWd3oD967lxb67vgSTgsjIixLdP+ejH7fH7XixS
	BLtvRxgI0I6ucwBYubt4jgPyH06kJgXKYPCTCZMuT+U8+zddObbXlq7i9KXh72YC57+FzDz
X-Received: by 2002:ac8:7d0a:0:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ffbf94a082mr1122261cf.19.1767813983752; Wed, 07 Jan 2026
 11:26:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-5-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-5-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 7 Jan 2026 19:25:47 +0000
X-Gm-Features: AQt7F2qO0uzZBb7qE9TqF-7WKMNBoVsC6m-23DUQhmoLKw26Bq83cmx6SM9OSu4
Message-ID: <CA+EHjTycP4Wz0V7S8hzWygpeXGzeehTL8RFfit7Eaq4rT+Eu+Q@mail.gmail.com>
Subject: Re: [PATCH v9 05/30] arm64/fpsimd: Determine maximum virtualisable
 SME vector length
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, Dave Martin <Dave.Martin@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, 
	Eric Auger <eric.auger@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hi Mark,

On Tue, 23 Dec 2025 at 01:21, Mark Brown <broonie@kernel.org> wrote:
>
> As with SVE we can only virtualise SME vector lengths that are supported by
> all CPUs in the system, implement similar checks to those for SVE. Since
> unlike SVE there are no specific vector lengths that are architecturally
> required the handling is subtly different, we report a system where this
> happens with a maximum vector length of -1.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/fpsimd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index f4e8cee00198..22f8397c67f0 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -1257,7 +1257,8 @@ void cpu_enable_sme(const struct arm64_cpu_capabilities *__always_unused p)
>  void __init sme_setup(void)
>  {
>         struct vl_info *info = &vl_info[ARM64_VEC_SME];
> -       int min_bit, max_bit;
> +       DECLARE_BITMAP(tmp_map, SVE_VQ_MAX);
> +       int min_bit, max_bit, b;
>
>         if (!system_supports_sme())
>                 return;
> @@ -1288,12 +1289,32 @@ void __init sme_setup(void)
>          */
>         set_sme_default_vl(find_supported_vector_length(ARM64_VEC_SME, 32));
>
> +       bitmap_andnot(tmp_map, info->vq_partial_map, info->vq_map,
> +                     SVE_VQ_MAX);
> +
> +       b = find_last_bit(tmp_map, SVE_VQ_MAX);
> +       if (b >= SVE_VQ_MAX)
> +               /* All VLs virtualisable */
> +               info->max_virtualisable_vl = SVE_VQ_MAX;
> +       else if (b == SVE_VQ_MAX - 1)
> +               /* No virtualisable VLs */
> +               info->max_virtualisable_vl = -1;

I'm not sure about -1 as the "No virtualisable VLs" value. Unless I've
missed something, this value gets used without being checked,
potentially even assigned to an unsigned int:

> kvm_max_vl[ARM64_VEC_SME] = sme_max_virtualisable_vl();

Cheers,
/fuad


> +       else
> +               info->max_virtualisable_vl = sve_vl_from_vq(__bit_to_vq(b +  1));
> +
> +       if (info->max_virtualisable_vl > info->max_vl)
> +               info->max_virtualisable_vl = info->max_vl;
> +
>         pr_info("SME: minimum available vector length %u bytes per vector\n",
>                 info->min_vl);
>         pr_info("SME: maximum available vector length %u bytes per vector\n",
>                 info->max_vl);
>         pr_info("SME: default vector length %u bytes per vector\n",
>                 get_sme_default_vl());
> +
> +       /* KVM decides whether to support mismatched systems. Just warn here: */
> +       if (info->max_virtualisable_vl < info->max_vl)
> +               pr_warn("SME: unvirtualisable vector lengths present\n");
>  }
>
>  void sme_suspend_exit(void)
>
> --
> 2.47.3
>

