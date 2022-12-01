Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2030963F204
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 14:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbiLANuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 08:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiLANuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 08:50:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3B256D7F
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 05:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669902546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGkTjaGqlhCrqVn247dB2WearCq0La6BjquyK9aBtH8=;
        b=R1huVt7VHGpv/8SPeMQj/QODLcjEh6uf7cCDdLMakmHWmnzuHrIW0uQ5eTf+9PToh/bjv0
        9VtlRutexE4+3BFOKp2xOD1eojvGjNWrFaT/FVfQLEc6dusIgHKPkvuLsFS0XZNfGB42I+
        kpuZrjwk/gT5nYFHiEJleIVxHZwOjbQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-WCbJKulwMcuUesWW5CN5MA-1; Thu, 01 Dec 2022 08:49:00 -0500
X-MC-Unique: WCbJKulwMcuUesWW5CN5MA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84645101E14D;
        Thu,  1 Dec 2022 13:49:00 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A306111E3EC;
        Thu,  1 Dec 2022 13:48:59 +0000 (UTC)
Message-ID: <3e0678e3ce57f3972945d2523ca66b9bc1d1e720.camel@redhat.com>
Subject: Re: [PATCH] KVM: selftests: restore special vmmcall code layout
 needed by the harness
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date:   Thu, 01 Dec 2022 15:48:58 +0200
In-Reply-To: <87r0xjh3qk.fsf@ovpn-194-141.brq.redhat.com>
References: <20221130181147.9911-1-pbonzini@redhat.com>
         <Y4ffgC+HbftkPbaW@google.com> <87r0xjh3qk.fsf@ovpn-194-141.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-01 at 10:28 +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Nov 30, 2022, Paolo Bonzini wrote:
> > > Commit 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values
> > > in vmmcall()/vmcall()", 2022-11-21) broke the svm_nested_soft_inject_test
> > > because it placed a "pop rbp" instruction after vmmcall.  While this is
> > > correct and mimics what is done in the VMX case, this particular test
> > > expects a ud2 instruction right after the vmmcall, so that it can skip
> > > over it in the L1 part of the test.
> > > 
> > > Inline a suitably-modified version of vmmcall() to restore the
> > > functionality of the test.
> > > 
> > > Fixes: 8fda37cf3d41 ("KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()"
> > > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > 
> > We really, really need to save/restore guest GPRs in L1 when handling exits from L2.
> 
> +1, the amount of stuff we do to workaround the shortcoming (and time
> we waste debugging) is getting ridiculously high. 
> 
> > For now,
> > 
> > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > 
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 

I didn't notice this fix and also found this issue.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

