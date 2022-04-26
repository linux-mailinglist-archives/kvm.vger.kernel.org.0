Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDD5104B5
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346402AbiDZQ7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353666AbiDZQ7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:59:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0A9D12619
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650992170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YjvvWssXq8rjQwYic6zivcuaRqe/JeIgLoHGnoX+Xcc=;
        b=TwpJby3uxcA0t0LvWvLzlz+SAd+KpedLwMAGaJsv/ElgVWDDxRlABGG0H6dyx0ktOX0W1L
        jNgProj+nzdlMk1SK8kfUPTbeHjG1xW4SlCy5i4IBvbxwx8IcUlsHdUNX9CBFm9TSGjSBG
        LCWp9s7hPxlLbiPp5tbmNR6gpd7hW3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-FwZW39PfMIqMM324oMD6oA-1; Tue, 26 Apr 2022 12:56:07 -0400
X-MC-Unique: FwZW39PfMIqMM324oMD6oA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCB5D803D67;
        Tue, 26 Apr 2022 16:56:04 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 566D4C27E81;
        Tue, 26 Apr 2022 16:56:03 +0000 (UTC)
Message-ID: <2dea96f99ee7b3b47702292a699d9ac7af1afaaf.camel@redhat.com>
Subject: Re: Another nice lockdep print in nested SVM code
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
Date:   Tue, 26 Apr 2022 19:56:02 +0300
In-Reply-To: <7a627c97-0fb1-cb35-8623-7893e228852c@redhat.com>
References: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
         <17948270d3c3261aa9fc5600072af437e4b85482.camel@redhat.com>
         <7a627c97-0fb1-cb35-8623-7893e228852c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 18:47 +0200, Paolo Bonzini wrote:
> On 4/26/22 18:43, Maxim Levitsky wrote:
> > Actually for vmrun, that #GP is I think sort of correct now - that is
> > what AMD cpus do on 'invalid physical address', but for VM exit, we
> > just need to have the vmcb mapped instead of mapping it again -
> > injecting #GP at that point which will go to the nested guest is just
> > wrong.
> 
> Yeah, in that case I can't think of anything better than triple fault.
> 
> Paolo
> 
But do you think that it would be better to keep the vmcb12 page mapped/pinned while doing the nested run
which will both solve the problem of calling sleeping function and allow us
to remove the case of map failing on vm exit?

If I remember correctly, vmx does something like that.

Best regards,
	Maxim Levitsky

