Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2C244A6A
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgHNNaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 09:30:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbgHNNaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Aug 2020 09:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597411809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oO8vbb5DPD+VaHo5QiT6wYbHvsMyE2vXIzFYhvHPGIE=;
        b=EQCgi3b6wm9QUAMJ2fKWlzwAYBfvSJ+ZEjCd/8+iyqLSB3b8Ua9TqdHxpZcHNboAE8PQpP
        Juoem532Blxt5h8JYKLfVxcMEtyvQAwLE1pPIQjUSn6rJBHzQaUef3qsrOP73hZJ+PS6UG
        5vqMydi3MqZq4sSH/y1DgWaJkFX11sI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-sw5m96_nM6SbvBDtu6Hpeg-1; Fri, 14 Aug 2020 09:30:07 -0400
X-MC-Unique: sw5m96_nM6SbvBDtu6Hpeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6024F100CFCA;
        Fri, 14 Aug 2020 13:30:06 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B37A71C4;
        Fri, 14 Aug 2020 13:30:00 +0000 (UTC)
Date:   Fri, 14 Aug 2020 15:29:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 3/4] run_tests/mkstandalone: add arch
 dependent function to `for_each_unittest`
Message-ID: <20200814132957.szwmbw6w26fhkroo@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
 <20200812092705.17774-4-mhartmay@linux.ibm.com>
 <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com>
 <87h7t51in7.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7t51in7.fsf@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 03:06:36PM +0200, Marc Hartmayer wrote:
> On Thu, Aug 13, 2020 at 10:30 AM +0200, Andrew Jones <drjones@redhat.com> wrote:
> > On Wed, Aug 12, 2020 at 11:27:04AM +0200, Marc Hartmayer wrote:
> >> This allows us, for example, to auto generate a new test case based on
> >> an existing test case.
> >> 
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> ---
> >>  run_tests.sh            |  2 +-
> >>  scripts/common.bash     | 13 +++++++++++++
> >>  scripts/mkstandalone.sh |  2 +-
> >>  3 files changed, 15 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/run_tests.sh b/run_tests.sh
> >> index 24aba9cc3a98..23658392c488 100755
> >> --- a/run_tests.sh
> >> +++ b/run_tests.sh
> >> @@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
> >>     # preserve stdout so that process_test_output output can write TAP to it
> >>     exec 3>&1
> >>     test "$tap_output" == "yes" && exec > /dev/null
> >> -   for_each_unittest $config run_task
> >> +   for_each_unittest $config run_task arch_cmd
> >
> > Let's just require that arch cmd hook be specified by the "$arch_cmd"
> > variable. Then we don't need to pass it to for_each_unittest.
> 
> Where is it then specified?

Just using it that way in the source is enough. We should probably call
it $ARCH_CMD to indicate that it's a special variable. Also, we could
return it from a $(arch_cmd) function, which is how $(migration_cmd) and
$(timeout_cmd) work.

> 
> >
> >>  ) | postprocess_suite_output
> >>  
> >>  # wait until all tasks finish
> >> diff --git a/scripts/common.bash b/scripts/common.bash
> >> index f9c15fd304bd..62931a40b79a 100644
> >> --- a/scripts/common.bash
> >> +++ b/scripts/common.bash
> >> @@ -1,8 +1,15 @@
> >> +function arch_cmd()
> >> +{
> >> +	# Dummy function, can be overwritten by architecture dependent
> >> +	# code
> >> +	return
> >> +}
> >
> > This dummy function appears unused and can be dropped.
> 
> So what is then used if the function is not defined by the architecture
> specific code?

Nothing, which works fine

 $ arch_cmd=
 $ $arch_cmd echo foo   # just do 'echo foo'

However, with what I wrote above, we now need a common arch_cmd function.
Something like

 arch_cmd()
 {
   [ "$ARCH_CMD" ] && return "$ARCH_CMD"
 }

Which would allow us to write

$(arch_cmd) $cmd ...

That does the same thing as above, but it now follows the pattern of
migration_cmd and timeout_cmd.

Thanks,
drew

