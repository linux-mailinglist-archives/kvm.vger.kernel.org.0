Return-Path: <kvm+bounces-53619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F52B14B7F
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:41:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2BE916CF21
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262382877EF;
	Tue, 29 Jul 2025 09:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pum9zC7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DC27057D
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 09:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782096; cv=none; b=I3hnkPOeB1JxdU9mkovUhyCQs5x/9uFWw+IEf5WbTxs+/aWJTjGT3g6URw9VF+u0d8Mcl1sXfbSXItd9Jf8avf4D09ejLzXF0J2NI7C0wEvV//6yYJS4q8Vm+bMahmMOFSK1FN3AVBblxod8j30H8IKx16mxCbRZRAVYdcAlDeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782096; c=relaxed/simple;
	bh=pze3g9I9ImuGvTuwzZt8zseQTd+y8AdIlBz7EqtXCT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tgc/F03NhWHyFWtMhMVsHdt60D7SwfuiRcvGO6JF+3ZXSOk6dwb5hgsgjV0KzI8HMk/3+tX0knYnQLz3CI8O6DDiUrM6DPcrnuYmN3g6H2GovK8/Wnppl/REWafnBvITXsC+vxSzl0/pWoySmJG1ejxTBmO0LbbpII342DvcSOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pum9zC7Q; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4561b43de62so70315e9.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 02:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753782093; x=1754386893; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PWTS5n1O4Ix3VKY86VLEWfgQ1N+O8NpWBxk8Bg9O6vI=;
        b=pum9zC7Qswq2ca5gLqRsOx0EsSHJhz9cLQltcnIeH2gEahWHJ0lviG2Rjb1qWhO3Vq
         vCUgQ2NCeRMr5flMnt2vgnogLiFBg76P5FnLzoCe0ypDf21+g/RTwHbCzchyxDNnanfT
         7SvlSGrtSWNwV3htCtLgIqysmXtY8K3+eCrEiLuDw121ObYoC/8eqywnNRDl3let2k2V
         oz9T1CxiQR52z0HZBfb5aJzlNe7GMjdvs3l7fJ6Z07ip+weyKjX8uKQsHDydSZVnhnvf
         98azS2czIs0EzWy7VNY3v6hJECyXRP3/adK7Cm6W0DAsbwft0LKAts6hbLlI1eiTiz8E
         ADKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753782093; x=1754386893;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PWTS5n1O4Ix3VKY86VLEWfgQ1N+O8NpWBxk8Bg9O6vI=;
        b=imK/LvfK4xBCg41rhVKgdVso6AS1EIKCkFogT2yZtdZHKDlXHgR92hRlfdUcE61CCd
         fPGGd65OdrtcT4NGUANkaj14Jntt8V1IShUHOdytT33jTTEFz8P/Yk23NvrpqDeWS56u
         a/HjY1HV05BOg5YTplCUXk18CODdNDTjdClJBaOGN2MQYxIGQr3HZ5RJxmReMx71eGw2
         nJZ+J5zzg3dV43qh3cTJrJxbld/fHlioXwcQsAj36yNkQVEQhFSMSmTNgqU214RSrQqO
         k8KMYSeU2SNRtG+Os5klkoL/IBVCG8m2/Gk06RV1sif0G3+PSRFuZdT6C4tvxRuwvBKn
         3kVg==
X-Gm-Message-State: AOJu0YzW1m584rR0L/fT9FfFG54BBfZtWMA1z3wmMa0pbtLFXUwBw5L0
	qDbgXQai9LNwYSscDEc/DMTibw1EBvvyIGouBDqa8/ngGprM50epIP7QbJdTKxXzVA==
X-Gm-Gg: ASbGncuqhDN9LT5uXKecKoY/8M9fn8yxZcFXRXT57oQsGiiVBXxje3Py/VGXGfqS7ID
	CE0Ud0QQOU3SPYyg+0DXzyrdAYddI7+bZq5SRGQ1zaNiaxOjWq7JleADPcr6GrWIHIxjWevLQ/I
	OdN6TZE2YM4MXgUHR4OyHTLCPP8kqGGZ2DDUTh1cTq3Hvc876El9CI6jeeaxpn4xKj1rKTHvnMj
	iTuGyTGI0bYCdQnr2nAvgkpD6e+XEqLp2qzvcRUHepQiTCe4FiyhNRjjjvrs34BTHyt1VbRF40s
	5t3jTKfgT5TDKqTqSJzke5+tRW3+khvBl1mKucXsxgWdrLrvcvfjYGXp7e+f1LFR4XlbSA56Ywf
	57WzEC6gPxPLehbzI4R0H/B66OqzxFLSRJuwRmgaFlNU4dE2RrEAgu0Q2JA==
X-Google-Smtp-Source: AGHT+IG+EszVU09J5v67ER0JFc89U/ZUSQqu+XR8lc75vInQ0L2VoR6ijmMaOHoO1vTppC5NJCkyIQ==
X-Received: by 2002:a05:600d:17:b0:453:6133:2e96 with SMTP id 5b1f17b1804b1-4588d58f585mr1042605e9.0.1753782092753;
        Tue, 29 Jul 2025 02:41:32 -0700 (PDT)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b7842a3e59sm8156053f8f.44.2025.07.29.02.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:41:32 -0700 (PDT)
Date: Tue, 29 Jul 2025 09:41:28 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
Message-ID: <aIiXSNgqt_6xuaRD@google.com>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aIZxadj3-uxSwaUu@google.com>
 <yq5a8qk7bml8.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq5a8qk7bml8.fsf@kernel.org>

On Tue, Jul 29, 2025 at 10:49:31AM +0530, Aneesh Kumar K.V wrote:
> Mostafa Saleh <smostafa@google.com> writes:
> 
> > On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
> >> This also allocates a stage1 bypass and stage2 translate table.
> >
> > So this makes IOMMUFD only working with SMMUv3?
> >
> > I don’t understand what is the point of this configuration? It seems to add
> > extra complexity and extra hw constraints and no extra value.
> >
> > Not related to this patch, do you have plans to add some of the other iommufd
> > features, I think things such as page faults might be useful?
> >
> 
> The primary goal of adding viommu/vdevice support is to enable kvmtool
> to serve as the VMM for ARM CCA secure device development. This requires
> a viommu implementation so that a KVM file descriptor can be associated
> with the corresponding viommu.
> 
> The full set of related patches is available here:
> https://gitlab.arm.com/linux-arm/kvmtool-cca/-/tree/cca/tdisp-upstream-post-v1

I see, but I don't understand why we need a nested setup in that case?
How would having bypassed stage-1 change things?

Also, In case we do something like this, I'd suggest to make it clear
for the command line that this is SMMUv3/CCA only, and maybe move
some of the code to arm64/

Thanks,
Mostafa


> 
> -aneesh

