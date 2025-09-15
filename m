Return-Path: <kvm+bounces-57576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DADE7B57EDC
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:26:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F6F51774B9
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0784324B1D;
	Mon, 15 Sep 2025 14:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7blHXjd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16561C860A
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757946365; cv=none; b=cZP26DtW87dSW1lK5/14Xzrholdi5ZnHQ/+A4x6b3GDCaZddRFdxIeJuLc2NgzZwFWEceruTkP4jqbzP8irk5FukDUFNY0eTrq8q12hyCjlB52sLYkUFyvBse6VQ/+y6TUggrcW0S4VWe8OqnnjBfObQNsnn7o4ojAnQuC+CSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757946365; c=relaxed/simple;
	bh=24dqys0fGPAuHsnHo+RJdsFLUXemxSGL8lu7wQtIaI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TtIJz/xOP750KGPvSXubWeKUv7s2Ba83BH+yUgqiLTm3Zg/w/i8yFftDjPJGLfDDdP9keoZbdT1o39c62VlYAS/PFdSL8b+RlixEU5ux3V+7xPZOrBXB53EjRxqXFHdbTYuphV0e2BKCJ//0ZArfeN0z3gFF8YwtU3NwYub+V2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7blHXjd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC1EC4CEF9;
	Mon, 15 Sep 2025 14:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757946364;
	bh=24dqys0fGPAuHsnHo+RJdsFLUXemxSGL8lu7wQtIaI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B7blHXjdIACd7YFT1d9V8xTcigIY6QrcPoZCzUaLmMJycVz0e9yklmad6qvaX8xQw
	 0xPm4kDZXgUGbypK4/PcOZEcEIwqzH9cPIrUUYtTvqws/KRBkwj6ygts2p7+tAVScj
	 cxrLOC+VZN6FL3W4gW4Aa3mlkrGxQJR+xLREAQWsYfbEm3VotZqHfI1E228OzkdhaW
	 2xSQO6VtP9k/TdyDWzD8sPebnxaQLpRsFAdL6aDZlevnoIjDLen7TzbFIKMiwKDnyA
	 dtNpQ3cmLq8QsU3qWiywNQgfliymDVdqLlHlzayR/cR5N0ASsbEcZLJHG3O96FYLbF
	 SGSqpS3RMc/MQ==
Date: Mon, 15 Sep 2025 19:49:48 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>, Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [RFC PATCH 1/7] target/i386: SEV: Consolidate SEV feature
 validation to common init path
Message-ID: <p4ynaokjw42oafnmsmbmkxm52fo2mstf5padafddnqie4jnggv@wrntlc3sev7d>
References: <cover.1757589490.git.naveen@kernel.org>
 <bd64baf06e483cf8df0f7b0f98cf5ad3dd5bff80.1757589490.git.naveen@kernel.org>
 <dd3672b6-5ee4-470f-9b61-f7ddef8bec72@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3672b6-5ee4-470f-9b61-f7ddef8bec72@amd.com>

Hi Tom,

On Fri, Sep 12, 2025 at 08:39:09AM -0500, Tom Lendacky wrote:
> On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> > Currently, check_sev_features() is called in multiple places when
> > processing IGVM files: both when processing the initial VMSA SEV
> > features from IGVM, as well as when validating the full contents of the
> > VMSA. Move this to a single point in sev_common_kvm_init() to simplify
> > the flow, as well as to re-use this function when VMSA SEV features are
> > being set without using IGVM files.
> > 
> > Since check_sev_features() relies on SVM_SEV_FEAT_SNP_ACTIVE being set
> > in VMSA SEV features depending on the guest type, set this flag by
> > default when creating SEV-SNP guests. When using IGVM files, this field
> > is anyway over-written so that validation in check_sev_features() is
> > still relevant.
> 
> There seem to be multiple things going on in this patch and I wonder if it
> would be best to split it up into separate smaller patches.
> 
> You have setting of SVM_SEV_FEAT_SNP_ACTIVE in sev_features, you have a
> new check for sev_features being set when using an IGVM file and you have
> the consolidation.

Sure, I started with the premise of unifying the call to 
check_sev_features() which necessitated the other changes. I will move 
those as pre-req patches.

Thanks for the review,
- Naveen


