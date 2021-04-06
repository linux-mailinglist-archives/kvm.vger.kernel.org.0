Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1407B3558A3
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346143AbhDFP6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:58:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40993 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhDFP6e (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617724706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+BEIJltezt+la/MXC+ZbcxgPcw5iDzUUXt4Vaphd/k=;
        b=Q4vI94WgicXbx6rXIoG/G/P7j378JAhrWWhTN3/EUxT0ApegEeF/FuN0nDCqjn+ZplVmq2
        PHYDHMWQzoFjDFaHDIb0MDpAFxtT8tmi8Sgpfiou1O1V0age2jWiA5HEx61R4XFpynEHXn
        JDBIBlcU0Mm3E4woCmN3lFcv9zpbZdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-QJc-vSUaPEuP0YginGKGTg-1; Tue, 06 Apr 2021 11:58:23 -0400
X-MC-Unique: QJc-vSUaPEuP0YginGKGTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19F3D1853043;
        Tue,  6 Apr 2021 15:58:10 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75013705BF;
        Tue,  6 Apr 2021 15:58:08 +0000 (UTC)
Date:   Tue, 6 Apr 2021 17:58:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 11/16] s390x: css: No support for
 MIDAW
Message-ID: <20210406175805.304b8abb.cohuck@redhat.com>
In-Reply-To: <1617694853-6881-12-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-12-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 09:40:48 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Verify that using MIDAW triggers a operand exception.

This is only for current QEMU; a future QEMU or another hypervisor may
support it. I think in those cases the failure mode may be different
(as the ccw does not use midaws?)

> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index f8f91cf..56adc16 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -197,6 +197,18 @@ static void ssch_ccw_dma31(void)
>  	free_pages(ccw_high);
>  }
>  
> +static void ssch_orb_midaw(void)
> +{
> +	uint32_t tmp = orb->ctrl;
> +
> +	orb->ctrl |= ORB_CTRL_MIDAW;
> +	expect_pgm_int();
> +	ssch(test_device_sid, orb);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +
> +	orb->ctrl = tmp;
> +}
> +
>  static struct tests ssh_tests[] = {
>  	{ "privilege", ssch_privilege },
>  	{ "orb cpa zero", ssch_orb_cpa_zero },
> @@ -204,6 +216,7 @@ static struct tests ssh_tests[] = {
>  	{ "data access", ssch_data_access },
>  	{ "CCW access", ssch_ccw_access },
>  	{ "CCW in DMA31", ssch_ccw_dma31 },
> +	{ "ORB MIDAW unsupported", ssch_orb_midaw },
>  	{ NULL, NULL }
>  };
>  

