Return-Path: <kvm+bounces-24548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8BB95723C
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 19:35:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ADF82838CC
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 17:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2449188004;
	Mon, 19 Aug 2024 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bO+TtUrL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D64186E2A
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088900; cv=none; b=uH4fuEalyMRWewksOek52ACwUi97j/VGCZQcpKjc4I2q5s5GzTGD4s0gljwFTzcK8iEqX+ow8yR0+uMoQB/AjBjlNs4TdWCLxZGvd3TXSt+04yVFFKDlC9P0dzccKj1y98DqL5wtxqNPN/bwps5zPZM5CaVGXxk7+Gj+lBJ+Wqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088900; c=relaxed/simple;
	bh=vnrUWXWCOxACC1SXhMDLY2OVG8VD6mjQwafYN4cxxew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RO7elilSpepR6cnhc+ddFXSPH3OV5yDzLcADTnXu5qhHkZmrdvMxcLF6bguu3pDhjc2XYKAsOuH7m77iF5ez7Gd6/hITSkZU9iiCYYMPzznkYnyZbXqOzgLN/dmLMunJTd8iaLCLltZDq+Y2YoBvgNJefCF+h5UAKQA/n204mkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bO+TtUrL; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7126d62667bso2650347b3a.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 10:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724088898; x=1724693698; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvr0J9ZuG3UW48C7b98BBRwz779hzA2BA91eRAwrF3w=;
        b=bO+TtUrL1OZ0Bde3LgPnMhLuFjT02eH5P8CXgJ0VIIkErPW/gn9tlKwY2/QQDYDTbM
         lit9c3HQ3LGbB+CqcFYVPOCwwLH5xNGWW66anQ+SZd0xWF/KfugGVvmrYWG9Led8Kx5c
         7Ue017LeJ3pMoa5G/MGNTAg5H5I4Ka4HN3IQbUro6tALwSuQ6ALc21GTrAG59rhGySjS
         mU4Lt08PKCrXKybcM5gJgbzRiJXH35/hd7mXUjPJNYsBgK6ymrMZ9E3aWYMo+yhioEyA
         hu6wfX/C50LpW973Ra6uZVZxYQ4mZunq5FIA9iFB6nEHX957ViSFNqBpbJXJol4TJ46+
         mMSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724088898; x=1724693698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvr0J9ZuG3UW48C7b98BBRwz779hzA2BA91eRAwrF3w=;
        b=ce7mhx6VrTGeBZMwBeTv7YhQPIl/2mYTINeP5mHnFn0mCUa+Ct349xIQ0eBRWtBMeO
         E2d1qDofJ7Yv5DpTexB2HV+p8ZUyvba3hbTm+8T2CL+ns0e7gzKpMmmdcXVrhLkek6w+
         jaBo4tQe5BCt4Wx1CgKBmBwJvaB8+Yia70G+PMAoO6Vs0sy67kHHRFLVoWN5dPWbyn4M
         0j4uQul5jGqHUhiOVjEpkG+Hx8BT4oLNUE4fR8HsrSOsxgEU28/TGb84B4hKk+1y3XB5
         14bTT7/21sqDIixat2OVMJzdAdRmsnGDXC5RE3HnuYT185dKNBGdMzi/BAeIAQCoY6T2
         ETZw==
X-Forwarded-Encrypted: i=1; AJvYcCUVo2eJy6+WmWVscMHBH0vACWbjDb3Feus/TuGTHgWgRgOSkq24JcbJxtVBAv01k4CZ/cPitYg/yvVb8v81iVlE+Jlr
X-Gm-Message-State: AOJu0YyGFe+uxYQaGzOU1iYkoxMjBTIgh9gNeB79xuGFED1lFURD7Cjk
	olYvTMwjZb/sJvMqzKqpw2NwpGSvlITZT4h2OjyzER54ZZR9XurmlMi0Rj2cyA==
X-Google-Smtp-Source: AGHT+IHSoVrZbK8JKRKcOoOO6pqNJPsdr5vFIHI2GSN+NXwnDc1LHQrZdggbtz7zdm7l5Hb3Ce2aKA==
X-Received: by 2002:a05:6a00:6f6a:b0:706:742a:1c3b with SMTP id d2e1a72fcca58-713c4dff651mr9673380b3a.8.1724088897429;
        Mon, 19 Aug 2024 10:34:57 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127addcc5fsm6826137b3a.9.2024.08.19.10.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 10:34:56 -0700 (PDT)
Date: Mon, 19 Aug 2024 10:34:53 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dmatlack@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Recover NX Huge pages belonging to TDP
 MMU under MMU read lock
Message-ID: <20240819173453.GB2210585.vipinsh@google.com>
References: <20240812171341.1763297-1-vipinsh@google.com>
 <20240812171341.1763297-3-vipinsh@google.com>
 <Zr_i3caXmIZgQL0t@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr_i3caXmIZgQL0t@google.com>

On 2024-08-16 16:38:05, Sean Christopherson wrote:
> On Mon, Aug 12, 2024, Vipin Sharma wrote:
> > @@ -1831,12 +1845,17 @@ ulong kvm_tdp_mmu_recover_nx_huge_pages(struct kvm *kvm, ulong to_zap)
> >  		 * recovered, along with all the other huge pages in the slot,
> >  		 * when dirty logging is disabled.
> >  		 */
> > -		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp))
> > +		if (kvm_mmu_sp_dirty_logging_enabled(kvm, sp)) {
> > +			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> >  			unaccount_nx_huge_page(kvm, sp);
> > -		else
> > -			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
> > -
> > -		WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> > +			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > +			to_zap--;
> > +			WARN_ON_ONCE(sp->nx_huge_page_disallowed);
> > +		} else if (tdp_mmu_zap_sp(kvm, sp)) {
> > +			flush = true;
> > +			to_zap--;
> 
> This is actively dangerous.  In the old code, tdp_mmu_zap_sp() could fail only
> in a WARN-able scenario, i.e. practice was guaranteed to succeed.  And, the
> for-loop *always* decremented to_zap, i.e. couldn't get stuck in an infinite
> loop.
> 
> Neither of those protections exist in this version.  Obviously it shouldn't happen,
> but it's possible this could flail on the same SP over and over, since nothing
> guarnatees forward progress.  The cond_resched() would save KVM from true pain,
> but it's still a wart in the implementation.
> 
> Rather than loop on to_zap, just do
> 
> 	list_for_each_entry(...) {
> 
> 		if (!to_zap)
> 			break;
> 	}
> 
> And if we don't use separate lists, that'll be an improvement too, as it KVM
> will only have to skip "wrong" shadow pages once, whereas this approach means
> every iteration of the loop has to walk past the "wrong" shadow pages.

TDP MMU accesses possible_nx_huge_pages using tdp_mmu_pages_lock spin
lock. We cannot hold it for recovery duration.

In this patch, tdp_mmu_zap_sp() has been modified to retry failures,
which is similar to other retry mechanism in TDP MMU. Won't it be the
same issue with other TDP MMU retry flows?

> 
> But I'd still prefer to use separate lists.

