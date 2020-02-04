Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049591518BD
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 11:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgBDKXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 05:23:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726684AbgBDKXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 05:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580811799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tUpnJG9JtDpQBK3s3JKa4VyZOJh0T5nVC/udj6x6DRk=;
        b=RwBp4gGSPD3reuU+2CPqrxfmbmUXSyXSlRQ/5rPc+HCFa+VnsUllWu3gzY3qS0Ry+PDPpp
        ZcTZb+R4jWp3Jo4ZEwuyoP7KIIFIfkpVvCKKro4fGmG6J1STBfccA7s5CVZNGS2mRb+LW/
        uQ3BL07xpuQlOTNkHqcgZvBEpxqlxRk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-Vaq1-pKzMpmFaNgyuv2CDQ-1; Tue, 04 Feb 2020 05:23:11 -0500
X-MC-Unique: Vaq1-pKzMpmFaNgyuv2CDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A80010054E3;
        Tue,  4 Feb 2020 10:23:10 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 012FC1001DC2;
        Tue,  4 Feb 2020 10:23:05 +0000 (UTC)
Date:   Tue, 4 Feb 2020 11:23:03 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 03/37] s390/protvirt: add ultravisor initialization
Message-ID: <20200204112303.5b5e999b.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-4-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-4-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:23 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Vasily Gorbik <gor@linux.ibm.com>
> 
> Before being able to host protected virtual machines, donate some of
> the memory to the ultravisor. Besides that the ultravisor might impose
> addressing limitations for memory used to back protected VM storage. Treat
> that limit as protected virtualization host's virtual memory limit.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 16 ++++++++++++
>  arch/s390/kernel/setup.c   |  3 +++
>  arch/s390/kernel/uv.c      | 53 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 72 insertions(+)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 32eac3ab2d3b..cdf2fd71d7ab 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h

(...)

> @@ -59,6 +61,15 @@ struct uv_cb_qui {
>  	u64 reserved98;
>  } __packed __aligned(8);
>  
> +struct uv_cb_init {
> +	struct uv_cb_header header;
> +	u64 reserved08[2];
> +	u64 stor_origin;
> +	u64 stor_len;
> +	u64 reserved28[4];
> +

Maybe drop the blank line?

> +} __packed __aligned(8);
> +
>  struct uv_cb_share {
>  	struct uv_cb_header header;
>  	u64 reserved08[3];

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

