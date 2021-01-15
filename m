Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1372F7C09
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732657AbhAONIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:08:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731955AbhAONIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:08:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RgqdN+rsOdyuFDjY8gpWUfMmwO4sA4LEjA6hTey4zU=;
        b=IbRDtWE7TEukDqB7dCpw4phpisk80fTdN88+jZA/bmxePGw/69AH1S1CZyPu3MUc64+c6a
        J4UB3MxZ2m0u0iA0uNDJaN/vojEOCO9E845TCX0QtSXpNSNxZjm1MJAqIqR7gbC+ga8yyI
        NSL+4jefoXDbyZuJ/FKdcsIVzR/mFD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-MzPZa4NFPPysRj78_viMng-1; Fri, 15 Jan 2021 08:06:47 -0500
X-MC-Unique: MzPZa4NFPPysRj78_viMng-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 458898144E0;
        Fri, 15 Jan 2021 13:06:44 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0ECC1000320;
        Fri, 15 Jan 2021 13:06:31 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:06:29 +0100
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
Subject: Re: [PATCH v7 05/13] confidential guest support: Rework the
 "memory-encryption" property
Message-ID: <20210115140629.46816ea3.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-6-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-6-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:03 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Currently the "memory-encryption" property is only looked at once we
> get to kvm_init().  Although protection of guest memory from the
> hypervisor isn't something that could really ever work with TCG, it's
> not conceptually tied to the KVM accelerator.
> 
> In addition, the way the string property is resolved to an object is
> almost identical to how a QOM link property is handled.
> 
> So, create a new "confidential-guest-support" link property which sets
> this QOM interface link directly in the machine.  For compatibility we
> keep the "memory-encryption" property, but now implemented in terms of
> the new property.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> ---
>  accel/kvm/kvm-all.c  |  5 +++--
>  accel/kvm/sev-stub.c |  5 +++--
>  hw/core/machine.c    | 43 +++++++++++++++++++++++++++++++++++++------
>  include/hw/boards.h  |  2 +-
>  include/sysemu/sev.h |  2 +-
>  target/i386/sev.c    | 32 ++------------------------------
>  6 files changed, 47 insertions(+), 42 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

