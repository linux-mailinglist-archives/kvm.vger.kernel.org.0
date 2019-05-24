Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E078529FCD
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404188AbfEXUYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 16:24:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403762AbfEXUYk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 16:24:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DD832AD47;
        Fri, 24 May 2019 20:24:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7C4A6E00A9; Fri, 24 May 2019 22:24:38 +0200 (CEST)
Date:   Fri, 24 May 2019 22:24:38 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: fix compilation on s390
Message-ID: <20190524202438.GE30439@unicorn.suse.cz>
References: <1558725957-22998-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558725957-22998-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 24, 2019 at 09:25:57PM +0200, Paolo Bonzini wrote:
> s390 does not have memremap, even though in this particular case it
> would be useful.

This is not completely true: memremap() is built when HAS_IOMEM is
defined which on s390 depends on CONFIG_PCI. So for "normal" configs
HAS_IOMEM would be enabled and memremap() would be available. We only
encountered the build error with a special minimal config for zfcpdump.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1fadfb9cf36e..134ec0283a8a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1761,8 +1761,10 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
>  	if (pfn_valid(pfn)) {
>  		page = pfn_to_page(pfn);
>  		hva = kmap(page);
> +#ifdef CONFIG_HAS_IOMEM
>  	} else {
>  		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
> +#endif
>  	}
>  
>  	if (!hva)
> -- 
> 1.8.3.1

I would have to run a test build to be sure but IMHO you will also need
to handle the memunmap() call in kvm_vcpu_unmap().

Michal Kubecek
