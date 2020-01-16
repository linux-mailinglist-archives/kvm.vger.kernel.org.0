Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE8513DD2A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 15:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgAPOPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 09:15:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgAPOPF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 09:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579184104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qKR5jXpRjZnhejjymOsQXrPhLoWNr4VigAggGKptAg=;
        b=HNO4uqCg3Saglq5cKLy+x3lO9saHrxrP+8MZaZAQHqEZk6oPVSbrTQnKDEz/4hKXFfHxx1
        xtvdlaUAsepXolqFG9IpKFX6qM9kBL9Mykco51Voqb/dnc027PNYKBotcVNnCcicI4Ks2b
        veWBJarIFVPLeTgBU05RuZlxxoVb7Is=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-cJjNy3w2PZ-tHwXJcphYVA-1; Thu, 16 Jan 2020 09:15:01 -0500
X-MC-Unique: cJjNy3w2PZ-tHwXJcphYVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D4831088389;
        Thu, 16 Jan 2020 14:15:00 +0000 (UTC)
Received: from gondolin (unknown [10.36.117.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71BBC5DA60;
        Thu, 16 Jan 2020 14:14:56 +0000 (UTC)
Date:   Thu, 16 Jan 2020 15:14:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] s390x: smp: Rework cpu start and
 active tracking
Message-ID: <20200116151453.186cbf94.cohuck@redhat.com>
In-Reply-To: <20200116120513.2244-5-frankja@linux.ibm.com>
References: <20200116120513.2244-1-frankja@linux.ibm.com>
        <20200116120513.2244-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 07:05:10 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> sigp is not synchronous on all hypervisors, so we need to wait until

"The architecture specifies that processing sigp orders may be
asynchronous, and this is indeed the case on some hypervisors, so..."

? (Or is that overkill?)

> the cpu runs until we return from the setup/start function.

s/until we return/before we return/

> 
> As there was a lot of duplicate code a common function for cpu

s/code/code,/

> restarts has been intropduced.

s/intropduced/introduced/

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/smp.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index f57f420..f984a34 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -104,35 +104,41 @@ int smp_cpu_stop_store_status(uint16_t addr)
>  	return rc;
>  }
>  
> +static int smp_cpu_restart_nolock(uint16_t addr, struct psw *psw)
> +{
> +	int rc;
> +	struct cpu *cpu = smp_cpu_from_addr(addr);
> +
> +	if (!cpu)
> +		return -1;
> +	if (psw) {
> +		cpu->lowcore->restart_new_psw.mask = psw->mask;
> +		cpu->lowcore->restart_new_psw.addr = psw->addr;
> +	}
> +	rc = sigp(addr, SIGP_RESTART, 0, NULL);
> +	if (rc)
> +		return rc;
> +	while (!smp_cpu_running(addr)) { mb(); }

Maybe split this statement? Also, maybe add a comment

/*
 * The order has been accepted, but the actual restart may not
 * have been performed yet, so wait until the cpu is running.
 */

?

> +	cpu->active = true;
> +	return 0;
> +}

The changes look good to me AFAICS.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

