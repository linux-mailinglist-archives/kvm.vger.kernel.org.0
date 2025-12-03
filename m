Return-Path: <kvm+bounces-65221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 723C0C9F8ED
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 16:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DFD603000957
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 15:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7731F30F7E4;
	Wed,  3 Dec 2025 15:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DLgXa87b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75E5303A3D;
	Wed,  3 Dec 2025 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776476; cv=none; b=aDyTojO7r08vYMT7spEATKa2EZy/F06AodDR6cAAiA6Tw8xhYyNt+ZfTK/5+rxZW38WjJsd/8R1QKTZ8Oa/GKq/M3vLAlGtoxQpTsAs5bGkIHJcUBl4Mda48Z/2juZ5ANurxccknnVLz29nLXTz28fduCSQ08qwcsZzhWcNbHA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776476; c=relaxed/simple;
	bh=4AbhQVU/HNqTPQxRtJIYaYcanF2goOzHgnXrU/BqQK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DETlkWK+Yfs3blTbVQ73QP+a6UO02yAwbxHv4Be7YWWY4bvFf7pKXHLzUx0vrc0AIjR6hsCsrlNoU8O08yldQQpKuraUlkc3oE3sAFJVjij+ZZepN0HZlNjoiEaob91UsLayQ4HaOSfbATzeHBENA4aUjLSQL+9nIKEgndzl/NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DLgXa87b; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764776475; x=1796312475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4AbhQVU/HNqTPQxRtJIYaYcanF2goOzHgnXrU/BqQK4=;
  b=DLgXa87bwN9yWxz8xhJ/nyIlbPX3L9S/6lamMyKiCDrfivF9o9mkIzYl
   BMHWfsOqDoOGK/P2Sx4feSD14KDalXgra4ssCAFWWqQ7clN3Bjr0LsXnf
   OCqOFPTRp08QJJTzao54ArNGNoF3chTF6z+otMuVpCp9llipcgh5Ppduv
   EFi2Q1NE/HEMrKOo7eQuFytJfI7XhZmMEFqSYNiw3iBwb65VyJjViCx71
   RZlis0rPMWymqYqCRnnIjhpom1KAkDlA065K9+pyW5+zMwjJ/ue8BHz5n
   WtI++62JC/veC0xU/o+3/eTywd/ISfLYvBzIgljxL1zGYQb3wUuOB4qUg
   w==;
X-CSE-ConnectionGUID: hrwJUW3vQx2Xd7/C7L0iQQ==
X-CSE-MsgGUID: CoKFMq4AS7WTv/3Ac4jzng==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="78239663"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="78239663"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 07:41:13 -0800
X-CSE-ConnectionGUID: 5zF7Ut8wRIalPCPtsyZOmA==
X-CSE-MsgGUID: enW6+D+KSfuk5fopTeSGqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="199139117"
Received: from tslove-mobl4.amr.corp.intel.com (HELO [10.125.108.18]) ([10.125.108.18])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 07:41:12 -0800
Message-ID: <04c51f1d-b79b-4ff8-b141-5888407a318e@intel.com>
Date: Wed, 3 Dec 2025 07:41:11 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
To: Nikolay Borisov <nik.borisov@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
 <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "x86@kernel.org" <x86@kernel.org>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
 <dde56556-7611-4adf-9015-5bdf1a016786@suse.com>
 <730de4be289ed7e3550d40170ea7d67e5d37458f.camel@intel.com>
 <f080efe3-6bf4-4631-9018-2dbf546c25fb@suse.com>
 <0274cee22d90cbfd2b26c52b864cde6dba04fc60.camel@intel.com>
 <7xbqq2uplwkc36q6jyorxe6u3fboka3snwar6parado5ysz25o@qrstyzh3okgh>
 <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <89d5876f-625b-43a6-bcad-d8caa4cbda2b@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/3/25 05:48, Nikolay Borisov wrote:
>> There was a plan to future prove DPAMT by allowing PAMT descriptor to
>> grow in the future. The concrete approach was not settled last time I
>> checked. This code was my attempt to accommodate it. I don't know if it
>> fits the current plan.
> 
> Considering this, I'd opt for the simplest possible approach that works
> _now_. If in the future there are changes to the ABI let's introduce
> them incrementally when their time comes.

It's fixed at a "page pair" in the ABI documentation, no?

If Intel wants anything else, it should have documented that as the ABI.
So, as far as the code goes, it's a "page pair" now and forever. Linux
does not need to go out of its way to make it inflexible, but there's no
need to add complexity now for some future that may never come.

I agree with Nikolay: KISS.

