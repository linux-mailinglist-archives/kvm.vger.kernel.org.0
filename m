Return-Path: <kvm+bounces-58826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA0EBA1CA8
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 00:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C0AB740C1F
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 22:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97BF31E89F;
	Thu, 25 Sep 2025 22:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PruQJXrX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C11235358;
	Thu, 25 Sep 2025 22:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758839211; cv=none; b=Ms9aewqOtpOu6wrE+hPFZRgRnuu0FEmOMxtNZPeipgQfGUrsG2S+lxsqzcDw5ePbIzo3mObV+RhQXdIppfqKQVGP2QuFGpCG3k8aaQd1lI6Qoz1T8flSY94RVj/SaM97+JMM0BlXY1RkQoPuPIaPRf3bTgkY+WKgSciDy/XAEhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758839211; c=relaxed/simple;
	bh=y8aCu9NESh0NVPciwZYe19Rxo6RA8Y4jx0b6M5NqwqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R2hbmEYI4DAReFzrzaMKLeJ/0RilCC5qn025VaQ3gTZ9o9fQ7nkkd8CesekkNW67WRHQpqsrtwqds4yuh8NtCC1DC/a1g/8R/+9aBV9w76hRaXzyjgOrRkXz0sKHMu6OVizm1XaOHZbFhVyiBrFD5CYnhI8Uh+M/VzXvd9GlAvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PruQJXrX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758839209; x=1790375209;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y8aCu9NESh0NVPciwZYe19Rxo6RA8Y4jx0b6M5NqwqM=;
  b=PruQJXrXeAbnKOXtH/FsofMbXJilr/I9pB2dcsnSr/4CequipFNFyJBF
   xGAkhW+0P5LSr25R03iq2K8sxFYTzHFruE9aGwkvyOt+lSAlcwKPPD46K
   LMg/0pOVlQTsAgS/1NiD5q6VJpWTlbsU05zd9Z0mKVDbnsIUv3xSgbzGH
   fOWPFCeEicPXY779//KgomiUP54iBT8xP75HyAYQHwixhhGGoRwz/kWD8
   UBYPlUrYU+5kO5sJ+138461ERS0gMJTNWqHnIvlhK4lhs0YO9cW+AeBYv
   crynj6KR/LGzAuGh1/smLQjqRmCNqSVaPpBh97pBabD93BIi68V2iFKUO
   g==;
X-CSE-ConnectionGUID: O3I3BHLKTlO2jtSZrIA/9Q==
X-CSE-MsgGUID: fND8rEndQaePhH1uDyxa1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="83779841"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="83779841"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 15:26:49 -0700
X-CSE-ConnectionGUID: ssyuVzJlRVu8xc7eoRt0VA==
X-CSE-MsgGUID: sk1hz81AS0KnvxoU+GvQNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="181447068"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.190])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 15:26:48 -0700
Date: Thu, 25 Sep 2025 15:26:41 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH 2/2] x86/vmscape: Replace IBPB with branch history clear
 on exit to userspace
Message-ID: <20250925222641.6lgdjua6oavdmih5@desk>
References: <20250924-vmscape-bhb-v1-0-da51f0e1934d@linux.intel.com>
 <20250924-vmscape-bhb-v1-2-da51f0e1934d@linux.intel.com>
 <LV3PR12MB9265478E85AA940EF6EA4D7D941FA@LV3PR12MB9265.namprd12.prod.outlook.com>
 <20250925220251.qfn3w6rukhqr4lcs@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925220251.qfn3w6rukhqr4lcs@desk>

On Thu, Sep 25, 2025 at 03:02:57PM -0700, Pawan Gupta wrote:
> On Thu, Sep 25, 2025 at 06:14:54PM +0000, Kaplan, David wrote:
> > > -       if (vmscape_mitigation == VMSCAPE_MITIGATION_AUTO)
> > > +       if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER
> > > &&
> > > +           !boot_cpu_has(X86_FEATURE_IBPB)) {
> > > +               pr_err("IBPB not supported, switching to AUTO select\n");
> > > +               vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
> > > +       }
> > 
> > I think there's a bug here in case you (theoretically) had a vulnerable
> > CPU that did not have IBPB and did not have BHI_CTRL. In that case, we
> > should select VMSCAPE_MITIGATION_NONE as we have no mitigation available.
> > But the code below will still re-select IBPB I believe even though there
> > is no IBPB.
> 
> Yes, you are right. Let me see how to fix that.

Below should fix it.

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 2f1a86d75877..60a2e54155e2 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3328,8 +3328,10 @@ static void __init vmscape_select_mitigation(void)
 	 */
 	if (boot_cpu_has(X86_FEATURE_BHI_CTRL))
 		vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
-	else
+	else if (boot_cpu_has(X86_FEATURE_IBPB))
 		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
+	else
+		vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
 }
 
 static void __init vmscape_update_mitigation(void)

