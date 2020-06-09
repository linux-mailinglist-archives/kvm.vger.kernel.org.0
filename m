Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38E61F474B
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 21:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgFITlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 15:41:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:55550 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389305AbgFITlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 15:41:15 -0400
IronPort-SDR: qyNMsHQSciIwvqjKM2TxjlI8NiyuLhlWoVDaWPv/7Aig+VuF44WnLDdOWPbIHNtIGQXXqLP0Wp
 6GIHcPjjsdLQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2020 12:41:14 -0700
IronPort-SDR: fhpdYRU5FgDmU+5o30NEvGCc5e7/YKXxQnuMiuSUD8hh0wChFEOHE5LVXEdfazJB2uHlQbzAxZ
 TYStdIYJL2Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,493,1583222400"; 
   d="scan'208";a="349620540"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2020 12:41:14 -0700
Date:   Tue, 9 Jun 2020 12:41:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Message-ID: <20200609194114.GA15818@linux.intel.com>
References: <20200603144914.41645-1-david@redhat.com>
 <20200609091034-mutt-send-email-mst@kernel.org>
 <08385823-d98f-fd9d-aa9d-bc1bd6747c29@redhat.com>
 <20200609115814-mutt-send-email-mst@kernel.org>
 <20200609161814.GJ2366737@habkost.net>
 <33021b38-cf60-fbfc-1baa-478ee6eed376@redhat.com>
 <20200609144242-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609144242-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 09, 2020 at 02:42:59PM -0400, Michael S. Tsirkin wrote:
> On Tue, Jun 09, 2020 at 08:38:15PM +0200, David Hildenbrand wrote:
> > On 09.06.20 18:18, Eduardo Habkost wrote:
> > > On Tue, Jun 09, 2020 at 11:59:04AM -0400, Michael S. Tsirkin wrote:
> > >> On Tue, Jun 09, 2020 at 03:26:08PM +0200, David Hildenbrand wrote:
> > >>> On 09.06.20 15:11, Michael S. Tsirkin wrote:
> > >>>> On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
> > >>>>> This is the very basic, initial version of virtio-mem. More info on
> > >>>>> virtio-mem in general can be found in the Linux kernel driver v2 posting
> > >>>>> [1] and in patch #10. The latest Linux driver v4 can be found at [2].
> > >>>>>
> > >>>>> This series is based on [3]:
> > >>>>>     "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices on all
> > >>>>>      buses"
> > >>>>>
> > >>>>> The patches can be found at:
> > >>>>>     https://github.com/davidhildenbrand/qemu.git virtio-mem-v3
> > >>>>
> > >>>> So given we tweaked the config space a bit, this needs a respin.
> > >>>
> > >>> Yeah, the virtio-mem-v4 branch already contains a fixed-up version. Will
> > >>> send during the next days.
> > >>
> > >> BTW. People don't normally capitalize the letter after ":".
> > >> So a better subject is
> > >>   virtio-mem: paravirtualized memory hot(un)plug
> > > 
> > > I'm not sure that's still the rule:
> > > 
> > > [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [A-Z]' | wc -l
> > > 5261
> > > [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [a-z]' | wc -l
> > > 2921
> > > 
> > 
> > Yeah, I switched to this scheme some years ago (I even remember that
> > some QEMU maintainer recommended it). I decided to just always
> > capitalize. Not that it should really matter ... :)
> 
> Don't mind about qemu but you don't want to do that for Linux.

Heh, depends on who you ask.  The tip tree maintainers (strongly) prefer
capitalizing the first word after the colon[*], and that naturally
percolates into a lot of other subsystems, e.g. I follow that pattern for
KVM so that I don't have to remember to switch when submitting patches
against a tip branch.


+Patch subject
+^^^^^^^^^^^^^
+
+The tip tree preferred format for patch subject prefixes is
+'subsys/component:', e.g. 'x86/apic:', 'x86/mm/fault:', 'sched/fair:',
+'genirq/core:'. Please do not use file names or complete file paths as
+prefix. 'git log path/to/file' should give you a reasonable hint in most
+cases.
+
+The condensed patch description in the subject line should start with a
+uppercase letter and should be written in imperative tone.

[*] https://lkml.kernel.org/r/20181107171149.165693799@linutronix.de

