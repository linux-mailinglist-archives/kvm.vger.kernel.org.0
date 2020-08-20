Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB66424B9D3
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 13:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgHTLza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 07:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730439AbgHTKC0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 06:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MP/JNWR1yLBisgN4+PEfbtEeM9N/uel00En3KvNqgSw=;
        b=SlEJqHR7x2rCcKfDjEdGO8Pe117BID1tIVOvWfnWnwiU7oKJnTUVB3b/rr484n7uvJesrx
        IUo+obcxnndn1VEg6il70M0PnzHla1DyGv2OjaBDv7m19DsL58WOXndEjNHm/kvbvOACnG
        S/9p0koSsNxQTuu8DoBDtQWJuzpbTiw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-urWTE_gTNuekkPMYyCy3Yg-1; Thu, 20 Aug 2020 06:02:21 -0400
X-MC-Unique: urWTE_gTNuekkPMYyCy3Yg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08AD3801ADD;
        Thu, 20 Aug 2020 10:02:20 +0000 (UTC)
Received: from starship (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF03F5D9E8;
        Thu, 20 Aug 2020 10:02:16 +0000 (UTC)
Message-ID: <faedeeb06b63a115a1ab733b1226ae6822d2a907.camel@redhat.com>
Subject: Re: [PATCH 5/8] KVM: nSVM: implement ondemand allocation of the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Date:   Thu, 20 Aug 2020 13:02:15 +0300
In-Reply-To: <476eecc8-a861-203c-40f5-46707d8c0237@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
         <20200820091327.197807-6-mlevitsk@redhat.com>
         <476eecc8-a861-203c-40f5-46707d8c0237@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 11:58 +0200, Paolo Bonzini wrote:
> On 20/08/20 11:13, Maxim Levitsky wrote:
> > @@ -3912,6 +3914,14 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
> >  	vmcb_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
> >  
> >  	if (guest) {
> > +		/*
> > +		 * This can happen if SVM was not enabled prior to #SMI,
> > +		 * but guest corrupted the #SMI state and marked it as
> > +		 * enabled it there
> > +		 */
> > +		if (!svm->nested.initialized)
> > +			return 1;
> > +
> >  		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
> >  			return 1;
> 
> This can also happen if you live migrate while in SMM (EFER.SVME=0).
> You need to check for the SVME bit in the SMM state save area, and:
> 
> 1) triple fault if it is clear
> 
> 2) call svm_allocate_nested if it is set.
> 
> Paolo
> 
Makes sense, will do.

Best regards,
	Maxim Levitsky

