Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640FF1704E6
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 17:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgBZQyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 11:54:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46260 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726214AbgBZQyn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 11:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLEBy3N/nFHO4csKCSJ96YktbetH2yn5sA9QJ3LgZ9Y=;
        b=c9UCtD8wUGkR9N/bLTHMPbTs2lVQkZLPKigS0ZjBhFjUkz6FxJnPEZPPzgyp5z0qRTJBhU
        KBVv2PyNvZ94q3PuU4oOBBG5Uhf2aHfcBtHKJfPPJvKxuF5JgK/Fj/wJtFteTIbYq/bOaa
        ay+7lH3xQD66s+Xv6TMFCGCMbHJH+G0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-iRsgvlU1Pm29plBincJ5RQ-1; Wed, 26 Feb 2020 11:54:37 -0500
X-MC-Unique: iRsgvlU1Pm29plBincJ5RQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D227C800D53;
        Wed, 26 Feb 2020 16:54:35 +0000 (UTC)
Received: from gondolin (ovpn-117-69.ams2.redhat.com [10.36.117.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 031205DA76;
        Wed, 26 Feb 2020 16:54:30 +0000 (UTC)
Date:   Wed, 26 Feb 2020 17:54:28 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     david@redhat.com, Ulrich.Weigand@de.ibm.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v4.5 09/36] KVM: s390: protvirt: Add initial vm and cpu
 lifecycle handling
Message-ID: <20200226175428.40143164.cohuck@redhat.com>
In-Reply-To: <dcd80ccd-2d66-502f-62a1-3c794cfcde65@de.ibm.com>
References: <f80a0b58-5ed2-33b7-5292-2c4899d765b7@redhat.com>
        <20200225214822.3611-1-borntraeger@de.ibm.com>
        <20200226132640.36c32fd3.cohuck@redhat.com>
        <dcd80ccd-2d66-502f-62a1-3c794cfcde65@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Feb 2020 14:31:36 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 26.02.20 13:26, Cornelia Huck wrote:
> > On Tue, 25 Feb 2020 16:48:22 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> This contains 3 main changes:
> >> 1. changes in SIE control block handling for secure guests
> >> 2. helper functions for create/destroy/unpack secure guests
> >> 3. KVM_S390_PV_COMMAND ioctl to allow userspace dealing with secure
> >> machines
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h |  24 ++-
> >>  arch/s390/include/asm/uv.h       |  69 ++++++++
> >>  arch/s390/kvm/Makefile           |   2 +-
> >>  arch/s390/kvm/kvm-s390.c         | 209 +++++++++++++++++++++++-
> >>  arch/s390/kvm/kvm-s390.h         |  33 ++++
> >>  arch/s390/kvm/pv.c               | 269 +++++++++++++++++++++++++++++++
> >>  include/uapi/linux/kvm.h         |  31 ++++
> >>  7 files changed, 633 insertions(+), 4 deletions(-)
> >>  create mode 100644 arch/s390/kvm/pv.c  

> >> @@ -2262,6 +2419,27 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >>  		mutex_unlock(&kvm->slots_lock);
> >>  		break;
> >>  	}
> >> +	case KVM_S390_PV_COMMAND: {
> >> +		struct kvm_pv_cmd args;
> >> +
> >> +		r = 0;
> >> +		if (!is_prot_virt_host()) {
> >> +			r = -EINVAL;
> >> +			break;
> >> +		}
> >> +		if (copy_from_user(&args, argp, sizeof(args))) {
> >> +			r = -EFAULT;
> >> +			break;
> >> +		}  
> > 
> > The api states that args.flags must be 0... better enforce that?  
> 
> 
> yes
> @@ -2431,6 +2431,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
>                         r = -EFAULT;
>                         break;
>                 }
> +               if (args.flags) {
> +                       r = -EINVAL;
> +                       break;
> +               }
>                 mutex_lock(&kvm->lock);
>                 r = kvm_s390_handle_pv(kvm, &args);
>                 mutex_unlock(&kvm->lock);

Looks good.

