Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C18D24399B
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 14:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHMMHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 08:07:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52465 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726546AbgHMMHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 08:07:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597320439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SWDfurIFPaKf/0lilWzjbiAdubT/0+OAkhiOhkZhaOU=;
        b=N9ZejT0iXS+ilwgRcB5KMkTtrFOPJMa9ZfaO/kY6Un7N9s/xfOWGP6vEnKs9a/yfKa10FF
        VjTnZE7/hq0NfRgJVei1IrE/iqjrEM17tUwxbhlwTnLCM99ZqChZAbkQO5LGHI+h9u20oT
        bXomOKvusuU6mNuZ8b3eDNnpTSe6Dlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-XuphGnlTPrKqbjdoL11-5g-1; Thu, 13 Aug 2020 08:07:15 -0400
X-MC-Unique: XuphGnlTPrKqbjdoL11-5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6E351DDE2;
        Thu, 13 Aug 2020 12:07:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90A5419C78;
        Thu, 13 Aug 2020 12:07:08 +0000 (UTC)
Date:   Thu, 13 Aug 2020 14:07:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 2/4] scripts: add support for
 architecture dependent functions
Message-ID: <20200813120705.7bggleqpq56jqdxm@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
 <20200812092705.17774-3-mhartmay@linux.ibm.com>
 <20200813074940.73xzr6nq4xktjhpu@kamzik.brq.redhat.com>
 <87lfiihiqd.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfiihiqd.fsf@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 01:45:46PM +0200, Marc Hartmayer wrote:
> On Thu, Aug 13, 2020 at 09:49 AM +0200, Andrew Jones <drjones@redhat.com> wrote:
> > On Wed, Aug 12, 2020 at 11:27:03AM +0200, Marc Hartmayer wrote:
> >> This is necessary to keep architecture dependent code separate from
> >> common code.
> >> 
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> ---
> >>  README.md           | 3 ++-
> >>  scripts/common.bash | 5 +++++
> >>  2 files changed, 7 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/README.md b/README.md
> >> index 48be206c6db1..24d4bdaaee0d 100644
> >> --- a/README.md
> >> +++ b/README.md
> >> @@ -134,7 +134,8 @@ all unit tests.
> >>  ## Directory structure
> >>  
> >>      .:                  configure script, top-level Makefile, and run_tests.sh
> >> -    ./scripts:          helper scripts for building and running tests
> >> +    ./scripts:          general architecture neutral helper scripts for building and running tests
> >> +    ./scripts/<ARCH>:   architecture dependent helper scripts for building and running tests
> >>      ./lib:              general architecture neutral services for the tests
> >>      ./lib/<ARCH>:       architecture dependent services for the tests
> >>      ./<ARCH>:           the sources of the tests and the created objects/images
> >> diff --git a/scripts/common.bash b/scripts/common.bash
> >> index 96655c9ffd1f..f9c15fd304bd 100644
> >> --- a/scripts/common.bash
> >> +++ b/scripts/common.bash
> >> @@ -52,3 +52,8 @@ function for_each_unittest()
> >>  	fi
> >>  	exec {fd}<&-
> >>  }
> >> +
> >> +ARCH_FUNC=scripts/${ARCH}/func.bash
> >
> > The use of ${ARCH} adds a dependency on config.mak. It works now because
> > in the two places we source common.bash we source config.mak first
> 
> Yep, I know.
> 
> > , but
> > I'd prefer we make that dependency explicit.
> 
> Okay.
> 
> > We could probably just
> > source it again from this file.
> 
> Another option is to pass ${ARCH} as an argument when we `source
> scripts/runtime.bash`
> 
> => `source scripts/runtime.bash "${ARCH}"`
> 
> Which one do you prefer?

The first one. There's a chance that the arch helper functions will
need more than $ARCH from config.mak. Of course that means we have
a dependency on config.mak from the arch helper file too. We can
just add a comment in common.bash about the order of sourcing
though, as common.bash should be the only file sourcing the
arch helper file.

Thanks,
drew

> 
> >
> > Thanks,
> > drew
> >
> >> +if [ -f "${ARCH_FUNC}" ]; then
> >> +	source "${ARCH_FUNC}"
> >> +fi
> >> -- 
> >> 2.25.4
> >> 
> >
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

