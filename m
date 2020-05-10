Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACB51CCAB8
	for <lists+kvm@lfdr.de>; Sun, 10 May 2020 14:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgEJMNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 May 2020 08:13:11 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54767 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728645AbgEJMNK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 10 May 2020 08:13:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589112789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qP/sxaANp1JY7bumO45mdIobp9ZW6EsO7vb9OqH2jFM=;
        b=M09fODKFt9rfQjK6laSNbYgg3E++kkevi0880vST1Oy6/D6+76jflEmF1zxJ65PNhgHvpR
        ncyoRVwmYFQCclI/8m0N5eZORGc1BupngcjJvht3NyJCnRKj5thxtz54mBLH/4uTp4lv2T
        ORissmH02F3shIOB0td4KQVmk7hSz/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-lcTXQcuvOVOjDDiNIm7p9w-1; Sun, 10 May 2020 08:13:03 -0400
X-MC-Unique: lcTXQcuvOVOjDDiNIm7p9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77E66460;
        Sun, 10 May 2020 12:13:02 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E4BA6AD10;
        Sun, 10 May 2020 12:13:00 +0000 (UTC)
Message-ID: <a221de5c2a823c508e09b664ce38db4e980e83d6.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: SVM: Disable AVIC before setting V_IRQ
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org, jon.grimm@amd.com
Date:   Sun, 10 May 2020 15:13:00 +0300
In-Reply-To: <793e7151-e14c-f254-7911-a4371ad635aa@redhat.com>
References: <1588818939-54264-1-git-send-email-suravee.suthikulpanit@amd.com>
         <793e7151-e14c-f254-7911-a4371ad635aa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-05-07 at 10:27 +0200, Paolo Bonzini wrote:
> On 07/05/20 04:35, Suravee Suthikulpanit wrote:
> > The commit 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window
> > while running L2 with V_INTR_MASKING=1") introduced a WARN_ON,
> > which checks if AVIC is enabled when trying to set V_IRQ
> > in the VMCB for enabling irq window.
> > 
> > The following warning is triggered because the requesting vcpu
> > (to deactivate AVIC) does not get to process APICv update request
> > for itself until the next #vmexit.
> > 
> > WARNING: CPU: 0 PID: 118232 at arch/x86/kvm/svm/svm.c:1372 enable_irq_window+0x6a/0xa0 [kvm_amd]
> >  RIP: 0010:enable_irq_window+0x6a/0xa0 [kvm_amd]
> >  Call Trace:
> >   kvm_arch_vcpu_ioctl_run+0x6e3/0x1b50 [kvm]
> >   ? kvm_vm_ioctl_irq_line+0x27/0x40 [kvm]
> >   ? _copy_to_user+0x26/0x30
> >   ? kvm_vm_ioctl+0xb3e/0xd90 [kvm]
> >   ? set_next_entity+0x78/0xc0
> >   kvm_vcpu_ioctl+0x236/0x610 [kvm]
> >   ksys_ioctl+0x8a/0xc0
> >   __x64_sys_ioctl+0x1a/0x20
> >   do_syscall_64+0x58/0x210
> >   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > 
> > Fixes by sending APICV update request to all other vcpus, and
> > immediately update APIC for itself.
> > 
> > Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > Link: https://lkml.org/lkml/2020/5/2/167
> > Fixes: 64b5bd270426 ("KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1")
> > ---
> >  arch/x86/kvm/x86.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index df473f9..69a01ea 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8085,6 +8085,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >   */
> >  void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
> >  {
> > +	struct kvm_vcpu *except;
> >  	unsigned long old, new, expected;
> >  
> >  	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
> > @@ -8110,7 +8111,17 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
> >  	trace_kvm_apicv_update_request(activate, bit);
> >  	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
> >  		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
> > -	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
> > +
> > +	/*
> > +	 * Sending request to update APICV for all other vcpus,
> > +	 * while update the calling vcpu immediately instead of
> > +	 * waiting for another #VMEXIT to handle the request.
> > +	 */
> > +	except = kvm_get_running_vcpu();
> > +	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
> > +					 except);
> > +	if (except)
> > +		kvm_vcpu_update_apicv(except);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
> >  
> > 
> 
> Queued, thanks.
> 
> Paolo
> 
I tested this patch today on top of kvm/queue,
the patch that add kvm_make_all_cpus_request_except and this patch
(the former patch needs slight adjustment to apply).

Best regards,
	Maxim Levitsky



