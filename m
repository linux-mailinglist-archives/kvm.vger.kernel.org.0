Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399152F80F2
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 17:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730307AbhAOQig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 11:38:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbhAOQig (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 11:38:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610728629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E0t/p6vUdTuxz2CXDj8S/giucsDXUc9V39NGSrWnCzY=;
        b=SFQB7zQu1TTyZb3tp9CsOKTM9GV3zDh6S6q+3cM2xJzgLSKmbb5PQZB5onV/7nDt9F7Vsx
        rqgTh2oUZMJkwhtu2L6zGafp+KGwx7yOPURUGNN9qYyAdqqABIbcryekJ48+eyuWX1Drc3
        PUBCnaqxpgnSW6Gsaua6mt/nhuhpaTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-ukYfi6LcNViM1F8nOD-P5Q-1; Fri, 15 Jan 2021 11:37:06 -0500
X-MC-Unique: ukYfi6LcNViM1F8nOD-P5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B77B2190A7A0;
        Fri, 15 Jan 2021 16:37:03 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0133E6E50A;
        Fri, 15 Jan 2021 16:36:50 +0000 (UTC)
Date:   Fri, 15 Jan 2021 17:36:47 +0100
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
Subject: Re: [PATCH v7 13/13] s390: Recognize confidential-guest-support
 option
Message-ID: <20210115173647.28f4cc9e.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-14-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-14-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:11 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled by the "confidential-guest-support"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the confidential-guest-support option is set, s390 will
>    recognize it, verify that the CPU can support PV (failing if not)
>    and set virtio default options necessary for encrypted or protected
>    guests, as on other platforms.  i.e. if confidential-guest-support
>    is set, we will either create a guest capable of entering PV mode,
>    or fail outright.
> 
>  - If confidential-guest-support is not set, guests might still be
>    able to enter PV mode, if the CPU has the right model.  This may be
>    a little surprising, but shouldn't actually be harmful.
> 
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |  3 ++
>  docs/system/s390x/protvirt.rst      | 19 ++++++---
>  hw/s390x/pv.c                       | 62 +++++++++++++++++++++++++++++
>  include/hw/s390x/pv.h               |  1 +
>  target/s390x/kvm.c                  |  3 ++
>  5 files changed, 82 insertions(+), 6 deletions(-)
> 

(...)

> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
> +{
> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
> +        return 0;
> +    }
> +
> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> +        error_setg(errp,
> +                   "CPU model does not support Protected Virtualization");
> +        return -1;
> +    }
> +
> +    cgs->ready = true;
> +
> +    return 0;
> +}

Do we want to add a migration blocker here? If we keep the one that is
added when the guest transitions, we'll end up with two of them, but
that might be easier than trying to unify it.

