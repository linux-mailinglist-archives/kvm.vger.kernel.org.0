Return-Path: <kvm+bounces-37239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D41A2744A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 15:25:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C47E61883AF1
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 14:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9182135BC;
	Tue,  4 Feb 2025 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oakxq0WK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6886020FA81;
	Tue,  4 Feb 2025 14:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738679150; cv=none; b=IBnNJ2uBXQLaylN7S3cADUShk7F20iInaNiVegKO0m0rPRhgsQhpDoY8rPeJYB/IbN5LKzCViT9ypLRIeKk+u3gwtB1ji08MSPo3s5Qxxic82fGJ0mMvh8HDGVVEO08Y7UAQfRTkAlW0fxe5PaLSkn4PMc3xBGFlmIfSD+LwWvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738679150; c=relaxed/simple;
	bh=+qPXk+NnlCCootlZNYkofdAlSOAmqMD4dsKrMXtZuzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cIbdErZl30yCZQfbctSGGFjU4ZQj6B/LHvQOT1wUrybovOHQ9HawuzLvTwwgbmnqaupfDVobF0LkTiBYXLeLqsEGB7vxnw7Wnbr2eiVhHhHtSv7JpH2/cjMltBFdCV7WfU9HUsh7J/AQ0EWpU+8aBZ3g0cf4I+E8+5Td2hQrnzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oakxq0WK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D0C4CEDF;
	Tue,  4 Feb 2025 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738679149;
	bh=+qPXk+NnlCCootlZNYkofdAlSOAmqMD4dsKrMXtZuzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oakxq0WKEFTT2IyLyodyBNYzeSXNvORosZ/aZoodygvXfOnljoaBJ3iki4NifvkYe
	 NmrhpOj2mdQIp/AsicY1/BfRbvvBMQaiwmi4MqCcmjBGQCNEI2K116CeWJqZRCxBsc
	 RTHd04Rh51D/Z2ZkRIrxWXQ12u80hd820UFuaDZ3AxkNJBQDlqPF83K2FLHWoeNNSV
	 8PPD3+ODtyDqVD19mgWP2fkRK/1mCfb8k45PuzooFICaQvkK3smBiE9ATgeupC9Y4D
	 y+ufLe8xY8Un/ySRPwPpNdo1AAzVut7ZEhJipMac3CjUr4sRj9feJ7BLxs6GbcvuWh
	 yu6LIpPc8rIIA==
Date: Tue, 4 Feb 2025 19:55:39 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Remove use of apicv_update_lock when
 toggling guest debug state
Message-ID: <a7eb34n6gkwg6kafh7r76tkwtweuflyfoczgxya2k63al2qdoe@phmszu6ilk4w>
References: <cover.1738595289.git.naveen@kernel.org>
 <dc6cf3403e29c0296926e3bd8f0d4e87b67f4600.1738595289.git.naveen@kernel.org>
 <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30fc469b5b2ec5e2d6703979a0d09ad0a9df29e1.camel@redhat.com>

On Mon, Feb 03, 2025 at 09:00:05PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-02-03 at 22:33 +0530, Naveen N Rao (AMD) wrote:
> > apicv_update_lock is not required when querying the state of guest
> > debug in all the vcpus. Remove usage of the same, and switch to
> > kvm_set_or_clear_apicv_inhibit() helper to simplify the code.
> 
> It might be worth to mention that the reason why the lock is not needed,
> is because kvm_vcpu_ioctl from which this function is called takes 'vcpu->mutex'
> and thus concurrent execution of this function is not really possible.

Looking at this again, that looks to be a vcpu-specific lock, so I guess 
it is possible for multiple vcpus to run this concurrently?

In reality, this looks to be coming in from a vcpu ioctl from userspace, 
so this is probably not being invoked concurrently today.

Regardless, I wonder if moving this to a per-vcpu inhibit might be a 
better way to address this.


Thanks,
Naveen


