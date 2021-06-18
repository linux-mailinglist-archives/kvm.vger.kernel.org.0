Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53753AC984
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbhFRLMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 07:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233730AbhFRLMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 07:12:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140726102A;
        Fri, 18 Jun 2021 11:10:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1luCOG-008QHB-VZ; Fri, 18 Jun 2021 12:10:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Jun 2021 12:10:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     "wangyanan (Y)" <wangyanan55@huawei.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance
 callbacks
In-Reply-To: <CA+EHjTyW+LP=UmwDP+egbPzpz2vxFpbOMgXi=dOt15j8wfLxWg@mail.gmail.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-2-wangyanan55@huawei.com>
 <20210617123837.GA24457@willie-the-truck> <87eed0d13p.wl-maz@kernel.org>
 <2c1b9376-3997-aa7b-d5f3-b04da985c260@huawei.com>
 <CA+EHjTyW+LP=UmwDP+egbPzpz2vxFpbOMgXi=dOt15j8wfLxWg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <be5a0a995d01d23898dc649eaa82ff49@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tabba@google.com, wangyanan55@huawei.com, will@kernel.org, kvm@vger.kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-06-18 09:59, Fuad Tabba wrote:
> Hi,
> 
> On Fri, Jun 18, 2021 at 2:52 AM wangyanan (Y) <wangyanan55@huawei.com> 
> wrote:
>> 
>> 
>> 
>> On 2021/6/17 22:20, Marc Zyngier wrote:
>> > On Thu, 17 Jun 2021 13:38:37 +0100,
>> > Will Deacon <will@kernel.org> wrote:
>> >> On Thu, Jun 17, 2021 at 06:58:21PM +0800, Yanan Wang wrote:
>> >>> To prepare for performing CMOs for guest stage-2 in the fault handlers
>> >>> in pgtable.c, here introduce two cache maintenance callbacks in struct
>> >>> kvm_pgtable_mm_ops. We also adjust the comment alignment for the
>> >>> existing part but make no real content change at all.
>> >>>
>> >>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> >>> ---
>> >>>   arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
>> >>>   1 file changed, 25 insertions(+), 17 deletions(-)
>> >>>
>> >>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> >>> index c3674c47d48c..b6ce34aa44bb 100644
>> >>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> >>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> >>> @@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
>> >>>
>> >>>   /**
>> >>>    * struct kvm_pgtable_mm_ops - Memory management callbacks.
>> >>> - * @zalloc_page:   Allocate a single zeroed memory page. The @arg parameter
>> >>> - *                 can be used by the walker to pass a memcache. The
>> >>> - *                 initial refcount of the page is 1.
>> >>> - * @zalloc_pages_exact:    Allocate an exact number of zeroed memory pages. The
>> >>> - *                 @size parameter is in bytes, and is rounded-up to the
>> >>> - *                 next page boundary. The resulting allocation is
>> >>> - *                 physically contiguous.
>> >>> - * @free_pages_exact:      Free an exact number of memory pages previously
>> >>> - *                 allocated by zalloc_pages_exact.
>> >>> - * @get_page:              Increment the refcount on a page.
>> >>> - * @put_page:              Decrement the refcount on a page. When the refcount
>> >>> - *                 reaches 0 the page is automatically freed.
>> >>> - * @page_count:            Return the refcount of a page.
>> >>> - * @phys_to_virt:  Convert a physical address into a virtual address mapped
>> >>> - *                 in the current context.
>> >>> - * @virt_to_phys:  Convert a virtual address mapped in the current context
>> >>> - *                 into a physical address.
>> >>> + * @zalloc_page:           Allocate a single zeroed memory page.
>> >>> + *                         The @arg parameter can be used by the walker
>> >>> + *                         to pass a memcache. The initial refcount of
>> >>> + *                         the page is 1.
>> >>> + * @zalloc_pages_exact:            Allocate an exact number of zeroed memory pages.
>> >>> + *                         The @size parameter is in bytes, and is rounded
>> >>> + *                         up to the next page boundary. The resulting
>> >>> + *                         allocation is physically contiguous.
>> >>> + * @free_pages_exact:              Free an exact number of memory pages previously
>> >>> + *                         allocated by zalloc_pages_exact.
>> >>> + * @get_page:                      Increment the refcount on a page.
>> >>> + * @put_page:                      Decrement the refcount on a page. When the
>> >>> + *                         refcount reaches 0 the page is automatically
>> >>> + *                         freed.
>> >>> + * @page_count:                    Return the refcount of a page.
>> >>> + * @phys_to_virt:          Convert a physical address into a virtual address
>> >>> + *                         mapped in the current context.
>> >>> + * @virt_to_phys:          Convert a virtual address mapped in the current
>> >>> + *                         context into a physical address.
>> >>> + * @clean_invalidate_dcache:       Clean and invalidate the data cache for the
>> >>> + *                         specified memory address range.
>> >> This should probably be explicit about whether this to the PoU/PoC/PoP.
>> > Indeed. I can fix that locally if there is nothing else that requires
>> > adjusting.
>> Will be grateful !
> 
> Sorry, I missed the v7 update. One comment here is that the naming
> used in the patch series I mentioned shortens invalidate to inval (if
> you want it to be less of a mouthful):
> https://lore.kernel.org/linux-arm-kernel/20210524083001.2586635-19-tabba@google.com/
> 

OK, I've now aligned these callbacks to Fuad's naming:

[...]

  * @dcache_clean_inval_poc:	Clean and invalidate the data cache to the 
PoC
  *				for the	specified memory address range.
  * @icache_inval_pou:		Invalidate the instruction cache to the PoU
  *				for the specified memory address range.
  */
struct kvm_pgtable_mm_ops {
	void*		(*zalloc_page)(void *arg);
	void*		(*zalloc_pages_exact)(size_t size);
	void		(*free_pages_exact)(void *addr, size_t size);
	void		(*get_page)(void *addr);
	void		(*put_page)(void *addr);
	int		(*page_count)(void *addr);
	void*		(*phys_to_virt)(phys_addr_t phys);
	phys_addr_t	(*virt_to_phys)(void *addr);
	void		(*dcache_clean_inval_poc)(void *addr, size_t size);
	void		(*icache_inval_pou)(void *addr, size_t size);
};

and repainted everything else.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
