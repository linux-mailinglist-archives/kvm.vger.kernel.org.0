Return-Path: <kvm+bounces-18935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A258FD27A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D739F283240
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D279E14E2FD;
	Wed,  5 Jun 2024 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F1TbHa9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF28E450EE
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717603667; cv=none; b=gpX8lUQd4GJ9nBmWE+fVMwyUXwF/v1UOErmIYDrhWqsz9ncuTDY06roWqddLJQQB6WRNObrcBmIYEu/AbnekAAQyP+yypIaI0XhGD7EWIm7nkSCPjcUudAz5H/sw4eDGfMZnS5By4smfumKyi1rYrSKgkUqFFhNP92w2tlGCj3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717603667; c=relaxed/simple;
	bh=/jVVWTJswohB/xqf/Gk2VHDxpZAppubI4Kdh3jqkrHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jq8N4Dc1BEIG9WMI1+TK6fx2KSpRnaN5QvIr3L2d5jN24+WmbVX+usfjrKWCU20fVMb90l/751whazCUvwzO7uYG5C7caDPx3QhrUSH3blhz3JeGJlosWg5YxXpi5LFEnAruBVzwZ1S59xjh8gtxp7xEerKaWdy8/3sQS9wDIVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F1TbHa9l; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a089511f9so13850687b3.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 09:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717603665; x=1718208465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2UNnoSekoeKYnabVPGwKngI8E4fbSorCl1htpPyd+mE=;
        b=F1TbHa9lbHAfD4tb70wowGQoBlk9XIyH9uWQxcLhmQSzfb1f4/py12VEvAA3C1ma1u
         X23NEETrOKaqWcfI4f8j3Sd4UsEcDxTyp6EQ4rWCWxguW88N0GtXf/DtoxxJ8O2yciWV
         C+r52AULAvpdcYeGyjJEYvu/nc6XZETJlfC34DtcJgZKERkQEROIsr5bQx0gYyMBqqG8
         TFz2eJW4/qJ/2qOShNLWh28iVREYXvmi1pt7Irb78J38I1pbQIOn/bjdKG3Vz6oMyGa7
         G+l9WmFyZ7wuihLw4L5oFvj9aXGKAiq6vKNU9TJAUHi/HsBL/H0YS2mdwMEdUFmg5naw
         dlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717603665; x=1718208465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UNnoSekoeKYnabVPGwKngI8E4fbSorCl1htpPyd+mE=;
        b=DKPqpdOsJxpkDj1Q8+HfNP3BOVZLbDg+9qnd+g/sdTstyEGAg0lEyt9zI8xJiICNRK
         g9ZevtzVafjVoqfgNMC27oXjgAnMvVkrX7jgiPujVOseAOXs8owSnW1VmnTSEW4rDa/W
         sm3uhTVwKkElf01sEFjrB1315UdZRGO5+toatocd8qwdoTK8dFmKEhyytnP6uEYqCuCC
         op4GWZfdpOQmjnDW+DDMrAU1yEUDpY0+GgJCrsR7Ak3+qjWakO9eJBi7AOgsqyko55G2
         HVucwDkYOx7k/DD8MlKGTITjd1y3c6rGpxS7vry+MMHh2V28EVEublyCXk2RFPFDDaD2
         R9JA==
X-Gm-Message-State: AOJu0Yzr9hGqUFvnVqW+9K28XQ9kJudl9pKOE459vL8+FkmvK/5SJUoL
	5kB+3UnYP+EVp3bn42ON0o6AplWRby9OVnpG2uMAOonVfLsuuZQaXFVQkWuMUioiogEiynEslBl
	ybQ==
X-Google-Smtp-Source: AGHT+IE5ephoLz0X6YnnMEbW925VOGtUHo1NLjvzAkIJDoMaEaX30Po+eafLnUULwPSIqzVtY3iwkBjoExE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f0f:b0:dfa:79ab:d5b6 with SMTP id
 3f1490d57ef6-dfade9a1f47mr8791276.1.1717603664754; Wed, 05 Jun 2024 09:07:44
 -0700 (PDT)
Date: Wed, 5 Jun 2024 09:07:43 -0700
In-Reply-To: <20240419161623.45842-9-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240419161623.45842-1-vsntk18@gmail.com> <20240419161623.45842-9-vsntk18@gmail.com>
Message-ID: <ZmCNT4vkG9_SGY0S@google.com>
Subject: Re: [kvm-unit-tests PATCH v7 08/11] x86: AMD SEV-ES: Handle CPUID #VC
From: Sean Christopherson <seanjc@google.com>
To: vsntk18@gmail.com
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	papaluri@amd.com, andrew.jones@linux.dev, 
	Vasant Karasulli <vkarasulli@suse.de>, Varad Gautam <varad.gautam@suse.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 19, 2024, vsntk18@gmail.com wrote:
> +static inline void sev_es_wr_ghcb_msr(u64 val)
> +{
> +	wrmsr(MSR_AMD64_SEV_ES_GHCB, val);
> +}
> +
> +static inline u64 sev_es_rd_ghcb_msr(void)
> +{
> +	return rdmsr(MSR_AMD64_SEV_ES_GHCB);
> +}

These are silly, they just add a layer of obfuscation.  It's just as easy to do:

	wrmsr(MSR_AMD64_SEV_ES_GHCB, __pa(ghcb));

> +
> +

Extra newline.

> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					  struct es_em_ctxt *ctxt,
> +					  u64 exit_code, u64 exit_info_1,
> +					  u64 exit_info_2)
> +{
> +	enum es_result ret;
> +
> +	/* Fill in protocol and format specifiers */
> +	ghcb->version = GHCB_VERSION;
> +	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
> +
> +	ghcb_set_sw_exit_code(ghcb, exit_code);
> +	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> +	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));

