Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229C4340D04
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhCRSbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:31:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27146 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231590AbhCRSbR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 14:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616092276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0mw/nf+8C6A4qj8FRDm7YP6EnE67XsUZD9T0VjBOeds=;
        b=Ugud/K9WhLbutfzY03Sj6dbcYqtt0kFeE9Ln12dPMR0fybL0i9Go+Sxlvlx1UTabZE/fD5
        3pVizKHMjmFzt1/YOCO3QVhHEfC+wJp0fWNpPIMjZXPh/Kvj4SfZS6Wra/kGH+gmEdqF43
        BIkYtGu+hGd1kbNk/o9i6OzN/TFiIrY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-_3Zb7MdKMvmHMTN_EGnyFw-1; Thu, 18 Mar 2021 14:31:14 -0400
X-MC-Unique: _3Zb7MdKMvmHMTN_EGnyFw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D3C91034B34;
        Thu, 18 Mar 2021 18:31:13 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 055A860CD7;
        Thu, 18 Mar 2021 18:31:13 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 75D704188684; Thu, 18 Mar 2021 15:30:42 -0300 (-03)
Date:   Thu, 18 Mar 2021 15:30:42 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
Message-ID: <20210318183042.GA42884@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-3-vkuznets@redhat.com>
 <20210318170208.GB36190@fuller.cnet>
 <20210318180446.GA41953@fuller.cnet>
 <5634f6c9-bee9-ae07-c8ce-8e79bd2bd1a7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5634f6c9-bee9-ae07-c8ce-8e79bd2bd1a7@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 07:05:49PM +0100, Paolo Bonzini wrote:
> On 18/03/21 19:04, Marcelo Tosatti wrote:
> > > 
> > > Not clear why this is necessary, if the choice was to not touch TSC page
> > > at all, when invariant TSC is supported on the host...
> > 	
> > 	s/invariant TSC/TSC scaling/
> > 
> > > Ah, OK, this is not for the migration with iTSC on destination case,
> > > but any call to kvm_gen_update_masterclock, correct?
> 
> Yes, any update can be racy.
> 
> Paolo

Which makes an unrelated KVM_REQ_MASTERCLOCK_UPDATE -> kvm_gen_update_masterclock 
sequence to inadvertedly reduce performance a possibility, unless i am
missing something.

Ah, OK, it should be enabled again at KVM_REQ_CLOCK_UPDATE.

Nevermind, then.

