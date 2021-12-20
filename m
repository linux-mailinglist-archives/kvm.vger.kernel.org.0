Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95CC947A6F1
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhLTJX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 04:23:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34834 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232516AbhLTJXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Dec 2021 04:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639992220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nnk2J4ZoXBtJE9rH5Olhc2v3ow2o0jQFMpDHq6LmjfY=;
        b=TfUuygAu0jRp4T5XYyqcyep5VUHpjZCfSaJvixdiMl7f/bNK3hXvIu5VwuYyXIrseo+3Cs
        ihiwuMh2xaJ5Mkqj61lN7bxfMC0xnOqVu/Ea++dpe/xz2k3ml1z2XeD+p5CyFXLItsSbgP
        11uCFlBP1MQDQyNQXRT+HmnSvFa8myk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-bapgra1gNZK9FuasX-NYsQ-1; Mon, 20 Dec 2021 04:23:39 -0500
X-MC-Unique: bapgra1gNZK9FuasX-NYsQ-1
Received: by mail-ed1-f72.google.com with SMTP id dm10-20020a05640222ca00b003f808b5aa18so7079604edb.4
        for <kvm@vger.kernel.org>; Mon, 20 Dec 2021 01:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Nnk2J4ZoXBtJE9rH5Olhc2v3ow2o0jQFMpDHq6LmjfY=;
        b=jGJL/o61mF9La1WC2vsH4ryN6YdXqHB8/oAyKoMiutS56LLRhDBwZubiQMgXCLp3+E
         dGs8qahScPxu2KdcVixkF79gkVRFSB+FWXTHsWMt3h15f4O7NcmpvYT+h8jO+AFh9b8m
         1n1zWIRmor8xNbXENlAQpUsmZEgExWUSlGzesX9vgvvLAZ+DAGn8GXCKhyKAb0lVhiRM
         sLMs5mvzoNx0EnIN9fpTz24HctA8pruuA93s6F1dleaEb0WEDIKcczAx05q1IPtFAHAd
         Jqpml812UJGvY1eFbkSYUSwZ+a+9Q+EsgPY9SdpPVV8xyqUGy1DcZyRMYNHJjvt4TgFF
         qVzg==
X-Gm-Message-State: AOAM5317kM+iOjAArZ21xZtyXT79pEpTTF576BVyrjDyNwLW6Yhfibg+
        ke3wHUTrVN3jjjEO80hR1i3xffO7dmc//edNZBt1y1WxvKqOdwNbaYCcJsuIBEOKxHoE6c4daHp
        0056/SxPsNCo4
X-Received: by 2002:a05:6402:c0a:: with SMTP id co10mr14695522edb.295.1639992217400;
        Mon, 20 Dec 2021 01:23:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUAbBEWaDB55xFPv1shMHEPRY0K/FLkT72nUjo6PPZahsoOBnw0777NBsB1oiVAcMaXdj8AQ==
X-Received: by 2002:a05:6402:c0a:: with SMTP id co10mr14695500edb.295.1639992217232;
        Mon, 20 Dec 2021 01:23:37 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j11sm6434339edv.0.2021.12.20.01.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 01:23:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandru Vasile <lexnv@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: Re: [PATCH =?utf-8?Q?v1=C2=A0=5D?= nitro_enclaves: Add
 mmap_read_lock() for the
 get_user_pages() call
In-Reply-To: <20211218103525.26739-1-andraprs@amazon.com>
References: <20211218103525.26739-1-andraprs@amazon.com>
Date:   Mon, 20 Dec 2021 10:23:35 +0100
Message-ID: <87o85btyso.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andra Paraschiv <andraprs@amazon.com> writes:

> After commit 5b78ed24e8ec (mm/pagemap: add mmap_assert_locked()
> annotations to find_vma*()), the call to get_user_pages() will trigger
> the mmap assert.
>
> static inline void mmap_assert_locked(struct mm_struct *mm)
> {
> 	lockdep_assert_held(&mm->mmap_lock);
> 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
> }
>
> [   62.521410] kernel BUG at include/linux/mmap_lock.h:156!
> ...........................................................
> [   62.538938] RIP: 0010:find_vma+0x32/0x80
> ...........................................................
> [   62.605889] Call Trace:
> [   62.608502]  <TASK>
> [   62.610956]  ? lock_timer_base+0x61/0x80
> [   62.614106]  find_extend_vma+0x19/0x80
> [   62.617195]  __get_user_pages+0x9b/0x6a0
> [   62.620356]  __gup_longterm_locked+0x42d/0x450
> [   62.623721]  ? finish_wait+0x41/0x80
> [   62.626748]  ? __kmalloc+0x178/0x2f0
> [   62.629768]  ne_set_user_memory_region_ioctl.isra.0+0x225/0x6a0 [nitro_enclaves]
> [   62.635776]  ne_enclave_ioctl+0x1cf/0x6d7 [nitro_enclaves]
> [   62.639541]  __x64_sys_ioctl+0x82/0xb0
> [   62.642620]  do_syscall_64+0x3b/0x90
> [   62.645642]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Add mmap_read_lock() for the get_user_pages() call when setting the
> enclave memory regions.
>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Cc: stable@vger.kernel.org

In case commit 5b78ed24e8ec broke Nitro Enclaves driver, we need to
explicitly state this:

Fixes: 5b78ed24e8ec ("mm/pagemap: add mmap_assert_locked() annotations to find_vma*()")

> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index 8939612ee0e0..6c51ff024036 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -886,8 +886,13 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
>  			goto put_pages;
>  		}
>  
> +		mmap_read_lock(current->mm);
> +
>  		gup_rc = get_user_pages(mem_region.userspace_addr + memory_size, 1, FOLL_GET,
>  					ne_mem_region->pages + i, NULL);
> +
> +		mmap_read_unlock(current->mm);
> +

This looks very much like get_user_pages_unlocked(), I think we can use
it instead of open-coding it.

>  		if (gup_rc < 0) {
>  			rc = gup_rc;

-- 
Vitaly

