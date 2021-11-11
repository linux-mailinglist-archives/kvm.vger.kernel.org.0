Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECC44D2A9
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 08:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbhKKHuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 02:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhKKHuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 02:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636616851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwcb2T7fSKiv5IrFFXaKqs6OBH5tXgIxxOZUu3zr0og=;
        b=MC2Iv6UxA0Gh76OPQESw9JM8LH46AtA1aSsENukldpHy0MdPTFLLASvD9BpsYkW5mbH5H4
        rPNCtOu3Lt4EY0rmcQO8LrJyaP9GLYWu4z56NYtUhhwlJhosBiDgh2xUcJ4u4N6BFYTIfv
        gl6JbyyeXDnIq+jvxYRB7ZW7+SX9qdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-8O7IuMrPP8K38DloTkev8w-1; Thu, 11 Nov 2021 02:47:29 -0500
X-MC-Unique: 8O7IuMrPP8K38DloTkev8w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 928CC80B724;
        Thu, 11 Nov 2021 07:47:28 +0000 (UTC)
Received: from [10.33.192.183] (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4E5C69214;
        Thu, 11 Nov 2021 07:47:24 +0000 (UTC)
Message-ID: <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
Date:   Thu, 11 Nov 2021 08:47:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Janosch Frank <frankja@de.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022131057.1308851-1-scgl@linux.ibm.com>
 <20211022131057.1308851-2-scgl@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: Add specification exception
 interception test
In-Reply-To: <20211022131057.1308851-2-scgl@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/2021 15.10, Janis Schoetterl-Glausch wrote:
> Check that specification exceptions cause intercepts when
> specification exception interpretation is off.
> Check that specification exceptions caused by program new PSWs
> cause interceptions.
> We cannot assert that non program new PSW specification exceptions
> are interpreted because whether interpretation occurs or not is
> configuration dependent.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@de.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
...
> +	report_prefix_push("on");
> +	vm.sblk->ecb |= ECB_SPECI;
> +	reset_guest();
> +	sie(&vm);
> +	/* interpretation on -> configuration dependent if initial exception causes
> +	 * interception, but invalid new program PSW must
> +	 */
> +	report(vm.sblk->icptcode == ICPT_PROGI
> +	       && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
> +	       "Received specification exception intercept");
> +	if (vm.sblk->gpsw.addr == 0xdeadbeee)
> +		report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
> +	else
> +		report_info("Did not interpret initial exception");

  Hi Janis!

While using this test in our downstream verification of the backport of the 
related kernel patch, it occurred that the way of only reporting the 
interpreted exception via report_info() is rather unfortunate for using this 
test in automatic regression runs. For such regression runs, it would be 
good if the test would be marked with FAIL if the exception was not 
interpreted. I know, the interpretation facility is not always there, but 
still would it be somehow possible to add such a mode? E.g. by checking the 
machine generation (is this always available with z15 and newer?) and maybe 
adding a CLI option to force the hard check (so that e.g. "-f" triggers the 
failure if the exception has not been interpreted, while running the test 
without "-f" would still do the old behavior instead)?

  Thomas

