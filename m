Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6490E155BD6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 17:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgBGQct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 11:32:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726874AbgBGQct (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 11:32:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581093168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=YrpbXFD3uGhBknCib/CmfKmTHs+XZUAPlpUmR119VD0=;
        b=do2MmYDUKj57BYXv0wUPkWHtlWkrRBACCzALJaEbAOmbceTeADu6DdoXYw+sTr2QkfTZax
        4sJdxAjlIuPY7TkeLzghuWgpFfUmIP8Y0np8CacEFVwMR1/xmtbCmWYwSYioUSUca+BRD8
        cTu+VjtAGrHp5scTuMTYikTzsAamh+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-fTrRfajkOOuw6ZsukJNYKA-1; Fri, 07 Feb 2020 11:32:42 -0500
X-MC-Unique: fTrRfajkOOuw6ZsukJNYKA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F02BCA0CC1;
        Fri,  7 Feb 2020 16:32:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-143.ams2.redhat.com [10.36.116.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B047326370;
        Fri,  7 Feb 2020 16:32:35 +0000 (UTC)
Subject: Re: [PATCH 08/35] KVM: s390: protvirt: Add initial lifecycle handling
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-9-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c4949664-c6fd-f4d9-d42d-f2fa9426db00@redhat.com>
Date:   Fri, 7 Feb 2020 17:32:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-9-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
>=20
> This contains 3 main changes:
> 1. changes in SIE control block handling for secure guests
> 2. helper functions for create/destroy/unpack secure guests
> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> machines
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
[...]
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index e1cef772fde1..7c21d55d2e49 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -23,11 +23,19 @@
>  #define UVC_RC_INV_STATE	0x0003
>  #define UVC_RC_INV_LEN		0x0005
>  #define UVC_RC_NO_RESUME	0x0007
> +#define UVC_RC_NEED_DESTROY	0x8000

This define is never used. I'd suggest to drop it.

The rest of the patch looks ok to me.

 Thomas

