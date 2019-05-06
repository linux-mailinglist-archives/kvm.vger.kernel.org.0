Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03FD15107
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfEFQS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfEFQS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:18:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33270308FEE0;
        Mon,  6 May 2019 16:18:55 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 766A560C44;
        Mon,  6 May 2019 16:18:53 +0000 (UTC)
Date:   Mon, 6 May 2019 18:18:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
Message-ID: <20190506181850.4b1b8300.cohuck@redhat.com>
In-Reply-To: <65313674-09be-88c0-4b5e-c99527f26532@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-8-farman@linux.ibm.com>
        <20190506173707.40216e76.cohuck@redhat.com>
        <65313674-09be-88c0-4b5e-c99527f26532@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 06 May 2019 16:18:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 May 2019 11:46:59 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/6/19 11:37 AM, Cornelia Huck wrote:
> > On Fri,  3 May 2019 15:49:12 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:
> >   
> >> If the CCW being processed is a No-Operation, then by definition no
> >> data is being transferred.  Let's fold those checks into the normal
> >> CCW processors, rather than skipping out early.
> >>
> >> Likewise, if the CCW being processed is a "test" (an invented
> >> definition to simply mean it ends in a zero),  
> > 
> > The "Common I/O Device Commands" document actually defines this :)  
> 
> Blech, okay so I didn't look early enough in that document.  Section 1.5 
> it is.  :)
> 
> >   
> >> let's permit that to go
> >> through to the hardware.  There's nothing inherently unique about
> >> those command codes versus one that ends in an eight [1], or any other
> >> otherwise valid command codes that are undefined for the device type
> >> in question.  
> > 
> > But I agree that everything possible should be sent to the hardware.
> >   
> >>
> >> [1] POPS states that a x08 is a TIC CCW, and that having any high-order
> >> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
> >> high-order bits are ignored.
> >>
> >> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> >> ---
> >>   drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
> >>   1 file changed, 5 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> >> index 36d76b821209..c0a52025bf06 100644
> >> --- a/drivers/s390/cio/vfio_ccw_cp.c
> >> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> >> @@ -289,8 +289,6 @@ static long copy_ccw_from_iova(struct channel_program *cp,
> >>   #define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
> >>   #define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == CCW_CMD_BASIC_SENSE)
> >>   
> >> -#define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
> >> -
> >>   #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
> >>   
> >>   #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
> >> @@ -314,6 +312,10 @@ static inline int ccw_does_data_transfer(struct ccw1 *ccw)
> >>   	if (ccw->count == 0)
> >>   		return 0;
> >>   
> >> +	/* If the command is a NOP, then no data will be transferred */
> >> +	if (ccw_is_noop(ccw))
> >> +		return 0;
> >> +  
> > 
> > Don't you need to return 0 here for any test command as well?
> > 
> > (If I read the doc correctly, we'll just get a unit check in any case,
> > as there are no parallel I/O interfaces on modern s390 boxes. Even if
> > we had a parallel I/O interface, we'd just collect the status, and not
> > get any data transfer. FWIW, the QEMU ccw interpreter for emulated
> > devices rejects test ccws with a channel program check, which looks
> > wrong; should be a command reject instead.)  
> 
> I will go back and look.  I thought when I sent a test command with an 
> address that wasn't translated I got an unhappy result, which is why I 
> ripped this check out.

Ugh, I just looked at the current PoP and that specifies ccws[1] of test
type as 'invalid' (generating a channel program check). So, the current
PoP and the (old) I/O device commands seem to disagree :/ Do you know
if there's any update to the latter? I think I'll just leave QEMU as it
is, as that at least agrees with the current PoP...

> 
> I was trying to use test CCWs as a safety valve for Halil's Status 
> Modifier concern, so maybe I had something else wrong on that pile. 
> (The careful observer would note that that code was not included here.  :)

:)

> 
> >   
> >>   	/* If the skip flag is off, then data will be transferred */
> >>   	if (!ccw_is_skip(ccw))
> >>   		return 1;
> >> @@ -398,7 +400,7 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
> >>   {
> >>   	struct ccw1 *ccw = chain->ch_ccw + idx;
> >>   
> >> -	if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
> >> +	if (ccw_is_tic(ccw))
> >>   		return;
> >>   
> >>   	kfree((void *)(u64)ccw->cda);
> >> @@ -723,9 +725,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
> >>   {
> >>   	struct ccw1 *ccw = chain->ch_ccw + idx;
> >>   
> >> -	if (ccw_is_test(ccw) || ccw_is_noop(ccw))
> >> -		return 0;
> >> -
> >>   	if (ccw_is_tic(ccw))
> >>   		return ccwchain_fetch_tic(chain, idx, cp);
> >>     
> >   

[1] tcws are a bit different; but we don't support them anyway.
