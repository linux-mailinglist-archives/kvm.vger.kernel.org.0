Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9A4C485B
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 16:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240744AbiBYPMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 10:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240046AbiBYPL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 10:11:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2203440E6C
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 07:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645801885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+vDSd3MfJiVJ9pM7iY8KPAaFiAK18v4PIHfNY77Ls7M=;
        b=IxuKd3DWsAauMCGyZbWwr+waPQXF9DRZHnfvZO2yDhcxTmP4Jr3GeggsIfVCEkitB5jJAT
        /QfIxbfqEJ2m6T5t25DuFt+/aO66uGsZ5x1UJJKHsrfkHkIhRddvSyQsKahVzRuYNRf5XE
        QGZcstyWiVirGks59pR3TIziC6O0H3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-Uu84fDVSNvicbHA8zeGW2A-1; Fri, 25 Feb 2022 10:11:21 -0500
X-MC-Unique: Uu84fDVSNvicbHA8zeGW2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 051351006AA6;
        Fri, 25 Feb 2022 15:11:19 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C2C78659F;
        Fri, 25 Feb 2022 15:11:12 +0000 (UTC)
Message-ID: <b9638fe3383d7b36846255e1d05afa9c1bfc7a0f.camel@redhat.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
Date:   Fri, 25 Feb 2022 17:11:11 +0200
In-Reply-To: <eb849245c98ea7f5d5e9320ee6ee6b0d1851b439.camel@infradead.org>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-7-guang.zeng@intel.com>
         <79f5ce60c65280f4fb7cba0ceedaca0ff5595c48.camel@redhat.com>
         <eb849245c98ea7f5d5e9320ee6ee6b0d1851b439.camel@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 14:56 +0000, David Woodhouse wrote:
> On Fri, 2022-02-25 at 16:46 +0200, Maxim Levitsky wrote:
> > On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> > > From: Maxim Levitsky <
> > > mlevitsk@redhat.com
> > > 
> > > No normal guest has any reason to change physical APIC IDs, and
> > > allowing this introduces bugs into APIC acceleration code.
> > > 
> > > And Intel recent hardware just ignores writes to APIC_ID in
> > > xAPIC mode. More background can be found at:
> > > https://lore.kernel.org/lkml/Yfw5ddGNOnDqxMLs@google.com/
> > > 
> > > 
> > > Looks there is no much value to support writable xAPIC ID in
> > > guest except supporting some old and crazy use cases which
> > > probably would fail on real hardware. So, make xAPIC ID
> > > read-only for KVM guests.
> > > 
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> > 
> > Assuming that this is approved and accepted upstream,
> > that is even better that my proposal of doing this
> > when APICv is enabled.
> > 
> > Since now apic id is always read only, now we should not 
> > forget to clean up some parts of kvm like kvm_recalculate_apic_map,
> > which are not needed anymore
> 
> Can we also now optimise kvm_get_vcpu_by_id() so it doesn't have to do
> a linear search over all the vCPUs when there isn't a 1:1
> correspondence with the vCPU index?

I don't think so since vcpu id can still be set by userspace to anything,
and this is even used to encode topology in it.


However a hash table can still be used there to speed it up regardless of
read-only apic id IMHO.

Or, even better than a hash table, I see that KVM already 
limits vcpu_id to KVM_MAX_VCPUS * 4 with a comment that only two extra
bits of topology are used:

"In the worst case, we'll need less than one extra bit for the
 * Core ID, and less than one extra bit for the Package (Die) ID,
 * so ratio of 4 should be enough"

Thus, we could in theory standardize location of those bits in apic_id 
(even with a new KVM extension and do linear search for legacy userspace), 
and then just mask/shift the topology bits.

The kvm extension would be defining how many low (or high?) bits of vcpu_id
are topology bits.

Best regards,
	Maxim Levitsky

