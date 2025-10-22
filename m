Return-Path: <kvm+bounces-60790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96015BF99ED
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 03:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB509425106
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 01:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27371D5CEA;
	Wed, 22 Oct 2025 01:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4hhQ9S6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9AA1BD9F0;
	Wed, 22 Oct 2025 01:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761097027; cv=none; b=gP22j2emQDvT3qrpjcgXMRfK+lB52MQsKAtszfVr2EF4LTCh73pPaMZiKXwLbzhtuUC5mQo55jGfNiO1Jix0LRxNWbR+xxPKZXm7XOxxtGIiIDMp0MjMX8CSBd5Jn4LOsE+5QYX7YMgVq6KqShjlyrV6O7NYXR/FjTwMwvaXvk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761097027; c=relaxed/simple;
	bh=vNBfwJ+2ZuN/Mnr0NMibpXs+Xf3ioiUmi9XNr0D6YRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSKCaomeuFSynh6xbH0SoC0nwjEQSMueEne4PVRB/rgYzVgQuzWhKdC+IJDP+rSkYPTKAynLcYURCvVeoui7yN5EUbvvtezeJJt51v0dQlLq4wJt2BYE5au1fwSRIxrNcD9WDkSmDWStTetNDRaDldZB+h7przG1xTLxIjLJgus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4hhQ9S6; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761097025; x=1792633025;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vNBfwJ+2ZuN/Mnr0NMibpXs+Xf3ioiUmi9XNr0D6YRM=;
  b=O4hhQ9S6WYyUc5YCetTh3YnPQkMionfSyenfIv3wP/O+N3H3Vvl4USIt
   QhwlqV33srpJ2DJlaJkLWoDdTKclrYNR8L31pG+tnwWvNFYZ6zNgLXZKM
   VJ7Rl/ofjtDG3UgjkBklKQtmVH6V2wQagMQ8YC3hqHG5PTcDnhfBRGJtx
   7AZeXOr2MCSgV9quPDum1pr6r7VOQMmS59q2QtF7u2+438P5XgU7Bav/Y
   5YPkDAY8adG7TA5ShzaWMaDySo0oobjjUTlzW8BVvNqv7j4KPvCnJsPe3
   15Tu5TonWiHy5xZ5XvOSbFvefY1wcl1s3vSajaobFc8250jvayxgZ2JVs
   g==;
X-CSE-ConnectionGUID: j9diwNNFR8eFv0BHg+4aqw==
X-CSE-MsgGUID: XWwkgTXPQaeX1c2dQXzN/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80858676"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="80858676"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:37:04 -0700
X-CSE-ConnectionGUID: aC0P0ciFQ0Wff5xJzmEN2A==
X-CSE-MsgGUID: /cpwlJNqSnmt4a1x14Go6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="188015779"
Received: from bkammerd-mobl.amr.corp.intel.com (HELO desk) ([10.124.220.246])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 18:37:04 -0700
Date: Tue, 21 Oct 2025 18:36:57 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v3 3/4] KVM: VMX: Disable L1TF L1 data cache flush if
 CONFIG_CPU_MITIGATIONS=n
Message-ID: <20251022013657.n2he5yabfgunm5vb@desk>
References: <20251016200417.97003-1-seanjc@google.com>
 <20251016200417.97003-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016200417.97003-4-seanjc@google.com>

On Thu, Oct 16, 2025 at 01:04:16PM -0700, Sean Christopherson wrote:
> @@ -302,6 +303,16 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
>  	return 0;
>  }
>  
> +static int vmx_setup_l1d_flush(void)
> +{
> +	/*
> +	 * Hand the parameter mitigation value in which was stored in the pre
> +	 * module init parser. If no parameter was given, it will contain
> +	 * 'auto' which will be turned into the default 'cond' mitigation mode.
> +	 */
> +	return vmx_setup_l1d_flush(vmentry_l1d_flush_param);

A likely typo here, it should be:

	return __vmx_setup_l1d_flush(vmentry_l1d_flush_param);

