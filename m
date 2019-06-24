Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464E250ABA
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 14:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfFXMdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 08:33:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfFXMdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 08:33:04 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD8803087948;
        Mon, 24 Jun 2019 12:33:03 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE248600D1;
        Mon, 24 Jun 2019 12:32:53 +0000 (UTC)
Date:   Mon, 24 Jun 2019 14:32:49 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>, <pbonzini@redhat.com>
Cc:     <mst@redhat.com>, <shannon.zhaosl@gmail.com>,
        <peter.maydell@linaro.org>, <lersek@redhat.com>,
        <james.morse@arm.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v17 08/10] KVM: Move related hwpoison page functions to
 accel/kvm/ folder
Message-ID: <20190624143249.37a5e6d5@redhat.com>
In-Reply-To: <1557832703-42620-9-git-send-email-gengdongjiu@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-9-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 24 Jun 2019 12:33:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 04:18:21 -0700
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> kvm_hwpoison_page_add() and kvm_unpoison_all() will be used both
> by X86 and ARM platforms, so move these functions to a common
> accel/kvm/ folder to avoid duplicate code.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  accel/kvm/kvm-all.c     | 33 +++++++++++++++++++++++++++++++++
>  include/exec/ram_addr.h | 24 ++++++++++++++++++++++++
>  target/arm/kvm.c        |  3 +++
>  target/i386/kvm.c       | 34 +---------------------------------
>  4 files changed, 61 insertions(+), 33 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 524c4dd..b9f9f29 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -625,6 +625,39 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
>      return ret;
>  }
>  
> +typedef struct HWPoisonPage {
> +    ram_addr_t ram_addr;
> +    QLIST_ENTRY(HWPoisonPage) list;
> +} HWPoisonPage;
> +
> +static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
> +    QLIST_HEAD_INITIALIZER(hwpoison_page_list);
> +
> +void kvm_unpoison_all(void *param)
> +{
> +    HWPoisonPage *page, *next_page;
> +
> +    QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
> +        QLIST_REMOVE(page, list);
> +        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        g_free(page);
> +    }
> +}
> +
> +void kvm_hwpoison_page_add(ram_addr_t ram_addr)
> +{
> +    HWPoisonPage *page;
> +
> +    QLIST_FOREACH(page, &hwpoison_page_list, list) {
> +        if (page->ram_addr == ram_addr) {
> +            return;
> +        }
> +    }
> +    page = g_new(HWPoisonPage, 1);
> +    page->ram_addr = ram_addr;
> +    QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
> +}
> +
>  static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
>  {
>  #if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index 139ad79..193b0a7 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h

it's not file for KVM specific code,
maybe Paolo could suggest a bettor place ...


> @@ -116,6 +116,30 @@ void qemu_ram_free(RAMBlock *block);
>  
>  int qemu_ram_resize(RAMBlock *block, ram_addr_t newsize, Error **errp);
>  
> +/**
> + * kvm_hwpoison_page_add:
> + *
> + * Parameters:
> + *  @ram_addr: the address in the RAM for the poisoned page
> + *
> + * Add a poisoned page to the list
> + *
> + * Return: None.
> + */
> +void kvm_hwpoison_page_add(ram_addr_t ram_addr);
> +
> +/**
> + * kvm_unpoison_all:
> + *
> + * Parameters:
> + *  @param: some data may be passed to this function
> + *
> + * Free and remove all the poisoned pages in the list
> + *
> + * Return: None.
> + */
> +void kvm_unpoison_all(void *param);
> +
>  #define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
>  #define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
>  
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 5995634..6d3b25b 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -29,6 +29,7 @@
>  #include "exec/address-spaces.h"
>  #include "hw/boards.h"
>  #include "qemu/log.h"
> +#include "exec/ram_addr.h"
>  
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
>      KVM_CAP_LAST_INFO
> @@ -187,6 +188,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>      cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
>  
> +    qemu_register_reset(kvm_unpoison_all, NULL);
> +
>      return 0;
>  }
>  
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3b29ce5..9bdb879 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -46,6 +46,7 @@
>  #include "migration/blocker.h"
>  #include "exec/memattrs.h"
>  #include "trace.h"
> +#include "exec/ram_addr.h"
>  
>  //#define DEBUG_KVM
>  
> @@ -467,39 +468,6 @@ uint32_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
>  }
>  
>  
> -typedef struct HWPoisonPage {
> -    ram_addr_t ram_addr;
> -    QLIST_ENTRY(HWPoisonPage) list;
> -} HWPoisonPage;
> -
> -static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
> -    QLIST_HEAD_INITIALIZER(hwpoison_page_list);
> -
> -static void kvm_unpoison_all(void *param)
> -{
> -    HWPoisonPage *page, *next_page;
> -
> -    QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
> -        QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> -        g_free(page);
> -    }
> -}
> -
> -static void kvm_hwpoison_page_add(ram_addr_t ram_addr)
> -{
> -    HWPoisonPage *page;
> -
> -    QLIST_FOREACH(page, &hwpoison_page_list, list) {
> -        if (page->ram_addr == ram_addr) {
> -            return;
> -        }
> -    }
> -    page = g_new(HWPoisonPage, 1);
> -    page->ram_addr = ram_addr;
> -    QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
> -}
> -
>  static int kvm_get_mce_cap_supported(KVMState *s, uint64_t *mce_cap,
>                                       int *max_banks)
>  {

