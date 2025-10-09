Return-Path: <kvm+bounces-59746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D0262BCB2F2
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C97194E59B8
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108BA287516;
	Thu,  9 Oct 2025 23:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cMHCrxcA"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9784039;
	Thu,  9 Oct 2025 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051960; cv=none; b=Wh3l+rSJsDkAC+GKQn/eCfvlpGq0jtFZXRP/r5S8ir86m+ux5B7amN1zXdzyfNwt/HzfX74hgyFRwzfsNGhWLtmqFXiRcObSfxjKotVaEInUNKe+kxcZUCtrfvGT7WwbpxTjM9q647tnPNcK/MpRR5W0/g1trc2RtRRk5MB0bWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051960; c=relaxed/simple;
	bh=YR/xnj5brcdLNIJ5ojF5bgsUyv47Oez54Yka0wOByNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mplw8h070ZKsId5fSdGXAcSE/8RZWBH0huA4MW0dLOTos+uuUynmE89SQSD1Ojf6t0uHeOxxKv5bAqy3KtbUDieQLH1XIOAl4kBqFDp29wZj2+9YIbI2m6/2y1dw1jCei1L8i03YWBAvmkH05y7d91U7ra72L4zlklA5ZIjdRFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cMHCrxcA; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 9 Oct 2025 23:19:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760051956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fUb793E4DKLeh5s+bQ8FZZbGdBb5oYBuDsenY0xZMvs=;
	b=cMHCrxcA+zFPIT7mgJvi2iZUOvU/8NFXBtPeVuBHC5dUi9o+PIWl52bwejk7fByiAfBRty
	7/ANTNsNGRoJ7q/l0ppFJE20+txrJmThd+j/Ec4aRCN2MgEps/Fi/vx53JbSYnC6k1MQ+C
	Lkuc7GNRPfeqLQXvu5UET8qpG+jUQl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: selftests: Extend vmx_nested_tsc_scaling_test
 to cover SVM
Message-ID: <qnel5p4xlukvyqmxdm5xhe3zj35dhsbjxj3dxohkrc2chpteus@hmfanp6agg64>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-5-yosry.ahmed@linux.dev>
 <CALMp9eRv3nraPfKLExX=cxhqSrShg=74gMkYh9R0jerhG4tt-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eRv3nraPfKLExX=cxhqSrShg=74gMkYh9R0jerhG4tt-A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 09, 2025 at 03:51:13PM -0700, Jim Mattson wrote:
> On Wed, Oct 1, 2025 at 8:03 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > From: Yosry Ahmed <yosryahmed@google.com>
> >
> > Add SVM L1 code to run the nested guest, and allow the test to run with
> > SVM as well as VMX.
> >
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> > ...
> > +       /* enable TSC scaling for L2 */
> > +       wrmsr(MSR_AMD64_TSC_RATIO, (L2_SCALE_FACTOR << 32) | 1);
> 
> Why set bit 0 here?

Brainfart. Will fix in the next version, thanks.

