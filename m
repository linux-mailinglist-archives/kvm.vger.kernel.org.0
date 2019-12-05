Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D642114138
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 14:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfLENKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 08:10:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729048AbfLENKB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Dec 2019 08:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575551400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=9ZS3eRs/VTFhjUYbJbY7+X719DLjsWtfaUgf8EntmVQ=;
        b=LG3TiVf2GJh9Okad8DRn8cdbU2AOly+vz0WS4B0jb0ACRe4Jd76x63edFaZnbt7044XGEy
        x4q+2ujMRc/DBJdJONYaD7XVRWERTfeRKcTG1ipcoHraVaMD7aJ7apicj03u88pW86/NxH
        DQ+/ifu83z3FE4nSyPqA47sbHA6rjFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-_ikbm2M-NAyyUG-a5mKo6w-1; Thu, 05 Dec 2019 08:09:57 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C1E2800D41;
        Thu,  5 Dec 2019 13:09:56 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-87.ams2.redhat.com [10.36.116.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E6235C21B;
        Thu,  5 Dec 2019 13:09:51 +0000 (UTC)
Subject: Re: [PATCH] KVM: s390: ENOTSUPP -> EOPNOTSUPP fixups
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <20191205125147.229367-1-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <087b1693-6ec0-94e3-d94a-f55c2e717438@redhat.com>
Date:   Thu, 5 Dec 2019 14:09:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191205125147.229367-1-borntraeger@de.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: _ikbm2M-NAyyUG-a5mKo6w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/12/2019 13.51, Christian Borntraeger wrote:
> There is no ENOTSUPP for userspace
> 
> Reported-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 2a711bae69a7..bd9b339bbb5e 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2312,7 +2312,7 @@ static int flic_ais_mode_get_all(struct kvm *kvm, struct kvm_device_attr *attr)
>  		return -EINVAL;
>  
>  	if (!test_kvm_facility(kvm, 72))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	mutex_lock(&fi->ais_lock);
>  	ais.simm = fi->simm;
> @@ -2621,7 +2621,7 @@ static int modify_ais_mode(struct kvm *kvm, struct kvm_device_attr *attr)
>  	int ret = 0;
>  
>  	if (!test_kvm_facility(kvm, 72))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (copy_from_user(&req, (void __user *)attr->addr, sizeof(req)))
>  		return -EFAULT;
> @@ -2701,7 +2701,7 @@ static int flic_ais_mode_set_all(struct kvm *kvm, struct kvm_device_attr *attr)
>  	struct kvm_s390_ais_all ais;
>  
>  	if (!test_kvm_facility(kvm, 72))
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (copy_from_user(&ais, (void __user *)attr->addr, sizeof(ais)))
>  		return -EFAULT;
> 

Good catch.

Reviewed-by: Thomas Huth <thuth@redhat.com>

There seems to be another one in arch/s390/include/asm/uv.h, are you
going to fix that, too?

