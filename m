Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1428130BD78
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 12:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhBBLxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 06:53:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230221AbhBBLxr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 06:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612266741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWzpCe0AFGllkbBagXKy+jQnPqCeMhVmegpfmsTMClM=;
        b=C/UJmrzF+hAe3amtAXGuXP5e1a8eAdxObdpMNqYUVD3ynJYIYxhLZZ84QTdSsFhomnx0Zg
        BdLUEcgbT1+Scl1MSncQmpDuaOCMcikxvTKq0V5ZM6P1p8MnYk76oqzelNm0CSPkYF1E/g
        KUQyq7P5AkAnhmAkBcL4NoIev6j7bG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-OyWyoO2ZPSS8xrvoEuN9ew-1; Tue, 02 Feb 2021 06:52:17 -0500
X-MC-Unique: OyWyoO2ZPSS8xrvoEuN9ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7720C100962A;
        Tue,  2 Feb 2021 11:52:16 +0000 (UTC)
Received: from gondolin (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6ECE5D9D5;
        Tue,  2 Feb 2021 11:52:11 +0000 (UTC)
Date:   Tue, 2 Feb 2021 12:52:09 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 5/5] s390x: css: testing measurement
 block format 1
Message-ID: <20210202125209.4ef8b66c.cohuck@redhat.com>
In-Reply-To: <1611930869-25745-6-git-send-email-pmorel@linux.ibm.com>
References: <1611930869-25745-1-git-send-email-pmorel@linux.ibm.com>
        <1611930869-25745-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 29 Jan 2021 15:34:29 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Measurement block format 1 is made available by the extended
> mesurement block facility and is indicated in the SCHIB by
> the bit in the PMCW.
> 
> The MBO is specified in the SCHIB of each channel and the MBO
> defined by the SCHM instruction is ignored.
> 
> The test of the MB format 1 is just skip if the feature is

s/skip/skipped/

> not available.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 

(...)

> @@ -208,6 +251,14 @@ static void test_schm(void)
>  	schm(mb0, SCHM_MBU);
>  	test_schm_fmt0(mb0);
>  
> +	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
> +	if (!mb1) {

I'm wondering whether you should move this into the format 1
invocation, so you won't try to allocate memory if format 1 is not even
supported.

> +		report(0, "mesurement_block_format0 allocation");

In any case, s/mesurement_block_format0/measurement_block_format1/ :)

> +		goto end_free;
> +	}
> +	test_schm_fmt1(mb1);
> +
> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));
>  end_free:
>  	free_io_mem(mb0, sizeof(struct measurement_block_format0));
>  }

