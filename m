Return-Path: <kvm+bounces-19529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FC20905F4A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41B4B28536B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3669C12D742;
	Wed, 12 Jun 2024 23:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnsOlQDN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E2A34;
	Wed, 12 Jun 2024 23:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718235396; cv=none; b=fZjQoeilu48rCDOqjuzi91AnscthxS3ftsRrOY0esw5I6epyGdergWxKWDE0HWH3q6ocaYRiW67ygr02bLbDDSXEOL3vBuWzSN6Fmpcl+Nt1gK1k/ozqtEaxNSbZtWxZCHYysX4htw2yj+gI3vD6VTYDw9gQOAhrpYtb0qmUvnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718235396; c=relaxed/simple;
	bh=/ot1u8+j6JBXYp+ET8FmSCXU3q6m7Kz9DNeH/nvc5aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tr+NKX0WaqY1OsUHol0fd6cOD7PtqFKGnuH1yGCy8k3u3QO6M6iJZUxfswRulwDIB+xaF1e1MBIrArqCg8h64W+jte5sjUyNdIjK6YsZX5ZfByM9Nr7HxLlFP4VUuZKWlfOM1WSGksyAQSm1/vzFiuoU3rfw1nGY9KwcySUm09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dnsOlQDN; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718235395; x=1749771395;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ot1u8+j6JBXYp+ET8FmSCXU3q6m7Kz9DNeH/nvc5aQ=;
  b=dnsOlQDNhu43zGATn1opV0AqQWO0sSRjZhAq2/1cjsXl71PIoZ0hgruT
   YfvjTv2UfGd4uuKTc0v9PMd6Eud6rgK3ZJVkxigHBu0p28K3Szn5lgos8
   jP44fXYQ8jHEWSE7FTMxkCgXel0Dl7XJN5eSgBbpO6NVk6bLCajHvda+J
   i8f+Z50f/wBGE0UrGdz99L1hWFp/Ql1hCVTacZkTVKTiv38rhfhTr42WW
   csOLMxfcpTHCDSL+onMRu+yMUhxCjbDtWkJ6f0IHQpwVJdLJjfqi0g1VO
   iJnGVej54y3mZXN1qHcyA8dVyG0k1jK/WznGjWXQRBWgK6vCcs32YYbxi
   A==;
X-CSE-ConnectionGUID: L7nIl811Qu2ubL3NZpvOwQ==
X-CSE-MsgGUID: jjGG/jqwTTmwEYTkc4FoVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="17951603"
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="17951603"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 16:36:33 -0700
X-CSE-ConnectionGUID: QJUdnfmMR3mkQluVZ708Eg==
X-CSE-MsgGUID: YFkjvzwHRTWoHdsP7JHVhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,234,1712646000"; 
   d="scan'208";a="40578318"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2024 16:36:33 -0700
Date: Wed, 12 Jun 2024 16:36:32 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	stable@vger.kernel.org, rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2] virt: guest_memfd: fix reference leak on hwpoisoned
 page
Message-ID: <20240612233632.GB1900928@ls.amr.corp.intel.com>
References: <20240611102515.48048-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240611102515.48048-1-pbonzini@redhat.com>

On Tue, Jun 11, 2024 at 06:25:15AM -0400,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> If __kvm_gmem_get_pfn() detects an hwpoisoned page, it returns -EHWPOISON
> but it does not put back the reference that kvm_gmem_get_folio() had
> grabbed.  Add the forgotten folio_put().
> 
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

