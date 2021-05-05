Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40310373636
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhEEIZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:25:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58543 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEIZU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620203064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BGsu3FEFRIesmc2ErwraLa3SbQ5oDTNKTYIfbpQOouA=;
        b=Vwy+yoJcocL6KZUASZ6ZeyFPP1B8WMSYxgGtGECz0GeIhX2Q/dE0qqBgHTPg3SQuli90hi
        C2IXnEFIgVZHBMIVrt9Cu38ai9tvCK0CSNDL5q7wfxhe7d+DVpTkjJeu+4ER6dXcJC4VFk
        +P4uN1VtB6nibw5MSvlY91fYZf8s7ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-1t92TdhMNrWMziXgyKVJKA-1; Wed, 05 May 2021 04:24:22 -0400
X-MC-Unique: 1t92TdhMNrWMziXgyKVJKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6F7D6D4F3;
        Wed,  5 May 2021 08:24:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B05E5D9D5;
        Wed,  5 May 2021 08:24:19 +0000 (UTC)
Message-ID: <ff72dc0172cfdef228e63d766cb37e417cc4334d.camel@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Properly pad 'struct
 kvm_vmx_nested_state_hdr'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Date:   Wed, 05 May 2021 11:24:18 +0300
In-Reply-To: <20210503150854.1144255-3-vkuznets@redhat.com>
References: <20210503150854.1144255-1-vkuznets@redhat.com>
         <20210503150854.1144255-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-05-03 at 17:08 +0200, Vitaly Kuznetsov wrote:
> Eliminate the probably unwanted hole in 'struct kvm_vmx_nested_state_hdr':
> 
> Pre-patch:
> struct kvm_vmx_nested_state_hdr {
>         __u64                      vmxon_pa;             /*     0     8 */
>         __u64                      vmcs12_pa;            /*     8     8 */
>         struct {
>                 __u16              flags;                /*    16     2 */
>         } smm;                                           /*    16     2 */
> 
>         /* XXX 2 bytes hole, try to pack */
> 
>         __u32                      flags;                /*    20     4 */
>         __u64                      preemption_timer_deadline; /*    24     8 */
> };
> 
> Post-patch:
> struct kvm_vmx_nested_state_hdr {
>         __u64                      vmxon_pa;             /*     0     8 */
>         __u64                      vmcs12_pa;            /*     8     8 */
>         struct {
>                 __u16              flags;                /*    16     2 */
>         } smm;                                           /*    16     2 */
>         __u16                      pad;                  /*    18     2 */
>         __u32                      flags;                /*    20     4 */
>         __u64                      preemption_timer_deadline; /*    24     8 */
> };
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 5a3022c8af82..0662f644aad9 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -437,6 +437,8 @@ struct kvm_vmx_nested_state_hdr {
>  		__u16 flags;
>  	} smm;
>  
> +	__u16 pad;
> +
>  	__u32 flags;
>  	__u64 preemption_timer_deadline;
>  };


Looks good to me.

I wonder if we can enable the -Wpadded GCC warning to warn about such cases.
Probably can't be enabled for the whole kernel but maybe we can enable it
for KVM codebase at least, like we did with -Werror.


From GCC manual:

"-Wpadded
Warn if padding is included in a structure, either to align an element of the structure or to align the whole structure. 
Sometimes when this happens it is possible to rearrange the fields of the structure 
to reduce the padding and so make the structure smaller."


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


