Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998FF15D5FA
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 11:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgBNKpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 05:45:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:20293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387415AbgBNKpN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 05:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581677111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCEszChvG+/IbS5bAqYTCNfNNd7U2vMeywC59KSLVaM=;
        b=DBHFXXBOdrHYXyKDk5Jp4fdlxDFzz+JADh7fjvI76/1V4VDfIXBrmVgMB//1UKsENYWKWB
        ckGh7lZQqwpe5dO+1uEqnFFf0abmmH0e8DiBS2yTgpZe+lCCHIGphjd4bhFIg2zCuLKI9Z
        lKj9idK8AuMrvBpJ/QJlQ0TfgCe6pJQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-rJxKhNRBPgivF0z6RMvZoA-1; Fri, 14 Feb 2020 05:45:09 -0500
X-MC-Unique: rJxKhNRBPgivF0z6RMvZoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8371418C43C3;
        Fri, 14 Feb 2020 10:45:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30B5A5C1C3;
        Fri, 14 Feb 2020 10:44:59 +0000 (UTC)
Date:   Fri, 14 Feb 2020 11:44:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, peter.maydell@linaro.org,
        alex.bennee@linaro.org, pbonzini@redhat.com, lvivier@redhat.com,
        thuth@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 2/2] runtime: Introduce VMM_PARAMS
Message-ID: <20200214104457.w4qwmhutiwkrbq24@kamzik.brq.redhat.com>
References: <20200213143300.32141-1-drjones@redhat.com>
 <20200213143300.32141-3-drjones@redhat.com>
 <b455b420-bdbd-8389-4a9c-c28a9970bfc2@redhat.com>
 <20200214103059.vcvsg6mfr3mo7dnm@kamzik.brq.redhat.com>
 <dfbd6f4c-6082-2909-e324-a401713c3af2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfbd6f4c-6082-2909-e324-a401713c3af2@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 14, 2020 at 11:33:55AM +0100, David Hildenbrand wrote:
> On 14.02.20 11:30, Andrew Jones wrote:
> > On Fri, Feb 14, 2020 at 11:14:49AM +0100, David Hildenbrand wrote:
> >> On 13.02.20 15:33, Andrew Jones wrote:
> >>> Users may need to temporarily provide additional VMM parameters.
> >>> The VMM_PARAMS environment variable provides a way to do that.
> >>> We take care to make sure when executing ./run_tests.sh that
> >>> the VMM_PARAMS parameters come last, allowing unittests.cfg
> >>> parameters to be overridden. However, when running a command
> >>> line like `$ARCH/run $TEST $PARAMS` we want $PARAMS to override
> >>> $VMM_PARAMS, so we ensure that too.
> >>
> >> While reading this, I was wondering why not simply "$QEMU_PARAMS"?
> > 
> > I'd like to slowly move away from assuming QEMU is the VMM. We
> > already have support for kvmtool (to some degree) and I'd like
> > to see that support increase. Also, maybe we'll eventually add
> > support for a rust-vmm reference VMM to drive kvm-unit-tests.
> > IOW, rather than add yet another QEMU named variable I'd like
> > to start a trend of using VMM named variables. Actually, we
> > could add VMM named alternatives for the QEMU named ones we have
> > now and start using them in the scripts. We'd just need to remap
> > the old names for backward compatibility early in the run.
> 
> And we do expect other VMMs to eat the same set of parameters? If it's
> QEMU specific, I think we should make this clear.

It won't matter. The parameters are VMM specific. Whether or not where
they show up on the command line has the same semantics as QEMU could
be an issue, but what the parameters are is up to the user, and they
should know which vmm they're currently using.

kvmtool support isn't complete because the run scripts haven't yet
provided a way for non-QEMU vmms to use the unittests.cfg files.
Andre had some patches once, though. So maybe someday.

Thanks,
drew

