Return-Path: <kvm+bounces-37886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 217DAA310FD
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 17:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25C3A188D49C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:13:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A301256C7E;
	Tue, 11 Feb 2025 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p2mapvzQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB22E254AF4
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739290340; cv=none; b=II8Tas6EPz++MCKEb1RJqQqe4zjNKSqKaFwgD1hG8R84rPXc6m8o6wyiXRMX3VJYTvlV7ElUXwuUnmDy2HP9VhxB91xLZAAABwwhaIly8lQRRIvx3T/zl6Khk0FIKxASdkldqhxwXjI4enlGuEmwjrsWoQ/mCLyWvjNItzVSXmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739290340; c=relaxed/simple;
	bh=I67uYaPn61REPW4U1VDeEVAHoIiiTMdqz+BBTaX+76g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SuA4g94Yl4AY15IOAOzmIXrrdIihqGul+s7DffrRlzBn290Mcbo3IHCzVHwpVOyN/Rkb2seSENAMDVfRVpbnbmEZqrXOr/WF9fREVD2PyyiSHxYg7h37YK9WPyvdlMpySBkcdvx/xByMOOJ1ig03OATXMVyrZQ/bwItK5SW+WbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p2mapvzQ; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5dc89df7eccso11074290a12.3
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739290336; x=1739895136; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksYhiNxYXxIQXSCUbIP2PVxMkppBVi7a3p8q7qKHPhU=;
        b=p2mapvzQ2JfqsB0JodTUuXi8FLr1wGjna4k4IBHYZIeNN6dgGE8OX35SfftQAABXxZ
         GscREQEdJ93izX4t3YKUNf+C9L3zoGOnKUncb/cdGNioYKAGqurHp0cXNfi4/M58R19K
         7KmcRDBGMssA0KXfu77Q6V18/DbwVbqIQakA6kFFuJGjJkzm0dOHEg6+yarIZvLdkVw5
         NfG9F62LA5airqBlHAc4r/Vtr17sWVhhUOURFRo8Cq6DLRutgG6/Wk1hPNK1w5Yc+nzJ
         Tr+QT/Pg+uYSPZgWi7b0i/BOU9qxgYTz9UsDGAI/708VF4R5p1gKOI9XmJm3O4+i+qFP
         SsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739290336; x=1739895136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksYhiNxYXxIQXSCUbIP2PVxMkppBVi7a3p8q7qKHPhU=;
        b=OGSc/1p3mUWXq35+otRK7tBS+Tnr/NRpbQVFqqMiGjyHEPd5nJhbJXhgrcR/oKugWz
         Wb8BqwncQKi63CmFICl+TjJXLYv4v7506+Dd+sAOvfp2WdJ2YKvvjZVz65GE1efcJt3z
         wiYoxMVEg2i47hXaMjgW0Ne7pylqPa3B7wL74bzFw/b7MOL77CoNUB92Lsu3lMJoonjw
         XUzfmt6B53SL3aCvVi5IpsS/Ean7701ij+jgmGO9WMwIX9fR/e7BnvcGRt2ivbdNU/s8
         vI/ybLwchHT8i43ae7yGS6RTJtPnxlqY61dhl6jBYskKrhh6UvQ111mCo6xj07Xvijr9
         4/Rg==
X-Gm-Message-State: AOJu0Yzr+kIjC4L1KaO9DZ/1cEJs13xmdLIk0nIkisxTohwSSVEEZQx5
	yonKNq2F8OSvqhZess9E+fA1Eb2IyP1LKAbK7TIZ7gQj94+pU2fl2im182F7AA==
X-Gm-Gg: ASbGncsoVln/4YI1mMOU3Bi2WPOxEAsbB3JrEtasPnY7t+vpWNNkTHSkPuGRM3ea82q
	ojenhR1QorsfoOfsyBuCVps4vFnuDS3EPfpni9n0DUfWFYvj0byLMSlbl+0EPlh4lE/spHL18zc
	pq6qd/f2lD6AysuDdjNHe2z4Wq9EzBUfsnpPSREBm2bn0ysirNX07/YA0QkscJCkWR2vTBnE0gg
	uT8Wh+lGo4pMwjG2a+bzME+sjmyaE9WQx7pJbn8lSIUsuQetqr6RDeRT1JuFS6aePk3PZ4Dsb1K
	nXyXDtF4XX1CZvFIMjVmzcQw96XqxQIb0KpWepzB1BYu9pcdkFD1
X-Google-Smtp-Source: AGHT+IHArNcP+f9MjN7EP3uzU7DHYs7lXHuAPyrJhIGf+osevoSlQPPB7u5M+tNFRK6c5XzjVmPf/Q==
X-Received: by 2002:a17:906:c146:b0:aa6:96ad:f903 with SMTP id a640c23a62f3a-ab789bcb704mr2131203366b.31.1739290335795;
        Tue, 11 Feb 2025 08:12:15 -0800 (PST)
Received: from google.com (229.112.91.34.bc.googleusercontent.com. [34.91.112.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7bcd53bf5sm467078566b.87.2025.02.11.08.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 08:12:15 -0800 (PST)
Date: Tue, 11 Feb 2025 16:12:11 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, keirf@google.com,
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org,
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com,
	fvdl@google.com, hughd@google.com, jthoughton@google.com
Subject: Re: [PATCH v3 09/11] KVM: arm64: Introduce
 KVM_VM_TYPE_ARM_SW_PROTECTED machine type
Message-ID: <Z6t227f31unTnQQt@google.com>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211121128.703390-10-tabba@google.com>

Hi Fuad,

On Tuesday 11 Feb 2025 at 12:11:25 (+0000), Fuad Tabba wrote:
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 117937a895da..f155d3781e08 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -652,6 +652,12 @@ struct kvm_enable_cap {
>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
>  	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> +
> +#define KVM_VM_TYPE_ARM_SW_PROTECTED	(1UL << 9)

FWIW, the downstream Android code has used bit 31 since forever
for that.

Although I very much believe that upstream should not care about the
downstream mess in general, in this particular instance bit 9 really
isn't superior in any way, and there's a bunch of existing userspace
code that uses bit 31 today as we speak. It is very much Android's
problem to update these userspace programs if we do go with bit 9
upstream, but I don't really see how that would benefit upstream
either.

So, given that there is no maintenance cost for upstream to use bit 31
instead of 9, I'd vote for using bit 31 and ease the landing with
existing userspace code, unless folks are really opinionated with this
stuff :)

Thanks,
Quentin

> +#define KVM_VM_TYPE_MASK	(KVM_VM_TYPE_ARM_IPA_SIZE_MASK | \
> +				 KVM_VM_TYPE_ARM_SW_PROTECTED)
> +
>  /*
>   * ioctls for /dev/kvm fds:
>   */
> -- 
> 2.48.1.502.g6dc24dfdaf-goog
> 

