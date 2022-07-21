Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8B57C9F5
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiGULvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiGULvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:51:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E3FF7B7B6
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDWWSereo1ExuCacDCVfZLh4NMqAbh3clxJOAzBAlMM=;
        b=gaJ4xhUd+8f6SGeNOhbtIVpvmkIKikvh380ZUoHDVvs7/5OyZsQYz/uSlke5U81rljy24v
        CNSsOo3Az/zN/x9ZgX0ospPgbdxpl/sm1iOdBmf/9+MvhmdrB11MfLYEfkv5cyJP+nH+J/
        CF7b+k33foUsLMSUQTnSk263phxg2Uw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-JiA3J-36PLSL8WOmoskXeg-1; Thu, 21 Jul 2022 07:51:34 -0400
X-MC-Unique: JiA3J-36PLSL8WOmoskXeg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0AE2A3826A44;
        Thu, 21 Jul 2022 11:51:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90FBD40D282F;
        Thu, 21 Jul 2022 11:51:31 +0000 (UTC)
Message-ID: <61067e86f0a52314cb6aceeaef5c73846d142a42.camel@redhat.com>
Subject: Re: [PATCH] KVM: nSVM: Pull CS.Base from actual VMCB12 for soft
 int/ex re-injection
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 21 Jul 2022 14:51:30 +0300
In-Reply-To: <Yth00gK0DWjukLgq@google.com>
References: <4caa0f67589ae3c22c311ee0e6139496902f2edc.1658159083.git.maciej.szmigiero@oracle.com>
         <7458497a8694ba0fbabee28eabf557e6e4406fbe.camel@redhat.com>
         <d311c92a-d753-3584-d662-7d82b2fc1e50@maciej.szmigiero.name>
         <Yth00gK0DWjukLgq@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-20 at 21:34 +0000, Sean Christopherson wrote:
> On Wed, Jul 20, 2022, Maciej S. Szmigiero wrote:
> > On 20.07.2022 10:43, Maxim Levitsky wrote:
> > > On Mon, 2022-07-18 at 17:47 +0200, Maciej S. Szmigiero wrote:
> > > > Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> > > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > > > ---
> > > >   arch/x86/kvm/svm/nested.c | 9 +++++----
> > > >   1 file changed, 5 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index adf4120b05d90..23252ab821941 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -639,7 +639,8 @@ static bool is_evtinj_nmi(u32 evtinj)
> > > >   }
> > > >   static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> > > > -                                         unsigned long vmcb12_rip)
> > > > +                                         unsigned long vmcb12_rip,
> > > > +                                         unsigned long vmcb12_csbase)
> > > 
> > > Honestly I don't like that nested_vmcb02_prepare_control starts to grow its parameter list,
> > > because it kind of defeats the purpose of vmcb12 cache we added back then.
> > > 
> > > I think that it is better to add csbase/rip to vmcb_save_area_cached,
> > > but I am not 100% sure. What do you think?
> > 
> > This function has only 3 parameters now, so they fit well into registers
> > without taking any extra memory (even assuming it won't get inlined).
> > 
> > If in the future more parameters need to be added to this function
> > (which may or may not happen) then they all can be moved to, for example,
> > vmcb_ctrl_area_cached.
> 
> I don't think Maxim is concerned about the size, rather that we have a dedicated
> struct for snapshotting select save state and aren't using it.

Yes my thoughts exactly. The thing is that passing these values as parameters to this function
also works like a cache, but not going through the cache that we already have
for this purpose.

Anyway for now let it be, but we might need to rethink it in the future.

Best regards,
	Maxim Levitsky

> 
> IIRC, I deliberately avoided using the "cache" because the main/original purpose
> of the cache is to avoid TOCTOU issues.  And because RIP and CS.base aren't checked,
> there's no need to throw them in the cache.

