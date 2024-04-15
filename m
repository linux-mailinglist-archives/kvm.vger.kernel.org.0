Return-Path: <kvm+bounces-14701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19BC28A5DD8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 00:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA123283B46
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 22:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B480C15885D;
	Mon, 15 Apr 2024 22:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nDFCuUeS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9140F1B80F;
	Mon, 15 Apr 2024 22:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713221478; cv=none; b=fKscdowQkbarc7ILmFe81LpuGDY5pNBtPi4jWtSt8PbUBkQFUKp3s8EKZlIvXxbN7eEQWXqPk53n95i5YFFvJGOOH/cuvNI5PWFhQQgwf0MAXhuLiyrfYXOkRp0EQauaAHdJ1cQSnK4gRsO2fVo7apZ9+eXKgEdx/sVd1PojQcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713221478; c=relaxed/simple;
	bh=NHyNdJP4kIYQm6I4Mu8rr7Xbs16DH+isQARC18Kfx7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfXKKAlwi6kQQGMsnPWlg9GZPH81aC8Irpwi8kEdeTVj4TNECzNgLZNxh2a2PBrgCLWR10HUN5cVOFJzV3pUF7j1K7E2vPf3JN/X0Lsh6yL92b/ig9z9zgPdYtW1yFDrdKO0ziaQMMsk+VI3zwdtbmKpPsrnKVWtZ5d9UTDMCmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nDFCuUeS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713221478; x=1744757478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NHyNdJP4kIYQm6I4Mu8rr7Xbs16DH+isQARC18Kfx7E=;
  b=nDFCuUeSuxGABE3ulBQoASazT9IdnDDxeJtiyUaUANNJw5dK9IE0GDby
   OGjYMStCkBn8C6FbkXrVLSxy93zuj+/5gaD6ZXVopNMP2NBAnn3UhlNUo
   2cJG9/288o1SqRtHjiVn+APPG1B3Y0InTOh31iA1UQcrm1iFmVMAI5O5P
   Xt5uYAZAH9WIbS+QcSjYGSsRiLDVOV0O5/EtwWbzPBzcryNwFCH47O8BR
   KZD6epIm2+jZiZrn7ahD0b0Lr0mL9GXjbtL+M9Ilxsl+pX3trI6WLeWz7
   /UOkBzWGtQq6KolkdgoYqecI5cLI1d4CrrZedBTINq5pmHLN9HZfRojKK
   w==;
X-CSE-ConnectionGUID: Ftb4W3ElRhmhvdZVB1VUDA==
X-CSE-MsgGUID: Cunge7YWSI6mKdQifWmnpg==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8491719"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="8491719"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:51:17 -0700
X-CSE-ConnectionGUID: Nv0HIZNbSuCtZ487mEP9zw==
X-CSE-MsgGUID: ySKigc9tTQeMm+wPBX9uvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22140454"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 15:51:16 -0700
Date: Mon, 15 Apr 2024 15:51:16 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 097/130] KVM: x86: Split core of hypercall emulation
 to helper function
Message-ID: <20240415225116.GT3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6547bd0c1eccdfb4a4908e330cc56ad39535f5e.1708933498.git.isaku.yamahata@intel.com>
 <73394dea-81d9-469c-b94f-6d58bfca186a@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <73394dea-81d9-469c-b94f-6d58bfca186a@linux.intel.com>

On Tue, Apr 09, 2024 at 05:28:05PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > +{
> > +	unsigned long nr, a0, a1, a2, a3, ret;
> > +	int op_64_bit;
> 
> Can it be opportunistically changed to bool type, as well as the argument
> type of "op_64_bit" in __kvm_emulate_hypercall()?

Yes. We can also fix kvm_pv_send_ipi(op_64_bit).
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

