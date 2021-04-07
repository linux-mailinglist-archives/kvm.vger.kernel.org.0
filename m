Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27255356935
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 12:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350818AbhDGKQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 06:16:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350816AbhDGKQS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Apr 2021 06:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617790568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lNJUMS0XqtDA+j/nPopG+vTJOjoz59Du+KS1uqYbIcY=;
        b=ggGVt4qzIu6mLUBBnapPBmREsbbH3dfSrpUs3IUHZqHlZa9t97w+mPo+FIlHL21zoR4oe1
        hb3z9FMDyfHLkvOT/+topuPE3tgSHmdlbvDRuS1K3eVc3/Gzis5Psbu3mj2ZJ7LTmuTEIr
        U/kvMohrCvrHxTaR7MjC6kPTv8bV9P8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-sMSMmmX7Mgy8sPnPBlr1pw-1; Wed, 07 Apr 2021 06:16:05 -0400
X-MC-Unique: sMSMmmX7Mgy8sPnPBlr1pw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD0C083DD22;
        Wed,  7 Apr 2021 10:16:03 +0000 (UTC)
Received: from gondolin (ovpn-113-88.ams2.redhat.com [10.36.113.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73C9B62A0C;
        Wed,  7 Apr 2021 10:15:56 +0000 (UTC)
Date:   Wed, 7 Apr 2021 12:15:54 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3 12/16] s390x: css: Check ORB reserved
 bits
Message-ID: <20210407121554.29aa8949.cohuck@redhat.com>
In-Reply-To: <19cc4cdc-027b-9c72-b4fe-fa8fc2dcbbf0@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
        <1617694853-6881-13-git-send-email-pmorel@linux.ibm.com>
        <20210406175136.1d7d7fa2.cohuck@redhat.com>
        <19cc4cdc-027b-9c72-b4fe-fa8fc2dcbbf0@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 12:07:13 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 4/6/21 5:51 PM, Cornelia Huck wrote:
> > On Tue,  6 Apr 2021 09:40:49 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> Several bits of the ORB are reserved and must be zero.
> >> Their use will trigger a operand exception.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >>   s390x/css.c | 21 +++++++++++++++++++++
> >>   1 file changed, 21 insertions(+)
> >>
> >> diff --git a/s390x/css.c b/s390x/css.c
> >> index 56adc16..26f5da6 100644
> >> --- a/s390x/css.c
> >> +++ b/s390x/css.c
> >> @@ -209,6 +209,26 @@ static void ssch_orb_midaw(void)
> >>   	orb->ctrl = tmp;
> >>   }
> >>   
> >> +static void ssch_orb_ctrl(void)
> >> +{
> >> +	uint32_t tmp = orb->ctrl;
> >> +	char buffer[80];
> >> +	int i;
> >> +
> >> +	/* Check the reserved bits of the ORB CTRL field */
> >> +	for (i = 26; i <= 30; i++) {  
> > 
> > This looks very magic; can we get some defines?  
> 
> OK, I can use something like ORB_FIRST_RESERVED_BIT - ORB_LAST_RESERVED_BIT

Yep, something like that.

