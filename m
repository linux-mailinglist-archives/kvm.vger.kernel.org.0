Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC815D5E6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgBNKjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:39:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46199 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387401AbgBNKjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581676752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iy+JvaHdOLPDsDUuV0Ut6kt4Oh5UXLHLOmwW1plCfuM=;
        b=aHEQxegWoXAJeR5d7tgmjj775bnG2dD4V3kREkdU33I1s+3flde6Y5czIhCFGX16Pur/U2
        9zLYKckbBsh4xO4CA+xS+GK3C10xWDunmeX618jxCmaEvVaxNLLAYuDZ2n6Gq0+suJ/j3D
        K9+9SOuVJW8Rq6OljlcOkZsNGa5hj9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-2eJ-2i3eNWOh5a05LKKFdg-1; Fri, 14 Feb 2020 05:39:04 -0500
X-MC-Unique: 2eJ-2i3eNWOh5a05LKKFdg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 172BF107ACC7;
        Fri, 14 Feb 2020 10:39:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 651DA790CF;
        Fri, 14 Feb 2020 10:38:56 +0000 (UTC)
Date:   Fri, 14 Feb 2020 11:38:53 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
Message-ID: <20200214103853.ycxs4clif4gisk6i@kamzik.brq.redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689d8031-22ac-c414-a3c3-e10567c3c9af@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:27:17AM +0100, Paolo Bonzini wrote:
> On 13/02/20 15:33, Andrew Jones wrote:
> > Users may need to temporarily provide additional VMM parameters.
> > The VMM_PARAMS environment variable provides a way to do that.
> > We take care to make sure when executing ./run_tests.sh that
> > the VMM_PARAMS parameters come last, allowing unittests.cfg
> > parameters to be overridden. However, when running a command
> > line like `$ARCH/run $TEST $PARAMS` we want $PARAMS to override
> > $VMM_PARAMS, so we ensure that too.
> > 
> > Additional QEMU parameters can still be provided by appending
> > them to the $QEMU environment variable when it provides the
> > path to QEMU, but as those parameters will then be the first
> > in the command line they cannot override anything, and may
> > themselves be overridden.
> 
> What about looking for "--" and passing to QEMU all parameters after it?
>

That was the way we originally planned on doing it when Alex Bennee posted
his patch. However since d4d34e648482 ("run_tests: fix command line
options handling") the "--" has become the divider between run_tests.sh
parameter inputs and individually specified tests. We'd have to change
that behavior, potentially breaking command lines, to go back to the
"--" approach.

Also, the nice thing about using an environment variable is that it works
with standalone tests too.

 VMM_PARAMS="-foo bar" tests/mytest

will run the test with "-foo bar" appended to the command line. We could
modify mkstandalone.sh to get that feature too (allowing the additional
parameters to be given after tests/mytest), but with VMM_PARAMS we don't
have to.

Thanks,
drew

