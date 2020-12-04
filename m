Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E02CEEA8
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgLDNLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:11:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgLDNLt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:11:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607087423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HmMQeMwJr/sXBh2GvU9XsEsWuFtoMDgEB5xcDGiFpiA=;
        b=EOcU0MahvhChz9STrHWEKVLj/DaECMvZGcYilHfZ6eguEUDWAkVLkH+0q8KOqR4P04hU8t
        CYuHH7JHHUjuDhLKL/sKaTtmcYBCT95I2G9MO/gO34+ZcGUmXxcNQwgagS+dTfTYAnL/3v
        qR8k0bKGYQQVGZSr8HDsdVaebJV+eQI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-YOPC6lTlPq-EuqvpJug2lg-1; Fri, 04 Dec 2020 08:10:20 -0500
X-MC-Unique: YOPC6lTlPq-EuqvpJug2lg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2230A18C89C4;
        Fri,  4 Dec 2020 13:10:18 +0000 (UTC)
Received: from gondolin (ovpn-113-97.ams2.redhat.com [10.36.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7A315C1D1;
        Fri,  4 Dec 2020 13:10:07 +0000 (UTC)
Date:   Fri, 4 Dec 2020 14:10:05 +0100
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
Subject: Re: [for-6.0 v5 03/13] securable guest memory: Handle memory
 encryption via interface
Message-ID: <20201204141005.07bf61dd.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-4-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-4-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:05 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> At the moment AMD SEV sets a special function pointer, plus an opaque
> handle in KVMState to let things know how to encrypt guest memory.
> 
> Now that we have a QOM interface for handling things related to securable
> guest memory, use a QOM method on that interface, rather than a bare
> function pointer for this.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>  accel/kvm/kvm-all.c                   |  36 +++++---
>  accel/kvm/sev-stub.c                  |   9 +-
>  include/exec/securable-guest-memory.h |   2 +
>  include/sysemu/sev.h                  |   5 +-
>  target/i386/monitor.c                 |   1 -
>  target/i386/sev.c                     | 116 ++++++++++----------------
>  6 files changed, 77 insertions(+), 92 deletions(-)
> 

> @@ -224,7 +224,7 @@ int kvm_get_max_memslots(void)
>  
>  bool kvm_memcrypt_enabled(void)
>  {
> -    if (kvm_state && kvm_state->memcrypt_handle) {
> +    if (kvm_state && kvm_state->sgm) {

If we want to generalize the concept, maybe check for encrypt_data in
sgm here? There's probably room for different callbacks in the sgm
structure.

>          return true;
>      }
>  

