Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A395D5EE360
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 19:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiI1Rob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 13:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiI1Ro3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 13:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691FFE5F9B
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 10:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664387067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1jdTlaHlqUGsp+WQYmTbrToN1KOLkOWoz/mZqD7wNkI=;
        b=dkDhArSLtTdqdSs1laRmoFAATz1dSshW00Lmps2m2fLOpOUTC+gQPYZdIJhrf/UOeV9PwF
        BY0ZVfid/uKB2RlEBJpSeox1qBICVur2T1xaPszKEoYTntFHnq/h9xWRXZUtTegSflwwlk
        xPB0o437eRHxMzJPyMNSpzCVH5ATSHM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-jTqblEF3M-ypPsQpFngd5Q-1; Wed, 28 Sep 2022 13:44:26 -0400
X-MC-Unique: jTqblEF3M-ypPsQpFngd5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6831B101AA5B;
        Wed, 28 Sep 2022 17:44:25 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B6791121314;
        Wed, 28 Sep 2022 17:44:23 +0000 (UTC)
Message-ID: <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 28 Sep 2022 20:44:22 +0300
In-Reply-To: <YzRycXDnWgMDgbD7@google.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
         <YzMt24/14n1BVdnI@google.com>
         <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
         <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
         <YzRycXDnWgMDgbD7@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-09-28 at 16:12 +0000, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Paolo Bonzini wrote:
> > On 9/28/22 09:10, Maxim Levitsky wrote:
> > > I also think that outside KVM developers nobody should be using KVM on 32 bit host.
> > > 
> > > However for_developement_  I think that 32 bit KVM support is very useful, as it
> > > allows to smoke test the support for 32 bit nested hypervisors, which I do once in a while,
> > > and can even probably be useful to some users (e.g running some legacy stuff in a VM,
> > > which includes a hypervisor, especially to run really legacy OSes / custom bare metal software,
> > > using an old hypervisor) - or in other words, 32 bit nested KVM is mostly useless, but
> > > other 32 bit nested hypervisors can be useful.
> > > 
> > > Yes, I can always use an older 32 bit kernel in a guest with KVM support, but as long
> > > as current kernel works, it is useful to use the same kernel on host and guest.
> > 
> > Yeah, I would use older 32 bit kernels just like I use RHEL4 to test PIT
> > reinjection. :)  But really the ultimate solution to this would be to
> > improve kvm-unit-tests so that we can compile vmx.c and svm.c for 32-bit.
> 
> Agreed.  I too use 32-bit KVM to validate KVM's handling of 32-bit L1 hypervisors,
> but the maintenance cost is painfully high.
> 

But is it actually? I test it routinely and it it does work quite well IMHO.
I don't remember that there were that much breakage lately in this area.

As far as my opinion goes I do volunteer to test this code more often,
and I do not want to see the 32 bit KVM support be removed *yet*.

Best regards,
	Maxim Levitsky

