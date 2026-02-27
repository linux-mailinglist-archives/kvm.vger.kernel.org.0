Return-Path: <kvm+bounces-72157-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFhKJMK0oWmMvgQAu9opvQ
	(envelope-from <kvm+bounces-72157-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:14:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8D01B9833
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 16:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B9DB8303D69A
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 15:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBC441B342;
	Fri, 27 Feb 2026 15:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b="VBFZUizv"
X-Original-To: kvm@vger.kernel.org
Received: from mx-2023-1.gwdg.de (mx-2023-1.gwdg.de [134.76.10.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54A12BD5A7;
	Fri, 27 Feb 2026 15:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205206; cv=none; b=DGljaH8gV4bsZj0UTr4PPE5Gn8B+uexmM6pk2v9SCN6rPFZYxamBKPe28hITzKujXslzMoj3T1gJEb0R/VzCXd7Tr84qMKNwfzx7SBEzJvVnS2hH0XD9iY8MyPjXMIMp2zxGyy5+eroE8SQ14cZ4SGAoFkv06/D0di/WFfT+ZrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205206; c=relaxed/simple;
	bh=U/AYMtm3HcMBARqjsqpovNKCJYz+YkgFM5S2Dw1nT34=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kYUKUyF2zxLRjEtvTfrokw4zARXWT5/EtNjTMmVbfyy1Xbx3y+NUBsKR1TJ11hrJnL15PTWfV/IIVSsnqf4ACQWLRqcf0UDbpXghccqyagExHFqkDiSa9XKmpkItm/MbDFzx/MI+96kt+1OPQiwwJ3ErqLrOVCxe+aR1mAM4OmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de; spf=pass smtp.mailfrom=cispa.de; dkim=pass (2048-bit key) header.d=cispa.de header.i=@cispa.de header.b=VBFZUizv; arc=none smtp.client-ip=134.76.10.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cispa.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cispa.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cispa.de;
	s=2023-rsa; h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:CC:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FWU+AoGX9eH3mCsh3LQUgdVuyGEg7A83/ykl1w+gkCQ=; b=VBFZUizvgZG78Youf4F+MeuRT2
	zri9gJa8VJVZ5M6To8Tru9dkJszT42T+HnSu3Linjj54Cre1zTBIRISI2Y2bBBZzcBR/QsOFFXhxq
	ta5/gvMUNi5XaBlqWdwXys81LGEl8Oq15xR6bbzo73PtB/vmOYhPpEzvtDSHj3E/dCyCXg4Uxjop+
	EBWg04SLhWki8tp+QNbFBzkK7dcpZKPpKVvBo0Oqhd5LaipYyIaq5LE0HzdnTqy17Hd1BQ9M9+lVd
	MMJ7Y72wIevZWLffmLfqJs7PD9o/ZNjE4Ebo4POqVfrCG9pLNOS0pQGM5R8OtCzT8ulNWsHGzN35Y
	jsDMgJfQ==;
Received: from mailer.gwdg.de ([134.76.10.26]:56296)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvzWi-006hGu-0F;
	Fri, 27 Feb 2026 16:13:12 +0100
Received: from mbx19-sub-05.um.gwdg.de ([10.108.142.70] helo=email.gwdg.de)
	by mailer.gwdg.de with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
	(GWDG Mailer)
	(envelope-from <lukas.gerlach@cispa.de>)
	id 1vvzWi-000PaN-2i;
	Fri, 27 Feb 2026 16:13:12 +0100
Received: from localhost.localdomain (10.250.9.200) by MBX19-SUB-05.um.gwdg.de
 (10.108.142.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.37; Fri, 27 Feb
 2026 16:13:10 +0100
From: Lukas Gerlach <lukas.gerlach@cispa.de>
To: <radim.krcmar@oss.qualcomm.com>
CC: <ajones@ventanamicro.com>, <alex@ghiti.fr>, <anup@brainfault.org>,
	<aou@eecs.berkeley.edu>, <atish.patra@linux.dev>, <daniel.weber@cispa.de>,
	<jo.vanbulck@kuleuven.be>, <kvm-riscv@lists.infradead.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <lukas.gerlach@cispa.de>,
	<marton.bognar@kuleuven.be>, <michael.schwarz@cispa.de>,
	<palmer@dabbelt.com>, <pjw@kernel.org>
Subject: Re: [PATCH 4/4] KVM: riscv: Fix Spectre-v1 in PMU counter access
Date: Fri, 27 Feb 2026 16:12:47 +0100
Message-ID: <20260227151247.18602-1-lukas.gerlach@cispa.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <DGPS39X0VRTU.3ATPEH33LUF1G@oss.qualcomm.com>
References: <DGPS39X0VRTU.3ATPEH33LUF1G@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MBX19-FMZ-06.um.gwdg.de (10.108.142.65) To
 MBX19-SUB-05.um.gwdg.de (10.108.142.70)
X-Virus-Scanned: (clean) by clamav
X-Spam-Level: -
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_REJECT(1.00)[cispa.de:s=2023-rsa];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[cispa.de : SPF not aligned (relaxed),none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72157-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lukas.gerlach@cispa.de,kvm@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.995];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[cispa.de:-];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	DBL_BLOCKED_OPENRESOLVER(0.00)[cispa.de:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E8D01B9833
X-Rspamd-Action: no action

Thanks for the review!

> This one also covers a non-speculation bug, since the previous condition
> used cidx > RISCV_KVM_MAX_COUNTER. :)  I'll send a patch for that.

Nice catch, thanks for sending the fix.

> I noticed a few other places where mis-speculation is possible,
> see below; can you explain why they don't need protection?

They do, I missed those. Will send a v2 incorporating all four sites.

Thanks,
Lukas

