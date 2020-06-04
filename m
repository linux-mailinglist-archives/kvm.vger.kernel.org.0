Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C2E1EEC7A
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgFDUyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 16:54:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50413 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729582AbgFDUyO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 16:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591304052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tnCgk4zuHWYJDP3RnNCax34/Masi6pk4ifg41i/aYfQ=;
        b=UYy0IXJOcfyfH4D0kxq59XAKJCaFLNrho/nPoZVBqvj9BL39d0JtFCxbMGjLnQhY0VwQRF
        OG4+KRYH8V58NCx2BPw+obRbySTi3ndCLBwLZwIND26VE9B4hPaZkYUzaY2SB1eRHfSwYb
        3yAVJqCL3aBCv1HWHTeA5uNBq87F3FU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-ByKIoHGaMMaRSFkDcDjLDA-1; Thu, 04 Jun 2020 16:54:09 -0400
X-MC-Unique: ByKIoHGaMMaRSFkDcDjLDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFAAB464;
        Thu,  4 Jun 2020 20:54:07 +0000 (UTC)
Received: from localhost (ovpn-113-102.phx2.redhat.com [10.3.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F02A600FC;
        Thu,  4 Jun 2020 20:54:01 +0000 (UTC)
Date:   Thu, 4 Jun 2020 16:54:00 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Babu Moger <babu.moger@amd.com>
Cc:     "mst@redhat.com" <mst@redhat.com>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kash@tripleback.net" <kash@tripleback.net>,
        "geoff@hostfission.com" <geoff@hostfission.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
Message-ID: <20200604205400.GE2366737@habkost.net>
References: <1528498581-131037-1-git-send-email-babu.moger@amd.com>
 <1528498581-131037-2-git-send-email-babu.moger@amd.com>
 <20200602175212.GH577771@habkost.net>
 <b6e22360-5fa0-9ade-624d-9de1f76b360b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6e22360-5fa0-9ade-624d-9de1f76b360b@amd.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 04, 2020 at 09:06:27AM -0500, Babu Moger wrote:
> 
> 
> > -----Original Message-----
> > From: Eduardo Habkost <ehabkost@redhat.com>
> > Sent: Tuesday, June 2, 2020 12:52 PM
> > To: Moger, Babu <Babu.Moger@amd.com>
> > Cc: mst@redhat.com; marcel.apfelbaum@gmail.com; pbonzini@redhat.com;
> > rth@twiddle.net; mtosatti@redhat.com; qemu-devel@nongnu.org;
> > kvm@vger.kernel.org; kash@tripleback.net; geoff@hostfission.com; Dr. David
> > Alan Gilbert <dgilbert@redhat.com>
> > Subject: Re: [PATCH v13 1/5] i386: Add support for CPUID_8000_001E for AMD
> > 
> > On Fri, Jun 08, 2018 at 06:56:17PM -0400, Babu Moger wrote:
> > > Add support for cpuid leaf CPUID_8000_001E. Build the config that closely
> > > match the underlying hardware. Please refer to the Processor Programming
> > > Reference (PPR) for AMD Family 17h Model for more details.
> > >
> > > Signed-off-by: Babu Moger <babu.moger@amd.com>
> > [...]
> > > +    case 0x8000001E:
> > > +        assert(cpu->core_id <= 255);
> > 
> > It is possible to trigger this assert using:
> > 
> > $ qemu-system-x86_64 -machine q35,accel=kvm,kernel-irqchip=split -device
> > intel-iommu,intremap=on,eim=on -smp
> > 1,maxcpus=258,cores=258,threads=1,sockets=1 -cpu
> > qemu64,xlevel=0x8000001e -device qemu64-x86_64-cpu,apic-id=257
> > qemu-system-x86_64: warning: Number of hotpluggable cpus requested (258)
> > exceeds the recommended cpus supported by KVM (240)
> > qemu-system-x86_64:
> > /home/ehabkost/rh/proj/virt/qemu/target/i386/cpu.c:5888: cpu_x86_cpuid:
> > Assertion `cpu->core_id <= 255' failed.
> > Aborted (core dumped)
> > 
> > See bug report and discussion at
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.
> > redhat.com%2Fshow_bug.cgi%3Fid%3D1834200&amp;data=02%7C01%7Cbabu.
> > moger%40amd.com%7C8a2724729b914bc9b53d08d8071db392%7C3dd8961fe4
> > 884e608e11a82d994e183d%7C0%7C0%7C637267171438806408&amp;sdata=ib
> > iGlF%2FF%2FVtYQLf7fe988kxFsLhj4GrRiTOq4LUuOT8%3D&amp;reserved=0
> > 
> > Also, it looks like encode_topo_cpuid8000001e() assumes core_id
> > has only 3 bits, so the existing assert() is not even sufficient.
> > We need to decide what to do if the user requests nr_cores > 8.
> > 
> > Probably omitting CPUID[0x8000001E] if the VCPU topology is
> > incompatible with encode_topo_cpuid8000001e() (and printing a
> > warning) is the safest thing to do right now.
> 
> Eduardo,  We need to generalize the encode_topo_cpuid8000001e decoding.
> We will have to remove 3 bit limitation there. It will not scale with
> latest configurations. I will take a look that.
> 
> For now, best option I think is to(like you mentioned in bug 1834200),
> declaring nr_cores > 256 as never supported (or deprecated); and throw
> warning.
> 
> What do you think?

I believe we can declare nr_cores > 256 as never supported to
address the assert failure.  Other CPUID functions also look
broken when nr_cores is too large: encode_cache_cpuid4() seems to
assume nr_cores is 128 or less.

But we still need to make nr_cores > 8 safe while
encode_topo_cpuid8000001e() is not generalized yet.

> > 
> > 
> > 
> > > +        encode_topo_cpuid8000001e(cs, cpu,
> > > +                                  eax, ebx, ecx, edx);
> > > +        break;
> > >      case 0xC0000000:
> > >          *eax = env->cpuid_xlevel2;
> > >          *ebx = 0;
> > > --
> > > 1.8.3.1
> > >
> > 
> > --
> > Eduardo
> 

-- 
Eduardo

