Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6433526A1B0
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgIOJIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:08:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35022 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726208AbgIOJII (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 05:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600160881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RaRr1rkKL0I9rBWtqad9Dv8rz6pmc1o4Jibb7XjUX0=;
        b=WQRTLRgkv7aGS28JitrX/cTrjee03e6ctGrNWbfweiGlYYe5cBmWKBYEVvAx16Vz1ZzF+X
        DPSNsMLyVYvMRaiRQc7u/Rfx7Eix6hB+tr6UC8IpaBFX0k5gNeXMFeV8G3oNmoZO9HsVGy
        /HlSNQMSsqZergccS+eYhX3NPlX9Psc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-45ZhZMqrOEitsyteJeWAGg-1; Tue, 15 Sep 2020 05:08:00 -0400
X-MC-Unique: 45ZhZMqrOEitsyteJeWAGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AD6B640B3;
        Tue, 15 Sep 2020 09:07:57 +0000 (UTC)
Received: from starship (unknown [10.35.207.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 061AB5DE82;
        Tue, 15 Sep 2020 09:07:33 +0000 (UTC)
Message-ID: <922e825c090892f22d40a469fef229d62f40af5e.camel@redhat.com>
Subject: Re: [PATCH] SVM: nSVM: fix resource leak on error path
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 15 Sep 2020 12:07:25 +0300
In-Reply-To: <20200914194557.10158-1-alex.dewar90@gmail.com>
References: <20200914194557.10158-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-14 at 20:45 +0100, Alex Dewar wrote:
> In svm_set_nested_state(), if nested_svm_vmrun_msrpm() returns false,
> then variables save and ctl will leak. Fix this.
> 
> Fixes: 772b81bb2f9b ("SVM: nSVM: setup nested msr permission bitmap on nested state load")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 598a769f1961..85f572cbabe4 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1148,7 +1148,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	nested_prepare_vmcb_control(svm);
>  
>  	if (!nested_svm_vmrun_msrpm(svm))
> -		return -EINVAL;
> +		goto out_free;	/* ret == -EINVAL */
>  
>  out_set_gif:
>  	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));

I think that this patch is based on unmerged patch, since I don't see
any memory allocation in nested_svm_vmrun_msrpm, nor out_free label.
in nether kvm/master, kvm/queue nor in upstream/master

If I recall correctly that would be something about allocating ctrl/save
dynamically rather than on stack.

Best regards,
	Maxim Levitsky

