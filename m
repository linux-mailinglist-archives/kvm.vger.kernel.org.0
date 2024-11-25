Return-Path: <kvm+bounces-32400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE529D79C3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 02:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51AC2B22329
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 01:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8919BBE5E;
	Mon, 25 Nov 2024 01:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aShGrGpZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A85B36D;
	Mon, 25 Nov 2024 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732497969; cv=none; b=bVKl4+kacRZVe/VpZ+A0m6DfhzpGWAd36QUeiL6YpruRxQxe0aQ6R6/2xRXseoTRfF7M/eTFDEalbjGwVaHehSryJYl1lZQu34EsREuJCLPxa2w1T5Hhphtdf1ogdueZgcYHtPYhJGdFnqBVzVl8gwdg62ufIG/5Oo6ugNiO/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732497969; c=relaxed/simple;
	bh=HQz+Pj9xyykrRznX3d5gcoWYrH68om3Us33aK61qgmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=haBbLQbx50UpN+xJyWUYTomiwVC/ietc7MFGWsU+hnDfZMqbBCWEWRvJBdw1f6ZsnJPg3/PchP0Is4vFT0m1AXkUTOwLCCceMqkJ+zrTwFfFd+JprXJ2TaBt2xqePzz976hhUOUP3dh14/nsmqUeUosiXhz7jdYdQQHnt7iIRiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aShGrGpZ; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732497964; x=1764033964;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HQz+Pj9xyykrRznX3d5gcoWYrH68om3Us33aK61qgmM=;
  b=aShGrGpZSpffXQdVlKiTAaQayfLvr2tlJE7oinDYKbqW2RO/ywxRgRQr
   1tswtKlYkJsKVH6cZE2+79ROPm9yI3nYd1dWlFuz0ijBLGkEQRF/2+tSj
   VfPKgaH7dloSW1bPhenahdAqqXbFvn01jzvGInQfqeAyp89SOntWcWz5b
   cGQX6ICdxSASEiYBtz0ki5tsWm6xRcb2lPCPft28fHLI9PYXMzcouTJX1
   4gxg6anluJmMp9hL9ps++eBdRT/g607pBd/N8KqxZkmMIWBCRpo/qrOLF
   evezk2T0mXCHtNcepUaCzingnAmm0Tb7mkCKGT3Cczmr0soiVy8jssxNu
   A==;
X-CSE-ConnectionGUID: mO+Di3ylR9GHxVXigiOkQg==
X-CSE-MsgGUID: cqA3FlyBQvei2DhZfxX4Pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="43646340"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="43646340"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 17:26:03 -0800
X-CSE-ConnectionGUID: JV5O2ojaS46SsCVZ1qR9Gg==
X-CSE-MsgGUID: UxullYvjS+WWPhyO3fO0hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="96038728"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.124]) ([10.124.241.124])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 17:26:00 -0800
Message-ID: <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
Date: Mon, 25 Nov 2024 09:25:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
To: seanjc@google.com, Adrian Hunter <adrian.hunter@intel.com>,
 pbonzini@redhat.com
Cc: dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com, dmatlack@google.com,
 isaku.yamahata@intel.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20241121201448.36170-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241121201448.36170-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/22/2024 4:14 AM, Adrian Hunter wrote:
[...]
>    - tdx_vcpu_enter_exit() calls guest_state_enter_irqoff()
>      and guest_state_exit_irqoff() which comments say should be
>      called from non-instrumentable code but noinst was removed
>      at Sean's suggestion:
>    	https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com/
>      noinstr is also needed to retain NMI-blocking by avoiding
>      instrumented code that leads to an IRET which unblocks NMIs.
>      A later patch set will deal with NMI VM-exits.
>
In https://lore.kernel.org/all/Zg8tJspL9uBmMZFO@google.com, Sean mentioned:
"The reason the VM-Enter flows for VMX and SVM need to be noinstr is they do things
like load the guest's CR2, and handle NMI VM-Exits with NMIs blocks.  None of
that applies to TDX.  Either that, or there are some massive bugs lurking due to
missing code."

I don't understand why handle NMI VM-Exits with NMIs blocks doesn't apply to
TDX.  IIUIC, similar to VMX, TDX also needs to handle the NMI VM-exit in the
noinstr section to avoid the unblock of NMIs due to instrumentation-induced
fault.


