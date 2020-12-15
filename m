Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766C62DAC54
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 12:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgLOLrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 06:47:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728802AbgLOLrO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 06:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608032748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ldS1J7wGI5856oRlyFwiQvFcG4BV7UZaA4YAKir6cWo=;
        b=fhjLoBq9DQTXhecOH+BAY6+rObD0sAiI+rgTYcz9R/sEkisNMPjR2BqMxKgidoEQJ1WnMo
        pk9aPI119N38w5MXXL6Ke456QeGtSbsIfDqXDzKzuFannkVVwYGLEBjdri0qO95cLNJQX0
        vEIMcP0/U3yp3WJ63B7jZ4XXoVo6tSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-r2-c6gfyPh-q2Lyxb7nHrw-1; Tue, 15 Dec 2020 06:45:44 -0500
X-MC-Unique: r2-c6gfyPh-q2Lyxb7nHrw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 781A510054FF;
        Tue, 15 Dec 2020 11:45:42 +0000 (UTC)
Received: from gondolin (ovpn-114-220.ams2.redhat.com [10.36.114.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCC9D5D9CA;
        Tue, 15 Dec 2020 11:45:29 +0000 (UTC)
Date:   Tue, 15 Dec 2020 12:45:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: Re: [for-6.0 v5 13/13] s390: Recognize securable-guest-memory
 option
Message-ID: <20201215124526.7c33dc8d.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-14-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-14-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:15 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled bythe "securable-guest-memory" machine

s/bythe/by the/

> option.  s390 is a slightly special case, because we already supported
> PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the securable-guest-memory option is set, s390 will recognize it,
>    verify that the CPU can support PV (failing if not) and set virtio
>    default options necessary for encrypted or protected guests, as on
>    other platforms.  i.e. if securable-guest-memory is set, we will
>    either create a guest capable of entering PV mode, or fail outright

s/outright/outright./

> 
>  - If securable-guest-memory is not set, guest's might still be able to

s/guest's/guests/

>    enter PV mode, if the CPU has the right model.  This may be a
>    little surprising, but shouldn't actually be harmful.
> 
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=pv0 -machine securable-guest-memory=pv0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/s390x/pv.c         | 58 +++++++++++++++++++++++++++++++++++++++++++
>  include/hw/s390x/pv.h |  1 +
>  target/s390x/kvm.c    |  3 +++
>  3 files changed, 62 insertions(+)
> 

Modulo any naming changes etc., I think this should work for s390. I
don't have the hardware to test this, however, and would appreciate
someone with a PV setup giving this a go.

