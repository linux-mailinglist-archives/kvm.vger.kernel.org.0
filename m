Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F6880844
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 22:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbfHCUVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 16:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728906AbfHCUVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 16:21:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8EC0A4D31;
        Sat,  3 Aug 2019 20:21:35 +0000 (UTC)
Received: from amt.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17FC25C22B;
        Sat,  3 Aug 2019 20:21:35 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id C4ED6105135;
        Sat,  3 Aug 2019 17:21:05 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x73KL24Q009531;
        Sat, 3 Aug 2019 17:21:02 -0300
Date:   Sat, 3 Aug 2019 17:21:01 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpuidle-haltpoll: Enable kvm guest polling when
 dedicated physical CPUs are available
Message-ID: <20190803202058.GA9316@amt.cnet>
References: <1564643196-7797-1-git-send-email-wanpengli@tencent.com>
 <7b1e3025-f513-7068-32ac-4830d67b65ac@intel.com>
 <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3fe182f-627f-88ad-cb4d-a4189202b438@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Sat, 03 Aug 2019 20:21:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 06:54:49PM +0200, Paolo Bonzini wrote:
> On 01/08/19 18:51, Rafael J. Wysocki wrote:
> > On 8/1/2019 9:06 AM, Wanpeng Li wrote:
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> The downside of guest side polling is that polling is performed even
> >> with other runnable tasks in the host. However, even if poll in kvm
> >> can aware whether or not other runnable tasks in the same pCPU, it
> >> can still incur extra overhead in over-subscribe scenario. Now we can
> >> just enable guest polling when dedicated pCPUs are available.
> >>
> >> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >> Cc: Radim Krčmář <rkrcmar@redhat.com>
> >> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> >> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > 
> > Paolo, Marcelo, any comments?
> 
> Yes, it's a good idea.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Paolo

I think KVM_HINTS_REALTIME is being abused somewhat.
It has no clear meaning and used in different locations 
for different purposes.

For example, i think that using pv queued spinlocks and 
haltpoll is a desired scenario, which the patch below disallows.

Wanpeng Li, currently the driver does not autoload. So polling in 
the guest has to be enabled manually. Isnt that sufficient?


