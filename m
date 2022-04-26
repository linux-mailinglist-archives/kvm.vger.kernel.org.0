Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F415104FE
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 19:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354705AbiDZROp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 13:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354029AbiDZRMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 13:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4EE5338B1
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 10:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650992887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEzH7XriBRSQTqPfGTh82qvKfLzT4wtnMiErDzxGzcQ=;
        b=GYmQty1Hs1UXQShiGCkUgzX7POm2sg7mB7FkX3Iew4JYc6YvNIcdrWbU4SZF8KIt0H/eHg
        aFie3R4rz0JHCe8sqxfrE4XjHK4g5d66xqmVBCa3WaSNF+USffB4xnRawkJRM0zU0R6uST
        5G9lk+flVaiUKvXZ4tFddA5r/Yt0Rp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-EXQhgoLqP_qHJ0AExwjFWg-1; Tue, 26 Apr 2022 13:08:04 -0400
X-MC-Unique: EXQhgoLqP_qHJ0AExwjFWg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F309811E80;
        Tue, 26 Apr 2022 17:08:03 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8431463ED1;
        Tue, 26 Apr 2022 17:08:02 +0000 (UTC)
Message-ID: <f3086e25e7a22d647e5f3e2b73e01a24844bb9c1.camel@redhat.com>
Subject: Re: Another nice lockdep print in nested SVM code
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Tue, 26 Apr 2022 20:08:01 +0300
In-Reply-To: <9eb9d0db-f8d1-e555-567c-b76a85997701@redhat.com>
References: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
         <17948270d3c3261aa9fc5600072af437e4b85482.camel@redhat.com>
         <7a627c97-0fb1-cb35-8623-7893e228852c@redhat.com>
         <2dea96f99ee7b3b47702292a699d9ac7af1afaaf.camel@redhat.com>
         <9eb9d0db-f8d1-e555-567c-b76a85997701@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 19:05 +0200, Paolo Bonzini wrote:
> On 4/26/22 18:56, Maxim Levitsky wrote:
> > > Yeah, in that case I can't think of anything better than triple fault.
> > > 
> > > Paolo
> > > 
> > But do you think that it would be better to keep the vmcb12 page mapped/pinned while doing the nested run
> > which will both solve the problem of calling sleeping function and allow us
> > to remove the case of map failing on vm exit?
> > 
> > If I remember correctly, vmx does something like that.
> 
> Yes, it does, but that's because vmx would have to do a lot of mapping 
> and unmapping for vmread/vmwrite on highmem (32-bit) kernels.  So it 
> maps at vmptrld and unmaps and vmclear.  I wouldn't consider it an 
> example to follow.

All right, but what are the downsides of keeping this page mapped?

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


