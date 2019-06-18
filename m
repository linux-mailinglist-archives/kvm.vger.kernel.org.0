Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B5E4A5C8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbfFRPsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:48:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbfFRPsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:48:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3AC04309703F;
        Tue, 18 Jun 2019 15:48:22 +0000 (UTC)
Received: from work-vm (ovpn-117-76.ams2.redhat.com [10.36.117.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A8307D925;
        Tue, 18 Jun 2019 15:48:20 +0000 (UTC)
Date:   Tue, 18 Jun 2019 16:48:17 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: Re: [QEMU PATCH v3 7/9] KVM: i386: Add support for save and restore
 nested state
Message-ID: <20190618154817.GI2850@work-vm>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
 <20190618090316.GC2850@work-vm>
 <32C4B530-A135-475B-B6AF-9288D372920D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32C4B530-A135-475B-B6AF-9288D372920D@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 18 Jun 2019 15:48:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> 
> > On 18 Jun 2019, at 12:03, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > 
> > * Liran Alon (liran.alon@oracle.com) wrote:
> >> 
> >> +static const VMStateDescription vmstate_vmx_vmcs12 = {
> >> +	.name = "cpu/kvm_nested_state/vmx/vmcs12",
> >> +	.version_id = 1,
> >> +	.minimum_version_id = 1,
> >> +	.needed = vmx_vmcs12_needed,
> >> +	.fields = (VMStateField[]) {
> >> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].vmcs12,
> >> +	                        struct kvm_nested_state, 0x1000),
> > 
> > Where did that magic 0x1000 come from?
> 
> Currently, KVM folks (including myself), haven’t decided yet to expose vmcs12 struct layout to userspace but instead to still leave it opaque.
> The formal size of this size is VMCS12_SIZE (defined in kernel as 0x1000). I was wondering if we wish to expose VMCS12_SIZE constant to userspace or not.
> So currently I defined these __u8 arrays as 0x1000. But in case Paolo agrees to expose VMCS12_SIZE, we can use that instead.

Well if it's not defined it's bound to change at some state!
Also, do we need to clear it before we get it from the kernel - e.g.
is the kernel guaranteed to give us 0x1000 ?

Dave

> -Liran
> 
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
