Return-Path: <kvm+bounces-30438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EC089BAC47
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 07:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 264C21F217A2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C6718C90E;
	Mon,  4 Nov 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MgVArSxw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1521791EB;
	Mon,  4 Nov 2024 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730700003; cv=none; b=TFHgjEf9fm5U1T97Y2PSEr/r336hgMccGyC9P+w80IoCpfbk6r66dm6s0j2G7Q/z0uzzTed2T11oQWfX4CZVm5vO4ymSNucEZKTWZjYIb9bnmXhUdDTWDQziHz/636bkSzCeZsYhHpnrjWOGRkFWkcICZ8eA7LLJEFt4fRCVlpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730700003; c=relaxed/simple;
	bh=GnOR+QIlvIUOGyN4B3bwPEAZxoCH8LR8YQQ6JHrlIsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F010xW8UHerPT8RmMZoVjwqcN0mmF2+oSSWUFpiAWkeeFUqNvOlqv6JImkqMSRht2GGchJDHiXqEsIDrlT5b+TzTT+K+lkM80Cl6F9zP4RkOGPKtGdwYi3OefmP+muzwWQBdyCB2pl3cvSo6DUTP8yI91XiCtDjr3UMobSs9f1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MgVArSxw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730700002; x=1762236002;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GnOR+QIlvIUOGyN4B3bwPEAZxoCH8LR8YQQ6JHrlIsk=;
  b=MgVArSxwDzIx2vYSN3Y6LWg+hHOHdS389KIDCoPDeHd//JH7daszXGdn
   Xjo+FjfMK/2UcE+kPq0/td+FOzF//n/ec9l9lAfFBgY6mczIr+hS4YU0T
   8KbUbgIE4ZquxdfOchl9GI2NtGl/WnOi2AEORhNYtl2rHhT1xYYkpU1lv
   Y8j0oQs50lU3FIJeTUVPcYHUtLeWtp6wA7fOt8OzVa0ka8BE8uJhXehwB
   dxjBVGUuo3V7C47AuB2z/vYmxTh1HD9WDFJ22N2vo8eYCgI8jduq+/rQB
   x1jyhwaNB9FUOcwkD3pabRIvpNXbise29S95ZSIjtFEFOCAqJwTlom25E
   w==;
X-CSE-ConnectionGUID: c6RAx8/HQJiHhQfcgKuM9g==
X-CSE-MsgGUID: G86FLe05RO6i8F5hf7hCTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="41773870"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="41773870"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 22:00:01 -0800
X-CSE-ConnectionGUID: zPx4GTzCTJKwRB2+ps4bog==
X-CSE-MsgGUID: YxicuX4ZQAuh2BhYLe4bdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83657335"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.13])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 21:59:56 -0800
Date: Mon, 4 Nov 2024 07:59:51 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, yan.y.zhao@intel.com, isaku.yamahata@gmail.com,
	kai.huang@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 17/25] KVM: TDX: create/destroy VM structure
Message-ID: <Zyhi1xzJpaA6yEnB@tlindgre-MOBL1>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-18-rick.p.edgecombe@intel.com>
 <ZygrjxCKM4y3+Z4M@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZygrjxCKM4y3+Z4M@intel.com>

On Mon, Nov 04, 2024 at 10:03:59AM +0800, Chao Gao wrote:
> >+static int __tdx_td_init(struct kvm *kvm)
> >+{
> >+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >+	cpumask_var_t packages;
> >+	unsigned long *tdcs_pa = NULL;
> >+	unsigned long tdr_pa = 0;
> >+	unsigned long va;
> >+	int ret, i;
> >+	u64 err;
> >+
> >+	ret = tdx_guest_keyid_alloc();
> >+	if (ret < 0)
> >+		return ret;
> >+	kvm_tdx->hkid = ret;
> >+
> >+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> >+	if (!va)
> >+		goto free_hkid;
> 
> @ret should be set to -ENOMEM before goto. otherwise, the error code would be
> the guest HKID.

Good catch.

> >+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL)) {
> >+		ret = -ENOMEM;
> 
> maybe just hoist this line before allocating tdr.

Yeah it should be initialized earlier.

Tony

