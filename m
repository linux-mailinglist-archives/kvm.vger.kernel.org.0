Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91F51E424A
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 14:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbgE0M26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 08:28:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50848 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728721AbgE0M25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 08:28:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590582536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g9FxUpI3OzPM1e9gI4pX6q/XzrU1P17TZrLPSvSwy/4=;
        b=bgl06NX7JFw6Oyrt3rS9fEIwh2v6pDOOQ3UXbwCMcY+loGcM9H+VgG0VncjtWKF71nceNW
        RjuMQq0paj3/ya3PnoWEY4gTziKx0Ha2AjT/2YfPlmveXDnXEQ320TqPXIGljjFOsSh1eB
        Pxea/daAgRcGLo0DdEQujRLFp+txrVM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-oAjDMN-xP067UrZLUINvoQ-1; Wed, 27 May 2020 08:28:54 -0400
X-MC-Unique: oAjDMN-xP067UrZLUINvoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 592A1107ACCA;
        Wed, 27 May 2020 12:28:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC70C5D9E5;
        Wed, 27 May 2020 12:28:51 +0000 (UTC)
Message-ID: <7240b1f9ef497fd040c7315d90711c642f709d16.camel@redhat.com>
Subject: Re: KVM broken after suspend in most recent kernels.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Brad Campbell <lists2009@fnarfbargle.com>
Cc:     kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 27 May 2020 15:28:50 +0300
In-Reply-To: <20200527051354.GL31696@linux.intel.com>
References: <1f7a85cc-38a6-2a2e-cbe3-a5b9970b7b92@fnarfbargle.com>
         <f726be8c-c7ef-bf6a-f31e-394969d35045@fnarfbargle.com>
         <1f7b1c9a8d9cbb6f82e97f8ba7a13ce5b773e16f.camel@redhat.com>
         <a45bc9d7-ad0b-2ff0-edcc-5283f591bc10@fnarfbargle.com>
         <20200527051354.GL31696@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-05-26 at 22:13 -0700, Sean Christopherson wrote:
> On Mon, May 25, 2020 at 09:15:57PM +0800, Brad Campbell wrote:
> > > When you mean that KVM is broken after suspend, you mean that you
> > > can't
> > > start new VMs after suspend, or do VMs that were running before
> > > suspend
> > > break?  I see the later on my machine. I have AMD system though,
> > > so most
> > > likely this is another bug.
> > > 
> > > Looking at the commit, I suspect that we indeed should set the
> > > IA32_FEAT_CTL
> > > after resume from ram, since suspend to ram might count as a
> > > complete CPU
> > > reset.
> > > 
> > 
> > One of those "I should have clarified that" moments immediately
> > after I
> > pressed send.  I've not tried suspending with a VM running. It's
> > "can't start
> > new VMs after suspend".
> 
> Don't bother testing suspending with a VM, the only thing that will
> be
> different is that your system will hang on resume instead when
> running a
> VM.  If there are active VMs, KVM automatically re-enables VMX via
> VMXON
> after resume, and VMXON is what's faulting.
> 
> Odds are good the firmware simply isn't initializing IA32_FEAT_CTL,
> ever.
> The kernel handles the boot-time case, but I (obviously) didn't
> consider
> the suspend case.  I'll work on a patch.

This is exactly what I was thinking about this as well.

Best regards,
	Maxim Levitsky
> 

