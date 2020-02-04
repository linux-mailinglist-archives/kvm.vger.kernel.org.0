Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9882151725
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 09:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgBDIlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 03:41:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32914 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726000AbgBDIlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 03:41:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580805661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mdQ5eMYTJGu5d0KP6oN5ZaNXuHbC1TLBkdnlQTCq1Os=;
        b=BRfiN9U7/QAaFRLWxWcIynTBPk509Fx0bfEzbPrHfaHionMlUzDZKr3qUXatiWrlSFvHlG
        eFqrQGjf+c/sMuuT8FsNJRlGIhM1vu+CabfvGA39/sSqO3uX1RRiU7B/TKGch+kiHeb4jh
        G98hKMdwC54zY6D5VMGIKky+c5ynxsg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-P15rOXcJP8qhilePZ8Sgew-1; Tue, 04 Feb 2020 03:40:57 -0500
X-MC-Unique: P15rOXcJP8qhilePZ8Sgew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D0821088382;
        Tue,  4 Feb 2020 08:40:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 412B51BC6D;
        Tue,  4 Feb 2020 08:40:52 +0000 (UTC)
Subject: Re: [RFCv2 02/37] s390/protvirt: introduce host side setup
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
 <20200203131957.383915-3-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5cda9a67-5ac8-c23c-a935-3c22c0012e32@redhat.com>
Date:   Tue, 4 Feb 2020 09:40:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203131957.383915-3-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2020 14.19, Christian Borntraeger wrote:
> From: Vasily Gorbik <gor@linux.ibm.com>
>=20
> Introduce KVM_S390_PROTECTED_VIRTUALIZATION_HOST kbuild option for
> protected virtual machines hosting support code.
>=20
> Add "prot_virt" command line option which controls if the kernel
> protected VMs support is enabled at early boot time. This has to be
> done early, because it needs large amounts of memory and will disable
> some features like STP time sync for the lpar.
>=20
> Extend ultravisor info definitions and expose it via uv_info struct
> filled in during startup.
>=20
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
[...]
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 4093a2856929..32eac3ab2d3b 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -44,7 +44,19 @@ struct uv_cb_qui {
>  	struct uv_cb_header header;
>  	u64 reserved08;
>  	u64 inst_calls_list[4];
> -	u64 reserved30[15];
> +	u64 reserved30[2];
> +	u64 uv_base_stor_len;
> +	u64 reserved48;
> +	u64 conf_base_phys_stor_len;
> +	u64 conf_base_virt_stor_len;
> +	u64 conf_virt_var_stor_len;
> +	u64 cpu_stor_len;
> +	u32 reserved68[3];

If I count right, that should be named reserved70 instead?

> +	u32 max_num_sec_conf;
> +	u64 max_guest_stor_addr;
> +	u8  reserved80[150-128];

And this one reserved88[158 - 136] ?

> +	u16 max_guest_cpus;
> +	u64 reserved98;

reservedA0 ?

>  } __packed __aligned(8);
> =20

Apart from that, the patch looks ok to me.

 Thomas

