Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3012C881A
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgK3PfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:35:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727464AbgK3PfA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 10:35:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606750414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FQatalQEFsFszop7DIO2Ob5g7uuYov1pLoszVHjjbgk=;
        b=VDg7bIf8OZcLREUqCjj/cQyThH7bXhgILWBWYLszqdncDUsRyfazqWdVj2/zn2UqjNYsFH
        SqzzJKlK/NWLCD4Rt2B3lHPN8iKCdRNm0pSDRTfTqe4G9jBryJs2r7XgfMCSaajkuewrka
        fFjcPZKgc/yPVVI9Xz3/xXt7U4e+faQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-5J4J05ODOcqkm__noHraNA-1; Mon, 30 Nov 2020 10:33:30 -0500
X-MC-Unique: 5J4J05ODOcqkm__noHraNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D097FE41;
        Mon, 30 Nov 2020 15:33:26 +0000 (UTC)
Received: from starship (unknown [10.35.206.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4989C5C233;
        Mon, 30 Nov 2020 15:33:16 +0000 (UTC)
Message-ID: <989974f32eab61187557239172c603857d4bd837.camel@redhat.com>
Subject: Re: [PATCH 2/2] KVM: x86: introduce KVM_X86_QUIRK_TSC_HOST_ACCESS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        open list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 30 Nov 2020 17:33:15 +0200
In-Reply-To: <5e77e912-893b-0c8f-a9a6-b43eaee24ed3@redhat.com>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <20201130133559.233242-3-mlevitsk@redhat.com>
         <c093973e-c8da-4d09-11f2-61cc0918f55f@redhat.com>
         <638a2919cf7c11c55108776beecafdd8e2da2995.camel@redhat.com>
         <5e77e912-893b-0c8f-a9a6-b43eaee24ed3@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-11-30 at 15:15 +0100, Paolo Bonzini wrote:
> On 30/11/20 15:11, Maxim Levitsky wrote:
> > On Mon, 2020-11-30 at 14:54 +0100, Paolo Bonzini wrote:
> > > On 30/11/20 14:35, Maxim Levitsky wrote:
> > > > This quirk reflects the fact that we currently treat MSR_IA32_TSC
> > > > and MSR_TSC_ADJUST access by the host (e.g qemu) in a way that is different
> > > > compared to an access from the guest.
> > > > 
> > > > For host's MSR_IA32_TSC read we currently always return L1 TSC value, and for
> > > > host's write we do the tsc synchronization.
> > > > 
> > > > For host's MSR_TSC_ADJUST write, we don't make the tsc 'jump' as we should
> > > > for this msr.
> > > > 
> > > > When the hypervisor uses the new TSC GET/SET state ioctls, all of this is no
> > > > longer needed, thus leave this enabled only with a quirk
> > > > which the hypervisor can disable.
> > > > 
> > > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > 
> > > This needs to be covered by a variant of the existing selftests testcase
> > > (running the same guest code, but different host code of course).
> > Do you think that the test should go to the kernel's kvm unit tests,
> > or to kvm-unit-tests project?
> 
> The latter already has x86_64/tsc_msrs_test.c (which I created in 
> preparation for this exact change :)).

I'll prepare a test then for it!

Best regards,
	Maxim Levitsky
> 
> Paolo
> 


