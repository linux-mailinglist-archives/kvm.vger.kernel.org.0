Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01480473F0A
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 10:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhLNJM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 04:12:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhLNJMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 04:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639473174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4SY60fvUC1aUPe7N3adn2XIf3PkiRQreUPZMYOK4fGA=;
        b=P0rHIFY7QuPhMiXStDVfRZy30rdjaM9C4yzLgf3kK/JKYf/BVKznc3vNSWolkeaXi+a1nX
        G2VGvikl7ecbweOtTaCHo5eGy975yPvJKZoVEUntVbNcV8qssgITy+0G2eyfIL55s0j2Db
        4C1+ttthRQjCPLr3RyT8jHtxmR7JRF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-w8lUoGQMNOeXOnHeUW-z3w-1; Tue, 14 Dec 2021 04:12:51 -0500
X-MC-Unique: w8lUoGQMNOeXOnHeUW-z3w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E1351927801;
        Tue, 14 Dec 2021 09:12:49 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 893AE5D6BA;
        Tue, 14 Dec 2021 09:12:46 +0000 (UTC)
Message-ID: <96c7c3c654481b650954ad12382ca28a6fc64a05.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: VMX: Fix stale docs for
 kvm-intel.emulate_invalid_guest_state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com
Date:   Tue, 14 Dec 2021 11:12:45 +0200
In-Reply-To: <20211207193006.120997-4-seanjc@google.com>
References: <20211207193006.120997-1-seanjc@google.com>
         <20211207193006.120997-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 19:30 +0000, Sean Christopherson wrote:
> Update the documentation for kvm-intel's emulate_invalid_guest_state to
> rectify the description of KVM's default behavior, and to document that
> the behavior and thus parameter only applies to L1.
> 
> Fixes: a27685c33acc ("KVM: VMX: Emulate invalid guest state by default")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 9725c546a0d4..fc34332c8d9a 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2413,8 +2413,12 @@
>  			Default is 1 (enabled)
>  
>  	kvm-intel.emulate_invalid_guest_state=
> -			[KVM,Intel] Enable emulation of invalid guest states
> -			Default is 0 (disabled)
> +			[KVM,Intel] Disable emulation of invalid guest state.
> +			Ignored if kvm-intel.enable_unrestricted_guest=1, as
> +			guest state is never invalid for unrestricted guests.
> +			This param doesn't apply to nested guests (L2), as KVM
> +			never emulates invalid L2 guest state.
> +			Default is 1 (enabled)
>  
>  	kvm-intel.flexpriority=
>  			[KVM,Intel] Disable FlexPriority feature (TPR shadow).
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

