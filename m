Return-Path: <kvm+bounces-14662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 087948A5229
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B41B1C227FF
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9187318A;
	Mon, 15 Apr 2024 13:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhetVyjK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F1C71B3A
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 13:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713188979; cv=none; b=Pdb8Mmeg4SLfPh0TCTuiqgFC1jMOU5Qc/7Ipgz4dyO6ammVNrAxyQlEDppOLyd151q1rYphIzcjiYUQm1CRdkVliQ8rUvtQnn/i48K7LBNRiMHDG4UwiA4SdiU86dnhAwljz7ml8pcze3dv+kKvCI3JQ8XBx9nvtGL/rcxJ3jik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713188979; c=relaxed/simple;
	bh=TvUNx+79vaopmzaM3PSKeNfcMIwNczVLZHrejGQKVD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XLdh0B2IE4rzrfQUJTR1Wmh6mAp6sEMelCeq5xiFO3SQaUgmJQt39XTSJzOi/k0VNLAMTKanr5UWpgdShz4L1TGQF3newwhNTWlJHyf+wAGUlwKduvvK4GQG7eYg/ke2Pt7dQcuiD5i8YfLoAiWEjWKKlWj77FiSyQV47Di1Qo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vhetVyjK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c65e666609so3303602a12.1
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713188977; x=1713793777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xyd56S0l2Vyx+AmnHkLVn8KVbV/FkDbyRlJsdS3u6MA=;
        b=vhetVyjKbC+U/ym5VynQzCHTXf8oCDev7vs++We7Vz8rBWldoPz4iNAk2n5mv4K/z2
         ykSgIEjVu2NwQAfgcg1gZI3I8oVuIWO2CJgDenDRx6PDZ1xQeCAqhqHd+VZ3YldrPYqi
         Q0TAAwlUYA80lVfO0g/DUR3Rdkpkdo0gZZlioUt/YFDgrDyHv3LsPh5sgDKCq7IZXZWb
         DzFDqrmbclmrkMD3Rwd1qHNrgQXKbNwsX3HXhc+TjyRBHU0axUl1J5BsjQzOcBFncyVO
         LKETZ1BiLfwoxLadxnpP4wqn5ebiwaoctSU2GHtq8B+73jMAHKnFEBd7dqsc7XoZZIVj
         O0pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713188977; x=1713793777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xyd56S0l2Vyx+AmnHkLVn8KVbV/FkDbyRlJsdS3u6MA=;
        b=FvMq17OGwNnQKGurgw+SW13KgKxcVEc3hDNq+vg+akn4LpMvb0M50/hqgSZrxBjFVU
         EIpIerkfm+7U1t1K1ZnSs2vNeeGFYaAGEHiZ2nGi1ec/uJg3aColw9Caoowuo+ou3AS5
         nqCbdN8khpQSSQuMpPO4uds31mXU+Q0LNpuuNYp2qRvdGP1b/+TyE1VBYPqBKQf/d8Mj
         R0RDzztrCP8B+9JEnOHni6vxm5AtIrec22ReEnrd1aTuRpHD6aiOTomAADMkun5w2Hyo
         XWAugVRQ7IuJzjKjwlys/oATwp20CndbxuLam65lqkpYdWnI4MYKJIwc+4jmecVF+fx7
         42cA==
X-Forwarded-Encrypted: i=1; AJvYcCUpyg0CgLflcCC4P7OWmiiNhMq2TxDKCBgIQWiQzbe0byYJqMVDoLlk6ucmpTprKfs5RtVrYNVGO3hHWt4UWDse5fz9
X-Gm-Message-State: AOJu0YzpZeHtV7EGuUxOO3N+CJED4zILkdsNqxroqKUqdBV11h2fqtiK
	m1gvkdG7HzBqCg/Br7LNAPvcBhFO2PTX88zRcuBeqNdUE3FaTko9ZZ65iyrNXR2eRdzV8WnPgtq
	bDg==
X-Google-Smtp-Source: AGHT+IHSFYB5Ovi0b4K5jyx+4UuWpvG3spx7cgwCfDIbLmGdSagtoqec1hfiGwAc/ZwSddi8gX2/4CqCx5Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8c:b0:1e5:e651:6099 with SMTP id
 j12-20020a170902da8c00b001e5e6516099mr727874plx.9.1713188977177; Mon, 15 Apr
 2024 06:49:37 -0700 (PDT)
Date: Mon, 15 Apr 2024 06:49:35 -0700
In-Reply-To: <20240413004031.GQ3039520@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com> <20240412214201.GO3039520@ls.amr.corp.intel.com>
 <Zhm5rYA8eSWIUi36@google.com> <20240413004031.GQ3039520@ls.amr.corp.intel.com>
Message-ID: <Zh0wGQ_FfPRENgb0@google.com>
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical processor
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, Sagi Shahar <sagis@google.com>, 
	Kai Huang <kai.huang@intel.com>, chen.bo@intel.com, hang.yuan@intel.com, 
	tina.zhang@intel.com, isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> On Fri, Apr 12, 2024 at 03:46:05PM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Fri, Apr 12, 2024, Isaku Yamahata wrote:
> > > On Fri, Apr 12, 2024 at 09:15:29AM -0700, Reinette Chatre <reinette.chatre@intel.com> wrote:
> > > > > +void tdx_mmu_release_hkid(struct kvm *kvm)
> > > > > +{
> > > > > +	while (__tdx_mmu_release_hkid(kvm) == -EBUSY)
> > > > > +		;
> > > > >  }
> > > > 
> > > > As I understand, __tdx_mmu_release_hkid() returns -EBUSY
> > > > after TDH.VP.FLUSH has been sent for every vCPU followed by
> > > > TDH.MNG.VPFLUSHDONE, which returns TDX_FLUSHVP_NOT_DONE.
> > > > 
> > > > Considering earlier comment that a retry of TDH.VP.FLUSH is not
> > > > needed, why is this while() loop here that sends the
> > > > TDH.VP.FLUSH again to all vCPUs instead of just a loop within
> > > > __tdx_mmu_release_hkid() to _just_ resend TDH.MNG.VPFLUSHDONE?
> > > > 
> > > > Could it be possible for a vCPU to appear during this time, thus
> > > > be missed in one TDH.VP.FLUSH cycle, to require a new cycle of
> > > > TDH.VP.FLUSH?
> > > 
> > > Yes. There is a race between closing KVM vCPU fd and MMU notifier release hook.
> > > When KVM vCPU fd is closed, vCPU context can be loaded again.
> > 
> > But why is _loading_ a vCPU context problematic?
> 
> It's nothing problematic.  It becomes a bit harder to understand why
> tdx_mmu_release_hkid() issues IPI on each loop.  I think it's reasonable
> to make the normal path easy and to complicate/penalize the destruction path.
> Probably I should've added comment on the function.

By "problematic", I meant, why can that result in a "missed in one TDH.VP.FLUSH
cycle"?  AFAICT, loading a vCPU shouldn't cause that vCPU to be associated from
the TDX module's perspective, and thus shouldn't trigger TDX_FLUSHVP_NOT_DONE.

I.e. looping should be unnecessary, no?

