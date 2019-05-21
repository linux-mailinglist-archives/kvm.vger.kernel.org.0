Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D239A247AD
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 07:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfEUFx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 May 2019 01:53:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:48878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725794AbfEUFx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 May 2019 01:53:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9527AEEE;
        Tue, 21 May 2019 05:53:27 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 6607FE0184; Tue, 21 May 2019 07:53:27 +0200 (CEST)
Date:   Tue, 21 May 2019 07:53:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Radim Krcmar <rkrcmar@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] kvm: make kvm_vcpu_(un)map dependency on
 CONFIG_HAS_IOMEM explicit
Message-ID: <20190521055327.GD25473@unicorn.suse.cz>
References: <20190520164418.06D1CE0184@unicorn.suse.cz>
 <41adfaf7-90e8-b011-2716-ea5dc464ae5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41adfaf7-90e8-b011-2716-ea5dc464ae5a@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 07:23:43PM +0200, Paolo Bonzini wrote:
> On 20/05/19 18:44, Michal Kubecek wrote:
> > Recently introduced functions kvm_vcpu_map() and kvm_vcpu_unmap() call
> > memremap() and memunmap() which are only available if HAS_IOMEM is enabled
> > but this dependency is not explicit, so that the build fails with HAS_IOMEM
> > disabled.
> > 
> > As both function are only used on x86 where HAS_IOMEM is always enabled,
> > the easiest fix seems to be to only provide them when HAS_IOMEM is enabled.
> > 
> > Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> > ---
> 
> Thank you very much.  However, it's better if only the memremap part is
> hidden behind CONFIG_HAS_IOMEM.  I'll send a patch tomorrow and have it
> reach Linus at most on Wednesday.

That sounds like a better solution. As I'm not familiar with the code,
I didn't want to risk and suggested the easiest way around.

Michal

> There is actually nothing specific to CONFIG_HAS_IOMEM in them,
> basically the functionality we want is remap_pfn_range but without a
> VMA.  However, it's for a niche use case where KVM guest memory is
> mmap-ed from /dev/mem and it's okay if for now that part remains
> disabled on s390.
> 
> Paolo
