Return-Path: <kvm+bounces-33397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A829EABF3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 10:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC2141886FFB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 09:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC9B23498D;
	Tue, 10 Dec 2024 09:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gl7jBWKX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6722CBE5;
	Tue, 10 Dec 2024 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733822872; cv=none; b=LV7YneDREBRHXiJCqCGB2aTpde0hc9nhvU+qRBz/keIl3vsYWOwMNCEPq4X48qTMJY8igkFAVayqkjt0QsWdhtIFtJljrpcLMrZxXqyj9OcnJRxxYUo1q0+BYY5A4D1E3Qy/X4qshj+V1WjNn1bBYtt23OXVbEn99EByyww4An8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733822872; c=relaxed/simple;
	bh=JR5YBRhO//eu6p5VHl2Cy8j9Yv+oYzNRBr4D+Wdeu6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCaHzDd6y8Yg1/1l0pjTdWwMJJCqQ0h6j2g8HEIm8rYMqi0ApKgc9GlDcYZSb1xxwyC4iRSgTR73X+TVAsExTAfsPnOuHrEUfLUcLhH43Fj2hs5s5lXsi41cQ33Jll2ZmBjGbRUyVRXE7A9ZwQVgzbgsaTMpEawdTGbm+0fa/Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gl7jBWKX; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733822870; x=1765358870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JR5YBRhO//eu6p5VHl2Cy8j9Yv+oYzNRBr4D+Wdeu6I=;
  b=gl7jBWKXwxqetgqtvPNCDD2YC4mXnaRkwjc+SxAT0Cg2QgF36CcmYvIZ
   HHdjwW5OsWj7CwYpE1Qd+YaRaFfKrR0UQCcQK+uA68G1oWL5wzQ/WKs4Z
   HesZ5jMGpm2Gxj7cNR5vMJoeeTJp5T5hlGrBoM+zn/ecnQMChRMnMH9me
   rZpnnEKfT20AuPy1pQ/qOXMcQPiuKf+IOJatkoYn57Z+60Ex1IbonHtYK
   v9rjMQ7qvH2gvgVvWH20DEOgz2RHL7g5++DNN/Q+YcKePBbwxLfejbEoy
   fqxj7tzkMCWdXgUJChkCecW/0j4rVrcYxRuepxRF2QMl6vuN1VXQcobv0
   w==;
X-CSE-ConnectionGUID: iqSi+UvGT4mepgFb2hdZuQ==
X-CSE-MsgGUID: ickFTKs0SE2ZQsZHrRIn/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="21742799"
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="21742799"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:27:49 -0800
X-CSE-ConnectionGUID: KFk3c24FS+eCAQsHuiup1g==
X-CSE-MsgGUID: Xao4va4qRn2jUvn2fz3fNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,222,1728975600"; 
   d="scan'208";a="118600177"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO localhost) ([10.245.246.224])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 01:27:44 -0800
Date: Tue, 10 Dec 2024 11:27:40 +0200
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
	seanjc@google.com, kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
	kai.huang@intel.com, adrian.hunter@intel.com,
	reinette.chatre@intel.com, xiaoyao.li@intel.com,
	isaku.yamahata@intel.com, yan.y.zhao@intel.com,
	michael.roth@amd.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
Message-ID: <Z1gJjCzDF6JNKCyl@tlindgre-MOBL1>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <Z1bmUCEdoZ87wIMn@intel.com>
 <e8163ac4-59cd-4beb-bb92-44aa2d7702ab@linux.intel.com>
 <Z1gFhU0oTGUNssMP@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1gFhU0oTGUNssMP@intel.com>

On Tue, Dec 10, 2024 at 05:10:29PM +0800, Chao Gao wrote:
> On Tue, Dec 10, 2024 at 10:51:56AM +0800, Binbin Wu wrote:
> >On 12/9/2024 8:45 PM, Chao Gao wrote:
> >> > +/*
> >> > + * Split into chunks and check interrupt pending between chunks.  This allows
> >> > + * for timely injection of interrupts to prevent issues with guest lockup
> >> > + * detection.
> >> Would it cause any problems if an (intra-host or inter-host) migration happens
> >> between chunks?
> >> 
> >> My understanding is that KVM would lose track of the progress if
> >> map_gpa_next/end are not migrated. I'm not sure if KVM should expose the
> >> state or prevent migration in the middle. Or, we can let the userspace VMM
> >> cut the range into chunks, making it the userspace VMM's responsibility to
> >> ensure necessary state is migrated.
> >> 
> >> I am not asking to fix this issue right now. I just want to ensure this issue
> >> can be solved in a clean way when we start to support migration.
> >How about:
> >Before exiting to userspace, KVM always sets the start GPA to r11 and set
> >return code to TDVMCALL_STATUS_RETRY.
> >- If userspace finishes the part, the complete_userspace_io() callback will
> >  be called and the return code will be set to TDVMCALL_STATUS_SUCCESS.
> >- If the live migration interrupts the MapGAP in the userspace, and
> >  complete_userspace_io() is not called, when the vCPU resumes from migration,
> >  TDX guest will see the return code is TDVMCALL_STATUS_RETRY with the failed
> >  GPA, and it can retry the MapGAP with the failed GAP.
> 
> Sounds good

Makes sense to me too.

Regards,

Tony

