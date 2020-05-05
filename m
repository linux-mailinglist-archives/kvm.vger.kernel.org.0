Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C351C50BF
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 10:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgEEIqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 04:46:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23652 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728351AbgEEIqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 04:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588668383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xo0QgrHWJ/5ZJxRirXqRejd7DgB0g48e4+rdKXViSlI=;
        b=Xm1+ERYk0nsc6SWU7DKmRmlu4EhIQu88Nj4AT6i0FHHB6KZBS9b1kJtog/6lDxKrDMMmdp
        ky6Gc3vrUNRgtuSS1aBUozSyNUpMzZXVkpJoItEA1bPg0FjvQxx5d199D9OP2k+1vhDjqO
        BmEK8phDDJ6xAwQtIxUUg453mXgu2B4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-5yF6fGg3PTaqid8vf2VP3A-1; Tue, 05 May 2020 04:46:18 -0400
X-MC-Unique: 5yF6fGg3PTaqid8vf2VP3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 599CF800687;
        Tue,  5 May 2020 08:46:17 +0000 (UTC)
Received: from gondolin (ovpn-112-219.ams2.redhat.com [10.36.112.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E79655D796;
        Tue,  5 May 2020 08:46:12 +0000 (UTC)
Date:   Tue, 5 May 2020 10:46:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Qian Cai <cailca@icloud.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v2] KVM: s390: Remove false WARN_ON_ONCE for the PQAP
 instruction
Message-ID: <20200505104610.469be44e.cohuck@redhat.com>
In-Reply-To: <20200505083515.2720-1-borntraeger@de.ibm.com>
References: <20200505083515.2720-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 10:35:15 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> In LPAR we will only get an intercept for FC==3 for the PQAP
> instruction. Running nested under z/VM can result in other intercepts as
> well as ECA_APIE is an effective bit: If one hypervisor layer has
> turned this bit off, the end result will be that we will get intercepts for
> all function codes. Usually the first one will be a query like PQAP(QCI).
> So the WARN_ON_ONCE is not right. Let us simply remove it.

Thanks, that is helpful to describe.

Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")

> Cc: Pierre Morel <pmorel@linux.ibm.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/kvm/20200505073525.2287-1-borntraeger@de.ibm.com

This links to v1, which is probably not what you want :)

> Reported-by: Qian Cai <cailca@icloud.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  arch/s390/kvm/priv.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 69a824f9ef0b..893893642415 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -626,10 +626,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>  	 * available for the guest are AQIC and TAPQ with the t bit set
>  	 * since we do not set IC.3 (FIII) we currently will only intercept
>  	 * the AQIC function code.
> +	 * Note: running nested under z/VM can result in intercepts for other
> +	 * function codes, e.g. PQAP(QCI). We do not support this and bail out.
>  	 */
>  	reg0 = vcpu->run->s.regs.gprs[0];
>  	fc = (reg0 >> 24) & 0xff;
> -	if (WARN_ON_ONCE(fc != 0x03))
> +	if (fc != 0x03)
>  		return -EOPNOTSUPP;
>  
>  	/* PQAP instruction is allowed for guest kernel only */

