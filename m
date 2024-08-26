Return-Path: <kvm+bounces-25108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6CB095FCC0
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6371628345B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6A919D8BE;
	Mon, 26 Aug 2024 22:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gMnC74sr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9CE19D892;
	Mon, 26 Aug 2024 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724711294; cv=none; b=DQCznKEON++wUDSPz4gsTD+6DSjXn0Ia1AEWCaryZ0BkI4GdSzmc0a2wjkhXwWxEnyKQKi+5q2YIr2sYaJ1zT9MtHwwukvv78Mzug4vFmnARVuXuVv2THedOGagfJMlQyuifH6PQ7nUxZ8H3MUJy5jchBvd9kJsLzNZ2TcqqHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724711294; c=relaxed/simple;
	bh=0z/jHJvJ2CiUmbBywngI41MtYYLJWRMJngbPClKnvhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FsMpVBG0IEQOhNkuLDlOqEDAU/r2+/lQ+IYToWHR50p64CLlhoYO8Z+9WunOMAYswYpP6jvgyRvEY+t/EnVRTijdIUdmbFHB3ZJW5rY9S2R34rwtE98duoXa6Wm9JmQLx2RiJVV75zSzbL/7p5Vcftgz2DhM9hW04vL5NAGEo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gMnC74sr; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724711292; x=1756247292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=0z/jHJvJ2CiUmbBywngI41MtYYLJWRMJngbPClKnvhw=;
  b=gMnC74sra2DXF9xj+Q53myMhnDRlsuX1KVHcJ5zBlSLtv4k+d/OgqEIO
   118eGay5VWBXW8zFvo32xu8W3MaDKRlQLaeVFzBPbHvNeUiO0/G+FbEZm
   8WH4exLPe/6IhQZPsIaUMnPJNvHIECxofpAkFeGUuEx3vZLWOAlkCsb1F
   sPJZz9xwS3xqWjekbvrt+ppocE4L/btAktlPVsGn1DWaujy5/vC4Rx5qc
   ByyoqCepGmznYgOHIdqq0jPstBqSmTvV9G0HIfKMfH6/OkvDYm85z5Dh8
   R4d51pY4jrSpeVQ8O2XZ1bzVHaDtMvniBmsjrZpIjXlrBUqtBABJs+Yhf
   w==;
X-CSE-ConnectionGUID: B/M/uf3GSVCZzGHwxHXLuw==
X-CSE-MsgGUID: 9zEHqUGFQGuIhwPrgj3UHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23129942"
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="23129942"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 15:28:11 -0700
X-CSE-ConnectionGUID: g+rEMYAhRWCp10fERfNnWA==
X-CSE-MsgGUID: lfdnuBwcSwO53OIZJRGvuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,178,1719903600"; 
   d="scan'208";a="67551410"
Received: from jsolisoc-mobl.amr.corp.intel.com (HELO desk) ([10.125.16.169])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 15:28:11 -0700
Date: Mon, 26 Aug 2024 15:28:02 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Kai Huang <kai.huang@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/4] x86/cpufeatures: Clarify semantics of
 X86_FEATURE_IBPB
Message-ID: <20240826222802.qbcegyewhhxtb3at@desk>
References: <20240823185323.2563194-1-jmattson@google.com>
 <20240823185323.2563194-2-jmattson@google.com>
 <20240826203308.litigvo6zomwapws@desk>
 <CALMp9eQ1tSQtmvF+7BVdpYto8KPN5jfad3o6XPnU9oVOrfxvjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQ1tSQtmvF+7BVdpYto8KPN5jfad3o6XPnU9oVOrfxvjQ@mail.gmail.com>

On Mon, Aug 26, 2024 at 01:59:50PM -0700, Jim Mattson wrote:
> On Mon, Aug 26, 2024 at 1:33 PM Pawan Gupta
> <pawan.kumar.gupta@linux.intel.com> wrote:
> >
> > On Fri, Aug 23, 2024 at 11:53:10AM -0700, Jim Mattson wrote:
> > > Since this synthetic feature bit is set on AMD CPUs that don't flush
> > > the RSB on an IBPB, indicate as much in the comment, to avoid
> > > potential confusion with the Intel IBPB semantics.
> > >
> > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/include/asm/cpufeatures.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> > > index dd4682857c12..cabd6b58e8ec 100644
> > > --- a/arch/x86/include/asm/cpufeatures.h
> > > +++ b/arch/x86/include/asm/cpufeatures.h
> > > @@ -215,7 +215,7 @@
> > >  #define X86_FEATURE_SPEC_STORE_BYPASS_DISABLE        ( 7*32+23) /* Disable Speculative Store Bypass. */
> > >  #define X86_FEATURE_LS_CFG_SSBD              ( 7*32+24)  /* AMD SSBD implementation via LS_CFG MSR */
> > >  #define X86_FEATURE_IBRS             ( 7*32+25) /* "ibrs" Indirect Branch Restricted Speculation */
> > > -#define X86_FEATURE_IBPB             ( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier */
> > > +#define X86_FEATURE_IBPB             ( 7*32+26) /* "ibpb" Indirect Branch Prediction Barrier without RSB flush */
> >
> > I don't think the comment is accurate for Intel. Maybe you meant to modify
> > X86_FEATURE_AMD_IBPB?
> 
> It's perhaps a bit terse, but this is what I meant. Perhaps better
> would be "without guaranteed RSB flush"?

That looks more accurate to me, thanks for the clarification.

