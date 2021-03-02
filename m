Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794F232A6E9
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837882AbhCBPym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1577314AbhCBGAp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 01:00:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614664759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7N81UneaT15FTWMRVAiCSKrt2qbXBuVlqjI/ib8b7PA=;
        b=hILWCCBWPZ8tCifpYQ+5gMdAoEKrcc4Ih8AAr5w4jjPGWr18KZZJD/2dOsD5jMnWypZ0rc
        YmRrQpqSIkbVc5sxIi0wyRW01H21LEtYpYtXKLMXxq0zgsJ54yuV8SyN6lyK/JkNAx9qoe
        fehmJ/Jelfzkqv6FbYO9YhQTpDBs/XY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-G-uKrksTNPivnbRIMv0pZA-1; Tue, 02 Mar 2021 00:59:16 -0500
X-MC-Unique: G-uKrksTNPivnbRIMv0pZA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A069510066EF;
        Tue,  2 Mar 2021 05:59:15 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-57.ams2.redhat.com [10.36.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F226B1F452;
        Tue,  2 Mar 2021 05:59:10 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: mvpg: skip some tests when
 using TCG
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210301182830.478145-1-imbrenda@linux.ibm.com>
 <20210301182830.478145-4-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2104a18d-e68b-cae8-8f9c-3b49bdde3f19@redhat.com>
Date:   Tue, 2 Mar 2021 06:59:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210301182830.478145-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/03/2021 19.28, Claudio Imbrenda wrote:
> TCG is known to fail these tests, so add an explicit exception to skip them.
> 
> Once TCG has been fixed, it will be enough to revert this patch.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/mvpg.c | 31 +++++++++++++++++++------------
>   1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/s390x/mvpg.c b/s390x/mvpg.c
> index 792052ad..148095e0 100644
> --- a/s390x/mvpg.c
> +++ b/s390x/mvpg.c
> @@ -20,6 +20,7 @@
>   #include <smp.h>
>   #include <alloc_page.h>
>   #include <bitops.h>
> +#include <vm.h>
>   
>   /* Used to build the appropriate test values for register 0 */
>   #define KFC(x) ((x) << 10)
> @@ -224,20 +225,26 @@ static void test_mmu_prot(void)
>   	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
>   	fresh += PAGE_SIZE;
>   
> -	protect_page(fresh, PAGE_ENTRY_I);
> -	cc = mvpg(CCO, fresh, source);
> -	report(cc == 1, "destination invalid");
> -	fresh += PAGE_SIZE;
> +	if (vm_is_tcg()) {
> +		report_skip("destination invalid");
> +		report_skip("source invalid");
> +		report_skip("source and destination invalid");

You could also use report_xfail(vm_is_tcg(), ...) instead. That shows that 
there are still problems without failing CI runs.

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

