Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC5A57179
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfFZTVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 15:21:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47614 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFZTVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 15:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=V0jLxYAn+nqGzG0R8aNQz9MoPnspgo1/uyky7k+5p+k=; b=uxdz562loKTGsLdJtWlp/cwLTe
        GT+1eM+P/R1wFx79woFof2wJjB3Y9vYfQmzpdcIaIU83pKIZREcTNlzD+0rQbxJwujSJKNBgvz9IV
        LfVVZ6NxKM9RyPIIiCojd62gd1v+4J2V/GBk5FOPvpYUHzl3whUUNTdAOcHZTcjTpPdM/mz61drdu
        oo61DWBQRp82BvcQCC0MBkBHPF41qM8CnNL0XyGaV4JF23Vez0fIIQIxizHvdYj+Y5W2IPqa2Beyi
        zcX6IUhMf3KUcXS+1oP8DCrEk6svsMb7I5V++fYKN5uW4u74Lcyxrw/VVZ73r6dddBMWyTsKxrZL5
        l/KTyAEg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgDTb-0001Mk-E0; Wed, 26 Jun 2019 19:21:03 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A49CC209CEDA7; Wed, 26 Jun 2019 21:21:00 +0200 (CEST)
Date:   Wed, 26 Jun 2019 21:21:00 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: cputime takes cstate into consideration
Message-ID: <20190626192100.GP3419@hirez.programming.kicks-ass.net>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com>
 <20190626161608.GM3419@hirez.programming.kicks-ass.net>
 <20190626183016.GA16439@char.us.oracle.com>
 <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>
 <1561575336.25880.7.camel@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1561575336.25880.7.camel@amazon.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 06:55:36PM +0000, Raslan, KarimAllah wrote:

> If the host is completely in no_full_hz mode and the pCPU is dedicated to a 
> single vCPU/task (and the guest is 100% CPU bound and never exits), you would 
> still be ticking in the host once every second for housekeeping, right? Would 
> not updating the mwait-time once a second be enough here?

People are trying very hard to get rid of that remnant tick. Lets not
add dependencies to it.

IMO this is a really stupid issue, 100% time is correct if the guest
does idle in pinned vcpu mode.
