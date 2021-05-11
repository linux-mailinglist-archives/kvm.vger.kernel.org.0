Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF437A6C6
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhEKMfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231521AbhEKMff (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CdLrGHhIPM4nsembm8QauLGNO+t0YsVKKFuZaXvjFQ8=;
        b=iTQOhvvEZSmBuSngB0r0tLJ/5ohanitkzlz1HBIGT9bxSOpvoOt5/ZFy4WZZRvWXaklsAP
        w1+RAQ1i45aWePt70zqvCp73yHk5udg4g4fx8go+appoTsDnv3kkS2NpdaFixfTJb30mDu
        LApnbXLyoSiR/LurDnkdfF9UnNyiOlM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-iPJ1v-aHO5eTsw_g5NpbAA-1; Tue, 11 May 2021 08:34:25 -0400
X-MC-Unique: iPJ1v-aHO5eTsw_g5NpbAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6321CC622;
        Tue, 11 May 2021 12:34:23 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 083B919809;
        Tue, 11 May 2021 12:34:20 +0000 (UTC)
Message-ID: <9cf65a1d7b96c69077779d7a11777004d0bce6c9.camel@redhat.com>
Subject: Re: [PATCH 08/15] KVM: VMX: Configure list of user return MSRs at
 module init
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Tue, 11 May 2021 15:34:19 +0300
In-Reply-To: <YJlNsvKoFIKI2V/V@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-9-seanjc@google.com>
         <db161b4dd7286870db5adb9324e4941f0dc3f098.camel@redhat.com>
         <YJlNsvKoFIKI2V/V@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-10 at 15:13 +0000, Sean Christopherson wrote:
> On Mon, May 10, 2021, Maxim Levitsky wrote:
> > On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> > > @@ -6929,18 +6942,10 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
> > >  			goto free_vpid;
> > >  	}
> > >  
> > > -	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
> > > +	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> > > +		vmx->guest_uret_msrs[i].data = 0;
> > >  
> > > -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> > > -		u32 index = vmx_uret_msrs_list[i];
> > > -		int j = vmx->nr_uret_msrs;
> > > -
> > > -		if (kvm_probe_user_return_msr(index))
> > > -			continue;
> > > -
> > > -		vmx->guest_uret_msrs[j].slot = i;
> > I don't see anything initalizing the .slot after this patch.
> > Now this code is removed later which masks this bug, 
> > but for the bisect sake, I think that this patch 
> > should still be fixed.
> 
> Egad, indeed it's broken.  I'll retest the whole series to verify the other
> patches will bisect cleanly.
> 
> Nice catch!
> 
Thanks!

Best regards,
	Maxim Levitsky

