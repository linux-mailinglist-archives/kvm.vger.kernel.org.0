Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD037C5C
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbfFFSgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfFFSgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:36:45 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2AAA3079B63;
        Thu,  6 Jun 2019 18:36:40 +0000 (UTC)
Received: from ultra.random (ovpn-120-155.rdu2.redhat.com [10.10.120.155])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF335C2E6;
        Thu,  6 Jun 2019 18:36:33 +0000 (UTC)
Date:   Thu, 6 Jun 2019 14:36:32 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch v2 3/3] cpuidle-haltpoll: disable host side polling when
 kvm virtualized
Message-ID: <20190606183632.GA20928@redhat.com>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet>
 <20190604122404.GA18979@amt.cnet>
 <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 06 Jun 2019 18:36:45 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Thu, Jun 06, 2019 at 07:25:28PM +0100, Joao Martins wrote:
> But I wonder whether we should fail to load cpuidle-haltpoll when host halt
> polling can't be disabled[*]? That is to avoid polling in both host and guest
> and *possibly* avoid chances for performance regressions when running on older
> hypervisors?

I don't think it's necessary: that would force an upgrade of the host
KVM version in order to use the guest haltpoll feature with an
upgraded guest kernel that can use the guest haltpoll.

The guest haltpoll is self contained in the guest, so there's no
reason to prevent that by design or to force upgrade of the KVM host
version. It'd be more than enough to reload kvm.ko in the host with
the host haltpoll set to zero with the module parameter already
available, to achieve the same runtime without requiring a forced host
upgrade.

The warning however sounds sensible.

Thanks,
Andrea
