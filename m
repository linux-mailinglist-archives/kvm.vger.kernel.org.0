Return-Path: <kvm+bounces-4462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC168812C95
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AE95B2118E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF0F3B2A2;
	Thu, 14 Dec 2023 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cetuARQw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE94E3
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702548825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kDMg3HUsC1D+7iMcfX6C49T0/PYwQi9wuLRR5tvdCBQ=;
	b=cetuARQw5MkeyzHiUK8Wngwpj++u7RtHx6RkdJA2Q6IU4vxxH139sXZVI+GQwb2zF7KyoO
	AlJy0SBCrcjkhj+NeDy7nP1xxWl7PQh5iUXHGYj2bc3pj0xfn30s97DbMLGP61Y8xZvYPW
	sc79u6F0R+B4Vf879Pjyf+/AxJyILOU=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-XUffS1e5Nqu57mZ4qsE2tg-1; Thu, 14 Dec 2023 05:13:43 -0500
X-MC-Unique: XUffS1e5Nqu57mZ4qsE2tg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b8b66d49easo11630520b6e.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 02:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548823; x=1703153623;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kDMg3HUsC1D+7iMcfX6C49T0/PYwQi9wuLRR5tvdCBQ=;
        b=liDX9/nngbKIfRyopWNhgmfZ1/AeLBYdFVSD6BTjLc5qfWW1GsDFTUJNEt1QWlvE8r
         wPfvuL35nTpfn+fGqieSShAG4uCnlrQCFufw36AqZr3uaRLAU+EWG6tTbl0pgQ7aCTgx
         3bMBJ9SykjUiSM/E+d0pxpH2sdF2Rys7gNuFmYVEmxyzpb+AcF+UF8vWrY9O+Zfu9/NS
         Jykil546iJs/EtBXHTOZUB0Gof9qBONyGJjJ40Rmfu0x6RMfamWYmz9b1TtUoG6wm7yM
         Wz66V7jcsoe2ncZbJIYPDfp90LaVqMLlh4bLuUaKWaSLEpx3oa0G960I923rsnKQLacH
         2Bqg==
X-Gm-Message-State: AOJu0Yyd5C1f3bdp64Rc0WrGuTE1EeLSiQ2MkZtwn/TUoLEqZM+7xHpV
	yjNdMWfg0Ywa69Uygt+No9ZcWSBvEiTlvDXfTrTlG+4G5UPHyPgUnz2gtbJutlhY+gJSdWrtiEZ
	Mva+hpDNAhheH
X-Received: by 2002:a05:6358:9dae:b0:170:26c3:ae83 with SMTP id d46-20020a0563589dae00b0017026c3ae83mr8097284rwo.57.1702548823110;
        Thu, 14 Dec 2023 02:13:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFB8csX1ryjDrxVFDCJY0uU76NV+YESezciiIbJoADXQAiSZe/NmTA3B8WcS0+AnSTCcwNpzQ==
X-Received: by 2002:a05:6358:9dae:b0:170:26c3:ae83 with SMTP id d46-20020a0563589dae00b0017026c3ae83mr8097264rwo.57.1702548822646;
        Thu, 14 Dec 2023 02:13:42 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id et2-20020a056214176200b0067f02d13157sm804679qvb.15.2023.12.14.02.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Dec 2023 02:13:42 -0800 (PST)
Message-ID: <b3882f12-04e0-4293-9f94-19895b182d2f@redhat.com>
Date: Thu, 14 Dec 2023 11:13:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] KVM: selftests: aarch64: Fix the buggy
 [enable|disable]_counter
Content-Language: en-US
To: Shaoqin Huang <shahuang@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231129072712.2667337-1-shahuang@redhat.com>
 <20231129072712.2667337-4-shahuang@redhat.com>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20231129072712.2667337-4-shahuang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaoqin,

On 11/29/23 08:27, Shaoqin Huang wrote:
> In general, the set/clr registers should always be used in their
> write form, never in a RMW form (imagine an interrupt disabling
> a counter between the read and the write...).
> 
> The current implementation of [enable|disable]_counter both use the RMW
> form, fix them by directly write to the set/clr registers.
> 
> At the same time, it also fix the buggy disable_counter() which would
> end up disabling all the counters.
> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> ---
>  tools/testing/selftests/kvm/include/aarch64/vpmu.h | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/vpmu.h b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> index e0cc1ca1c4b7..644dae3814b5 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/vpmu.h
> @@ -78,17 +78,13 @@ static inline void write_sel_evtyper(int sel, unsigned long val)
>  
>  static inline void enable_counter(int idx)
>  {
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenset_el0);
> +	write_sysreg(BIT(idx), pmcntenset_el0);
>  	isb();
>  }
>  
>  static inline void disable_counter(int idx)
>  {
> -	uint64_t v = read_sysreg(pmcntenset_el0);
> -
> -	write_sysreg(BIT(idx) | v, pmcntenclr_el0);
> +	write_sysreg(BIT(idx), pmcntenclr_el0);
>  	isb();
>  }
>  


