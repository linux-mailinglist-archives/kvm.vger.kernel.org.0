Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4732CEB6D
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 10:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbgLDJvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 04:51:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387711AbgLDJvv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 04:51:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607075424;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=ft/KvADNPiSTXMbQ4XO9Hd43L+YE8RFLJA/kVVbksb0=;
        b=PtTcTAcCZDc9LbDza/iynYGR+V2bcfaMoiOGSLD//M74ZYUPgqgTr+HM/2q36fm7QtVtAZ
        //KL5eqxhM5Crp+L8YvnDkACi4Y/kCT+BXz6OHQ5Bsb0+mdHnmD2KFx3cL5ZzoTnBsFc6M
        kXLFx91MvW68S/lxdpmwe76TW5VzNRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-xYF4ljvZNainVXmhOc2mBA-1; Fri, 04 Dec 2020 04:50:22 -0500
X-MC-Unique: xYF4ljvZNainVXmhOc2mBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11B5310054FF;
        Fri,  4 Dec 2020 09:50:20 +0000 (UTC)
Received: from redhat.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EE5DA620D7;
        Fri,  4 Dec 2020 09:50:07 +0000 (UTC)
Date:   Fri, 4 Dec 2020 09:50:05 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 00/13] Generalize memory encryption models
Message-ID: <20201204095005.GB3056135@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.6 (2020-07-11)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 04, 2020 at 04:44:02PM +1100, David Gibson wrote:
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
> "securable-guest-memory" property pointing to a platform specific
> object which configures and manages the specific details.

There's no docs updated or added in this series.

docs/amd-memory-encryption.txt needs an update at least, and
there ought to be a doc added describing how this series is
to be used for s390/ppc 


>  accel/kvm/kvm-all.c                   |  39 +------
>  accel/kvm/sev-stub.c                  |  10 +-
>  accel/stubs/kvm-stub.c                |  10 --
>  backends/meson.build                  |   1 +
>  backends/securable-guest-memory.c     |  30 +++++
>  hw/core/machine.c                     |  71 ++++++++++--
>  hw/i386/pc_sysfw.c                    |   6 +-
>  hw/ppc/meson.build                    |   1 +
>  hw/ppc/pef.c                          | 124 +++++++++++++++++++++
>  hw/ppc/spapr.c                        |  10 ++
>  hw/s390x/pv.c                         |  58 ++++++++++
>  include/exec/securable-guest-memory.h |  86 +++++++++++++++
>  include/hw/boards.h                   |   2 +-
>  include/hw/ppc/pef.h                  |  26 +++++
>  include/hw/s390x/pv.h                 |   1 +
>  include/qemu/typedefs.h               |   1 +
>  include/qom/object.h                  |   3 +-
>  include/sysemu/kvm.h                  |  17 ---
>  include/sysemu/sev.h                  |   5 +-
>  qom/object.c                          |   4 +-
>  softmmu/vl.c                          |  16 ++-
>  target/i386/kvm.c                     |  12 ++
>  target/i386/monitor.c                 |   1 -
>  target/i386/sev.c                     | 153 ++++++++++++--------------
>  target/ppc/kvm.c                      |  18 ---
>  target/ppc/kvm_ppc.h                  |   6 -
>  target/s390x/kvm.c                    |   3 +
>  27 files changed, 510 insertions(+), 204 deletions(-)
>  create mode 100644 backends/securable-guest-memory.c
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/exec/securable-guest-memory.h
>  create mode 100644 include/hw/ppc/pef.h

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

