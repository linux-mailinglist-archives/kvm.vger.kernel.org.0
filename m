Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F0190DCC
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgCXMiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:38:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:23000 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727223AbgCXMiw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585053531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uftN846mv5IA+0FxdsilX9S+UyWk5Djyev1MZNlUGc=;
        b=Y7LTRNNa2vG5YB8fUM5MGmVZcVpsU3+EQc//wNo1r8TO3PezV2Mx8EB8CwEgmxlg2ELtB7
        iQanNwGFLj90+qHPqDJQRAlgSVkMwmXEB492b2gLIXDbY2BcJiYpsOGWLOZ/qWRBJj21kA
        QjZCRkgYz29bUzIB2QpG9XohLndUxUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-GeSMFY-tM5SWbUVumqF6Bg-1; Tue, 24 Mar 2020 08:38:49 -0400
X-MC-Unique: GeSMFY-tM5SWbUVumqF6Bg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BD301005510;
        Tue, 24 Mar 2020 12:38:48 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 193BBA0A67;
        Tue, 24 Mar 2020 12:38:41 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:38:39 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 08/10] s390x: smp: Wait for sigp
 completion
Message-ID: <20200324133839.10efabf1.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-9-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-9-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:49 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Sigp orders are not necessarily finished when the processor finished
> the sigp instruction. We need to poll if the order has been finished
> before we continue.
> 
> For (re)start and stop we already use sigp sense running and sigp
> sense loops. But we still lack completion checks for stop and store
> status, as well as the cpu resets.
> 
> Let's add them.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/smp.c | 8 ++++++++
>  lib/s390x/smp.h | 1 +
>  s390x/smp.c     | 4 ++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 6ef0335954fd4832..2555bf4f5e73d762 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -154,6 +154,14 @@ int smp_cpu_start(uint16_t addr, struct psw psw)
>  	return rc;
>  }
>  
> +void smp_cpu_wait_for_completion(uint16_t addr)

Hm, that is more wait-for-idle than wait-for-completion, I guess? But
only semantics, no need to change that.

> +{
> +	uint32_t status;
> +
> +	/* Loops when cc == 2, i.e. when the cpu is busy with a sigp order */
> +	sigp_retry(1, SIGP_SENSE, 0, &status);
> +}
> +
>  int smp_cpu_destroy(uint16_t addr)
>  {
>  	struct cpu *cpu;
> diff --git a/lib/s390x/smp.h b/lib/s390x/smp.h
> index ce63a89880c045f3..a8b98c0fcf2b451c 100644
> --- a/lib/s390x/smp.h
> +++ b/lib/s390x/smp.h
> @@ -45,6 +45,7 @@ int smp_cpu_restart(uint16_t addr);
>  int smp_cpu_start(uint16_t addr, struct psw psw);
>  int smp_cpu_stop(uint16_t addr);
>  int smp_cpu_stop_store_status(uint16_t addr);
> +void smp_cpu_wait_for_completion(uint16_t addr);
>  int smp_cpu_destroy(uint16_t addr);
>  int smp_cpu_setup(uint16_t addr, struct psw psw);
>  void smp_teardown(void);
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 74622113a2c4ad92..48321f4e346dc71d 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -75,6 +75,7 @@ static void test_stop_store_status(void)
>  	lc->prefix_sa = 0;
>  	lc->grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
> +	smp_cpu_wait_for_completion(1);
>  	mb();
>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
>  	report(lc->grs_sa[15], "stack");
> @@ -85,6 +86,7 @@ static void test_stop_store_status(void)
>  	lc->prefix_sa = 0;
>  	lc->grs_sa[15] = 0;
>  	smp_cpu_stop_store_status(1);
> +	smp_cpu_wait_for_completion(1);
>  	mb();
>  	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore, "prefix");
>  	report(lc->grs_sa[15], "stack");
> @@ -215,6 +217,7 @@ static void test_reset_initial(void)
>  	wait_for_flag();
>  
>  	sigp_retry(1, SIGP_INITIAL_CPU_RESET, 0, NULL);
> +	smp_cpu_wait_for_completion(1);
>  	sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, NULL);
>  
>  	report_prefix_push("clear");
> @@ -264,6 +267,7 @@ static void test_reset(void)
>  	smp_cpu_start(1, psw);
>  
>  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
> +	smp_cpu_wait_for_completion(1);
>  	report(smp_cpu_stopped(1), "cpu stopped");
>  
>  	set_flag(0);

I'm wondering whether there's a place for a
sigp-and-wait-for-completion function. But that's probably overkill.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

