Return-Path: <kvm+bounces-6520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1DD1835D70
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 09:57:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42EF71F24DA5
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 08:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 130E139AC8;
	Mon, 22 Jan 2024 08:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nf23aZpl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A055A39859
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 08:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705913724; cv=none; b=m45vhNHpGFNYxwgBbtdriLBqaFAR7T1Fwrn9r0CZS/HAakVEGMORwVX36du+7/zdGHsr8SGlaKdgM1PR8FgCXDKA1A9nybMwwRA28ugNJ8agDH/uLJpx1ra3Fz3dAQYGDq6q4r0wWl5iyNKW6dtq90AYRCPyvD5UDa4e6JFrpyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705913724; c=relaxed/simple;
	bh=wUdT4fRB5Nf5lr+Hx1LVC2U0RFqx5arh4ZtYweAoHYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=On66FCd9Br57GHiHNaidOGqXlKQbKimXd10jClmxKosJDtVDtiDOTkYV4/xeelMc5xvleXxZu36Eqgo5pa1Fz//++oPwW0nXD2tfQCBzGPRzOTySp0LQF1eZWzNQdTIU3YunsKzn6hAdA+BqexQ5ISKLFdSpAjNx3j3MoK5Ntmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nf23aZpl; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705913722; x=1737449722;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wUdT4fRB5Nf5lr+Hx1LVC2U0RFqx5arh4ZtYweAoHYI=;
  b=nf23aZpl5L6vSO5L1uriPyBe75TVxLSWhgYCz+TZAg4JBLtnIlqr4CyC
   s+gpXhveyhUUHEcP9vr49U3qa9V5DmvV7Hyca3kTxY4gKSHtyQZAClSwC
   MJlGg8gCSmgnCN6zPBg7RECT0wiXYGdH/uvIxKXydOJpMYGRe4PeMZPGv
   M7ER2UgrkQEohekJQyY2ppJqKVbkxw/2ZkxqNgrhPUQwYurRMHQfLlor+
   jj7g5xEc6+XZDcQdLL7VT7JUCMbq2lyPEvJKCg2wvA66030merIKAFrIJ
   A5CCcUP1glanl7fMqbJBTF9kBpLjBeAcFMT8q+1GpYJ3YAiJzgxJiFuGC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="398301307"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="398301307"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10960"; a="928932124"
X-IronPort-AV: E=Sophos;i="6.05,211,1701158400"; 
   d="scan'208";a="928932124"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.49]) ([10.238.10.49])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 00:55:20 -0800
Message-ID: <d424a315-1b20-47bf-a88e-394f576c3cc1@linux.intel.com>
Date: Mon, 22 Jan 2024 16:55:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] Add support for LAM in QEMU
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: xiaoyao.li@intel.com, chao.gao@intel.com, robert.hu@linux.intel.com,
 binbin.wu@linux.intel.com
References: <20240112060042.19925-1-binbin.wu@linux.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240112060042.19925-1-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Gentle ping...
Please help to review and consider applying the patch series. (The KVM
part has been merged).


On 1/12/2024 2:00 PM, Binbin Wu wrote:
> Linear-address masking (LAM) [1], modifies the checking that is applied to
> *64-bit* linear addresses, allowing software to use of the untranslated
> address bits for metadata and masks the metadata bits before using them as
> linear addresses to access memory.
>
> When the feature is virtualized and exposed to guest, it can be used for
> efficient
> address sanitizers (ASAN) implementation and for optimizations in JITs and
> virtual machines.
>
> The KVM patch series can be found in [2].
>
> [1] Intel ISE https://cdrdv2.intel.com/v1/dl/getContent/671368
>      Chapter Linear Address Masking (LAM)
> [2] https://lore.kernel.org/kvm/20230913124227.12574-1-binbin.wu@linux.intel.com
>
> ---
> Changelog
> v4:
> - Add a reviewed-by from Xiaoyao for patch 1.
> - Mask out LAM bit on CR4 if vcpu doesn't support LAM in cpu_x86_update_cr4() (Xiaoyao)
>
> v3:
> - https://lists.gnu.org/archive/html/qemu-devel/2023-07/msg04160.html
>
> Binbin Wu (1):
>    target/i386: add control bits support for LAM
>
> Robert Hoo (1):
>    target/i386: add support for LAM in CPUID enumeration
>
>   target/i386/cpu.c    | 2 +-
>   target/i386/cpu.h    | 9 ++++++++-
>   target/i386/helper.c | 4 ++++
>   3 files changed, 13 insertions(+), 2 deletions(-)
>
>
> base-commit: f614acb7450282a119d85d759f27eae190476058


