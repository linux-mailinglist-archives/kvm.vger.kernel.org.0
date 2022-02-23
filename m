Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 172A94C1528
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbiBWOLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241416AbiBWOLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:11:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0919BB153E
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 06:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645625472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YdcAku5RTM09+5NmAraAro7hs3RJHhvW1fX0az3zUcE=;
        b=WyWOOlxejBRUUebe7k32lpVJwHpsUkqdmNaErQEzPpKol8JQLs4yHgacL27KeoefkO13P8
        RSBSZ/+hv1KbJTLUQotXMXxS5BsULnn63AEpPeDfGwgu/yZSnkLta1MhM6df2ZvVIUGhhF
        9Fo2bg6mfiDE/bgcez6YxpswxEYVyM8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-15Miu6EtNjqn7LqSAj8OMw-1; Wed, 23 Feb 2022 09:11:08 -0500
X-MC-Unique: 15Miu6EtNjqn7LqSAj8OMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC37D835DE2;
        Wed, 23 Feb 2022 14:11:07 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 405B9866C2;
        Wed, 23 Feb 2022 14:11:06 +0000 (UTC)
Message-ID: <fdd3488193dfb0c60e219f02f181dc41bec2c54e.camel@redhat.com>
Subject: Re: [PATCH v2 03/18] KVM: x86/mmu: WARN if PAE roots linger after
 kvm_mmu_unload
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 23 Feb 2022 16:11:05 +0200
In-Reply-To: <db3e3781-0ae8-7392-b899-b386f4df0368@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-4-pbonzini@redhat.com> <Yg/UCQggoKQ27pVm@google.com>
         <db3e3781-0ae8-7392-b899-b386f4df0368@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-18 at 18:23 +0100, Paolo Bonzini wrote:
> On 2/18/22 18:14, Sean Christopherson wrote:
> > Checkpatch doesn't like it, and IMO the existing asserts
> > are unnecessary.
> 
> I agree that removing the assertions could be another way to go.
> 
> A third and better one could be to just wait until pae_root is gone.  I 
> have started looking at it but I would like your opinion on one detail; 
> see question I posted at 
> https://lore.kernel.org/kvm/7ccb16e5-579e-b3d9-cedc-305152ef9b8f@redhat.com/.
> 
> For now I'll drop this patch.

IMHO, the idea of having shadow pages backing the synthetic pages like pae roots,
is a very good idea.

I hope I get to review that RFC very soon.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


