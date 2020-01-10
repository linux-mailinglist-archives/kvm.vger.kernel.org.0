Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E3F137141
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgAJPaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 10:30:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728100AbgAJPaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 10:30:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578670203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sJNh1uxufS6tY4jbZR6tw4iBKLWQowKRssWFLqff6nw=;
        b=iWH/LU+uviv5/Vi3kOpd3lEK1prQINFuBIOIA4ifqCJHJ9UiiUAXMZFkX0ep+wwTN7eyHa
        CJnqlbryINORHXGYNaXF83Nta+rh6mVSGOzh8UsRjF+warwRFuQTgBwGvoisik9X+f/FpG
        0f/CsBO4pjNhGp5s1HILrFmpF8QdvAw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-zW__VrgTPBe-hib5yl8qtg-1; Fri, 10 Jan 2020 10:30:02 -0500
X-MC-Unique: zW__VrgTPBe-hib5yl8qtg-1
Received: by mail-qk1-f200.google.com with SMTP id c202so1418275qkg.4
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 07:30:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJNh1uxufS6tY4jbZR6tw4iBKLWQowKRssWFLqff6nw=;
        b=uDN/Cv75r6fQUtY7+C0xcStIDeuIGTOne9guq96RTNbhmBaUe1G2F5oMzrrbXVFL7T
         Iew3ZTWFbUv/sLXCGI2gVCZdg8mbhxBRo+1po4oYPWm0tJ4ZdN0urt/fi+h5JzQnjbvc
         wb+CxJKCO971xKY2y9YNTHUz6f+Md/bRoIuGOyfv3rVLTYtrdSC9LtuMxSURQhWtxkPZ
         njD3ZJUMyI4yMTIN+NMt6tFBTojJILjRPio1Y0cnrZtcbyDAJH+fVRHIF0c93nnNYYCC
         9E6I37Keczcj+eDN5feJI01gQ2aILwUKdvPYXlw8MbrmIQANIc9bHI/vJadFISj63vxz
         RjEA==
X-Gm-Message-State: APjAAAVeAXqoPtGbsvW8JMU1HFwxwxbRmZAAH+GigN4bHFTjVYwweZ8W
        iZMJD77GUoqzDmuOaUqYOeYLSY8CQE5tt47Lv8vG9Uc16k4TWst4SyfcU6Op496IHxUH1FtgMKW
        9fiSXfH8RNMZu
X-Received: by 2002:ad4:42d1:: with SMTP id f17mr3295946qvr.30.1578670201761;
        Fri, 10 Jan 2020 07:30:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqwsahFonjsn/5z2F5PRDVZsqweHmMmz01elwFM2HzO6ZKViN40cOIybfOcq66RGqf/heP1lxQ==
X-Received: by 2002:ad4:42d1:: with SMTP id f17mr3295923qvr.30.1578670201389;
        Fri, 10 Jan 2020 07:30:01 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id z3sm1164257qtm.5.2020.01.10.07.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:30:00 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:29:59 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200110152959.GC53397@xz-x1>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <20200109141634-mutt-send-email-mst@kernel.org>
 <20200109201916.GH36997@xz-x1>
 <20200109171154-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200109171154-mutt-send-email-mst@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 05:18:24PM -0500, Michael S. Tsirkin wrote:
> On Thu, Jan 09, 2020 at 03:19:16PM -0500, Peter Xu wrote:
> > > > while for virtio, both sides (hypervisor,
> > > > and the guest driver) are trusted.
> > > 
> > > What gave you the impression guest is trusted in virtio?
> > 
> > Hmm... maybe when I know virtio can bypass vIOMMU as long as it
> > doesn't provide IOMMU_PLATFORM flag? :)
> 
> If guest driver does not provide IOMMU_PLATFORM, and device does,
> then negotiation fails.

I mean it's still possible to specify "!IOMMU_PLATFORM" for the virtio
device even if vIOMMU is enabled in the guest (rather than the
negociation procedures).  Again I think it's fair, just the same
reason as why we tend to even make "iommu=pt" by default for all the
kernel drivers, because we should trust all the drivers as kernel
itself.  The only thing we want to protect using vIOMMU is the
userspace driver because we do have a line between the userspace and
the kernel, and IMHO it's the same thing here for the new kvm
interface.

> 
> > I think it's logical to trust a virtio guest kernel driver, could you
> > guide me on what I've missed?
> 
> 
> guest driver is assumed to be part of guest kernel. It can't
> do anything kernel can't do anyway.

Right, I think all things belongs to the kernel will have the same
level of trust.  However again, userspace should be differently
treated, and that's why I tend to prefer the index solution that we
expose less to userspace to write (read is far safer comparing to
writes from userspace).

> 
> > > 
> > > 
> > > >  Above means we need to do these to
> > > > change to the new design:
> > > > 
> > > >   - Allow the GFN array to be mapped as writable by userspace (so that
> > > >     userspace can publish bit 2),
> > > > 
> > > >   - The userspace must be trusted to follow the design (just imagine
> > > >     what if the userspace overwrites a GFN when it publishes bit 2
> > > >     over a valid dirty gfn entry?  KVM could wrongly unprotect a page
> > > >     for the guest...).
> > > 
> > > You mean protect, right?  So what?
> > 
> > Yes, I mean with that, more things are uncertain from userspace.  It
> > seems easier to me that we restrict the userspace with one index.
> 
> Donnu how to treat vague statements like this.  You need to be specific
> with threat models. Otherwise there's no way to tell whether code is
> secure.
> 
> > > 
> > > > While if we use the indices, we restrict the userspace to only be able
> > > > to write to one index only (which is the reset_index).  That's all it
> > > > can do to mess things up (and it could never as long as we properly
> > > > validate the reset_index when read, which only happens during
> > > > KVM_RESET_DIRTY_RINGS and is very rare).  From that pov, it seems the
> > > > indices solution still has its benefits.
> > > 
> > > So if you mess up index how is this different?
> > 
> > We can't mess up much with that.  We simply check fetch_index (sorry I
> > meant this when I said reset_index, anyway it's the only index that we
> > expose to userspace) to make sure:
> > 
> >   reset_index <= fetch_index <= dirty_index
> > 
> > Otherwise we fail the ioctl.  With that, we're 100% safe.
> 
> safe from what? userspace can mess up guest memory trivially.
> for example skip sending some memory or send junk.

Yes, QEMU can mess the guest up, but it should never mess the host up,
am I right?  Regarding to QEMU as an userspace, KVM should see it as
untrusted as well from host-wise.  However guest security is another
thing, imho.

> 
> > > 
> > > I agree RO page kind of feels safer generally though.
> > > 
> > > I will have to re-read how does the ring works though,
> > > my comments were based on the old assumption of mmaped
> > > page with indices.
> > 
> > Yes, sorry again for a bad cover letter.
> > 
> > It's basically the same as before, just that we only have per-vcpu
> > ring now, and the indices are exposed from kvm_run so we don't need
> > the extra page, but we still expose that via mmap.
> 
> So that's why changelogs are useful.
> Can you please write a changelog for this version so I don't
> need to re-read all of it? Thanks!

Sure, actually I've got a changelog in the cover letter for this
version [1]... it's:

V3 changelog:

- fail userspace writable maps on dirty ring ranges [Jason]
- commit message fixups [Paolo]
- change __x86_set_memory_region to return hva [Paolo]
- cacheline align for indices [Paolo, Jason]
- drop waitqueue, global lock, etc., include kvmgt rework patchset
- take lock for __x86_set_memory_region() (otherwise it triggers a
  lockdep in latest kvm/queue) [Paolo]
- check KVM_DIRTY_LOG_PAGE_OFFSET in kvm_vm_ioctl_enable_dirty_log_ring
- one more patch to drop x86_set_memory_region [Paolo]
- one more patch to remove extra srcu usage in init_rmode_identity_map()
- add some r-bs for Paolo

I didn't have detailed changelog for v2 because it could be a long
list with trivial details which can hide the major things, but I've
got a small write-up in the cover letter trying to mention the major
changes [2].

Again, I'm very sorry for either missing a complete changelog in v2,
or the high-level overview of v3 in the cover letter.  I'll make it
better in v4.

Thanks,

[1] https://lore.kernel.org/kvm/20200109145729.32898-1-peterx@redhat.com/
[2] https://lore.kernel.org/kvm/20191220211634.51231-1-peterx@redhat.com/

-- 
Peter Xu

