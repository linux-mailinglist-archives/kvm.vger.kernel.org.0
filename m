Return-Path: <kvm+bounces-11942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E30EE87D63C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 22:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FA9B1C20D35
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 21:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7282954BD8;
	Fri, 15 Mar 2024 21:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R3MG9Abr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91E954BE2;
	Fri, 15 Mar 2024 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710538603; cv=none; b=IDgNNbie9MT8c/bLBHMCfUtFGejxveWc+oy4r6EmF7dCt7hptrZfWYNTGs9tsjD5k1sysWvZSq+LbySf5rCkT24EBUr1ZSsDGFNEespDhDyEYku83B3yBW0yADXThvzdJ9XyOtnhXhDrWILqUQ2GP2tDSPlcjphrUL20uvm3j5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710538603; c=relaxed/simple;
	bh=GQXUPfiBlSVvLTjL48ZfSB9ZLxCsBjgjHOWhfwvRGB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snNPthNqezlK+qtr1G0PNoqh6asW/AO0vCTwCb5Wy1EpE3Vc2GCUYt9HJ3naKbrcwB9n37F/1Jmchq7ZbqXkNJ6srp7ytSKlrZXXI5vKspxdr6ZXyQ2fTPFIlODmKvjIyv+LON/E/UwzQb1eRgm0hww/+P0OqMqwBQXphAuyA24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R3MG9Abr; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710538600; x=1742074600;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GQXUPfiBlSVvLTjL48ZfSB9ZLxCsBjgjHOWhfwvRGB0=;
  b=R3MG9Abr3JRCvrejMs3SXxt5LXQ/NdsDb6KDv6MAoVa5x5P+3JmKJ8hZ
   kLRty+C6mIexjt+pJKmSedsBfUmZADJ7hSshZNH+1PUotkZUgpZt+9ZRo
   4FQEfhYM7dlMF4sSTSZu5Saq3O/mEouJJBHLreTNKVJGRnEBXLwOy+5ob
   IU9W7wR3sayBUX2Osy4CpTHeb5zD2jis5aJKYZR3hw599PXOe9mCXzocz
   u+jCxJxaqkdy6dAEYL5OZMbeI+NzLkxqxSqgu3whTr/g5n6dsDf6K+fjf
   tzSghrKinbFAwYdNTSvj62vR3AvJqIaZTZ83G5sf6w31wBwxSVTke7kZb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="16828984"
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="16828984"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 14:36:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,129,1708416000"; 
   d="scan'208";a="17508714"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 14:36:39 -0700
Date: Fri, 15 Mar 2024 14:36:38 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 025/130] KVM: TDX: Make TDX VM type supported
Message-ID: <20240315213638.GJ1258280@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5159c2b6a23560e9d8252c1311dd91d328e58871.1708933498.git.isaku.yamahata@intel.com>
 <f4961c6d-aa67-4427-bcc7-17942b5f1a9b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f4961c6d-aa67-4427-bcc7-17942b5f1a9b@linux.intel.com>

On Thu, Mar 14, 2024 at 02:29:07PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:25 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > NOTE: This patch is in position of the patch series for developers to be
> > able to test codes during the middle of the patch series although this
> > patch series doesn't provide functional features until the all the patches
> > of this patch series.  When merging this patch series, this patch can be
> > moved to the end.
> 
> Maybe at this point of time, you can consider to move this patch to the end?

Given I don't have to do step-by-step debug recently, I think it's safe to move
it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

