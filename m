Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3274D262CA7
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 11:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIIJ4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 05:56:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbgIIJ4c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 05:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599645389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1F7oNSzkYrwwlqYYpWF6QycIDBNCbe1zVIPy2aNmoRg=;
        b=cmFpJZTF0bay3CRbctrpW5TBQFMWyZCBnNeALg0A+5Z9Zw4r3oYJlSIVQZ0ZfDg1GTQe2k
        +vERQQjc52S3MV7aVdPXBSz0P1dk0BxY0nO+atSe2PqKngMBR/3hKaoQ4Ht41QMbB7II1X
        HW4h1mao7YjOcn9mJZ3yvAIlRnncl68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-Tpf0cnimPfydsd2tQ52ReA-1; Wed, 09 Sep 2020 05:56:27 -0400
X-MC-Unique: Tpf0cnimPfydsd2tQ52ReA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A0F78018A9;
        Wed,  9 Sep 2020 09:56:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5205D9E8;
        Wed,  9 Sep 2020 09:56:19 +0000 (UTC)
Date:   Wed, 9 Sep 2020 11:56:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2] KVM: arm64: Allow to limit number of PMU counters
Message-ID: <20200909095616.bbblmk5bwosb5c7c@kamzik.brq.redhat.com>
References: <20200908205730.23898-1-graf@amazon.com>
 <20200909062534.zsqadaeewfeqsgsj@kamzik.brq.redhat.com>
 <fcb9ccab-2118-af76-3109-4d491d888c7c@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb9ccab-2118-af76-3109-4d491d888c7c@amazon.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 10:43:41AM +0200, Alexander Graf wrote:
> Hey Drew!
> 
> On 09.09.20 08:25, Andrew Jones wrote:
> > 
> > On Tue, Sep 08, 2020 at 10:57:30PM +0200, Alexander Graf wrote:
> > > We currently pass through the number of PMU counters that we have available
> > > in hardware to guests. So if my host supports 10 concurrently active PMU
> > > counters, my guest will be able to spawn 10 counters as well.
> > > 
> > > This is undesireable if we also want to use the PMU on the host for
> > > monitoring. In that case, we want to split the PMU between guest and
> > > host.
> > > 
> > > To help that case, let's add a PMU attr that allows us to limit the number
> > > of PMU counters that we expose. With this patch in place, user space can
> > > keep some counters free for host use.
> > 
> > Hi Alex,
> > 
> > Is there any reason to use the device API instead of just giving the user
> > control over the necessary PMCR_EL0 bits through set/get-one-reg?
> 
> I mostly used the attr interface because I was in that particular mental
> mode after looking at the filtering bits :).
> 
> Today, the PMCR_EL0 register gets reset implicitly on every vcpu reset call.
> How would we persist the counter field across resets? Would we in the first
> place?
> 
> I'm slightly hazy how the ONE_REG API would look like here. Do you have
> recommendations?
>

Using the set/get_user hooks of the sysreg table we can accept a user
input PMCR_EL0. We would only accept one that matches what the hardware
and KVM supports though (EINVAL otherwise). We'll need to modify reset to
use the value selected by the user too, which we can store in 'val' of the
sysreg table.

Since userspace will likely get before set in order to know what's valid,
we'll need to provide the current reset state on get until it has been
set. I'm not sure how to track whether it has been set or not. Maybe new
state is needed or an initial val=0 or val=~0 may work.

Thanks,
drew

