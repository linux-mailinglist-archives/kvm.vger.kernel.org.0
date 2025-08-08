Return-Path: <kvm+bounces-54332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 87FA0B1EE0D
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 19:52:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3918B4E34C4
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 17:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AE220126A;
	Fri,  8 Aug 2025 17:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QUPj2JWM"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FD81EFF93
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754675519; cv=none; b=XAiBnVbVSqaSitSRnqbFghKra6ntILu9mYJd9A7bPOwVjxx7x6Env2OSsWsVNxWCmoEerI7gvh0TQwVlLvFEUYKTKccVgmldhw31NZ8tNGzT32H6L9RYmjiiF2W+n3QVmKyK+Cnr3xZCqISrD1MgMnCN4yZraZgIgBC+C94d/is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754675519; c=relaxed/simple;
	bh=rXKQRSRtO2OF7fEKPeUeS/+MTrBKQjbFjfTHZEmkDeo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=epg2RhjUcUM9biJltGwh9tJrDOmYbllLHzwSxMhbjRfqPFH40ZTtdWkDgcRPQrS7u07rOgIHyVY81aLJeoAXDCBQsPxLWUH3CsoptCWbvRub0+phhM2808hD3pfBjh7KvOE3B1eBcU6tbFIRo6SfYstFOoc7eAbfhAjmcjGc54o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QUPj2JWM; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754675515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3aJycHRGyL1a+2uBavRRBDprR05fm5AmwSm2JSYILI=;
	b=QUPj2JWM7vjVN5vuRP59WuDjApuBKY+rlVf6six6X8M6RVR0evhG503jgPq21MN9LaAnzu
	ZqqesYURlyVxbjOwNmsVxQ7IdDS6XLqt4Eq8vtbzOf/QOWFdxeZs0z4cWb5/HFSMMez/9/
	EMi+hsTaYMpq+bx+IT+1qbhpTib9xOk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	ajones@ventanamicro.com,
	Sebastian Ott <sebott@redhat.com>
Subject: Re: [PATCH v2] KVM: arm64: selftest: Add standalone test checking for KVM's own UUID
Date: Fri,  8 Aug 2025 10:51:34 -0700
Message-Id: <175467548067.670500.2669324809464970988.b4-ty@linux.dev>
In-Reply-To: <20250806171341.1521210-1-maz@kernel.org>
References: <20250806171341.1521210-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 06 Aug 2025 18:13:41 +0100, Marc Zyngier wrote:
> Tinkering with UUIDs is a perilious task, and the KVM UUID gets
> broken at times. In order to spot this early enough, add a selftest
> that will shout if the expected value isn't found.
> 
> 

Applied to fixes, thanks!

[1/1] KVM: arm64: selftest: Add standalone test checking for KVM's own UUID
      https://git.kernel.org/kvmarm/kvmarm/c/85acc29f90e0

--
Best,
Oliver

