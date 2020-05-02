Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681F11C270D
	for <lists+kvm@lfdr.de>; Sat,  2 May 2020 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgEBQoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 May 2020 12:44:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60344 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728312AbgEBQoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 May 2020 12:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588437846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/3LfYCaKp3d91VeRUQIYcTWyqUcJvlD0GVhdC45Qehk=;
        b=CJ+X7ThN2e2pk2EfXUsaqQHLb01POqKWEl1K8eGXJofDsxPdv7KtETW7e0BI4Hsl5hc9wL
        S3mhmWmOqaWqs2lSmUDifXkOmCdWXdFDkyt0Pu5bEU3fG4te73cuFNS0vkt0WTr1p+rAfP
        4n1zkIC1PXBLhjfR9RT4zuRG1fpSxUA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-LDdzYs5ENfCmCj2pPCURgg-1; Sat, 02 May 2020 12:44:03 -0400
X-MC-Unique: LDdzYs5ENfCmCj2pPCURgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6F4C107ACF8;
        Sat,  2 May 2020 16:44:02 +0000 (UTC)
Received: from starship (unknown [10.35.206.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4338B2B7B9;
        Sat,  2 May 2020 16:44:01 +0000 (UTC)
Message-ID: <27ec00547131cc0e0b807e94eb30fdcff5c1cb47.camel@redhat.com>
Subject: Re: AVIC related warning in enable_irq_window
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org
Date:   Sat, 02 May 2020 19:43:59 +0300
In-Reply-To: <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
         <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2020-05-02 at 18:42 +0200, Paolo Bonzini wrote:
> On 02/05/20 15:58, Maxim Levitsky wrote:
> > The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
> > kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
> > however it doesn't broadcast it to CPU on which now we are running, which seems OK,
> > because the code that handles that broadcast runs on each VCPU entry, thus
> > when this CPU will enter guest mode it will notice and disable the AVIC.
> > 
> > However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
> > which is still true on current CPU because of the above.
> 
> Good point!  We can just remove the WARN_ON I think.  Can you send a patch?
> 
> svm_set_vintr also has a rather silly
> 
> static void svm_set_vintr(struct vcpu_svm *svm)
> {
>        set_intercept(svm, INTERCEPT_VINTR);
>        if (is_intercept(svm, INTERCEPT_VINTR))
>                svm_enable_vintr(svm);
> }
> 
> so I'm thinking of just inlining svm_enable_vintr and renaming
> svm_{set,clear}_vintr to svm_{enable,disable}_vintr_window.  Would you
> like to send two patches for this, the first to remove the WARN_ON and
> the second to do the cleanup?

Absolutely! I will send a patch very soon.
Best regards,
	Maxim Levitsky

> 
> Thanks,
> 
> Paolo
> 
> > The code containing this warning was added in commit
> > 
> > 64b5bd27042639dfcc1534f01771b7b871a02ffe
> > KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1


