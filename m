Return-Path: <kvm+bounces-69540-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNJiA4ZPe2n9DgIAu9opvQ
	(envelope-from <kvm+bounces-69540-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:16:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3394BAFFC7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 13BF23027977
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E0638884B;
	Thu, 29 Jan 2026 12:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="prWDpijG"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCC5388848
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769688956; cv=none; b=sPtjf5aUBbL4QD+UwQHvVM7+2Ehj8jWkTsvrIGRLeD/hik6iWI4tTy3DnQhMrRiNWzaGa8Yu+qYvYdTSLKOIQYHe4GDM7358RuTH6d9jRBmN3aCRkWc6/4Yz5sKuTOojiY4xiNSsKHd95243Qx42yJK705MUs8lQO0DGCuDoz+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769688956; c=relaxed/simple;
	bh=0IK+DRm/Yda57JCyxXKFwl4KjzuOyT1Kblfcrg+u0bU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vFfCfLj4Y2EjNMBeKdzBglnhuUhAKTTbtgxXJVv47RlJTDiTdZsL2UQ/lD5koXaJQVKiTyNLrFr/sRxkxTkAXb4g0NsBcXLJ/nRQ1pzn+Nmok0Rbzdo50qYRbCHwE/m9T12mRA1Z7RqhDR2fwrYra9XKYFGx5NF601hcSPLJlg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=prWDpijG; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OznORozYizQxwH0YPp/AAs48x/3QH3/xBBmeqZor+bQ=;
	b=prWDpijG40MZmkg1lzmAGJw6xmt4IAKoEXYw3AUU90gjbb0oBm/bMqiWzRbjhgrO13AxqgaKN
	gal8bbTwofUWrwhXvRnZJ0Eh7S4I+oWj6h7757vNn+INwVKhBzTMVX0EqJNiGFFenjRxjbGw0+N
	d8fUrJVvIH2H/VC5BQ0ym0o=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f1yhm551Qz1P7P4;
	Thu, 29 Jan 2026 20:13:12 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f1ykf1dmTzHnGjf;
	Thu, 29 Jan 2026 20:14:50 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id AA4B940569;
	Thu, 29 Jan 2026 20:15:39 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 29 Jan
 2026 12:15:35 +0000
Date: Thu, 29 Jan 2026 12:15:34 +0000
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
Subject: Re: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Message-ID: <20260129121534.00001133@huawei.com>
In-Reply-To: <20260128175919.3828384-11-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	<20260128175919.3828384-11-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69540-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[huawei.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 3394BAFFC7
X-Rspamd-Action: no action

On Wed, 28 Jan 2026 18:01:54 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> As part of booting the system and initialising KVM, create and
> populate a mask of the implemented PPIs. This mask allows future PPI
> operations (such as save/restore or state, or syncing back into the
> shadow state) to only consider PPIs that are actually implemented on
> the host.
> 
> The set of implemented virtual PPIs matches the set of implemented
> physical PPIs for a GICv5 host. Therefore, this mask represents all
> PPIs that could ever by used by a GICv5-based guest on a specific
> host.
> 
> Only architected PPIs are currently supported in KVM with
> GICv5. Moreover, as KVM only supports a subset of all possible PPIS
> (Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
> present. The timers are always assumed to be present; if we have KVM
> we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
> have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
> always assumed to be present.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

