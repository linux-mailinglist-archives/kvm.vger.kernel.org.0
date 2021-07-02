Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781973B9C4E
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhGBGtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 02:49:33 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9335 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhGBGtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 02:49:33 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GGQW75Sbkz74Bs;
        Fri,  2 Jul 2021 14:42:43 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 14:46:59 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 2 Jul 2021 14:46:58 +0800
Subject: Re: [PATCH v4 5/6] KVM: selftests: Add exception handling support for
 aarch64
To:     Ricardo Koller <ricarkol@google.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <pbonzini@redhat.com>, <maz@kernel.org>, <drjones@redhat.com>,
        <alexandru.elisei@arm.com>, <eric.auger@redhat.com>,
        <vkuznets@redhat.com>, Sean Christopherson <seanjc@google.com>
References: <20210611011020.3420067-1-ricarkol@google.com>
 <20210611011020.3420067-6-ricarkol@google.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b1f581ec-56f4-24a2-7850-182128cdc4ac@huawei.com>
Date:   Fri, 2 Jul 2021 14:46:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210611011020.3420067-6-ricarkol@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+Sean]

On 2021/6/11 9:10, Ricardo Koller wrote:
> Add the infrastructure needed to enable exception handling in aarch64
> selftests. The exception handling defaults to an unhandled-exception
> handler which aborts the test, just like x86. These handlers can be
> overridden by calling vm_install_exception_handler(vector) or
> vm_install_sync_handler(vector, ec). The unhandled exception reporting
> from the guest is done using the ucall type introduced in a previous
> commit, UCALL_UNHANDLED.
> 
> The exception handling code is inspired on kvm-unit-tests.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/processor.h |  63 +++++++++
>  .../selftests/kvm/lib/aarch64/handlers.S      | 126 ++++++++++++++++++
>  .../selftests/kvm/lib/aarch64/processor.c     |  97 ++++++++++++++
>  4 files changed, 287 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S

[...]

> +void vm_init_descriptor_tables(struct kvm_vm *vm)
> +{
> +	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
> +			vm->page_size, 0, 0);

This raced with commit a75a895e6457 ("KVM: selftests: Unconditionally
use memslot 0 for vaddr allocations") which dropped memslot parameters
from vm_vaddr_alloc().

We can remove the related comments on top of vm_vaddr_alloc() as well.

Zenghui
