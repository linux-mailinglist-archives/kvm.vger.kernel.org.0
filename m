Return-Path: <kvm+bounces-60754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A2EBF9327
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EADDD4E6C50
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 23:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C0A2BEC23;
	Tue, 21 Oct 2025 23:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSlVmWxz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6F27BF7C;
	Tue, 21 Oct 2025 23:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761088720; cv=none; b=WCLzmUVURcS843qVJhJ+KNaxJQ8XpSx3R2LQe7vw8dhPy6A5hS3tLWsG2ulvXxBHq08kphrk3v+RbRJ8lHewZ6GAK4/7yFfuOVy0fkcO/fEOJ4NXv1uORD6wlPQdR2v2RGW8+fez/RLz18vKGkOtXqf4DT9aJuFs3TmELjHU9YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761088720; c=relaxed/simple;
	bh=5NroiVkaikWWHu19OQjjcQ2Dp/7no3wz4Nn5cDugRl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8s7AhIzEiOWFaB0BJiubAF9nzj66N3zFmNeI01P0zZuaVmNGWMPy8W4AW8inyZOAURfYzyJf81YUvpYoW2A80kEfpj4gHJJD2f3ggwYc9zf57iPOZFBvUunkkT3BMcEREAsg1ZVLpvAGffYhp2KObA80nlSNFRcAjhaIG+NCtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSlVmWxz; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761088718; x=1792624718;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5NroiVkaikWWHu19OQjjcQ2Dp/7no3wz4Nn5cDugRl4=;
  b=gSlVmWxzeF5sryM9KGwZMajy/s1ys3cgd6wJZ4nqDTR1OMD6mJa38slI
   B0vK6xrc3IeVtyRJDF2LGPkBRvc/GqMnTUKtjcvf6pUbMq0Ld9bgUXTCT
   zMFIngsden+BGVmArCdvca1zpL4Hh/TZWlbdgLlrCZqr2FNMPY03kn08q
   79DrTZyCZWMQgRdB1ckGNM4A96mkBYuYUnRqXEpCswr3crqEVWrRD6FaR
   OMlbeLmyuDakLcB+YTGFpKfuED8nkwiIZ2Bfiqu8NJU6/UIKycunxyr68
   iB6DfCSVocjsJmKgdWMfx0kYLIEwV5sg3atfyUpoA4gLvMizFLun4j0wH
   A==;
X-CSE-ConnectionGUID: YdW33UBmSV2rjS3SIt80mQ==
X-CSE-MsgGUID: zLCMYoW7R2SNBQWNa4AU2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62435632"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="62435632"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:18:37 -0700
X-CSE-ConnectionGUID: /cnXQnTrRUy0K6o4mM8R3A==
X-CSE-MsgGUID: TcyLRb7QTCGYmrCsF4Uv0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="207389220"
Received: from bkammerd-mobl.amr.corp.intel.com (HELO desk) ([10.124.220.246])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 16:18:37 -0700
Date: Tue, 21 Oct 2025 16:18:31 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v3 1/4] KVM: VMX: Flush CPU buffers as needed if L1D
 cache flush is skipped
Message-ID: <20251021231831.lofzy6frinusrd5s@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016200417.97003-2-seanjc@google.com>

On Thu, Oct 16, 2025 at 01:04:14PM -0700, Sean Christopherson wrote:
> If the L1D flush for L1TF is conditionally enabled, flush CPU buffers to
> mitigate MMIO Stale Data as needed if KVM skips the L1D flush, e.g.
> because none of the "heavy" paths that trigger an L1D flush were tripped
> since the last VM-Enter.
>
> Note, the flaw goes back to the introduction of the MDS mitigation.

I don't think it is a flaw. If L1D flush was skipped because VMexit did not
touch any interested data, then there shouldn't be any need to flush CPU
buffers.

Secondly, when L1D flush is skipped, flushing MDS affected buffers is of no
use, because the data could still be extracted from L1D cache using L1TF.
Isn't it?

