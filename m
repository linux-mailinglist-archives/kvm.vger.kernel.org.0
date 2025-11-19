Return-Path: <kvm+bounces-63683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0DAC6D16B
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 141C72D25E
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E5E320CCE;
	Wed, 19 Nov 2025 07:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ctWxSVkK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B57A2DBF78
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 07:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763537111; cv=none; b=LIp2Q7JCF1bHpibzn4Og6Ss2ZNrKe2StA1fRrGqbS0EJf2Q04dZudNiq9whf2YDiSTYojliQOGT05uJz0WGMhUhKh/n/ML/AxUM8x/tsBU8n/SKKfCazws0OmFFE3Kv5kixWWjz6U5vkDdhGm2aFHF3e9IATSWZ4OP4nZueK/JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763537111; c=relaxed/simple;
	bh=4PhZgJ5p/fAYFjT9EQDC/elazvzshQlub5vAtKA0oHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qejd31LlsHhOdPJgFklydfjYyVvW0/98yfUqVLm7Q7B7A6xuaDDuq1X73AEvquxoB2Xe9tSK2kbDC5lb3aNqGgqFMTZcQvx08T6Qf8DGXYGJEFIpJOQmZqMS1k3gXLwCopQt1nZUkZpe6OKDhXv39mJ33rR+NGDf+Dks9rDjXzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ctWxSVkK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763537109; x=1795073109;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4PhZgJ5p/fAYFjT9EQDC/elazvzshQlub5vAtKA0oHE=;
  b=ctWxSVkKHk6NPGz8zjx1Nvz3oBHwuwU4P0tjnwtCvg8fBCdeCsS8EiFJ
   eM7iLDXWEGBV0LpXcCHBcuPkQkzpWsrxA8kb/hKEpPR1sg8Z1yxgyWtpA
   6SPg3cbkRUJKrlT8TRirrDuEJR8d34/8CI/VLGQPkUPxOvSF0R1Z/2+6W
   Nzj8doRQ41PRjU5mY9lQqiKhIG+5S63CNPkicUDl6LUjYodqdbuuPaiJf
   MTK+8X4usyse4AmM+Ebv53vshU8tXDoum9Vh+Nuw4Cbm/JQ48Fgq/TQ+q
   3m6+DpmpzJZHoSHmv2OTWQmBKQp8ouv5iNdS+EnH9TYX2s5q0WBqj3Le2
   w==;
X-CSE-ConnectionGUID: rgmmnGjsQ9aoIhEp5LOaxg==
X-CSE-MsgGUID: 35m3reVlS3GY5gIlqphMAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="68176977"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="68176977"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 23:25:07 -0800
X-CSE-ConnectionGUID: yIu5F3gmSReum3H1F8gkyg==
X-CSE-MsgGUID: maoJ8l6pSFaSX8uXbi69MQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="191116663"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa008.jf.intel.com with ESMTP; 18 Nov 2025 23:25:06 -0800
Date: Wed, 19 Nov 2025 15:47:25 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	"Chang S . Bae" <chang.seok.bae@intel.com>,
	Zide Chen <zide.chen@intel.com>, Xudong Hao <xudong.hao@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH 2/5] i386/cpu: Cache EGPRs in CPUX86State
Message-ID: <aR12DVNhNuViq7sG@intel.com>
References: <20251118065817.835017-1-zhao1.liu@intel.com>
 <20251118065817.835017-3-zhao1.liu@intel.com>
 <CABgObfbzzwCafmGehgzCC-pFSnRR1OW_wfQxR4OJDAbv4mCztQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbzzwCafmGehgzCC-pFSnRR1OW_wfQxR4OJDAbv4mCztQ@mail.gmail.com>

On Tue, Nov 18, 2025 at 09:43:26AM +0100, Paolo Bonzini wrote:
> Date: Tue, 18 Nov 2025 09:43:26 +0100
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: Re: [PATCH 2/5] i386/cpu: Cache EGPRs in CPUX86State
> 
> On Tue, Nov 18, 2025 at 7:43 AM Zhao Liu <zhao1.liu@intel.com> wrote:
> >
> > From: Zide Chen <zide.chen@intel.com>
> >
> > Cache EGPR[16] in CPUX86State to store APX's EGPR value.
> 
> Please change regs[] to have 32 elements instead; see the attached
> patch for a minimal starting point. You can use VMSTATE_SUB_ARRAY to
> split their migration data in two parts. You'll have to create a
> VMSTATE_UINTTL_SUB_ARRAY similar to VMSTATE_UINT64_SUB_ARRAY.

Thanks! VMSTATE_UINTTL_SUB_ARRAY is for target_ulong. I'll move EGPRs
to regs[].

> To support HMP you need to adjust target/i386/monitor.c and
> target/i386/cpu-dump.c. Please make x86_cpu_dump_state print R16...R31
> only if APX is enabled in CPUID.
> 
> Also, it would be best for the series to include gdb support. APX is
> supported by gdb as a "coprocessor", the easiest way to do it is to
> copy what riscv_cpu_register_gdb_regs_for_features() does for the FPU,
> and copy https://github.com/intel/gdb/blob/master/gdb/features/i386/64bit-apx.xml
> into QEMU's gdb-xml/ directory.

Good! Thank you for your guidance. I will add GDB support in next
version.

Regards,
Zhao


