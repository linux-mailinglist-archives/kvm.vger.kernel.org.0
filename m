Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C148340C6F
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 19:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhCRSFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 14:05:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhCRSFK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 14:05:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616090709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ARipjyQ/+VpEsQMvpoz97/F1MzfXWQVrW6+PPzivjCQ=;
        b=d6ASN/aLGFqNUmQkNC0KUsWnhMpBhoZFsGU6Ajq3UUoStFwMifocwwqHO4jOc2VKRpImIW
        uN3F6wW4j8PB6VXDHOnKNM/TU/KOcYwoGXuyaJGUjndiXJ4pgY/Sv9seNDVWEX4W/l+Bd4
        DTqTc2vK1nHdDEIZwJsHsMlvD0pCUOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-upV6s4IWOmG7-v7CKgApRA-1; Thu, 18 Mar 2021 14:05:08 -0400
X-MC-Unique: upV6s4IWOmG7-v7CKgApRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E883881621;
        Thu, 18 Mar 2021 18:05:06 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1262F6EF45;
        Thu, 18 Mar 2021 18:05:06 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 7470C4188684; Thu, 18 Mar 2021 15:04:46 -0300 (-03)
Date:   Thu, 18 Mar 2021 15:04:46 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 2/4] KVM: x86: hyper-v: Prevent using not-yet-updated
 TSC page by secondary CPUs
Message-ID: <20210318180446.GA41953@fuller.cnet>
References: <20210316143736.964151-1-vkuznets@redhat.com>
 <20210316143736.964151-3-vkuznets@redhat.com>
 <20210318170208.GB36190@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318170208.GB36190@fuller.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 02:02:08PM -0300, Marcelo Tosatti wrote:
> On Tue, Mar 16, 2021 at 03:37:34PM +0100, Vitaly Kuznetsov wrote:
> > When KVM_REQ_MASTERCLOCK_UPDATE request is issued (e.g. after migration)
> > we need to make sure no vCPU sees stale values in PV clock structures and
> > thus all vCPUs are kicked with KVM_REQ_CLOCK_UPDATE. Hyper-V TSC page
> > clocksource is global and kvm_guest_time_update() only updates in on vCPU0
> > but this is not entirely correct: nothing blocks some other vCPU from
> > entering the guest before we finish the update on CPU0 and it can read
> > stale values from the page.
> > 
> > Invalidate TSC page in kvm_gen_update_masterclock() to switch all vCPUs
> > to using MSR based clocksource (HV_X64_MSR_TIME_REF_COUNT).
> 
> Hi Vitaly,
> 
> Not clear why this is necessary, if the choice was to not touch TSC page
> at all, when invariant TSC is supported on the host...
	
	s/invariant TSC/TSC scaling/

> Ah, OK, this is not for the migration with iTSC on destination case,
> but any call to kvm_gen_update_masterclock, correct?

