Return-Path: <kvm+bounces-25787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B37CA96A84F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7149E2858C7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F951D5883;
	Tue,  3 Sep 2024 20:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a62e+wYH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7528C1C62C7
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 20:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395212; cv=none; b=KrkE2d3o6tlqk3wnHcWe7fAGklTIDh0qF4q2mAAUcwuysLJqOgjYqwOqkPX3D1hmUu3dJgWogHL+UEUYYtl8nGbI5GmvFiEET1BAqJ+stiM6T1Vr0b2UVJLaci454yWGJljFXpxkxgbk+O4YcF+NQepzIZixdApu8/C85ZYOSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395212; c=relaxed/simple;
	bh=FAbvctyXmBfHcAZGqMzzReeqED9AEbWCcpVs4u2wjrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oq1dQyZ0X75WUVZSZwza9napGrq39qJ3U7O2gvoKJrzYh9RSWptywpApGJQS0MjHSBEUtXKjk0a63pSICdw9yWa4YCy30zIHWkO0O3xjvNZ9WsCAO6d2cf9r6L4tQLqwsQjXKoIjvAfTCAK12Fn2VbWdCEvP0BB20In7MMqv71A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a62e+wYH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2056aa5cefcso12275ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 13:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725395211; x=1726000011; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hn9q192qt3f9I/JNUW5WfgcLIfdvUW9LVehziz5b0yI=;
        b=a62e+wYHHrgbetdlnD/7wcsgbHrAmjjQSMRluX0BY0ZmoRl+vLLyTlKt1eUbrvNNVq
         LO/pmTI5ntjW90XNJwr3u6Zk5xqOeGEFIpLxO35AwgnG5FcDM56VJcNSNRA4h9J/Kaj7
         7P2C8pOTQM6PZZvlSV70JGBYlI5vxIhOYj4O8BciyrG/16uTdcizfmlEKcnbpxFXAoOh
         j2BzRlQTqinQIDi/8HSdvyCCuzDkcwPBrG+XhbXbdoBub2FARaJ6HMzpx31ILAIzuPME
         NuxdgY7QmNmq1n3et0mQ92YA8TTx9HTpa/l14vJrDG1Nm2fD+FGCZUlfCFH6ToqHX5FJ
         QGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725395211; x=1726000011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hn9q192qt3f9I/JNUW5WfgcLIfdvUW9LVehziz5b0yI=;
        b=HSbLonYvbQ+YHZEFIH0qoaUATfcnn873khkf6iAjVtSPHvCeA/TfQJsNrg89TlvC2I
         EF/kjiLR3X51LSSHtnFVs1dkrgoPLz/IAfn66oUmH2C2lnzCwXU6rAG/TsTb2ndi5NPG
         //EaHymkYBdvZEDrL58YemtzceIf8Zc3sgm4qSidCWKKTDV6ZLzuX/mTu+FP/21smxxu
         +Lwu1Okmzb0rM7L/MIBAzSTOynGZvUtZ6pmNtLJLwwNKanoCVSValRwF1dPAq/Lg3vDZ
         DUW5RtXarVVkZCjurZnp9HlWogrYM7F3PJ2fE6Ptl50F/om/BRVR1msL5xiZ72vCP5pP
         WUOw==
X-Forwarded-Encrypted: i=1; AJvYcCV67XLEyxNacCpId3om6m/6o2u9E5217l0O7L/TyaMNGJyqF0q6tM22fr+aMDIE+B1mLos=@vger.kernel.org
X-Gm-Message-State: AOJu0YwddlBZGKsMj4/jC4eXBn0Klu/CmpH8Oa22EKhjHVh9DjOfs3lI
	AVDTv0MqfAw9Ck/4t+3xlrvc+ncQoni1qIVTQ7QmAn9nSYRvmrZWGlU7+TYdXA==
X-Google-Smtp-Source: AGHT+IGEpC7n9bw1anipjHhk+pckubl7cjfnvUTvpjr8Gnqnk6n6BjEyH86EvPY7d1h/Za0isVPpxQ==
X-Received: by 2002:a17:902:e88e:b0:206:9b0f:48f3 with SMTP id d9443c01a7336-206b58bf5cemr35535ad.19.1725395210553;
        Tue, 03 Sep 2024 13:26:50 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d4fbd92473sm295280a12.48.2024.09.03.13.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 13:26:49 -0700 (PDT)
Date: Tue, 3 Sep 2024 13:26:46 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: x86/mmu: Track TDP MMU NX huge pages
 separately
Message-ID: <20240903202646.GA423248.vipinsh@google.com>
References: <20240829191135.2041489-1-vipinsh@google.com>
 <20240829191135.2041489-2-vipinsh@google.com>
 <ZtDXQ6oeQrb8LxkX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtDXQ6oeQrb8LxkX@google.com>

On 2024-08-29 13:18:27, Sean Christopherson wrote:
> On Thu, Aug 29, 2024, Vipin Sharma wrote:
> > @@ -871,8 +871,17 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> >  		return;
> >  
> >  	++kvm->stat.nx_lpage_splits;
> > -	list_add_tail(&sp->possible_nx_huge_page_link,
> > -		      &kvm->arch.possible_nx_huge_pages);
> > +	if (is_tdp_mmu_page(sp)) {
> > +#ifdef CONFIG_X86_64
> > +		++kvm->arch.tdp_mmu_possible_nx_huge_pages_count;
> > +		list_add_tail(&sp->possible_nx_huge_page_link,
> > +			      &kvm->arch.tdp_mmu_possible_nx_huge_pages);
> > +#endif
> 
> Pass in the count+list, that way there's no #ifdef and no weird questions for
> what happens if the impossible happens (is_tdp_mmu_page() on 32-bit KVM).
> 
> void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> 				 u64 *nr_pages, struct list_head *pages)
> {
> 	/*
> 	 * If it's possible to replace the shadow page with an NX huge page,
> 	 * i.e. if the shadow page is the only thing currently preventing KVM
> 	 * from using a huge page, add the shadow page to the list of "to be
> 	 * zapped for NX recovery" pages.  Note, the shadow page can already be
> 	 * on the list if KVM is reusing an existing shadow page, i.e. if KVM
> 	 * links a shadow page at multiple points.
> 	 */
> 	if (!list_empty(&sp->possible_nx_huge_page_link))
> 		return;
> 
> 	++kvm->stat.nx_lpage_splits;
> 	++(*nr_pages);
> 	list_add_tail(&sp->possible_nx_huge_page_link, pages);
> }
> 
Sounds good, I was not sure if passing pointers and incrementing count
via pointer will be accepted.

