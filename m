Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AF6322E57
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbhBWQHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 11:07:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232599AbhBWQHC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 11:07:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614096333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoPC4OqBQYYaZDbfxiMN7pyWyOMJZgNc23RJ9DQ6oNM=;
        b=XQ9Ko+EHYUQwQxnNLl4a10Rx3eYAgnVo03YBmpsJKE19+U3ZrWrAVUMIRYG1YgnXyzFo/y
        QCpIjSBZZBG1An+PtUVrB0wpreFmIFwj4FGA5xt9ElOpXZQw3+8Eem9w/paTt3VM9oR+5A
        67TTjo5RHOe8s5GRLA5e2HI603WtjyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-KbvUFR3QPHq8FAPw3pcciw-1; Tue, 23 Feb 2021 11:05:26 -0500
X-MC-Unique: KbvUFR3QPHq8FAPw3pcciw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4E9036493;
        Tue, 23 Feb 2021 16:05:21 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC41B60C6C;
        Tue, 23 Feb 2021 16:05:14 +0000 (UTC)
Date:   Tue, 23 Feb 2021 17:05:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: css: testing measurement
 block format 0
Message-ID: <20210223170512.39db5cab.cohuck@redhat.com>
In-Reply-To: <c0af463a-d5ae-d84e-7a37-217bed4aeb78@linux.ibm.com>
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
        <1613669204-6464-5-git-send-email-pmorel@linux.ibm.com>
        <20210223142730.4509bfc3.cohuck@redhat.com>
        <c0af463a-d5ae-d84e-7a37-217bed4aeb78@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Feb 2021 16:49:56 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2/23/21 2:27 PM, Cornelia Huck wrote:
> > On Thu, 18 Feb 2021 18:26:43 +0100
> > Pierre Morel <pmorel@linux.ibm.com> wrote:

> >> + */
> >> +static void test_schm_fmt0(void)
> >> +{
> >> +	struct measurement_block_format0 *mb0;
> >> +	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
> >> +
> >> +	report_prefix_push("Format 0");
> >> +
> >> +	/* Allocate zeroed Measurement block */
> >> +	mb0 = alloc_io_mem(shared_mb_size, 0);
> >> +	if (!mb0) {
> >> +		report_abort("measurement_block_format0 allocation failed");
> >> +		goto end;
> >> +	}
> >> +
> >> +	schm(NULL, 0); /* Stop any previous measurement */  
> > 
> > Probably not strictly needed, but cannot hurt.  
> yes
> 
> >   
> >> +	schm(mb0, SCHM_MBU);
> >> +
> >> +	/* Expect success */
> >> +	report_prefix_push("Valid MB address and index 0");
> >> +	report(start_measure(0, 0, false) &&
> >> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
> >> +	       "SSCH measured %d", mb0->ssch_rsch_count);
> >> +	report_prefix_pop();
> >> +
> >> +	/* Clear the measurement block for the next test */
> >> +	memset(mb0, 0, shared_mb_size);
> >> +
> >> +	/* Expect success */
> >> +	report_prefix_push("Valid MB address and index 1");
> >> +	report(start_measure(0, 1, false) &&
> >> +	       mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
> >> +	       "SSCH measured %d", mb0[1].ssch_rsch_count);
> >> +	report_prefix_pop();
> >> +
> >> +	schm(NULL, 0); /* Stop the measurement */  
> > 
> > Shouldn't you call css_disable_mb() here as well?  
> 
> I do not think it is obligatory, measurements are stopped but it may be 
> indeed better so we get a clean SCHIB.
> So yes,
> 
>      css_disable_mb();
>      schm(NULL, 0);
> 
> seems the right thing to do.

Yes, keeping a reference to something you free seems just wrong.

