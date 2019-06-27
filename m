Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5241957F0B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 11:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfF0JPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 05:15:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfF0JPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 05:15:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A425DA70E;
        Thu, 27 Jun 2019 09:14:59 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B44B260BE0;
        Thu, 27 Jun 2019 09:14:58 +0000 (UTC)
Date:   Thu, 27 Jun 2019 11:14:56 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/1] vfio-ccw: Don't call cp_free if we are processing
 a channel program
Message-ID: <20190627111456.3e6da01c.cohuck@redhat.com>
In-Reply-To: <7841b312-13ad-a4b3-85d9-1f5a4991f7fd@linux.ibm.com>
References: <cover.1561055076.git.alifm@linux.ibm.com>
        <46dc0cbdcb8a414d70b7807fceb1cca6229408d5.1561055076.git.alifm@linux.ibm.com>
        <638804dc-53c0-ff2f-d123-13c257ad593f@linux.ibm.com>
        <581d756d-7418-cd67-e0e8-f9e4fe10b22d@linux.ibm.com>
        <2d9c04ba-ee50-2f9b-343a-5109274ff52d@linux.ibm.com>
        <56ced048-8c66-a030-af35-8afbbd2abea8@linux.ibm.com>
        <20190624114231.2d81e36f.cohuck@redhat.com>
        <20190624120514.4b528db5.cohuck@redhat.com>
        <20190624134622.2bb3bba2.cohuck@redhat.com>
        <20190624140723.5aa7b0b1.cohuck@redhat.com>
        <3e93215c-c11a-d0bb-8982-be3f2b467e13@linux.ibm.com>
        <20190624170937.4c76de8d.cohuck@redhat.com>
        <7841b312-13ad-a4b3-85d9-1f5a4991f7fd@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 27 Jun 2019 09:14:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jun 2019 11:24:16 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> On 06/24/2019 11:09 AM, Cornelia Huck wrote:
> > On Mon, 24 Jun 2019 10:44:17 -0400
> > Farhan Ali <alifm@linux.ibm.com> wrote:

> >> But even if we don't remove the cp_free from vfio_ccw_sch_io_todo, I am
> >> not sure if your suggestion will fix the problem. The problem here is
> >> that we can call vfio_ccw_sch_io_todo (for a clear or halt interrupt) at
> >> the same time we are handling an ssch request. So depending on the order
> >> of the operations we could still end up calling cp_free from both from
> >> threads (i refer to the threads I mentioned in response to Eric's
> >> earlier email).  
> > 
> > What I don't see is why this is a problem with ->initialized; wasn't
> > the problem that we misinterpreted an interrupt for csch as one for a
> > not-yet-issued ssch?
> >   
> 
> It's the order in which we do things, which could cause the problem. 
> Since we queue interrupt handling in the workqueue, we could delay 
> processing the csch interrupt. During this delay if ssch comes through, 
> we might have already set ->initialized to true.
> 
> So when we get around to handling the interrupt in io_todo, we would go 
> ahead and call cp_free. This would cause the problem of freeing the 
> ccwchain list while we might be adding to it.
> 
> >>
> >> Another thing that concerns me is that vfio-ccw can also issue csch/hsch
> >> in the quiesce path, independently of what the guest issues. So in that
> >> case we could have a similar scenario to processing an ssch request and
> >> issuing halt/clear in parallel. But maybe I am being paranoid :)  
> > 
> > I think the root problem is really trying to clear a cp while another
> > thread is trying to set it up. Should we maybe use something like rcu?
> > 
> >   
> 
> Yes, this is the root problem. I am not too familiar with rcu locking, 
> but what would be the benefit over a traditional mutex?

I don't quite remember what I had been envisioning at the time (sorry,
the heat seems to make my brain a bit slushy :/), but I think we might
have two copies of the cp and use an rcu-ed pointer in the private
structure to point to one of the copies. If we make sure we've
synchronized on the pointer at interrupt time, we should be able to
free the old one in _todo and act on the new on when doing ssch. And
yes, I realize that this is awfully vague :)
