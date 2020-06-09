Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA81F34D9
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 09:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgFIHak (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 03:30:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33837 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726099AbgFIHah (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jun 2020 03:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591687835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=owPW4Yyn+vRG/I3e4tfWyQnRyiSow4wVMNxxjaVp++o=;
        b=fns7Jorz3uDnBL1cuAfLpaBW9XYbsJfalLvCL6nV2/fDRIeyDLzGSNGpHY1ECGq+P7lgFb
        1Kp4Gjm8yJBmRkxewmHrHvs+LoanRm9fV6XdwsEDON5W+bWuKSoKv4KsReJP9dGwNmSNVI
        MMKyyIvfwmQH/7nRebxosYPdxCOiP58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-OiftQ25pPvOPb7nkMQP-Fg-1; Tue, 09 Jun 2020 03:30:33 -0400
X-MC-Unique: OiftQ25pPvOPb7nkMQP-Fg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 708E6EC1AA;
        Tue,  9 Jun 2020 07:30:32 +0000 (UTC)
Received: from starship-rhel (unknown [10.35.206.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E26D5C1BD;
        Tue,  9 Jun 2020 07:30:29 +0000 (UTC)
Message-ID: <500129791dd00349acb5919d75fa9de7e0c112d1.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: fix calls to is_intercept
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Qian Cai <cai@lca.pw>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Tue, 09 Jun 2020 10:30:28 +0300
In-Reply-To: <87wo4hbu0q.fsf@vitty.brq.redhat.com>
References: <20200608121428.9214-1-pbonzini@redhat.com>
         <87wo4hbu0q.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-06-08 at 14:51 +0200, Vitaly Kuznetsov wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
> 
> > is_intercept takes an INTERCEPT_* constant, not SVM_EXIT_*; because
> > of this, the compiler was removing the body of the conditionals,
> > as if is_intercept returned 0.
> > 
> > This unveils a latent bug: when clearing the VINTR intercept,
> > int_ctl must also be changed in the L1 VMCB (svm->nested.hsave),
> > just like the intercept itself is also changed in the L1 VMCB.
> > Otherwise V_IRQ remains set and, due to the VINTR intercept being
> > clear,
> > we get a spurious injection of a vector 0 interrupt on the next
> > L2->L1 vmexit.
> > 
> > Reported-by: Qian Cai <cai@lca.pw>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> > 	Vitaly, can you give this a shot with Hyper-V?  I have already
> > 	placed it on kvm/queue, it passes both svm.flat and KVM-on-KVM
> > 	smoke tests.
> 
> Quickly smoke-tested this with WS2016/2019 BIOS/UEFI and the patch
> doesn't seem to break anything. I'm having issues trying to launch a
> Gen2 (UEFI) VM in Hyper-V (Gen1 works OK) but the behavior looks
> exactly
> the same pre- and post-patch.
> 

And if I understand correctly that bug didn't affect anything I tested
because your recent patches started to avoid the usage of the interrupt
window unless L1 clears the usage of the interrupt intercept which is
rare.

Looks correct to me, and I guess this could have being avoided have C
enforced the enumeration types.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky



