Return-Path: <kvm+bounces-752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CF97E22B9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:04:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D5C41F21AE9
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4DF200DA;
	Mon,  6 Nov 2023 13:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwp6HCpZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367DFB674
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 13:04:06 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF821B2;
	Mon,  6 Nov 2023 05:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699275844; x=1730811844;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v+viOGU3qwP1vIfGdPJcXm+0kRpH20trqAeV1C9YH3M=;
  b=gwp6HCpZvU5VFchfRP/Xf+XYr7J1V/l2keBDsVzixseSBgDfo2ivlZS3
   sCqctNqvd3uvnI/AVh/Q8vSR3qtfY5cyrmGmwOkj/t1jP6KFBVTIPVVkW
   X7zEQTESOaDS8s2GhacppEBjmxA2T/kg0AbziHwRzlHWOuBdeob1ifpU6
   ln494w+RuNYOe+ufEUEvxeFnKOj+zsmd2BHMSeDkSx7kOkUQy+qY9JBZf
   XuXcQjzZ6IT49OEz5Bctd0cZOuLKu/j69IPdIiZsFMWgsNe+dEkirGsRM
   MYgTO3Jqyt2awacaH3lZoLfM8rwcd0mKtMJeoUeUJPCwI1kKgRhjtVD7T
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10885"; a="368605708"
X-IronPort-AV: E=Sophos;i="6.03,281,1694761200"; 
   d="scan'208";a="368605708"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 05:04:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10885"; a="879442673"
X-IronPort-AV: E=Sophos;i="6.03,281,1694761200"; 
   d="scan'208";a="879442673"
Received: from jgulati-mobl.ger.corp.intel.com (HELO box.shutemov.name) ([10.249.42.157])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 05:03:59 -0800
Received: by box.shutemov.name (Postfix, from userid 1000)
	id 8C032104790; Mon,  6 Nov 2023 16:03:56 +0300 (+03)
Date: Mon, 6 Nov 2023 16:03:56 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com,
	Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
	bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, dionnaglaze@google.com,
	pgonda@google.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Message-ID: <20231106130356.5mppou4pzxmldy22@box.shutemov.name>
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
 <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
 <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
 <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
 <cf92b26e-d940-4dc8-a339-56903952cee2@amd.com>
 <20231102123851.jsdolkfz7sd3jys7@box>
 <b56a1eb7-4e31-4806-9f5e-31efe7212e04@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b56a1eb7-4e31-4806-9f5e-31efe7212e04@amd.com>

On Mon, Nov 06, 2023 at 05:23:44PM +0530, Nikunj A. Dadhania wrote:
> > Maybe kvmclock rating has to be even lower after detecting sane TSC?
> 
> If I set kvmclock rating to 298, I do see exact behavior as you have seen on the bare-metal.
> 
> [    0.004520] clocksource: clocksource_enqueue: name kvm-clock rating 298
> [...]
> [    1.827422] clocksource: clocksource_enqueue: name tsc-early rating 299
> [...]
> [    3.485059] clocksource: Switched to clocksource tsc-early
> [...]
> [    3.623625] clocksource: clocksource_enqueue: name tsc rating 300
> [    3.628954] clocksource: Switched to clocksource tsc

This looks more reasonable to me. But I don't really understand
timekeeping. It would be nice to hear from someone who knows what he
saying.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

