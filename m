Return-Path: <kvm+bounces-61922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3AAC2E767
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 00:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5462E4F301E
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 23:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D753002DD;
	Mon,  3 Nov 2025 23:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g4PwfPNf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714A72614;
	Mon,  3 Nov 2025 23:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213478; cv=none; b=s6rY3A4pcJ+AE9XSOj4j43sSboUKiGld5QlSc2GBCJMwXzGt/j0/JJjgtRNjmcIAvxUa56GQxds/K5gqTzMUM51P8cCOB+G8bGTdnIcLcGycS5qoAc6HZeQCoFp4PfvZPnhwQ47BIuXXXfa6wcVCC3xERyAiqojUeN4o1RWJpB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213478; c=relaxed/simple;
	bh=4zlAndWqArVrtRye/SjHxQy3Eu33EhiAlDQI/abNLSI=;
	h=Subject:To:Cc:From:Date:Message-Id; b=EHqck/hWeHOsGubZofFtq3ZIupeT75jcg3P8pgawaxZdYiu9snvuVWUxcq1XlJhMvpOaDuQRbjMKqKQ2xvLYgnJZeK/n0fCYiMQrShDNrmFcKeMLPzIcoQeIDHlaRy8BygRH5DbrzTt3ZfTf3bbtFtudAh6HXn4lSAeHOQrVwC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g4PwfPNf; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762213476; x=1793749476;
  h=subject:to:cc:from:date:message-id;
  bh=4zlAndWqArVrtRye/SjHxQy3Eu33EhiAlDQI/abNLSI=;
  b=g4PwfPNflCGn4NL1vOXaH7y0Mz5qGdtJKVU88J2iRRSGtTlox+vKCT2s
   jI8G+TVPf0TzuPLwfqtSzNVU0jp4KDFYYckLGYdCiq/UYduGZNHiNWvcr
   gisy7OqSll5mW0IaeHyJYFS1RW6omVQDBf2lN9jAaAOwTCH+SzXyunqEP
   hELfDrsJN+vI6UIlfigexll4lyOUu6ZEZqeY4nJpRW8OW1WaBjjYiGsl9
   Qy/gbgiGPMUyFFpPs/6dX+W8yTxUzqr6OUIA6doFE9jzEd0+98JnUXrGw
   kw2X/SdBMjyvff1A7behb9f9Rh3U5p8OGZpIs/HDjw/xM2Gt4c0Wsy21o
   w==;
X-CSE-ConnectionGUID: RyKkQrS1TluViZ273TJL2w==
X-CSE-MsgGUID: C3mFVX/NT8ueC6dN76PHhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64217933"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="64217933"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 15:44:35 -0800
X-CSE-ConnectionGUID: RPXljUSGTFyAdjiWzQb47w==
X-CSE-MsgGUID: 0zDh9bGTThaE2oa1aKFFpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="187150880"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by orviesa008.jf.intel.com with ESMTP; 03 Nov 2025 15:44:35 -0800
Subject: [v2][PATCH 0/2] x86/virt/tdx: Minor sparse fixups
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 03 Nov 2025 15:44:35 -0800
Message-Id: <20251103234435.0850400B@davehans-spike.ostc.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Changs from v1:

 * Add Fixes/Reviewed-by tags (Rick)
 * Add some "backwards" KVM changelog blurbs

--

Sean recently suggested relying on sparse to add type safety in TDX code,
hoping that the robots would notice and complain. Well, that plan is not
working out so great. TDX is not even sparse clean today and nobody seems
to have noticed or cared.

I can see how folks might ignore the 0 vs. NULL complaints. But the
misplaced __user is actually bad enough it should be fixed no matter
what.

Might as well fix it all up.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Kirill A. Shutemov" <kas@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

