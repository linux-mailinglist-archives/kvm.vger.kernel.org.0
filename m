Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F232F7AF2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387822AbhAOM4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:56:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387552AbhAOM4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610715284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3464aNY1pSNVMl9kXj2bqfBR/O9eQZd6QX4BTIBIyk=;
        b=D86eI3LZEFTiLtg/8gLTPuaYfbiFyIOfSNT5OfeeARUAghg1FraN2t+zIUjU35xgcn+g9s
        f4jTHw4kL69H/GrNKb5x+/bVmY7++DpU8StSw5QlS43KPnwWYYerOGEVFDMPvuVSJM56DL
        Vp/rMMokVEuMEVN6zDEKjUHKhu95iGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-vabXa1jcOJCjssgG9Fnheg-1; Fri, 15 Jan 2021 07:54:41 -0500
X-MC-Unique: vabXa1jcOJCjssgG9Fnheg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FCD4DF8A4;
        Fri, 15 Jan 2021 12:54:38 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40EAE60CCE;
        Fri, 15 Jan 2021 12:54:27 +0000 (UTC)
Date:   Fri, 15 Jan 2021 13:54:25 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 03/13] sev: Remove false abstraction of flash
 encryption
Message-ID: <20210115135425.7fd94aed.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-4-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-4-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:01 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> When AMD's SEV memory encryption is in use, flash memory banks (which are
> initialed by pc_system_flash_map()) need to be encrypted with the guest's
> key, so that the guest can read them.
> 
> That's abstracted via the kvm_memcrypt_encrypt_data() callback in the KVM
> state.. except, that it doesn't really abstract much at all.
> 
> For starters, the only called is in code specific to the 'pc' family of

s/called/call site/

> machine types, so it's obviously specific to those and to x86 to begin
> with.  But it makes a bunch of further assumptions that need not be true
> about an arbitrary confidential guest system based on memory encryption,
> let alone one based on other mechanisms:
> 
>  * it assumes that the flash memory is defined to be encrypted with the
>    guest key, rather than being shared with hypervisor
>  * it assumes that that hypervisor has some mechanism to encrypt data into
>    the guest, even though it can't decrypt it out, since that's the whole
>    point
>  * the interface assumes that this encrypt can be done in place, which
>    implies that the hypervisor can write into a confidential guests's
>    memory, even if what it writes isn't meaningful
> 
> So really, this "abstraction" is actually pretty specific to the way SEV
> works.  So, this patch removes it and instead has the PC flash
> initialization code call into a SEV specific callback.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  accel/kvm/kvm-all.c    | 31 ++-----------------------------
>  accel/kvm/sev-stub.c   |  9 ++-------
>  accel/stubs/kvm-stub.c | 10 ----------
>  hw/i386/pc_sysfw.c     | 17 ++++++-----------
>  include/sysemu/kvm.h   | 16 ----------------
>  include/sysemu/sev.h   |  4 ++--
>  target/i386/sev-stub.c |  5 +++++
>  target/i386/sev.c      | 24 ++++++++++++++----------
>  8 files changed, 31 insertions(+), 85 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

