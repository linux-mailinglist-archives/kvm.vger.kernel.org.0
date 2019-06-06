Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF1B3727B
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 13:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfFFLHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 07:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44072 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfFFLHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 07:07:44 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6ADC8F90F;
        Thu,  6 Jun 2019 11:07:43 +0000 (UTC)
Received: from work-vm (ovpn-116-119.ams2.redhat.com [10.36.116.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B67E22A345;
        Thu,  6 Jun 2019 11:07:40 +0000 (UTC)
Date:   Thu, 6 Jun 2019 12:07:38 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: QEMU/KVM migration backwards compatibility broken?
Message-ID: <20190606110737.GK2788@work-vm>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
 <20190606084222.GA2788@work-vm>
 <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
 <20190606092358.GE2788@work-vm>
 <8F3FD038-12DB-44BC-A262-3F1B55079753@oracle.com>
 <20190606103958.GJ2788@work-vm>
 <B7A9A778-9BD5-449E-A8F3-5D8E3471F4A6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B7A9A778-9BD5-449E-A8F3-5D8E3471F4A6@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 06 Jun 2019 11:07:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> 
> 
> > On 6 Jun 2019, at 13:39, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> > 
> > * Liran Alon (liran.alon@oracle.com) wrote:
> >> 
> >> 
> >>> On 6 Jun 2019, at 12:23, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> >>> 
> >>> * Liran Alon (liran.alon@oracle.com) wrote:
> >>>> 
> >>>> 
> >>>>> On 6 Jun 2019, at 11:42, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:
> >>>>> 
> >>>>> * Liran Alon (liran.alon@oracle.com) wrote:
> >>>>>> Hi,
> >>>>>> 
> >>>>>> Looking at QEMU source code, I am puzzled regarding how migration backwards compatibility is preserved regarding X86CPU.
> >>>>>> 
> >>>>>> As I understand it, fields that are based on KVM capabilities and guest runtime usage are defined in VMState subsections in order to not send them if not necessary.
> >>>>>> This is done such that in case they are not needed and we migrate to an old QEMU which don’t support loading this state, migration will still succeed
> >>>>>> (As .needed() method will return false and therefore this state won’t be sent as part of migration stream).
> >>>>>> Furthermore, in case .needed() returns true and old QEMU don’t support loading this state, migration fails. As it should because we are aware that guest state
> >>>>>> is not going to be restored properly on destination.
> >>>>>> 
> >>>>>> I’m puzzled about what will happen in the following scenario:
> >>>>>> 1) Source is running new QEMU with new KVM that supports save of some VMState subsection.
> >>>>>> 2) Destination is running new QEMU that supports load this state but with old kernel that doesn’t know how to load this state.
> >>>>>> 
> >>>>>> I would have expected in this case that if source .needed() returns true, then migration will fail because of lack of support in destination kernel.
> >>>>>> However, it seems from current QEMU code that this will actually succeed in many cases.
> >>>>>> 
> >>>>>> For example, if msr_smi_count is sent as part of migration stream (See vmstate_msr_smi_count) and destination have has_msr_smi_count==false,
> >>>>>> then destination will succeed loading migration stream but kvm_put_msrs() will actually ignore env->msr_smi_count and will successfully load guest state.
> >>>>>> Therefore, migration will succeed even though it should have failed…
> >>>>>> 
> >>>>>> It seems to me that QEMU should have for every such VMState subsection, a .post_load() method that verifies that relevant capability is supported by kernel
> >>>>>> and otherwise fail migration.
> >>>>>> 
> >>>>>> What do you think? Should I really create a patch to modify all these CPUX86 VMState subsections to behave like this?
> >>>>> 
> >>>>> I don't know the x86 specific side that much; but from my migration side
> >>>>> the answer should mostly be through machine types - indeed for smi-count
> >>>>> there's a property 'x-migrate-smi-count' which is off for machine types
> >>>>> pre 2.11 (see hw/i386/pc.c pc_compat_2_11) - so if you've got an old
> >>>>> kernel you should stick to the old machine types.
> >>>>> 
> >>>>> There's nothing guarding running the new machine type on old-kernels;
> >>>>> and arguably we should have a check at startup that complains if
> >>>>> your kernel is missing something the machine type uses.
> >>>>> However, that would mean that people running with -M pc   would fail
> >>>>> on old kernels.
> >>>>> 
> >>>>> A post-load is also a valid check; but one question is whether,
> >>>>> for a particular register, the pain is worth it - it depends on the
> >>>>> symptom that the missing state causes.  If it's minor then you might
> >>>>> conclude it's not worth a failed migration;  if it's a hung or
> >>>>> corrupt guest then yes it is.   Certainly a warning printed is worth
> >>>>> it.
> >>>>> 
> >>>>> Dave
> >>>> 
> >>>> I think we should have flags that allow user to specify which VMState subsections user explicitly allow to avoid restore even though they are required to fully restore guest state.
> >>>> But it seems to me that the behaviour should be to always fail migration in case we load a VMState subsections that we are unable to restore unless user explicitly specified this is ok
> >>>> for this specific subsection.
> >>>> Therefore, it seems that for every VMState subsection that it’s restore is based on kernel capability we should:
> >>>> 1) Have a user-controllable flag (which is also tied to machine-type?) to explicitly allow avoid restoring this state if cannot. Default should be “false”.
> >>>> 2) Have a .post_load() method that verifies we have required kernel capability to restore this state, unless flag (1) was specified as “true”.
> >>> 
> >>> This seems a lot of flags; users aren't going to know what to do with
> >>> all of them; I don't see what will set/control them.
> >> 
> >> True but I think users will want to specify only for a handful of VMState subsections that it is OK to not restore them even thought hey are deemed needed by source QEMU.
> >> We can create flags only for those VMState subsections.
> >> User should set these flags explicitly on QEMU command-line. As a “-cpu” property? I don’t think these flags should be tied to machine-type.
> > 
> > I don't see who is going to work out these flags and send them.
> > 
> >>> 
> >>>> Note that above mentioned flags is different than flags such as “x-migrate-smi-count”.
> >>>> The purpose of “x-migrate-smi-count” flag is to avoid sending the VMState subsection to begin with in case we know we migrate to older QEMU which don’t even have the relevant VMState subsection. But it is not relevant for the case both source and destination runs QEMU which understands the VMState subsection but run on kernels with different capabilities.
> >>>> 
> >>>> Also note regarding your first paragraph, that specifying flags based on kernel you are running on doesn’t help for the case discussed here.
> >>>> As source QEMU is running on new kernel. Unless you meant that source QEMU should use relevant machine-type based on the destination kernel.
> >>>> i.e. You should launch QEMU with old machine-type as long as you have hosts in your migration pool that runs with old kernel.
> >>> 
> >>> That's what I meant; stick to the old machine-type unless you know it's
> >>> safe to use a newer one.
> >>> 
> >>>> I don’ think it’s the right approach though. As there is no way to change flags such as “x-migrate-smi-count” dynamically after all hosts in migration pool have been upgraded.
> >>>> 
> >>>> What do you think?
> >>> 
> >>> I don't have an easy answer.  The users already have to make sure they
> >>> use a machine type that's old enough for all the QEMUs installed in
> >>> their cluster; making sure it's also old enough for their oldest
> >>> kernel isn't too big a difference - *except* that it's much harder to
> >>> tell which kernel corresponds to which feature/machine type etc - so
> >>> how does a user know what the newest supported machine type is?
> >>> Failing at startup when selecting a machine type that the current
> >>> kernel can't support would help that.
> >>> 
> >>> Dave
> >> 
> >> First, machine-type express the set of vHW behaviour and properties that is exposed to guest.
> >> Therefore, machine-type shouldn’t change for a given guest lifetime (including Live-Migrations).
> >> Otherwise, guest will experience different vHW behaviour and properties before/after Live-Migration.
> >> So I think machine-type is not relevant for this discussion. We should focus on flags which specify
> >> migration behaviour (such as “x-migrate-smi-count” which can also be controlled by machine-type but not only).
> > 
> > Machine type specifies two things:
> >  a) The view from the guest
> >  b) Migration compatibility
> > 
> > (b) is explicitly documented in qemu's docs/devel/migration.rst, see the
> > subsection on subsections.
> > 
> >> Second, this strategy results in inefficient migration management. Consider the following scenario:
> >> 1) Guest running on new_qemu+old_kernel migrate to host with new_qemu+new_kernel.
> >> Because source is old_kernel than destination QEMU is launched with (x-migrate-smi-count == false).
> >> 2) Assume at this point fleet of hosts have half of hosts with old_kernel and half with new_kernel.
> >> 3) Further assume that guest workload indeed use msr_smi_count and therefore relevant VMState subsection should be sent to properly preserve guest state.
> >> 4) From some reason, we decide to migrate again the guest in (1).
> >> Even if guest is migrated to a host with new_kernel, then QEMU still avoids sending msr_smi_count VMState subsection because it is launched with (x-migrate-smi-count == false).
> >> 
> >> Therefore, I think it makes more sense that source QEMU will always send all VMState subsection that are deemed needed (i.e. .nedeed() returns true)
> >> and let receive-side decide if migration should fail if this subsection was sent but failed to be restored.
> >> The only case which I think sender should limit the VMState subsection it sends to destination is because source is running older QEMU
> >> which is not even aware of this VMState subsection (Which is to my understanding the rational behind using “x-migrate-smi-count” and tie it up to machine-type).
> > 
> > But we want to avoid failed migrations if we can; so in general we don't
> > want to be sending subsections to destinations that can't handle them.
> > The only case where it's reasonable is when there's a migration bug such
> > that the behaviour in the guest is really nasty; if there's a choice
> > between a failed migration or a hung/corrupt guest I'll take a failed
> > migration.
> > 
> >> Third, let’s assume all hosts in fleet was upgraded to new_kernel. How do I modify all launched QEMUs on these new hosts to now have “x-migrate-smi-count” set to true?
> >> As I would like future migrations to do send this VMState subsection. Currently there is no QMP command to update these flags.
> > 
> > I guess that's possible - it's pretty painful though; you're going to
> > have to teach your management layer about features/fixes of the kernels
> > and which flags to tweak in qemu.  Having said that, if you could do it,
> > then you'd avoid having to restart VMs to pick up a few fixes.
> > 
> >> Fourth, I think it’s not trivial for management-plane to be aware with which flags it should set on destination QEMU based on currently running kernels on fleet.
> >> It’s not the same as machine-type, as already discussed above doesn’t change during the entire lifetime of guest.
> > 
> > Right, which is why I don't see your idea of adding flags will work.
> > I don't see how anything will figure out what the right flags to use
> > are.
> > (Getting the management layers to do sane things with the cpuid flags
> > is already a nightmare, and they're fairly well understood).
> > 
> >> I’m also not sure it is a good idea that we currently control flags such as “x-migrate-smi-count” from machine-type.
> >> As it means that if a guest was initially launched using some old QEMU, it will *forever* not migrate some VMState subsection during all it’s Live-Migrations.
> >> Even if all hosts and all QEMUs on fleet are capable of migrating this state properly.
> >> Maybe it is preferred that this flag was specified as part of “migrate” command itself in case management-plane knows it wishes to migrate even though dest QEMU
> >> is older and doesn’t understand this specific VMState subsection.
> >> 
> >> I’m left pretty confused about QEMU’s migration compatibility strategy...
> > 
> > The compatibility strategy is the machine type;  but yes it does
> > have a problem when it's not really just a qemu version - but also
> > kernel (and external libraries, etc).
> > My general advice is that users should be updating their kernels and
> > qemus together; but I realise there's lots of cases where that
> > doesn't work.
> > 
> > Dave
> 
> I think it’s not practical advise to expect users to always upgrade kernel and QEMU together.
> In fact, users prefer to upgrade them separately to avoid doing major upgrades at once and to better pin-point root-cause of issues.

It's tricky; for distro-based users, hitting 'update' and getting both
makes a lot of sense; but as you say you ened to let them do stuff
individually if they want to, so they can track down problems.
There's also a newer problem which is people want to run the QEMU in
containers on hosts that have separate update schedules - the kernel
version relationship is then much more fluid.

> Compiling all above very useful discussion (thanks for this!), I may have a better suggestion that doesn’t require any additional flags:
> 1) Source QEMU will always send all all VMState subsections that is deemed by source QEMU as required to not break guest semantic behaviour.
> This is done by .needed() methods that examine guest runtime state to understand if this state is required to be sent or not.

So that's as we already do.

> 2) Destination QEMU will provide a generic QMP command which allows to set names of VMState subsections that if accepted on migration stream
> and failed to be loaded (because either subsection name is not implemented or because .post_load() method failed) then the failure should be ignored
> and migration should continue as usual. By default, the list of this names will be empty.

The format of the migration stream means that you can't skip an unknown
subsection; it's not possible to resume parsing the stream without
knowing what was supposed to be there. [This is pretty awful
but my last attempts to rework it hit a dead end]

So we still need to tie subsections to machine types; that way
you don't send them to old qemu's and there for you don't have the
problem of the qemu receiving something it doesn't know.

Still, you could skip things where the destination kernel doesn't know
about it.

> 3) Destination QEMU will implement .post_load() method for all these VMState subsections that depend on kernel capability to be restored properly
> such that it will fail subsection load in case kernel capability is not present. (Note that this load failure will be ignored if subsection name is specified in (2)).
> 
> Above suggestion have the following properties:
> 1) Doesn’t require any flag to be added to QEMU.

There's no logical difference between 'flags' and 'names of subsections'
- they're got the same problem in someone somewhere knowing which are
  safe.

> 2) Moves all control on whether to fail migration because of failure to load VMState subsection to receiver side. Sender always attempts to send max state he believes is required.
> 3) We remove coupling of migration compatibility from machine-type.
> 
> What do you think?

Sorry, can't do (3) - we need to keep the binding for subsections to
machine types for qemu compatibility;  I'm open for something for
kernel compat, but not when it's breaking the qemu subsection
checks.

Dave

> 
> -Liran
> 
> > 
> >> -Liran
> >> 
> >>> 
> >>>> -Liran
> >>>> 
> >>>>> 
> >>>>>> Thanks,
> >>>>>> -Liran
> >>>>> --
> >>>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >>>> 
> >>> --
> >>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >> 
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
