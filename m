Return-Path: <kvm+bounces-50572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2432BAE70FF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EC251BC02C7
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B592EACF2;
	Tue, 24 Jun 2025 20:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdnrfDP1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4193FB1B;
	Tue, 24 Jun 2025 20:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797900; cv=none; b=pYs7gQ2Tm8aeOj96e48umWuRX4mFE/VSiFmEWiGzT8Iht7/BBGTn8I9Br5ey1VPb04sIzk6R8hY7Ubc8LQEoSYB6P8deGctavrvMqT1jA1YQ4Iio5Nu/ieAitFfjEIioPsihj6eSV+3PH9RmN+9LVZdia+KYbuv6QEG09iwfPtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797900; c=relaxed/simple;
	bh=AoFPMCIxkttPg56+0un4riAb99bPvrJcXHuKXirc4kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8n4FQ+PTIjAD6taOMYxbl3zSjqh8jLajEoMHKfzWML4uTm3UG9fNFN2mGeMft8eUlZavbF526uO41CiZ+qLm5OBUgbZZIIKp79UxjIR6+As1ZwXCXWyy9Rf54Ea135nMxAg1an4e455TdN6IsYHYO/CWukWs4MxXBPNuF4SEK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdnrfDP1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D80C4CEE3;
	Tue, 24 Jun 2025 20:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750797900;
	bh=AoFPMCIxkttPg56+0un4riAb99bPvrJcXHuKXirc4kE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DdnrfDP1H9mNBSpD5Y2HOlveUi/wqHGE06OJbvGfgz9LAgedeeFvamygl27k74DLg
	 z3wshVBWK9q1KHtT53hcQNy9dVSFLbDWB+b+9NhOzwT0OUGYBC7oCWwGP66REdulcR
	 ExUvcH/dJKv6VUs1oqrteB9roCwoHyjNFixHjaKU0GQxtk+tEWDi7zPhYYlHYGwpRV
	 AH5Qtf0XvLBOODaXlYkMBtEnvZHCbEpwgTE9Ypyt8oY/tYQ86nWLr99rpX+B/BdOVD
	 m6cOd7LPHkd71mK4yhsI+SD46i8WHOe2lEHsrccjP1jJXfvEbmhSnBUZog9qwAK75k
	 p0hUTMnVqPt5Q==
Date: Tue, 24 Jun 2025 23:44:56 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: update architecture and driver code to use
 vm_flags_t
Message-ID: <aFsOSL8hht-ZojTC@kernel.org>
References: <cover.1750274467.git.lorenzo.stoakes@oracle.com>
 <b6eb1894abc5555ece80bb08af5c022ef780c8bc.1750274467.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6eb1894abc5555ece80bb08af5c022ef780c8bc.1750274467.git.lorenzo.stoakes@oracle.com>

On Wed, Jun 18, 2025 at 08:42:54PM +0100, Lorenzo Stoakes wrote:
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -279,7 +279,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
>  
>  static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
>  						       unsigned long addr,
> -						       unsigned long vm_flags)
> +						       vm_flags_t vm_flags)
>  {
>  	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
>  	struct sgx_encl_page *entry;
> @@ -520,9 +520,9 @@ static void sgx_vma_open(struct vm_area_struct *vma)
>   * Return: 0 on success, -EACCES otherwise
>   */
>  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> -		     unsigned long end, unsigned long vm_flags)
> +		     unsigned long end, vm_flags_t vm_flags)
>  {
> -	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
> +	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
>  	struct sgx_encl_page *page;
>  	unsigned long count = 0;
>  	int ret = 0;
> @@ -605,7 +605,7 @@ static int sgx_encl_debug_write(struct sgx_encl *encl, struct sgx_encl_page *pag
>   */
>  static struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
>  						   unsigned long addr,
> -						   unsigned long vm_flags)
> +						   vm_flags_t vm_flags)
>  {
>  	struct sgx_encl_page *entry;
>  
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index f94ff14c9486..8ff47f6652b9 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -101,7 +101,7 @@ static inline int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
>  }
>  
>  int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> -		     unsigned long end, unsigned long vm_flags);
> +		     unsigned long end, vm_flags_t vm_flags);
>  
>  bool current_is_ksgxd(void);
>  void sgx_encl_release(struct kref *ref);
 
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

