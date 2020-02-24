Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 049B316A75A
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgBXNie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:38:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725535AbgBXNie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 08:38:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582551512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ark2hE7WLrLV7YDgkdBAJMQ6bjdInuFgEhEnSA3QwsQ=;
        b=IZSkuIC+r17OU/SS7efhwLp/nDogc/0mxzqapi5qycv6HpmnBq4qHjVqEALMJDrBYKD+Ec
        XB8FPKXJ+jIVgc5FoDjCbL+SoHX5jvK6J6kvLuVrbehLkJxYhJKFV250Q3QjULIntGGyrj
        bLWOPfqjQAIZ8Vnt7PeBFDp9b4DrRnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-e6xD0m2BNCi_oBJOdtaWCQ-1; Mon, 24 Feb 2020 08:38:25 -0500
X-MC-Unique: e6xD0m2BNCi_oBJOdtaWCQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FFAC189F767;
        Mon, 24 Feb 2020 13:38:23 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C49255C21B;
        Mon, 24 Feb 2020 13:38:20 +0000 (UTC)
Date:   Mon, 24 Feb 2020 14:38:18 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        kvm list <kvm@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, yzt356@gmail.com,
        jmattson@google.com, Paolo Bonzini <pbonzini@redhat.com>,
        namit@vmware.com, sean.j.christopherson@intel.com,
        Basil Eljuse <Basil.Eljuse@arm.com>
Subject: Re: kvm-unit-tests : Kconfigs and extra kernel args for full coverage
Message-ID: <20200224133818.gtxtrmzo4y4guk4z@kamzik.brq.redhat.com>
References: <CA+G9fYvx=WzyJqS4fUFLq8qXT8nbFQoFfXZoeL9kP-hvv549EA@mail.gmail.com>
 <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c82f4386-702f-a2e9-a4d7-d5ebb1f335d1@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 01:21:23PM +0000, Alexandru Elisei wrote:
> Hi Naresh,
> 
> On 2/24/20 12:53 PM, Naresh Kamboju wrote:
> > [Sorry for the spam]
> >
> > Greeting from Linaro !
> > We are running kvm-unit-tests on our CI Continuous Integration and
> > testing on x86_64 and arm64 Juno-r2.
> > Linux stable branches and Linux mainline and Linux next.
> >
> > Few tests getting fail and skipped, we are interested in increasing the
> > test coverage by adding required kernel config fragments,
> > kernel command line arguments and user space tools.
> >
> > Your help is much appreciated.
> >
> > Here is the details of the LKFT kvm unit test logs,
> >
> > [..]
> 
> I am going to comment on the arm64 tests. As far as I am aware, you don't need any
> kernel configs to run the tests.
> 
> From looking at the java log [1], I can point out a few things:
> 
> - The gicv3 tests are failing because Juno has a gicv2 and the kernel refuses to
> create a virtual gicv3. It's normal.

Yup

> 
> - I am not familiar with the PMU test, so I cannot help you with that.

Where is the output from running the PMU test? I didn't see it in the link
below.

> 
> - Without the logs, it's hard for me to say why the micro-bench test is failing.
> Can you post the logs for that particular run? They are located in
> /path/to/kvm-unit-tests/logs/micro-bench.log. My guess is that it has to do with
> the fact that you are using taskset to keep the tests on one CPU. Micro-bench will
> use 2 VCPUs to send 2^28 IPIs which will run on the same physical CPU, and sending
> and receiving them will be serialized which will incur a *lot* of overhead. I
> tried the same test without taskset, and it worked. With taskset -c 0, it timed
> out like in your log.

We've also had "failures" of the micro-bench test when run under avocado
reported. The problem was/is the assert_msg() on line 107 is firing. We
could probably increase the number of tries or change the assert to a
warning. Of course micro-bench isn't a "test" anyway so it can't "fail".
Well, not unless one goes through the trouble of preparing expected times
for each measurement for a given host and then compares new results to
those expectations. Then it could fail when the results are too large
(some threshold must be defined too).

> 
> - there are also other tests that spawn multiple VCPUs, using taskset will
> serialize the VCPUs and will probably hide any potential locking issues.

Indeed.

Thanks,
drew

> 
> [1]|https://lkft.validation.linaro.org/scheduler/job/1242488|
> 
> |Thanks,|
> |Alex|
> ||||
> 

