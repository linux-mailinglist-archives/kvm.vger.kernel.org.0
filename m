Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680EC48972D
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 12:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244563AbiAJLSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 06:18:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36444 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244532AbiAJLSi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 06:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641813517;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=6yvXSdG8moFPznyivPUcH7Feaqgjzliy5iEUbJ6Pdlg=;
        b=Kj47SQgkStgK4Lpuk8gp9MkjbmxRavDFtmit9y6BOMLMhGme8yKwiunmD1Qt74ioWlE6tk
        RQYKLKe+nYLHYFfQrXs6QNW6Op+CjTSk8Xx8pg90Ya1MTqVoK6zbhNvCAZrcXPFcY0EQgf
        LnQImXLUr8xQ5NjJzL9Rwjp4UmZyQvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-sCzK_TxPOG-U7XYpuTAtrQ-1; Mon, 10 Jan 2022 06:18:32 -0500
X-MC-Unique: sCzK_TxPOG-U7XYpuTAtrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54E3D1853024;
        Mon, 10 Jan 2022 11:18:31 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 498781ABE5;
        Mon, 10 Jan 2022 11:18:13 +0000 (UTC)
Date:   Mon, 10 Jan 2022 11:18:10 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com, cohuck@redhat.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, seanjc@google.com,
        alistair@alistair23.me, qemu-devel@nongnu.org, mtosatti@redhat.com,
        erdemaktas@google.com, pbonzini@redhat.com
Subject: Re: [RFC PATCH v2 06/44] hw/i386: Introduce kvm-type for TDX guest
Message-ID: <YdwV8jUm+RuirhxK@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
 <20210826102212.gykq2z4fb2iszb2k@sirius.home.kraxel.org>
 <03aaab8b-0a50-6b56-2891-ccd58235ad83@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <03aaab8b-0a50-6b56-2891-ccd58235ad83@intel.com>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021 at 03:31:13PM +0800, Xiaoyao Li wrote:
> On 8/26/2021 6:22 PM, Gerd Hoffmann wrote:
> > On Wed, Jul 07, 2021 at 05:54:36PM -0700, isaku.yamahata@gmail.com wrote:
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > 
> > > Introduce a machine property, kvm-type, to allow the user to create a
> > > Trusted Domain eXtensions (TDX) VM, a.k.a. a Trusted Domain (TD), e.g.:
> > > 
> > >   # $QEMU \
> > > 	-machine ...,kvm-type=tdx \
> > > 	...
> 
> Sorry for the very late reply.
> 
> > Can we align sev and tdx better than that?
> > 
> > SEV is enabled this way:
> > 
> > qemu -machine ...,confidential-guest-support=sev0 \
> >       -object sev-guest,id=sev0,...
> > 
> > (see docs/amd-memory-encryption.txt for details).
> > 
> > tdx could likewise use a tdx-guest object (and both sev-guest and
> > tdx-guest should probably have a common parent object type) to enable
> > and configure tdx support.
> 
> yes, sev only introduced a new object and passed it to
> confidential-guest-support. This is because SEV doesn't require the new type
> of VM.
> However, TDX does require a new type of VM.
> 
> If we read KVM code, there is a parameter of CREATE_VM to pass the vm_type,
> though x86 doesn't use this field so far. On QEMU side, it also has the
> codes to pass/configure vm-type in command line. Of cousre, x86 arch doesn't
> implement it. With upcoming TDX, it will implement and use vm type for TDX.
> That's the reason we wrote this patch to implement kvm-type for x86, similar
> to other arches.
> 
> yes, of course we can infer the vm_type from "-object tdx-guest". But I
> prefer to just use vm_type. Let's see others opinion.

It isn't just SEV that is using the confidential-guest-support approach.
This was done for PPC64 and S390x too.  This gives QEMU a standard
internal interface to declare that a confidential guest is being used /
configured. IMHO, TDX needs to use this too, unless there's a compelling
technical reason why it is a bad approach & needs to diverge from every
other confidential guest impl in QEMU.

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

