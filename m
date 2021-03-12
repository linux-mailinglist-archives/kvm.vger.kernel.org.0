Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3573385F4
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 07:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhCLGeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 01:34:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231713AbhCLGds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 01:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615530828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxYXgMslZPHyhqjjAUjb+4OhgFRtuNfwG4K2get5jzc=;
        b=CNK2/qVtfCARrBUC52RW5uBGXQWV0S+/j7W9sDqzC87hYFEchtqT/wR2THLJfJdrlPo7CX
        CAg1YdFdsECnWGRq/WgjC/48jHcCHlkoJSOPIVjC7K5MHzN1rFACSq1J6ejDJBUi5JNXeK
        aAR1VZaOJC3SwFQ+c1D8c92CwXQMYG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-74yRoMHdPampxkMFKNsVrQ-1; Fri, 12 Mar 2021 01:33:46 -0500
X-MC-Unique: 74yRoMHdPampxkMFKNsVrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3B0F6801817;
        Fri, 12 Mar 2021 06:33:45 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-168.pek2.redhat.com [10.72.13.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0CD15D6D7;
        Fri, 12 Mar 2021 06:33:39 +0000 (UTC)
Subject: Re: [PATCH 1/2] vhost-vdpa: fix use-after-free of v->config_ctx
To:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210311135257.109460-1-sgarzare@redhat.com>
 <20210311135257.109460-2-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cfe550cf-301a-92c4-7270-6a50ea3ed19c@redhat.com>
Date:   Fri, 12 Mar 2021 14:33:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210311135257.109460-2-sgarzare@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/3/11 9:52 下午, Stefano Garzarella wrote:
> When the 'v->config_ctx' eventfd_ctx reference is released we didn't
> set it to NULL. So if the same character device (e.g. /dev/vhost-vdpa-0)
> is re-opened, the 'v->config_ctx' is invalid and calling again
> vhost_vdpa_config_put() causes use-after-free issues like the
> following refcount_t underflow:
>
>      refcount_t: underflow; use-after-free.
>      WARNING: CPU: 2 PID: 872 at lib/refcount.c:28 refcount_warn_saturate+0xae/0xf0
>      RIP: 0010:refcount_warn_saturate+0xae/0xf0
>      Call Trace:
>       eventfd_ctx_put+0x5b/0x70
>       vhost_vdpa_release+0xcd/0x150 [vhost_vdpa]
>       __fput+0x8e/0x240
>       ____fput+0xe/0x10
>       task_work_run+0x66/0xa0
>       exit_to_user_mode_prepare+0x118/0x120
>       syscall_exit_to_user_mode+0x21/0x50
>       ? __x64_sys_close+0x12/0x40
>       do_syscall_64+0x45/0x50
>       entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
> Cc: lingshan.zhu@intel.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vdpa.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ef688c8c0e0e..00796e4ecfdf 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -308,8 +308,10 @@ static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
>   
>   static void vhost_vdpa_config_put(struct vhost_vdpa *v)
>   {
> -	if (v->config_ctx)
> +	if (v->config_ctx) {
>   		eventfd_ctx_put(v->config_ctx);
> +		v->config_ctx = NULL;
> +	}
>   }
>   
>   static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)

