Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBA720AFCA
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 12:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgFZKdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 06:33:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39442 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727883AbgFZKdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 06:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593167610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AYU5K2hAfmX2GUNWr0ua/BF8FmCBUP2+H46nooxPxcM=;
        b=WvfEi5AF6uP0OV6qgDPgJvd5aUx2/zGO+yrIs/1Ce95FJ5O4Q1Wmh1TZdvjb10sSu2qmFb
        nx/qxejZAXln8sy4ZIbUVGU2kNPdpjhjC0fiSwmLipyfM7rRbPX2yL0o6PyAYazbRx9Qwr
        OJxmzr5GX17CQMkKD+omFvvMsOKZaBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-SE2UBXfRPYOl_aP91fMvVg-1; Fri, 26 Jun 2020 06:33:28 -0400
X-MC-Unique: SE2UBXfRPYOl_aP91fMvVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1477C805EE2;
        Fri, 26 Jun 2020 10:33:27 +0000 (UTC)
Received: from work-vm (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D5BE25C1BB;
        Fri, 26 Jun 2020 10:33:05 +0000 (UTC)
Date:   Fri, 26 Jun 2020 11:33:03 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        cohuck@redhat.com, pasic@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        david@redhat.com
Subject: Re: [PATCH v3 8/9] spapr: PEF: block migration
Message-ID: <20200626103303.GE3087@work-vm>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-9-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619020602.118306-9-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.3 (2020-06-14)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Gibson (david@gibson.dropbear.id.au) wrote:
> We haven't yet implemented the fairly involved handshaking that will be
> needed to migrate PEF protected guests.  For now, just use a migration
> blocker so we get a meaningful error if someone attempts this (this is the
> same approach used by AMD SEV).
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Do you expect this to happen if people run with -cpu host ?

Dave

> ---
>  target/ppc/pef.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/target/ppc/pef.c b/target/ppc/pef.c
> index 53a6af0347..6a50efd580 100644
> --- a/target/ppc/pef.c
> +++ b/target/ppc/pef.c
> @@ -36,6 +36,8 @@ struct PefGuestState {
>      Object parent_obj;
>  };
>  
> +static Error *pef_mig_blocker;
> +
>  static int pef_kvm_init(HostTrustLimitation *gmpo, Error **errp)
>  {
>      if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
> @@ -52,6 +54,10 @@ static int pef_kvm_init(HostTrustLimitation *gmpo, Error **errp)
>          }
>      }
>  
> +    /* add migration blocker */
> +    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
> +    migrate_add_blocker(pef_mig_blocker, &error_abort);
> +
>      return 0;
>  }
>  
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

