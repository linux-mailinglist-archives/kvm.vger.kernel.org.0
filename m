Return-Path: <kvm+bounces-34906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C98BBA07430
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 12:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 539861889C9C
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 11:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DD1B2163A2;
	Thu,  9 Jan 2025 11:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ek9XTOeF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706B1714D7;
	Thu,  9 Jan 2025 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736420858; cv=none; b=f8t0MjQdm1m6yx0lqCK105v0+iEF910yE5X3vX9SB8zmeH9hPzR2q085mLx72oo+dQT7jN04hdghYZTgHhmfzkvOI1ymyFetW4mU2z/YxG0SNVgfUAPM2S1Xqdl6RrxShEJywmAGjHIfzoYyH/+xRkpz5X2iPO19ZU5lP722s+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736420858; c=relaxed/simple;
	bh=F6e+zTKxdfMl6YB5qwF/ViD8pLNLaWg7ilrKQC+Ei88=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=uWjR0wTdQD9OTqu/FBngTn8fOiAjPwnTcAqlG/xqd78bLxxYxpzDrINhR3P2jqQp9TCZVWyE/zDY1PQqjSnnlZtgPU43rsN8+McBzBMTZ2favYYcJ0VRH5n9B3RUWGmzQksyxucsDy3bZgteIc1lXrMLHeN7aKSdUY3ttAxJTok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ek9XTOeF; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaec61d0f65so162032966b.1;
        Thu, 09 Jan 2025 03:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736420855; x=1737025655; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8OY6lYM84gjJNHGF++tX8YJgQyAji5W4KPsm1srlRg=;
        b=Ek9XTOeFATcqCl0tMQgk98OPmRB4gpPDbAvf2HJriUoJcUd3hw9aNOwfZio4JDmRyX
         nlITkfZKFwmBQcCY1SpK3S9IwEKN+okjxIK5yjnZhbjWiaT+4aQ3LujDaNNl0RuDFIFc
         M8Jgx9A4u/15gjG/YRL1oSIXFoGdPYjXHF8TK02jd4rakj4cpgn0kJrGyIEpuGx0NNNz
         Mwm5sv1jsPLOQgMHKpkqqhtopfqakS4PFGYzCzjEDlFl6shxcR9N6zpwDRN9hJ2TusDr
         aExv7jbbK6I+oaTUB8naPl32GfgyiXY/rkk0zNEErkR40SDv8jP8EQB1yhEfVYMx6N0f
         cJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736420855; x=1737025655;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S8OY6lYM84gjJNHGF++tX8YJgQyAji5W4KPsm1srlRg=;
        b=M8nXVkj9Oo0cLCvEUffkU3by+vppVeGcaOlsh65/my0D234nVxNyd2PoAqwW8BJUrU
         kjeymaBUFRYXh1v5F3jNDY81/6Vo9ih1+yGtTBoddK2uYjXK04gHBLkzMsBJADjNhM9D
         L79w/VjnCT3M5F7uN6xc36s/6szvwLZbTcRB1GcbDi1pPAmef8abBh5+cI3iEJyKWoms
         bm8zcjQi3FRrghokY/135WTl4j4Bk3NDdrHePKcO2zRQMpgf+M/garEoO3m66n1DZGBB
         /jnXiVwxaED7x2fReHQZtCIWy5LlLtF/HyEODF4UuoLcoYtyDCMC81ZZpTBe6nYabovD
         3w2A==
X-Forwarded-Encrypted: i=1; AJvYcCVV+5hS0fASaTGysLCHYRyP8DxM1vPRYqG8zLD8iFsB4x+xFfS58bG3zpLfuYYi1B5CLOo=@vger.kernel.org, AJvYcCVWn2Y8Gb4ygXrO8tzG53Knzk+4Ms6h5QskP5UnZBZZ1WiheKcGefr7gHbC555HmdVjDWZRT03nJFe/C2Oa@vger.kernel.org
X-Gm-Message-State: AOJu0YznmLCXHAztPr4XH1ILbcmwCTwgpBKffzIr3O4ceBupdS5NqkbT
	afzmJOQr4H80qxuJXMQKrgmnqWKl+ZUJFNJ9s9rUgv3WGgVimZaA
X-Gm-Gg: ASbGncvLELGaEB8Y3sRe+2YEl6M32MfLYxRPid78rMNb320Tgfpjcq2IERVe5Wl5xm4
	fg3OkFT/nmDa4OuahjJQKI19j4x3UiQCOStH7cf716g510jV6Lv7F3xIyqtsr9ARWlZPZWJqnF2
	NPulHrAtItAr1hiHXhYTRxQL20StF7xW1MxYfZr1NwiSnxnQWYJHBGk9vha+jBU91Wd2CStd1JR
	lwzKxbdK8D11yUoDko7Lf5MH4jL9gpFewZL+Srrpk3LGLSuLTHs+xLxD6XhBSPSUGUqGo/r6i/i
	cLC98wm54BaOgtrkrRsJvL8nKRSULMc9Iro=
X-Google-Smtp-Source: AGHT+IF8MX69XFzCSg6sHClCf00aWr58vf2b38+rmPg7jZkozvChGI0IoZuWM8bXWWkqLHv9hsn3HA==
X-Received: by 2002:a17:907:1c10:b0:aab:7588:f411 with SMTP id a640c23a62f3a-ab2ab6d6328mr504034866b.25.1736420854532;
        Thu, 09 Jan 2025 03:07:34 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:d27b:7be4:1cb:cca4? ([2001:b07:5d29:f42d:d27b:7be4:1cb:cca4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c956306bsm60229766b.104.2025.01.09.03.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2025 03:07:34 -0800 (PST)
Message-ID: <dcb03fc9d73b09734dee4110363cace369fc4d4c.camel@gmail.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: rick.p.edgecombe@intel.com
Cc: isaku.yamahata@gmail.com, kai.huang@intel.com, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 reinette.chatre@intel.com,  seanjc@google.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,  yan.y.zhao@intel.com
Date: Thu, 09 Jan 2025 12:07:32 +0100
In-Reply-To: <20241030190039.77971-25-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2024-10-30 at 19:00, Rick Edgecombe wrote:
> @@ -1055,6 +1144,81 @@ static int tdx_td_vcpu_init(struct kvm_vcpu
> *vcpu, u64 vcpu_rcx)
>  	return ret;
>  }
> =20
> +/* Sometimes reads multipple subleafs. Return how many enties were
> written. */
> +static int tdx_vcpu_get_cpuid_leaf(struct kvm_vcpu *vcpu, u32 leaf,
> int max_cnt,
> +				   struct kvm_cpuid_entry2
> *output_e)
> +{
> +	int i;
> +
> +	if (!max_cnt)
> +		return 0;
> +
> +	/* First try without a subleaf */
> +	if (!tdx_read_cpuid(vcpu, leaf, 0, false, output_e))
> +		return 1;
> +
> +	/*
> +	 * If the try without a subleaf failed, try reading subleafs
> until
> +	 * failure. The TDX module only supports 6 bits of subleaf
> index.

It actually supports 7 bits, i.e. bits 6:0, so the limit below should
be 0b1111111.

> +	 */
> +	for (i =3D 0; i < 0b111111; i++) {
> +		if (i > max_cnt)
> +			goto out;

This will make this function return (max_cnt + 1) instead of max_cnt.
I think the code would be simpler if max_cnt was initialized to
min(max_cnt, 0x80) (because 0x7f is a supported subleaf index, as far
as I can tell), and the for() condition was changed to `i < max_cnt`.

> +		/* Keep reading subleafs until there is a failure.
> */
> +		if (tdx_read_cpuid(vcpu, leaf, i, true, output_e))
> +			return i;
> +
> +		output_e++;
> +	}
> +
> +out:
> +	return i;
> +}
> +
> +static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct
> kvm_tdx_cmd *cmd)
> +{
> +	struct kvm_cpuid2 __user *output, *td_cpuid;
> +	struct kvm_cpuid_entry2 *output_e;
> +	int r =3D 0, i =3D 0, leaf;
> +
> +	output =3D u64_to_user_ptr(cmd->data);
> +	td_cpuid =3D kzalloc(sizeof(*td_cpuid) +
> +			sizeof(output->entries[0]) *
> KVM_MAX_CPUID_ENTRIES,
> +			GFP_KERNEL);
> +	if (!td_cpuid)
> +		return -ENOMEM;
> +
> +	for (leaf =3D 0; leaf <=3D 0x1f; leaf++) {
> +		output_e =3D &td_cpuid->entries[i];
> +		i +=3D tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
> +					     KVM_MAX_CPUID_ENTRIES -
> i - 1,

This should be KVM_MAX_CPUID_ENTRIES - i.

> +					     output_e);
> +	}
> +
> +	for (leaf =3D 0x80000000; leaf <=3D 0x80000008; leaf++) {
> +		output_e =3D &td_cpuid->entries[i];
> +		i +=3D tdx_vcpu_get_cpuid_leaf(vcpu, leaf,
> +					     KVM_MAX_CPUID_ENTRIES -
> i - 1,

Same here.


