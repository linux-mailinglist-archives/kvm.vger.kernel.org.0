Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB29522F344
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgG0PCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 11:02:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726983AbgG0PCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 11:02:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595862138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bsciqIa8fXOddHPzcAGR7K9op1vJPoheDHoXbCvop18=;
        b=N4SnhlWRxkL0pxKdXw/lmv4SD/q0dgut9FI4OZumkCQa3Sfe9qvBI/scmNkwpDSXgQ3+3N
        dmCPOJPXZ+ZKIgLR6STG2yIYRs2zZNsep2QqVbcLmSz8mwj6o04HDXyXyXHbPzC+blys2U
        dpGXeRWxWOcn4dVdpYmAmfTDPtnxG0I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-rFIiD02OPoaGU8VroFhj_A-1; Mon, 27 Jul 2020 11:02:13 -0400
X-MC-Unique: rFIiD02OPoaGU8VroFhj_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C2308017FB;
        Mon, 27 Jul 2020 15:02:11 +0000 (UTC)
Received: from work-vm (ovpn-114-135.ams2.redhat.com [10.36.114.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89DDF5D9E8;
        Mon, 27 Jul 2020 15:02:00 +0000 (UTC)
Date:   Mon, 27 Jul 2020 16:01:57 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     frankja@linux.ibm.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [for-5.2 v4 08/10] spapr: PEF: block migration
Message-ID: <20200727150157.GP3040@work-vm>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
 <20200724025744.69644-9-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724025744.69644-9-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

You might want that to be &error_fatal rather than error_abort; I think
someone could trigger it just by using --only-migratable together with
your pef device?

(I previously asked whether this would trigger with -cpu host; I hadn't
noticed this was based on the device rather than the CPU flag that said
whether you had the feature)

Dave

>      return 0;
>  }
>  
> -- 
> 2.26.2
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

