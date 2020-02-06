Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC411540EB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgBFJLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:11:46 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728226AbgBFJLp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 04:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580980304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU3WK4P1kPyNxLlvfVhA2b0v6z5klZVP2WgKEW+13sI=;
        b=LI49qZyET5ylB45g5/FgD/x/CyE0JQe7FTVw3zyOop6cpLKXxp3ipcUr+W1L+jF6rX6voh
        9tA1Hp4mop7pKCsmcoQJIMmLx73gQsl8YzqhCQgrGKy85Ei0FwkHjygsaMoAdtDQCXZZ/a
        LUSk9u8J4Br0U5siC+AuZAyCs+vO38c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76--tGtER9MPi6wjBDiYPYD2A-1; Thu, 06 Feb 2020 04:11:40 -0500
X-MC-Unique: -tGtER9MPi6wjBDiYPYD2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 509E118A5502;
        Thu,  6 Feb 2020 09:11:39 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0FAC11A7E3;
        Thu,  6 Feb 2020 09:11:34 +0000 (UTC)
Date:   Thu, 6 Feb 2020 10:11:32 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 18/37] KVM: s390: protvirt: Implement machine-check
 interruption injection
Message-ID: <20200206101132.443b6812.cohuck@redhat.com>
In-Reply-To: <a008c638-780a-a383-0cd9-9954ef2468ab@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-19-borntraeger@de.ibm.com>
        <20200205144704.58b2c327.cohuck@redhat.com>
        <55e7548b-520b-d271-6867-fb887697235e@de.ibm.com>
        <20200206092546.14a812ce.cohuck@redhat.com>
        <a008c638-780a-a383-0cd9-9954ef2468ab@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Feb 2020 10:01:02 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 06.02.20 09:25, Cornelia Huck wrote:
> > On Wed, 5 Feb 2020 19:18:44 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 05.02.20 14:47, Cornelia Huck wrote:
> >> [..]  
> >>>> --- a/arch/s390/kvm/interrupt.c
> >>>> +++ b/arch/s390/kvm/interrupt.c
> >>>> @@ -571,6 +571,14 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
> >>>>  	union mci mci;
> >>>>  	int rc;
> >>>>  
> >>>> +	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> >>>> +		vcpu->arch.sie_block->iictl = IICTL_CODE_MCHK;
> >>>> +		vcpu->arch.sie_block->mcic = mchk->mcic;
> >>>> +		vcpu->arch.sie_block->faddr = mchk->failing_storage_address;
> >>>> +		vcpu->arch.sie_block->edc = mchk->ext_damage_code;    
> >>>
> >>> Maybe add a comment that we don't need with other machine-check related data?    
> >>
> >> Not sure I get this point. Can you make a proposal?  
> > 
> > /*
> >  * All other possible payload for a machine check will
> >  * not be handled by the hypervisor, as it does not have
> >  * the needed information for protected guests.
> >  */
> > 
> > Something like that?  
> 
> Ah, you mean the registers and so on for the checkout?
> I will add 
>         /*
>          * All other possible payload for a machine check (e.g. the register
>          * contents in the save area) will be handled by the ultravisor, as 
>          * the hypervisor does not not have the needed information for
>          * protected guests.
>          */
> 

Sounds good!

