Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F951D2F21
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgENMGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 08:06:04 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30820 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726160AbgENMGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 08:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589457963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2turSXxj58dWtI4E5GvG/JsmoKcrappaPKE1Pq7AuaM=;
        b=KJQ503ZYEjFM23xx6dvYxYktKn2FITdPNbHHdY3soepvGXyvadcWOVObHLNy5MGQsYmzj9
        dc+G+f+Srru8ZnTrL/QtpTsS65EoPMpWHb5qgfmJVAvQU0AmgGdz7pf7m7Uf7Tnq73oNE8
        Sf5medrfMV5YtUYUDGr12SgwdKqutr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-AQyggWWVPD2gyf6Wivh1ZA-1; Thu, 14 May 2020 08:06:01 -0400
X-MC-Unique: AQyggWWVPD2gyf6Wivh1ZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23DB9835B42;
        Thu, 14 May 2020 12:06:00 +0000 (UTC)
Received: from gondolin (unknown [10.40.192.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6C007D930;
        Thu, 14 May 2020 12:05:55 +0000 (UTC)
Date:   Thu, 14 May 2020 14:05:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 06/10] s390x: css: stsch, enumeration
 test
Message-ID: <20200514140552.107abbde.cohuck@redhat.com>
In-Reply-To: <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
References: <1587725152-25569-1-git-send-email-pmorel@linux.ibm.com>
        <1587725152-25569-7-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 12:45:48 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction, we do not test the

s/of/of the/

> reaction of the VM for an instruction with wrong parameters.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  s390x/Makefile      |  2 +
>  s390x/css.c         | 92 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 ++
>  4 files changed, 99 insertions(+)
>  create mode 100644 s390x/css.c
> 

(...)

> +static void test_enumerate(void)
> +{
> +	struct pmcw *pmcw = &schib.pmcw;
> +	int cc;
> +	int scn;
> +	int scn_found = 0;
> +	int dev_found = 0;
> +
> +	for (scn = 0; scn < 0xffff; scn++) {
> +		cc = stsch(scn|SID_ONE, &schib);
> +		switch (cc) {
> +		case 0:		/* 0 means SCHIB stored */
> +			break;
> +		case 3:		/* 3 means no more channels */
> +			goto out;
> +		default:	/* 1 or 2 should never happened for STSCH */

s/happened/happen/

> +			report(0, "Unexpected cc=%d on subchannel number 0x%x",
> +			       cc, scn);
> +			return;
> +		}

