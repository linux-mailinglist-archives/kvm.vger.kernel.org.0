Return-Path: <kvm+bounces-30265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E7B9B8698
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 00:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202741C227E4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 23:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E291D04A6;
	Thu, 31 Oct 2024 23:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GsHWpqDp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459361CF280;
	Thu, 31 Oct 2024 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415861; cv=none; b=hE264WCURBCsMDk1zILuoO9MD6eWGJMuA8C8ZzGDecDwaB96sCdtbD6NG1hMqSeDQrhPFzNip+kw87deMAYjVThlh5K4fqjjCvl4hAgvP9cr9dJcn35GTQQzGe4jBhdsT4VsZqhhBmYmVC5Pn4B5X7VrsRQK4JJCy8IyhSOhtSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415861; c=relaxed/simple;
	bh=g6mgr1PiSpqyrNl30sSjTkEcTnFjsET5qcjpTWm2Pzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwGziNkL9mz0mqCwGLX6ZWrx28A9vB58xeQwcgXR+Gk9KaWD0ik+B7slvml6dsC1eZrLbuBdADkpFtM0qopFwrB0/OguEASUYFo2YsreaEF5oVYwIhwOxOKKs9f2y9NqSLaHe82dJ3WHtAE1awrdPBzEvjS5JzNG4yaaiGeEDv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GsHWpqDp; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730415856; x=1761951856;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g6mgr1PiSpqyrNl30sSjTkEcTnFjsET5qcjpTWm2Pzo=;
  b=GsHWpqDpiXXxeuSjrttl81hepIFmiKpPtXqRxwV0drpYqIyJHGPyZBpf
   OjE2uAXj/TY/rBPfYlol31kAg1r9FX4BU/lhIfVBzzaIIXrRgDpPUOvBr
   iZhV1f74wZrLosCYZpJYIPi5WTw6vF9DjSlqi7DxYgqGxAtXsxq1z85rI
   y6jz2NC5l6vVGLl9gxbnDL2Dtx3Sv9Swr4od6rkUmbNgDR5APUSz10FDV
   wcKvHHBbF30B5gMwGTtySR2VomvmcbUygU8NWaJkSKy4+CGBNl7gNvx1K
   JjkZDrRGg79xq2Z4RTO5udZChx3Qc2S93rt6hsoFCtgRqI+Dbd3NFgH4C
   A==;
X-CSE-ConnectionGUID: 6rIjlog6SgKzohIScB1CCg==
X-CSE-MsgGUID: xoMlOg3LSK+SKzkKm75b9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11242"; a="34114358"
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="34114358"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 16:04:05 -0700
X-CSE-ConnectionGUID: xlWR6pseQeWhTQ5qLJxk6w==
X-CSE-MsgGUID: zKlYlmxTRS6cTKeVIy+vAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,247,1725346800"; 
   d="scan'208";a="82700487"
Received: from adande-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.235])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2024 16:04:05 -0700
Date: Thu, 31 Oct 2024 16:03:58 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, jpoimboe@kernel.org, corbet@lwn.net,
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
	seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Message-ID: <20241031225900.k3epw7xej757kz4d@desk>
References: <20241031153925.36216-1-amit@kernel.org>
 <20241031153925.36216-2-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031153925.36216-2-amit@kernel.org>

On Thu, Oct 31, 2024 at 04:39:24PM +0100, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> Remove explicit RET stuffing / filling on VMEXITs and context
> switches on AMD CPUs with the ERAPS feature (Turin+).
> 
> With the Enhanced Return Address Prediction Security feature,  any
> hardware TLB flush results in flushing of the RSB (aka RAP in AMD spec).
> This guarantees an RSB flush across context switches.

Is it that the mov to CR3 triggers the RSB flush?

> Feature documented in AMD PPR 57238.

I couldn't find ERAPS feature description here, I could only manage to find
the bit position:

24 	ERAPS. Read-only. Reset: 1. Indicates support for enhanced return
	address predictor security.

Could you please point me to the document/section where this is described?

