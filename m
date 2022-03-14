Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCBC4D809F
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 12:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbiCNL0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 07:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbiCNL0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 07:26:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 452533B02A
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647257139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRARorNMuLEMO3Q74z8VCs95vYReIERotUo2AAQgnIw=;
        b=R2lOz5nWhTcHT0bIJ37HGb18H38bezEn6fEkGTaMmfNfCx13HaAiyq2/169LndPq9fn1eY
        3P3mRM4BonRG2S0r4hsPwzLQ9ekF0SaI6N7ONX3ZWdnoxDkW2FaNZvQymKasnLFDt+KShp
        aXXh66XmU0UNPAEh3rftMM/ipGibmP4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-Ij4WiYpgP3OkQjmqTocYKA-1; Mon, 14 Mar 2022 07:25:36 -0400
X-MC-Unique: Ij4WiYpgP3OkQjmqTocYKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D739101AA77;
        Mon, 14 Mar 2022 11:25:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C42C40F9D48;
        Mon, 14 Mar 2022 11:25:32 +0000 (UTC)
Message-ID: <00b4248797a993fca85a6faec7fb350275cafb75.camel@redhat.com>
Subject: Re: [PATCH v3 1/7] KVM: x86: nSVM: correctly virtualize LBR msrs
 when L2 is running
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>
Date:   Mon, 14 Mar 2022 13:25:31 +0200
In-Reply-To: <e38f0d14-419d-7b3d-4ce4-bd37200ba232@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
         <20220301143650.143749-2-mlevitsk@redhat.com>
         <e38f0d14-419d-7b3d-4ce4-bd37200ba232@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-09 at 14:00 +0100, Paolo Bonzini wrote:
> On 3/1/22 15:36, Maxim Levitsky wrote:
> > +void svm_copy_lbrs(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
> > +{
> > +	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
> > +	to_vmcb->save.br_from		= from_vmcb->save.br_from;
> > +	to_vmcb->save.br_to		= from_vmcb->save.br_to;
> > +	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
> > +	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
> > +
> > +	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
> > +}
> > +
> 
> I think "struct vmcb *to_vmcb, struct vmcb *from_vmcb" is more common 
> (e.g. svm_copy_vmrun_state, svm_copy_vmloadsave_state).
> 
> Paolo
> 
Will do.

Best regards,
	Maxim Levitsky

