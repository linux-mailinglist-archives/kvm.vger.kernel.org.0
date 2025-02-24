Return-Path: <kvm+bounces-38976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CEBDDA4166E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:41:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 712A07A37F4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 07:40:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD1F18FDDB;
	Mon, 24 Feb 2025 07:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bC9f76Xy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B91A1BC3C;
	Mon, 24 Feb 2025 07:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740382889; cv=none; b=BpzfKU+WDmyTF/qpwWepWkANwABH7y2iB/kJ+7pkGNvzacex+O/qr0DGVDE832so0k8H6WGCMcZmuZz4fOtwi18EvZ5RFkrt+k78fwJtWZP2BkllS2y4WTvfRPF9z5O8t55rgy+EUv3TtWl3WghoBLClKd9I76+zQQ2b4cMGb9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740382889; c=relaxed/simple;
	bh=z0db1DqZHwFj5ZNDEVx51VsoNu+zSAQurtKCoSQL2aM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=X7biz3R3ctli+zos7ADi1xkf6GjwdrWwtAsKDc4IhVjabCyNfZkKuLFqOVy0UFJ1el9UkWZfQp9oOx7ScOp0orZ285mpT5saPF+9VqFgYjOD3kNk2JL9KQEZ1p6P0wtw08WMA/dTtxneh/ViUyIxUng8JIBJQftNYZIEp0V6SnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bC9f76Xy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE82C4CED6;
	Mon, 24 Feb 2025 07:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740382888;
	bh=z0db1DqZHwFj5ZNDEVx51VsoNu+zSAQurtKCoSQL2aM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bC9f76XynJZMxxSRIRacLKFFjzO6G7gkKSz+9tKa4ks7eByxWJIV+DSvxVsmdyNd9
	 g7SpQg6+8/fwhq8MiE1g/Q0/5o8LlGJSfrWZSRjQmecErteiAuVJaN58MktOOKJvgK
	 UVihfCL3nZsUrW59ZrWf7PmH8gyuaP8hxeFiL91yd44C81QjZzGPLqauwZeUEtED47
	 n3cOsK9j1z5d43+iL0yEgXzliqmdnw3BuXhcEEQQrYFkca801SOkwzxx8ycMBIBHKQ
	 qC3RyHhH6t6VymLzE6YKtXglF3sLfTLsknzm1aSBnSxISnjgRB3oyAtla2CdrMX2IM
	 cb7XG/Ipp4GbA==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 01/14] arm64: cpufeature: Handle NV_frac as a synonym of
 NV2
In-Reply-To: <20250215173816.3767330-2-maz@kernel.org>
References: <20250215173816.3767330-1-maz@kernel.org>
 <20250215173816.3767330-2-maz@kernel.org>
Date: Mon, 24 Feb 2025 13:11:18 +0530
Message-ID: <yq5a7c5fhjs1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Marc Zyngier <maz@kernel.org> writes:

> With ARMv9.5, an implementation supporting Nested Virtualization
> is allowed to only support NV2, and to avoid supporting the old
> (and useless) ARMv8.3 variant.
>
> This is indicated by ID_AA64MMFR2_EL1.NV being 0 (as if NV wasn't
> implemented) and ID_AA64MMDR4_EL1.NV_frac being 1 (indicating that
                            ^ F
The register name is wrong there.

> NV2 is actually supported).
>

-aneesh

