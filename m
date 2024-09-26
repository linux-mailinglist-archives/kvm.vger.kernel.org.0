Return-Path: <kvm+bounces-27546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F61E986D82
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 09:25:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DABBEB24D74
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 07:25:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F3418E04C;
	Thu, 26 Sep 2024 07:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="K/mwP0jE"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C10188CB8
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 07:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727335542; cv=none; b=h0g0cft3q3t+2X5FpFyInHDCE0kzXPI9hiwrzsZpSg/BL7PEImq1NJVc3IwO0ZbY8jnRVcifK2XRwp3V0CQ8SBB/X2e6Ldaaf7+PCf23slPbfJdKNIBdPxC4FNlasMsudP2wQZyPhtE4nF+i50Rj5rsLUbfX97Xt+J4gk2brdAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727335542; c=relaxed/simple;
	bh=LKz2BWYlC1wcCer0rqsExIwaiuKqjGdcgjs7mcfIdhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4puzyzkcYn+V2i368OqPZ/XmkBX0NL5vAjbF4IZ2kedQpiUmtd65QrhI/vlNIfP8kaRoE7osVn7CdhYQ+IpiTWjogspSfyFdhuzfPrgM86F/He3s0KyIVbAak/hnXFMfiVDrCVGZl1bFcJLg4OoxDRSKy7qyHb49dkzI1X5BSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=K/mwP0jE; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 26 Sep 2024 09:25:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727335538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t68Dgt6yWbqsMukshTyhqyh1jY4+yGJXlpezi6ogjkA=;
	b=K/mwP0jEZ9zsREYyIkWCF/42FhlrEamH5wF/IFzcqHKsIW6MJBvoRP1V/k3VcPfu1BkbM0
	K76Z+dAiueYbH4gfnlB1BthHvEPE9kAY9shbmhT/pgCObYpbXzOA3pYgNidL+fAEuOPv8h
	Y6x6Zt2+CImb7+xufZgCmHxz9WNfmk8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Eric Auger <eauger@redhat.com>, Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/2] KVM: arm64: Allow the RAS feature bit in
 ID_AA64PFR0_EL1 writable from userspace
Message-ID: <ZvUMZFdY_j3pUisX@linux.dev>
References: <20240926032244.3666579-1-shahuang@redhat.com>
 <20240926032244.3666579-3-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240926032244.3666579-3-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 25, 2024 at 11:22:40PM -0400, Shaoqin Huang wrote:
> Currently FEAT_RAS is not writable, this makes migration fail between
> systems where this feature differ. Allow the FEAT_RAS writable in
> ID_AA64PFR0_EL1 to let the migration possible when the RAS is differ
> between two machines.
> 
> Also update the kselftest to test the RAS field.

Please do kernel + selftests changes in separate patches.

-- 
Thanks,
Oliver

