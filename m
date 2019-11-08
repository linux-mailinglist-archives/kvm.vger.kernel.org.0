Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3EEBF424E
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfKHIj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:39:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31120 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726072AbfKHIj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Nov 2019 03:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573202395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xp0hQH3S2oYEDoMEKj5U21xfIeDgrenV0RYz25pJPfM=;
        b=fofgyRyW/Hu9ECGQ+BuGy8FrFejNTvdG1VDYv/Sy56jk2rjxJiFadAJ6tW2eWt9rqekuBY
        LdFHwFNW/fpNyLAIMrFbIKrRG997gKqXRGk6v+erNj1/4rlk01b5m+c5FTi5Ork3Y0H5IS
        t0y6WISBtzAvzweprcCFUmmWoilvEFY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-7lYtMHmCOIOBR8EdWD8Thw-1; Fri, 08 Nov 2019 03:39:52 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B6D18017DE;
        Fri,  8 Nov 2019 08:39:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-167.ams2.redhat.com [10.36.116.167])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74B241A8D8;
        Fri,  8 Nov 2019 08:39:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 2/6] pci: cast the masks to the
 appropriate size
To:     Bill Wendling <morbo@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     jmattson@google.com, sean.j.christopherson@intel.com
References: <20191015000411.59740-1-morbo@google.com>
 <20191030210419.213407-1-morbo@google.com>
 <20191030210419.213407-3-morbo@google.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <17a73412-7417-bef4-d525-1f4c168f56a7@redhat.com>
Date:   Fri, 8 Nov 2019 09:39:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191030210419.213407-3-morbo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: 7lYtMHmCOIOBR8EdWD8Thw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/10/2019 22.04, Bill Wendling wrote:
> At this point, we're dealing with 32-bit addresses, therefore downcast
> the masks to 32-bits.

In case you respin, please mention the warning from clang that you are=20
fixing here.

> diff --git a/lib/pci.c b/lib/pci.c
> index daa33e1..1b85411 100644
> --- a/lib/pci.c
> +++ b/lib/pci.c
> @@ -107,7 +107,8 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_=
t device_id)
>   uint32_t pci_bar_mask(uint32_t bar)
>   {
>   =09return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
> -=09=09PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
> +=09=09(uint32_t)PCI_BASE_ADDRESS_IO_MASK :
> +=09=09(uint32_t)PCI_BASE_ADDRESS_MEM_MASK;
>   }
>  =20
>   uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)

Reviewed-by: Thomas Huth <thuth@redhat.com>

