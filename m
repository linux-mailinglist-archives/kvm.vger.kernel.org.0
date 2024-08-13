Return-Path: <kvm+bounces-24016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F4519508AC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 17:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 708BD1C22737
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 15:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C0D1A01AB;
	Tue, 13 Aug 2024 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AzcKh0Fc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4CA3B192;
	Tue, 13 Aug 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723562079; cv=none; b=XeIz7TQLXulHl96+B575C7o2cxpAonUHvTnhtu9yMc2qOw9SDUV8ILGRLzyYqNzMIYc7/KV8smmDtLB7BrA6XMLz/d8EQXhKqo9ND7riMJ8yu69of4rq5jJ4EfnXkradkUn/g6dGZQC4W2jsorooY3BgF31mebSnFxn66v/4U6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723562079; c=relaxed/simple;
	bh=WBQDgpze3nOImWdFR2VP7QJc+vFPXo94UaLalSef/cQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jDzN2gl6uhgrbqNqmPot6VqNEpc2UuHnjjKIZO69j7dwNLgZqbKmVMfUZNus7mM8LfJd+hb18y0y5mz0ASQP6Gc78+mdw2Cd4fNacleRR77aUBm6NhcAiZFwRqJoj+e9yCGuckZ3PEQd5q1YcPgexXjIRsrp1/azYxAGDq8dHko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AzcKh0Fc; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723562078; x=1755098078;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WBQDgpze3nOImWdFR2VP7QJc+vFPXo94UaLalSef/cQ=;
  b=AzcKh0FcNwx9B5LdWTqCTJ5dWGLhIs5WAbSSadPLrsajs2PM2lVkcPDt
   AvLxYyZaTJNOiYRnNhaN7uEbtFto4EpiqV/WLWioBmaaaxt66OcT6L9vL
   wFZ2HlFbxYTuPXpkoXDRxEHiVXksKVMwzCNsJksMOOmxmy3HF6OBjUfm7
   fk2J0Ox/nkdPAfue/C3JaTAf8NEteoXpnQ5CXy3CltzorJ68G0dC4h6pb
   lqhWehU7NF/cfY8KhYpTxrcF5xpU2wP7l667tpNrrmm4eh80MvOxWiTjK
   BCi7yi1PNdJU+jez+7Vm24mAyxdxrEAiy9oLKtXplXhbAonbk+d9PgU6M
   A==;
X-CSE-ConnectionGUID: JlPQHC8EQX6vhkiNtAPZgA==
X-CSE-MsgGUID: kl+8lUJOTdOnqw7fYPe9yQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="33136463"
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="33136463"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 08:14:37 -0700
X-CSE-ConnectionGUID: 4QLPTbJrTc2D49Rf/SSRHQ==
X-CSE-MsgGUID: lWGoRVsIRkqcp+mRKGnprQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,286,1716274800"; 
   d="scan'208";a="81925585"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.228.22]) ([10.124.228.22])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2024 08:14:34 -0700
Message-ID: <efc22d22-9cb6-41f7-a703-e96cbaf0aca7@intel.com>
Date: Tue, 13 Aug 2024 23:14:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
To: Chao Gao <chao.gao@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, linux-kernel@vger.kernel.org
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
 <ZrtEvEh4UJ6ZbPq5@chao-email>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZrtEvEh4UJ6ZbPq5@chao-email>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/2024 7:34 PM, Chao Gao wrote:
> I think adding new fixed-1 bits is fine as long as they don't break KVM, i.e.,
> KVM shouldn't need to take any action for the new fixed-1 bits, like
> saving/restoring more host CPU states across TD-enter/exit or emulating
> CPUID/MSR accesses from guests

I disagree. Adding new fixed-1 bits in a newer TDX module can lead to a 
different TD with same cpu model.

People may argue that for the new features that have no vmcs control bit 
(usually the new instruction) face the similar issue. Booting a VM with 
same cpu model on a new platform with such new feature leads to the VM 
actually can use the new feature.

However, for the perspective of CPUID, VMM at least can make sure it 
unchanged, though guest can access the feature even when guest CPUID 
tells no such feature. This is virtualization hole. no one like it.

