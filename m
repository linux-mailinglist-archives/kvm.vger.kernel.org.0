Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1DF1F5863
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgFJPyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:54:43 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728217AbgFJPym (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 11:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591804481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0tCjaHRqySsbmgo1SDH04ZSF0FVSvkDa8UYEOkQpewY=;
        b=PHzMrpgm/0f7i3Fmfcob5L4hiCyl7WFsQH5lOVo6z1ZKKYMt/ITE4UlwGE9NeO6qEbtrGz
        r1vkR0MpGV0mQv+o4PdSJnBhY9xzF3bqJIAq6JmL4fc1aoqTdnl9W9PmOVELdtjl4Ge5Xg
        o0G4tB2wykLwUjzA8+NinPq6sMOVhoo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-dzM1y0lSMs-4xPVPbqoQgA-1; Wed, 10 Jun 2020 11:54:37 -0400
X-MC-Unique: dzM1y0lSMs-4xPVPbqoQgA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDF5D107ACF4;
        Wed, 10 Jun 2020 15:54:36 +0000 (UTC)
Received: from gondolin (ovpn-112-196.ams2.redhat.com [10.36.112.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4A3178905;
        Wed, 10 Jun 2020 15:54:32 +0000 (UTC)
Date:   Wed, 10 Jun 2020 17:54:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v8 10/12] s390x: css: stsch, enumeration
 test
Message-ID: <20200610175429.401a58ea.cohuck@redhat.com>
In-Reply-To: <a9a44f1d-2179-5d95-f45f-172000f7a3c1@linux.ibm.com>
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
        <1591603981-16879-11-git-send-email-pmorel@linux.ibm.com>
        <af39687e-4512-d147-5011-11d03b68e1bf@redhat.com>
        <a9a44f1d-2179-5d95-f45f-172000f7a3c1@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 9 Jun 2020 14:20:35 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-06-09 09:39, Thomas Huth wrote:
> > On 08/06/2020 10.12, Pierre Morel wrote:  

> >> +static void test_enumerate(void)
> >> +{
> >> +	test_device_sid = css_enumerate();
> >> +	if (test_device_sid & SCHID_ONE) {
> >> +		report(1, "First device schid: 0x%08x", test_device_sid);
> >> +		return;
> >> +	}
> >> +
> >> +	switch (test_device_sid) {
> >> +	case 0:
> >> +		report (0, "No I/O device found");
> >> +		break;
> >> +	default:	/* 1 or 2 should never happened for STSCH */
> >> +		report(0, "Unexpected cc=%d during enumeration",
> >> +		       test_device_sid);
> >> +			return;
> >> +	}  
> > 
> > Ok, so here is now the test failure for the cc=1 or 2 that should never
> > happen. That means currently you print out the CC for this error twice.
> > One time should be enough, either here, or use an report_abort() in the
> > css_enumerate(), I'd say.
> > 
> > Anyway, can you please replace this switch statement with a "if
> > (!test_device_sid)" instead? Or do you plan to add more "case"
> > statements later?  
> 
> I will use the repor_abort() in the css_enumerate() so there
> is only two case, I find a channel or not, so I don't even need the 
> second if :) .

Yeah, testing only for SCHID_ONE present or not makes this a lot less
confusing.

