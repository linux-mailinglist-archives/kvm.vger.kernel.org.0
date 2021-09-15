Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFAE40C667
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 15:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhION3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 09:29:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:11289 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233467AbhION3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 09:29:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="222359755"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="222359755"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 06:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="472399199"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.192.135])
  by orsmga007.jf.intel.com with ESMTP; 15 Sep 2021 06:28:11 -0700
Date:   Wed, 15 Sep 2021 19:58:57 +0000
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210915195857.GA52522@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
 <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 10, 2021 at 08:18:11PM +0300, Kirill A. Shutemov wrote:
> On Fri, Sep 03, 2021 at 12:15:51PM -0700, Andy Lutomirski wrote:
> > On 9/3/21 12:14 PM, Kirill A. Shutemov wrote:
> > > On Thu, Sep 02, 2021 at 08:33:31PM +0000, Sean Christopherson wrote:
> > >> Would requiring the size to be '0' at F_SEAL_GUEST time solve that problem?
> > > 
> > > I guess. Maybe we would need a WRITE_ONCE() on set. I donno. I will look
> > > closer into locking next.
> > 
> > We can decisively eliminate this sort of failure by making the switch
> > happen at open time instead of after.  For a memfd-like API, this would
> > be straightforward.  For a filesystem, it would take a bit more thought.
> 
> I think it should work fine as long as we check seals after i_size in the
> read path. See the comment in shmem_file_read_iter().
> 
> Below is updated version. I think it should be good enough to start
> integrate with KVM.
> 
> I also attach a test-case that consists of kernel patch and userspace
> program. It demonstrates how it can be integrated into KVM code.
> 
> One caveat I noticed is that guest_ops::invalidate_page_range() can be
> called after the owner (struct kvm) has being freed. It happens because
> memfd can outlive KVM. So the callback has to check if such owner exists,
> than check that there's a memslot with such inode.

Would introducing memfd_unregister_guest() fix this?

> 
> I guess it should be okay: we have vm_list we can check owner against.
> We may consider replace vm_list with something more scalable if number of
> VMs will get too high.
> 
> Any comments?
> 
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index 4f1600413f91..3005e233140a 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -4,13 +4,34 @@
>  
>  #include <linux/file.h>
>  
> +struct guest_ops {
> +	void (*invalidate_page_range)(struct inode *inode, void *owner,
> +				      pgoff_t start, pgoff_t end);
> +};

I can see there are two scenarios to invalidate page(s), when punching a
hole or ftruncating to 0, in either cases KVM should already been called
with necessary information from usersapce with memory slot punch hole
syscall or memory slot delete syscall, so wondering this callback is
really needed.

> +
> +struct guest_mem_ops {
> +	unsigned long (*get_lock_pfn)(struct inode *inode, pgoff_t offset);
> +	void (*put_unlock_pfn)(unsigned long pfn);

Same as above, I¡¯m not clear on which time put_unlock_pfn() would be
called, I¡¯m thinking the page can be put_and_unlock when userspace
punching a hole or ftruncating to 0 on the fd.

We did miss pfn_mapping_level() callback which is needed for KVM to query
the page size level (e.g. 4K or 2M) that the backing store can support.

> +
> +};
> +
>  #ifdef CONFIG_MEMFD_CREATE
>  extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
> +
> +extern inline int memfd_register_guest(struct inode *inode, void *owner,
> +				       const struct guest_ops *guest_ops,
> +				       const struct guest_mem_ops **guest_mem_ops);
>  #else
>  static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
>  {
>  	return -EINVAL;
>  }
> +static inline int memfd_register_guest(struct inode *inode, void *owner,
> +				       const struct guest_ops *guest_ops,
> +				       const struct guest_mem_ops **guest_mem_ops)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #endif /* __LINUX_MEMFD_H */
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 8e775ce517bb..265d0c13bc5e 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -12,6 +12,9 @@
>  
>  /* inode in-kernel data */
>  
> +struct guest_ops;
> +struct guest_mem_ops;
> +
>  struct shmem_inode_info {
>  	spinlock_t		lock;
>  	unsigned int		seals;		/* shmem seals */
> @@ -24,6 +27,8 @@ struct shmem_inode_info {
>  	struct simple_xattrs	xattrs;		/* list of xattrs */
>  	atomic_t		stop_eviction;	/* hold when working on inode */
>  	struct inode		vfs_inode;
> +	void			*guest_owner;
> +	const struct guest_ops	*guest_ops;
>  };
>  
>  struct shmem_sb_info {
> @@ -90,6 +95,10 @@ extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
>  extern unsigned long shmem_partial_swap_usage(struct address_space *mapping,
>  						pgoff_t start, pgoff_t end);
>  
> +extern int shmem_register_guest(struct inode *inode, void *owner,
> +				const struct guest_ops *guest_ops,
> +				const struct guest_mem_ops **guest_mem_ops);
> +
>  /* Flag allocation requirements to shmem_getpage */
>  enum sgp_type {
>  	SGP_READ,	/* don't exceed i_size, don't allocate page */
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 2f86b2ad6d7e..c79bc8572721 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -43,6 +43,7 @@
>  #define F_SEAL_GROW	0x0004	/* prevent file from growing */
>  #define F_SEAL_WRITE	0x0008	/* prevent writes */
>  #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
> +#define F_SEAL_GUEST		0x0020
>  /* (1U << 31) is reserved for signed error codes */
>  
>  /*
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 081dd33e6a61..ae43454789f4 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -130,11 +130,24 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
>  	return NULL;
>  }
>  
> +int memfd_register_guest(struct inode *inode, void *owner,
> +			 const struct guest_ops *guest_ops,
> +			 const struct guest_mem_ops **guest_mem_ops)
> +{
> +	if (shmem_mapping(inode->i_mapping)) {
> +		return shmem_register_guest(inode, owner,
> +					    guest_ops, guest_mem_ops);
> +	}
> +
> +	return -EINVAL;
> +}

Are we stick our design to memfd interface (e.g other memory backing
stores like tmpfs and hugetlbfs will all rely on this memfd interface to
interact with KVM), or this is just the initial implementation for PoC?

If we really want to expose multiple memory backing stores directly to
KVM (as opposed to expose backing stores to memfd and then memfd expose
single interface to KVM), I feel we need a third layer between KVM and
backing stores to eliminate the direct call like this. Backing stores
can register ¡®memory fd providers¡¯ and KVM should be able to connect to
the right backing store provider with the fd provided by usersapce under
the help of this third layer.

Thanks,
Chao
