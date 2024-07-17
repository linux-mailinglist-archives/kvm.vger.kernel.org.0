Return-Path: <kvm+bounces-21770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AFA2933864
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 09:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB8B71F22409
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 07:58:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE881CF8A;
	Wed, 17 Jul 2024 07:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UUBC5Ibc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A98922EED
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 07:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721203098; cv=none; b=tvKuKWTWxfdf0UagdpXGLJS9jd2rz/ulbxfexJYlm0BkKo15gTE3Ch99d9dKH4rQO2oUsZvE73y3OEBJtFYmFzg0FTlYZr1qQY3/kf19H/iappKVMZT2+nclwK5oZRDRQR2QEnoRsEUcWLFG5TSeB95LzpzXMquyTQ4KkryMzHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721203098; c=relaxed/simple;
	bh=T7qlJrjpyFDXPBgKHa75RQTSAiHjtJwCfj1dr3Dk1hc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d487oxTeQH4d63umzscX/pKibZBiRfaPEmCk7FMG4+v1qlsgh1Y4IriuajEVHWqpOK3X6P7mlFplS2wlgxd9TX+lGLjTN38IHiKuSlEnqeza/Ji1Ev+ICwdWieIq8WDFTUa5U3ju9JCpjuLqurW5w5jQlMv49pofkce7XNAE/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UUBC5Ibc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721203095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iCkJlmWrSesCrwKH6u57qUR/KXqhyEQ84J0GnoDPXlE=;
	b=UUBC5IbcpnmzncZePRUw86C9ws2qWlJPn878SP0n7UhDOA/Rsk2iI7moQE+pyNi9Dq5wFp
	cCdafAMiBHVwiP7yT7XJr2NYDVwlmncdauSdfag4EMVws+GQCu/tAIgx26IeJIWfUpU6xW
	7aXKu9Sccz/fLRX4+jNjivtD4KPF6a4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-B9g7kWrlObaMTxEaCDaqBA-1; Wed,
 17 Jul 2024 03:58:09 -0400
X-MC-Unique: B9g7kWrlObaMTxEaCDaqBA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C17A81955D48;
	Wed, 17 Jul 2024 07:58:07 +0000 (UTC)
Received: from localhost (dhcp-192-176.str.redhat.com [10.33.192.176])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A1D31955F40;
	Wed, 17 Jul 2024 07:58:06 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Xianglai Li <lixianglai@loongson.cn>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Jiaxun Yang
 <jiaxun.yang@flygoat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 kvm@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>
Subject: Re: [RFC 0/4]  Added Interrupt controller emulation for loongarch kvm
In-Reply-To: <cover.1721186636.git.lixianglai@loongson.cn>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <cover.1721186636.git.lixianglai@loongson.cn>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 17 Jul 2024 09:58:03 +0200
Message-ID: <87r0bsa1ro.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Jul 17 2024, Xianglai Li <lixianglai@loongson.cn> wrote:

> Before this, the interrupt controller simulation has been completed
> in the user mode program. In order to reduce the loss caused by frequent
> switching of the virtual machine monitor from kernel mode to user mode
> when the guest accesses the interrupt controller, we add the interrupt
> controller simulation in kvm.
>
> In qemu side implementation is simple, just make a new IPI EXTIOI PCH KVM
> related several classes, And the interface to access kvm related data is
> implemented.
>
> Most of the simulation work of the interrupt controller is done in kvm.
> Because KVM the changes have not been the Linux community acceptance,
> the patches of this series will have RFC label until KVM patch into the community.
>
> For the implementation of kvm simulation, refer to the following documents.
>
> IPI simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/inter-processor-interrupts-and-communication
>
> EXTIOI simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/tree/main/docs/Loongson-3A5000-usermanual-EN/io-interrupts/extended-io-interrupts
>
> PCH-PIC simulation implementation reference:
> https://github.com/loongson/LoongArch-Documentation/blob/main/docs/Loongson-7A1000-usermanual-EN/interrupt-controller.adoc
>
> For PCH-MSI, we used irqfd mechanism to send the interrupt signal
> generated by user state to kernel state and then to EXTIOI without
> maintaining PCH-MSI state in kernel state.
>
> You can easily get the code from the link below:
> the kernel:
> https://github.com/lixianglai/linux
> the branch is: interrupt
>
> the qemu:
> https://github.com/lixianglai/qemu
> the branch is: interrupt
>
> Please note that the code above is regularly updated based on community
> reviews.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com> 
> Cc: Song Gao <gaosong@loongson.cn> 
> Cc: Huacai Chen <chenhuacai@kernel.org> 
> Cc: Jiaxun Yang <jiaxun.yang@flygoat.com> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com> 
> Cc: Cornelia Huck <cohuck@redhat.com> 
> Cc: kvm@vger.kernel.org 
> Cc: Bibo Mao <maobibo@loongson.cn> 
>
> Xianglai Li (4):
>   hw/loongarch: Add KVM IPI device support
>   hw/loongarch: Add KVM extioi device support
>   hw/loongarch: Add KVM pch pic device support
>   hw/loongarch: Add KVM pch msi device support
>
>  hw/intc/Kconfig                     |  12 ++
>  hw/intc/loongarch_extioi_kvm.c      | 141 +++++++++++++++++++
>  hw/intc/loongarch_ipi_kvm.c         | 207 ++++++++++++++++++++++++++++
>  hw/intc/loongarch_pch_msi.c         |  42 ++++--
>  hw/intc/loongarch_pch_pic.c         |  20 ++-
>  hw/intc/loongarch_pch_pic_kvm.c     | 189 +++++++++++++++++++++++++
>  hw/intc/meson.build                 |   3 +
>  hw/loongarch/virt.c                 | 141 ++++++++++++-------
>  include/hw/intc/loongarch_extioi.h  |  34 ++++-
>  include/hw/intc/loongarch_pch_msi.h |   2 +-
>  include/hw/intc/loongarch_pch_pic.h |  51 ++++++-
>  include/hw/intc/loongson_ipi.h      |  22 +++
>  include/hw/loongarch/virt.h         |  15 ++
>  linux-headers/asm-loongarch/kvm.h   |   7 +
>  linux-headers/linux/kvm.h           |   6 +

Please split out any headers changes into a separate patch -- just put
them into a placeholder patch at the beginning of the series as long as
the changes are not yet upstream (and replace that with a full headers
sync later.)

>  15 files changed, 823 insertions(+), 69 deletions(-)
>  create mode 100644 hw/intc/loongarch_extioi_kvm.c
>  create mode 100644 hw/intc/loongarch_ipi_kvm.c
>  create mode 100644 hw/intc/loongarch_pch_pic_kvm.c


