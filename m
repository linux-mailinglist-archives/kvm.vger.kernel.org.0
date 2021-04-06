Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA9355880
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346027AbhDFPux (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346008AbhDFPuo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617724235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnbXBo7tEO27FFpU/yfGuiAx13yYtpbdSKoY6qIhdAc=;
        b=gspAgKA3sh43Mhi2249Rvx9muH6InR5sd+H4QVFneAkdyCyrAhGipHzkvqBLjHUEi2ODPV
        DyXduUNBwqfmJgZS8uh+0H43smtpQbsNLdz2tgNaQj/PlPWPfgwtvlyYbyHBPVcJZV0jbL
        HVfhUcK0dc38TAXoiiI7AMiAetxE7xw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-Ni6QRetuOIWAxCCSot0oEw-1; Tue, 06 Apr 2021 11:50:34 -0400
X-MC-Unique: Ni6QRetuOIWAxCCSot0oEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB3ED10866A3;
        Tue,  6 Apr 2021 15:50:32 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D42B60240;
        Tue,  6 Apr 2021 15:50:27 +0000 (UTC)
Date:   Tue, 6 Apr 2021 17:50:24 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 13/16] s390x: css: checking for CSS
 extensions
Message-ID: <20210406175024.44fe7473.cohuck@redhat.com>
In-Reply-To: <1617694853-6881-14-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-14-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 09:40:50 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We verify that these extensions are not install before running simple

s/not install/installed/ ?

Testing extensions that are not installed does not make that much sense
:)

> tests.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h |  2 ++
>  s390x/css.c     | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index d824e34..08b2974 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -338,7 +338,9 @@ struct chsc_scsc {
>  	uint8_t reserved[9];
>  	struct chsc_header res;
>  	uint32_t res_fmt;
> +#define CSSC_ORB_EXTENSIONS		0
>  #define CSSC_EXTENDED_MEASUREMENT_BLOCK 48
> +#define CSSC_FC_EXTENSIONS		88
>  	uint64_t general_char[255];
>  	uint64_t chsc_char[254];
>  };
> diff --git a/s390x/css.c b/s390x/css.c
> index 26f5da6..f8c6688 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -229,6 +229,35 @@ static void ssch_orb_ctrl(void)
>  	}
>  }
>  
> +static void ssch_orb_extension(void)
> +{
> +	if (!css_test_general_feature(CSSC_ORB_EXTENSIONS)) {
> +		report_skip("ORB extensions not installed");
> +		return;
> +	}
> +	/* Place holder for checking ORB extensions */
> +	report_info("ORB extensions installed but not tested");
> +}
> +
> +static void ssch_orb_fcx(void)
> +{
> +	uint32_t tmp = orb->ctrl;
> +
> +	if (!css_test_general_feature(CSSC_FC_EXTENSIONS)) {
> +		report_skip("Fibre-channel extensions not installed");
> +		return;
> +	}
> +
> +	report_prefix_push("Channel-Program Type Control");
> +	orb->ctrl |= ORB_CTRL_CPTC;
> +	expect_pgm_int();
> +	ssch(test_device_sid, orb);
> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> +	report_prefix_pop();

I don't quite understand what you're testing here; shouldn't the device
accept a transport-mode orb if fcx is installed? The problem would be
if the program consists of ccws instead, so it's more a malformed block
handling test?

> +
> +	orb->ctrl = tmp;
> +}
> +
>  static struct tests ssh_tests[] = {
>  	{ "privilege", ssch_privilege },
>  	{ "orb cpa zero", ssch_orb_cpa_zero },
> @@ -238,6 +267,8 @@ static struct tests ssh_tests[] = {
>  	{ "CCW in DMA31", ssch_ccw_dma31 },
>  	{ "ORB MIDAW unsupported", ssch_orb_midaw },
>  	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
> +	{ "ORB extensions", ssch_orb_extension},
> +	{ "FC extensions", ssch_orb_fcx},
>  	{ NULL, NULL }
>  };
>  

