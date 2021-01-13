Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45452F4AF4
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhAMMFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbhAMMFj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610539451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zS8Kuje3Zrd0mSCmvEursDP8tBxHOEE7k+k/eJZre3U=;
        b=h8nmt/8ocjLz5IBaHR55IokUM10mwH5CPx8GhctsroaIktlplxDxKyet4LsJbD4qoDiCvt
        UKk0Gt6EmCo892Yi2r3C2PkQiJEufhsZTlRH6yujoOYFDuLCLwEGiJlvepC+79aVlAIdBv
        Zp9ydY+TtnLlKFJxQmp7NkeBaJ3GKTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-vnjKxs6KM9GwgpKiTztn5Q-1; Wed, 13 Jan 2021 07:04:07 -0500
X-MC-Unique: vnjKxs6KM9GwgpKiTztn5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1F3381DFAC;
        Wed, 13 Jan 2021 12:04:04 +0000 (UTC)
Received: from work-vm (ovpn-112-200.ams2.redhat.com [10.36.112.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 330EE60871;
        Wed, 13 Jan 2021 12:03:53 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:03:51 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Greg Kurz <groug@kaod.org>, pasic@linux.ibm.com,
        brijesh.singh@amd.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: Re: [PATCH v6 05/13] confidential guest support: Rework the
 "memory-encryption" property
Message-ID: <20210113120351.GG2938@work-vm>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-6-david@gibson.dropbear.id.au>
 <20210112115959.2c042dbb@bahia.lan>
 <20210113005032.GA435587@yekko.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113005032.GA435587@yekko.fritz.box>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Gibson (david@gibson.dropbear.id.au) wrote:
> On Tue, Jan 12, 2021 at 11:59:59AM +0100, Greg Kurz wrote:
> > On Tue, 12 Jan 2021 15:45:00 +1100
> > David Gibson <david@gibson.dropbear.id.au> wrote:
> > 
> > > Currently the "memory-encryption" property is only looked at once we
> > > get to kvm_init().  Although protection of guest memory from the
> > > hypervisor isn't something that could really ever work with TCG, it's
> > > not conceptually tied to the KVM accelerator.
> > > 
> > > In addition, the way the string property is resolved to an object is
> > > almost identical to how a QOM link property is handled.
> > > 
> > > So, create a new "confidential-guest-support" link property which sets
> > > this QOM interface link directly in the machine.  For compatibility we
> > > keep the "memory-encryption" property, but now implemented in terms of
> > > the new property.
> > 
> > Do we really want to keep "memory-encryption" in the long term ? If
> > not, then maybe engage the deprecation process and add a warning in
> > machine_set_memory_encryption() ?
> 
> Hmm.. I kind of think that's up to the SEV people to decide on the
> timetable (if any) for deprecation - it's their existing option.  In
> any case I'd prefer to leave that to a separate patch.
> 
> Dave (Gilbert), any opinions?

Well, the first thing would be to get libvirt to know about the new
mechanism; only when it's happy can we even think about deprecating the
old one;  but yes in the long term it makes sense.

Dave

> > Apart from that, LGTM:
> > 
> > Reviewed-by: Greg Kurz <groug@kaod.org>
> > 
> > > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > > ---
> > >  accel/kvm/kvm-all.c  |  5 +++--
> > >  accel/kvm/sev-stub.c |  5 +++--
> > >  hw/core/machine.c    | 43 +++++++++++++++++++++++++++++++++++++------
> > >  include/hw/boards.h  |  2 +-
> > >  include/sysemu/sev.h |  2 +-
> > >  target/i386/sev.c    | 32 ++------------------------------
> > >  6 files changed, 47 insertions(+), 42 deletions(-)
> > > 
> > > diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> > > index 260ed73ffe..28ab126f70 100644
> > > --- a/accel/kvm/kvm-all.c
> > > +++ b/accel/kvm/kvm-all.c
> > > @@ -2181,8 +2181,9 @@ static int kvm_init(MachineState *ms)
> > >       * if memory encryption object is specified then initialize the memory
> > >       * encryption context.
> > >       */
> > > -    if (ms->memory_encryption) {
> > > -        ret = sev_guest_init(ms->memory_encryption);
> > > +    if (ms->cgs) {
> > > +        /* FIXME handle mechanisms other than SEV */
> > > +        ret = sev_kvm_init(ms->cgs);
> > >          if (ret < 0) {
> > >              goto err;
> > >          }
> > > diff --git a/accel/kvm/sev-stub.c b/accel/kvm/sev-stub.c
> > > index 5db9ab8f00..3d4787ae4a 100644
> > > --- a/accel/kvm/sev-stub.c
> > > +++ b/accel/kvm/sev-stub.c
> > > @@ -15,7 +15,8 @@
> > >  #include "qemu-common.h"
> > >  #include "sysemu/sev.h"
> > >  
> > > -int sev_guest_init(const char *id)
> > > +int sev_kvm_init(ConfidentialGuestSupport *cgs)
> > >  {
> > > -    return -1;
> > > +    /* SEV can't be selected if it's not compiled */
> > > +    g_assert_not_reached();
> > >  }
> > > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > > index 8909117d80..94194ab82d 100644
> > > --- a/hw/core/machine.c
> > > +++ b/hw/core/machine.c
> > > @@ -32,6 +32,7 @@
> > >  #include "hw/mem/nvdimm.h"
> > >  #include "migration/global_state.h"
> > >  #include "migration/vmstate.h"
> > > +#include "exec/confidential-guest-support.h"
> > >  
> > >  GlobalProperty hw_compat_5_2[] = {};
> > >  const size_t hw_compat_5_2_len = G_N_ELEMENTS(hw_compat_5_2);
> > > @@ -427,16 +428,37 @@ static char *machine_get_memory_encryption(Object *obj, Error **errp)
> > >  {
> > >      MachineState *ms = MACHINE(obj);
> > >  
> > > -    return g_strdup(ms->memory_encryption);
> > > +    if (ms->cgs) {
> > > +        return g_strdup(object_get_canonical_path_component(OBJECT(ms->cgs)));
> > > +    }
> > > +
> > > +    return NULL;
> > >  }
> > >  
> > >  static void machine_set_memory_encryption(Object *obj, const char *value,
> > >                                          Error **errp)
> > >  {
> > > -    MachineState *ms = MACHINE(obj);
> > > +    Object *cgs =
> > > +        object_resolve_path_component(object_get_objects_root(), value);
> > > +
> > > +    if (!cgs) {
> > > +        error_setg(errp, "No such memory encryption object '%s'", value);
> > > +        return;
> > > +    }
> > >  
> > > -    g_free(ms->memory_encryption);
> > > -    ms->memory_encryption = g_strdup(value);
> > > +    object_property_set_link(obj, "confidential-guest-support", cgs, errp);
> > > +}
> > > +
> > > +static void machine_check_confidential_guest_support(const Object *obj,
> > > +                                                     const char *name,
> > > +                                                     Object *new_target,
> > > +                                                     Error **errp)
> > > +{
> > > +    /*
> > > +     * So far the only constraint is that the target has the
> > > +     * TYPE_CONFIDENTIAL_GUEST_SUPPORT interface, and that's checked
> > > +     * by the QOM core
> > > +     */
> > >  }
> > >  
> > >  static bool machine_get_nvdimm(Object *obj, Error **errp)
> > > @@ -836,6 +858,15 @@ static void machine_class_init(ObjectClass *oc, void *data)
> > >      object_class_property_set_description(oc, "suppress-vmdesc",
> > >          "Set on to disable self-describing migration");
> > >  
> > > +    object_class_property_add_link(oc, "confidential-guest-support",
> > > +                                   TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> > > +                                   offsetof(MachineState, cgs),
> > > +                                   machine_check_confidential_guest_support,
> > > +                                   OBJ_PROP_LINK_STRONG);
> > > +    object_class_property_set_description(oc, "confidential-guest-support",
> > > +                                          "Set confidential guest scheme to support");
> > > +
> > > +    /* For compatibility */
> > >      object_class_property_add_str(oc, "memory-encryption",
> > >          machine_get_memory_encryption, machine_set_memory_encryption);
> > >      object_class_property_set_description(oc, "memory-encryption",
> > > @@ -1158,9 +1189,9 @@ void machine_run_board_init(MachineState *machine)
> > >                      cc->deprecation_note);
> > >      }
> > >  
> > > -    if (machine->memory_encryption) {
> > > +    if (machine->cgs) {
> > >          /*
> > > -         * With memory encryption, the host can't see the real
> > > +         * With confidential guests, the host can't see the real
> > >           * contents of RAM, so there's no point in it trying to merge
> > >           * areas.
> > >           */
> > > diff --git a/include/hw/boards.h b/include/hw/boards.h
> > > index 17b1f3f0b9..1acd662fa5 100644
> > > --- a/include/hw/boards.h
> > > +++ b/include/hw/boards.h
> > > @@ -270,7 +270,7 @@ struct MachineState {
> > >      bool iommu;
> > >      bool suppress_vmdesc;
> > >      bool enable_graphics;
> > > -    char *memory_encryption;
> > > +    ConfidentialGuestSupport *cgs;
> > >      char *ram_memdev_id;
> > >      /*
> > >       * convenience alias to ram_memdev_id backend memory region
> > > diff --git a/include/sysemu/sev.h b/include/sysemu/sev.h
> > > index 7335e59867..3b5b1aacf1 100644
> > > --- a/include/sysemu/sev.h
> > > +++ b/include/sysemu/sev.h
> > > @@ -16,7 +16,7 @@
> > >  
> > >  #include "sysemu/kvm.h"
> > >  
> > > -int sev_guest_init(const char *id);
> > > +int sev_kvm_init(ConfidentialGuestSupport *cgs);
> > >  int sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp);
> > >  int sev_inject_launch_secret(const char *hdr, const char *secret,
> > >                               uint64_t gpa, Error **errp);
> > > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > > index 2a4b2187d6..5399a136ad 100644
> > > --- a/target/i386/sev.c
> > > +++ b/target/i386/sev.c
> > > @@ -335,26 +335,6 @@ static const TypeInfo sev_guest_info = {
> > >      }
> > >  };
> > >  
> > > -static SevGuestState *
> > > -lookup_sev_guest_info(const char *id)
> > > -{
> > > -    Object *obj;
> > > -    SevGuestState *info;
> > > -
> > > -    obj = object_resolve_path_component(object_get_objects_root(), id);
> > > -    if (!obj) {
> > > -        return NULL;
> > > -    }
> > > -
> > > -    info = (SevGuestState *)
> > > -            object_dynamic_cast(obj, TYPE_SEV_GUEST);
> > > -    if (!info) {
> > > -        return NULL;
> > > -    }
> > > -
> > > -    return info;
> > > -}
> > > -
> > >  bool
> > >  sev_enabled(void)
> > >  {
> > > @@ -682,10 +662,9 @@ sev_vm_state_change(void *opaque, int running, RunState state)
> > >      }
> > >  }
> > >  
> > > -int
> > > -sev_guest_init(const char *id)
> > > +int sev_kvm_init(ConfidentialGuestSupport *cgs)
> > >  {
> > > -    SevGuestState *sev;
> > > +    SevGuestState *sev = SEV_GUEST(cgs);
> > >      char *devname;
> > >      int ret, fw_error;
> > >      uint32_t ebx;
> > > @@ -698,13 +677,6 @@ sev_guest_init(const char *id)
> > >          return -1;
> > >      }
> > >  
> > > -    sev = lookup_sev_guest_info(id);
> > > -    if (!sev) {
> > > -        error_report("%s: '%s' is not a valid '%s' object",
> > > -                     __func__, id, TYPE_SEV_GUEST);
> > > -        goto err;
> > > -    }
> > > -
> > >      sev_guest = sev;
> > >      sev->state = SEV_STATE_UNINIT;
> > >  
> > 
> 
> -- 
> David Gibson			| I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
> 				| _way_ _around_!
> http://www.ozlabs.org/~dgibson


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

