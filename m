Return-Path: <kvm+bounces-64499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 507FFC855BB
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 15:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8664434E655
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 14:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E5632572B;
	Tue, 25 Nov 2025 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="xvJzENOU"
X-Original-To: kvm@vger.kernel.org
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020AA31BC84;
	Tue, 25 Nov 2025 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764080310; cv=none; b=YhX59T5ZFhP4MMJDXDs7gi6boz6FMIIP8Q8/OhdsmuaAAtJvriYLj+QJOnivA9un6B2mBh/maAUtJAUJoY+stx1F74Y4E3ns+y8x6z28XXzJagF5vSrOWN/6roX1cBlJLwdeA/AIGW5nl9xL1cMYlMtIGKAGRODyAn8Se0NMp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764080310; c=relaxed/simple;
	bh=/nLaQgrfgV1fF/s4cxpU8v6u4Dcf3qSsNdZfhEYMj+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDpi7G9lntK9JvSnlU/gSoYBvH70qRJD96UitqkY9u1qqWvhkuHhEkV23abWw8AwXF6qnpNuYpwC/vxTFDcuoXFK/MjzPV7CFGIfvl1yQFMf5VW9tQj/S9kSxUsouArvH1YwymugpKsjio/+ziX428MugNSGNyMF1sljSfRJ9Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=xvJzENOU; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764080298; h=From:To:Subject:Date:Message-Id:MIME-Version:Content-Type;
	bh=/nLaQgrfgV1fF/s4cxpU8v6u4Dcf3qSsNdZfhEYMj+8=;
	b=xvJzENOUMCjeqbuIA+vD6EVDlopmFSv9XWFGHdCIueSQcCyH/GDKQxI0xlWqoXQZAsI1gAGWeUL/jvZpAtaB2S9mGiwAn2TFSgbZaZ8eydZQSY5aRduBk91OovE8NIUB0qOkSoPQ8ql2FU9HubJHw8lXI3UMHogG0ggERlh4huk=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WtOKGV7_1764080296 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 25 Nov 2025 22:18:17 +0800
From: fangyu.yu@linux.alibaba.com
To: ajones@ventanamicro.com
Cc: alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pjw@kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
Date: Tue, 25 Nov 2025 22:18:11 +0800
Message-Id: <20251125141811.39964-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20251124-4ecf1b6b91b8f0688b762698@orel>
References: <20251124-4ecf1b6b91b8f0688b762698@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

>> On Sat, Nov 22, 2025 at 3:50 PM <fangyu.yu@linux.alibaba.com> wrote:
>> >
>> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> >
>> > Currently, HGATP mode uses the maximum value detected by the hardware
>> > but often such a wide GPA is unnecessary, just as a host sometimes
>> > doesn't need sv57.
>> > It's likely that no additional parameters (like no5lvl and no4lvl) are
>> > needed, aligning HGATP mode to SATP mode should meet the requirements
>> > of most scenarios.
>> Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP is
>> reasonable.
>
>The documentation should be improved, but I don't think we want to state
>that these parameters apply to both s- and g-stage. If we need parameters
>to dictate KVM behavior (g-stage management), then we should add KVM
>module parameters.

Right, adding new parameters for g-stage management is clear.

Or we could discuss this topic, from a virtual machine perspective,
it may not be necessary to provide all hardware configuration
combinations. For example, when SATP is configured as sv48,
configuring HGATP as sv57*4 is not very meaningful, Because the
VM cannot actually use more than 48 bits of GPA range.

Thanks,
Fangyu
>Thanks,
>drew



