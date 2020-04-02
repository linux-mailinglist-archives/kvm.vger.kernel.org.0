Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21F819C419
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387819AbgDBO2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:28:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28815 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732245AbgDBO2p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 10:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585837723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q6/Zdn4PdxHJ91S/7dMf7deMcEC4jxiYXpkPo4ursOU=;
        b=AtpTb9HLyNnBiGcAYkirfds0y3SvqyvxmdpMlDEMbAfgiu0lLPEIH4ATZptEQDqPleKxsF
        B/GfHBtDgHbmQcYD4Q6oEWzwF/jlHbRcXJlv47N91c05ImCIsGMC0oLecgIC6MQ03IVPoR
        LposBxm4lW6S4UNPGxspb4gi1GZRoNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-enE41F3_PCCPc9ZZekUOcg-1; Thu, 02 Apr 2020 10:28:42 -0400
X-MC-Unique: enE41F3_PCCPc9ZZekUOcg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FF0118C43F9;
        Thu,  2 Apr 2020 14:28:32 +0000 (UTC)
Received: from [10.72.12.172] (ovpn-12-172.pek2.redhat.com [10.72.12.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 668BD26172;
        Thu,  2 Apr 2020 14:28:30 +0000 (UTC)
Subject: Re: [PATCH] vhost: drop vring dependency on iotlb
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200402141207.32628-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <afe230b9-708f-02a1-c3af-51e9d4fdd212@redhat.com>
Date:   Thu, 2 Apr 2020 22:28:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200402141207.32628-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/4/2 =E4=B8=8B=E5=8D=8810:12, Michael S. Tsirkin wrote:
> vringh can now be built without IOTLB.
> Select IOTLB directly where it's used.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> This is on top of my previous patch (in vhost tree now).
>
>   drivers/vdpa/Kconfig  | 1 +
>   drivers/vhost/Kconfig | 1 -
>   2 files changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index 7db1460104b7..08b615f2da39 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -17,6 +17,7 @@ config VDPA_SIM
>   	depends on RUNTIME_TESTING_MENU
>   	select VDPA
>   	select VHOST_RING
> +	select VHOST_IOTLB
>   	default n
>   	help
>   	  vDPA networking device simulator which loop TX traffic back
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 21feea0d69c9..bdd270fede26 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -6,7 +6,6 @@ config VHOST_IOTLB
>  =20
>   config VHOST_RING
>   	tristate
> -	select VHOST_IOTLB
>   	help
>   	  This option is selected by any driver which needs to access
>   	  the host side of a virtio ring.


Do we need to mention driver need to select VHOST_IOTLB by itself here?

Thanks



