Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8720652851C
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 15:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiEPNOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241730AbiEPNOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 09:14:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7210C3A18F
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 06:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652706880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJ97JlAV6zFIz097rsMrqoY03C5F3dZPF0NCbznRE10=;
        b=BoVnPPGGDYkx1/TbDBe9UDZvI9s0J41vD+iFhpGtEl64OJ3pJMwRIMEo/1w3/FWwGnmYZB
        9PYRlfi5H8cbJIxvaC+wDsxB4hmkps9GCdD6zChqqGwP8I/eMftNeFbDh+fkSkJZaXIKe/
        FdOcoirqLPl5gsIgy+2/sShFnam4F/s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-vb0tcTncOW6xQRoSVjL4CA-1; Mon, 16 May 2022 09:14:36 -0400
X-MC-Unique: vb0tcTncOW6xQRoSVjL4CA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2275C1DB28A0;
        Mon, 16 May 2022 13:14:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D487140D1B98;
        Mon, 16 May 2022 13:14:32 +0000 (UTC)
Message-ID: <f05dcf66ed2bfb7d113ce0d9a261569959265c68.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused
 cmpxchg to be not atomic
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Mon, 16 May 2022 16:14:31 +0300
In-Reply-To: <Yn17urxf7vprODed@google.com>
References: <20220202004945.2540433-5-seanjc@google.com>
         <20220512101420.306759-1-mlevitsk@redhat.com>
         <87e16c11-d57b-92cd-c10b-21d855f475ef@redhat.com>
         <Yn17urxf7vprODed@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-05-12 at 21:27 +0000, Sean Christopherson wrote:
> On Thu, May 12, 2022, Paolo Bonzini wrote:
> > On 5/12/22 12:14, Maxim Levitsky wrote:
> > > Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
> > > Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
> > > under same spte.
> > 
> > Awesome!  And queued, thanks.
> 
> If you haven't done so already, can you add 
> 
>   Cc: stable@vger.kernel.org

When I posted my patch, I checked that the patch didn't reach mainline yet,
so I assumed that it won't be in -stable either yet, although it was CCed there.


> 
> Also, given that we have concrete proof that not honoring atomic accesses can have
> dire consequences for the guest, what about adding a capability to turn the emul_write
> path into an emulation error?
> 


This is a good idea. It might though break some guests - I did see that
warning few times, that is why I wasn't alert by the fact that it started showing up more often.

I'll take a look at this soon.

Best regards,
	Maxim Levitsky

