Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B313B15A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgANRvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:51:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgANRvN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 12:51:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579024272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p5I9yRo4DxwJWAsieS+jn8acxGiDxwT4HgwwRtRVWx8=;
        b=G3ZC3i2/jOUfabC8R4vouYRO/3HF1gYodIwVtx7UBjODbsuHWZhiUCunzczJpHgCihfh0e
        zM3rOMysgxKRsdhC06MoxWcDvngVi5EBCMXfzi3usrdC8iB2zzEoX/EmYxBuRMXgOShWdr
        RSZKFMyydnVcEX/f6w1lo1ROhNy7+94=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-eZwBTe3MNm-UovYeSLzpfg-1; Tue, 14 Jan 2020 12:51:08 -0500
X-MC-Unique: eZwBTe3MNm-UovYeSLzpfg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DCAD107ACCA;
        Tue, 14 Jan 2020 17:51:07 +0000 (UTC)
Received: from gondolin (ovpn-117-161.ams2.redhat.com [10.36.117.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80AB660BE0;
        Tue, 14 Jan 2020 17:51:03 +0000 (UTC)
Date:   Tue, 14 Jan 2020 18:51:01 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: smp: Test all CRs on initial
 reset
Message-ID: <20200114185101.1f2481c8.cohuck@redhat.com>
In-Reply-To: <bec10775-3713-4604-1b49-27d49682db43@redhat.com>
References: <20200114153054.77082-1-frankja@linux.ibm.com>
        <20200114153054.77082-4-frankja@linux.ibm.com>
        <bec10775-3713-4604-1b49-27d49682db43@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jan 2020 18:01:32 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 14/01/2020 16.30, Janosch Frank wrote:
> > All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
> > so we also need to test 1-13 and 15 for 0.
> > 
> > And while we're at it, let's also set some values to cr 1, 7 and 13, so
> > we can actually be sure that they will be zeroed.
> > 
> > Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> > ---
> >  s390x/smp.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)

> > @@ -219,6 +237,7 @@ static void test_reset(void)
> >  
> >  	sigp_retry(1, SIGP_CPU_RESET, 0, NULL);
> >  	report(smp_cpu_stopped(1), "cpu stopped");
> > +	smp_cpu_destroy(1);  
> 
> Shouldn't that rather be part of patch 2/4 ? I'd maybe also move this to
> the main() function instead since you've setup the cpu there...? Also is
> it still ok to use smp_cpu_start() in test_reset_initial() after you've
> destroyed the CPU here in test_reset()?

Isn't it simply wrong? I thought the pattern was supposed to be

- setup cpu
- do some tests, including stopping/restarting/etc.
- destroy cpu [currently missing]

> 
> >  	report_prefix_pop();
> >  }  
> 
>  Thomas

