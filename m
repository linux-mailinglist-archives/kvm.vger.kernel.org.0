Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287FE148F6F
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 21:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404318AbgAXUgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 15:36:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgAXUgr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Jan 2020 15:36:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579898206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wYPFnForP5DW9b9y/S2cEuNSkYqUwYPt/8FCorq3d2E=;
        b=T9XHfqfXRbwgoGc9W+hxypeoFOeivMIgxgCKrtW+6gytlpUYmqWDVtbVFhnA8EiB900NHt
        j6GV6rb+hyAXYSnTvY1wmiMCNO21P6AWL0NPp3DHiE5T46PT1yNupinGrR7BAG5qxx09em
        hbjuRc7LRJQIbnsxJAjLbSgAcyWOQlY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-SakrKCg8Pc2g8uEbqAzK0w-1; Fri, 24 Jan 2020 15:36:45 -0500
X-MC-Unique: SakrKCg8Pc2g8uEbqAzK0w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03E91800D41;
        Fri, 24 Jan 2020 20:36:44 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-59.gru2.redhat.com [10.97.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C05F4867E3;
        Fri, 24 Jan 2020 20:36:43 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 2755C418CC03; Fri, 24 Jan 2020 17:36:30 -0300 (-03)
Date:   Fri, 24 Jan 2020 17:36:30 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: do not mix raw and monotonic clocks in
 kvmclock
Message-ID: <20200124203630.GA28074@fuller.cnet>
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 22, 2020 at 03:22:31PM +0100, Paolo Bonzini wrote:
> Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
> clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
> the default kvmclock_offset for the VM was still based on the monotonic
> clock and, if the raw clock drifted enough from the monotonic clock,
> this could cause a negative system_time to be written to the guest's
> struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
> observe a negative time value) it hangs.
> 
> This series fixes the issue by using the raw clock everywhere.
> 
> (And this, ladies and gentlemen, is why I was not applying patches to
> the KVM tree.  I saw this before Christmas and could only reproduce it
> today, since it requires almost 2 weeks of uptime to reproduce on my
> machine.  Of course, once you have the reproducer the fix is relatively
> easy to come up with).
> 
> Paolo
> 
> Paolo Bonzini (2):
>   KVM: x86: reorganize pvclock_gtod_data members
>   KVM: x86: use raw clock values consistently
> 
>  arch/x86/kvm/x86.c | 67 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 35 insertions(+), 32 deletions(-)
> 
> -- 
> 1.8.3.1

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

BTW, should switch both masterclock and non-masterclock cases
to raw clock base. Do you see any problem with that? 

Using the same reasoning as raw clock for master, ntpd in 
the guest should correct the difference.

Could probably simplify things.

