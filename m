Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D9415414E
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgBFJmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:42:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49394 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727985AbgBFJmP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 04:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580982134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GrdnJCndLBTO81IIwZCfscAmdjAE7F40PRfCOhvJxwo=;
        b=jGK8RGijJSiSE2YmR2AFxmywIkoykPRZTUyFdHOofM5XUEX8vvKVFlwBThaU1MUxa+YGOj
        0VCVNdpCwLVBBoKTwO7zrY17SSgUn+lTMUXf5nYh1Ry95OikgpWnVTWLXtxhrrooNo3XD1
        R7JBSw3fpfx9sTzUN8dJZNz480fO1p0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-V-GVgMVjOQKnl-cTCcrk2A-1; Thu, 06 Feb 2020 04:42:07 -0500
X-MC-Unique: V-GVgMVjOQKnl-cTCcrk2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCBCDB8B;
        Thu,  6 Feb 2020 09:42:05 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4F965DE52;
        Thu,  6 Feb 2020 09:42:01 +0000 (UTC)
Date:   Thu, 6 Feb 2020 10:41:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 34/37] KVM: s390: protvirt: Add UV debug trace
Message-ID: <20200206104159.16130ccb.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-35-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-35-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:54 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> Let's have some debug traces which stay around for longer than the
> guest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 10 +++++++++-
>  arch/s390/kvm/kvm-s390.h |  9 +++++++++
>  arch/s390/kvm/pv.c       | 21 +++++++++++++++++++--
>  3 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 2beb93f0572f..d4dc156e2c3e 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -221,6 +221,7 @@ static struct kvm_s390_vm_cpu_subfunc kvm_s390_available_subfunc;
>  static struct gmap_notifier gmap_notifier;
>  static struct gmap_notifier vsie_gmap_notifier;
>  debug_info_t *kvm_s390_dbf;
> +debug_info_t *kvm_s390_dbf_uv;
>  
>  /* Section: not file related */
>  int kvm_arch_hardware_enable(void)
> @@ -462,7 +463,13 @@ int kvm_arch_init(void *opaque)
>  	if (!kvm_s390_dbf)
>  		return -ENOMEM;
>  
> -	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view))
> +	kvm_s390_dbf_uv = debug_register("kvm-uv", 32, 1, 7 * sizeof(long));
> +	if (!kvm_s390_dbf_uv)
> +		return -ENOMEM;

Doesn't that leak kvm_s390_dbf?

> +
> +

One blank line should be enough.

> +	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view) ||
> +	    debug_register_view(kvm_s390_dbf_uv, &debug_sprintf_view))
>  		goto out;
>  
>  	kvm_s390_cpu_feat_init();
> @@ -489,6 +496,7 @@ void kvm_arch_exit(void)
>  {
>  	kvm_s390_gib_destroy();
>  	debug_unregister(kvm_s390_dbf);
> +	debug_unregister(kvm_s390_dbf_uv);
>  }
>  
>  /* Section: device related */

(...)

> @@ -252,7 +269,7 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>  		addr += PAGE_SIZE;
>  		tw[1] += PAGE_SIZE;
>  	}
> -	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished rc %x", rc);
> +	VM_EVENT(kvm, 3, "PROTVIRT VM UNPACK: finished with rc %x", rc);

Can you merge this into the patch that introduces this log entry?

Also, do you want to add logging into the new dbf here as well?

>  	return rc;
>  }
>  

You often seem to log in pairs (into the per-vm dbf and into the new uv
dbf). Would it make sense to introduce a new helper for that, or is
that overkill?

