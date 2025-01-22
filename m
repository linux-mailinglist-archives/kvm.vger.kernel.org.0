Return-Path: <kvm+bounces-36247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DEEA19337
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:00:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 290551887C8E
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 14:01:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48380214A64;
	Wed, 22 Jan 2025 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NpptEloo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77D5213E7A;
	Wed, 22 Jan 2025 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737554371; cv=none; b=g4DtpXk8Gbjf4tYmqZNjT1EkSPJhugDw1YYxG4pGfKHCzb438vvm7R8TWTBO8GKTRiRpTpvgZG/vRayJNt7d0uEzR2pBAW9tQkzFZh62KHNkJeffMazlXmirdsZJ36UPBr/lwtC5O8WKpPmbKrWZBgjeuTqnvmgFqWjDGUn7L50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737554371; c=relaxed/simple;
	bh=nvfCGmKFPueXN9fyf0SxBVc93+49qmAp8YB9j+mwDII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kf9MnZeKDz8aEZIh+bQG3dasb/I3S2IGaFgKkY/vP2n88icxQAx6kyfrzfpa12MTEMvvSxwoeZuuvwozqNEXfD6hETGkCPHew6of7MOYj5p+gXfr3OqCGxcsL9crjcSQqdCzwEZx8CP+6RvRVG5Ujl+EzmjR6HcNQk2cyh9tKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NpptEloo; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737554370; x=1769090370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nvfCGmKFPueXN9fyf0SxBVc93+49qmAp8YB9j+mwDII=;
  b=NpptEloo+mq+A0iXboFS+QIN00Fd2yl9FipwCgpIxP9XfgqhGbufIo6x
   X3yeWLqH8QUree5LXnNcel8klhrtsNroq51dYaSkVOvsh7YRbFBVbQZZw
   68Fp5q30sgZenoiA5Q8tNcttNlr9cW/qtFOjpMJ8FaiRWVxRXVdjHgGOF
   9ZmAn+aHt4YAQ+WYVR3Q7j5d41NBgdX2yF7jRbN6r/PO49JJ92tSOyz2m
   yJFLuJTjzTqOppV8lrWyBPt1XNSN31lG19by8B7ikPSBwpNz84Cqic6hP
   Lh/sua0eAeDz2LNuVAJsFyk9T/XHgAezxy84Mjl6imlgP1s8IDFD+a+iD
   w==;
X-CSE-ConnectionGUID: YcyqaB4nRlOGJu624GtK4g==
X-CSE-MsgGUID: yLWCzfolSbKS4AjFPQhAew==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="48674107"
X-IronPort-AV: E=Sophos;i="6.13,225,1732608000"; 
   d="scan'208";a="48674107"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 05:59:29 -0800
X-CSE-ConnectionGUID: LUmPfTPFQ3iTLhd+lB23Ng==
X-CSE-MsgGUID: OIlfl4LFQBe9O8LGXr0eCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,225,1732608000"; 
   d="scan'208";a="107253391"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.228]) ([10.124.241.228])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2025 05:59:26 -0800
Message-ID: <4f3752f0-e940-4f2f-9606-58fd2f019655@linux.intel.com>
Date: Wed, 22 Jan 2025 21:59:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] KVM: TDX: Add methods to ignore virtual apic
 related operation
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com,
 xiaoyao.li@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-14-binbin.wu@linux.intel.com>
 <CABgObfbFX+3rCcB2teTEMO=EPiuOnaXjMW+tR3UF5t7gWwiNwQ@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CABgObfbFX+3rCcB2teTEMO=EPiuOnaXjMW+tR3UF5t7gWwiNwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/22/2025 7:34 PM, Paolo Bonzini wrote:
> On Mon, Dec 9, 2024 at 2:06 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>> -       .hwapic_irr_update = vmx_hwapic_irr_update,
>> -       .hwapic_isr_update = vmx_hwapic_isr_update,
>> +       .hwapic_irr_update = vt_hwapic_irr_update,
>> +       .hwapic_isr_update = vt_hwapic_isr_update,
> Just a note, hwapic_irr_update is gone in 6.14 and thus in kvm-coco-queue.
>
> Paolo
>
Thanks for the info.

