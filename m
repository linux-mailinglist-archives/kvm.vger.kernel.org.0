Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E221F154015
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 09:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFIZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 03:25:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33507 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726673AbgBFIZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 03:25:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580977556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDyDa5Dzr4xy8blteeZ0yJhb15nJxcktYC094Uibheg=;
        b=CQGWCz3CawAS2d1Z+AmrooWRT6OB7F29Wqsdd8m6V10Ystcu3aaRmp0+bJRhz8M/6OES6e
        8/TdGELy8TQBeAxWopXB6YSEM9ixure5Vg0zNF11IUQUMah3f4guraObaI3LfLUyHlxBMD
        VHoU01qc6PHUIyaITuAhHemArculxck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-y_zx8CnYOR6BDhdfY45C2A-1; Thu, 06 Feb 2020 03:25:54 -0500
X-MC-Unique: y_zx8CnYOR6BDhdfY45C2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E51B4801FA9;
        Thu,  6 Feb 2020 08:25:52 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E882C8DC1F;
        Thu,  6 Feb 2020 08:25:48 +0000 (UTC)
Date:   Thu, 6 Feb 2020 09:25:46 +0100
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
Message-ID: <20200206092546.14a812ce.cohuck@redhat.com>
In-Reply-To: <55e7548b-520b-d271-6867-fb887697235e@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-19-borntraeger@de.ibm.com>
        <20200205144704.58b2c327.cohuck@redhat.com>
        <55e7548b-520b-d271-6867-fb887697235e@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 19:18:44 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.02.20 14:47, Cornelia Huck wrote:
> [..]
> >> --- a/arch/s390/kvm/interrupt.c
> >> +++ b/arch/s390/kvm/interrupt.c
> >> @@ -571,6 +571,14 @@ static int __write_machine_check(struct kvm_vcpu *vcpu,
> >>  	union mci mci;
> >>  	int rc;
> >>  
> >> +	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
> >> +		vcpu->arch.sie_block->iictl = IICTL_CODE_MCHK;
> >> +		vcpu->arch.sie_block->mcic = mchk->mcic;
> >> +		vcpu->arch.sie_block->faddr = mchk->failing_storage_address;
> >> +		vcpu->arch.sie_block->edc = mchk->ext_damage_code;  
> > 
> > Maybe add a comment that we don't need with other machine-check related data?  
> 
> Not sure I get this point. Can you make a proposal?

/*
 * All other possible payload for a machine check will
 * not be handled by the hypervisor, as it does not have
 * the needed information for protected guests.
 */

Something like that?

> 
> >   
> >> +		return 0;
> >> +	}
> >> +
> >>  	mci.val = mchk->mcic;
> >>  	/* take care of lazy register loading */
> >>  	save_fpu_regs();  
> > 
> > Anyway,
> > Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> >   
> 

