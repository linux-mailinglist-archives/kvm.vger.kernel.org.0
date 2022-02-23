Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D96F4C189E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 17:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbiBWQda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 11:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbiBWQd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 11:33:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 769D04F47B
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 08:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645633979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eJFcVMvv6yQets9GHtEootWOFNlstKVit+WEDgtDqA8=;
        b=GwkIIkCyotnKLYkshTr7wdSrsIKuAG3Ocw016VsP6ePoloWluHd6me0OAnkDcs9rN6j1jj
        QX+aQORNhoWbsw6pZdplWXAx18uCgQLCN+FXxNFGszGlcb0vSY3OfF7gNYAi9qUwsOrGOg
        ioce9hUFvgk6knU9s6kwZLgTGa7TFNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-k7jpMBl1Psy5uqDeQ85eJQ-1; Wed, 23 Feb 2022 11:32:56 -0500
X-MC-Unique: k7jpMBl1Psy5uqDeQ85eJQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D15B801AAD;
        Wed, 23 Feb 2022 16:32:55 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D65DB2ED8D;
        Wed, 23 Feb 2022 16:32:53 +0000 (UTC)
Message-ID: <7f18cfd048609276cc298dbfa01628bd2fa15937.camel@redhat.com>
Subject: Re: [PATCH v2 12/18] KVM: x86/mmu: clear MMIO cache when unloading
 the MMU
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 18:32:52 +0200
In-Reply-To: <20220217210340.312449-13-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-13-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> For cleanliness, do not leave a stale GVA in the cache after all the roots are
> cleared.  In practice, kvm_mmu_load will go through kvm_mmu_sync_roots if
> paging is on, and will not use vcpu_match_mmio_gva at all if paging is off.
> However, leaving data in the cache might cause bugs in the future.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b01160716c6a..4e8e3e9530ca 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5111,6 +5111,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
>  {
>  	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.root_mmu);
>  	__kvm_mmu_unload(vcpu->kvm, &vcpu->arch.guest_mmu);
> +	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  }
>  
>  static bool need_remote_flush(u64 old, u64 new)


One thing that bothers me for a while with all of this is that
vcpu->arch.{mmio_gva|mmio_access|mmio_gfn|mmio_gen} are often called mmio cache,
while we also install reserved bit SPTEs and also call this a mmio cache.

The above is basically a cache of a cache sort of.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

