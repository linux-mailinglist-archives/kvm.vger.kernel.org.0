Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9732D857
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 18:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbhCDRJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 12:09:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239023AbhCDRIl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 12:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614877635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hTdCgmE0lHLx/zeUgnOailAq2XZJW/d6tJ8RFfCz4fM=;
        b=devhJceGSnQEIRBHTHsYc6NMNfNwutp2bzI0AiznWTDhA64r45y0sby+6Mh7sQLR3cMo3s
        MwL1JRISZly5Zm//g1pPjTlicwk7g1WyOZtOPwP9cRjJbwPa6bY5FJOTvcjCi5jmovZukQ
        qoLMWGmHKdjbP0JASPoSNhd4YEnHylw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-eUG4GN3dPc6qReaLSHArOQ-1; Thu, 04 Mar 2021 12:07:13 -0500
X-MC-Unique: eUG4GN3dPc6qReaLSHArOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F681EAEBE;
        Thu,  4 Mar 2021 17:05:15 +0000 (UTC)
Received: from gondolin (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFC56104C3BF;
        Thu,  4 Mar 2021 17:05:13 +0000 (UTC)
Date:   Thu, 4 Mar 2021 18:05:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 5/6] s390x: css: testing measurement
 block format 0
Message-ID: <20210304180511.34afe9fe.cohuck@redhat.com>
In-Reply-To: <80e25939-239a-8579-ba48-563ca0b2960f@linux.ibm.com>
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
        <1614599225-17734-6-git-send-email-pmorel@linux.ibm.com>
        <80e25939-239a-8579-ba48-563ca0b2960f@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Mar 2021 16:54:57 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 3/1/21 12:47 PM, Pierre Morel wrote:
> > We test the update of the measurement block format 0, the
> > measurement block origin is calculated from the mbo argument
> > used by the SCHM instruction and the offset calculated using
> > the measurement block index of the SCHIB.
> > 
> > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > ---
> >  lib/s390x/css.h | 12 +++++++++
> >  s390x/css.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 78 insertions(+)
> > 

(...)

> > diff --git a/s390x/css.c b/s390x/css.c
> > index e8f96f3..3915ed3 100644
> > --- a/s390x/css.c
> > +++ b/s390x/css.c
> > @@ -184,6 +184,71 @@ static void test_schm(void)
> >  	report_prefix_pop();
> >  }
> >  
> > +#define SCHM_UPDATE_CNT 10
> > +static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
> > +{
> > +	int i;
> > +
> > +	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
> > +		report(0, "Enabling measurement_block_format");
> > +		return false;
> > +	}
> > +
> > +	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
> > +		if (!do_test_sense()) {
> > +			report(0, "Error during sense");
> > +			return false;  
> Are these hard fails, i.e. would it make sense to stop testing if this
> or the css_enable_mb() above fails?

I think so; if we can't even enable the mb or send a sense, there's
something really broken.

(...)

Otherwise, this looks good to me (same for the next patch.)

