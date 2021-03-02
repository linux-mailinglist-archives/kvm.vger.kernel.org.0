Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0837832A6E8
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837529AbhCBPyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:54:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347752AbhCBF4a (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 00:56:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614664471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Rp1Q80Hcz7cPjRqeV/AybsDsuiqKchh0xCxYRghwQc=;
        b=B95dabTQHzhBpvGQq0x9BApOhBU3TfOP6FIKFoTlz0wpRnNfabzXO6cRS+0O2CiNhX92vE
        4IS1iXvWRRLpaY1uIYSlPWnFs2vCe31Db5usm1lr7VtNOnqvjFPHUt8m6atxlnnjx0X3Kh
        DrC/2LWEqoTAgyt6Eflb8yQxnTvV77Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-vSAdr2bwP6W89n7e47ZrdA-1; Tue, 02 Mar 2021 00:54:29 -0500
X-MC-Unique: vSAdr2bwP6W89n7e47ZrdA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13F0018B9ECA;
        Tue,  2 Mar 2021 05:54:28 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-57.ams2.redhat.com [10.36.112.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D1006F981;
        Tue,  2 Mar 2021 05:54:23 +0000 (UTC)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210301182830.478145-1-imbrenda@linux.ibm.com>
 <20210301182830.478145-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/3] s390x: mvpg: simple test
Message-ID: <88a8003c-fb66-e2d2-455e-b2b83b76c59e@redhat.com>
Date:   Tue, 2 Mar 2021 06:54:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210301182830.478145-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/03/2021 19.28, Claudio Imbrenda wrote:
> A simple unit test for the MVPG instruction.
> 
> The timeout is set to 10 seconds because the test should complete in a
> fraction of a second even on busy machines. If the test is run in VSIE
> and the host of the host is not handling MVPG properly, the test will
> probably hang.
> 
> Testing MVPG behaviour in VSIE is the main motivation for this test.
> 
> Anything related to storage keys is not tested.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
[...]
> +static void test_success(void)
> +{
> +	int cc;
> +
> +	report_prefix_push("success");
> +	/* Test successful scenarios, both in supervisor and problem state */
> +	cc = mvpg(0, buffer, source);
> +	report(page_ok(buffer) && !cc, "Supervisor state MVPG successful");

I'd maybe add a memset(buffer, 0xff, PAGE_SIZE) here to make sure that the 
buffer really gets re-written before the next page_ok() check.

> +	enter_pstate();
> +	cc = mvpg(0, buffer, source);
> +	leave_pstate();
> +	report(page_ok(buffer) && !cc, "Problem state MVPG successful");
> +
> +	report_prefix_pop();
> +}

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>

