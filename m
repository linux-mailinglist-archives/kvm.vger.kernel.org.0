Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F05EF6ED
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 15:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiI2Nwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 09:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiI2Nwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 09:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E4B14769F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 06:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664459554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ipdsBNiCU5QZTpFMyWEFqXQ10vbG8H1g103O/b01nPg=;
        b=cS3OhcD08RMKgejOQpLTUjvU4Bx+3KVYNG9mJfcxpjfqt3pao7fzc4MSlprpikLDhX9cDQ
        RVzjT/+hikcwTRC57qzEniMW+GPnq17YDQPea+2ZXXoNVsV/ijub9WOQcpqM3Oj8uXbo++
        2eggpPeLOOUdnNdLK9A6PvMk5ws76c0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-x6rC90CZMa6qMaMfHVX-4Q-1; Thu, 29 Sep 2022 09:52:30 -0400
X-MC-Unique: x6rC90CZMa6qMaMfHVX-4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACC79101A52A;
        Thu, 29 Sep 2022 13:52:29 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7102C40C6EC2;
        Thu, 29 Sep 2022 13:52:28 +0000 (UTC)
Message-ID: <b8fa9561295bb6af2b7fcaa8125c6a3b89b305c7.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: disable on 32-bit unless CONFIG_BROKEN
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 29 Sep 2022 16:52:26 +0300
In-Reply-To: <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
References: <20220926165112.603078-1-pbonzini@redhat.com>
         <YzMt24/14n1BVdnI@google.com>
         <ed74c9a9d6a0d2fd2ad8bd98214ad36e97c243a0.camel@redhat.com>
         <15291c3f-d55c-a206-9261-253a1a33dce1@redhat.com>
         <YzRycXDnWgMDgbD7@google.com>
         <ad97d0671774a873175c71c6435763a33569f669.camel@redhat.com>
         <YzSKhUEg3L1eMKOR@google.com>
         <08dab49f-9ca4-4978-4482-1815cf168e74@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-29 at 15:26 +0200, Paolo Bonzini wrote:
> On 9/28/22 19:55, Sean Christopherson wrote:
> > > As far as my opinion goes I do volunteer to test this code more often,
> > > and I do not want to see the 32 bit KVM support be removed*yet*.
> > 
> > Yeah, I 100% agree that it shouldn't be removed until we have equivalent test
> > coverage.  But I do think it should an "off-by-default" sort of thing.  Maybe
> > BROKEN is the wrong dependency though?  E.g. would EXPERT be a better option?
> 
> Yeah, maybe EXPERT is better but I'm not sure of the equivalent test 
> coverage.  32-bit VMX/SVM kvm-unit-tests are surely a good idea, but 
> what's wrong with booting an older guest?

From my point of view, using the same kernel source for host and the guest
is easier because you know that both kernels behave the same.

About EXPERT, IMHO these days most distros already dropped 32 bit suport thus anyway
one needs to compile a recent 32 bit kernel manually - thus IMHO whoever
these days compiles a 32 bit kernel, knows what they are doing.

I personally would wait few more releases when there is a pressing reason to remove
this support.

AFAIK, it is not really possible to remove most of the legacy direct mmu
because shadowing mmu still can use it (I think Sean told me that once).

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


