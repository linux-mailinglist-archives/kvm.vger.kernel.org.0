Return-Path: <kvm+bounces-55263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7E3B2F18F
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 10:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 030887AFBBC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 08:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681772F90D8;
	Thu, 21 Aug 2025 08:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWwM7F7d"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803452F7466;
	Thu, 21 Aug 2025 08:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764568; cv=none; b=VvZ9bTDc97469EFqF7P7mDBLw6tHCEq5LNwkrkiPfrxSZOidIkAcF5zKaGq3umPvl5UqS8ZMMynYAYgqRjUDsi//qQkRnisGnDFcXTwyGDaUknHTBf6VM5qxccds3rVWhZ7na/LtHwdUxfIFZuOSaUGZQbmcOL0qCU2Kv2aVYzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764568; c=relaxed/simple;
	bh=sCyzuB7YJmmuOyWRTSgUz4eii2awqBJX81AH6BpF6is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VV+PEUAA9HDDCcSn8xpl251JyYmlmxxA6lL/PgdYBRyeGu5g3iGHuxsBlafqA/hCrqKnZrJ8D+e+ruw+6AK/OC7Rvc1aYErsD2IDbA7Z71p0TY3cdiCaDMTQzCVD1ajGYInGOEN58rlJqKSUFtY92HGnVkAp4ZdFdSLreZSvrKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWwM7F7d; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97506C116B1;
	Thu, 21 Aug 2025 08:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755764568;
	bh=sCyzuB7YJmmuOyWRTSgUz4eii2awqBJX81AH6BpF6is=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YWwM7F7dsB6YWLOUYAqlclxsQe6Vsj+jjlM8UftlE6mvaMvaMA1SGq8oqWJqpyntN
	 KgbsWrt5jUQAdUI8K8nEAe3pBFZYlgPbvGJJOF77gyCZpn6Dzsq404uNprJqkKuN0U
	 J6WaV9pq1W4AEwnoQQWMiBqlsiP9yDOTpho5z+jHTK6Kbmq8fen5krkOH5f4PjNrrN
	 fz9JpVcbyv85JCpFV1tmnM99l54Zjy0y0vZlcf2QMqm8MHBOOlB2oGGjpxzf522z8j
	 p+0iW4QrPSdNm0fQprfMoTtEsccXTW2cwchi+3zSsq2JpCbU1uC2NLys+PEOnUwCGw
	 KORXEZi1aKf/A==
Date: Thu, 21 Aug 2025 13:48:07 +0530
From: Naveen N Rao <naveen@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: SVM: Fix missing LAPIC TPR sync into
 VMCB::V_TPR with AVIC on
Message-ID: <zeavh4vqorbuq23664til6hww6yafm4lniu4dm32ii33hyszvq@5byejwk3bom3>
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755609446.git.maciej.szmigiero@oracle.com>

On Tue, Aug 19, 2025 at 03:32:13PM +0200, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> When AVIC is enabled the normal pre-VMRUN LAPIC TPR to VMCB::V_TPR sync in
> sync_lapic_to_cr8() is inhibited so any changed TPR in the LAPIC state would
> *not* get copied into the V_TPR field of VMCB.
> 
> AVIC does sync between these two fields, however it does so only on
> explicit guest writes to one of these fields, not on a bare VMRUN.
> 
> This is especially true when it is the userspace setting LAPIC state via
> KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
> VMCB.

Dumb question: why is the VMM updating TPR? Is this related to live 
migration or such?

I think I do see the problem described here, but when AVIC is 
temporarily inhibited. So, trying to understand if there are other flows 
involving the VMM where TPR could be updated outside of the guest.

> 
> Practice shows that it is the V_TPR that is actually used by the AVIC to
> decide whether to issue pending interrupts to the CPU (not TPR in TASKPRI),
> so any leftover value in V_TPR will cause serious interrupt delivery issues
> in the guest when AVIC is enabled.
> 
> Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
> avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC and
> similar code paths when AVIC is enabled.
> 
> Add also a relevant set of tests to xapic_state_test so hopefully
> we'll be protected against getting such regressions in the future.

Do the new tests reproduce this issue?

> 
> 
> Yes, this breaks real guests when AVIC is enabled.
> Specifically, the one OS that sometimes needs different handling and its
> name begins with letter 'W'.

Indeed, Linux does not use TPR AFAIK.


- Naveen


