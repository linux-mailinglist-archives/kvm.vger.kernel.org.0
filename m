Return-Path: <kvm+bounces-13258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 647C5893816
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 07:29:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94CED1C20AB9
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 05:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436379454;
	Mon,  1 Apr 2024 05:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VN0sRLnv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2F79DD;
	Mon,  1 Apr 2024 05:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711949330; cv=none; b=oeAkuv7GChnLAmrYUPCoRlbybrty+aFlQ2f053fa8iI3cs0ZH2YxdjDfwQNssBPKUjZLZesFI2NYxEKy1A9HZB/WSvA5s3icpV+46kQ3OUO+Dij9DRrecW/smkYYweTcDBDpij6aHRmtdlBds3Ft+eVx1s0vP88hwD/P2a+h1rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711949330; c=relaxed/simple;
	bh=3OO03zo5w4k1NXVF/Hv+BUcj++anSMK3kx0dwOuOTP8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nb+7j9QlbPVD1bHgNli8/sNa2KgRSr0oLOClxZQe12lu8YdrF7hWGfWFDaSRhce6o6hkkX5/Oe7trSHUFU3IGUzIc+H4KkveBkLZmaEsdDlblmPEVnXi1F+phTcNZy5tt8+YUoq2jRrzjPloAzRkwZYVR0OOB+aI53L6tO5+A/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VN0sRLnv; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711949329; x=1743485329;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3OO03zo5w4k1NXVF/Hv+BUcj++anSMK3kx0dwOuOTP8=;
  b=VN0sRLnvetWbdech3lsiOeB7e5q5SyPC2pkNQ3AasagWpPw9jy6ylBOb
   uGllb0mwodmzCo64mO/09lAs6KQFmXRQW6oZQ+/2LjZ0Rcydf/RQOcNod
   b0ECD/EQTzZtfH3iD7dPH4QR3y55v7Nxnzq9dc9KcVFFW/X8kbjcZsOME
   MbKlloeXnFlk3t0oeQt+6oleaSNgs7saVMMtyQ3dfRuHD5wHL4hF+41By
   3CalJ5fqquB+voKHUTYUyCPMOQXv5OzMGMoYHJLM5ul1/CHVg2T85AZzH
   VZ6aZ+JmLspf+ccJS8MHt7waOMO840WUNXcM7avcXaygkZNrUwJEmXCAw
   w==;
X-CSE-ConnectionGUID: KPiaDdENTsKbYAZLIpG6aQ==
X-CSE-MsgGUID: B/kolN2ASkid6nID/h+3WQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11030"; a="6899454"
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="6899454"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 22:28:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,171,1708416000"; 
   d="scan'208";a="40770542"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.224.7]) ([10.124.224.7])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2024 22:28:44 -0700
Message-ID: <2a17af71-95d3-41de-a962-ff223ffbd2fb@intel.com>
Date: Mon, 1 Apr 2024 13:28:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] x86/cpu: KVM: Move macro to encode PAT value to
 common header
To: Sean Christopherson <seanjc@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xin Li <xin3.li@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-3-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240309012725.1409949-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/2024 9:27 AM, Sean Christopherson wrote:
> Move pat/memtype.c's PAT() macro to msr-index.h as PAT_VALUE(), and use it
> in KVM to define the default (Power-On / RESET) PAT value instead of open
> coding an inscrutable magic number.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>


