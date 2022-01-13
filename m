Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E133648DBCB
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiAMQa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:30:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236686AbiAMQa5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jan 2022 11:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642091455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4H2G/AcFCWNIo4a7X3Hpex/LEo4UsnyCD4gzRSNQTAQ=;
        b=iS7qhr2ZU2Jf7Q/u02AJ/TnxnjtKJPDFFN4B6uGiWsvrdpSdxbtNZAOHgWTbP0uuxFfdo8
        jYMedgFWvEUzQ3uoVJRTvR/D6EYLm+q3qehToo0vjKG/JD/PkzFv/lMaBmWiamFiQglO73
        /jL/3ta2iN/v7MVaW8iSzU1lNpLYlgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-Ax1e_eeJPauRyoBTaav1KA-1; Thu, 13 Jan 2022 11:30:54 -0500
X-MC-Unique: Ax1e_eeJPauRyoBTaav1KA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D54810AF8C2;
        Thu, 13 Jan 2022 16:30:53 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95131858A0;
        Thu, 13 Jan 2022 16:30:50 +0000 (UTC)
Message-ID: <d3cc3cd1a90d7ee9a31e40fbe2db9f3f338d5004.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: Forbid KVM_SET_CPUID{,2} after KVM_RUN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Thu, 13 Jan 2022 18:30:49 +0200
In-Reply-To: <YeBSrcNawgzvTzQ6@google.com>
References: <877dbbq5om.fsf@redhat.com>
         <5505d731-cf87-9662-33f3-08844d92877c@redhat.com>
         <20220111090022.1125ffb5@redhat.com> <87fsptnjic.fsf@redhat.com>
         <50136685-706e-fc6a-0a77-97e584e74f93@redhat.com>
         <87bl0gnfy5.fsf@redhat.com>
         <7e7c7e22f8b1b1695d26d9e19a767b87c679df93.camel@redhat.com>
         <87zgnzn1nr.fsf@redhat.com>
         <6ae7e64c53727f9f00537d787e9612c292c4e244.camel@redhat.com>
         <87wnj3n0k0.fsf@redhat.com> <YeBSrcNawgzvTzQ6@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-13 at 16:26 +0000, Sean Christopherson wrote:
> On Thu, Jan 13, 2022, Vitaly Kuznetsov wrote:
> > Maxim Levitsky <mlevitsk@redhat.com> writes:
> > > For my nested AVIC work I would really want the APIC ID of a VCPU to be read-only
> > > and be equal to vcpu_id.
> > > 
> > 
> > Doesn't APIC ID have topology encoded in it?
> 
> Yeah, APIC IDs are derived from the topology.  From the SDM (this doesn't
> talk about core/SMT info, but that's included as well):
> 
>   The hardware assigned APIC ID is based on system topology and includes encoding
>   for socket position and cluster information.
> 
> The SDM also says:
> 
>   Some processors permit software to modify the APIC ID. However, the ability of
>   software to modify the APIC ID is processor model specific.
> 
> So I _think_ we could define KVM behavior to ignore writes from the _guest_, but
> the APIC_ID == vcpu_id requirement won't fly as userspace expects to be able to
> stuff virtual toplogy info into the APIC ID.
> 
That is a very good piece of information! Thanks!

Best regards,
	Maxim Levitsky

