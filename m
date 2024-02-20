Return-Path: <kvm+bounces-9185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A250A85BC2A
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:30:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 436011F23464
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 12:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20482692EE;
	Tue, 20 Feb 2024 12:30:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0798D433D0;
	Tue, 20 Feb 2024 12:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708432212; cv=none; b=I35+WfYJ02FQxAN8xFGxfuM9QN8eAPsV4utBto9yzUiazxAeDsis0rI0ZhY3kDtMWs9hbMveZKURxE+lHqULOHW8SB6GPaNX01QTBCTjT9eCa17MM00yXBdjJdwnCse1bFa7IZS1ru482F8Pazjs259rpxc7BuDHM4cN9tq0PGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708432212; c=relaxed/simple;
	bh=Ldn+RYfAL5iEmTzaxh/qozaEEdrntxxBOHPfnWMDxOc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EOIGNsUXhUt0gLPTz8+3ElfxNkLRLCEGjKC5izEo1grVoHAfhUNvdFq6KJ+HE6dr0VO0+C4lGAJvpNXexRS2rnxe64GGQeb49uKGGeQlHk+9uefj2eV2tZZOYGfQ8NuirRthcuKq1DUIc98+yMBofkN9/029jnZzPvVJPlc5/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TfJdX1b7Kz4wxZ;
	Tue, 20 Feb 2024 23:30:08 +1100 (AEDT)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, Amit Machhiwal <amachhiw@linux.ibm.com>
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan Srinivasan <svaidy@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, linux-kernel@vger.kernel.org
In-Reply-To: <20240207054526.3720087-1-amachhiw@linux.ibm.com>
References: <20240207054526.3720087-1-amachhiw@linux.ibm.com>
Subject: Re: [PATCH v4] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to empty 'arch_compat'
Message-Id: <170843210068.1280904.12521172425579669086.b4-ty@ellerman.id.au>
Date: Tue, 20 Feb 2024 23:28:20 +1100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Wed, 07 Feb 2024 11:15:26 +0530, Amit Machhiwal wrote:
> Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
> below error as L1 qemu sends PVR value 'arch_compat' == 0 via
> ppc_set_compat ioctl. This triggers a condition failure in
> kvmppc_set_arch_compat() resulting in an EINVAL.
> 
> qemu-system-ppc64: Unable to set CPU compatibility mode in KVM: Invalid
> argument
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due to empty 'arch_compat'
      https://git.kernel.org/powerpc/c/20c8c4dafe93e82441583e93bd68c0d256d7bed4

cheers

