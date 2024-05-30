Return-Path: <kvm+bounces-18366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B728D44B1
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 07:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F21731F22C8A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 05:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5010F143C45;
	Thu, 30 May 2024 05:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCpAjKSn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D762BD0F
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717045964; cv=none; b=sF7RoL4Wa4lKKIiRxulzUZmi01cLCt8KEtGXqMewyzc4ahQr3UngwBi61zhfD0fvyEzC/xxs9OJ4qdzk4JZVqn6A0LUsfeXeFKBTsD7BFjYYTxyOYA/nQCGLLuDkXlQcjx8C8Il+1v25hNyQFC3On0uavh7dd4N8OckRX4MkDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717045964; c=relaxed/simple;
	bh=VL7H8fQqd8nIHUwam6QTyMO5mDtMq5T7rwyxfbnRY40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naliVffRi2TLEO5jfwPDVKVQFBX9Ve2VVwujYfyT1TBKzraGHdkFyhaMIqT+PUlwQ38AlhG9pwrItJRcsIg+Y6994p5Xhy4g+XI8Hgb94V4nRPlZduejW8T/P/LZS9TWWvumhr02ms8DsklyUyUM0I39L3ziPyqwH3K8ubIEnrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCpAjKSn; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1f4a52b94c3so4053945ad.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 22:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717045961; x=1717650761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lsuBDYq9BDHnrjQ91CodaxuYJofbd1MSvq6lCNBpu6Q=;
        b=GCpAjKSnYVJwdce3TEjzXFLxGr83pO4CosKsaJtDqflEV74y4MHvrj29GqzUGD9SvE
         hkPS90100jJ5j1bF/irLBYznABFbwNozWyOf95LjJm8pHvXKp/F5+uZA/xeRqoPrpkUL
         t+uduyxGiIhPOdgt7N6DZnH4NPnYzRof+kGtsede8kiv1uxW4bq6JZX1/reowJ45YJpC
         dxOKyitGeryHF+KLPsgScfpm0gw7MBtHahLjumN9bGSilmPjIXenRQi3a1lS3JeJuy7Y
         TSjYnh1vf1vRwNG+5mPBRomV9H7SjV1hwQZKwKtdouE3JxLjzDDKVCF5c8d2nhK2162m
         sduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717045961; x=1717650761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsuBDYq9BDHnrjQ91CodaxuYJofbd1MSvq6lCNBpu6Q=;
        b=LGKNeFTHO6WEuuGfC6KFl7mxPnRpIVqk4i3LGU99KSpUtfgMVNH/ZvGBhq3fRJTTYy
         /CgpjN/Yf4lBVDSgsJJP3N1zntwGqcQcn9LcOtCx696HedLFVl2lHq3uap9sIazLJjum
         SktId6hv53icni0NjtBC2nye2ZdJqiN+ksEVHys4ouKtlEUTG4aO1YCKlGSxoiTSEb+I
         lxDNoccbF/egIsuY8CWqnuFDnSVOwoMndqMe4HkqViKhaYqGzkcLmSFRJ4pPkeCRoLjg
         CUIaU3SjAtrYB/e/Aj7HHU7EiJYScsGXAnAanNg2lEr+h5O9fyORgVWdJs+07WsCfP+S
         pRnA==
X-Forwarded-Encrypted: i=1; AJvYcCXvao6k1/a+JbbEOgRIO6biFZTOI/2r4TL0513mO2PVXfqjDOddUoCe5djI7IrwVLknxyvivkqfi3SQJfFk7TEDridg
X-Gm-Message-State: AOJu0Yy13hc3/OG7yfQRr6pG2vG5Aspwme2gQRjsSiutmlYk3SVlh9+U
	qriIu8wnGdXY9DRO4S+pzHKCo7Et2rz4+Dn2BRzyHi33w2GAiiTmNRKGk6EpzQ==
X-Google-Smtp-Source: AGHT+IE8SaVeF/ixvsvfsb7cY1TEvKFZg63GHo6DzI1+1r7OKM5WXqYQ1YDSRkePpYz9kTBkgwKlBA==
X-Received: by 2002:a17:902:e5d0:b0:1f4:92d4:d126 with SMTP id d9443c01a7336-1f61962124fmr12878015ad.28.1717045961292;
        Wed, 29 May 2024 22:12:41 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f44c75e79fsm108939435ad.40.2024.05.29.22.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 22:12:40 -0700 (PDT)
Date: Thu, 30 May 2024 05:12:36 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Chen, Zide" <zide.chen@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 12/54] perf: x86: Add x86 function to switch PMI
 handler
Message-ID: <ZlgKxGmJWr8tUHsv@google.com>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-13-mizhang@google.com>
 <f49ebe98-c190-4767-bb0d-471776484fc8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f49ebe98-c190-4767-bb0d-471776484fc8@intel.com>

On Tue, May 07, 2024, Chen, Zide wrote:
> 
> 
> On 5/5/2024 10:29 PM, Mingwei Zhang wrote:
> > From: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> > 
> > Add x86 specific function to switch PMI handler since passthrough PMU and host
> > PMU use different interrupt vectors.
> > 
> > x86_perf_guest_enter() switch PMU vector from NMI to KVM_GUEST_PMI_VECTOR,
> > and guest LVTPC_MASK value should be reflected onto HW to indicate whether
> > guest has cleared LVTPC_MASK or not, so guest lvt_pc is passed as parameter.
> > 
> > x86_perf_guest_exit() switch PMU vector from KVM_GUEST_PMI_VECTOR to NMI.
> > 
> > Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > ---
> >  arch/x86/events/core.c            | 17 +++++++++++++++++
> >  arch/x86/include/asm/perf_event.h |  3 +++
> >  2 files changed, 20 insertions(+)
> > 
> > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> > index 09050641ce5d..8167f2230d3a 100644
> > --- a/arch/x86/events/core.c
> > +++ b/arch/x86/events/core.c
> > @@ -701,6 +701,23 @@ struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
> >  }
> >  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
> >  
> > +void x86_perf_guest_enter(u32 guest_lvtpc)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	apic_write(APIC_LVTPC, APIC_DM_FIXED | KVM_GUEST_PMI_VECTOR |
> > +			       (guest_lvtpc & APIC_LVT_MASKED));
> 
> If CONFIG_KVM is not defined, KVM_GUEST_PMI_VECTOR is not available and
> it causes compiling error.

That is a good discovery, thanks. hmm, we could put the whole function
under IS_ENABLED(CONFIG_KVM) to avoid that.

Thanks.
-Mingwei

