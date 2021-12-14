Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636F7474219
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhLNMIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:08:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhLNMIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 07:08:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639483730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=09N8pjnDvvbprsIxiPa7zXeNfQTeGAO51slZCYiF8IQ=;
        b=SaBocxTQjo65jocyF6OaaLQcWkWC1+LQP6hmtNECCmfzkqId52aw1BJ9TmQH4SLmSs91qp
        KXR18oL57hO1wndEvqgRVqtlpic9125OkLm74wXd8m6SYT9B1XVvaCvcC42sr1gTXhXj/4
        HdYIZaEE+hDDic52ZGQbutzN6F6rmJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-wl2w618aOJuTcv7lc39a_Q-1; Tue, 14 Dec 2021 07:08:47 -0500
X-MC-Unique: wl2w618aOJuTcv7lc39a_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A051C1018727;
        Tue, 14 Dec 2021 12:08:33 +0000 (UTC)
Received: from localhost (unknown [10.39.193.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED0767DE50;
        Tue, 14 Dec 2021 12:08:32 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        farman@linux.ibm.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com
Subject: Re: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
In-Reply-To: <20211213134038.39bb0618.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 14 Dec 2021 13:08:31 +0100
Message-ID: <87ee6fs81s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> We do specify that a migration driver has discretion in using the error
> state for failed transitions, so there are options to simplify error
> handling.
>
> If we look at bit flips, we have:
>
> Initial state
> |  Resuming
> |  |  Saving
> |  |  |  Running
> |  |  |  |  Next states with multiple bit flips
>
> a) 0, 0, 0  (d)
> b) 0, 0, 1  (c) (e)
> c) 0, 1, 0  (b) (e)
> d) 0, 1, 1  (a) (e)
> e) 1, 0, 0  (b) (c) (d)
> f) 1, 0, 1 UNSUPPORTED
> g) 1, 1, 0 ERROR
> h) 1, 1, 1 INVALID
>
> We specify that we cannot pass through any invalid states during
> transition, so if I consider each bit to be a discrete operation and
> map all these multi-bit changes to a sequence of single bit flips, the
> only requirements are:
>
>   1) RESUMING must be cleared before setting SAVING or RUNNING
>   2) SAVING or RUNNING must be cleared before setting RESUMING
>
> I think the basis of your priority scheme comes from that.  Ordering
> of the remaining items is more subtle though, for instance
> 0 -> SAVING | RUNNING can be broken down as:
>
>   0 -> SAVING
>   SAVING -> SAVING | RUNNING 
>
>   vs
>
>   0 -> RUNNING
>   RUNNING -> SAVING | RUNNING
>
> I'd give preference to enabling logging before running and I believe
> that holds for transition (e) -> (d) as well.

Agreed.

>
> In the reverse case, SAVING | RUNNING -> 0
>
>   SAVING | RUNNING -> RUNNING
>   RUNNING -> 0
>
>   vs
>
>   SAVING | RUNNING -> SAVING
>   SAVING -> 0
>
> This one is more arbitrary.  I tend to favor clearing RUNNING to stop
> the device first, largely because it creates nice symmetry in the
> resulting algorithm and follows the general principle that you
> discovered as well, converge towards zero by addressing bit clearing
> before setting.

That also makes sense to me.

> So a valid algorithm would include:
>
> int set_device_state(u32 old, u32 new, bool is_unwind)
> {
> 	if (old.RUNNING && !new.RUNNING) {
> 		curr.RUNNING = 0;
> 		if (ERROR) goto unwind;
> 	}
> 	if (old.SAVING && !new.SAVING) {
> 		curr.SAVING = 0;
> 		if (ERROR) goto unwind;
> 	}
> 	if (old.RESUMING && !new.RESUMING) {
> 		curr.RESUMING = 0;
> 		if (ERROR) goto unwind;
> 	}
> 	if (!old.RESUMING && new.RESUMING) {
> 		curr.RESUMING = 1;
> 		if (ERROR) goto unwind;
> 	}
> 	if (!old.SAVING && new.SAVING) {
> 		curr.saving = 1;
> 		if (ERROR) goto unwind;
> 	}
> 	if (!old.RUNNING && new.RUNNING) {
> 		curr.RUNNING = 1;
> 		if (ERROR) goto unwind;
>         }
>
> 	return 0;
>
> unwind:
> 	if (!is_unwind) {
> 		ret = set_device_state(curr, old, true);
> 		if (ret) {
> 			curr.raw = ERROR;
> 			return ret;
> 		}
> 	}
>
> 	return -EIO;
> }
>

I've stared at this and scribbled a bit on paper and I think this would
work.

> And I think that also addresses the claim that we're doomed to untested
> and complicated error code handling, we unwind by simply swapping the
> args to our set state function and enter the ERROR state should that
> recursive call fail.

Nod. As we clear RUNNING as the first thing and would only set RUNNING
again as the last step, any transition to ERROR should be save.

>
> I think it would be reasonable for documentation to present similar
> pseudo code as a recommendation, but ultimately the migration driver
> needs to come up with something that fits all the requirements.

Yes, something like this should go into Documentation/.

