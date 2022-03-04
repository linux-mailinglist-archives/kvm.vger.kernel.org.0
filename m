Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398DF4CD2D2
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbiCDKzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236544AbiCDKzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:55:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3D3A1AEEC6
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646391284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7s/lxrFPB1XJVbl3uCZFp5Kc2+3RQJwgC3q7lGcv94=;
        b=DOFLsK52LbBwtAU4ReBOYDePZEZ+bT9IWkJOkC5N5m4BsAFdsR2NPqU19Y8qvrwefCMSkF
        rvl67Gped4WTl0ThXiRPja8jrvgCVHvrZvyBnzdIVPdXGgo1EMw9rxO9ormV2MnysovVzN
        QOrxLmTQEqO39AKkl3gRYR0z+AwjX8I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-suPo5m-5NNukxLXVpqeNUw-1; Fri, 04 Mar 2022 05:54:40 -0500
X-MC-Unique: suPo5m-5NNukxLXVpqeNUw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8E2B1800D50;
        Fri,  4 Mar 2022 10:54:38 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2A98842D9;
        Fri,  4 Mar 2022 10:54:34 +0000 (UTC)
Message-ID: <bc54dd197ce2e13420ce43be0156ee7335cf9de6.camel@redhat.com>
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
Date:   Fri, 04 Mar 2022 12:54:33 +0200
In-Reply-To: <YiEbsasKjrvKKyff@google.com>
References: <20220301135526.136554-1-mlevitsk@redhat.com>
         <20220301135526.136554-5-mlevitsk@redhat.com> <Yh5QJ4dJm63fC42n@google.com>
         <6f4819b4169bd4e2ca9ab710388ebd44b7918eed.camel@redhat.com>
         <Yh5b3eBYK/rGzFfj@google.com>
         <297c8e41f512587230a54130a71ddfd9004c9507.camel@redhat.com>
         <eae0b69fb8f5c47457fac853cc55b41a30762994.camel@redhat.com>
         <YiDx/uYAMSZDvobO@google.com>
         <df1ed2b01c74310bd4918196ba632e906e4c78f1.camel@redhat.com>
         <YiEZJ6tg0+I+MdW5@google.com> <YiEbsasKjrvKKyff@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-03-03 at 19:49 +0000, Sean Christopherson wrote:
> On Thu, Mar 03, 2022, Sean Christopherson wrote:
> > With your proposed change, KVM_SET_LAPIC will fail and we've broken a functional,
> > if sketchy, setup.  Is there likely to be such a real-world setup that doesn't
> > barf on the inconsistent x2APIC ID?  Probably not, but I don't see any reason to
> > find out.
> 
> I take back the "probably not", this isn't even all that contrived.  Prior to the
> "migration", the guest will see a consistent x2APIC ID.  It's not hard to imagine
> a guest that snapshots the ID and never re-reads the value from "hardware".
> 
Ok. you win. I will not argue about this.

Best regards,
	Maxim Levitsky

