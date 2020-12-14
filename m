Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D522D9D92
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 18:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408508AbgLNRYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 12:24:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39285 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408510AbgLNRY1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 12:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607966580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIQmqdC7+zH2YkfI8yaUxzLNmpQ3Ic1mn8OsF5AYibw=;
        b=FDst1kyWJMiHrKRe8A9cFeB0V8l2jrHWTnQEQmRIEp8CsXa+zJY4nHyw5uOtATcgsQAqgl
        IGiPjDw+huFl9uHZ5gbrDD3LskGGntmsgGtpKtYaeoc7qORD5Nd716dr6hyOZhOJVw9Y2O
        Z6YAX3Y0EUzA4TuXAKNK5bglXqm1+z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-Zn_ZHwp8MJWyj9502nlsyQ-1; Mon, 14 Dec 2020 12:22:58 -0500
X-MC-Unique: Zn_ZHwp8MJWyj9502nlsyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF54B80ED8B;
        Mon, 14 Dec 2020 17:22:56 +0000 (UTC)
Received: from gondolin (ovpn-113-171.ams2.redhat.com [10.36.113.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB62A5D6AB;
        Mon, 14 Dec 2020 17:22:43 +0000 (UTC)
Date:   Mon, 14 Dec 2020 18:22:40 +0100
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
Subject: Re: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Message-ID: <20201214182240.2abd85eb.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-12-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-12-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:13 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> We haven't yet implemented the fairly involved handshaking that will be
> needed to migrate PEF protected guests.  For now, just use a migration
> blocker so we get a meaningful error if someone attempts this (this is the
> same approach used by AMD SEV).
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  hw/ppc/pef.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> index 3ae3059cfe..edc3e744ba 100644
> --- a/hw/ppc/pef.c
> +++ b/hw/ppc/pef.c
> @@ -38,7 +38,11 @@ struct PefGuestState {
>  };
>  
>  #ifdef CONFIG_KVM
> +static Error *pef_mig_blocker;
> +
>  static int kvmppc_svm_init(Error **errp)

This looks weird?

> +
> +int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
>  {
>      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
>          error_setg(errp,
> @@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
>          }
>      }
>  
> +    /* add migration blocker */
> +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
> +    /* NB: This can fail if --only-migratable is used */
> +    migrate_add_blocker(pef_mig_blocker, &error_fatal);

Just so that I understand: is PEF something that is enabled by the host
(and the guest is either secured or doesn't start), or is it using a
model like s390x PV where the guest initiates the transition into
secured mode?

Asking because s390x adds the migration blocker only when the
transition is actually happening (i.e. guests that do not transition
into secure mode remain migratable.) This has the side effect that you
might be able to start a machine with --only-migratable that
transitions into a non-migratable machine via a guest action, if I'm
not mistaken. Without the new object, I don't see a way to block with
--only-migratable; with it, we should be able to do that. Not sure what
the desirable behaviour is here.

> +
>      return 0;
>  }
>  

