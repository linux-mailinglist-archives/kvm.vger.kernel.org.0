Return-Path: <kvm+bounces-2223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 817977F36BB
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 20:16:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1CE2820C1
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5CA5B1F0;
	Tue, 21 Nov 2023 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lp9ZT9B5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF638110;
	Tue, 21 Nov 2023 11:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700594159; x=1732130159;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XcNHGE3mfkWpwt/actN7amxrbPAaFnHfr5Q3LoIXsAA=;
  b=Lp9ZT9B5wsuaWAEVS2DxjZNZQO87aiEVl4+v5557Jn+8ZZG/UIe8u6xW
   rd13w1tnZnLnNd4UiALWiwORyui2HPiDf0LdWm9sPw9pYHTR47J3aTT15
   A2aBtllTZJ2STsMov/qGQ7muGgZNCKLJE9HEjlL4A2DmAtrs+//05j5G4
   hyCtlFePg+3oUVvsDTqDuE04RhscXYFxF3vPfVA7tNjPn4lHPZoA4QuXY
   UfOGXeSSg2R492J/JUyqv5k/Ql22Cig4x+/HbKdrrDbUHv/wK1VjoO2Mb
   DD+argnhn/Y7H3h6P4Hp8fWajUqfSRx4Q1IQLEE09gLq6vvWcTqTE1xSI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="395831982"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="395831982"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 11:15:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="910555576"
X-IronPort-AV: E=Sophos;i="6.04,216,1695711600"; 
   d="scan'208";a="910555576"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 11:15:58 -0800
Date: Tue, 21 Nov 2023 11:15:57 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v17 020/116] KVM: TDX: create/destroy VM structure
Message-ID: <20231121191557.GI1109547@ls.amr.corp.intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <997a92e4f667b497166ff8cc777ec8025b0f22bc.1699368322.git.isaku.yamahata@intel.com>
 <2a5a38d9-28e2-4718-b8fc-2b8f27610706@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2a5a38d9-28e2-4718-b8fc-2b8f27610706@linux.intel.com>

On Sun, Nov 19, 2023 at 02:30:19PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +static int tdx_reclaim_page(hpa_t pa)
> > +{
> > +	int r;
> > +
> > +	r = __tdx_reclaim_page(pa);
> > +	if (!r)
> > +		tdx_clear_page(pa);
> > +	return r;
> > +}
> > +
> > +static void tdx_reclaim_td_page(unsigned long td_page_pa)
> 
> This function is used to reclaim td control sturcture pages like TDCX,
> TDVPX,
> TDVPR. Should this function name be more specific?
> For me, it is a bit confusing.
> 
> Or maybe do "td page" have specific meaning referring to these control
> structures
> pages in TDX?

As they are control page, how about tdx_reclaim_control_page()?
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

