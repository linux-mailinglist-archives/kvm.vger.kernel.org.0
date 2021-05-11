Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB33237A9E6
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEKOxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231461AbhEKOxT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620744732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AGUuKyRRkxZWpoHJCBu1bHLU10yx3EHMin2qCpKyO3U=;
        b=aZcATtsmxQnNzzQsP/NsfObjMVjtsLL7XGCnX08/m88vftenfwAnreUW2vNKp3Bq225fX2
        LIfscBZy0+GG8HjfxHCMpE3O/0dZcFnUC5mjwiUGCrgGZiP6NT2PNK+ERJQ8mN3H7S3i8G
        ZmmhTbPwB+sbjNl7KaCCuMuQ+GfLrYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-BiGzewN-OTyHzQE0GIMNmw-1; Tue, 11 May 2021 10:52:09 -0400
X-MC-Unique: BiGzewN-OTyHzQE0GIMNmw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C869A8C8645;
        Tue, 11 May 2021 14:52:08 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-7.gru2.redhat.com [10.97.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 93ABD6267D;
        Tue, 11 May 2021 14:52:00 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 390D34097D83; Tue, 11 May 2021 11:51:57 -0300 (-03)
Date:   Tue, 11 May 2021 11:51:57 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <20210511145157.GC124427@fuller.cnet>
References: <20210507130609.269153197@redhat.com>
 <20210507130923.528132061@redhat.com>
 <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJqXD5gQCfzO4rT5@t490s>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:39:11AM -0400, Peter Xu wrote:
> On Fri, May 07, 2021 at 07:08:31PM -0300, Marcelo Tosatti wrote:
> > > Wondering whether we should add a pi_test_on() check in kvm_vcpu_has_events()
> > > somehow, so that even without customized ->vcpu_check_block we should be able
> > > to break the block loop (as kvm_arch_vcpu_runnable will return true properly)?
> > 
> > static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
> > {
> >         int ret = -EINTR;
> >         int idx = srcu_read_lock(&vcpu->kvm->srcu);
> > 
> >         if (kvm_arch_vcpu_runnable(vcpu)) {
> >                 kvm_make_request(KVM_REQ_UNHALT, vcpu); <---
> >                 goto out;
> >         }
> > 
> > Don't want to unhalt the vcpu.
> 
> Could you elaborate?  It's not obvious to me why we can't do that if
> pi_test_on() returns true..  we have pending post interrupts anyways, so
> shouldn't we stop halting?  Thanks!

pi_test_on() only returns true when an interrupt is signalled by the
device. But the sequence of events is:


1. pCPU idles without notification vector configured to wakeup vector.

2. PCI device is hotplugged, assigned device count increases from 0 to 1.

<arbitrary amount of time>

3. device generates interrupt, sets ON bit to true in the posted
interrupt descriptor.

We want to exit kvm_vcpu_block after 2, but before 3 (where ON bit
is not set).


