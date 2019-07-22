Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF7A702AB
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 16:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfGVOvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 10:51:13 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46011 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfGVOvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 10:51:13 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so37823994lje.12
        for <kvm@vger.kernel.org>; Mon, 22 Jul 2019 07:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NmRF2kaOw40rznWfjCJVbDC4AKTC36kv0HPXnc5ddCE=;
        b=IcEx/SXtNd4jWKbyW4aH7+REj3HlGulQ0ynWwdqqpmDj81tKnzrPGxonAKrC41cDu1
         lIjkyi3Imh05LQD/0cMlmohlgwjz4mmgtxrAXd/QqKUVBlntJJPFyJ5Ykqts8SbYemwy
         r+CNet9lKScw3W0R5gJRlOD5ElE90Kbh9xzctfXfi2JKlC7PQwx6AZ+Y0JXHfCoPai5D
         OCjg7Cy09oD4gFtU6yJdcp/l7DZ2MElTIEl120681RvM8SskJ+G/AXESTDhV07phceK6
         7lNJbPV2nP3usZ48j9i5lU/z55NVR7d5jaFMh5OD1NMgokaPXTC6aOD5zu4Uv9tFSz+3
         sZpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NmRF2kaOw40rznWfjCJVbDC4AKTC36kv0HPXnc5ddCE=;
        b=gTKVRHvl+R1HiIRM2aITyeuerd9tWirhFsIVQrqycTgP5oV0FojcsSshpnuHkjSTxs
         BxgaHuPJGqg8dVvmRTtEoBR2ruYyJg/MQnngJ6G34QBOGea/YJ9sOHCRVBcBdfpN0T5S
         hco57Sr9HaezPklx6ZnXDR1/UHnOBQosCqKhLpg9YbUHZi3nTafE7bbIg/z1FZxdSJgT
         XnnBOW70H7e1Wy0V1VE+za0/u+46WqKFseaQMUOBcuPZEceP9z3k0vFxQvknS1WXrw+R
         jsRw4HYh1iQOj6d8OR7HIjpGDBeghMhxBJbQgFisOApEltrBYcMmhW2TWuM2elgviGCi
         5OSw==
X-Gm-Message-State: APjAAAVHuIHN/wus9sYAoGJ6rCGT0pKwjvCtzlDWddhK9XJeqw2+sprg
        lsu9Rx4hPwr9Ahoo3GR4se6R5kM25T1TtaGarb2AdQ==
X-Google-Smtp-Source: APXvYqz6JRfNu2bVHEI+xCIwQ7lkO4Ojm0nd94T2byHbDrkwkxd9qY8dFLL8/8bRVKt2iVlrg/oo/r8WhE7XeaCxwxc=
X-Received: by 2002:a2e:8945:: with SMTP id b5mr35716701ljk.93.1563807071622;
 Mon, 22 Jul 2019 07:51:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190715210316.25569-1-aaronlewis@google.com>
In-Reply-To: <20190715210316.25569-1-aaronlewis@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Mon, 22 Jul 2019 07:51:00 -0700
Message-ID: <CAAAPnDE43xj+A6f3mxN9P1GKAQq1fk7HvUu8Z9R9MKnguUO9eQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: CPUID: Add new features to the guest's CPUID
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 2:03 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add features X86_FEATURE_FDP_EXCPTN_ONLY and X86_FEATURE_ZERO_FCS_FDS to the
> mask for CPUID.(EAX=07H,ECX=0H):EBX.  Doing this will ensure the guest's CPUID
> for these bits match the host, rather than the guest being blindly set to 0.
>
> This is important as these are actually defeature bits, which means that
> a 0 indicates the presence of a feature and a 1 indicates the absence of
> a feature.  since these features cannot be emulated, kvm should not
> claim the existence of a feature that isn't present on the host.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ead681210306..64c3fad068e1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -353,7 +353,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>                 F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
>                 F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
>                 F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> -               F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> +               F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt |
> +               F(FDP_EXCPTN_ONLY) | F(ZERO_FCS_FDS);
>
>         /* cpuid 7.0.ecx*/
>         const u32 kvm_cpuid_7_0_ecx_x86_features =
> --
> 2.22.0.510.g264f2c817a-goog
>

ping
