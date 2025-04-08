Return-Path: <kvm+bounces-42951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5796EA81317
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 18:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FF591BA03AC
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 16:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8E0232364;
	Tue,  8 Apr 2025 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OoyebfrX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6DE22ACE3
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131478; cv=none; b=qhUvsFNgCsqN69sUGi9AYmZSTi9jefFsfRsI4qYiEryn5tUtuFgL/R4zqHC4s0Tc7ztnUc+lrXTINxlPx3d6bB3K0T+bictLv89jHg/y8yaz8u3gnb+GiCRdi/y5jGfyqnYw4xhBRjbnI5L9+Sg0UIi8BUWDutK1BU4F/3nzMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131478; c=relaxed/simple;
	bh=E/UgzG4NaYP4/YEsbqahDbER43TJcbSBQEzVlGvZq6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kiKzDaaYAm2qsjVAE9+Dk3fRwXbNBx1zHgoc3LwUWybe+rmXcextNIMS7bTMeN1AvfHPLYDbq3PbdfTZ9+FaaCXnJEev0BltBSLk/AmA1Gudzkg53vtZ6xFRw7VvGUDVPo5Bgja+pGz4OxFi1kEmF+D5WD9nclZs/Uh7BKNYwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OoyebfrX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744131474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ur0KNcNU+Bbe3ulpEE4AO76I8ACxlXZkuuWpkfCf0Jc=;
	b=OoyebfrXjst/gmGbkhTuTOeqKDlju7jyBlsgC3IvxRhtfgwsyEa0fCmLNMBoyttKaMYgXR
	czleVYHct5hEPt1Hqxsv1jQodo4OER70fG9G4tkgjg9C+v8SfOFtAVzjN1J+9pqj9Vruzc
	p80SCjpRQr2FtCBz2/cPgvvhqkD4GI4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-JP0vQF1dOkOrTEqiq0HXow-1; Tue, 08 Apr 2025 12:57:53 -0400
X-MC-Unique: JP0vQF1dOkOrTEqiq0HXow-1
X-Mimecast-MFC-AGG-ID: JP0vQF1dOkOrTEqiq0HXow_1744131472
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac31adc55e4so111584366b.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 09:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744131472; x=1744736272;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ur0KNcNU+Bbe3ulpEE4AO76I8ACxlXZkuuWpkfCf0Jc=;
        b=Tmu5lL9KTNbOJjIhT3C+pL68AFjg2IgPpRJNF1jkuDXGPwlFekwrzk2AkAv8IVgGWd
         HTAYCjDx1lD9rUj71RobBeDcHjO3up8/Qp5QOyujWrqy8Q+IWAhQ/1cgeXguu9bFb8gB
         CmCmT25R0GPJCuoeyCl0m3bFvZTVg/UILYTq+5yYPF63LI3GI2B724BLKHpikDcwRZEP
         kOSHk+BNrrNOAsc53+4uRn42p/DEu8/tMUCFTtVWbBUkySNXkKcjF55DQikl2xS/wDiJ
         +f11Xupo3zSTdgrsCFkoYEUOoh0Ojtgb5KsjR2sEYhfdlTXHuqMDo/qxNKhBGQnm/5Tu
         tEdw==
X-Gm-Message-State: AOJu0YzMmfMfRDD0w6aSrkZMSoVDokKh3uGixtdZj14xU+868NjvivmG
	7GSU6PzA5o/xu+7EiS/h/UyRAtgtuPuK05Ai1v2GPeB/P9syrFYpBNumSceHDuShzDzHr+YHteo
	gt8ZfAgRQ2WXa8a/5/nofNDNZ90myTZm08DqExD2dG35YhptoHg==
X-Gm-Gg: ASbGncsx+x8T3zSYPNP/q4BtQOifceECseW+5yG6QnyoODT88f23qf0EbwZcRhknbuw
	nGY/fWln2w6QTkLf347aFbNShpYZY+GG4bGlyEazbbxrGntmYAG4/QgSsuA3SVKBbtfA6lLptT5
	Q+6ezfEanSVRYIr254VD92evCyckHYt+hID2oTs8OaV9dHFLlxy+H+/H3Ps/PN4/atbHoBzs6Oi
	U7pVSlYwSlQ4vnkYr1AA4Dg279EH7cVM7MpVJ4NUl2RNW6SgGIzWIaZ59nucwSifL0t0EFmzJTE
	sLHlWBjNuRU41Nkj56Yq
X-Received: by 2002:a17:906:6c91:b0:ac7:f348:b8bc with SMTP id a640c23a62f3a-ac7f348c1a4mr846858366b.61.1744131472359;
        Tue, 08 Apr 2025 09:57:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoJBXVzWDsYpEAyABHK22MH5Y16LHSd5i/jqdw+5ay+0S5ZKY/E+1W+Hg+xuoMz9rwwMee0Q==
X-Received: by 2002:a17:906:6c91:b0:ac7:f348:b8bc with SMTP id a640c23a62f3a-ac7f348c1a4mr846855866b.61.1744131471892;
        Tue, 08 Apr 2025 09:57:51 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.197.100])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ac7c01c2e6dsm953029866b.174.2025.04.08.09.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 09:57:51 -0700 (PDT)
Message-ID: <8b061b2d-7137-498e-93b2-0cb714824d7b@redhat.com>
Date: Tue, 8 Apr 2025 18:57:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 26/67] iommu/amd: KVM: SVM: Delete now-unused
 cached/previous GA tag fields
To: Sean Christopherson <seanjc@google.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-27-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250404193923.1413163-27-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 21:38, Sean Christopherson wrote:
> Delete the amd_ir_data.prev_ga_tag field now that all usage is
> superfluous.

This can be moved much earlier (maybe even after patch 10 from a cursory 
look), can't it?  I'd do that to clarify what has been cleaned up at 
which point.

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/avic.c             |  2 --
>   drivers/iommu/amd/amd_iommu_types.h |  1 -
>   drivers/iommu/amd/iommu.c           | 10 ----------
>   include/linux/amd-iommu.h           |  1 -
>   4 files changed, 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 9024b9fbca53..7f0f6a9cd2e8 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -943,9 +943,7 @@ int avic_pi_update_irte(struct kvm_kernel_irqfd *irqfd, struct kvm *kvm,
>   		/**
>   		 * Here, pi is used to:
>   		 * - Tell IOMMU to use legacy mode for this interrupt.
> -		 * - Retrieve ga_tag of prior interrupt remapping data.
>   		 */
> -		pi.prev_ga_tag = 0;
>   		pi.is_guest_mode = false;
>   		ret = irq_set_vcpu_affinity(host_irq, &pi);
>   	} else {
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index 23caea22f8dc..319a1b650b3b 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -1060,7 +1060,6 @@ struct irq_2_irte {
>   };
>   
>   struct amd_ir_data {
> -	u32 cached_ga_tag;
>   	struct amd_iommu *iommu;
>   	struct irq_2_irte irq_2_irte;
>   	struct msi_msg msi_entry;
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 635774642b89..3c40bc9980b7 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3858,23 +3858,13 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>   	ir_data->cfg = irqd_cfg(data);
>   	pi_data->ir_data = ir_data;
>   
> -	pi_data->prev_ga_tag = ir_data->cached_ga_tag;
>   	if (pi_data->is_guest_mode) {
>   		ir_data->ga_root_ptr = (vcpu_pi_info->pi_desc_addr >> 12);
>   		ir_data->ga_vector = vcpu_pi_info->vector;
>   		ir_data->ga_tag = pi_data->ga_tag;
>   		ret = amd_iommu_activate_guest_mode(ir_data);
> -		if (!ret)
> -			ir_data->cached_ga_tag = pi_data->ga_tag;
>   	} else {
>   		ret = amd_iommu_deactivate_guest_mode(ir_data);
> -
> -		/*
> -		 * This communicates the ga_tag back to the caller
> -		 * so that it can do all the necessary clean up.
> -		 */
> -		if (!ret)
> -			ir_data->cached_ga_tag = 0;
>   	}
>   
>   	return ret;
> diff --git a/include/linux/amd-iommu.h b/include/linux/amd-iommu.h
> index 4f433ef39188..deeefc92a5cf 100644
> --- a/include/linux/amd-iommu.h
> +++ b/include/linux/amd-iommu.h
> @@ -19,7 +19,6 @@ struct amd_iommu;
>    */
>   struct amd_iommu_pi_data {
>   	u32 ga_tag;
> -	u32 prev_ga_tag;
>   	bool is_guest_mode;
>   	struct vcpu_data *vcpu_data;
>   	void *ir_data;


