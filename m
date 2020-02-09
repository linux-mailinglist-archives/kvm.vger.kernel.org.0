Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7588156B4C
	for <lists+kvm@lfdr.de>; Sun,  9 Feb 2020 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBIQDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Feb 2020 11:03:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26586 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727320AbgBIQDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Feb 2020 11:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581264225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=JY0nhyrXgf3jKw0ANrA7IUOfqPVCGUx1OFfYKp1/sVk=;
        b=IVzVlhLYLpKLUIK93CF+D7xIUYOm5vTRYaJY/afJhxJCucvWnt+EaoGTAIHv2NDNPbpmhk
        k75ue+A5NIEmHczkkbtWB/mJlg+tNXj2la9+msW+Sa0XNKSU218Zwd89m9JWIOqcyYcgYF
        t0gylfQIPl4Nx7uOYdlqygL7ePG7Bpk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-klDpJsQXMricCmuBzE5XGg-1; Sun, 09 Feb 2020 11:03:41 -0500
X-MC-Unique: klDpJsQXMricCmuBzE5XGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 775F08017DF;
        Sun,  9 Feb 2020 16:03:39 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-108.ams2.redhat.com [10.36.116.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 73D9F84BCC;
        Sun,  9 Feb 2020 16:03:34 +0000 (UTC)
Subject: Re: [PATCH 28/35] KVM: s390: protvirt: UV calls diag308 0, 1
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
 <20200207113958.7320-29-borntraeger@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bc9b1c4f-af9f-8859-79b7-ed232cfd5f6e@redhat.com>
Date:   Sun, 9 Feb 2020 17:03:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200207113958.7320-29-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2020 12.39, Christian Borntraeger wrote:
> From: Janosch Frank <frankja@linux.ibm.com>
> 
> diag 308 subcode 0 and 1 require KVM and Ultravisor interaction, since
> the cpus have to be set into multiple reset states.
> 
> * All cpus need to be stopped
> * The "unshare all" UVC needs to be executed
> * The "perform reset" UVC needs to be executed
> * The cpus need to be reset via the "set cpu state" UVC
> * The issuing cpu needs to set state 5 via "set cpu state"

Is the patch description still accurate here? The patch seems mostly
about adding two new UVCs, and not really about diag 308 ... ?

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
[...]
> diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
> index 3fb54ec2cf3e..390830385b9f 100644
> --- a/arch/s390/kvm/diag.c
> +++ b/arch/s390/kvm/diag.c
> @@ -13,6 +13,7 @@
>  #include <asm/pgalloc.h>
>  #include <asm/gmap.h>
>  #include <asm/virtio-ccw.h>
> +#include <asm/uv.h>
>  #include "kvm-s390.h"
>  #include "trace.h"
>  #include "trace-s390.h"

This single change to diag.c looks like it could either be removed, or
the hunk should belong to another patch.

> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 4afa44e3d1ed..0be18ac1afb5 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c

 Thomas

