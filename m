Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030BE4CC4DB
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiCCSQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 13:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiCCSQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:16:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC1D91A3618
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 10:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646331355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBqCnWQ27WKHnjMxdvchXpc/aXYJejhGnK9iylW2jMI=;
        b=XkexL6xhL09xfRelyIJ4X77PYGGpFPNwMj9lc1BridbsIctwsX7daPXUd9fQj7GUAx5gHh
        rtqiJuRBlr23S2lWrz17C/hzetr3WpZLW+d0EX/FJO61zseT6RYSpiNqNErLyGtvOGrUEQ
        3slBcB2fM8A3RDODDK8RiZ+fj7P4fHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-50GVmhIzPbyjqd79N1b_mw-1; Thu, 03 Mar 2022 13:15:52 -0500
X-MC-Unique: 50GVmhIzPbyjqd79N1b_mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6D0051DC;
        Thu,  3 Mar 2022 18:15:49 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD4C28378A;
        Thu,  3 Mar 2022 18:15:45 +0000 (UTC)
Message-ID: <df1ed2b01c74310bd4918196ba632e906e4c78f1.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86: lapic: don't allow to set non default
 apic id when not using x2apic api
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org
Date:   Thu, 03 Mar 2022 20:15:44 +0200
In-Reply-To: <YiDx/uYAMSZDvobO@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-5-mlevitsk@redhat.com> <Yh5QJ4dJm63fC42n@google.com>
         <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
         <Yh5b3eBYK/rGzFfj@google.com>
         <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
         <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
         <YiDx/uYAMSZDvobO@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-03 at 16:51 +0000, Sean Christopherson wrote:
> On Wed, Mar 02, 2022, Maxim Levitsky wrote:
> > When APIC state is loading while APIC is in *x2apic* mode it does enforce that
> > value in this 0x20 offset is initial apic id if KVM_CAP_X2APIC_API.
> >  
> > I think that it is fair to also enforce this when KVM_CAP_X2APIC_API is not used,
> > especially if we make apic id read-only.
> 
> I don't disagree in principle.  But, (a) this loophole as existing for nearly 6
> years, (b) closing the loophole could break userspace, (c) false positive are
> possible due to truncation, and (d) KVM gains nothing meaningful by closing the
> loophole.
> 
> (d) changes when we add a knob to make xAPIC ID read-only, but we can simply
> require userspace to enable KVM_CAP_X2APIC_API (or force it).  That approach
> avoids (c) by eliminating truncation, and avoids (b) by virtue of being opt-in.
> 

(a) - doesn't matter.

(b) - if userspace wants to have non default apic id with x2apic mode,
      which (*)can't even really be set from the guest - this is ridiculous.
 
      (*) Yes I know that in *theory* user can change apic id in xapic mode
      and then switch to x2apic mode - but I really doubt that KVM
      would even honor this - there are already places which assume
      that this is not the case. In fact it would be nice to audit KVM
      on what happens when userspace does this, there might be a nice
      CVE somewhere....
 
(c) - without KVM_CAP_X2APIC_API, literally just call to KVM_GET_LAPIC/KVM_SET_LAPIC
will truncate x2apic id if > 255 regardless of my patch - literally this cap
was added to avoid this.
What we should do is to avoid creating cpu with vcpu_id > 256 when this cap is not set…
 
(d) - doesn't matter - again we are talking about x2apic mode in which apic id is read only.
 

Don’t get me wrong - I understand your concerns about this, but I hope that you
also understand mine - I still think that you just don't understand me.

Best regards,
	Maxim Levitsky

