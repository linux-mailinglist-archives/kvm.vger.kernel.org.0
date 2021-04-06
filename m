Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B904355817
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 17:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbhDFPgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 11:36:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234060AbhDFPfV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 11:35:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617723312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9dJXJkS2QPn1XQKPxb/+xfuE05p5cCmmoy2v2dYhg0=;
        b=IPSVQBp1PlphFpWYQJh1kGk3lACOkaO/2MQNaUgEMgSRKPHQuGK3boDIHlM3GBOKsS7yOD
        4//Qd39zuvCoSl45ZsjvhB1OdoEXlFLt1EUyYCCen0HiysoDdJNSsHCtwa9AzVZ+9izTnZ
        suiacGBj9l5PSNYN1qDO11F5sbAzc6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-7Su1V4uFNZy1CPIsESHlqA-1; Tue, 06 Apr 2021 11:35:09 -0400
X-MC-Unique: 7Su1V4uFNZy1CPIsESHlqA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5C18107B788;
        Tue,  6 Apr 2021 15:35:06 +0000 (UTC)
Received: from gondolin (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1DCC610F0;
        Tue,  6 Apr 2021 15:34:58 +0000 (UTC)
Date:   Tue, 6 Apr 2021 17:34:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 14/16] s390x: css: issuing SSCH when
 the channel is status pending
Message-ID: <20210406173456.30d0c246.cohuck@redhat.com>
In-Reply-To: <1617694853-6881-15-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-15-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Apr 2021 09:40:51 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We await CC=1 when we issue a SSCH on a channel with status pending.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h |  2 ++
>  s390x/css.c     | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 08b2974..3eb6957 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -90,6 +90,8 @@ struct scsw {
>  #define SCSW_ESW_FORMAT		0x04000000
>  #define SCSW_SUSPEND_CTRL	0x08000000
>  #define SCSW_KEY		0xf0000000
> +#define SCSW_SSCH_COMPLETED	(SCSW_CCW_FORMAT | SCSW_FC_START | SCSW_SC_PENDING | SCSW_SC_SECONDARY | \
> +				 SCSW_SC_PRIMARY)
>  	uint32_t ctrl;
>  	uint32_t ccw_addr;
>  #define SCSW_DEVS_DEV_END	0x04
> diff --git a/s390x/css.c b/s390x/css.c
> index f8c6688..52264f2 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -258,6 +258,15 @@ static void ssch_orb_fcx(void)
>  	orb->ctrl = tmp;
>  }
>  
> +static void ssch_status_pending(void)
> +{
> +	assert(ssch(test_device_sid, orb) == 0);
> +	report(ssch(test_device_sid, orb) == 1, "CC = 1");

I don't think that's correct in the general case (although it will work
for QEMU).

The PoP has a note about some models discarding the status pending, if
we have secondary status only (although I don't think that would happen
with this sequence.) You might also end up with cc 2 here, I think. In
theory, you could also get a cc 3 on real hardware, but that would be a
real edge case, and subsequent tests would fail anyway.

> +	/* now we clear the status */
> +	assert(tsch(test_device_sid, &irb) == 0);
> +	check_io_completion(test_device_sid, SCSW_SSCH_COMPLETED);
> +}
> +
>  static struct tests ssh_tests[] = {
>  	{ "privilege", ssch_privilege },
>  	{ "orb cpa zero", ssch_orb_cpa_zero },
> @@ -269,6 +278,7 @@ static struct tests ssh_tests[] = {
>  	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
>  	{ "ORB extensions", ssch_orb_extension},
>  	{ "FC extensions", ssch_orb_fcx},
> +	{ "status pending before ssch", ssch_status_pending},
>  	{ NULL, NULL }
>  };
>  

