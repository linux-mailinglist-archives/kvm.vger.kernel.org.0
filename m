Return-Path: <kvm+bounces-17714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AE48C8E39
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A64BA1F2428C
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 22:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F2E1419AD;
	Fri, 17 May 2024 22:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z6wzOec0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258E814036B
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 22:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715983272; cv=none; b=p4gKw8Y8hTIalP2xDPOyh3z7jyq4xz62ZhECO8Vi1uW/3Hn+NpFe3TZRRcKwKnjjRxkumL0Lp1ZdPPJOP9ruPBCALH+nOcaB7rpA8dFJrqyUt46mAA4fWeeHZ3folG+Iuij9m3ydnSC9+lJPo7dA1OFNTVZU5/XYayBqJdyyghg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715983272; c=relaxed/simple;
	bh=tKFUvI5gt7hLN6dkyDdXMdQUukxhrEOMhNZL9hIIlpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VDoumU6zSidV6xKfszESRf9o2SszhbL+R1fH5dVBnyZgArQVGouYom3jyth4lSyarkCI687pmZnC7gth5p1hCYv5+EGRVH6vPeE7wENtr8lyUKbSqa4P7fnmgr+7WACX8CzSFK3Dhi2y8W756Yxc3POsq8aol8WTZq133cBWFIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z6wzOec0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715983269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qdpUFXRIVfL52195MnmJDcIlCYPzvNX7uOwOv3Xc+XA=;
	b=Z6wzOec0L4AIPo2nU3bXjszdl0yozFbwEVxYBc5hmHqDNFOrR7Y1bQBxrLj/Nri1FbJ5Hd
	IMrBGb8JtxWO/9lGcNXttzzeD4bQbgnRMRgoliic6/m26ZZTe2ssDG8KCcuGSNwjypchwN
	6Q6utoAtYeMT6Z64zeokbttZTKF+yho=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-Hfd9jmLUNcOR04hfyEe5Ag-1; Fri, 17 May 2024 18:01:08 -0400
X-MC-Unique: Hfd9jmLUNcOR04hfyEe5Ag-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a599dbd2b6aso566628566b.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 15:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715983267; x=1716588067;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdpUFXRIVfL52195MnmJDcIlCYPzvNX7uOwOv3Xc+XA=;
        b=ZtX2Pgy9hjNYnSjfdhgOi+F89oF5xaC9BFNQET01pnfZddltAf7sDqhsPvJ7bIDt4T
         ySIh9jDmeWIEk1C78dKvM6g4+e5lqy8cNbtg359zj/lrSSEd4MMU+n/8qg1SSlIJzQzh
         4y3L6z03nkrdS/EpLmVVDuO9gw3SQaUD8fPOGDGmoXB+upMISC7GwGID+20TAk7xa7/z
         SjbusXwB5KZ0FJdLQc+2BDwC1K1Xi+jIW1rAfxJ8txdG+8fJAteDw/qdwx9PItJ1uFg7
         CW46C/WAw9JtLCl578CaBPVD5jYUgrZghQCTh6jTl1REsNdE95Y+bFVAvjRhe0gvw8SU
         2MfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEi+FNTWKtvVkOgyIV2Z6OPvDQnz00inXp9ty/0Sem40FKLO4CaoJIgb6q+qU+SZLmdj8HNh0hKoklp201yp9MkQgS
X-Gm-Message-State: AOJu0YyFw0sARHc0OsyMgEGzmxNdw18vZIrkKYkfkalGXAZvMZKKLJfj
	2NQacSHVhi6Mn0RLhwJIvzJs+MUpvKCG9wnwUJe8iCD5u4ZM3NNjRvn2254Dx+5ItytbG4zX88g
	SM1snie6lRJ5qyQvMmAsh6fiDThaP1vVAMmhhTsTRt/ZfM7MBRg==
X-Received: by 2002:a17:907:7da3:b0:a59:d063:f5f3 with SMTP id a640c23a62f3a-a5a2d673401mr2047180466b.63.1715983267338;
        Fri, 17 May 2024 15:01:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbO3RNBBJvjrmQrsSy2cv7ekGE/kUJSCKL4dwshp50q+y+7KPL9PGYTVFI+tQB68Or25mBGg==
X-Received: by 2002:a17:907:7da3:b0:a59:d063:f5f3 with SMTP id a640c23a62f3a-a5a2d673401mr2047178366b.63.1715983266873;
        Fri, 17 May 2024 15:01:06 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a5a69148b97sm701619366b.114.2024.05.17.15.01.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 15:01:06 -0700 (PDT)
Message-ID: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
Date: Sat, 18 May 2024 00:01:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PULL 17/19] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE
 event
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "michael.roth@amd.com" <michael.roth@amd.com>
Cc: "aik@amd.com" <aik@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>,
 "brijesh.singh@amd.com" <brijesh.singh@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-18-michael.roth@amd.com>
 <96cf4b4929f489f291b3ae8385bb3527cbdf9400.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <96cf4b4929f489f291b3ae8385bb3527cbdf9400.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/17/24 22:41, Edgecombe, Rick P wrote:
> I get a build error in kvm-coco-queue with W=1:
> 
> arch/x86/kvm/svm/sev.c: In function ‘__snp_handle_guest_req’:
> arch/x86/kvm/svm/sev.c:3968:30: error: variable ‘sev’ set but not used [-
> Werror=unused-but-set-variable]
>   3968 |         struct kvm_sev_info *sev;
>        |                              ^~~
> cc1: all warnings being treated as errors
> 
> To fix it:
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 57c2c8025547..6beaa6d42de9 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3965,14 +3965,11 @@ static int __snp_handle_guest_req(struct kvm *kvm, gpa_t
> req_gpa, gpa_t resp_gpa
>                                    sev_ret_code *fw_err)
>   {
>          struct sev_data_snp_guest_request data = {0};
> -       struct kvm_sev_info *sev;
>          int ret;
>   
>          if (!sev_snp_guest(kvm))
>                  return -EINVAL;
>   
> -       sev = &to_kvm_svm(kvm)->sev_info;
> -
>          ret = snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa);
>          if (ret)
>                  return ret;

I'll post a fully updated version tomorrow with all the pending fixes. 
Or today depending on the timezone.

Paolo


