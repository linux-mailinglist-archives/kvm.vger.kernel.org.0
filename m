Return-Path: <kvm+bounces-3759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6787F8078AC
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D0021C20D62
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F0D47F4C;
	Wed,  6 Dec 2023 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bg269fBQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE32D46
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 11:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701890974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sljBObNDGvGAqcWtvwFnUEKrACaMezHakqGzjYfrZeQ=;
	b=Bg269fBQZewgxXeV0Fy/8o6H2uJ8GGOQ4YDQ/t+XbZYPtORCSJwRQEN7itVJJeSWe4ktCq
	cbnFN8FqtR1lFm4NBAT02z36sz981bit0J9bD/zg0Pj3n4f3oQXKHH4cnVh8wgMxYnlVra
	74zf2VFmqJdbKO8KFESFW+m5R1Ff3ZU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HW8z4pUnMDuUcyVt6GpRUA-1; Wed, 06 Dec 2023 14:29:32 -0500
X-MC-Unique: HW8z4pUnMDuUcyVt6GpRUA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2c9f594de2fso1500371fa.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 11:29:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701890970; x=1702495770;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sljBObNDGvGAqcWtvwFnUEKrACaMezHakqGzjYfrZeQ=;
        b=mXfLhQHSP4NGGGYV7ZE/LUA2VqdpW8Lf6fSDjH0wX+hKUpGR2JpiK3CTw/Nj5jHUG0
         0BjuFX/H9kKF0jOszLgrPYYZUFibszUoJFlv4UwcuQ1K4wb4CtPf+xvcD8wlRa4QJjvc
         xLHwrRLbueOnEysgwXBDq74lr0BYEpnY7OUDeGaT535SW9xgJpa1bDxW4/NjeLeT7M0M
         MYPpW35geEvwNCzsaxc4nnY7YkCovq4Aihz2WKw7R/VLmUXIXYWKGUGt5nH/KM0GZj7y
         6nfFHognNi5NyuoHYIdcp4hJIR9Ui3WZcMhK5ekva3pFvfx8gHLNJLfnpzvwpX8HsHzG
         M5eQ==
X-Gm-Message-State: AOJu0YwIVajkmANpJ4nSac/p+gM2fkewdIir0ovPQcPR0IkNmKxsG5L3
	ssXDWSOeS/L1nxaB5h5GSi3PajQbvH9AmIsYJAygGUc2n3dy69nGwsXsVLdUlYblsbz9GAjgjyJ
	sHJqxz4CPD1Ub
X-Received: by 2002:a2e:7816:0:b0:2c9:f68f:541f with SMTP id t22-20020a2e7816000000b002c9f68f541fmr901167ljc.10.1701890970612;
        Wed, 06 Dec 2023 11:29:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4J9f99EcqypXlRDzp4mLmjhXquMG22fvmBx1RKBtE2OENiiupNKSeRu7CFOiH9uaaAHS9RA==
X-Received: by 2002:a2e:7816:0:b0:2c9:f68f:541f with SMTP id t22-20020a2e7816000000b002c9f68f541fmr901163ljc.10.1701890970239;
        Wed, 06 Dec 2023 11:29:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id dc8-20020a170906c7c800b00a1c85124b08sm327152ejb.94.2023.12.06.11.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 11:29:29 -0800 (PST)
Message-ID: <f6f51261-7571-4713-a052-f232c8b2bfee@redhat.com>
Date: Wed, 6 Dec 2023 20:29:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 for-8.2] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Lara Lazier <laramglazier@gmail.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 kvm@vger.kernel.org
References: <20231206155821.1194551-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20231206155821.1194551-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/6/23 16:58, Michael Roth wrote:
> Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> exposed a long-running bug in current KVM support for SEV-ES where the
> kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> kernel, in which case EFER write traps would result in KVM eventually
> seeing MSR_EFER_LMA get set and recording it in such a way that it would
> be subsequently visible when accessing it via KVM_GET_SREGS/etc.
> 
> However, guest kernels currently rely on MSR_EFER_LMA getting set
> automatically when MSR_EFER_LME is set and paging is enabled via
> CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> MSR_EFER_LMA bit, even though it is set internally, and when QEMU
> subsequently tries to pass this EFER value back to KVM via
> KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> which is now considered fatal due to the aforementioned QEMU commit.
> 
> This can be addressed by inferring the MSR_EFER_LMA bit being set when
> paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> the expected bits are all present in subsequent handling on the host
> side.
> 
> Ultimately, this handling will be implemented in the host kernel, but to
> avoid breaking QEMU's SEV-ES support when using older host kernels, the
> same handling can be done in QEMU just after fetching the register
> values via KVM_GET_SREGS*. Implement that here.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Cc: Philippe Mathieu-Daudé <philmd@linaro.org>
> Cc: Lara Lazier <laramglazier@gmail.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Cc: kvm@vger.kernel.org
> Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   target/i386/kvm/kvm.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 11b8177eff..4ce80555b4 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3643,6 +3643,10 @@ static int kvm_get_sregs(X86CPU *cpu)
>       env->cr[4] = sregs.cr4;
>   
>       env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
> +        env->cr[0] & CR0_PG_MASK) {
> +        env->efer |= MSR_EFER_LMA;
> +    }
>   
>       /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
>       x86_update_hflags(env);
> @@ -3682,6 +3686,10 @@ static int kvm_get_sregs2(X86CPU *cpu)
>       env->cr[4] = sregs.cr4;
>   
>       env->efer = sregs.efer;
> +    if (sev_es_enabled() && env->efer & MSR_EFER_LME &&
> +        env->cr[0] & CR0_PG_MASK) {
> +        env->efer |= MSR_EFER_LMA;
> +    }
>   
>       env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
>   

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks.  We can change it for 9.0 (especially adding a comment, because 
long term having it only in the commit message isn't great) but for now 
it's safe.

Paolo


