Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4501EF5D4
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 12:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgFEKzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 06:55:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50930 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726733AbgFEKzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 06:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591354517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1jqzEFAmP+wiSC+oGpCImeB7+gOsv977I/lhj0oFVSo=;
        b=OaXw1nffwi9Z+ciauZc0MExnUbNoROa0YILwtt8qvNqHgljrAbozQRkFBdp/8nF6NTMbmZ
        BlVQurro7Dz1lJTUMBtpBZJbhHEXXqXYTq08rzCZk9A2liUYcn3mr2mCSi/GRMmb2Ng66N
        OCY1AFN7ZRwZPW+EU1paghSLdvvf9Qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-2KNrhLL4P7G99GlRwg7b4w-1; Fri, 05 Jun 2020 06:55:15 -0400
X-MC-Unique: 2KNrhLL4P7G99GlRwg7b4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A366B1005512;
        Fri,  5 Jun 2020 10:55:13 +0000 (UTC)
Received: from gondolin (ovpn-113-2.ams2.redhat.com [10.36.113.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20C01579A3;
        Fri,  5 Jun 2020 10:55:07 +0000 (UTC)
Date:   Fri, 5 Jun 2020 12:55:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory
 protection
Message-ID: <20200605125505.3fdd7de8.cohuck@redhat.com>
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 May 2020 13:42:46 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> A number of hardware platforms are implementing mechanisms whereby the
> hypervisor does not have unfettered access to guest memory, in order
> to mitigate the security impact of a compromised hypervisor.
> 
> AMD's SEV implements this with in-cpu memory encryption, and Intel has
> its own memory encryption mechanism.  POWER has an upcoming mechanism
> to accomplish this in a different way, using a new memory protection
> level plus a small trusted ultravisor.  s390 also has a protected
> execution environment.
> 
> The current code (committed or draft) for these features has each
> platform's version configured entirely differently.  That doesn't seem
> ideal for users, or particularly for management layers.
> 
> AMD SEV introduces a notionally generic machine option
> "machine-encryption", but it doesn't actually cover any cases other
> than SEV.
> 
> This series is a proposal to at least partially unify configuration
> for these mechanisms, by renaming and generalizing AMD's
> "memory-encryption" property.  It is replaced by a
> "guest-memory-protection" property pointing to a platform specific
> object which configures and manages the specific details.
> 
> For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> can be extended to cover the Intel and s390 mechanisms as well,
> though.

For s390, there's the 'unpack' cpu facility bit, which is indicated iff
the kernel indicates availability of the feature (depending on hardware
support). If that cpu facility is available, a guest can choose to
transition into protected mode. The current state (protected mode or
not) is tracked in the s390 ccw machine.

If I understand the series here correctly (I only did a quick
read-through), the user has to instruct QEMU to make protection
available, via a new machine property that links to an object?

> 
> Note: I'm using the term "guest memory protection" throughout to refer
> to mechanisms like this.  I don't particular like the term, it's both
> long and not really precise.  If someone can think of a succinct way
> of saying "a means of protecting guest memory from a possibly
> compromised hypervisor", I'd be grateful for the suggestion.
> 
> Changes since v1:
>  * Rebased
>  * Fixed some errors pointed out by Dave Gilbert
> 
> David Gibson (18):
>   target/i386: sev: Remove unused QSevGuestInfoClass
>   target/i386: sev: Move local structure definitions into .c file
>   target/i386: sev: Rename QSevGuestInfo
>   target/i386: sev: Embed SEVState in SevGuestState
>   target/i386: sev: Partial cleanup to sev_state global
>   target/i386: sev: Remove redundant cbitpos and reduced_phys_bits
>     fields
>   target/i386: sev: Remove redundant policy field
>   target/i386: sev: Remove redundant handle field
>   target/i386: sev: Unify SEVState and SevGuestState
>   guest memory protection: Add guest memory protection interface
>   guest memory protection: Handle memory encrption via interface
>   guest memory protection: Perform KVM init via interface
>   guest memory protection: Move side effect out of
>     machine_set_memory_encryption()
>   guest memory protection: Rework the "memory-encryption" property
>   guest memory protection: Decouple kvm_memcrypt_*() helpers from KVM
>   guest memory protection: Add Error ** to
>     GuestMemoryProtection::kvm_init
>   spapr: Added PEF based guest memory protection
>   guest memory protection: Alter virtio default properties for protected
>     guests
> 
>  accel/kvm/kvm-all.c                    |  40 +--
>  accel/kvm/sev-stub.c                   |   5 -
>  accel/stubs/kvm-stub.c                 |  10 -
>  backends/Makefile.objs                 |   2 +
>  backends/guest-memory-protection.c     |  29 ++
>  hw/core/machine.c                      |  61 ++++-
>  hw/i386/pc_sysfw.c                     |   6 +-
>  include/exec/guest-memory-protection.h |  77 ++++++
>  include/hw/boards.h                    |   4 +-
>  include/sysemu/kvm.h                   |  17 --
>  include/sysemu/sev.h                   |   6 +-
>  target/i386/sev.c                      | 351 +++++++++++++------------
>  target/i386/sev_i386.h                 |  49 ----
>  target/ppc/Makefile.objs               |   2 +-
>  target/ppc/pef.c                       |  81 ++++++
>  15 files changed, 441 insertions(+), 299 deletions(-)
>  create mode 100644 backends/guest-memory-protection.c
>  create mode 100644 include/exec/guest-memory-protection.h
>  create mode 100644 target/ppc/pef.c
> 

