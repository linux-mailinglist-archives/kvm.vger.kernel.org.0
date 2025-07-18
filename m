Return-Path: <kvm+bounces-52910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8BF8B0A7B0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 17:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89CFF189003B
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 15:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4042E03FC;
	Fri, 18 Jul 2025 15:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yGnP67TA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302462DE6E8
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752852946; cv=none; b=GkTjbm67uo8TOVEs/5Uth0OO5F7Eq/iDR74S3SNz5U2GtJK5jqCNSJ5Naws2Ene3tnx3HkgIAtJAmrv8LYy3GfOxC6AmHlvow7FxyHH8lzM2frPgR4wCEoHYQAsSRxTl0nhtuK+4BeGCecYpMWMGQJhP5bez2ThF0FqZfG8+FEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752852946; c=relaxed/simple;
	bh=4Vfku2YS9tu3aYWTykK4Ku/U89qRWW3/HUMuhIP/xd8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lvQpWZYFiDKK50KEJtUFrwvihoY9tFoZi0r6QKd53CtxoV1cfymln47fMHuNX2ABrPbZ10ALllqtDY+6dWvHIqGD/Z7OSAD3H4vvXy08BXElonWd6uox5J+lT62P1FMLc8BiTT8vTdsfuODSyUSSUgtcwIcx9ji0YdnXHJFvXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yGnP67TA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313f8835f29so3133917a91.3
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 08:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752852944; x=1753457744; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FMufa9slHHq3UhWrTz98ZkkB+x6OEpY7SyDzwmKTqZs=;
        b=yGnP67TA1aeUipLt1QKuhLpnCnv+D1az3GIpyyaq6m2Hbf5N8KDI8i0jrTuThQlJTC
         zhhNcq0qMC+fj9tw+dmryilRVfbQJbAgqOtzjse4pdWN4l/WqzXl3IGkWcBaAQjXGBgU
         S84omCGltJrEy1FcJvSHroMAzIzeeDguDVSCde6cKCL8wo6ROLojATx0rS6pLajgr5vY
         OfB2ZKpXpajdmeOGZlpb45BQF+1RuoKQlOuzeJTYpJX3k5hh1BEG3dMH83ZM2JjB4qOl
         loGpmqD2uBFii+zb0rTcZvyOEh4osNQeRSWnD1FngsX3X05sL8xkNA38XaPDkbrMQUea
         V0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752852944; x=1753457744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMufa9slHHq3UhWrTz98ZkkB+x6OEpY7SyDzwmKTqZs=;
        b=w0Gi4RRNufqEKSNn+hHIYi7nDBCVaowpbzMByJGGZkwbFmu+wjiMBlDWHGcVpGAaR4
         d59zN9b0y19jSDAWG4PYz2M/7PjONp/UNwX2w+MTmFs0nTnKNxKwtidYqTM1KQWFnUQt
         7YovmoyJkof/RT/NvAQpFoDzqi2Hl/uy5tt4Hja1iElocfOkZTyRzsJtHMq4gluhSW6h
         Pa97tFPeFNGM2GzAvvnKC35ozoc3BBr5NAmiesPi34pBmSn6De+bsNoa9N3M37AfixKr
         6r2eUP8FcZPbWbNOOb7lL6IpW+ni2daT+atMLE96nYtsgd41Vf/HY5TGEuuvcwj4Sztc
         IiQA==
X-Forwarded-Encrypted: i=1; AJvYcCVsUjda6rR6iLinajLJ5XYY8YfzR7dx9JlcWzD9+l/XhtLCKWCW/TD6Xtzlgq1LQkvojcY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJFCMXQVVKKc21Wu/PJjpeP+kfMwD2Lf162rN/+ijwF9aP3/Y1
	GLhtf7y/qgVq4ySYXZxUnwFqLCDMh4xq58HufZte2nXcjQBiBP9ocYdUo4v4QM1rHm6rZOpTimj
	oc6kRSw==
X-Google-Smtp-Source: AGHT+IH/1HWlOEGTinigbtGS/fI4pZaE0lBuxsB7y4G9gSRNWOYWs+b2FnDCG8rAn4n/EHZZ46lLEQTU4do=
X-Received: from pjbqa6.prod.google.com ([2002:a17:90b:4fc6:b0:315:f140:91a5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3511:b0:312:ea46:3e66
 with SMTP id 98e67ed59e1d1-31c9f45e1c5mr12926141a91.21.1752852944417; Fri, 18
 Jul 2025 08:35:44 -0700 (PDT)
Date: Fri, 18 Jul 2025 08:35:42 -0700
In-Reply-To: <930ca39f-41a6-44d4-85b1-552c56a417e8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com> <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com> <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
 <aHEdg0jQp7xkOJp5@google.com> <930ca39f-41a6-44d4-85b1-552c56a417e8@intel.com>
Message-ID: <aHppzp0WIbLZfVqu@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com, 
	kai.huang@intel.com, reinette.chatre@intel.com, tony.lindgren@linux.intel.com, 
	binbin.wu@linux.intel.com, isaku.yamahata@intel.com, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 16, 2025, Xiaoyao Li wrote:
> On 7/11/2025 10:19 PM, Sean Christopherson wrote:
> > On Fri, Jul 11, 2025, Xiaoyao Li wrote:
> ...
> > > 
> > > I'm wondering if we need a TDX centralized enumeration interface, e.g., new
> > > field in struct kvm_tdx_capabilities. I believe there will be more and more
> > > TDX new features, and assigning each a KVM_CAP seems wasteful.
> > 
> > Oh, yeah, that's a much better idea.  In addition to not polluting KVM_CAP,
> > 
> > LOL, and we certainly have the capacity in the structure:
> > 
> > 	__u64 reserved[250];
> > 
> > Sans documentation, something like so?
> 
> I suppose it will be squashed into the original patch,

I dropped the commit from kvm-x86/vmx, and will send a full v5.  There's enough
moving parts that I don't want to risk going 'round in circles trying to squash
fixes :-)

> so just gave
> 
> Tested-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks! 

