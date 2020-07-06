Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3430521594D
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 16:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgGFOYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 10:24:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49919 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729159AbgGFOYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jul 2020 10:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594045476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07icP/Ih/mf4Kcf8RQHziy0b5gOQsyLW4sKpyYiuNic=;
        b=GG88lxq/khWAINEwe3gbMpSHQOrpH8KWauAsirjZyq3LmZ2bKug3b41GOqdCnl8fsE7Ell
        5BZgAH5X7F/Yk4he0Bpvyyb5sEquZRfpbThNgvTI3YRnyZeit92As4gZqrWzzbJnhnBTts
        E3JaHm+ntBcY3SJ8dfi/5DajFAOvspg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-BAzD4zKhMfaAdXP-ngdoSg-1; Mon, 06 Jul 2020 10:24:32 -0400
X-MC-Unique: BAzD4zKhMfaAdXP-ngdoSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC5B01005510;
        Mon,  6 Jul 2020 14:24:31 +0000 (UTC)
Received: from gondolin (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D57185C3F8;
        Mon,  6 Jul 2020 14:24:24 +0000 (UTC)
Date:   Mon, 6 Jul 2020 16:24:13 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v10 9/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20200706162413.1a24fe40.cohuck@redhat.com>
In-Reply-To: <02eb7a70-7a74-6f09-334f-004e69aaa198@linux.ibm.com>
References: <1593707480-23921-1-git-send-email-pmorel@linux.ibm.com>
        <1593707480-23921-10-git-send-email-pmorel@linux.ibm.com>
        <20200706114655.5088b6b7.cohuck@redhat.com>
        <02eb7a70-7a74-6f09-334f-004e69aaa198@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 Jul 2020 15:01:50 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-07-06 11:46, Cornelia Huck wrote:
> > On Thu,  2 Jul 2020 18:31:20 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> >> After a channel is enabled we start a SENSE_ID command using
> >> the SSCH instruction to recognize the control unit and device.
> >>
> >> This tests the success of SSCH, the I/O interruption and the TSCH
> >> instructions.
> >>
> >> The SENSE_ID command response is tested to report 0xff inside
> >> its reserved field and to report the same control unit type
> >> as the cu_type kernel argument.
> >>
> >> Without the cu_type kernel argument, the test expects a device
> >> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> >> ---
> >>   lib/s390x/asm/arch_def.h |   1 +
> >>   lib/s390x/css.h          |  32 ++++++++-
> >>   lib/s390x/css_lib.c      | 148 ++++++++++++++++++++++++++++++++++++++-
> >>   s390x/css.c              |  94 ++++++++++++++++++++++++-
> >>   4 files changed, 272 insertions(+), 3 deletions(-)  

(...)

> >> @@ -114,6 +128,7 @@ retry:
> >>   		return cc;
> >>   	}
> >>   
> >> +	report_info("stsch: flags: %04x", pmcw->flags);  
> > 
> > It feels like all of this already should have been included in the
> > previous patch?  
> 
> Yes, I did not want to modify it since it was reviewed-by.

It's not such a major change (the isc change and this here), though...
what do the others think?

> 
> >   
> >>   	if (pmcw->flags & PMCW_ENABLE) {
> >>   		report_info("stsch: sch %08x enabled after %d retries",
> >>   			    schid, retry_count);

(...)

> >> +/*
> >> + * css_residual_count
> >> + * We expect no residual count when the ORB request was successful  
> > 
> > If we have a short block, but have suppressed the incorrect length
> > indication, we may have a successful request with a nonzero count.
> > Maybe replace this with "Return the residual count, if it is valid."?  
> 
> 
> OK
> 
> >   
> >> + * The residual count is valid when the subchannel is status pending
> >> + * with primary status and device status only or device status and
> >> + * subchannel status with PCI or incorrect length.
> >> + * Return value:
> >> + * Success: the residual count
> >> + * Not meaningful: -1 (-1 can not be a valid count)
> >> + */
> >> +int css_residual_count(unsigned int schid)
> >> +{
> >> +
> >> +	if (!(irb.scsw.ctrl & (SCSW_SC_PENDING | SCSW_SC_PRIMARY)))
> >> +		goto fail;  
> > 
> > s/fail/invalid/ ? It's not really a failure :)  
> 
> yes
> 
> >   
> >> +
> >> +	if (irb.scsw.dev_stat)
> >> +		if (irb.scsw.sch_stat & ~(SCSW_SCHS_PCI | SCSW_SCHS_IL))
> >> +			goto fail;
> >> +
> >> +	return irb.scsw.count;
> >> +
> >> +fail:
> >> +	report_info("sch  status %02x", irb.scsw.sch_stat);
> >> +	report_info("dev  status %02x", irb.scsw.dev_stat);
> >> +	report_info("ctrl status %08x", irb.scsw.ctrl);
> >> +	report_info("count       %04x", irb.scsw.count);
> >> +	report_info("ccw addr    %08x", irb.scsw.ccw_addr);  
> > 
> > I don't understand why you dump this data if no valid residual count is
> > available. But maybe I don't understand the purpose of this function
> > correctly.  
> 
> As debug information to facilitate the search why the function failed.
> Would you prefer more accurate report_info inside the if tests?
> or just return with error code?

My main issue is that I don't understand why you consider this a
failure. Depending on the interrupt, the count field may or may not
contain valid information, and that's fine. If you consider a certain
interrupt unexpected/a failure, I think it makes much more sense to
check that outside of this function (and only call it if you actually
get an expected interrupt.)

> 
> >   
> 
> >>   
> >> +/*
> >> + * test_sense
> >> + * Pre-requisits:  
> > 
> > s/Pre-requisists/Pre-requisites/  
> 
> OK
> 
> >   
> >> + * - We need the test device as the first recognized
> >> + *   device by the enumeration.
> >> + */
> >> +static void test_sense(void)
> >> +{
> >> +	int ret;
> >> +	int len;
> >> +
> >> +	if (!test_device_sid) {
> >> +		report_skip("No device");
> >> +		return;
> >> +	}
> >> +
> >> +	ret = css_enable(test_device_sid, IO_SCH_ISC);
> >> +	if (ret) {
> >> +		report(0,
> >> +		       "Could not enable the subchannel: %08x",
> >> +		       test_device_sid);
> >> +		return;
> >> +	}
> >> +
> >> +	ret = register_io_int_func(css_irq_io);
> >> +	if (ret) {
> >> +		report(0, "Could not register IRQ handler");
> >> +		goto unreg_cb;
> >> +	}
> >> +
> >> +	lowcore_ptr->io_int_param = 0;
> >> +
> >> +	memset(&senseid, 0, sizeof(senseid));
> >> +	ret = start_single_ccw(test_device_sid, CCW_CMD_SENSE_ID,
> >> +			       &senseid, sizeof(senseid), CCW_F_SLI);
> >> +	if (ret) {
> >> +		report(0, "ssch failed for SENSE ID on sch %08x with cc %d",
> >> +		       test_device_sid, ret);
> >> +		goto unreg_cb;
> >> +	}
> >> +
> >> +	wait_for_interrupt(PSW_MASK_IO);
> >> +
> >> +	if (lowcore_ptr->io_int_param != test_device_sid) {
> >> +		report(0, "ssch succeeded but interrupt parameter is wrong: expect %08x got %08x",
> >> +		       test_device_sid, lowcore_ptr->io_int_param);
> >> +		goto unreg_cb;
> >> +	}
> >> +
> >> +	ret = css_residual_count(test_device_sid);
> >> +	if (ret < 0) {
> >> +		report(0, "ssch succeeded for SENSE ID but can not get a valid residual count");
> >> +		goto unreg_cb;
> >> +	}  
> > 
> > I'm not sure what you're testing here. You should first test whether
> > the I/O concluded normally (i.e., whether you actually get something
> > like status pending with channel end/device end). If not, it does not
> > make much sense to look either at the residual count or at the sense id
> > data.
> > 
> > If css_residual_count does not return something >= 0 for that 'normal'
> > case, something is definitely fishy, though :)  
> 
> I will add the test before the call to get the residual count.
> May be it leads to rework the css_residual_count too.

Sounds good (sorry about causing all that additional churn).

