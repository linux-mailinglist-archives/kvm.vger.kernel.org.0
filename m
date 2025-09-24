Return-Path: <kvm+bounces-58637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 500EBB9A0EF
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118581673DB
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD72C30277D;
	Wed, 24 Sep 2025 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rlp71cpN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DC7143C69
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721077; cv=none; b=BePWoa+9TKNobilxcoQfWrc+J4flGMqsz4jg5HTbppl1W7iD8xdbku57+UOBQbd50JcxWT/quIUlAV+H+21MZf8XB1yjwkFIrsFMiHD/tf/JmCCsahXtL24rUjpcSkKFByWoYdlfe9UM0jCMV14rxIsQduY2y7LjNbqLbGyg0OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721077; c=relaxed/simple;
	bh=E4ixhkY8HwW7iTS5Si12737ldgLwAXbST4HbN3m8JQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KG25YbYFoHMZxNPb4MS587bhViONac4d4GHVwbS5XmQuhSbeL1Gz3i+uRNBqmNCLQmGXxB/FNJmJn0lmpCgqC+5PcLBpYqbOmWKYNV2/KiSbRoPdgXF4WmOqshkrlVIYoZIcVp+UxMUMgMhFZMtOhVoj8/GLTwP24Sl8yH00Yvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rlp71cpN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FA5C4CEE7;
	Wed, 24 Sep 2025 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758721077;
	bh=E4ixhkY8HwW7iTS5Si12737ldgLwAXbST4HbN3m8JQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rlp71cpNyDWxFZcNHMebg7CHBETrkBT/z2q4nKtjHX0YD9Yo1DW7ERFJez3fkG1EQ
	 hnBk4u6RYsLp65YY5FDei4pqUi8bBls5niTU+/ENorFrm3RJXZlEyv/xqiiUymlm8i
	 qsU1xsFfnb+mtxl+WBawJY123Gad2gkrvB2tP3p/PBv2dhdouoY9Xcce4v2G3UmWt0
	 sL4nLdLJY+0OvEnMDjEs6wRYrqxYbQFZCDUUlzUnkkVpUdZQyUH82ctW7IDlouhpPd
	 zxaMgn2vFf1fBwVqN2rurNJ1zNuftf0AMvJsGsgkvWGOvTH8fFtRqp39+eFXNpb0Ra
	 oH5RQzQZRP1hw==
Date: Wed, 24 Sep 2025 18:59:35 +0530
From: Naveen N Rao <naveen@kernel.org>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, "Daniel P. Berrange" <berrange@redhat.com>, 
	Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH 8/8] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
Message-ID: <swnray4zt34wzfyarg5np4ykfpxnwa6psaoghkis4wxxdi3ybx@mptfzf4633fs>
References: <cover.1758189463.git.naveen@kernel.org>
 <6a9b3e02d1a1eb903bd3e7c9596dfe00029de01e.1758189463.git.naveen@kernel.org>
 <412fce46-e143-4b71-b5ac-24f4f5ae230f@amd.com>
 <4f3f7b7d-f6bf-49de-8c3a-96876e298ad5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f3f7b7d-f6bf-49de-8c3a-96876e298ad5@amd.com>

On Tue, Sep 23, 2025 at 09:48:07AM +0530, Nikunj A. Dadhania wrote:
> 
> 
> On 9/20/2025 3:36 AM, Tom Lendacky wrote:
> > On 9/18/25 05:27, Naveen N Rao (AMD) wrote:

<snip>

> > 
> > And does KVM_SET_TSC_KHZ have to be called if "tsc-frequency" wasn't set?
> No, this is not required. This patch has changed a bit from my original version, we should have something like below: 
> 
> if (is_sev_feature_set(sev_common, SVM_SEV_FEAT_SECURE_TSC) && sev_snp_guest->stsc_khz) {
> ...
> }

Right, I suppose I relied on KVM using the default TSC frequency if the 
VMM does KVM_SET_TSC_KHZ with a TSC frequency of zero, which is totally 
unnecessary. I will update this.


Thanks,
Naveen


