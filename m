Return-Path: <kvm+bounces-25517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D4596619C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC4F4281574
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E966199951;
	Fri, 30 Aug 2024 12:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NBM7DXFQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376C815C12D
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725020841; cv=none; b=esku1QO0xybdEcXER1zNlxyln/pW1ntUF36D5AXpCR0bJcQlWDRJQXjQS/TYG0wDRHmPM0Hk4O6eku+2+v/bh0+Bra8vHwvp98viWIM+e6+6nMG3QlRZ/PxCYEvLVHcm7nthAvoxJoB6sF+sQ/9HhVmWpqNEVwvx4RkMQZqQQhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725020841; c=relaxed/simple;
	bh=ur0JWyShQgoQopaWpJTcRJZt1xbVa2943ENTjGpAUA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SokHMiOmZ2rwj1BGdw5Af1XvMNSTphwm7LhwOM5o1GyIOQ6jH5tEO77eDDaiGp5K7P3Unlkv0vaXjy8SLpOoctkGj+z/fvmI3tp99uFniD71npHGlPUINt4w6ek0o4i7ZnWd+W0lbbU+ok5IqZtB8Iw+rNdgEvEl16u+Iq9Nrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NBM7DXFQ; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a8695cc91c8so172582266b.3
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 05:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725020837; x=1725625637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NE74wxGwsCKlZLA7ems9OjPNaFhB2GRCRAeyjJDrX+w=;
        b=NBM7DXFQ7FAn9p5WN8EEnw05TWWPWz74cF0NOTkymuOV+t2oieDmEywtvnTBLtiAu/
         40YlrsBOv2qfBlljLBm5f1pRKt+TySpbYLzgjhyPEuXh2WG+o9qUwypnNkwXB8/RR5Us
         8YivUMUPHtZQbYdp8ACM7xaRx3R0eRSEI4c/7AMb0fE49F2EbBBB1nBGVKnGQKjPNGdk
         EG1ALELVj/GkQuS+lDHdP5iP+WxtKCjzpI1S4Hz4c+MQp6ZrEKwaoQWJRYtY3kGNqNgy
         bz1JEuA10uspqGVayQktX24jL0h0LS6JsBFznzE7esJ+CrJAvawdu5W3NqJ/u/lARi63
         mJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725020837; x=1725625637;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NE74wxGwsCKlZLA7ems9OjPNaFhB2GRCRAeyjJDrX+w=;
        b=JhsA4DuVbRuSNUYhJ46AUoEP4kVuGktzYuHUKqVWdGwCNGrq+KTvMqbjH821q09ouj
         bfzxiLohDQawoud9QAFWDrT6G9cdOfzL829MyAUR3vY8Hhw8IohM62J3XFBIc+V292k8
         iuN6TR7jjGO4ymmxeAtwyuCb3JOK9/t/Iyd5nK2Jwr3bje6cwjvrVeF4gUi3uR8BylUF
         kI035nm2r43Bg/8tLqjgiq/gMyrUbRN7j0SqRNwTK++f3TQXXTMd1lnrbDW8dtyVxZSu
         IJpzwGUjrcxITeTd+0l+c2qYDR587C2TQnbwT3WSCR/qYOy4MYjIsVIQ29NjA0dgLb+r
         MbmA==
X-Forwarded-Encrypted: i=1; AJvYcCU8aO5B0S9TliaNA7LsP5o4dCXfRa2BCuMU271D0yzxTK/3QYwQY77J0CJSAvghBktcOOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPp+Z/EYKXeWmfAoU/z41kvLltdLRi9oGB6XJbUZr/303YELMA
	NZ+1X6meFZPLFgLmIY+jxjm0VMsx0I4xh082+0xYPPlSzQtF8R7xAb5PQ4hK9QU=
X-Google-Smtp-Source: AGHT+IFwGTUaqlFFzSyRSdCyCgSrH1k0+wuZKY9klMeJF2RQGjHYW71f2iHG128z/xGmHE0xY1TD2A==
X-Received: by 2002:a17:907:6d28:b0:a86:a9a4:69fa with SMTP id a640c23a62f3a-a897fa72317mr519196666b.43.1725020837027;
        Fri, 30 Aug 2024 05:27:17 -0700 (PDT)
Received: from [10.20.4.146] (212-5-158-102.ip.btc-net.bg. [212.5.158.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989035f02sm210237266b.89.2024.08.30.05.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 05:27:16 -0700 (PDT)
Message-ID: <02c06646-a8c9-45ae-9836-33f70aefccea@suse.com>
Date: Fri, 30 Aug 2024 15:27:12 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/8] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com, adrian.hunter@intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <9b55398a1537302fb7135330dba54e79bfabffb1.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 27.08.24 г. 10:14 ч., Kai Huang wrote:
<snip>

> [2] Convertible Memory Regions of the problematic platform:
> 
>    virt/tdx: CMR: [0x100000, 0x6f800000)
>    virt/tdx: CMR: [0x100000000, 0x107a000000)
>    virt/tdx: CMR: [0x1080000000, 0x207c000000)
>    virt/tdx: CMR: [0x2080000000, 0x307c000000)
>    virt/tdx: CMR: [0x3080000000, 0x407c000000)
> 
> Fixes: dde3b60d572c9 ("x86/virt/tdx: Designate reserved areas for all TDMRs")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

<snpi>

> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 105 ++++++++++++++++++++++++++++++------
>   arch/x86/virt/vmx/tdx/tdx.h |  13 +++++
>   2 files changed, 102 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 0fb673dd43ed..fa335ab1ae92 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -331,6 +331,72 @@ static int get_tdx_sys_info_version(struct tdx_sys_info_version *sysinfo_version
>   	return ret;
>   }
>   
> +/* Update the @sysinfo_cmr->num_cmrs to trim tail empty CMRs */
> +static void trim_empty_tail_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		u64 cmr_base = sysinfo_cmr->cmr_base[i];
> +		u64 cmr_size = sysinfo_cmr->cmr_size[i];
> +
> +		if (!cmr_size) {
> +			WARN_ON_ONCE(cmr_base);
> +			break;
> +		}
> +
> +		/* TDX architecture: CMR must be 4KB aligned */
> +		WARN_ON_ONCE(!PAGE_ALIGNED(cmr_base) ||
> +				!PAGE_ALIGNED(cmr_size));
> +	}
> +
> +	sysinfo_cmr->num_cmrs = i;
> +}
> +
> +static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
> +{
> +	int i, ret = 0;
> +
> +#define TD_SYSINFO_MAP_CMR_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, sysinfo_cmr, _member)
> +
> +	TD_SYSINFO_MAP_CMR_INFO(NUM_CMRS, num_cmrs);
> +
> +	if (ret)
> +		return ret;
> +
> +	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
> +		TD_SYSINFO_MAP_CMR_INFO(CMR_BASE(i), cmr_base[i]);

Yeah, this is just golden, not only are you going through 3 levels of 
indirection to expand the TD_SYSINFO_MAP but you also top it with one 
final one MD_FIELD_ID_CMR_BASE(i). I'm fine with the CMR_BASE/SIZE 
macros, but the way you introduce 3 levels of macros just to avoid typing

TD_SYSINFO_MAP(foo, bar, zoo)

makes no sense.

<snip>

