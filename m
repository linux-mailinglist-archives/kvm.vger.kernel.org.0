Return-Path: <kvm+bounces-17734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 931DB8C9189
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 17:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9661F21838
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 15:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61AB945035;
	Sat, 18 May 2024 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiZjDZ5o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B95E1773A;
	Sat, 18 May 2024 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716046146; cv=none; b=YCAYgb4MY1yEW9bbK/UTj6jP2KnxlLv5qnJ/9eaqjvzeV/IwYJKyTN4Jz2bh+tqn7OZU3KXVyyjGJd6ln1cnwUY0hSCoh7Eazl9HSeJOII7psi/QlxzzlwfQbMmOYa/eSKd9neoPIMlT0QSMhGjTHC+idC+UqHzDacUrFujX4Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716046146; c=relaxed/simple;
	bh=0oWWlE3oDhEW0XamtqcFvDPIPwOclTeWmexU0R6AMOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWJwa7T8aVY2kUe+wmc15VR2eQP7lVjb3RCuQIbeaXfG77Vn1gQaCTmuZF/C8HZSsE8nJj4hKZA3KTJgOXFV9g2xenT1EvoncJHNieXPgQszT7aEwXevV2MoTmhPpmnQI0RbsFkahk3MRm8iXg2KsyYn2OOUJcMRJelZQnjtaX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WiZjDZ5o; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5b277a61f6fso884066eaf.1;
        Sat, 18 May 2024 08:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716046144; x=1716650944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YcGBSUjyXOA1JpVYvoN1EuahOO06ajza5ZUGXHQ/tYE=;
        b=WiZjDZ5oVhdv4zkCxQaSDGEMNpfBcex8Q02ep9Zl9XMAv6/GMXLnXTwJMT1IYiXhWh
         UgEp5DDIInVKQkf/He3FoYL+u4GMyp4QAdLLEqmFEoEXjMj+e46H1+wCCWNdOXY+YQ0t
         A6JO6ZEFWPAi7azh/PwEqcriAW8jAOmmD6VdtrnuWj9192ugmPLWgK8kA2A6WVfZvjtR
         THzfjWtfo2l7mWBQr/HWlGrKt6cqcm8sH/o1aubTqXn9ZJ81v/d8A92uiuAG2CuW/Xbl
         S6mjcO9pVIfCFU7nm4fvzhgDDpgo6UlGgjtfswXBPgfDPVgldZLDDvmMYa5q182SarBT
         MxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716046144; x=1716650944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YcGBSUjyXOA1JpVYvoN1EuahOO06ajza5ZUGXHQ/tYE=;
        b=ui0m/t/00dN+rO0dKFEiXZeTgbFnvfNSBtqpwftJEk32GJwdVXZJnoXzAIYGvRC6Ea
         9NGnRVgm/r1F2CVDe9jMNjH46a9De5L0bSa2uiz7qh+0Cb+fDm96GkrJ9/Vw457HGZ9v
         XVDF7SeTmEU20ymu7k/H1qWkOQjd6V4NNE5TsP8OXp4FW/81tUxmG7vRpmbTH0IOh2lF
         Slc2g4KdIXhDZMZG14qY+8cq2B/Rv1xDmtsxJhxOBr/i1+mR0RokiiJ+x9qs1rUeMl57
         obK3leCdPzuIyfO9UdVNp29b6efAoRkaMMuL+HMnZNlvUbDG7+i98vnwUVazUEbVFktU
         YtwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaBbBn5cSP3mvfLRcBp5XODHHnuAzOS/ho8EQGgj1kmf2+0YkwW0F4h2TlCRvKLbTM48yiY+oSu5JF7MPjckmPOnI6
X-Gm-Message-State: AOJu0YyBvRxNvYEr3H4/qJJTKsJsBeLcJiyYBWcXCK8abybdnkHWfDUp
	SOs1b90RZi8RqWWW20zq6Tt1LrTjwn8MoDw/wM2/BNUpUWXeATlh
X-Google-Smtp-Source: AGHT+IH71oEJiJAd+qKPw7I30ipuzZqOKbfz9SVHCqEDTVEIWdcivJlGSb6FpPimtRapWLRXuy7gDA==
X-Received: by 2002:a05:6820:248c:b0:5b2:8deb:98cb with SMTP id 006d021491bc7-5b3299ba504mr933215eaf.2.1716046144372;
        Sat, 18 May 2024 08:29:04 -0700 (PDT)
Received: from ?IPV6:2603:8080:2300:de:3d70:f8:6869:93de? ([2603:8080:2300:de:3d70:f8:6869:93de])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5b26ddcc6acsm4088141eaf.24.2024.05.18.08.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 May 2024 08:29:04 -0700 (PDT)
Message-ID: <83b2db44-c7bc-49af-8634-d349b91dfab0@gmail.com>
Date: Sat, 18 May 2024 10:29:03 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Fix unused variable in guest request handling
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>
References: <20240513181928.720979-1-michael.roth@amd.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <20240513181928.720979-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/24 13:19, Michael Roth wrote:

> The variable 'sev' is assigned, but never used. Remove it.
>
> Fixes: 449ead2d1edb ("KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event")
> Signed-off-by: Michael Roth <michael.roth@amd.com>


Reviewed-by: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>


> ---
>  arch/x86/kvm/svm/sev.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 59c0d89a4d52..6cf665c410b2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3965,14 +3965,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa
>  				  sev_ret_code *fw_err)
>  {
>  	struct sev_data_snp_guest_request data = {0};
> -	struct kvm_sev_info *sev;
>  	int ret;
>  
>  	if (!sev_snp_guest(kvm))
>  		return -EINVAL;
>  
> -	sev = &to_kvm_svm(kvm)->sev_info;
> -
>  	ret = snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa);
>  	if (ret)
>  		return ret;

