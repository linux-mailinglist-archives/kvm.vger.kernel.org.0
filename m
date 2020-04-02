Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AADBA19C6F0
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 18:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389788AbgDBQTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 12:19:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389458AbgDBQTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 12:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585844369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=85/xyrCo8QjmlhKA4FcVRatCKUNg8UqQsOxjVD1bFWU=;
        b=NVWpZExVUMRnCcYv+zbacTLL0AL1o5UsYTNml2lz4W7zqfPGcZMpTNDrhcrm+4raI4uTLq
        fon4ZP9lB2e1OkVm4DtQ2gjhiNjxzkXHmwXtfJE7SH9p3b2K8u6m2NqDAaS/VCKwTC+JJ5
        eyFnptPOwyPdkq3eeCmAZis/DI9RSOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-G_ch5ApxMp6UUpC7rLCB_w-1; Thu, 02 Apr 2020 12:19:27 -0400
X-MC-Unique: G_ch5ApxMp6UUpC7rLCB_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 102118017CE;
        Thu,  2 Apr 2020 16:19:26 +0000 (UTC)
Received: from gondolin (ovpn-113-176.ams2.redhat.com [10.36.113.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FED919C69;
        Thu,  2 Apr 2020 16:19:22 +0000 (UTC)
Date:   Thu, 2 Apr 2020 18:19:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v3] s390x/smp: add minimal test for sigp sense
 running status
Message-ID: <20200402181919.4662ecb0.cohuck@redhat.com>
In-Reply-To: <20200402154441.13063-1-borntraeger@de.ibm.com>
References: <20200402154441.13063-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Apr 2020 11:44:41 -0400
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Two minimal tests:
> - our own CPU should be running when we check ourselves
> - a CPU should at least have some times with a not running
> indication. To speed things up we stop CPU1
> 
> Also rename smp_cpu_running to smp_sense_running_status.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  lib/s390x/smp.c |  2 +-
>  lib/s390x/smp.h |  2 +-
>  s390x/smp.c     | 15 +++++++++++++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
>

(...)

> diff --git a/s390x/smp.c b/s390x/smp.c
> index 79cdc1f..4450aff 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -210,6 +210,20 @@ static void test_emcall(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_sense_running(void)
> +{
> +	report_prefix_push("sense_running");
> +	/* we are running */

Maybe /* we (CPU0) are running */ ?

> +	report(smp_sense_running_status(0), "CPU0 sense claims running");
> +	/* make sure CPU is stopped to speed up the not running case */

"the target CPU" ?

> +	smp_cpu_stop(1);
> +	/* Make sure to have at least one time with a not running indication */
> +	while(smp_sense_running_status(1));
> +	report(true, "CPU1 sense claims not running");
> +	report_prefix_pop();
> +}
> +
> +
>  /* Used to dirty registers of cpu #1 before it is reset */
>  static void test_func_initial(void)
>  {

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

