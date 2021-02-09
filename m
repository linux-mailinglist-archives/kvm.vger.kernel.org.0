Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0915E315177
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhBIOW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:22:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30140 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231627AbhBIOWo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 09:22:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612880475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmOCO/CZ7jC50hfqD2msGOaEG56/3k+thICsAvimHwk=;
        b=ARnor9Cg0etYdDW0WOsMhAbHLlTpAm4XP/gnZ0m8ibHOPl+2hW38jmsJGSOcHJeKZ9CeJd
        82J1q59y8BlcFwCPPJrO9CmjVNtU5zrY7vIvbUX0dxKoAr9/PeISePhMuVSTXmqy1I04Lz
        FU13aUOdlB/d42GCkzsRIUQR7MyH1Bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-s7suOJwrO5-L67RNx0pvYQ-1; Tue, 09 Feb 2021 09:21:13 -0500
X-MC-Unique: s7suOJwrO5-L67RNx0pvYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D27751935780;
        Tue,  9 Feb 2021 14:21:11 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-56.ams2.redhat.com [10.36.114.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A077519C59;
        Tue,  9 Feb 2021 14:21:07 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] s390x: Workaround smp stop and store
 status race
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        imbrenda@linux.ibm.com
References: <20210209141554.22554-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <10fd2ab0-3a36-7739-8644-e6e6ad3607f5@redhat.com>
Date:   Tue, 9 Feb 2021 15:21:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209141554.22554-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 15.15, Janosch Frank wrote:
> KVM and QEMU handle a SIGP stop and store status in two steps:
> 1) Stop the CPU by injecting a stop request
> 2) Store when the CPU has left SIE because of the stop request
> 
> The problem is that the SIGP order is already considered completed by
> KVM/QEMU when step 1 has been performed and not once both have
> completed. In addition we currently don't implement the busy CC so a
> kernel has no way of knowing that the store has finished other than
> checking the location for the store.
> 
> This workaround is based on the fact that for a new SIE entry (via the
> added smp restart) a stop with the store status has to be finished
> first.
> 
> Correct handling of this in KVM/QEMU will need some thought and time.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   s390x/smp.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/smp.c b/s390x/smp.c
> index b0ece491..32f284a2 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -102,12 +102,15 @@ static void test_stop_store_status(void)
>   	lc->grs_sa[15] = 0;
>   	smp_cpu_stop_store_status(1);
>   	mb();
> +	report(smp_cpu_stopped(1), "cpu stopped");
> +	/* For the cpu to be started it should have finished storing */
> +	smp_cpu_restart(1);
>   	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
>   	report(lc->grs_sa[15], "stack");
> -	report(smp_cpu_stopped(1), "cpu stopped");
>   	report_prefix_pop();
>   
>   	report_prefix_push("stopped");
> +	smp_cpu_stop(1);
>   	lc->prefix_sa = 0;
>   	lc->grs_sa[15] = 0;
>   	smp_cpu_stop_store_status(1);

Thanks, this fixes the flaky test for me!

Tested-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>


