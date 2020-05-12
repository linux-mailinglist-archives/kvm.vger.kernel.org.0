Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5693A1CF91E
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 17:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgELP1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 11:27:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32674 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgELP1T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 11:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589297237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2u1XARVde3VI73bLUwqMi18VBBkfQgX36y/WO8y170=;
        b=PKFIa+ch06aVrl6kcdgKKKavxydD7/nNNS+M8QNJ/cuEtc2jpAoupCxaWoyhzjFh2PSF1A
        1eEq33Hm/tr+WqGAWirX1XQ4V6tuBg5p/1VX7JDxl0RBOuZt1Qez7UsO7BYgwa6J0yg8ak
        Txildd3cEFvl48bMgNfhf3MNXuCud0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-9oudkDtfNJGhHr-5Zc_JBA-1; Tue, 12 May 2020 11:27:12 -0400
X-MC-Unique: 9oudkDtfNJGhHr-5Zc_JBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEB42107ACCA;
        Tue, 12 May 2020 15:27:10 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5830663F8F;
        Tue, 12 May 2020 15:27:10 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id C2B03220C05; Tue, 12 May 2020 11:27:09 -0400 (EDT)
Date:   Tue, 12 May 2020 11:27:09 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
Message-ID: <20200512152709.GB138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-3-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511164752.2158645-3-vkuznets@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 11, 2020 at 06:47:46PM +0200, Vitaly Kuznetsov wrote:
> Currently, APF mechanism relies on the #PF abuse where the token is being
> passed through CR2. If we switch to using interrupts to deliver page-ready
> notifications we need a different way to pass the data. Extent the existing
> 'struct kvm_vcpu_pv_apf_data' with token information for page-ready
> notifications.
> 
> The newly introduced apf_put_user_ready() temporary puts both reason
> and token information, this will be changed to put token only when we
> switch to interrupt based notifications.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>  arch/x86/kvm/x86.c                   | 17 +++++++++++++----
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..e3602a1de136 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
>  
>  struct kvm_vcpu_pv_apf_data {
>  	__u32 reason;
> -	__u8 pad[60];
> +	__u32 pageready_token;

How about naming this just "token". That will allow me to deliver error
as well. pageready_token name seems to imply that this will always be
successful with page being ready.

And reason will tell whether page could successfully be ready or
it was an error. And token will help us identify the task which
is waiting for the event.

Thanks
Vivek

