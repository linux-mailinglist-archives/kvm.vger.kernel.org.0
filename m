Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC02D24B9AE
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 13:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbgHTLxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 07:53:00 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730027AbgHTLw7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 07:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597924377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sl1A0GJYyx/PpdeVM1m/fCfkzRMyvSRC51l7PfeNxkY=;
        b=AmUXcJvBXqFfFdl4vkih78OTpfyMXSd2na1rWfCd+kbgg+r8eHE3Gr756JiVzm49eGOcmx
        b8GSsNWnvjAQtdR4nlDiXpW37q+9wUcIxsm060bzK3a1ukR2e8RzbAgCcgtyyUDXLJ8gLw
        2T9tkGtCOjdcjaIaG1WtiJ2YzE16qbs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-OVb8DL8xOeOkVLLilJhpGw-1; Thu, 20 Aug 2020 07:52:55 -0400
X-MC-Unique: OVb8DL8xOeOkVLLilJhpGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 22407801AE5;
        Thu, 20 Aug 2020 11:52:54 +0000 (UTC)
Received: from starship (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F36167A40D;
        Thu, 20 Aug 2020 11:52:46 +0000 (UTC)
Message-ID: <36a13760db3cb439eb47057c763845f61449cbcc.camel@redhat.com>
Subject: Re: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few
 places
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
Date:   Thu, 20 Aug 2020 14:52:45 +0300
In-Reply-To: <3effc656-20e8-40c9-d0e3-5c700d9b5572@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
         <20200820091327.197807-3-mlevitsk@redhat.com>
         <f6bf9494-f337-2e53-6e6c-e0b8a847ec8d@redhat.com>
         <608fe03082dc5e4db142afe3c0eb5f7c165f342b.camel@redhat.com>
         <2e8185af-08fc-18c3-c1ca-fa1f7d4665dd@redhat.com>
         <2b8faaead6f7744dc10b4701bd1583a2b494d4f4.camel@redhat.com>
         <3effc656-20e8-40c9-d0e3-5c700d9b5572@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-08-20 at 12:56 +0200, Paolo Bonzini wrote:
> On 20/08/20 12:23, Maxim Levitsky wrote:
> > I fully agree that adding local variable is a good idea anyway.
> > 
> > I was just noting that svm->nested.vmcb is already about the nested
> > (e.g vmcb12) thus I was thinking that naming this field vmcb12 would be
> > redundant and not accepted this way.
> 
> We want to have both svm->nested.vmcb12 and svm->nested.vmcb02 in there,
> and hsave is also a VMCB of sort (somewhat like a vmcb01 that is only
> used while running a nested guest).  So it is clearer to write _which_
> vmcb it is, and it also helps by making terminology consistent between
> VMX and SVM.
This makes sense.
Best regards,
	Maxim Levitsky

> 
> Paolo
> 


