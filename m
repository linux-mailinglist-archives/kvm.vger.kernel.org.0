Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A6B60FEFC
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 19:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiJ0RKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 13:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237102AbiJ0RKV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 13:10:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CB165543
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 10:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666890619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nTgmHiaY++R2zVxxlFfFezwFxGvZNe2Ob6Ll2wA7jzM=;
        b=iQMiFF6Cd0M4rIvBLucS29au0p3+MAQNOcdAhoUgD+wOrbONbZYCBD2jyDXL05vibi8mP6
        JOI7higT5upGndCN19S1mnPedL2ZELypCEl/RspYER75L2+k5bdX8lzqCerzdLYTyful5e
        KXMNE2RqKS4gdQIV69vbdoSPGKRAQl0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-Mae1ylAtPLqUMuxnzZph7Q-1; Thu, 27 Oct 2022 13:10:18 -0400
X-MC-Unique: Mae1ylAtPLqUMuxnzZph7Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B17B8828C3;
        Thu, 27 Oct 2022 17:10:17 +0000 (UTC)
Received: from starship (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 059F6492B16;
        Thu, 27 Oct 2022 17:10:15 +0000 (UTC)
Message-ID: <646889178a52d74a8a9036fb523a04ca4fb037ad.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/16] x86: make irq_enable avoid the
 interrupt shadow
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 27 Oct 2022 20:10:14 +0300
In-Reply-To: <Y1qowfkxEGWizEls@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
         <20221020152404.283980-2-mlevitsk@redhat.com> <Y1GNE9YdEuGPkadi@google.com>
         <a52dfb9b126354f0ec6a3f6cb514cc5e426b22ae.camel@redhat.com>
         <Y1cWfiKayXy5xvji@google.com>
         <35223fa0e5f09b33180ba161e1b2e16ce0d0669f.camel@redhat.com>
         <Y1qowfkxEGWizEls@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-27 at 15:50 +0000, Sean Christopherson wrote:
> On Thu, Oct 27, 2022, Maxim Levitsky wrote:
> > On Mon, 2022-10-24 at 22:49 +0000, Sean Christopherson wrote:
> > > On Mon, Oct 24, 2022, Maxim Levitsky wrote:
> > > > I usually use just "\n", but the safest is "\n\t".
> > > 
> > > I'm pretty sure we can ignore GCC's warning here and maximize readability.  There
> > > are already plenty of asm blobs that use a semicolon.
> > 
> > IMHO this is corner cutting and you yourself said that this is wrong.
> > 
> > The other instances which use semicolon should be fixed IMHO.
> 
> The kernel itself has multiple instances of "sti; ..." alone, I'm quite confident
> this we can prioritize making the code easy to read without risking future breakage.
> 
> $ git grep -E "\"sti\;"
> arch/x86/include/asm/irqflags.h:        asm volatile("sti; hlt": : :"memory");
> arch/x86/include/asm/mwait.h:   asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
> arch/x86/include/asm/paravirt.h:        PVOP_ALT_VCALLEE0(irq.irq_enable, "sti;", ALT_NOT(X86_FEATURE_XENPV));
> tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c:            asm volatile("sti; hlt; cli");
> tools/testing/selftests/x86/iopl.c:             asm volatile("sti; pushf; pop %[flags]"
> 

All right, let it be, but then lets also replace of '\n\t' with just '\n', just so that we don't pretend that
we follow the gcc advice, to at least be consistent.

Best regards,
	Maxim Levitsky

