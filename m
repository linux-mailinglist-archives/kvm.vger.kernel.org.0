Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF1B1C3555
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 11:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgEDJNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 05:13:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726751AbgEDJNz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 05:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588583633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=84FYeu+Y/BZJ25AptG7IThNwoOt4gkPs9yl7t+IFJuc=;
        b=ilRGt2zTaLdrqY09+IEfCBEl+ylffendz5gXMaTApB1MrNhdYcR2vUc5/gKhW+Ju9N4EJJ
        gkz1gT5UVcSEqODPqz5T9hCIWAAhj2MBvl2+18M9n6pEWzVv+KQr90Bo4kbPRCW+4BBrUF
        tWFUnCnC87ru/j8gRcyVvcoQI71sPYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-ahw7Sc6jNv2Od3h0BoWisA-1; Mon, 04 May 2020 05:13:51 -0400
X-MC-Unique: ahw7Sc6jNv2Od3h0BoWisA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 508138014C0;
        Mon,  4 May 2020 09:13:50 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14766100239A;
        Mon,  4 May 2020 09:13:48 +0000 (UTC)
Message-ID: <159382e7fdf0f9b50d79e29554842289e92e1ed7.camel@redhat.com>
Subject: Re: AVIC related warning in enable_irq_window
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Mon, 04 May 2020 12:13:47 +0300
In-Reply-To: <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
         <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
         <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-05-04 at 15:46 +0700, Suravee Suthikulpanit wrote:
> Paolo / Maxim,
> 
> On 5/2/20 11:42 PM, Paolo Bonzini wrote:
> > On 02/05/20 15:58, Maxim Levitsky wrote:
> > > The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
> > > kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
> > > however it doesn't broadcast it to CPU on which now we are running, which seems OK,
> > > because the code that handles that broadcast runs on each VCPU entry, thus
> > > when this CPU will enter guest mode it will notice and disable the AVIC.
> > > 
> > > However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
> > > which is still true on current CPU because of the above.
> > 
> > Good point!  We can just remove the WARN_ON I think.  Can you send a patch?
> 
> Instead, as an alternative to remove the WARN_ON(), would it be better to just explicitly
> calling kvm_vcpu_update_apicv(vcpu) to update the apicv_active flag right after
> kvm_request_apicv_update()?
> 
> Thanks,
> Suravee
> 

This should work IMHO, other that the fact kvm_vcpu_update_apicv will be called again,
when this vcpu is entered since the KVM_REQ_APICV_UPDATE will still be pending on it.
It shoudn't be a problem, and we can even add a check to do nothing when it is called
while avic is already in target enable state.

Best regards,
	Maxim Levitsky

