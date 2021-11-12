Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B4B44E0ED
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 04:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhKLECj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 11 Nov 2021 23:02:39 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14738 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKLECi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 23:02:38 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hr4Y66YfzzZd1X;
        Fri, 12 Nov 2021 11:57:30 +0800 (CST)
Received: from dggpemm100007.china.huawei.com (7.185.36.116) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 12 Nov 2021 11:59:47 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpemm100007.china.huawei.com (7.185.36.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 12 Nov 2021 11:59:46 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.015;
 Fri, 12 Nov 2021 11:59:46 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH v5 4/6] kvm: irqchip: extract
 kvm_irqchip_add_deferred_msi_route
Thread-Topic: [PATCH v5 4/6] kvm: irqchip: extract
 kvm_irqchip_add_deferred_msi_route
Thread-Index: AQHX0IsxWviLXRP53kGau6vBqNcnCav/UFjg
Date:   Fri, 12 Nov 2021 03:59:46 +0000
Message-ID: <dcdeba83881c4fe289092ed55cb9500b@huawei.com>
References: <20211103081657.1945-1-longpeng2@huawei.com>
 <20211103081657.1945-5-longpeng2@huawei.com>
In-Reply-To: <20211103081657.1945-5-longpeng2@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Ping...

Do you have any suggestions about this change ? It seems Alex has no
objection on this series now, but we need your ACK, thanks.


> -----Original Message-----
> From: Longpeng (Mike, Cloud Infrastructure Service Product Dept.)
> Sent: Wednesday, November 3, 2021 4:17 PM
> To: alex.williamson@redhat.com; pbonzini@redhat.com
> Cc: qemu-devel@nongnu.org; kvm@vger.kernel.org; Gonglei (Arei)
> <arei.gonglei@huawei.com>; Longpeng (Mike, Cloud Infrastructure Service
> Product Dept.) <longpeng2@huawei.com>
> Subject: [PATCH v5 4/6] kvm: irqchip: extract
> kvm_irqchip_add_deferred_msi_route
> 
> Extract a common helper that add MSI route for specific vector
> but does not commit immediately.
> 
> Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
> ---
>  accel/kvm/kvm-all.c  | 15 +++++++++++++--
>  include/sysemu/kvm.h |  6 ++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index db8d83b..8627f7c 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1953,7 +1953,7 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
>      return kvm_set_irq(s, route->kroute.gsi, 1);
>  }
> 
> -int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
> +int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector, PCIDevice
> *dev)
>  {
>      struct kvm_irq_routing_entry kroute = {};
>      int virq;
> @@ -1996,7 +1996,18 @@ int kvm_irqchip_add_msi_route(KVMState *s, int vector,
> PCIDevice *dev)
> 
>      kvm_add_routing_entry(s, &kroute);
>      kvm_arch_add_msi_route_post(&kroute, vector, dev);
> -    kvm_irqchip_commit_routes(s);
> +
> +    return virq;
> +}
> +
> +int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
> +{
> +    int virq;
> +
> +    virq = kvm_irqchip_add_deferred_msi_route(s, vector, dev);
> +    if (virq >= 0) {
> +        kvm_irqchip_commit_routes(s);
> +    }
> 
>      return virq;
>  }
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index a1ab1ee..8de0d9a 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -476,6 +476,12 @@ void kvm_init_cpu_signals(CPUState *cpu);
>   * @return: virq (>=0) when success, errno (<0) when failed.
>   */
>  int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev);
> +/**
> + * Add MSI route for specific vector but does not commit to KVM
> + * immediately
> + */
> +int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector,
> +                                       PCIDevice *dev);
>  int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
>                                   PCIDevice *dev);
>  void kvm_irqchip_commit_routes(KVMState *s);
> --
> 1.8.3.1

