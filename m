Return-Path: <kvm+bounces-57578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8E0B57EE0
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CC82162D8C
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:26:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0386230B51F;
	Mon, 15 Sep 2025 14:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q3j+uDnp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A420322DC0
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757946378; cv=none; b=KVIFVwD0fKQXziUUohCD37Bl0IC5tiXKuDSSPqoreIy8H0U8ldVTdaCBGQqmsYpmUT6BXwHBlHRTIuVNGn9nunUwS7W9w6uzYqDgR9xBpEQfFn7UFCwd3B4SEUrvZ/1y4x9m6hOYBHE9L8CF8/Nn7m2l5JM1DKl96NQnm8CGcfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757946378; c=relaxed/simple;
	bh=a0FP0D99H9vBGZzMmTJ9lETyLW7JGGn8jb+atITB0Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihrbj0dJdWkO4PAiP8NltNHWEezb9I0WPaTZvOccFvEu0Q8PCJC1IE9Pbqh2IjONTDwgWi8YCFfDnVAjlfhK3rA5TZqhoRSHkKA5ORW84Ps1WHhYzkvNXc+VDE+ZW1yHSlLkOpK6UICgq9qhDP9Q1WfBLo7GuqWFPEvtZ0QMbj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q3j+uDnp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A429C4CEF1;
	Mon, 15 Sep 2025 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757946377;
	bh=a0FP0D99H9vBGZzMmTJ9lETyLW7JGGn8jb+atITB0Ao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q3j+uDnp4Z76D+OQNW00cAYSqZFdvsEeYFohEe8Tq7tD/viod9aCe3s72dUa+knuY
	 R7nujGSSfy1MCapi7aDbg+MJ0xe2bNY7yI/2ylsqQPzL5MBpSaZxVDkIb7T/Q7bRGF
	 vAOLrdabh+LzARzAmAFIIPAli7WH7u7qnu4F+Jw2tyFJHxf2e7BHPvRL0sj6UAQ0SI
	 0M0hfDxAtyCvfzCDyfwq4hu7ZAly2uW/yn11M39x7932CwM1KPkrXl32B/a+P+ZzUb
	 ufqrYRdI9iYB8fzK3jKMVOHwjGyR+mnTRemxh8ubHQH++CmBeW8dxrh0al/jgnx8xK
	 OAJgW9zTNsGrg==
Date: Mon, 15 Sep 2025 19:55:47 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>, Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 3/7] target/i386: SEV: Add support for enabling
 debug-swap SEV feature
Message-ID: <abrl6m327yzcjhkk6wircecgq6ryven6uakifzwzbndgcpnxcg@n3tk7cevpmpc>
References: <cover.1757589490.git.naveen@kernel.org>
 <0a77cf472bc36fee7c1be78fc7d6d514d22bca9a.1757589490.git.naveen@kernel.org>
 <98064a4a-41d7-4071-893e-4cced0afb66a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98064a4a-41d7-4071-893e-4cced0afb66a@amd.com>

On Fri, Sep 12, 2025 at 08:50:28AM -0500, Tom Lendacky wrote:
> On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> > Add support for enabling debug-swap VMSA SEV feature in SEV-ES and
> > SEV-SNP guests through a new "debug-swap" boolean property on SEV guest
> > objects. Though the boolean property is available for plain SEV guests,
> > check_sev_features() will reject setting this for plain SEV guests.
> > 
> > Add helpers for setting and querying the VMSA SEV features so that they
> > can be re-used for subsequent VMSA SEV features, and convert the
> > existing SVM_SEV_FEAT_SNP_ACTIVE definition to use the BIT() macro for
> > consistency with the new feature flag.
> > 
> > Sample command-line:
> >   -machine q35,confidential-guest-support=sev0 \
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> > 
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> 
> Should you convert the setting/checking of SVM_SEV_FEAT_SNP_ACTIVE in the
> first patch (and wherever else it might be used), too?
> 
> If you do, then it would split this into two patches, one that adds the
> helpers and converts existing accesses to sev_features and then the new
> debug_swap parameter.

Sure, I'll do that.

Thanks,
Naveen


