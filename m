Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C977E40AA16
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 11:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhINJDz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 05:03:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43765 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhINJDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Sep 2021 05:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631610157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9zHzAE5JRRNzn4tPguLuhYSUPQr1fd/jH5EtFVUE3c=;
        b=QAbt76ZBn3ZTIsTesDpADF+Lf4xTewBwxcV/pBc137OsigI6iBWuRXA+MEOJc7S643TMm4
        Ky5P4jJ4w5OlrLzklw9Yo/GmyZ0EP8956iVCscAv7fdve4ofZwa6pH4LRFy4ONDpazzA2k
        QYbs4UvLGFM9ZAZEvjWNWAPVSBlKWLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-511-6ZFRKCtGND6AYxhtycmzbw-1; Tue, 14 Sep 2021 05:02:36 -0400
X-MC-Unique: 6ZFRKCtGND6AYxhtycmzbw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF157800FF4;
        Tue, 14 Sep 2021 09:02:32 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 668835D9DC;
        Tue, 14 Sep 2021 09:02:29 +0000 (UTC)
Message-ID: <9585f1387b2581d30b74cd163a9aac2adbd37a93.camel@redhat.com>
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 Sep 2021 12:02:28 +0300
In-Reply-To: <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-4-eesposit@redhat.com>
         <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
         <73b5a5bb-48f2-3a08-c76b-a82b5b69c406@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-09-14 at 10:20 +0200, Emanuele Giuseppe Esposito wrote:
> 
> On 12/09/2021 12:42, Maxim Levitsky wrote:
> > >   
> > > -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> > > +	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
> > >   	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> > If you use a different struct for the copied fields, then it makes
> > sense IMHO to drop the 'control' parameter from nested_vmcb_check_controls,
> > and just use the svm->nested.save there directly.
> > 
> 
> Ok, what you say in patch 2 makes sense to me. I can create a new struct 
> vmcb_save_area_cached, but I need to keep nested.ctl because 1) it is 
> used also elsewhere, and different fields from the one checked here are 
> read/set and 2) using another structure (or the same 

Yes, keep nested.ctl, since vast majority of the fields are copied I think.

Best regards,
	Maxim Levitsky


> vmcb_save_area_cached) in its place would just duplicate the same fields 
> of nested.ctl, creating even more confusion and possible inconsistency.
> 
> Let me know if you disagree.
> 
> Thank you,
> Emanuele
> 


