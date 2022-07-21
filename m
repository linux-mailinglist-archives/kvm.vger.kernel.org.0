Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E457CA12
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiGULzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 07:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbiGULzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 07:55:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE1721A5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 04:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658404504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HERq0We8j8CwHoxj+xEjyLsUyfaDI+Q0OqS7fh97oS8=;
        b=FEAJjb0Mmhcg4oRrwmBIg2BpbM85fmziy/r0XW17u6vlY8wNIKgSGoCrVycQyyDHhxTrK9
        QV3vreFN1RAfxC/Lz3p3cgF/ql1cYAh/M2tv/dK/I4gIZSVpll7wiDSVkuNyMxxOyhCYZ9
        nabUbeQtEGmUTfL4VOy93Z2Jxaka1x8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-PyRpB3c-NQqwC8SzSTMV1g-1; Thu, 21 Jul 2022 07:54:59 -0400
X-MC-Unique: PyRpB3c-NQqwC8SzSTMV1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D59BF3C0E216;
        Thu, 21 Jul 2022 11:54:58 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56CEF40C1288;
        Thu, 21 Jul 2022 11:54:55 +0000 (UTC)
Message-ID: <a1d5b658870ea5eb545034a00088ddca5bb6219b.camel@redhat.com>
Subject: Re: [PATCH v2 10/11] KVM: x86: SVM: use smram structs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jul 2022 14:54:54 +0300
In-Reply-To: <YtigJfHmyTr3eE5v@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
         <20220621150902.46126-11-mlevitsk@redhat.com> <YtigJfHmyTr3eE5v@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-21 at 00:39 +0000, Sean Christopherson wrote:
> On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
> 
> I think you want X86_FEATURE_LM, not X86_FEATURE_SVM.
> 

Yes, sorry about that! Thanks!

Best regards,
	Maxim Levitsky

