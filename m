Return-Path: <kvm+bounces-5452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 627788220BE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB0BC283ADE
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 18:07:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B43156E5;
	Tue,  2 Jan 2024 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cMJUxUHJ"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0572B156D2;
	Tue,  2 Jan 2024 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=NjAb889JD++8fj8AizE8mZ+IbGGnU/Gx82bIJwsVBMI=; b=cMJUxUHJGIwEVliny7ThN+d3Ic
	Dnpjnq4M21toBawVosS623+9/6L6qm/259WYTPv9nxSCWupEPmA9fitAcCO9mrEidPAA5CQaqFwzC
	P4qWYqgPpsYacPUBcTn06DMI3ZM2O/lskPfCQIH1hW0I9+8n/ykuMV5c5qG2KvVQ4p1YbfvORxYA9
	A+wIPQ8xs4JlNdDL92Xj3ePbBhMPeEwb+ueh+/SOKVHcJxIVZKC0g4pWNrufiXYuMXqw0bYS2vXS2
	rO/R/hhIZneFxE1J17XhErMScyF4OWzZVxNPDqJPuIZHqKM4jucWtc6OUHOvRiAzH80t9K17vjGry
	9p3oY10w==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rKjAg-008fZO-12;
	Tue, 02 Jan 2024 18:07:22 +0000
Message-ID: <44907c6b-c5bd-4e4a-a921-e4d3825539d8@infradead.org>
Date: Tue, 2 Jan 2024 10:07:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: Tree for Jan 2 (riscv & KVM problem)
Content-Language: en-US
To: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 KVM list <kvm@vger.kernel.org>, linux-riscv <linux-riscv@lists.infradead.org>
References: <20240102165725.6d18cc50@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20240102165725.6d18cc50@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/1/24 21:57, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20231222:
> 

It is possible for a riscv randconfig to create a .config file with
CONFIG_KVM enabled but CONFIG_HAVE_KVM is not set.
Is that expected?

CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_KVM_MMIO=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_KVM_GENERIC_HARDWARE_ENABLING=y
CONFIG_KVM_GENERIC_MMU_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m

Should arch/riscv/kvm/Kconfig: "config KVM" select HAVE_KVM
along with the other selects there or should that "config KVM"
depend on HAVE_KVM?


The problem .config file causes build errors because EVENTFD
is not set:

../arch/riscv/kvm/../../../virt/kvm/eventfd.c: In function 'kvm_irqfd_assign':
../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:19: error: implicit declaration of function 'eventfd_ctx_fileget'; did you mean 'eventfd_ctx_fdget'? [-Werror=implicit-function-declaration]
  335 |         eventfd = eventfd_ctx_fileget(f.file);
      |                   ^~~~~~~~~~~~~~~~~~~
      |                   eventfd_ctx_fdget
../arch/riscv/kvm/../../../virt/kvm/eventfd.c:335:17: warning: assignment to 'struct eventfd_ctx *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
  335 |         eventfd = eventfd_ctx_fileget(f.file);
      |                 ^


-- 
#Randy

