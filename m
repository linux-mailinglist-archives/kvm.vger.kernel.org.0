Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E9A397E5
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 23:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731338AbfFGVjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 17:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbfFGVjG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 17:39:06 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ECAD30872DC;
        Fri,  7 Jun 2019 21:39:06 +0000 (UTC)
Received: from amt.cnet (ovpn-112-16.gru2.redhat.com [10.97.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C52CD60D61;
        Fri,  7 Jun 2019 21:39:05 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 6A30A105165;
        Fri,  7 Jun 2019 17:38:35 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x57KcVo0023604;
        Fri, 7 Jun 2019 17:38:31 -0300
Date:   Fri, 7 Jun 2019 17:38:31 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
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
Message-ID: <20190607203828.GC5542@amt.cnet>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.360289262@amt.cnet>
 <20190604122404.GA18979@amt.cnet>
 <cb11ef01-b579-1526-d585-0c815f2e1f6f@oracle.com>
 <20190606183632.GA20928@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606183632.GA20928@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 07 Jun 2019 21:39:06 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 02:36:32PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Thu, Jun 06, 2019 at 07:25:28PM +0100, Joao Martins wrote:
> > But I wonder whether we should fail to load cpuidle-haltpoll when host halt
> > polling can't be disabled[*]? That is to avoid polling in both host and guest
> > and *possibly* avoid chances for performance regressions when running on older
> > hypervisors?
> 
> I don't think it's necessary: that would force an upgrade of the host
> KVM version in order to use the guest haltpoll feature with an
> upgraded guest kernel that can use the guest haltpoll.
> 
> The guest haltpoll is self contained in the guest, so there's no
> reason to prevent that by design or to force upgrade of the KVM host
> version. It'd be more than enough to reload kvm.ko in the host with
> the host haltpoll set to zero with the module parameter already
> available, to achieve the same runtime without requiring a forced host
> upgrade.
> 
> The warning however sounds sensible.

Alright, added a warning:

void arch_haltpoll_enable(void)
{
        if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
                WARN_ONCE(1, "kvm: host does not support poll control, can't "
                             "disable host polling (host upgrade "
                             " recommended).\n"
                return;
        }

Thanks

