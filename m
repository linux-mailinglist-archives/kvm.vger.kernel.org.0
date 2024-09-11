Return-Path: <kvm+bounces-26456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 090349749FE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 07:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4AD21F25850
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 05:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7DD4F881;
	Wed, 11 Sep 2024 05:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="if820MxU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9692B558B7;
	Wed, 11 Sep 2024 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726034305; cv=none; b=Ak2dg9isZK7Tz+amqOR3xAxwCqGaxta+W5ADY3zF0MLaf/2H/BqMLN1S/Z8WsKsX1mzurfiTNrrsYXWh1KePcSG4w/s6MkitIQkY4JUidxQgpdposCJWB6ntBKMNVL+BnoQrDsb7Vr87b/9Z2b8alkefKlj7TrIUno09qwOtWnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726034305; c=relaxed/simple;
	bh=IsXKRKlRRuoUhynSJbyMXcCxSD7PLob00R0+URxVCkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYqUK1SKSMwzBVJGrjnzD5J+02xjb01km7z1AaBv+ThIRIxnqk8VNRdICe34RUubVWZwOGUkdss/RzoUbFZVT9DPHAqoCoEM5WT2biCkJmrr0VNYD091hv8wkzOXB+AgwoVli8HdC5N2ZCObgYdPHDXc6V0VVhcmxDCo/3GkSBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=if820MxU; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726034304; x=1757570304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IsXKRKlRRuoUhynSJbyMXcCxSD7PLob00R0+URxVCkE=;
  b=if820MxUjGFB40henhOjXKcPwtPKMcdD6LF4+Ztm/+4pOiLCo0ohjYxn
   5PsgT/GfhKHA6UdU+14NsI4XiRFprY8U2gZB3oarOCHbDpAVlYLJ31xOv
   Fn2++5gIIjgDo6kvl0EGImQWie1yOgAubuXYQnRHqNzWuPvWMu4mIaEsg
   ZhFYtjzenORZBw2phm9UdNYz20ptVwqbN5C6VrIJhG/ZahZTZke3+IozY
   2gEpIIuT1kKbbgqb5+SkR83P+zCye54gnlJwPcr6HQWWitOV5bFPylUqq
   exYrXau44jIijEpijj+60K0hyIdXznr0zS+U6a5hJiz5XN7KD1ZsFdL8x
   g==;
X-CSE-ConnectionGUID: Z/DBDX+QSNuvxyGzttG6Sw==
X-CSE-MsgGUID: Ane3ksJbSvyepfIIdGWabA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="24752594"
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="24752594"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 22:58:23 -0700
X-CSE-ConnectionGUID: ueKq3hlCTgq+TdyP0xyCSg==
X-CSE-MsgGUID: shOFvoKuRkOPI++3EIgGJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,219,1719903600"; 
   d="scan'208";a="104729422"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.117])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 22:58:19 -0700
Date: Wed, 11 Sep 2024 08:58:14 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	kvm@vger.kernel.org, kai.huang@intel.com, isaku.yamahata@gmail.com,
	xiaoyao.li@intel.com, linux-kernel@vger.kernel.org,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 03/25] KVM: TDX: Add TDX "architectural" error codes
Message-ID: <ZuExdkguCRNcX14o@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-4-rick.p.edgecombe@intel.com>
 <45cecaa1-d118-4465-98ae-8f63eb166c84@linux.intel.com>
 <ZtAGCSslkH3XhM7a@tlindgre-MOBL1>
 <ZtFeO3hq6dpnXvmf@tlindgre-MOBL1>
 <80a3a5a1-59cb-4ca9-8107-b7552fa35b6b@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80a3a5a1-59cb-4ca9-8107-b7552fa35b6b@redhat.com>

On Tue, Sep 10, 2024 at 06:22:52PM +0200, Paolo Bonzini wrote:
> On 8/30/24 07:52, Tony Lindgren wrote:
> > > > +#define TDVMCALL_STATUS_SUCCESS 0x0000000000000000ULL
> > > > -#define TDVMCALL_STATUS_RETRY                  1
> > > > +#define TDVMCALL_STATUS_RETRY 0x0000000000000001ULL
> > > > +#define TDVMCALL_STATUS_INVALID_OPERAND 0x8000000000000000ULL
> > > Makes sense as they are the hardware status codes.
> > I'll do a patch against the CoCo queue for the TDVMCALL_STATUS prefix FYI.
> 
> Just squash it in the next version of this series.

Sure no problem.

Regards,

Tony

