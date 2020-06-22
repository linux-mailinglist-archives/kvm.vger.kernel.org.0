Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8516D203A3D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 17:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgFVPDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 11:03:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25795 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729329AbgFVPDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 11:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592838199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bb1w5QU1Hy5NCmoDKxTZik9/pBKK5Oqka+g+77E+2gg=;
        b=Zk/Jau0jmU8NIJcZqFd4oW/it5+9tKyOvrhWToG+WeUHbtyYqXryaItDmT6xZyJqqRyxLC
        ORTws7HikH78DKI4Q65scaeitP/8eM5AQ6Lq1Hq8zRgvfSNRriiLupq51MqZ5n+RoG9yFe
        Wp0BhV+WN4x25MZ2+q4QVj+2HQdjGPA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-viG_YR1iNsSyMyaQ6hsrrQ-1; Mon, 22 Jun 2020 11:03:12 -0400
X-MC-Unique: viG_YR1iNsSyMyaQ6hsrrQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 555E9A0C02;
        Mon, 22 Jun 2020 15:03:11 +0000 (UTC)
Received: from gondolin (ovpn-113-56.ams2.redhat.com [10.36.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75B1F5D9E2;
        Mon, 22 Jun 2020 15:03:06 +0000 (UTC)
Date:   Mon, 22 Jun 2020 17:03:03 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Collin Walling <walling@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, pbonzini@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v8 2/2] s390/kvm: diagnose 0x318 sync and reset
Message-ID: <20200622170303.5eee22db.cohuck@redhat.com>
In-Reply-To: <43967a50-a69c-face-805d-7cc935d3f230@de.ibm.com>
References: <20200618222222.23175-1-walling@linux.ibm.com>
        <20200618222222.23175-3-walling@linux.ibm.com>
        <20200622122456.781492a8.cohuck@redhat.com>
        <43967a50-a69c-face-805d-7cc935d3f230@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Jun 2020 16:50:41 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 22.06.20 12:24, Cornelia Huck wrote:
> > On Thu, 18 Jun 2020 18:22:22 -0400
> > Collin Walling <walling@linux.ibm.com> wrote:
> >   
> >> DIAGNOSE 0x318 (diag318) sets information regarding the environment
> >> the VM is running in (Linux, z/VM, etc) and is observed via
> >> firmware/service events.
> >>
> >> This is a privileged s390x instruction that must be intercepted by
> >> SIE. Userspace handles the instruction as well as migration. Data
> >> is communicated via VCPU register synchronization.
> >>
> >> The Control Program Name Code (CPNC) is stored in the SIE block. The
> >> CPNC along with the Control Program Version Code (CPVC) are stored
> >> in the kvm_vcpu_arch struct.
> >>
> >> The CPNC is shadowed/unshadowed in VSIE.
> >>
> >> This data is reset on load normal and clear resets.
> >>
> >> Signed-off-by: Collin Walling <walling@linux.ibm.com>
> >> ---
> >>  arch/s390/include/asm/kvm_host.h |  4 +++-
> >>  arch/s390/include/uapi/asm/kvm.h |  5 ++++-
> >>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
> >>  arch/s390/kvm/vsie.c             |  3 +++
> >>  include/uapi/linux/kvm.h         |  1 +
> >>  5 files changed, 21 insertions(+), 3 deletions(-)
> >>  
> > 
> > (...)
> >   
> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index 4fdf30316582..35cdb4307904 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -1031,6 +1031,7 @@ struct kvm_ppc_resize_hpt {
> >>  #define KVM_CAP_PPC_SECURE_GUEST 181
> >>  #define KVM_CAP_HALT_POLL 182
> >>  #define KVM_CAP_ASYNC_PF_INT 183
> >> +#define KVM_CAP_S390_DIAG318 184  
> > 
> > Do we strictly need this new cap, or would checking against the sync
> > regs capabilities be enough?  
> 
> We could check the sync_regs valid field to decide about the sync. We do
> that for ETOKEN as well and QEMU also uses it in handle_diag_318.
> 
> I think what this is used for is actually to tell the QEMU CPU model
> if this is there. And for that the sync_reg validity seems wrong. So better
> keep the CAP?
> 

Ok, makes sense.

