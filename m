Return-Path: <kvm+bounces-14676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAF48A58FA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 19:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96970B23BCB
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB1E84047;
	Mon, 15 Apr 2024 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fabYWyHr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A991B839E1;
	Mon, 15 Apr 2024 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713201430; cv=none; b=U0yxAO/gOFdNQY6nvTa7nX+fE/Gjpm+b39EqMFVYiqMMclG7G1eWd/Vq7Ohehyh3I/ymTcHfbeMa1SMuKhMuGX9Z+Awxbxwt/WdteEqvaOEf8sj+LGkUDSpqUPaiEC/nO5cnAQ0FT01J8mncv/HyK9a4GKa378YwQ4bH5SALCV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713201430; c=relaxed/simple;
	bh=l2PunGGcgnzIP5mDROsf63lAcZWDi3Fqv+iJYpuU8J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aLXI9MSU9INqwHDVWylTI2XYK24+/gGKISThcAC7PNJnX/f0B+UDlksMIXhHzLYKBcq1CR0omVPV+87unbB2zIG1rNE9Yi3osBEqrJcJqHb1rIil2PKRkjXG135vV2l3/CtfbqiNk7hCBERT65edjMQq5gzrAqC1Yte2ganK2f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fabYWyHr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713201429; x=1744737429;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l2PunGGcgnzIP5mDROsf63lAcZWDi3Fqv+iJYpuU8J8=;
  b=fabYWyHroQdcfGy8HPoqfCsUfqnjh81VXi8sQ+pf/6phcKGEyZGvCjL4
   XtrtLKnf2alWlrmLH2xDHJkaBrsZgaW204NktNVlUHqTrQxLEbCoiH5AX
   Ah1oJhj/b6vq5KnRn3bsopjte7EYlv9vUqGcOcvnwJX+61cZTg6RwA0Y1
   VshHpXUylkKRyxSBihVD58jgyz8tlxv6WhYtOdGiUGyzOgL06VYevKeFN
   hst1bUDKhCNWVeavzUn01VGD6kFeZiUWQvJmSXzX4OY8W6EFZ7a9ACEIo
   dKfa9kvE2b1ZF1hkW8bOUc5ZBQ6y6CoY4tYo17soITAwQ8htiYWFja23t
   A==;
X-CSE-ConnectionGUID: KD5uhEdYSiuX2uUPxBpI1w==
X-CSE-MsgGUID: KWM4MYXISfGW5wLmzn7kEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8770499"
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="8770499"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 10:17:08 -0700
X-CSE-ConnectionGUID: YABDTTwmQgq21T1a8c+3IQ==
X-CSE-MsgGUID: 6vx70lLtRpWQ8oQms+kgXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,203,1708416000"; 
   d="scan'208";a="52934293"
Received: from granthal-mobl2.amr.corp.intel.com (HELO [10.209.101.186]) ([10.209.101.186])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 10:17:06 -0700
Message-ID: <a8af757b-a40a-40dd-a543-99a39a0fe8ad@intel.com>
Date: Mon, 15 Apr 2024 10:17:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
 Chao Gao <chao.gao@intel.com>, Andrew Cooper <andrew.cooper3@citrix.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
 tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
 gregkh@linuxfoundation.org, seanjc@google.com, dave.hansen@linux.intel.com,
 nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
 pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
 <ZhfGHpAz7W7d/pSa@chao-email>
 <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
 <2af16cb4-32ed-4b91-872b-f0cc9ed92e59@oracle.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <2af16cb4-32ed-4b91-872b-f0cc9ed92e59@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> +       /*
> +        * The following Intel CPUs are affected by BHI, but they don't have
> +        * the eIBRS feature. In that case, the default Spectre v2 mitigations
> +        * are enough to also mitigate BHI. We mark these CPUs with NO_BHI so
> +        * that X86_BUG_BHI doesn't get set and no extra BHI mitigation is
> +        * enabled.
> +        *
> +        * This avoids guest VMs from enabling extra BHI mitigation when this
> +        * is not needed. For guest, X86_BUG_BHI is never set for CPUs which
> +        * don't have the eIBRS feature. But this doesn't happen in guest VMs
> +        * as the virtualization can hide the eIBRS feature.
> +        */
> +       VULNWL_INTEL(IVYBRIDGE_X,               NO_BHI),
> +       VULNWL_INTEL(HASWELL_X,                 NO_BHI),
> +       VULNWL_INTEL(BROADWELL_X,               NO_BHI),
> +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
> +       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),

Isn't this at odds with the existing comment?

        /* When virtualized, eIBRS could be hidden, assume vulnerable */

Because it seems now that we've got two relatively conflicting pieces of
vulnerability information when running under a hypervisor.

