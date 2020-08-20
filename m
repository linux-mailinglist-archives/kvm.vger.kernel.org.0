Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5DA24B8DC
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 13:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbgHTLaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 07:30:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730594AbgHTKFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 06:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQk9HF5WyLsR7Qjp7OmzOvtHJ+K+Qv4nXKEE5TBkCHU=;
        b=P0ncrEOj8ays6jEwbw0sgcehEGjGm7eIb/32vYxzM66YtN4lNGBajOl5Urmi6KtVlp8Xlp
        CLvM490voNxw+tXgEjBsiRTZcnBjnUhe7z+eVoGT18tsx+2OmZH2oQrvvIgev/ETFhLkEp
        ND1nVCB3HwG7w+8pS9OSsbXNMNR3vBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-cGDsWAEVNY2VwpKo97NMHQ-1; Thu, 20 Aug 2020 06:05:43 -0400
X-MC-Unique: cGDsWAEVNY2VwpKo97NMHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F335807332;
        Thu, 20 Aug 2020 10:05:41 +0000 (UTC)
Received: from starship (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FE3F7E309;
        Thu, 20 Aug 2020 10:05:38 +0000 (UTC)
Message-ID: <33166884f54569ab47cc17a4c3e01f9dbc96401a.camel@redhat.com>
Subject: Re: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested
 guest data area
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
Date:   Thu, 20 Aug 2020 13:05:37 +0300
In-Reply-To: <53afbfba-427e-72f5-73a6-faea7606e78e@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
         <20200820091327.197807-9-mlevitsk@redhat.com>
         <53afbfba-427e-72f5-73a6-faea7606e78e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 12:01 +0200, Paolo Bonzini wrote:
> On 20/08/20 11:13, Maxim Levitsky wrote:
> > +	u32 clean = nested_vmcb->control.clean;
> > +
> > +	if (svm->nested.vmcb_gpa != vmcb_gpa) {
> > +		svm->nested.vmcb_gpa = vmcb_gpa;
> > +		clean = 0;
> > +	}
> 
> You probably should set clean to 0 also if the guest doesn't have the
> VMCBCLEAN feature (so, you first need an extra patch to add the
> VMCBCLEAN feature to cpufeatures.h).  It's probably best to cache the
> guest vmcbclean in struct vcpu_svm, too.

Right, I totally forgot about this one.

One thing why I made this patch optional, is that I can instead drop it,
and not 'read back' the saved area on vmexit, this will probably be faster
that what this optimization does. What do you think? Is this patch worth it?
(I submitted it because I already implemented this and wanted to hear opinion
on this).

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


