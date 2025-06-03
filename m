Return-Path: <kvm+bounces-48257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EBEAACBFC0
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D20A1890AFD
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 05:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8601F9F7C;
	Tue,  3 Jun 2025 05:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DnU92xcq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340B3137C52;
	Tue,  3 Jun 2025 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748929847; cv=none; b=laPn3ynwJxAKMLmDjDJAuRekUpAq/g9x9CECHbb3TxgTi51vHdVM9U6+tyUy3f4mJqK2hEk/WTB2+NcL3F4E0AWcM1La42HtWccgG+sTHwessUIeD8PZgoODnwL0g2JG76kKOMmOh5CdB908qvDqEbiOOF6Wi/Dl9dZjAxOVgGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748929847; c=relaxed/simple;
	bh=9Mf0QNUymzZG5jrtVYhs1cOl5GQlP0WgmJqukvnLxsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kk33O4yAJlvMXbcCcYqS6zWucl4SNg7GaWTsCbCJ5jlzosYsaCWTJWYVzppccebz9WZbveWacdHjTPRdww7ksAZscU0Hyhv2iDweBbI5mWO95fjkB2JQAA2biNUYazDFg31LTxiziEOuXDKsExxvwikyld0FTZYWh+GKGQfxemc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DnU92xcq; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748929846; x=1780465846;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9Mf0QNUymzZG5jrtVYhs1cOl5GQlP0WgmJqukvnLxsI=;
  b=DnU92xcqaxFhmJRhriCoplBKUrtbZz7sCQwNwyomubITsB0Bo+WRSABH
   ZWRatB5uDlNno/7L7Yts3aM+tpSpm16ndKMigK7xcqtyZpguIymPpysep
   eP8S6nHb7kC8WLZGansrez3F56KaOkZ40GJpCcqCdcKSVAhUF4YRXT7Hx
   1PoY3/8dz4a2hn92psbCi/aKD39m+zX0zfl74QX6PhPsmQdkrMEUr7e0B
   Hmdy9hbMpZ+jvwy/0X5HmUB2Bt1Fff24zPqGAWnTHudE1GC4ft5CsXfvl
   zH6DNOh9Ap4WwT1ZzC2DnAIoVBOhccrp30B2AWNoLrfqnZJWd4A7gmVUU
   Q==;
X-CSE-ConnectionGUID: UN+N3QMyQQGTjvQWXfc+CA==
X-CSE-MsgGUID: N9SKw47+R9SOG6ueXcuKPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="62310188"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="62310188"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 22:47:11 -0700
X-CSE-ConnectionGUID: G9hnGvk6TeGnEz4ienUFNw==
X-CSE-MsgGUID: Z+7sL2tPRt2gjksowo4+cw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="149906053"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.144]) ([10.124.245.144])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 22:47:08 -0700
Message-ID: <83d8cd7d-0e7a-4d01-bff9-4c05815474ae@linux.intel.com>
Date: Tue, 3 Jun 2025 13:47:06 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 28/28] KVM: selftests: Verify KVM disable interception
 (for userspace) on filter change
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-29-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250529234013.3826933-29-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 5/30/2025 7:40 AM, Sean Christopherson wrote:
> Re-read MSR_{FS,GS}_BASE after restoring the "allow everything" userspace
> MSR filter to verify that KVM stops forwarding exits to userspace.  This
> can also be used in conjunction with manual verification (e.g. printk) to
> ensure KVM is correctly updating the MSR bitmaps consumed by hardware.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
> index 32b2794b78fe..8463a9956410 100644
> --- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
> +++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
> @@ -343,6 +343,12 @@ static void guest_code_permission_bitmap(void)
>  	data = test_rdmsr(MSR_GS_BASE);
>  	GUEST_ASSERT(data == MSR_GS_BASE);
>  
> +	/* Access the MSRs again to ensure KVM has disabled interception.*/
> +	data = test_rdmsr(MSR_FS_BASE);
> +	GUEST_ASSERT(data != MSR_FS_BASE);
> +	data = test_rdmsr(MSR_GS_BASE);
> +	GUEST_ASSERT(data != MSR_GS_BASE);
> +
>  	GUEST_DONE();
>  }
>  
> @@ -682,6 +688,8 @@ KVM_ONE_VCPU_TEST(user_msr, msr_permission_bitmap, guest_code_permission_bitmap)
>  		    "Expected ucall state to be UCALL_SYNC.");
>  	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
>  	run_guest_then_process_rdmsr(vcpu, MSR_GS_BASE);
> +
> +	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
>  	run_guest_then_process_ucall_done(vcpu);
>  }
>  

Test passes on Intel platform (Sapphire Rapids).

Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



