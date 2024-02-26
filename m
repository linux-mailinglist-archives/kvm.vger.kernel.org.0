Return-Path: <kvm+bounces-9952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8426C867F38
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 226011F2F41A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADCC12F59E;
	Mon, 26 Feb 2024 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sant42uM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70FB12EBED;
	Mon, 26 Feb 2024 17:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969715; cv=none; b=XlPtqA9ZnbTUOSLIIfKzOvHskm7+XI2Cl7oqak4ltWWLZt7/oQ1l3paJb+uC6qiazf+VqnZkpJKIuZcpW0LaF0KHUzmLtbPl6IkE8wx2Kr6am7M6xvlRTJaS01TwxrrmMg0wzCiMGw4FMGcqbw0+bvaPvFAqp0Ljcc1CjptcUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969715; c=relaxed/simple;
	bh=WA21Fa+u+0bZAQGTzI3bdQdJE0FzbKKnJdNhwb93T+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gOcdz9u5K9MOZXVQnXbC+RIkR9TzPyO3B7ByX1QSoobmEKqxB7wvtZ/c0Gs0ZakGlDjtBLXLPpXI6MoJpFfOU/tK5jLKa8Ivj5YvA9HE2Mz11aXB291B77lhR08HlwZNX3IoIvwpvQNk9Uk00svqeFeOKSgyMPYaF5UgbKM7MGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sant42uM; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708969712; x=1740505712;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WA21Fa+u+0bZAQGTzI3bdQdJE0FzbKKnJdNhwb93T+E=;
  b=Sant42uMS0h1lu1JPV2clx/fTqWpp9fp/21xua7ShTkQQ6qDuCbFQIdB
   V7z6UdWIkZ72xOXfm55lKkof/h1he7mJPofLET1Q2WWBasWhEKFkjkh4+
   Dp/Mkpc/jBBDpoN5LFHVMVARY3cL+P6XMs45CZZU2L8WEm6M283v5FQoD
   14w3oyjKG0sLDwpYgGzA/iY47WqJA0VujDeu8z4s4AlmDGPT6hIz4FSrI
   z9pV+dCaZht7/6ZNAf73TBOhNF0DUYWyEPXzjc/Jhtb6YjGlje1G/qCsM
   oMXkRF2uQ6MTlyfojIIL5Ap1Xa1GoDKFV0iSYTV4oATJYkvlWVT8ENUOZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3428125"
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="3428125"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:48:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,186,1705392000"; 
   d="scan'208";a="29919652"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 09:48:32 -0800
Date: Mon, 26 Feb 2024 09:48:30 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v18 032/121] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
Message-ID: <20240226174830.GA177224@ls.amr.corp.intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <591420ca62f0a9ac2478c2715181201c23f8acf0.1705965635.git.isaku.yamahata@intel.com>
 <CABgObfaEz8zmdqy4QatCKKqjugMxW+AsnLDAg6PN+BX1QyV01A@mail.gmail.com>
 <Zcrarct88veirZx7@google.com>
 <CABgObfYFnpe_BO5bNRvXC6Y-3rUxFAogs2TGFUTBu+JR25N=pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfYFnpe_BO5bNRvXC6Y-3rUxFAogs2TGFUTBu+JR25N=pQ@mail.gmail.com>

On Tue, Feb 13, 2024 at 05:47:43PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Feb 13, 2024 at 3:57 AM Sean Christopherson <seanjc@google.com> wrote:
> > The only thing that even so much as approaches being a hot path is
> > kvm_gfn_shared_mask(), and if that needs to be optimized, then we'd probably be
> > better off with a static_key, a la kvm_has_noapic_vcpu (though I'm *extremely*
> > skeptical that that adds any measurable benefit).
> 
> I'm okay with killing it altogether.

I eliminated this config.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

