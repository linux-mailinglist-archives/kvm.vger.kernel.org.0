Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873C11CD1E8
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 08:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEKGga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 02:36:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgEKGg3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 May 2020 02:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589178988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ncGeH5ZKVwCdh5E0XvEmoml51kA2FhsNgAa3Rpsy93w=;
        b=fn5AxNTGNtOH+QRKToE59YvI1dQBQ6mRY8kFmnbgYkYaIS5x0tlbFm5ISXplT/wcXrjxfv
        Ibbp7bZk3BJ73bK4bVsIArKItMGdwp9Wbl3AD81RSAh1mgSdkGelaWvovfzXyfhmraPBLo
        ZQZmcTyOY8ygwt9PCkab9vSVWzPZ9Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-HiHDwdZgPKaiPonLkIwVrA-1; Mon, 11 May 2020 02:35:55 -0400
X-MC-Unique: HiHDwdZgPKaiPonLkIwVrA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE07F107ACCA;
        Mon, 11 May 2020 06:35:54 +0000 (UTC)
Received: from gondolin (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD81360CD1;
        Mon, 11 May 2020 06:35:50 +0000 (UTC)
Date:   Mon, 11 May 2020 08:35:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Qian Cai <cai@lca.pw>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: fix memory leaks in alloc_perm_bits()
Message-ID: <20200511083547.24718bcc.cohuck@redhat.com>
In-Reply-To: <20200510161656.1415-1-cai@lca.pw>
References: <20200510161656.1415-1-cai@lca.pw>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 10 May 2020 12:16:56 -0400
Qian Cai <cai@lca.pw> wrote:

> vfio_pci_disable() calls vfio_config_free() but forgets to call
> free_perm_bits() resulting in memory leaks,
> 
> unreferenced object 0xc000000c4db2dee0 (size 16):
>   comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
>   hex dump (first 16 bytes):
>     00 00 ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
>   backtrace:
>     [<00000000a6a4552d>] alloc_perm_bits+0x58/0xe0 [vfio_pci]
>     [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
>     init_pci_cap_msi_perm at drivers/vfio/pci/vfio_pci_config.c:1125
>     (inlined by) vfio_msi_cap_len at drivers/vfio/pci/vfio_pci_config.c:1180
>     (inlined by) vfio_cap_len at drivers/vfio/pci/vfio_pci_config.c:1241
>     (inlined by) vfio_cap_init at drivers/vfio/pci/vfio_pci_config.c:1468
>     (inlined by) vfio_config_init at drivers/vfio/pci/vfio_pci_config.c:1707
>     [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
>     [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
>     [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
>     [<000000006577923d>] sys_ioctl+0x28/0x40
>     [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
>     [<0000000008ea7dd5>] system_call_common+0xf0/0x278
> unreferenced object 0xc000000c4db2e330 (size 16):
>   comm "qemu-kvm", pid 4305, jiffies 4295020272 (age 3463.780s)
>   hex dump (first 16 bytes):
>     00 ff ff 00 ff ff ff ff ff ff ff ff ff ff 00 00  ................
>   backtrace:
>     [<000000004c71914f>] alloc_perm_bits+0x44/0xe0 [vfio_pci]
>     [<00000000ac990549>] vfio_config_init+0xdf0/0x11b0 [vfio_pci]
>     [<000000006db873a1>] vfio_pci_open+0x234/0x700 [vfio_pci]
>     [<00000000630e1906>] vfio_group_fops_unl_ioctl+0x8e0/0xb84 [vfio]
>     [<000000009e34c54f>] ksys_ioctl+0xd8/0x130
>     [<000000006577923d>] sys_ioctl+0x28/0x40
>     [<000000006d7b1cf2>] system_call_exception+0x114/0x1e0
>     [<0000000008ea7dd5>] system_call_common+0xf0/0x278
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 90c0b80f8acf..f9fdc72a5f4e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1728,6 +1728,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
>  	vdev->vconfig = NULL;
>  	kfree(vdev->pci_config_map);
>  	vdev->pci_config_map = NULL;
> +	free_perm_bits(vdev->msi_perm);
>  	kfree(vdev->msi_perm);
>  	vdev->msi_perm = NULL;
>  }

Seems to be the only perm bits that were missed.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

