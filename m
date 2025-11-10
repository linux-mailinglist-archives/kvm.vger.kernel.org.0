Return-Path: <kvm+bounces-62528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BA49C48024
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77FD84EFBC8
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D598526E6F7;
	Mon, 10 Nov 2025 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b="b8p91nzC"
X-Original-To: kvm@vger.kernel.org
Received: from pku.edu.cn (mx17.pku.edu.cn [162.105.129.180])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A8B283FC5;
	Mon, 10 Nov 2025 16:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.105.129.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762792326; cv=none; b=sgVpCYj4LjiLhkOiJAHG6AFaLdWOUTMLd5nJ8MqnL8qoG2f5zUJBvZ35ilDP3bUj8lRtiF3FfCwTfPWLdxp5yTDYdKbwha0k7juyPZVXV5K/SO4NEFTdpXPNziuM9ydVcrOj/tiG1TapWJRJIMwM7MCMcAXUH5OhvxFzCggCOFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762792326; c=relaxed/simple;
	bh=lWnh50PqXFlhEyYamQgKHdaiBHiW776Trd3dcosjSkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPn9EOzmItpXKkMH9qgER/kLmDGVGBMFggDgdOXToNOiH40AOdK93Sqzc0w3t5Yq4h+QE6zdaCBATXlvZU96ROzlOwL9sWHYT4QOI2uqZ4QI9iteQsTOldmA8Y6mCcXEsQM7QbqFFnH7Ht7Pg0xpJLXYqukffFoDkSEtPXfyyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn; spf=pass smtp.mailfrom=pku.edu.cn; dkim=pass (1024-bit key) header.d=pku.edu.cn header.i=@pku.edu.cn header.b=b8p91nzC; arc=none smtp.client-ip=162.105.129.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pku.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pku.edu.cn
Received: from pku.edu.cn (unknown [10.7.30.65])
	by mtasvr (Coremail) with SMTP id _____7Dw3ffTEhJpxbJpAA--.8884S3;
	Tue, 11 Nov 2025 00:29:08 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=pku.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
	Message-ID:In-Reply-To:References:MIME-Version:
	Content-Transfer-Encoding; bh=lWnh50PqXFlhEyYamQgKHdaiBHiW776Trd
	3dcosjSkk=; b=b8p91nzCG3p4hzFVKiUE83PkgtplVDh7ZnXpvZe5lOYUXOPTE1
	lFJyU36dWjwcff70RxLDrxMJb2KKGXJpzTosTtSs5dE/ezx8uMFGf9rVLA4Bc5BS
	gfLxgGV2RrZnxQPanaS9yMG6ILOAYxdjOizx45AkL+z3QVjal7itTm1oU=
Received: from localhost (unknown [10.7.30.65])
	by front02 (Coremail) with SMTP id 54FpogAX75_MEhJpACBcAQ--.55300S2;
	Tue, 11 Nov 2025 00:29:06 +0800 (CST)
From: Ruihan Li <lrh2000@pku.edu.cn>
To: lei4.wang@intel.com,
	seanjc@google.com
Cc: chenyi.qiang@intel.com,
	jmattson@google.com,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	wanpengli@tencent.com,
	lrh2000@pku.edu.cn
Subject: The current status of PKS virtualization
Date: Tue, 11 Nov 2025 00:29:00 +0800
Message-ID: <20251110162900.354698-1-lrh2000@pku.edu.cn>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20220424101557.134102-1-lei4.wang@intel.com>
References: <20220424101557.134102-1-lei4.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:54FpogAX75_MEhJpACBcAQ--.55300S2
X-CM-SenderInfo: yssqiiarrvmko6sn3hxhgxhubq/1tbiAgEKBWkA6EEIawAVs6
X-CM-DELIVERINFO: =?B?tXD+XaaAH6dYjNjDbLdWX9VB7ttaQFyXTaecYZzOeDisy/krtsX5TsLkpeAzENeCPc
	0+BGeASIntztwfi8J9JaFaT+fUWlM1Q81OmB0KK6btj5wZoSkrq2Heyi0QCXGKu0hj48+j
	23Jtl6qgUJCOGAQPyNgfi+csIjBNqYdlQrlji/7QokZ4Tw/NMmyYtGmpLVVuSQ==
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Hi,

I'm sorry to bother you by replying to the email from years ago. I would like
to learn about the current status of PKS virtualization.

In short, I tried to rebase this patch series on the latest kernel. The result
was a working kernel that supports PKS virtualization, which would be useful
for my purposes. Would PKS virtualization be accepted even if the kernel itself
does not use PKS?

Here's a longer explanation: I noticed that this patch series is built on top
of basic PKS support. Meanwhile, it appears that the basic PKS support "was
dropped after the main use case was rejected (pmem stray write protection)"
[1]. I suppose that's why this patch series won't be merged into the kernel?

 [1]: https://lore.kernel.org/lkml/3b3c941f1fb69d67706457a30cecc96bfde57353.camel@intel.com/

For my purposes, I don't need the Linux kernel to use PKS. I do want the kernel
to support PKS virtualization so that I can run another OS that requires PKS
support with the help of KVM. Fundamentally, I don't think this patch series
has to be built on top of basic PKS support. But I am unsure whether there is a
policy or convention that states virtualization support can only be added after
basic support.

One problem is that if the Linux kernel does not use PKS, we will be unable to
test PKS virtualization with a guest Linux kernel. However, given that we have
KVM unit test infrastructure, I believe we can find a way to properly test PKS
virtualization for its correctness?

I'd like to hear from you to know whether I understand things correctly. Thank
you in advance for any feedback.

Thanks,
Ruihan Li


