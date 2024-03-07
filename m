Return-Path: <kvm+bounces-11250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3053D874661
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 03:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61F021C21F7F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 02:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76405CA62;
	Thu,  7 Mar 2024 02:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hhQGj9ZO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A958A3D71;
	Thu,  7 Mar 2024 02:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709779976; cv=none; b=WbrxkemZAu7cFqA7G6Jotq3fpYBnjFTeyWZhJwe9Y/a+t3MljjrWFb7xg8vHlOfnLAAies9wiHntKzYxf54XKovRQYUqtH1pdAtyK0zlW4MD7p5kSHWmFfPwwGHpl5+/lBizp/LskPS5r/kY9DVoqFx7wUElhvQhHEtUJt5NxCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709779976; c=relaxed/simple;
	bh=2JAHTpQP0sPgir3sGjPu5gyDIuuD+wQ+e68TUz1lrTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY/b3zeg/6WCROv8J/ZXxdcV/Bup0MRXsIKJZUNuSmQUif8P5DQqh5G2amDqq+3fSOLh/NZCbULmhbhU44XJqRUZajUicIW9YrcyfCJetc0cBxlCz2vGzUwsjQfeRd15HbJvbgNfTGWQNRWsPZTpMjsh/0jThKF4r9SH8sCFbmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hhQGj9ZO; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709779974; x=1741315974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2JAHTpQP0sPgir3sGjPu5gyDIuuD+wQ+e68TUz1lrTE=;
  b=hhQGj9ZObZQCH3eTEx7PwrwdSJvoubf4kUdVR0FuWBDfiCMTJpBgZFsS
   XULzW88zor1+qXpsI6LjgohMvYBb3pIc3G8GEPNZwl38JQqLDEfBNLpD2
   hxHPdnoLY2w/eIWHk1Dgm/uv91F7pa/GByvbaSGnx78hKW4248Yy837TG
   fhkZsjvHVYDEgfHoLgdeJ/qsUMfeR8FCdP7I/NBWenq5ONkjS9GXO/M+r
   LKH1fPy8KeK91nb2p/qsg6zBZ10mc1B7PtzfV2+ZTWEvTcInpPEbQwK7C
   e18GrYp8+e4+uugehSxK6hPz9w3msWOP0M8hHSR9N88S7suTLGHE1wORA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="8249351"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="8249351"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 18:52:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="40941433"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 18:52:53 -0800
Date: Wed, 6 Mar 2024 18:52:52 -0800
From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
To: David Matlack <dmatlack@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Message-ID: <20240307025252.GH368614@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
 <ZekPD_L7vam2W-CJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZekPD_L7vam2W-CJ@google.com>

On Wed, Mar 06, 2024 at 04:49:19PM -0800,
David Matlack <dmatlack@google.com> wrote:

> > +			cond_resched();
> > +
> > +		r = kvm_arch_vcpu_map_memory(vcpu, mapping);
> > +		if (r)
> > +			break;
> > +
> > +		added = true;
> > +	}
> > +
> > +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +	vcpu_put(vcpu);
> > +
> > +	if (added && mapping->nr_pages > 0)
> > +		r = -EAGAIN;
> 
> This can overwrite the return value from kvm_arch_vcpu_map_memory().

This is to convert ERESTART into EAGAIN.  I'll drop this check
and document EINTR so that caller should be aware of partial population.
-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>

