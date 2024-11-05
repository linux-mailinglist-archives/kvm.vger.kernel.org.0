Return-Path: <kvm+bounces-30582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BBAA9BC243
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CAD11F22BD1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 01:03:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4340717736;
	Tue,  5 Nov 2024 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iAQNB8Qd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B179E4C97
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 01:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730768603; cv=none; b=uydJp0pmvqjqAf0C4M5RHFx7rA3o517vIuAw7rHV70NGMNgYF4Ez+E+gUBEWo7C2fBe6FgtUnqPL34LsJkfbLgx63Fon1z9GOSL6oMG3HZSTgNfTGWDuxkpgjQL3V3nhLPbPIdqXcpwQVKd3x2ZF1O0rdpTi88cHpZvCUXqlGIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730768603; c=relaxed/simple;
	bh=d15lgxLHS5+DnI2hgQeNwprldZATG/4iD9gETe4uxqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fk96pLe8wbcp0kw2L2wz7v7p3bv8sDoYahQ1U88b1KMYKAw6msWugGlMDirJ8tmGR9IdWEnZdUfeAXiAqvFmI6s5y9Z1mKBy1IGpsROuziUlcV3/hky4TfKgWCpdW5r5tnA20AqAQyZn41rgJRYHrAwmKoUGI1k6o9+vsT3FS/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iAQNB8Qd; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730768602; x=1762304602;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d15lgxLHS5+DnI2hgQeNwprldZATG/4iD9gETe4uxqM=;
  b=iAQNB8QdnRbhgKoKOCp6VEMiXsArwS2M49GRvblfS7KvqY95rhkxbXHH
   i88wAWt+7sOt0m5MpuoXHexRi4jC4XdFSrDWwkInmOR7MjZ2JCQzDuxrV
   0xpnpiKOZj8nVMHpHA+hHppn3e0KQGLBjcMVWOb02zFuEFUii5GSU+eMJ
   +Q1TENTahwzCwXwSzeQSWwk9osi3U4HViWt6eofDZmjZ1+Yaf8M8uHPxi
   x4/ysmWnX1h2pWeM9LeDe3gLoUhFsG4BztDRFvhNMedHUF5Bd5wpxPrZC
   1weKcwPTY+TnulRrzG6SZA/Xa11At7HxBqUp2vfvYdb/VPTRKIY9zpvbw
   w==;
X-CSE-ConnectionGUID: h1zjBuNHT+i3ec08FXwHbQ==
X-CSE-MsgGUID: ihaxg4DxSc+wBjYbqk2PMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30603246"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30603246"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:03:20 -0800
X-CSE-ConnectionGUID: fwHpGvpyTaqRpt7VgTBfuw==
X-CSE-MsgGUID: q6kfbfVMQp2Mc7FwFvjkwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="84639912"
Received: from linux.bj.intel.com ([10.238.157.71])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 17:03:17 -0800
Date: Tue, 5 Nov 2024 08:58:11 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
	pbonzini@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	chao.gao@intel.com, xiaoyao.li@intel.com, jiaan.lu@intel.com,
	xuelian.guo@intel.com
Subject: Re: [PATCH 2/4] x86: KVM: Advertise SM3 CPUID to userspace
Message-ID: <ZyltowkJqpD7BEfC@linux.bj.intel.com>
References: <20241104063559.727228-1-tao1.su@linux.intel.com>
 <20241104063559.727228-3-tao1.su@linux.intel.com>
 <c4e28cbf-c90c-4b7f-b45a-e59b384b03b7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e28cbf-c90c-4b7f-b45a-e59b384b03b7@intel.com>

On Mon, Nov 04, 2024 at 08:40:57AM -0800, Dave Hansen wrote:
> On 11/3/24 22:35, Tao Su wrote:
> > SM3 is enumerated via CPUID.(EAX=7,ECX=1):EAX[bit 1].
> 
> Please don't put things like this in the changelog.  They're just a near
> literal copy of what the code says and don't need to be duplicated.

Yes, I will drop them. Thanks!

