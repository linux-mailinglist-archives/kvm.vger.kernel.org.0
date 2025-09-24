Return-Path: <kvm+bounces-58635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 504FFB9A074
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D47A189A82E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF69A30214B;
	Wed, 24 Sep 2025 13:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjWR1tWs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40FE2D97AA
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758720477; cv=none; b=GkdaV8FFQoWOh86g115N2VVuVtzpj8uP98jCKMOy27/ceGBD7gcJ/n9HfirLFkRzfziWxMvJF1BY5WA/fT/MgtmSyw9IYJFSyAphDSToBSQ8QBXe4sZVYN0F4e4NUF0by2sHh0ooTr0pHAhXfqFyrCqLsmXufFitEQIJH6bg5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758720477; c=relaxed/simple;
	bh=LkJeLqstneWF3zjIGHB5Imu+sWVXbsZul/NeRhwn7g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2awEMYTIqU2mCqLz6cOOwbOfqw9sQtpEL+l2G5gIC5eWS8k6uJnRl+sMSPoHITRpuVmHX78MjXuX1UFvAEDrq95t6lbuQwcLrJgozWc8JHyu7qI0iVaMKt/TncI0OcuiXaUBBK19meuelJ9i0s6jKB0cuYKLKpC9Hl7P04kQyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjWR1tWs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E320CC4CEE7;
	Wed, 24 Sep 2025 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758720477;
	bh=LkJeLqstneWF3zjIGHB5Imu+sWVXbsZul/NeRhwn7g8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RjWR1tWsnUZgvTWg9+jtByQYaQ922o5mWRroIPs1rpGaxZJWv/9KSHP6ViI4Spa28
	 BCy3cFqdKvoZv/yJrkGeXl59kCsXvrESS3iyBCXkCagXjAE7BZtErUzhbRfXN0Jvoo
	 kc7yqDTkCF1ImiCJtvvRwKturn3b6UhAm5UIxjg3rdN57bJ9Q+YGxUWQsRCXXYNUKI
	 fxaRHviFKsFCPsKJXp5Pn1qCjOTx62Tz7kzJnChtObBBSq310zKBiCFdEAYJjf37Dw
	 j76KU9B6/0bw0zU/zayC2AColABCte5zlTtC6hg9OcNc1cNi8ZGHiERVkfixwsy71w
	 51EffP0VdfszA==
Date: Wed, 24 Sep 2025 18:52:37 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org, Nikunj A Dadhania <nikunj@amd.com>, 
	"Daniel P. Berrange" <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, 
	Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: Re: [PATCH 6/8] target/i386: SEV: Enable use of KVM_SEV_INIT2 for
 SEV-ES guests
Message-ID: <h5b6iurfiluiraavdi7ujcawh67f3qpsyh2qxnlmehamawzma3@p5zqx722khe7>
References: <cover.1758189463.git.naveen@kernel.org>
 <4d14083f34e3196a1ef179a958e30e800b5263fe.1758189463.git.naveen@kernel.org>
 <f97f66c5-d6f8-4a6e-91f1-4d3dac3c0816@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f97f66c5-d6f8-4a6e-91f1-4d3dac3c0816@amd.com>

On Fri, Sep 19, 2025 at 04:44:34PM -0500, Tom Lendacky wrote:
> On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> > Now that users can enable VMSA SEV features, update sev_init2_required()
> > to return true if any SEV features are requested. This enables qemu to
> > use KVM_SEV_INIT2 for SEV-ES guests when necessary.
> > 
> > Sample command-line:
> >   -machine q35,confidential-guest-support=sev0 \
> >   -object sev-guest,id=sev0,policy=0x5,cbitpos=51,reduced-phys-bits=1,debug-swap=on
> > 
> 
> Should this patch go before patch #5 from a bisect point of view? Because
> won't patch #5 fail because you still aren't using init2?

I put this patch after the base debug-swap support since it is not 
possible to exercize this code otherwise. But, as you rightly point out, 
this just means that patch 5/8 is buggy and that is not good from a 
bisect standpoint. I will move this before patch 5/8.

> 
> > Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> > Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks for the review,
- Naveen


