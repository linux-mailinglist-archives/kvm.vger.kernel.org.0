Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E3C14F9DA
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgBASzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:55:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726487AbgBASzs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:55:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580583347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=6pwRPZod6kBjVm5P+qCz5818fJAOwXn5aXODvcuCPRg=;
        b=EGvBzyDg0RrlDuOAMCDz/cOQ8fEBmWHVIOZEEFEhTiRo0XwhnL6K4pk4Tb3uju787mfhZ9
        GCbo0TwRACtzz9q7tH930oUoF7HdAcbo+CKoblJAMjEvl9GwMQm4ua73l4QPpg2gQemRJ5
        ATn6quR/ZNDy4p+SA9mMJarDo1VD4zI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-dFDdcUu1NgSnwjaKjEpJvw-1; Sat, 01 Feb 2020 13:55:45 -0500
X-MC-Unique: dFDdcUu1NgSnwjaKjEpJvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E12013E6;
        Sat,  1 Feb 2020 18:55:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-27.ams2.redhat.com [10.36.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 78ECF5DAB0;
        Sat,  1 Feb 2020 18:55:40 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 3/7] s390x: Stop the cpu that is
 executing exit()
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200201152851.82867-1-frankja@linux.ibm.com>
 <20200201152851.82867-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a2c462d4-c27c-2da5-b168-016a063d17c7@redhat.com>
Date:   Sat, 1 Feb 2020 19:55:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200201152851.82867-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2020 16.28, Janosch Frank wrote:
> CPU 0 is not necessarily the CPU which does the exit if we ran into a
> test abort situation. So, let's ask stap() which cpu does the exit and
> stop it on exit.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/io.c b/lib/s390x/io.c
> index 32f09b5..e091c37 100644
> --- a/lib/s390x/io.c
> +++ b/lib/s390x/io.c
> @@ -46,6 +46,6 @@ void exit(int code)
>  	smp_teardown();
>  	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
>  	while (1) {
> -		sigp(0, SIGP_STOP, 0, NULL);
> +		sigp(stap(), SIGP_STOP, 0, NULL);
>  	}
>  }

Right, smp_teardown stops already all CPUs except for the current one,
so this is the last one running here.

Reviewed-by: Thomas Huth <thuth@redhat.com>

