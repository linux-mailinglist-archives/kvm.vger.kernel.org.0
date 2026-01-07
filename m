Return-Path: <kvm+bounces-67241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC1CCFF4D1
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 19:09:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00E7735A9812
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 17:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87186352FBB;
	Wed,  7 Jan 2026 16:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="VhN3APYA"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F7318BAF
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767802361; cv=none; b=d5UPVgPP92KtDm11oq/zkJclPKj9r7Hj0+OZmQ8oSrJM+8ft0Zq81sbQrfr3rnnRX27v0EObujN4uWSJ2Bu87yMPPOgDOmwCfpmqRq5tEf1Y7Wrhi3DwyLKQe522ALBmEJMGg0Lz+y46FkdeIvbh6mElVTU/spAytz5xQMP5BCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767802361; c=relaxed/simple;
	bh=08V3A1CUeNqrrsFDdlmhFiwRCXZgzw8XqV+zmq8IxC4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVkFLuaoDJOZLhIs6siOVwj5Gi1CIiBwBuEy1WQ0GwgBPG8XpJkCCjXwhAGmiZIMKYYlkfppg377iQbHjvgHr9C832XXAVMEPh7b8DKgrIn01jcsDx/xswskSFH94qhobTnvw98kdFDTfZiKZ9GTZbL8LlmhzidlN8iSIkMx9lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=VhN3APYA; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IfbhaZoobr3IKngcO11YDj7yW5shTZnJBe+jJ+BAfBo=;
	b=VhN3APYA8fOCtP255sVosi977cSkdzO8mKn3UVava9UwUOCUQTUaWdc7l5arsUs75em7L6fcJ
	/o7+P8CMCTahY56adRa26mRANolSi3mndLa9phf1cczgZmK0kbnbHJGSYjv/cLQ2lI1LDjP+1qQ
	UJS2/BlbKoHzgPV9FYyqcpU=
Received: from frasgout.his.huawei.com (unknown [172.18.146.33])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dmY0B1pwTz1P6mx;
	Thu,  8 Jan 2026 00:10:02 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dmY2s5wLjzJ4683;
	Thu,  8 Jan 2026 00:12:21 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 454BB4056B;
	Thu,  8 Jan 2026 00:12:25 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 7 Jan
 2026 16:12:24 +0000
Date: Wed, 7 Jan 2026 16:12:23 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v2 28/36] KVM: arm64: gic: Hide GICv5 for protected
 guests
Message-ID: <20260107161223.0000307f@huawei.com>
In-Reply-To: <20251219155222.1383109-29-sascha.bischoff@arm.com>
References: <20251219155222.1383109-1-sascha.bischoff@arm.com>
	<20251219155222.1383109-29-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 15:52:45 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> We don't support running protected guest with GICv5 at the
> moment. Therefore, be sure that we don't expose it to the guest at all

Tidy up line wrap to 75 ish chars.

> by actively hiding it when running a protected guest.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Seems fine to me, but I know almost nothing about protected guests, so no tag.


