Return-Path: <kvm+bounces-8641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9490853F39
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 23:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1E02B29FC4
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 22:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DBE64AAD;
	Tue, 13 Feb 2024 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pWtSMuw4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD993627EA
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 22:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707864452; cv=none; b=EudUASYILNGoEn3Z6Gs9thAOoEFhe4wgdF8X+zyPB4oFPTlA43g2hwda7Z6eUZ7ip+vxk02J5lxl9GJC+VSmr6kwRzpbWr9RwOTwSneyNwKyeFUdw+H6KvFUvaCwLHy3u7pbmc6rq6rbsQYF375JS7HcQ8hkJBKHTOHYEa3w3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707864452; c=relaxed/simple;
	bh=h6roo4nzai1plnwUDMJ8X4JCHbJwwjdVH3mZ5DCnk7U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HkLZw5KUENsSdCJzlhhHB940KyX3Srpee+lDXOIQNzXdPKFurJqDpt11aqoZ6CAzP6Q+kgQz0wXfBrxfEFP1/kOUq0JRv0uTu7YKf4zapC1ZNxvl5/O7N1ItpnJ7Kl974/ytcRNfa2s5J28sTCsXXXR/8kUYh4lGTvpeF7DvGR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pWtSMuw4; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso8311030276.3
        for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 14:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707864449; x=1708469249; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMLNcnuC5oAh9dkduNsu7ea1PmxDXxNMUX+9+b4QQbo=;
        b=pWtSMuw4ecLHQYXbJimVUZ/0qmWz9hjtvZ9VtEHx+T/NtYAnaDAraTYijL2reOKMRU
         hpxdC7GgOPGHR/oo82Up95IDvUMDbHJVXEX3fnGJl1P1+Tp76oj1EAK03E1zlo6jsAHf
         peqt/R+gZzaS+DUFy4ob1wVgXAkOQov0DV26pSF0eIR56zrRlF3OLIGXsUbjQ/Elm/iF
         LxwKNVaZrZqs+apZyxBm3DQHEkRNHrIpUuC+8bq8XaS67kVyGu8L7kFBPWEj0nOxUuvD
         6zfQNwptTSv+L5mn50r7EkWnZXu7Zv7MoJUoxTkmQtNu/H9P+4zUXonvQWrzpMx0OVZT
         aZAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707864449; x=1708469249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YMLNcnuC5oAh9dkduNsu7ea1PmxDXxNMUX+9+b4QQbo=;
        b=cqVed8tspnQW20nGp/okRhmEke80YAwls68+ralVbilhDqEv/P7E6SNIok6eDJq+64
         5PRg/FjISXzvU8xd/TbT9aPwG8QmODTNI+Q+lcpw30htsGo3UBlCEtSm/EDB0RBfe74M
         d1SSgz+R4/mxxaHPACpztyLsORF9dsMRRc34t7GC8Z847lDi0JUZ3CVlro1I/CnpUvHL
         HOOsJdhNVEVnS8wWmvTlB3jUlJx8+ZbZ9tYXzPDAcJTzt9MniE7hW1D93JXxAFPvM0QQ
         79kOhTlXVXYeMXJOu0kkTLtrLarPfeNfoj0fJsfaCvfRTHSQ5QA1s5nvTSXDdNcJRGV+
         eY9w==
X-Forwarded-Encrypted: i=1; AJvYcCUXHDiIpHHObd/Q7/FE4JpjcEa52FhH9kdpXbkUhGBcgAI63NJLV0582S2aIQ/QFJAulZ3dv3AOqswlylSOB4UWrfaR
X-Gm-Message-State: AOJu0YwD0saMa0eCgnnpOdu2h/kQ38JMgmrgKg2sUsZ7FJ6VyDf69e2z
	CjdHlZiI9tCxRg2Znpwoy/eUognDYsj0iIRNie1wXn1ai6dwArYM8V0T28e2tHAkG3fde6PP6fs
	MIQ==
X-Google-Smtp-Source: AGHT+IF252kSBEQS48Y/ROryQIMgImMVNQDVJMPHGUyo6F8rUBPDvDjGb/zGZ5wS5MOW9teIbcz3suG4nk4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150d:b0:dc6:e1ed:bd1a with SMTP id
 q13-20020a056902150d00b00dc6e1edbd1amr177506ybu.2.1707864448755; Tue, 13 Feb
 2024 14:47:28 -0800 (PST)
Date: Tue, 13 Feb 2024 14:47:27 -0800
In-Reply-To: <20240206182032.1596-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240206182032.1596-1-xin3.li@intel.com>
Message-ID: <Zcvxf-fjYhsn_l1F@google.com>
Subject: Re: [PATCH v5 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin3.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	weijiang.yang@intel.com, kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

Please send cover letters for series with more than one patch, even if there are
only two patches.  At the very least, cover letters are a convenient location to
provide feedback/communication for the series as a whole.  Instead, I need to
put it here:

I'll send a v6 with all of my suggestions incorporated.  I like the cleanups, but
there are too many process issues to fixup when applying, a few things that I
straight up disagree with, and more aggressive memtype related changes that can
be done in the context of this series.

On Tue, Feb 06, 2024, Xin Li wrote:
> Define VMX basic information fields with BIT_ULL()/GENMASK_ULL(), and
> replace hardcoded VMX basic numbers with these field macros.
> 
> Save the full/raw value of MSR_IA32_VMX_BASIC in the global vmcs_config
> as type u64 to get rid of the hi/lo crud, and then use VMX_BASIC helpers
> to extract info as needed.
> 
> VMX_EPTP_MT_{WB,UC} values 0x6 and 0x0 are generic x86 memory type
> values, no need to prefix them with VMX_EPTP_.

*sigh*

This obviously, like super duper obviously, should be at least three distinct
patches.  The changelog has three paragraphs that have *zero* relation to each
other, and the changelog doesn't even cover all of the opportunistic cleanups
that are being done.

> +/* x86 memory types, explicitly used in VMX only */
> +#define MEM_TYPE_WB				0x6ULL
> +#define MEM_TYPE_UC				0x0ULL

No, this is ridiculous.  These values are architectural, there's no reason for
KVM to have yet another copy.  The MTRRs #defines have goofy names, and are
incomplete, but it's trivial to move the enums from pat/memtype.c to msr-index.h.

> @@ -505,8 +521,6 @@ enum vmcs_field {
>  #define VMX_EPTP_PWL_5				0x20ull
>  #define VMX_EPTP_AD_ENABLE_BIT			(1ull << 6)
>  #define VMX_EPTP_MT_MASK			0x7ull
> -#define VMX_EPTP_MT_WB				0x6ull
> -#define VMX_EPTP_MT_UC				0x0ull

I would strongly prefer to keep the VMX_EPTP_MT_WB and VMX_EPTP_MT_UC defines,
at least so long as KVM is open coding reads and writes to the EPTP.  E.g. if
someone wants to do a follow-up series that adds wrappers to decode/encode the
memtype (and other fiels) from/to EPTP values, then I'd be fine dropping these.

But this:


	/* Check for memory type validity */
	switch (new_eptp & VMX_EPTP_MT_MASK) {
	case MEM_TYPE_UC:
		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT)))
			return false;
		break;
	case MEM_TYPE_WB:
		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_WB_BIT)))
			return false;
		break;
	default:
		return false;
	}

looks wrong and is actively confusing, especially when the code below it does:

	/* Page-walk levels validity. */
	switch (new_eptp & VMX_EPTP_PWL_MASK) {
	case VMX_EPTP_PWL_5:
		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_PAGE_WALK_5_BIT)))
			return false;
		break;
	case VMX_EPTP_PWL_4:
		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_PAGE_WALK_4_BIT)))
			return false;
		break;
	default:
		return false;
	}

>  static inline bool cpu_has_virtual_nmis(void)
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 994e014f8a50..80fea1875948 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1226,23 +1226,29 @@ static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
>  	return (superset | subset) == superset;
>  }
>  
> +#define VMX_BASIC_FEATURES_MASK			\
> +	(VMX_BASIC_DUAL_MONITOR_TREATMENT |	\
> +	 VMX_BASIC_INOUT |			\
> +	 VMX_BASIC_TRUE_CTLS)
> +
> +#define VMX_BASIC_RESERVED_BITS			\
> +	(GENMASK_ULL(63, 56) | GENMASK_ULL(47, 45) | BIT_ULL(31))

Looking at this with fresh eyes, I think #defines are overkill.  There is zero
chance anything other than vmx_restore_vmx_basic() will use these, and the feature
bits mask is rather weird.  It's not a mask of features that KVM supports, it's
a mask of feature *bits* that KVM knows about.

So rather than add #defines, I think we can keep "const u64" variables, but split
into feature_bits and reserved_bits (the latter will have open coded GENMASK_ULL()
usage, whereas the former will not).

BUILD_BUG_ON() is fancy enough that it can detect overlap.

> @@ -6994,6 +7000,9 @@ static void nested_vmx_setup_misc_data(struct vmcs_config *vmcs_conf,
>  	msrs->misc_high = 0;
>  }
>  
> +#define VMX_BSAIC_VMCS12_SIZE	((u64)VMCS12_SIZE << 32)

Typo.

> +#define VMX_BASIC_MEM_TYPE_WB	(MEM_TYPE_WB << 50)

I don't see any value in either of these.  In fact, I find them both to be far
more confusing, and much more likely to be incorrectly used.

Back in v1, when I said "don't bother with shift #defines", I was very specifically
talking about feature bits where defining the bit shift is an extra, pointless
layer.  I even (tried) to clarify that.

