Return-Path: <kvm+bounces-69542-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEE8CshRe2m3DwIAu9opvQ
	(envelope-from <kvm+bounces-69542-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:25:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB62EB00A7
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 13:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 218E630058C5
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 12:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18FB9381716;
	Thu, 29 Jan 2026 12:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ViHzBtXw"
X-Original-To: kvm@vger.kernel.org
Received: from sinmsgout03.his.huawei.com (sinmsgout03.his.huawei.com [119.8.177.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2A322D7B9
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 12:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769689539; cv=none; b=oIuM15Oiwk+T+unMZj7hZYzPYtyjnzlnVeVQ4cq3h2RaUwOgPET8OyfH00npmorTjEfW0YQxljYgE6kRz14WC8Muo36HiRpP2DmqIfgfm/YYWP7LMeqlB9Ld8zaGSXvZgD4l9kl/O//PG8QpZmE9eQ7T5sk1LHqEtojY/pzg6zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769689539; c=relaxed/simple;
	bh=m8ylvaq8h/DzsNq6ZhbNUFUDMUasrbfqOjyDlNFwl7I=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X27ZGuGcEXMIFxqmQ+RZA+w3n2ZXoLc2E2c+Si9T3JoMn4PqvdErsnvspyJsHjA65Y+vAOwDvB1UmFjVwHLWr6qmpaFTUMK9Mfu3/pamV10qGTyBCqWgW2B9mOduOc8BAjTK9tKHXi1dYji/YOzoL1Ry0+bRnXgZLeK/wHIcvM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ViHzBtXw; arc=none smtp.client-ip=119.8.177.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yO3/auPzmp7ReB1QnPMWLdhH/pZKTIU/CYkFbUdLmUE=;
	b=ViHzBtXwU5EOIYFIkOPA05+owiF//mmrmP1BYmKw0DM1FLVapAJxlTqV9B0DkdISfFagDj95F
	7baaD+YkRydIaaRkvaXUImTJiABrjKe3zRC01Maqm2zoXeIip4yaSPVUwxcULRpLcWwmTU56Qs0
	x1JPdN9kjUzu1P+wSCN32iA=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4f1yvw74DlzN0jj;
	Thu, 29 Jan 2026 20:22:52 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f1yxw0zsDzHnGgq;
	Thu, 29 Jan 2026 20:24:36 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 974D140572;
	Thu, 29 Jan 2026 20:25:25 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 29 Jan
 2026 12:25:24 +0000
Date: Thu, 29 Jan 2026 12:25:23 +0000
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
Subject: Re: [PATCH v4 36/36] KVM: arm64: gic-v5: Communicate
 userspace-driveable PPIs via a UAPI
Message-ID: <20260129122523.00004bfd@huawei.com>
In-Reply-To: <20260128175919.3828384-37-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
	<20260128175919.3828384-37-sascha.bischoff@arm.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_FROM(0.00)[bounces-69542-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:email,huawei.com:email,huawei.com:dkim,huawei.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jonathan.cameron@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: BB62EB00A7
X-Rspamd-Action: no action

On Wed, 28 Jan 2026 18:08:35 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> GICv5 systems will likely not support the full set of PPIs. The
> presence of any virtual PPI is tied to the presence of the physical
> PPI. Therefore, the available PPIs will be limited by the physical
> host. Userspace cannot drive any PPIs that are not implemented.
> 
> Moreover, it is not desirable to expose all PPIs to the guest in the
> first place, even if they are supported in hardware. Some devices,
> such as the arch timer, are implemented in KVM, and hence those PPIs
> shouldn't be driven by userspace, either.
> 
> Provided a new UAPI:
>   KVM_DEV_ARM_VGIC_GRP_CTRL => KVM_DEV_ARM_VGIC_USERPSPACE_PPIs
> 
> This allows userspace to query which PPIs it is able to drive via
> KVM_IRQ_LINE.
> 
> Additionally, introduce a check in kvm_vm_ioctl_irq_line() to reject
> any PPIs not in the userspace mask.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Seems fine to me, but it's new ABI, so needs some careful review from
others.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>



