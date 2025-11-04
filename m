Return-Path: <kvm+bounces-61938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4425DC2F0CA
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 04:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F8F188ECA1
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 03:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D31D26B2D2;
	Tue,  4 Nov 2025 03:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ne+bSW8m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD387262D;
	Tue,  4 Nov 2025 03:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762225413; cv=none; b=l+v/alM/n/frwnFIFwBNVgwq7hcgtM5AqvwcHtMDM69PrHQsQscz41vl1IRrIYnEK8VjIsNPhvURa7BY1FAEUoOvFxuOLAq1j/mH8wn3X+vY/CFgyyhM1Ug3bs5dS5pvrFGzzOVAHTPqFFr1i9Lq1DBFc27/8bo33blelNO4r+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762225413; c=relaxed/simple;
	bh=WGw4lGJj9huttZ/mJwmJZYcOekuBZSxll0pcVFaWMwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvcZlG/MaaC4L43hhZ1RMJcJjJYvrkLJsahCIRGcpa7sMAZ3ui0Mv1M601OvKuQjO50mFjrP84GjbFB8g/PQRkCI8LbAqj3HqL3sWovONQ+jis8C9C2NbNASsKyF8yy9KFjmT2n06p+2HdCKipvIR0lJWILLa6i2+mEln548YWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ne+bSW8m; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762225411; x=1793761411;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WGw4lGJj9huttZ/mJwmJZYcOekuBZSxll0pcVFaWMwA=;
  b=ne+bSW8mVcby4xPGPlVA0au3PDsEGVVHvhTJ2bd0X1isnUMt//TAiTph
   X6tubDTXtq8EXKOKKMftSaopFJu56UmCC4OITaxqNEHLSW9YXaGaneJnl
   u34oCOL+t5w//7wpD3BIINa21ibcCe+gyWB4H6GjKtduVr0AJD44N6R8c
   Nhl39BTihvvFU4As+Nz9QyiRw4W3iik+w36/tvQm6JYGCU/RzOgSSNV+X
   ODaUA0ZIoj1wFo9ArnJGKjXxz7U1IS8/mZs3G/BshbbP0JC0d3gUJrXBk
   vABvH5pMHyzsLwLlX/oc3sGigZ8IUcwZJVLZ9sihgynAo9tSSmRoO1isr
   Q==;
X-CSE-ConnectionGUID: i8iFHqNCSiGb0ennV0FlmA==
X-CSE-MsgGUID: 3A24ChJfTQa49ZKoXFevDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="81718503"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="81718503"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 19:03:31 -0800
X-CSE-ConnectionGUID: FLfftsxNTY6nI+xyiXi2xg==
X-CSE-MsgGUID: h/xj5pRDQ2y1fFMtDEdqZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="210545521"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 19:03:28 -0800
Message-ID: <063b0ccb-42bb-4120-89f4-48b8c2191eb7@linux.intel.com>
Date: Tue, 4 Nov 2025 11:03:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251030185004.3372256-1-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/31/2025 2:50 AM, Sean Christopherson wrote:
> Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> KVM doesn't know how to handle.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


