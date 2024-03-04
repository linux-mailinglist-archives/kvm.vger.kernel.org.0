Return-Path: <kvm+bounces-10776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0AC86FC9E
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 10:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DEBBB22F8C
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 09:02:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59021B7F1;
	Mon,  4 Mar 2024 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="avBUcNoz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302A199C7;
	Mon,  4 Mar 2024 09:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709542949; cv=none; b=Lk88SQAEIz3J4Yjzh0wo/442oyQbObknRrW4s2PfX0Pwy9rPBKIMHfmAQIHHPdYHKcTjgDBL1zjL43hiQnTyqoHEf3vzjNSx0lhqKEzVtWnFieL6fFuWoxsUg+5FD56DLj3CKmxh1Z/BKKJtBP5tqk/Y2I3D6bTh1JT0wDJm3HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709542949; c=relaxed/simple;
	bh=02GHhgzzwCODHSLjtoC02aB2+aErcjAhYrJviGy6hi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLdYv5TEYEa2nmcP+6TzQCpjiylCIYZ/X5ONZIASRVBB2/yZpJ0D3Auwbxzoc7gNbQyAx/AwxuS/kRTWCvbqYpH2gh5VSI//JW3Xc97biUsvR6mkQulWBS/0UrBf3ZBEViQB7SZKmuviQa4bwjVF0RGUHN2T+KRMmZrukx3F/W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=avBUcNoz; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709542948; x=1741078948;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=02GHhgzzwCODHSLjtoC02aB2+aErcjAhYrJviGy6hi4=;
  b=avBUcNozTsVwTioIPnDJC8KCTwMgelcRhZ9h0GqT/etEi1BaiqKcYoGL
   TF2B++EEIhaJPV8rdL0/qX/VLxm+yNxLpbOH3AiMlIEpbUAmBholuwU5b
   i5K+FtVFmA7Lt9plzpVHVuW/eMJiV+4qQkezsOVXR0ZAEmAoej0KBA+jP
   HHbCyHMmOjKdt8zwE4mgyFv4ATF+oT979uXJ9XWWEWEAtqnzPVvUCgpua
   Hb7C0AWMWJlqErMSB5fwDPLwVNJpvDwUP70iUK7lFQzGT4Xran2Cr3mhQ
   725ibdZu4G/0u1ZQYwtlWD6B90y7bSVS8cC2MWUf/WUUTGdP/v4/42cP0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11002"; a="3887588"
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="3887588"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 01:02:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,203,1705392000"; 
   d="scan'208";a="8813391"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 01:02:24 -0800
Date: Mon, 4 Mar 2024 16:59:32 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kvm: wire up KVM_CAP_VM_GPA_BITS for x86
Message-ID: <ZeWNdBSWVTAwtLyI@linux.bj.intel.com>
References: <20240301101410.356007-1-kraxel@redhat.com>
 <20240301101410.356007-2-kraxel@redhat.com>
 <ZeH+pPO7hhgDNujs@linux.bj.intel.com>
 <vlr6f5dnyhb6aw5si6m4vxqemwoyg7lrti7pdy4jzatady5mgr@bv44qwgk6ppu>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vlr6f5dnyhb6aw5si6m4vxqemwoyg7lrti7pdy4jzatady5mgr@bv44qwgk6ppu>

On Mon, Mar 04, 2024 at 09:43:53AM +0100, Gerd Hoffmann wrote:
> > > +	kvm_caps.guest_phys_bits = boot_cpu_data.x86_phys_bits;
> > 
> > When KeyID_bits is non-zero, MAXPHYADDR != boot_cpu_data.x86_phys_bits
> > here, you can check in detect_tme().
> 
> from detect_tme():
> 
>         /*
>          * KeyID bits effectively lower the number of physical address
>          * bits.  Update cpuinfo_x86::x86_phys_bits accordingly.
>          */
>         c->x86_phys_bits -= keyid_bits;
> 
> This looks like x86_phys_bits gets adjusted if needed.

If TDP is enabled and supports 5-level, we want kvm_caps.guest_phys_bits=52,
but c->x86_phys_bits!=52 here. Maybe we need to set kvm_caps.guest_phys_bits
according to whether TDP is enabled or not, like leaf 0x80000008 in
__do_cpuid_func().

Thanks,
Tao

