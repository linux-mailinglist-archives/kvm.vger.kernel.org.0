Return-Path: <kvm+bounces-19411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69BA1904B73
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 08:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3B631F21BA8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 06:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6188C167295;
	Wed, 12 Jun 2024 06:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mNNbRY6l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CD047A6C
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 06:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718173110; cv=none; b=nFSwGWhqNTa0GZYwWi9xAZXcMNoJKn6KjWDSkzF1iO0RryF0frJSK3Lv1WZmzY3oIWHu85/5dD2C/azAfX9gpkx+vC3mSqpsFe25A8QVzLn6WM+mHm5BmBX/QqVz1Bg0Q4iek9C7hL+OYgwwNVO4ixQ672grOi0I0lTWXFW9qD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718173110; c=relaxed/simple;
	bh=M4eOGvl/0dr8Hzleu1zPPu+fOl+XRh9uE9Doh4pU5E8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bfjutbU9H8Tt0HcYcBO5hmU/j5n8n+2U+iaeeez0kM0VehTayz+zKY/uVLuTotqKFcGOdMUIpYRb7325pLO4j0YyVNtJ0z64MIKAZdLM+QnOmOf8OgfKUb3JCC1RZGD+iEQ6/MrvZXzGIy9tId+2URd1EgXlD36QPIpvbASPUKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mNNbRY6l; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52c815e8e9eso3847362e87.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718173107; x=1718777907; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qz1Sdj4E2qb4tFt00sjT4ZATpDRNmC3N+c5nkjQn9ak=;
        b=mNNbRY6ly/K8XgM6BFCHqSNqVUlFd82NBdqsNKKo/+bPBz5aei91SmxeCx5B60TIFm
         MFskZCFbN6dqaEhDZUHMtWiqvodDY1BQPZw0T/wQmf2RyYlkFEb3nFkoB1DoCHnPCF+T
         fFuDuad9eh2BnrdvuCBOItXLbobywdIZKkrFa4YvFvPycfLf4eFy2D7e37nLphjJmaVO
         oKBJxagvK5CBq3aiYIn6J8yKhXO/pJd5VlsAWwNoJK64pj+C4EIVju+KGI4qxYQ+Oxkx
         8tztEn0MTgm88GvxUUvcM0YSSL3ia2MXnRVZHve8kN/TXpdbIpJkXpSjRymu6OkbGZKa
         8nTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718173107; x=1718777907;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qz1Sdj4E2qb4tFt00sjT4ZATpDRNmC3N+c5nkjQn9ak=;
        b=V/66vf1hukEdPaa/SBUDQxvPKAaLwDol1AW59YHhzIutGEQD9YhpPF9539/Vg8blUS
         f0yV7AMWVWeq0GsgO97118DFPQnnYUGVZPyckwLkKKplzaSXT3mMQem03XJ0OZ7xN1Hs
         oyj7LyOo6krmJiqdOnvZfkZtuB4QHbX2hrRWfuXWAOhZuwfysfWRWndWF5WHs+A3e3OD
         ofqK5O2IddVa7rrZMJuZPzsoZeeJAAeLFI1liL7HYBgG5ZMtIy4ngx7Bvb9M6XHxufws
         MTwf9I6tFG1x9RAZau6vVZ6wYFcDNClwRGjvaf99BK0ohI6Ul8YZImlHQ4wZc9KUab7n
         5JsQ==
X-Gm-Message-State: AOJu0YyHH/IqlRMj5MU/LAnDWPpL40ZtuS94eOoV5BIlqh9zn9ap8L+6
	d5AmwXCcfGTZxOZBqc8JbTKb4CSiBq5v8NP+IbSU6+zNIYx9IhWCVGpiu1nJG6r6XCEeLdTsa86
	o
X-Google-Smtp-Source: AGHT+IE8BujWt3X6RUlrEoqzjHHE63Wiv/jRffuxA/Z5sHpmQ+gOz7hK94IUF9GLAfn55yRIRoskVg==
X-Received: by 2002:a05:6512:3085:b0:52b:bd97:ffde with SMTP id 2adb3069b0e04-52c9a3b979cmr482384e87.7.1718173106844;
        Tue, 11 Jun 2024 23:18:26 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35f1c423932sm9813261f8f.114.2024.06.11.23.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 23:18:26 -0700 (PDT)
Date: Wed, 12 Jun 2024 09:18:22 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
Message-ID: <d9c16deb-6fad-4ecd-a783-4c4e9f518725@moroto.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Brijesh Singh,

Commit 136d8bc931c8 ("KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START
command") from May 1, 2024 (linux-next), leads to the following
Smatch static checker warning:

	arch/x86/kvm/svm/sev.c:2159 snp_launch_start()
	warn: double fget(): 'argp->sev_fd'

arch/x86/kvm/svm/sev.c
    2121 static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
    2122 {
    2123         struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
    2124         struct sev_data_snp_launch_start start = {0};
    2125         struct kvm_sev_snp_launch_start params;
    2126         int rc;
    2127 
    2128         if (!sev_snp_guest(kvm))
    2129                 return -ENOTTY;
    2130 
    2131         if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
    2132                 return -EFAULT;
    2133 
    2134         /* Don't allow userspace to allocate memory for more than 1 SNP context. */
    2135         if (sev->snp_context)
    2136                 return -EINVAL;
    2137 
    2138         sev->snp_context = snp_context_create(kvm, argp);
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
What this static checker warning is about is that "argp->sev_fd" points
to a file and we create some context here and send a
SEV_CMD_SNP_GCTX_CREATE command using that file.

    2139         if (!sev->snp_context)
    2140                 return -ENOTTY;
    2141 
    2142         if (params.flags)
    2143                 return -EINVAL;
    2144 
    2145         if (params.policy & ~SNP_POLICY_MASK_VALID)
    2146                 return -EINVAL;
    2147 
    2148         /* Check for policy bits that must be set */
    2149         if (!(params.policy & SNP_POLICY_MASK_RSVD_MBO) ||
    2150             !(params.policy & SNP_POLICY_MASK_SMT))
    2151                 return -EINVAL;
    2152 
    2153         if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
    2154                 return -EINVAL;
    2155 
    2156         start.gctx_paddr = __psp_pa(sev->snp_context);
    2157         start.policy = params.policy;
    2158         memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
--> 2159         rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
                                      ^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^^^^^^^^
The user controls which file the ->sev_fd points to so now we're doing
SEV_CMD_SNP_LAUNCH_START command but the file could be different from
what we expected.  Does this matter?  I don't know KVM well enough to
say.  It doesn't seem very safe, but it might be fine.

    2160         if (rc) {
    2161                 pr_debug("%s: SEV_CMD_SNP_LAUNCH_START firmware command failed, rc %d\n",
    2162                          __func__, rc);
    2163                 goto e_free_context;
    2164         }
    2165 
    2166         sev->fd = argp->sev_fd;
                 ^^^^^^^^^^^^^^^^^^^^^^
We save the fd here, but I'm not sure how it's used.

    2167         rc = snp_bind_asid(kvm, &argp->error);
    2168         if (rc) {
    2169                 pr_debug("%s: Failed to bind ASID to SEV-SNP context, rc %d\n",
    2170                          __func__, rc);
    2171                 goto e_free_context;
    2172         }
    2173 
    2174         return 0;
    2175 
    2176 e_free_context:
    2177         snp_decommission_context(kvm);
    2178 
    2179         return rc;
    2180 }

regards,
dan carpenter

