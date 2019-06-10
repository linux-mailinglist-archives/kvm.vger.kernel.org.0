Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D2E3B264
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 11:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389111AbfFJJov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 05:44:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387977AbfFJJov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 05:44:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 343823086225;
        Mon, 10 Jun 2019 09:44:51 +0000 (UTC)
Received: from work-vm (ovpn-117-16.ams2.redhat.com [10.36.117.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C8E65C219;
        Mon, 10 Jun 2019 09:44:47 +0000 (UTC)
Date:   Mon, 10 Jun 2019 10:44:44 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: QEMU/KVM migration backwards compatibility broken?
Message-ID: <20190610094444.GB22439@work-vm>
References: <20190606084222.GA2788@work-vm>
 <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
 <20190606092358.GE2788@work-vm>
 <8F3FD038-12DB-44BC-A262-3F1B55079753@oracle.com>
 <20190606103958.GJ2788@work-vm>
 <B7A9A778-9BD5-449E-A8F3-5D8E3471F4A6@oracle.com>
 <20190606110737.GK2788@work-vm>
 <3F6B41CD-C7E2-4A61-875C-F61AE45F2A58@oracle.com>
 <20190606133138.GM2788@work-vm>
 <041C1ABE-48B4-487A-B0EF-67F0FBFCA8BE@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <041C1ABE-48B4-487A-B0EF-67F0FBFCA8BE@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Mon, 10 Jun 2019 09:44:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> 
> > On 6 Jun 2019, at 16:31, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > 
> >>> 
> >>> So we still need to tie subsections to machine types; that way
> >>> you don't send them to old qemu's and there for you don't have the
> >>> problem of the qemu receiving something it doesn't know.
> >> 
> >> I agree that if there is no way to skip a VMState subsection in the stream, then we must
> >> have a way to specify to source QEMU to prevent sending this subsection to destination…
> >> 
> >> I would suggest though that instead of having a flag tied to machine-type, we will have a QMP command
> >> that can specify names of subsections we explicitly wish to be skipped sending to destination even if their .needed() method returns true.
> > 
> > I don't like the thought of generically going behind the devices back;
> > it's pretty rare to have to do this, so adding a qmp command to tweak
> > properties that we've already got seems to make more sense to me.
> > 
> >> This seems like a more explicit approach and doesn’t come with the down-side of forever not migrating this VMState subsection
> > Dave
> 
> If I understand you correctly, this is what you propose:
> 1) Have a .post_load() method for VMState subsections that depend on kernel capability to fail migration in case capability do not exist.

Yes (wehther it fails or prints a warning depends on how significant the
capability is; if it's a guest crash then fail is probably best).

> 2) For specific problematic VMState subsections, add property such that it’s .needed() method will return false in case the property is set to false (value is true by default).
> 3) Have a QMP command that allows dynamically changing the value of these properties.
> 4) Properties values are still tied to machine-type? I think not right?

Property values are initialised from the machine type; in your case
where you want to upgrade to use a new feature then you can use
(3) to change it.

> I instead propose the following:
> 1) Same as (1) above.
> 2) Add a MigrationParameter (and matching MigrationCapability) named “avoid_state” that specifies list of subsection names to avoid sending in migration even if their .needed() method will return false. i.e. We will modify migration/vmstate.c to not even call .needed() method of such subsection.
> 
> I believe the second proposal have the following advantages:
> 1) Less error-prone: .needed() methods are written only once and don’t need to take into account additional properties when calculating if they are required or not. Just depend on guest state.
> 2) Generic: We don’t require additional patch to add a new property to support avoiding sending some subsection in case it doesn’t matter for some workload. As we have discovered only late after msr_smi_count was added (by me) at that point. Second approach allows avoid sending any subsection that is deemed not important to guest workload by migration admin.
> 3) Not tied to machine-type: Properties are usually tied to machine-type as they need to remain same forever for the lifetime of the guest. However, migration parameters are per-migration and are meant to be tweaked and changed. This allows a guest that used to run on old QEMU and moved to new QEMU to now have better state saved for it’s next future migrations.
> 
> Currently we indeed have very rare cases like this ([git grep \"x-migrate | wc -l] product only 4 results…) but I’m not sure it’s not only because we haven’t analysed carefully the case of
> restored properties that it’s property depend on kernel capability.
> 
> As a start thought, we can start by at least agreeing to implement (1) and consider the property VS MigrationParameter discussion for a later time.
> 
> What do you think?

I still don't like exposing a list of migration subsections into an
interface.

Dave

> -Liran
> 
> 
> 
> 
> 
> 
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
