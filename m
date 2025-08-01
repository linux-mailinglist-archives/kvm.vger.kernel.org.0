Return-Path: <kvm+bounces-53843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9AAB1844A
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 16:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 179101C820E8
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 14:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B482C26FA77;
	Fri,  1 Aug 2025 14:56:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3676022D9ED;
	Fri,  1 Aug 2025 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754060205; cv=none; b=UWp15GIkDiV6hABmT0MOkuYZNON/ViYrj0dJMTQu/rrHFIvm/Y8n06/ChKSNVb5cdWoSzyUzyXFDrct6W0xgDK7KJ4b3zNcthS5fev8UvWTofZUgGsM5tVw2b/gA3jUh6ePSyvSb8yphnUej+ACiFv+n7ZNHNC24/Am8Y96r7Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754060205; c=relaxed/simple;
	bh=N8mt0CeZ+jpyRoE3MYFXrL2J5GTr3fT8urbv+hG3NTA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SkjxHO/AjpLHPNamPG5XpD4V8DFJdt8n8WB8r71wFeNFlHzyicXoqCz2+biGEq6PzktGLh0wKVuZOLI2aYBCIWIcBC4LUnWzS5XcT17yt2FkAxjI8h1QsAf4XRZrykFevWrjKMlvwl7X2x8VGotMzAgUCQzhZ1f9uaGgIPgEL8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4btpr56h0Cz23jcP;
	Fri,  1 Aug 2025 22:54:13 +0800 (CST)
Received: from kwepemf200012.china.huawei.com (unknown [7.202.181.238])
	by mail.maildlp.com (Postfix) with ESMTPS id 972C514027A;
	Fri,  1 Aug 2025 22:56:38 +0800 (CST)
Received: from localhost (10.173.124.246) by kwepemf200012.china.huawei.com
 (7.202.181.238) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 22:56:38 +0800
From: Hogan Wang <hogan.wang@huawei.com>
To: <tglx@linutronix.de>, <x86@kernel.org>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <alex.williamson@redhat.com>
CC: <weidong.huang@huawei.com>, <yechuan@huawei.com>, <hogan.wang@huawei.com>,
	<wangxinxin.wang@huawei.com>, <jianjay.zhou@huawei.com>,
	<wangjie88@huawei.com>, <maz@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: Plug vector setup race
Date: Fri, 1 Aug 2025 22:56:33 +0800
Message-ID: <20250801145633.2412-1-hogan.wang@huawei.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <87a54kil52.ffs@tglx>
References: <87a54kil52.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200012.china.huawei.com (7.202.181.238)

> On Thu, Jul 24 2025 at 12:49, Thomas Gleixner wrote:=0D
> =0D
=0D
Thank you very much for your professional, friendly, and detailed response.=
=0D
Based on the clear modification suggestions you provided, I conducted=0D
retesting and validation using the following methods:=0D
=0D
1) Start a virtual machine with 192U384G specification, and configure=0D
   one VirtioNet network card and one VirtioSCSI disk.=0D
2) After the virtual machine starts successfully, execute the following=0D
   script inside the virtual machine. The interrupt number 30 is the=0D
   VirtioNet MSI-x interrupt.=0D
=0D
for((;;))=0D
    do (for((i=3D0;i<192;i++))=0D
	    do echo $i > /proc/irq/30/smp_affinity_list=0D
		sleep 0.1=0D
	done)=0D
done=0D
=0D
After a 7x24-hour test, no error logs of the type "No irq handler for=0D
vector" were found, I believe this issue should have already been=0D
resolved. =0D
=0D
As you said, this fix cannot solve the problem of lost interrupts.=0D
=0D
I believe an effective solution to the issue of lost interrupts=0D
might be to modify the vifo module to avoid un-plug/plug irq,=0D
and instead use a more lightweight method to switch interrupt=0D
modes. Just like:=0D
=0D
vfio_irq_handler()=0D
	if kvm_mode=0D
		vfio_send_eventfd(kvm_irq_fd);=0D
	else=0D
		vfio_send_eventfd(qemu_irq_fd);=0D
=0D
However, this will bring about some troubles:=0D
1) The kvm_mode variable should be protected, leading to performance loss. =
=0D
2) The VFIO interface requires the passing of two eventfds. =0D
3) Add another interface to implement mode switching. =0D
=0D
Do you have a better solution to fix this interrupt loss issue? =0D
	=0D
There is a question that has been troubling me: Why are interrupts=0D
still reported after they have been masked and the interrupt remapping=0D
table entries have been disabled? Is this interrupt cached somewhere?=0D
=0D
> Hogan!=0D
> =0D
> > Hogan reported a vector setup race, which overwrites the interrupt =0D
> > descriptor in the per CPU vector array resulting in a disfunctional dev=
ice.=0D
> >=0D
> > CPU0				CPU1=0D
> > 				interrupt is raised in APIC IRR=0D
> > 				but not handled=0D
> >   free_irq()=0D
> >     per_cpu(vector_irq, CPU1)[vector] =3D VECTOR_SHUTDOWN;=0D
> >=0D
> >   request_irq()			common_interrupt()=0D
> >   				  d =3D this_cpu_read(vector_irq[vector]);=0D
> >=0D
> >     per_cpu(vector_irq, CPU1)[vector] =3D desc;=0D
> >=0D
> >     				  if (d =3D=3D VECTOR_SHUTDOWN)=0D
> > 				    this_cpu_write(vector_irq[vector], VECTOR_UNUSED);=0D
> >=0D
> > free_irq() cannot observe the pending vector in the CPU1 APIC as there =
=0D
> > is no way to query the remote CPUs APIC IRR.=0D
> >=0D
> > This requires that request_irq() uses the same vector/CPU as the one =0D
> > which was freed, but this also can be triggered by a spurious interrupt=
.=0D
> >=0D
> > Prevent this by reevaluating vector_irq under the vector lock, which =0D
> > is held by the interrupt activation code when vector_irq is updated.=0D
> =0D
> Does this fix your problem?=0D
=0D
Thanks,=0D
=0D
		Hogan=0D
-- =0D
2.45.1=0D

