Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB0C21B178
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgGJIhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:37:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726615AbgGJIhU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 04:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594370239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wihF8WgATGrzyjCcakRoNJsvdCqcYtomuBAUafeVICc=;
        b=Vfv11znnE45vaP5pntmuiAX+PymCuuqbvlqG8oA+CFBVZVmPMxegdZqfbrUbDt7nkuZj6a
        IVLEN+DDEZkL7xyBfQwTXszbAVV1u+VOXDYqQbpdXQSbDJ+/2kzgaz1/GQ4q2QvgRdcBa7
        MKcwRTGLY2HU47J2GipvpQ2f02vxbCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-W7aywa_sPQq_whhAoxJ7jg-1; Fri, 10 Jul 2020 04:37:17 -0400
X-MC-Unique: W7aywa_sPQq_whhAoxJ7jg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 639DC107ACCA;
        Fri, 10 Jul 2020 08:37:16 +0000 (UTC)
Received: from starship (unknown [10.35.206.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0F35C1D3;
        Fri, 10 Jul 2020 08:37:14 +0000 (UTC)
Message-ID: <f9570ac28fc1792b91ff6db29bc6bba5d4453607.camel@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: vmentry ignores EFER.LMA and possibly
 RFLAGS.VM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Date:   Fri, 10 Jul 2020 11:37:13 +0300
In-Reply-To: <a341f7ca-4739-db84-74e0-27859bba9eeb@redhat.com>
References: <20200709095525.907771-1-pbonzini@redhat.com>
         <CALMp9eREY4e7kb22CxReNV83HwR7D_tBkn2i5LUbGLGe_yw5nQ@mail.gmail.com>
         <782fdf92-38f8-c081-9796-5344ab3050d5@redhat.com>
         <CALMp9eRSvdx+UHggLbvFPms3Li2KY-RjZhjGjcQ3=GbSB1YyyA@mail.gmail.com>
         <717a1b5d-1bf3-5f72-147a-faccd4611b87@redhat.com>
         <CALMp9eThSjLY92-WURobbJBHRKLxGuYPLBWMnq+=FxxYHquTiw@mail.gmail.com>
         <a341f7ca-4739-db84-74e0-27859bba9eeb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-07-09 at 20:41 +0200, Paolo Bonzini wrote:
> On 09/07/20 20:40, Jim Mattson wrote:
> > On Thu, Jul 9, 2020 at 11:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > On 09/07/20 20:28, Jim Mattson wrote:
> > > > > That said, the VMCB here is guest memory and it can change under our
> > > > > feet between nested_vmcb_checks and nested_prepare_vmcb_save.  Copying
> > > > > the whole save area is overkill, but we probably should copy at least
> > > > > EFER/CR0/CR3/CR4 in a struct at the beginning of nested_svm_vmrun; this
> > > > > way there'd be no TOC/TOU issues between nested_vmcb_checks and
> > > > > nested_svm_vmrun.  This would also make it easier to reuse the checks in
> > > > > svm_set_nested_state.  Maybe Maxim can look at it while I'm on vacation,
> > > > > as he's eager to do more nSVM stuff. :D
> > > > 
> > > > I fear that nested SVM is rife with TOCTTOU issues.
> > > 
> > > I am pretty sure about that, actually. :)
> > > 
> > > Another possibility to stomp them in a more efficient manner could be to
> > > rely on the dirty flags, and use them to set up an in-memory copy of the
> > > VMCB.
> > 
> > That sounds like a great idea! Is Maxim going to look into that?
> > 
> 
> Now he is!

Yep :-)

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


