Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B11248195
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 11:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgHRJOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 05:14:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726165AbgHRJN7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 05:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597742036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNYUKzkrnV8NK/br9GHQs0zaO6FCvgguT47+sGQtDzA=;
        b=IPhtPNrwHBjmq6mEz+0LH3KP2IJ8c4o78YoLXXLz2M1Tn2/3ZO3LusdSSumJ9sHBn1AuBC
        H6jVLj7xaQiJsSm1hAHZVPTZdHw6nWlyDm/xjkiI4PWgKcJ6S/HBhqY+SPqihFtHzXDs1w
        WKhp2m9tDJFejSUjdgJdz6ZQVeKJURY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-yNoXktQCO5-uSXSX3l5G_w-1; Tue, 18 Aug 2020 05:13:52 -0400
X-MC-Unique: yNoXktQCO5-uSXSX3l5G_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7C0F81F02B;
        Tue, 18 Aug 2020 09:13:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8432A600DA;
        Tue, 18 Aug 2020 09:13:46 +0000 (UTC)
Date:   Tue, 18 Aug 2020 11:13:43 +0200
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
Message-ID: <20200818091343.vp7eiyrrz34tyiy3@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
 <20200812092705.17774-4-mhartmay@linux.ibm.com>
 <20200813083000.e4bscohuhgl3jdv4@kamzik.brq.redhat.com>
 <87h7t51in7.fsf@linux.ibm.com>
 <20200814132957.szwmbw6w26fhkroo@kamzik.brq.redhat.com>
 <87ft8k497k.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ft8k497k.fsf@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 18, 2020 at 11:03:27AM +0200, Marc Hartmayer wrote:
> On Fri, Aug 14, 2020 at 03:29 PM +0200, Andrew Jones <drjones@redhat.com> wrote:
> > On Fri, Aug 14, 2020 at 03:06:36PM +0200, Marc Hartmayer wrote:
> >> On Thu, Aug 13, 2020 at 10:30 AM +0200, Andrew Jones <drjones@redhat.com> wrote:
> >> > On Wed, Aug 12, 2020 at 11:27:04AM +0200, Marc Hartmayer wrote:
> >> >> This allows us, for example, to auto generate a new test case based on
> >> >> an existing test case.
> >> >> 
> >> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> >> ---
> >> >>  run_tests.sh            |  2 +-
> >> >>  scripts/common.bash     | 13 +++++++++++++
> >> >>  scripts/mkstandalone.sh |  2 +-
> >> >>  3 files changed, 15 insertions(+), 2 deletions(-)
> >> >> 
> >> >> diff --git a/run_tests.sh b/run_tests.sh
> >> >> index 24aba9cc3a98..23658392c488 100755
> >> >> --- a/run_tests.sh
> >> >> +++ b/run_tests.sh
> >> >> @@ -160,7 +160,7 @@ trap "wait; exit 130" SIGINT
> >> >>     # preserve stdout so that process_test_output output can write TAP to it
> >> >>     exec 3>&1
> >> >>     test "$tap_output" == "yes" && exec > /dev/null
> >> >> -   for_each_unittest $config run_task
> >> >> +   for_each_unittest $config run_task arch_cmd
> >> >
> >> > Let's just require that arch cmd hook be specified by the "$arch_cmd"
> >> > variable. Then we don't need to pass it to for_each_unittest.
> >> 
> >> Where is it then specified?
> >
> > Just using it that way in the source is enough. We should probably call
> > it $ARCH_CMD to indicate that it's a special variable. Also, we could
> > return it from a $(arch_cmd) function, which is how $(migration_cmd) and
> > $(timeout_cmd) work.
> 
> My first approach was different…
> 
> First we source the (common) functions that could be overridden by
> architecture dependent code, and then source the architecture dependent
> code. But I’m not sure which approach is cleaner - if you prefer your
> proposed solution with the global variables I can change it.

I prefer my proposed solution. It's not necessary to provide and
source an arch-neutral function that will never do anything. And,
it will never do anything, because the function is supposed to be
arch-specific. If an arch doesn't implement the function, then
we don't need to call anything at all.

Thanks,
drew

> 
> Thanks for the feedback!
> 
> […snip]
> 
> -- 
> Kind regards / Beste Grüße
>    Marc Hartmayer
> 
> IBM Deutschland Research & Development GmbH
> Vorsitzender des Aufsichtsrats: Gregor Pillen 
> Geschäftsführung: Dirk Wittkopp
> Sitz der Gesellschaft: Böblingen
> Registergericht: Amtsgericht Stuttgart, HRB 243294
> 

