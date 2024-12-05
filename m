Return-Path: <kvm+bounces-33115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D248C9E4F76
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 09:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 927D8281333
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 08:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900401D0F46;
	Thu,  5 Dec 2024 08:14:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8920EC0;
	Thu,  5 Dec 2024 08:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733386445; cv=none; b=DE0VQFi+tfYrpZr0nW8RuO14bN3D+4wM2AyGPjOMzuh5feCQ9YOO7xiuEgTBsw+M1LC1pAsUZGRBDy9K8pMLszYBmDUrPLpAaZXXJJuDViC4kZnSw5GWZ6Cwiv1aLMuhLa73gXxXfAAI7mePSEJ97FBYOwzeTVJWb0djuzDqrx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733386445; c=relaxed/simple;
	bh=uG4kweo2R0LPJaPBPblkzf1XyKYVzjFv1M2jhqBoBEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVAG3P/jA5T7dPy6RwjxI6UJUJD2dEAU+o/cIplHLsvCiXIuXwxkFsXB8A2z/ApzLqExbX4h1KPbGvB5mUyeHq0vNfaNmPIYeXSwO4uzLBY93SbSCQeBxgtEv45CIl+yYAzHGRm4ZmgJvJ+FU2hiamHXwspffjlz+kKQc2ZTUdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=fail smtp.mailfrom=kernel.org; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.org
X-CSE-ConnectionGUID: hjziUAGvS9ihPHjuvp2fzw==
X-CSE-MsgGUID: +TtJ3r9aTV+2oAIWt0O/DQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="44291665"
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="44291665"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:14:03 -0800
X-CSE-ConnectionGUID: fVDbkDdYStehzmCp4b0FYQ==
X-CSE-MsgGUID: lVV0iEYnTiS1VgeoRO+KOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,209,1728975600"; 
   d="scan'208";a="94210168"
Received: from smile.fi.intel.com ([10.237.72.154])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 00:13:59 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andy@kernel.org>)
	id 1tJ6zk-000000041VC-1mEX;
	Thu, 05 Dec 2024 10:13:56 +0200
Date: Thu, 5 Dec 2024 10:13:56 +0200
From: Andy Shevchenko <andy@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 09/11] x86: rework CONFIG_GENERIC_CPU compiler flags
Message-ID: <Z1FgxAWHKgyjOZIU@smile.fi.intel.com>
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-10-arnd@kernel.org>
 <CAHk-=wh_b8b1qZF8_obMKpF+xfYnPZ6t38F1+5pK-eXNyCdJ7g@mail.gmail.com>
 <d189f1a1-40d4-4f19-b96e-8b5dd4b8cefe@app.fastmail.com>
 <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wji1sV93yKbc==Z7OSSHBiDE=LAdG_d5Y-zPBrnSs0k2A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Wed, Dec 04, 2024 at 03:33:19PM -0800, Linus Torvalds wrote:
> On Wed, 4 Dec 2024 at 11:44, Arnd Bergmann <arnd@arndb.de> wrote:

...

> Will that work when you cross-compile? No. Do we care? Also no. It's
> basically a simple "you want to optimize for your own local machine"
> switch.

Maybe it's okay for 64-bit machines, but for cross-compiling for 32-bit on
64-bit. I dunno what '-march=native -m32' (or equivalent) will give in such
cases.

> Maybe that could replace some of the 32-bit choices too?

-- 
With Best Regards,
Andy Shevchenko



