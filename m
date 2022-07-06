Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA856922F
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 20:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiGFSuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 14:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiGFSux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 14:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E892D25C5B
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657133450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VXm7agXtiv+U3vrTaDHt2nr+7qTTcMzlC2o0102s4c=;
        b=eTKA0ionBGRk7dPZAaPddlur09ih6LrXE7/lzMWi7e31AqUQuLw4k2JKhTJnT9AEez0BsH
        oEgIYPYK0vNDUguZfGWdhHn2GH/YIe24Ma4DioH96oWmip9YtjFCty8MIsxRmEuaJOaXUx
        +ZrETb5gqlg/+JEt+sfsJ6uKYVQ0JG4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-213-Te3BkxTNPBKv-FuUOUFLOg-1; Wed, 06 Jul 2022 14:50:47 -0400
X-MC-Unique: Te3BkxTNPBKv-FuUOUFLOg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB193811E81;
        Wed,  6 Jul 2022 18:50:46 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 994A8492C3B;
        Wed,  6 Jul 2022 18:50:40 +0000 (UTC)
Message-ID: <7160446153df8710f78db8e0d0e135a583b13e0b.camel@redhat.com>
Subject: Re: [PATCH v2 02/21] KVM: VMX: Drop bits 31:16 when shoving
 exception error code into VMCS
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Wed, 06 Jul 2022 21:50:39 +0300
In-Reply-To: <YsW0ZDkfVywkQEJO@google.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <20220614204730.3359543-3-seanjc@google.com>
         <df72cfcdda55b594d6bbbd9b5b0e2b229dc6c718.camel@redhat.com>
         <YsW0ZDkfVywkQEJO@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-07-06 at 16:12 +0000, Sean Christopherson wrote:
> On Wed, Jul 06, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-06-14 at 20:47 +0000, Sean Christopherson wrote:
> > > Deliberately truncate the exception error code when shoving it into the
> > > VMCS (VM-Entry field for vmcs01 and vmcs02, VM-Exit field for vmcs12).
> > > Intel CPUs are incapable of handling 32-bit error codes and will never
> > > generate an error code with bits 31:16, but userspace can provide an
> > > arbitrary error code via KVM_SET_VCPU_EVENTS.  Failure to drop the bits
> > > on exception injection results in failed VM-Entry, as VMX disallows
> > > setting bits 31:16.  Setting the bits on VM-Exit would at best confuse
> > > L1, and at worse induce a nested VM-Entry failure, e.g. if L1 decided to
> > > reinject the exception back into L2.
> > 
> > Wouldn't it be better to fail KVM_SET_VCPU_EVENTS instead if it tries
> > to set error code with uppper 16 bits set?
> 
> No, because AMD CPUs generate error codes with bits 31:16 set.  KVM "supports"
> cross-vendor live migration, so outright rejecting is not an option.
> 
> > Or if that is considered ABI breakage, then KVM_SET_VCPU_EVENTS code
> > can truncate the user given value to 16 bit.
> 
> Again, AMD, and more specifically SVM, allows bits 31:16 to be non-zero, so
> truncation is only correct for VMX.  I say "VMX" instead of "Intel" because
> architecturally the Intel CPUs do have 32-bit error codes, it's just the VMX
> architecture that doesn't allow injection of 32-bit values.
> 

Oh, I see AMD uses bit 31 for RMP (from SEV-SNP) page fault,
Thanks for the explanation!

You might want to add this piece of info somewhere as a comment if you wish.

Thanks,
Best regards,
	Maxim Levitsky

