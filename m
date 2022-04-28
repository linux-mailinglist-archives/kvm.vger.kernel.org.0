Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B45513ADC
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350371AbiD1RaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 13:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236562AbiD1RaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 13:30:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B87F235250
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 10:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651166817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZRY0CP0uuG/LK26ciYdoHEggTFpAtfPg+TlemPGY9CE=;
        b=Q5OUqnRwUsKOsMcshF3Dg1PqFKJ1LLl7aSPvH9LPD3xmElHXR94nREqjsB0TfbpIzoTEKO
        xbmMm4h4/nEfAmhs1qe4rMRxlX6Jze7CEg6g+icB87PeugxOlXWsswPAqmSUAa0oMEyY3b
        NKZP92e5S5DC7Uodrd5clM80hTeBMfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-lHxxeDkwM6WjHK5gSxSWgA-1; Thu, 28 Apr 2022 13:26:54 -0400
X-MC-Unique: lHxxeDkwM6WjHK5gSxSWgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D40511014A62;
        Thu, 28 Apr 2022 17:26:53 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A52D1121319;
        Thu, 28 Apr 2022 17:26:50 +0000 (UTC)
Message-ID: <47eb853424ef6c7dd6439ac33dfeb64a29f49c44.camel@redhat.com>
Subject: Re: [syzbot] WARNING in kvm_mmu_uninit_tdp_mmu (2)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     syzbot <syzbot+a8ad3ee1525a0c4b40ec@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        vkuznets@redhat.com, wanpengli@tencent.com, x86@kernel.org
Date:   Thu, 28 Apr 2022 20:26:49 +0300
In-Reply-To: <d1e4eaba-2dcd-ec08-4e23-98ab8ea6c37b@redhat.com>
References: <00000000000082452505dd503126@google.com>
         <13b3235ef66f22475fd4059df95ad0144548ccd1.camel@redhat.com>
         <YmqzoFqdmH1WuPv0@google.com>
         <d1e4eaba-2dcd-ec08-4e23-98ab8ea6c37b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-28 at 19:22 +0200, Paolo Bonzini wrote:
> On 4/28/22 17:32, Sean Christopherson wrote:
> > On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > > I can reproduce this in a VM, by running and CTRL+C'in my ipi_stress test,
> > 
> > Can you post your ipi_stress test?  I'm curious to see if I can repro, and also
> > very curious as to what might be unique about your test.  I haven't been able to
> > repro the syzbot test, nor have I been able to repro by killing VMs/tests.
> 
> Did you test with CONFIG_PREEMPT=y?

yes, I test with CONFIG_PREEMPT but I only enabled it a day ago,
I think I had seen this warning before, but could bit, I'll check
if that fails without CONFIG_PREEMPT as well.


What I recently changed, is that I enabled lockdep and related settings
on all my machines and VMs, I enabled CONFIG_PREEMPT, and I also
switched to tdp_mmu on all systems.

Bugs are biting but it is better this way, especially to weed out
the last bugs of my nested avic code :)

Best regards,
	Maxim Levitsky


> 
> (BTW, the fact that it reproduces under 5.17 is a mixed blessing, 
> because it means that we can analyze/stare at a simpler codebase).
> 
> Paolo
> 


