Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40364C1610
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 16:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbiBWPDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 10:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiBWPDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 10:03:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93A196E285
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 07:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645628572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exzpM2LSG9f05DEW2rVqdo8gegc7G06w4mF6UEiw0ho=;
        b=HY6UAvm+xUaHzR4joFfbhLikXWAPd7z2xUZUiJUttZJs3zfbbOKkATh32CS1+g2QxvQs0O
        obbkDJvjG44XqxORuaYC5JGpRkgbMF8YbcGMIeMbUB9QMUzPR5fa5SxjXnwRTCBavQ7K2P
        fzEK3sTJwbQdRhzuxoP77e58iY7A5NI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-tTCdhBjuNFOB5XnGGGSZkQ-1; Wed, 23 Feb 2022 10:02:47 -0500
X-MC-Unique: tTCdhBjuNFOB5XnGGGSZkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C886800425;
        Wed, 23 Feb 2022 15:02:45 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C7F210631FB;
        Wed, 23 Feb 2022 15:02:43 +0000 (UTC)
Message-ID: <9af820b8deecf3b6ea31db0993e83f746221634d.camel@redhat.com>
Subject: Re: [PATCH v2 07/18] KVM: x86/mmu: Do not use guest root level in
 audit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>
Date:   Wed, 23 Feb 2022 17:02:42 +0200
In-Reply-To: <219937f8-6b49-47db-4ecf-f354b110da1c@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-8-pbonzini@redhat.com> <Yg/nc1jjtUD2fhOR@google.com>
         <219937f8-6b49-47db-4ecf-f354b110da1c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-18 at 19:46 +0100, Paolo Bonzini wrote:
> On 2/18/22 19:37, Sean Christopherson wrote:
> > Since I keep bringing it up...
> > 
> > From: Sean Christopherson<seanjc@google.com>
> > Date: Fri, 18 Feb 2022 09:43:05 -0800
> > Subject: [PATCH] KVM: x86/mmu: Remove MMU auditing
> > 
> > Remove mmu_audit.c and all its collateral, the auditing code has suffered
> > severe bitrot, ironically partly due to shadow paging being more stable
> > and thus not benefiting as much from auditing, but mostly due to TDP
> > supplanting shadow paging for non-nested guests and shadowing of nested
> > TDP not heavily stressing the logic that is being audited.
> > 
> > Signed-off-by: Sean Christopherson<seanjc@google.com>
> 
> Queued, thanks. O:-)

I once kind of played with it.

Note that shadow mmu does have bugs - I can easily crash L1/L2 when
doing repeated migrations when I disable NPT either in L0 or L1,
and when I force the mmu to be always sync (see my strict_mmu patch),
the crashes go away.

mmu audit maybe could have helped with that.

But I won't argue too much about this.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


