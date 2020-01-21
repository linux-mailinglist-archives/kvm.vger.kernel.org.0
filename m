Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5A2143F83
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 15:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgAUO2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 09:28:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727255AbgAUO2y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 09:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579616933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LxxNnY1rAyCDccuN/PEfPqIre2nRFy4Xi4Kq8vWTHm8=;
        b=Nbw9wuDvcESV1yXSJAbqMFtIfUEBPNgj2LTxQrrz584niU0t5uKboSM3cSss1maOGdMuht
        P7LR6OPXMVEKe5XqF+KBMsWUUzJkaPYPQeSXs+0Vv4bgoGRS6oqKYGzqyzLLm0BtH2atsB
        pyX8ruC8STrUcwYVj+niKr8NPFavFJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-y9hCvqekNWmVDr--JeUYgg-1; Tue, 21 Jan 2020 09:28:51 -0500
X-MC-Unique: y9hCvqekNWmVDr--JeUYgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B91D71005513;
        Tue, 21 Jan 2020 14:28:50 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21CF880627;
        Tue, 21 Jan 2020 14:28:46 +0000 (UTC)
Date:   Tue, 21 Jan 2020 15:28:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 6/9] s390x: smp: Loop if secondary cpu
 returns into cpu setup again
Message-ID: <20200121152844.22fd9e03.cohuck@redhat.com>
In-Reply-To: <20200121134254.4570-7-frankja@linux.ibm.com>
References: <20200121134254.4570-1-frankja@linux.ibm.com>
        <20200121134254.4570-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jan 2020 08:42:51 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Up to now a secondary cpu could have returned from the function it was
> executing and ending up somewhere in cstart64.S. This was mostly
> circumvented by an endless loop in the function that it executed.
> 
> Let's add a loop to the end of the cpu setup, so we don't have to rely
> on added loops in the tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/cstart64.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 9af6bb3..5fd8d2f 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -162,6 +162,8 @@ smp_cpu_setup_state:
>  	/* We should only go once through cpu setup and not for every restart */
>  	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
>  	br	%r14
> +	/* If the function returns, just loop here */
> +0:	j	0
>  
>  pgm_int:
>  	SAVE_REGS

Acked-by: Cornelia Huck <cohuck@redhat.com>

