Return-Path: <kvm+bounces-61504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D3ED8C21578
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C361B4F14D5
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 16:57:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013793164BC;
	Thu, 30 Oct 2025 16:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NB3PkIEw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF42F12BE;
	Thu, 30 Oct 2025 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761843421; cv=none; b=OTAwEUf3vsm9i/i60QUKd1cbX/ASH9PhGSqjpvirkj2wimLJzqQLurz/By5xgz+7XddRbAln36RGAKF6oxvrJT87FtKq8dIoQWAigTBWM3UZSBlrCvvfAF7/S019zoM3hZ/qCQLuzMvMN9/e6ybTEIr2oRoBHu4iktoTCiHb1ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761843421; c=relaxed/simple;
	bh=Bu3GaDn+KhEy/BmFR54Rp6ZMwsXMWG+ZTktrK8/UtVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhySKAbr6UMKojYm5w21bi0YBZ21MyDM1GhRPNljteBVZQWqofq6Pi2GFC3U/KYWlJePqji8PvI64G8w2+/scod9pb+HggekmGgLZIYxUGIZ74lzakTPc9dcgeDKUFNqKmO/8gtM32hnsBBoEkya6ikqiJ1fxV5zrJ90uaBQZcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NB3PkIEw; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761843416; x=1793379416;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bu3GaDn+KhEy/BmFR54Rp6ZMwsXMWG+ZTktrK8/UtVE=;
  b=NB3PkIEwyoGS3PVNUGaEcT4LKfX+jC4vu/SV4arQKW0A2a1qAjpd2PvO
   K8rCQq7r7wgOPFgrBsqev7s33wan0eP8pEgqCoCwb1u55nyej7DoqO4ip
   /LWc8skT27ATQBC9XRJZUvBB0RherH5YukXJBZyNnG4sUv1kSHhS7XJog
   qavtJBxIInqRsgRnt8+gJckGcx+8nz6C7bjq+0uIbRImosG+mk6hVYrDD
   8bCSdv2po4YwN6EtLN3xcXP0SRF5M1IRhNmEMDRg89Ya1muxNL5lgRkmK
   NHIBhL5BH3k/8aOeZgsJJfH1Y+KIu+gEzwKdqzijVYQ240wO3iVmaKbP6
   g==;
X-CSE-ConnectionGUID: Nd8ktODIRGCx3VRw8102UA==
X-CSE-MsgGUID: UlHNHBLmQWGnQHqmpdI9lQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="66607376"
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="66607376"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 09:56:56 -0700
X-CSE-ConnectionGUID: JYmqv/AoSkWfV6zFxdk7pA==
X-CSE-MsgGUID: zeXhZBYRQRaqlY3mGhgd/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="186448967"
Received: from iherna2-mobl4.amr.corp.intel.com (HELO desk) ([10.124.223.240])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 09:56:55 -0700
Date: Thu, 30 Oct 2025 09:56:45 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Tao Zhang <tao1.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/3] x86/mmio: Rename cpu_buf_vm_clear to
 cpu_buf_vm_clear_mmio_only
Message-ID: <20251030165645.rsu2pvkgak32nyip@desk>
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
 <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
 <DDVNOKPKN4II.33NWK6IDYPRFD@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDVNOKPKN4II.33NWK6IDYPRFD@google.com>

On Thu, Oct 30, 2025 at 12:29:39PM +0000, Brendan Jackman wrote:
> On Wed Oct 29, 2025 at 9:26 PM UTC, Pawan Gupta wrote:
> > cpu_buf_vm_clear static key is only used by the MMIO Stale Data mitigation.
> > Rename it to avoid mixing it up with X86_FEATURE_CLEAR_CPU_BUF_VM.
> >
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> (except the build issue)

Will fix that.

> Reviewed-by: Brendan Jackman <jackmanb@google.com>

Thanks.

