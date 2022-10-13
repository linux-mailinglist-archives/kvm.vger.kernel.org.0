Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B196D5FD6D2
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 11:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJMJQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 05:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiJMJQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 05:16:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB79FA457
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665652586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1PougXwFNeOBx9Qjbr5s56x+6pgJ2sjuaM5Urh09Fk=;
        b=hi7Sxs3NUN5tw74/8sYvvgVIUK8SB5X2/LwQmwLLi28U1NhOwQUi8ykWVXfSUFBrXEJ/l8
        xpxmpjd81gFK/6a/KiWWrDNc2mYmjUssfVDk3Lcclll7R6olcLfPAofB6bNHhb/ThLJOyS
        LleJ1zdyp3vTSwPWCjpFeNXr+s6JT08=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-329-YpKq4_4IMnaFCj4aEDS8yQ-1; Thu, 13 Oct 2022 05:16:25 -0400
X-MC-Unique: YpKq4_4IMnaFCj4aEDS8yQ-1
Received: by mail-wm1-f72.google.com with SMTP id h129-20020a1c2187000000b003bf635eac31so841310wmh.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 02:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c1PougXwFNeOBx9Qjbr5s56x+6pgJ2sjuaM5Urh09Fk=;
        b=JDJ+CRCDIylIZIhLxvqOmfcQHuzfz8D9rivn97GAQfhJhGNmkFgdc1TlP4L95y3ABl
         qpB62yFiJvL+AB+D5xY4e390Re7Zr15Ngp1Lcil14FYw2BxM8QleZzJAiFCai19WnDAG
         6mI0L/lPPLstddMjIfgRKuxz9Qu/OSRKBrpBQ7iQ53CNqJaiKZ7OCDWm+GUg9ZRPqtlS
         ysrUmHFqM4b0wQM1FsJrFPpaNvQC5DD1dw9L7zFEhxShC3IO1EBuuo8cVEO1R6IHsuNa
         c25H7ydk1WbeDUm5AlyD+9Mhhs7gFiJ61bFYdmpTc66H1EIEwPB8SHS9Ujn0dsndfaPf
         S56Q==
X-Gm-Message-State: ACrzQf27PqiJ0wOPP8vY9Hpkv9kSz2GDqRdkca6aE4ZkjciSTkDkKlxc
        0ZSOGRyNoIPhcXsA28tBBi1093Qlq5ySvXZUuQ7lV77pGzyKwhPgWsAdYGhwSCWSiwSh+YZE1Wt
        qKuxW8/1sQuNb
X-Received: by 2002:a05:600c:1e88:b0:3c3:ecf:ce3e with SMTP id be8-20020a05600c1e8800b003c30ecfce3emr5656943wmb.15.1665652584176;
        Thu, 13 Oct 2022 02:16:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7lz0WlApvKFq530rS3Ksn4hAAN1MoaF0PVyZiyi2JurSmUe0qN78jbTg3xrD4n6KsUR0fbjQ==
X-Received: by 2002:a05:600c:1e88:b0:3c3:ecf:ce3e with SMTP id be8-20020a05600c1e8800b003c30ecfce3emr5656930wmb.15.1665652583965;
        Thu, 13 Oct 2022 02:16:23 -0700 (PDT)
Received: from ovpn-194-196.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g17-20020a05600c4ed100b003b4ac05a8a4sm5313583wmq.27.2022.10.13.02.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 02:16:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] KVM: selftests: Test Hyper-V invariant TSC control
In-Reply-To: <Y0bwwfuO/iubQDPH@google.com>
References: <20220922143655.3721218-1-vkuznets@redhat.com>
 <20220922143655.3721218-7-vkuznets@redhat.com>
 <Y0XGuk4vwJBTU9oN@google.com> <87v8op6wq3.fsf@ovpn-194-196.brq.redhat.com>
 <Y0bwwfuO/iubQDPH@google.com>
Date:   Thu, 13 Oct 2022 11:16:22 +0200
Message-ID: <87pmew6q3d.fsf@ovpn-194-196.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Oct 12, 2022, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 

...

>> > Aha!  Idea.  Assuming none of the MSRs are write-only, what about adding a prep
>> > patch to rework this code so that it verifies RDMSR returns what was written when
>> > a fault didn't occur.
>> >
>> 
>> There is at least one read-only MSR which comes to mind:
>> HV_X64_MSR_EOI.
>
> I assume s/read-only/write-only since it's EOI?
>

Yes, of course)

>> Also, some of the MSRs don't preserve the written value,
>> e.g. HV_X64_MSR_RESET which always reads as '0'.
>
> Hrm, that's annoying.

'Slightly annoying'. In fact, the test never writes anything besides '0'
to the MSR as the code is not ready to handle real vCPU reset. I'll
leave a TODO note about that.

...

> static bool is_write_only_msr(uint32_t msr)
> {
> 	return msr == HV_X64_MSR_EOI;
> }

This is all we need, basically. I'll go with that.

-- 
Vitaly

