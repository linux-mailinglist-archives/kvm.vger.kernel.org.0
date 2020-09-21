Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F32271EE4
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 11:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgIUJ1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 05:27:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726326AbgIUJ1D (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 05:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600680422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/mWcb3lVK8Gq7w/NdqwWlKh9+OIwDSzQsY/Vm1E6nM=;
        b=E/4hG1RofRhA4crNSTNGy4j3N6+EhNFjhLfSq72SC3IgmKuxjD7C/H3JZDJBE6q47zvdy7
        oq107/50Y/sT+7pxHNM0EgyCGNRfu5IDH8oPb+TKgU+JbdndMYyDZkyIIpBSbAhtnIHxOU
        ZE3JpyLcod+FcayaVxNjihmQhQS89hM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-bXlEz8G5OUCmDZnu3Rr_vw-1; Mon, 21 Sep 2020 05:27:00 -0400
X-MC-Unique: bXlEz8G5OUCmDZnu3Rr_vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CEF2186A56B;
        Mon, 21 Sep 2020 09:26:58 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDE2A73684;
        Mon, 21 Sep 2020 09:26:53 +0000 (UTC)
Message-ID: <6310fbe66e89b9f82ac88f7f080ea2eff2dad74e.camel@redhat.com>
Subject: Re: [PATCH 1/1] KVM: x86: fix MSR_IA32_TSC read for nested migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 21 Sep 2020 12:26:52 +0300
In-Reply-To: <20200917161450.GD13522@sjchrist-ice>
References: <20200917110723.820666-1-mlevitsk@redhat.com>
         <20200917110723.820666-2-mlevitsk@redhat.com>
         <20200917161450.GD13522@sjchrist-ice>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-17 at 09:14 -0700, Sean Christopherson wrote:
> On Thu, Sep 17, 2020 at 02:07:23PM +0300, Maxim Levitsky wrote:
> > +		 * Intel PRM states that MSR_IA32_TSC read adds the TSC offset
> 
> One more nit, "Intel SDM" would be preferred as that's most commonly used in
> KVM changelogs, and there are multiple PRM acronyms in Intel's dictionary
> these days.
Fixed.

Best regards,
	Maxim Levitsky

> 
> > +		 * even when not intercepted. AMD manual doesn't define this
> > +		 * but appears to behave the same
> > +		 *
> > +		 * However when userspace wants to read this MSR, return its
> > +		 * real L1 value so that its restore will be correct
> > +		 *
> > +		 */
> > +		if (msr_info->host_initiated)
> > +			msr_info->data = kvm_read_l1_tsc(vcpu, rdtsc());
> > +		else
> > +			msr_info->data = kvm_read_l2_tsc(vcpu, rdtsc());
> >  		break;
> >  	case MSR_MTRRcap:
> >  	case 0x200 ... 0x2ff:
> > -- 
> > 2.26.2
> > 


