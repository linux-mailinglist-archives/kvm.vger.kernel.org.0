Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6145A5136FE
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348307AbiD1OiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiD1OiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:38:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C716DB6E50
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651156491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5PDm4tHCHPYdLQ9C5vAO9ilNtVAoyTm1UBO+qRDuy2I=;
        b=Sn4z5XqgjETqPOGWmwO3piPSS7DWP7yytyJbIZa3tfpEsBC9w6nM8WwUzQ2QuIt4bZrUCm
        lcMPbWNsKlcf795/zT+nAAlAWmVd00zNVr84tH8/qWnJ9Qsd4UTVWLcRg/NVdWs8bKAehx
        /Bhnt2HsOxbwBW8OnthnpXltMuGYjwg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-mXTDc8oQPDqKujQj-mWFaQ-1; Thu, 28 Apr 2022 10:34:48 -0400
X-MC-Unique: mXTDc8oQPDqKujQj-mWFaQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8B9328001EA;
        Thu, 28 Apr 2022 14:34:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C3242166B4D;
        Thu, 28 Apr 2022 14:34:45 +0000 (UTC)
Message-ID: <b8a02f2eab780262c172cd4bbffd801ca8a37e98.camel@redhat.com>
Subject: Re: [PATCH v2 02/11] KVM: SVM: Don't BUG if userspace injects a
 soft interrupt with GIF=0
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 28 Apr 2022 17:34:44 +0300
In-Reply-To: <4baa5071-3fb6-64f3-bcd7-2ffc1181d811@maciej.szmigiero.name>
References: <20220423021411.784383-1-seanjc@google.com>
         <20220423021411.784383-3-seanjc@google.com>
         <61ad22d6de1f6a51148d2538f992700cac5540d4.camel@redhat.com>
         <4baa5071-3fb6-64f3-bcd7-2ffc1181d811@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 15:27 +0200, Maciej S. Szmigiero wrote:
> On 28.04.2022 09:35, Maxim Levitsky wrote:
> > On Sat, 2022-04-23 at 02:14 +0000, Sean Christopherson wrote:
> > > From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > > 
> > > Don't BUG/WARN on interrupt injection due to GIF being cleared if the
> > > injected event is a soft interrupt, which are not actually IRQs and thus
> > 
> > Are any injected events subject to GIF set? I think that EVENTINJ just injects
> > unconditionaly whatever hypervisor puts in it.
> 
> That's right, EVENTINJ will pretty much always inject, even when the CPU
> is in a 'wrong' state (like for example, injecting a hardware interrupt
> or a NMI with GIF masked).
> 
> But KVM as a L0 is not supposed to inject a hardware interrupt into guest
> with GIF unset since the guest is obviously not expecting it then.
> Hence this WARN_ON().

If you mean L0->L1 injection, that sure, but if L1 injects interrupt to L2,
then it should always be allowed to do so.


I am not sure that I am right here, just noticed something odd. I'll take
a better look at this next week.


Best regards,
	Maxim levitsky

> 
> > Best regards,
> > 	Maxim Levitsky
> 
> Thanks,
> Maciej
> 


