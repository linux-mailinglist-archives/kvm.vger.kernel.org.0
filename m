Return-Path: <kvm+bounces-23671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 956C994C987
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 07:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 013592865A8
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 05:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D947716B75F;
	Fri,  9 Aug 2024 05:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X7RHGJKB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FBA3EA71
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 05:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723180539; cv=none; b=pUV5/a5l0xC7RmyUPhMtqpZF72UWYP3UeMfWJbPyg4P8Go5cKMXQRxdjbrtMOLv3FEVOIrAitYxN6RaxRQQUBt3OFTvfDKI9lT+SP8ZeQt0jyUJ6YxJJjx2xQp1sfqqwAbtp5tZRj78yF4ygh1vmvtKpQP3v0U67fS3aIRfGSs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723180539; c=relaxed/simple;
	bh=7zC5X+3wT/YG6YfO3WL6oaU7GpvFEdfjp8clX6chuQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j99cF360Nj/501rv/GHL3li9cfVhYLmSv/P8ks6m+yAoa47u2bSHtPigDVUhgz+pytahdQ6dmxBwB97+RBs3UVc+6F3F/bLMtkPH9J3d0skGQNhMsLG4ll6ZYCfttdK7c7+kDV6xBFTrGGmFTDWiJ4gWcX1j9BOaVMirxKzCuNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X7RHGJKB; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723180538; x=1754716538;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7zC5X+3wT/YG6YfO3WL6oaU7GpvFEdfjp8clX6chuQw=;
  b=X7RHGJKBmIPO9FNj0ZlRow7WwudHaJvPxaQ3zmGKoX7MG2A1VEAfixb3
   sOpo8Z5gkKPVS0JWvTQIJHGWfUF7E1bxQ+xPLsHNCJQBjP7xF70xtK2vm
   cvFGZS8H+avJhZuO6g2kqPkTV0Cd4f3ydRKTe43rnphuJ7ytuNEayImKi
   fb9H9d2N1c3yF61erbKnC5p7uAUlKrHM0HBjS6S3qNFa2tUkzmZ6L5YZ0
   8SHWEcVKzV4TxW2Meac5EYMrPXISEij6f37lmSNg4puLTAqqMaXHuADYT
   HmqxHnoyWYJBbsbnSHtfaYPzqBiIqvSvrcjCW3EnnP88xMHSUSnKVMu92
   Q==;
X-CSE-ConnectionGUID: j/pwG95tQ5eER/0hiK0U0g==
X-CSE-MsgGUID: xpULnzJkTUS6HZag8BLRKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21312499"
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="21312499"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 22:15:37 -0700
X-CSE-ConnectionGUID: yV7O915vSnSqhBA9FQMAoQ==
X-CSE-MsgGUID: s+CAelOOQNCcrseZoelePA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="62095893"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 08 Aug 2024 22:15:34 -0700
Date: Fri, 9 Aug 2024 13:31:24 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, cfontana@suse.de,
	qemu-trivial@nongnu.org, kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v3 2/2] kvm: refactor core virtual machine creation into
 its own function
Message-ID: <ZrWprIS6gFhCQFjR@intel.com>
References: <20240809051054.1745641-1-anisinha@redhat.com>
 <20240809051054.1745641-3-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809051054.1745641-3-anisinha@redhat.com>

On Fri, Aug 09, 2024 at 10:40:54AM +0530, Ani Sinha wrote:
> Date: Fri,  9 Aug 2024 10:40:54 +0530
> From: Ani Sinha <anisinha@redhat.com>
> Subject: [PATCH v3 2/2] kvm: refactor core virtual machine creation into
>  its own function
> X-Mailer: git-send-email 2.45.2
> 
> Refactoring the core logic around KVM_CREATE_VM into its own separate function
> so that it can be called from other functions in subsequent patches. There is
> no functional change in this patch.
> 
> CC: pbonzini@redhat.com
> CC: zhao1.liu@intel.com
> CC: cfontana@suse.de
> CC: qemu-trivial@nongnu.org
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>  accel/kvm/kvm-all.c | 86 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 53 insertions(+), 33 deletions(-)
> 
> changelog:
> v2: s/fprintf/warn_report as suggested by zhao
> v3: s/warn_report/error_report. function names adjusted to conform to
> other names. fprintf -> error_report() moved to its own patch.

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


