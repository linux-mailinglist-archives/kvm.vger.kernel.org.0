Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85C435588B
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbhDFPwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:52:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230125AbhDFPwI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:52:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617724320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WJ63vzERZCNyN9qZibHxIXWrDklJSNUPg81NRXGfTMM=;
        b=R6f4NZ20ejmNEeQH6kTgIR27a9CIiYcrF8L2XEva3RQP0XTJN3x/pY7bVKke3RcvIHV897
        8c7AWqT8BkJejDK+1cuOP5DjeaGQarvnT5aI/SNjcymPw/gdgwo6Fr9obm80wpZF2z1Mii
        UOqui2m5qUWZy+sUyPJ5TCsW+8OcD7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Z7VN45TMNUWknDMmoUN6aw-1; Tue, 06 Apr 2021 11:51:59 -0400
X-MC-Unique: Z7VN45TMNUWknDMmoUN6aw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 247DC10866A3;
        Tue,  6 Apr 2021 15:51:58 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B1405D75A;
        Tue,  6 Apr 2021 15:51:39 +0000 (UTC)
Date:   Tue, 6 Apr 2021 17:51:36 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 12/16] s390x: css: Check ORB reserved
 bits
Message-ID: <20210406175136.1d7d7fa2.cohuck@redhat.com>
In-Reply-To: <1617694853-6881-13-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-13-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 09:40:49 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Several bits of the ORB are reserved and must be zero.
> Their use will trigger a operand exception.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  s390x/css.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 56adc16..26f5da6 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -209,6 +209,26 @@ static void ssch_orb_midaw(void)
>  	orb->ctrl = tmp;
>  }
>  
> +static void ssch_orb_ctrl(void)
> +{
> +	uint32_t tmp = orb->ctrl;
> +	char buffer[80];
> +	int i;
> +
> +	/* Check the reserved bits of the ORB CTRL field */
> +	for (i = 26; i <= 30; i++) {

This looks very magic; can we get some defines?

> +		orb->ctrl |= (0x01 << (31 - i));
> +		snprintf(buffer, 80, " %d", i);
> +		report_prefix_push(buffer);
> +		expect_pgm_int();
> +		ssch(test_device_sid, orb);
> +		check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +		report_prefix_pop();
> +
> +		orb->ctrl = tmp;
> +	}
> +}
> +
>  static struct tests ssh_tests[] = {
>  	{ "privilege", ssch_privilege },
>  	{ "orb cpa zero", ssch_orb_cpa_zero },
> @@ -217,6 +237,7 @@ static struct tests ssh_tests[] = {
>  	{ "CCW access", ssch_ccw_access },
>  	{ "CCW in DMA31", ssch_ccw_dma31 },
>  	{ "ORB MIDAW unsupported", ssch_orb_midaw },
> +	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
>  	{ NULL, NULL }
>  };
>  

