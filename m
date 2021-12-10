Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EBA47014E
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbhLJNOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:14:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36825 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236130AbhLJNOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Dec 2021 08:14:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639141845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g28ogTKeSb2RimVMfdJsC1QVLdKzz3DH/S0ei09yZg8=;
        b=RWKTbZTwmQD5uiDNGoXyjY/qw+IYKxAVYmt4RvKo02Dmjkabh3Ksk1RhTrEN5Dp9vnXcFh
        4xy+xAvETCUxuh3zKlKcwDL/F03LexsWiWXjSL3SXZTCxFri8+ftN9X+fdwHGvOi1FupOc
        Ho7er1Bi7IX1mUkAep/dmWxJzgIMkgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-rERBtxmIPOShklY63U4Iog-1; Fri, 10 Dec 2021 08:10:42 -0500
X-MC-Unique: rERBtxmIPOShklY63U4Iog-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9420B802C92;
        Fri, 10 Dec 2021 13:10:39 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB9AD19C59;
        Fri, 10 Dec 2021 13:10:35 +0000 (UTC)
Message-ID: <8cbc67c742db2c4a66baf669a722a544d892ffb7.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: x86: never clear irr_pending in
 kvm_apic_update_apicv
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Dec 2021 15:10:34 +0200
In-Reply-To: <3c30e682-a569-9e91-987d-9e2fc66bb625@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
         <20211209115440.394441-6-mlevitsk@redhat.com>
         <636dd644-8160-645a-ce5a-f4eb344f001c@redhat.com>
         <fbf3e1665357d9517015ad49eee0c9825ed876d4.camel@redhat.com>
         <0a01229bbbb6d133ba164cb5495ad2300eb8d818.camel@redhat.com>
         <3c30e682-a569-9e91-987d-9e2fc66bb625@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-12-10 at 14:03 +0100, Paolo Bonzini wrote:
> On 12/10/21 13:47, Maxim Levitsky wrote:
> > If we scan vIRR here and see no bits, and*then*  disable AVIC,
> > there is a window where the they could legit be turned on without any cpu errata,
> > and we will not have irr_pending == true, and thus the following
> > KVM_REQ_EVENT will make no difference.
> 
> Right.
> 
> > Not touching irr_pending and letting just the KVM_REQ_EVENT do the work
> > will work too,
> 
> Yeah, I think that's preferrable.  irr_pending == true is a conservative 
> setting that works; irr_pending will be evaluated again on the first 
> call to apic_clear_irr and that's enough.
> 
> With that justification, you don't need to reorder the call to 
> kvm_apic_update_apicv to be after kvm_x86_refresh_apicv_exec_ctrl.

Yes exactly! but no need to scan IRR here since irr_pending is already
true at that point anyway - it is always true while avic is enabled.


Best regards,
	Maxim Levitsky
> 
> Paolo
> 
>   and if the avic errata is present, reduce slightly
> > the chances of it happening.


