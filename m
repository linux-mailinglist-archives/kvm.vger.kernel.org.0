Return-Path: <kvm+bounces-67574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E8F0D0B135
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 16:56:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D332A301AB6D
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 15:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351A3280A5B;
	Fri,  9 Jan 2026 15:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aOnZrg1O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB1B50096E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767974184; cv=pass; b=hEBFG5JJKKsACkIo2H3b6ZQ9wTEhqncoqSsulO3L4C+/YxxAckc9fHw0l8CfPDH5rpMXyz04cmsJfk8sqg+dotMdK8aV/DI9qhr0fPKEriJd+rXP1zz89ku+70/7I7s5bHU4p7d2Q+tv8waY6nva4sX8HVQFimvBo8aMGAZtoS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767974184; c=relaxed/simple;
	bh=RJop5DvCjIWLKeaevl0mMUi6g/p1XvGrRQjivQIYqSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NxbJQNWfAbT4CuPR3TiR0RmkVywSo3TdroudqbMSkfwyRhZ9y8h4ureC5hYFuiEKXWO5DktQ0IzDjE/n/o7RW2OaKPgaASJKRf2EQNLCnYKVhLltoxwS3Tv/0AUE+Q5IW96agREEIMr6quEzCpQJSpnleT1yyp8hfEW3q166Fto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aOnZrg1O; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ee243b98caso353791cf.1
        for <kvm@vger.kernel.org>; Fri, 09 Jan 2026 07:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767974182; cv=none;
        d=google.com; s=arc-20240605;
        b=DH7Fr3y7rnrIwH0uY4HfDYuMMzhsKucqLQE9uZ/hnkXIL1xKHo9E87bh6trapP4HB3
         yOr3EJjfLwA4NemKDvOvd4XHL/Jp1ypCsz5pkER2s+l5zBClVNU9zm/qAEA5pdtx0Ci9
         eeHeD2mkxncAfqyqImeD/kjBSqwrWK5ZNsultAy1fCn9u+/NG/i17qYGrhP92jbkmxIS
         65AHPkDgxRhLmGxcLzYJWGm/igWvC95lnjOHaZ3YkbnQ/Ev9uumU0ZhMadhjfXU4aKYG
         B/WrBDQgEjtfIGgzh/PyjobrTMYKttJdXGH0gdt7tqWTFgr5nDr88i2AvwqGejSHAf14
         QN4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        fh=e51rnOPFNN0lQQN6nAnUyQl7SCGoqIp6ReM5K5dIzm0=;
        b=Qk2mO50go0uwc7ga5tVcMVshJ6ehrGqhqag295CnYIVb+sHnPGkFDmBKswyTwSzcte
         2QNm5szglp5Zhb/aaFn5SzYetHPsPbWDXQ/KOTYPqgstzA3O17BiUSoKQAUjtg3kRun5
         Op5CUsyQJ5cux4bkFdQmrdldFRuAt7jBZ5fB6Zx3JkM1kHvENxMzrduhYlswDcbItVCi
         Pe4vz9Snq493Inad3GZkqqFVX8EiLWlAI3FLmIki0FkmK0vl0fpzBIREiFuNfNS6y7L9
         mK2EMp9PX7nSwtx6kKfLcUtG9NJdDYxrMFLC2eN3SUxMjdy2Z0EBmObYHLgLTlsQYHvR
         JYrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767974182; x=1768578982; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        b=aOnZrg1OPl7eDlojGo98JRYTJvq/PnfnNQZ9XcAV/DHytRrdch0y/4x5n+5k3Xp8E8
         9mSQAxxSyg1covqqhLMvcHpYWZBomI6se0JkRaPkoQ4M3cYxLK62tmjM2eqwghvtyA2/
         s9chezLI2pDKYDGOa6EyZQDuvSO7XvMiX7rLgzM5khLqUpDYvLfcXsZT/mfCjeJENi/F
         KtDCFATbEQkFlr/c5a6EGPZcMsViCLHgVsP80mwTf3t47xFHMBtQUBpRtSKnphrzLNxX
         lhcUwN7gu/HVScIFCq3BILbuoqHBxaA9PlA77RyrxyzMWGQAwN57xNwzWIRDZ/gu0J2d
         5nug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767974182; x=1768578982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5CL8FxNgdT9nItA6mQg13QZSgYd92jfbMmDmpgGf0w=;
        b=SNgIaU/0LCeQvm+F7DCYE/kd2m5WFbtyjb4c2JrjQIMXXqYZu+AVW7LxlxAA4+smD0
         G/1QYoBuilcPosmL/692PWKrd5rSzl59rjvdPMSlM0u0ADADGs35jl6Fl4vQ/6qwwpkw
         a2FB3MVc1LqNG0BtJCMKVSadC7+u8I9TicFJeyI0ZsC0fD/vOiU48DR6pw9hlvByej4J
         pueTCHmnm0bBfhZa789nOnK6dxT/a3XO45Ms2vBuYcDa8nyxiTuHIzpgDxkZIGGXucit
         l5mSL5BPcbUpsEwSYW0U4VupGPx2ZUpzyayjzYmM4jWdj4z6BhO3RpZdyFeZvy9vmCAh
         36IQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXO212w8ovwGXzkGCIpU1zI8zEmGEfdzHD+AXkHGoWtMPDD0Y3W3YKCggW8KYnbtwmBTU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEoillwMml0R4Z3EuyYMwrRTODDN3lZ4Mu2pRhXsTBlUeo9p9m
	4NygQ2lKccPFA5JgW8UcoAfwQHLWuDRg5cX9ChFNa/vTSQJQI7klM2b3sNWdckJyh2q8f77h9Yr
	LF7buZ3bW+w20hmVf04X6hn0oMS7PNUId2959sSYg
X-Gm-Gg: AY/fxX4mYg+8zwYj5hxVxARHganLBlnxksQDa3dArgEFs/27xzFL/nAaDrbcFWiP7+t
	crI9KTbpUgawtgVNSo4OJze1Ilippo90murlXYupFOT07KNplQCzGm5/u0URF4nJXNQ6Ox0yCWP
	0BGd6cLYSFl7PTMJ1FcehU2LJ5cnW8/8V919oTGcqk3mgmEDbfcQf6Dw26STShbe5KlnguDSASN
	LAX011HrGefFd7CUPzwVdP7IAT3Gf3FR7wLO6u2L9EnTvmQIqZhfQTaBgtqjanjmDGukjl7
X-Received: by 2002:a05:622a:1827:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-4ffcb233993mr10494381cf.17.1767974181223; Fri, 09 Jan 2026
 07:56:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223-kvm-arm64-sme-v9-0-8be3867cb883@kernel.org> <20251223-kvm-arm64-sme-v9-12-8be3867cb883@kernel.org>
In-Reply-To: <20251223-kvm-arm64-sme-v9-12-8be3867cb883@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 9 Jan 2026 15:55:44 +0000
X-Gm-Features: AZwV_QjYKCnQMH_dJFXuijQwcG8RABb6JnH52RR1LbUrpQK_8_OFYA5NFixm6a4
Message-ID: <CA+EHjTy95BPnZzZcrR8eOekTm9Cv41D_BCkH1puWtDG3JO6yTQ@mail.gmail.com>
Subject: Re: [PATCH v9 12/30] KVM: arm64: Rename sve_state_reg_region
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

On Tue, 23 Dec 2025 at 01:22, Mark Brown <broonie@kernel.org> wrote:
>
> As for SVE we will need to pull parts of dynamically sized registers out of
> a block of memory for SME so we will use a similar code pattern for this.
> Rename the current struct sve_state_reg_region in preparation for this.
>
> No functional change.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d15aa2da1891..8c3405b5d7b1 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -404,9 +404,9 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   */
>  #define vcpu_sve_slices(vcpu) 1
>
> -/* Bounds of a single SVE register slice within vcpu->arch.sve_state */
> -struct sve_state_reg_region {
> -       unsigned int koffset;   /* offset into sve_state in kernel memory */
> +/* Bounds of a single register slice within vcpu->arch.s[mv]e_state */

nit: I'm not sure that the space saving of s[mv]e_state is worth the
added difficulty or reading compared with writing sve_state/sme_state

That said:
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad



> +struct vec_state_reg_region {
> +       unsigned int koffset;   /* offset into s[mv]e_state in kernel memory */
>         unsigned int klen;      /* length in kernel memory */
>         unsigned int upad;      /* extra trailing padding in user memory */
>  };
> @@ -415,7 +415,7 @@ struct sve_state_reg_region {
>   * Validate SVE register ID and get sanitised bounds for user/kernel SVE
>   * register copy
>   */
> -static int sve_reg_to_region(struct sve_state_reg_region *region,
> +static int sve_reg_to_region(struct vec_state_reg_region *region,
>                              struct kvm_vcpu *vcpu,
>                              const struct kvm_one_reg *reg)
>  {
> @@ -485,7 +485,7 @@ static int sve_reg_to_region(struct sve_state_reg_region *region,
>  static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>         int ret;
> -       struct sve_state_reg_region region;
> +       struct vec_state_reg_region region;
>         char __user *uptr = (char __user *)reg->addr;
>
>         /* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
> @@ -511,7 +511,7 @@ static int get_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  static int set_sve_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  {
>         int ret;
> -       struct sve_state_reg_region region;
> +       struct vec_state_reg_region region;
>         const char __user *uptr = (const char __user *)reg->addr;
>
>         /* Handle the KVM_REG_ARM64_SVE_VLS pseudo-reg as a special case: */
>
> --
> 2.47.3
>

