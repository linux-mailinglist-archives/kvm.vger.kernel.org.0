Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604D04C152E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiBWONJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241433AbiBWONH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:13:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC55E88B12
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 06:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645625559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAjVPOU0N1F4du8mU5slitM9UdAudwFn2DQNF4c8ifE=;
        b=iX35Ph9ovnm71LyZwTNuUbbLOhetc+rSl+0fBZxrdlknDANgqfdbyIJfhD9WTwS3Y9AnjY
        O2Nl9nmDLTVp3CLSjemtH3k9rG4nTNbHPCrOvtDYmM6BwHRCLA2LtFcQnOstARaVJQG/22
        65mNeIzO2u68u9Lso4Ca/VrHUrYBhgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-WKlw5rJ2Mm6CTp1v8dnOoA-1; Wed, 23 Feb 2022 09:12:35 -0500
X-MC-Unique: WKlw5rJ2Mm6CTp1v8dnOoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B20A71091DA5;
        Wed, 23 Feb 2022 14:12:34 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A114866C6;
        Wed, 23 Feb 2022 14:12:33 +0000 (UTC)
Message-ID: <d7a8983bdcca7d8ab3d2d88dc6f07fdcc12cdc1d.camel@redhat.com>
Subject: Re: [PATCH v2 04/18] KVM: x86/mmu: avoid NULL-pointer dereference
 on page freeing bugs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 16:12:32 +0200
In-Reply-To: <20220217210340.312449-5-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-5-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> WARN and bail if KVM attempts to free a root that isn't backed by a shadow
> page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
> paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
> will be valid but won't be backed by a shadow page.  It's all too easy to
> blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
> crashing KVM and possibly the kernel.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a67071ac80f3..6ea423b00824 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3222,6 +3222,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  		return;
>  
>  	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>  
>  	if (is_tdp_mmu_page(sp))
>  		kvm_tdp_mmu_put_root(kvm, sp, false);



Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

