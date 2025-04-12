Return-Path: <kvm+bounces-43193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B3EA86D55
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 15:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99AEE189593E
	for <lists+kvm@lfdr.de>; Sat, 12 Apr 2025 13:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E57F1DE2BF;
	Sat, 12 Apr 2025 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="oN+dCYA2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A051D2367CC
	for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744465519; cv=none; b=CY5iLhvRjn021OZR2az6e6lQt73d7kZdr0fg8V9ncT+7VYKhk1zl9rvcKDvfrJUd4qORvQRRaxLQCow3nAUxhYtJl5cRXGvRkqA3W67w8ppJayeVCXaRAslLFmapiNZZZdVVqAtbNCCkgiGE4Sy2poMluUzJj11mpP/m0dFKH7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744465519; c=relaxed/simple;
	bh=yGWnzvK9QlEeI5U3VsJPUWds5n3Pky4awX1FVsHrVEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPVmLB1S/h7xs0Gj3tvHfPHTcKlodOwpZSgtRK4O4O303oPhh4IpTAR3tot7p+Er6qdqOiWxiyiMqkuITvVMzf1IybCl73DPFizSDIYk9d709eDQjKb8Lrcq1yd7J+9qpVT+EOSVrja/IvMDXfRxkP4TwEG0siPwRN68eq21xjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=oN+dCYA2; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43edb40f357so24347895e9.0
        for <kvm@vger.kernel.org>; Sat, 12 Apr 2025 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1744465516; x=1745070316; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q+PTisbOYZ2Qwu/8sMQ4cLoOEg0RHZSBhZtKop+FLVc=;
        b=oN+dCYA2XDpw8FxpodLXYPQCPSYbiCeqpzO2HzjhSDJU5S9lEym7x0sRcOyu46o2lQ
         JHt3PmJUD4Atyz44Rp7FuuP4ziWqSRH7S1aSK27js3RvitEBQW6Ki3l1mVXBRFn4tU5w
         Fk4OBlVSx50x/NKNUzifEdKFoEeczbzbBzTjA55SZcZKzAYqV/FrKOFNFhPG2Gvovoln
         dBZADASOsDPpciwW1lKEZbPs+iQ1AdFOI7CRkPo0gvMcc98PoJLlH15POOpHMjnRKfiQ
         LbaqN3BOPBtxdQ8Y9ch6vscSvgWJL4bjKcFC6ldpPNe81QrWL0pnfxJHqNe/re6xMYui
         UMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744465516; x=1745070316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+PTisbOYZ2Qwu/8sMQ4cLoOEg0RHZSBhZtKop+FLVc=;
        b=TrzoGreBKyYLsjCI9Nxgxtc6/mmS6iJtp/BORkk74rklFbimxgPPkIzbKzrCj1aefE
         zeh3mX1yEt5HgI/2mvOX+fbf1sMh5mJjP6yjYoVOsqr8k6/NUnlUcJmmAlmjk8T8mImL
         JcZ20+UY5+nIDaJBjAfNHiE6MWxOZLqfVrOjUY2JYrGNfhwYdcNl0qMOz13NG2ehq1wt
         qmaEhcozmXl+we8hqog1eZmh68ihio2bnhZunjg4QOTEbxdZvopTJcQN2OM1wRZJHLBo
         cAv3X1zinyEouceOu34VWYVn9VLWfP49B09MCGm7445IIsRZ5ZPV7c032n7YfxR39q9O
         7iDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjDQ75Ts2Oco7j5u6iZ8qnVQU3RSP1ETLySbhHJKb+XxWc8jgFynK5VZ191AGvLN8k5UQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjNk4cxXeb1KY1nr+1bRQLlVgRVSwyZvGwRFPY9CloBiwJJtoX
	CAd+Y5lDi4oHOgQDrS5DkqjNokWxyl5cCgMlMah6+BPHJ3bkq+HBDaD+p+BRtgI=
X-Gm-Gg: ASbGncvZidfrfX00u5i1F6g/wQZJUxe+e25kFRf+c9Jo5DmPQa1Sbu1WpQ7pkmI2V+7
	fsOpa2l4hcY7vhu0jFnP9xrGpFHVUJlaRRCAL6N0ACqPd5Sy36ubAXCmylwTmRm3YfkeYTXRePt
	vFbgYXnisdw70XjEAmAK3qh7eptsjOZTnopQycLEo9656ZmV3D7yK9YyWIP0aPGGoc6NelRMvPD
	LOkFj4gYrtlxDAq4SGltENvs8WBtk++YR9bSMWgpv8H1Pk8BdxJpsVU7pCnYjyZTUED5qwVSzbp
	B8T2b0vW1nSMacB4gzFbP3FbZmMEFQf8cyzUlfxU6ayaysyVFXDew3wPlGrdMOyhRT8DkgX77zY
	lcKfz
X-Google-Smtp-Source: AGHT+IHOggjW4ANei8+xfx2xYGSLpaAiQhy8R8hFdGmjQUvWrfEGBCXt+dyjNPjiCGY1JREcJFIGGg==
X-Received: by 2002:a05:600c:46d0:b0:43d:209:21fd with SMTP id 5b1f17b1804b1-43f3a9b02b3mr61950195e9.30.1744465515805;
        Sat, 12 Apr 2025 06:45:15 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39eae977513sm5044750f8f.42.2025.04.12.06.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 06:45:15 -0700 (PDT)
Date: Sat, 12 Apr 2025 15:45:13 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 10/10] riscv: Allow including extensions in the
 min CPU type using command-line
Message-ID: <20250412-bc81866c2227ed98429f86b5@orel>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
 <20250326065644.73765-11-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326065644.73765-11-apatel@ventanamicro.com>

On Wed, Mar 26, 2025 at 12:26:44PM +0530, Anup Patel wrote:
> It is useful to allow including extensions in the min CPU type on need
> basis via command-line. To achieve this, parse extension names as comma
> separated values appended to the "min" CPU type using command-line.
> 
> For example, to include Sstc and Ssaia in the min CPU type use
> "--cpu-type min,sstc,ssaia" command-line option.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 4c018c8..9cefd2f 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info
>  	return true;
>  }
>  
> +static void __min_cpu_include(const char *ext, size_t ext_len)

s/include/enable/

> +{
> +	struct isa_ext_info *info;
> +	unsigned long i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
> +		info = &isa_info_arr[i];
> +		if (strlen(info->name) != ext_len)
> +			continue;
> +		if (!strncmp(ext, info->name, ext_len))

strcmp should be fine here since we already checked length.

> +			info->min_cpu_included = true;
> +	}
> +}
> +
>  bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
>  {
>  	struct isa_ext_info *info = NULL;
> @@ -128,16 +142,39 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
>  int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
>  {
>  	struct kvm *kvm = opt->ptr;
> +	const char *str, *nstr;
> +	int len;
>  
> -	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
> +	if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&

If arg == 'min', then it can't be less than 3 so the '|| strlen(arg) < 3'
is dead code.

> +	    (strncmp(arg, "max", 3) || strlen(arg) != 3))

I think we want

 if (strlen(arg) < 3 ||
     (strlen(arg) == 3 && strcmp(arg, "min") && strcmp(arg, "max")) ||
     strncmp(arg, "min", 3))

>  		die("Invalid CPU type %s\n", arg);
>  
>  	if (!strncmp(arg, "max", 3))
>  		kvm->cfg.arch.cpu_type = "max";
>  
> -	if (!strncmp(arg, "min", 3))
> +	if (!strncmp(arg, "min", 3)) {
>  		kvm->cfg.arch.cpu_type = "min";
>  
> +		str = arg;
> +		str += 3;
> +		while (*str) {
> +			if (*str == ',') {
> +				str++;
> +				continue;
> +			}
> +
> +			nstr = strchr(str, ',');
> +			if (!nstr)
> +				nstr = str + strlen(str);
> +
> +			len = nstr - str;
> +			if (len) {

I think len will always be nonzero since *str isn't \0 and we ate all
consecutive ,'s above. __min_cpu_include() is also safe to call with
len=0, so we could drop this check.

> +				__min_cpu_include(str, len);
> +				str += len;
> +			}
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 2.43.0
>

Thanks,
drew

