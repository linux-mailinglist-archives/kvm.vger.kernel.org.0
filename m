Return-Path: <kvm+bounces-22330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE7DE93D735
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79E9528467C
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 16:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C7217C7D3;
	Fri, 26 Jul 2024 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="UcE/YCsU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E130521364;
	Fri, 26 Jul 2024 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722012627; cv=none; b=QaZA1Q+sXcHiIkjETmu1PFtTD0AREsRA8x1lh5bmQcZvHvD7V4z3okxcRoU42oUClB/4FzkOtMlYV/12ZEWMdr9MSoMp8XyUTJi7oqpY6yx+9Fc0558wtZS4e5Sd5GqarLqtUy2pgmf8yAEBxoZkf5U1pyS1W+zue/C4Al/NCEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722012627; c=relaxed/simple;
	bh=rqbgT/0iYp0SyvwyUNh8ElGIQ4w4+Dw0nQzyKcM25qM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SnOTxeirQujVoSg07E4jCHEjUzPwYknywmH3FrAGTCWBxaZM3hRq+ghL7qSeSYwh73H+D2v+07unSvRKIkIvAYH9ebRq7/6dUBiFdltEaEThl6JRLqc7rbO/u31OpeGeg1bVynky3KNlkzCoY/GEau8b6ck4T4WBGksSTQVu3ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=UcE/YCsU; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1722012626; x=1753548626;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=LunzKZL6emWKetW1H3wwaEoDFwJcR/2MIjOK6DAsJmI=;
  b=UcE/YCsUtQxG+zGIiJ4nVx+3okKvVaD9+wqpKFoLU4oiAeTg5N38wcMa
   yv3F7aFbT194t+4YxNJ3/b5RxP/6MAAfXSmwQvl6tatqdRicbczDQl4cL
   7gOqR2MavUNTEx3Bp+Pe0bfdM2GgS92jvg408XVkJkHxpmit9v5DYSomc
   c=;
X-IronPort-AV: E=Sophos;i="6.09,239,1716249600"; 
   d="scan'208";a="744977504"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 16:50:19 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:41594]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.0.129:2525] with esmtp (Farcaster)
 id dd7c83a3-7c90-419d-98f4-4e8089f8113d; Fri, 26 Jul 2024 16:50:18 +0000 (UTC)
X-Farcaster-Flow-ID: dd7c83a3-7c90-419d-98f4-4e8089f8113d
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 26 Jul 2024 16:50:18 +0000
Received: from [192.168.9.159] (10.106.83.8) by EX19D022EUC002.ant.amazon.com
 (10.252.51.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34; Fri, 26 Jul 2024
 16:50:17 +0000
Message-ID: <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
Date: Fri, 26 Jul 2024 17:50:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults,
 KVM_READ_USERFAULT
To: James Houghton <jthoughton@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <roypat@amazon.co.uk>, <kalyazin@amazon.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-15-jthoughton@google.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJj5ki9BQkDwmcAAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOR1wD/UTcn4GbLC39QIwJuWXW0DeLoikxFBYkbhYyZ5CbtrtAA/2/rnR/zKZmyXqJ6
 ULlSE8eWA3ywAIOH8jIETF2fCaUCzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmPmSL0FCQPCZwACGwwACgkQr5LKIKmaZPNCxAEAxwnrmyqSC63nf6hoCFCfJYQapghC
 abLV0+PWemntlwEA/RYx8qCWD6zOEn4eYhQAucEwtg6h1PBbeGK94khVMooF
In-Reply-To: <20240710234222.2333120-15-jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D008EUC001.ant.amazon.com (10.252.51.165) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)

Hi James,

On 11/07/2024 00:42, James Houghton wrote:
> It is possible that KVM wants to access a userfault-enabled GFN in a
> path where it is difficult to return out to userspace with the fault
> information. For these cases, add a mechanism for KVM to wait for a GFN
> to not be userfault-enabled.
In this patch series, an asynchronous notification mechanism is used 
only in cases "where it is difficult to return out to userspace with the 
fault information". However, we (AWS) have a use case where we would 
like to be notified asynchronously about _all_ faults. Firecracker can 
restore a VM from a memory snapshot where the guest memory is supplied 
via a Userfaultfd by a process separate from the VMM itself [1]. While 
it looks technically possible for the VMM process to handle exits via 
forwarding the faults to the other process, that would require building 
a complex userspace protocol on top and likely introduce extra latency 
on the critical path. This also implies that a KVM API 
(KVM_READ_USERFAULT) is not suitable, because KVM checks that the ioctls 
are performed specifically by the VMM process [2]:
	if (kvm->mm != current->mm || kvm->vm_dead)
		return -EIO;

 > The implementation of this mechanism is certain to change before KVM
 > Userfault could possibly be merged.
How do you envision resolving faults in userspace? Copying the page in 
(provided that userspace mapping of guest_memfd is supported [3]) and 
clearing the KVM_MEMORY_ATTRIBUTE_USERFAULT alone do not look 
sufficient to resolve the fault because an attempt to copy the page 
directly in userspace will trigger a fault on its own and may lead to a 
deadlock in the case where the original fault was caused by the VMM. An 
interface similar to UFFDIO_COPY is needed that would allocate a page, 
copy the content in and update page tables.

[1] Firecracker snapshot restore via UserfaultFD: 
https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapshotting/handling-page-faults-on-snapshot-resume.md
[2] KVM ioctl check for the address space: 
https://elixir.bootlin.com/linux/v6.10.1/source/virt/kvm/kvm_main.c#L5083
[3] mmap() of guest_memfd: 
https://lore.kernel.org/kvm/489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.com/T/#mc944a6fdcd20a35f654c2be99f9c91a117c1bed4

Thanks,
Nikita

