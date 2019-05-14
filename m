Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F981E456
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 00:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfENWQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 18:16:49 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34713 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfENWQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 18:16:48 -0400
Received: by mail-qk1-f195.google.com with SMTP id j20so306279qke.1
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 15:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sGvgwbM8Qq7R+d/pXVInrNBNpxBHuLlypbYxdcSh0QQ=;
        b=U9HzuBAo2+ougdnIOsGzuV3CfabYNQPgKPZCf7VQ98DwGuDdOzEHvaVxHQE6MelcwG
         mTJMXdX0jqswuX+qhBLZbRrtydXubk9T7V6ZOObVERTkDGDd5liTsLOQKyMu2LS/fPrc
         3TLgoxa1meMQzUthc97bzBrEf2Xq3quEVDrt8gqHq7IbhmAVujv8uM+9+umaXZWRz+3g
         m5CdyQmkS6QiNGomShY/AnTEqRbkAPTTE14PmICkKnNyQ5U56rfiXSJ+qwALocaKcdQ/
         edtdHb5hYndmxGUr47L0cYhhTBw6QmoGBCmaNAVlixtC37vNFO4HRJogDcZp8RaXW4IW
         v5Vw==
X-Gm-Message-State: APjAAAVUJNi4j9mwqCiX/9hPBquLHWkpkToBJEsBuHxsLJUH+9T7ZJuh
        Wm7mh0PsArgG8s5EQQpUCJpVWA==
X-Google-Smtp-Source: APXvYqzxwTTzn51KbxxNaAzyv/pkJUV1ke6okBZa0i2lA3TII6YFz3jTQ7gK0oYDoqLv2xlrm4e0cA==
X-Received: by 2002:ae9:e806:: with SMTP id a6mr14184171qkg.247.1557872207417;
        Tue, 14 May 2019 15:16:47 -0700 (PDT)
Received: from redhat.com ([185.54.206.10])
        by smtp.gmail.com with ESMTPSA id t6sm41702qkt.25.2019.05.14.15.16.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 14 May 2019 15:16:46 -0700 (PDT)
Date:   Tue, 14 May 2019 18:16:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH net] vhost: don't use kmap() to log dirty pages
Message-ID: <20190514181150-mutt-send-email-mst@kernel.org>
References: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557725265-63525-1-git-send-email-jasowang@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 01:27:45AM -0400, Jason Wang wrote:
> Vhost log dirty pages directly to a userspace bitmap through GUP and
> kmap_atomic() since kernel doesn't have a set_bit_to_user()
> helper. This will cause issues for the arch that has virtually tagged
> caches. The way to fix is to keep using userspace virtual
> address. Fortunately, futex has arch_futex_atomic_op_inuser() which
> could be used for setting a bit to user.
> 
> Note there're several cases that futex helper can fail e.g a page
> fault or the arch that doesn't have the support. For those cases, a
> simplified get_user()/put_user() pair protected by a global mutex is
> provided as a fallback. The fallback may lead false positive that
> userspace may see more dirty pages.
> 
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Darren Hart <dvhart@infradead.org>
> Fixes: 3a4d5c94e9593 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from RFC V2:
> - drop GUP and provide get_user()/put_user() fallbacks
> - round down log_base
> Changes from RFC V1:
> - switch to use arch_futex_atomic_op_inuser()
> ---
>  drivers/vhost/vhost.c | 54 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 351af88..7fa05ba 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -31,6 +31,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/interval_tree_generic.h>
>  #include <linux/nospec.h>
> +#include <asm/futex.h>
>  
>  #include "vhost.h"
>  
> @@ -43,6 +44,8 @@
>  MODULE_PARM_DESC(max_iotlb_entries,
>  	"Maximum number of iotlb entries. (default: 2048)");
>  
> +static DEFINE_MUTEX(vhost_log_lock);
> +
>  enum {
>  	VHOST_MEMORY_F_LOG = 0x1,
>  };
> @@ -1692,28 +1695,31 @@ long vhost_dev_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp)
>  }
>  EXPORT_SYMBOL_GPL(vhost_dev_ioctl);
>  
> -/* TODO: This is really inefficient.  We need something like get_user()
> - * (instruction directly accesses the data, with an exception table entry
> - * returning -EFAULT). See Documentation/x86/exception-tables.txt.
> - */
> -static int set_bit_to_user(int nr, void __user *addr)
> +static int set_bit_to_user(int nr, u32 __user *addr)
>  {
> -	unsigned long log = (unsigned long)addr;
> -	struct page *page;
> -	void *base;
> -	int bit = nr + (log % PAGE_SIZE) * 8;
> +	u32 old;
>  	int r;
>  
> -	r = get_user_pages_fast(log, 1, 1, &page);
> -	if (r < 0)
> -		return r;
> -	BUG_ON(r != 1);
> -	base = kmap_atomic(page);
> -	set_bit(bit, base);
> -	kunmap_atomic(base);
> -	set_page_dirty_lock(page);
> -	put_page(page);
> +	r = arch_futex_atomic_op_inuser(FUTEX_OP_OR, 1 << nr, &old, addr);
> +	if (r) {
> +		/* Fallback through get_user()/put_user(), this may
> +		 * lead false positive that userspace may see more
> +		 * dirty pages. A mutex is used to synchronize log
> +		 * access between vhost threads.
> +		 */
> +		mutex_lock(&vhost_log_lock);
> +		r = get_user(old, addr);
> +		if (r)
> +			goto err;
> +		r = put_user(old | 1 << nr, addr);
> +		if (r)
> +			goto err;
> +		mutex_unlock(&vhost_log_lock);
> +	}

Problem is, we always said it's atomic.

This trick will work if userspace only clears bits
in the log, but won't if it sets bits in the log.
E.g. reusing the log structure for vhost-user
will have exactly this effect.




>  	return 0;
> +err:
> +	mutex_unlock(&vhost_log_lock);
> +	return r;
>  }
>  
>  static int log_write(void __user *log_base,
> @@ -1725,13 +1731,13 @@ static int log_write(void __user *log_base,
>  	if (!write_length)
>  		return 0;
>  	write_length += write_address % VHOST_PAGE_SIZE;
> +	log_base = (void __user *)((u64)log_base & ~0x3ULL);
> +	write_page += ((u64)log_base & 0x3ULL) * 8;
>  	for (;;) {
> -		u64 base = (u64)(unsigned long)log_base;
> -		u64 log = base + write_page / 8;
> -		int bit = write_page % 8;
> -		if ((u64)(unsigned long)log != log)
> -			return -EFAULT;
> -		r = set_bit_to_user(bit, (void __user *)(unsigned long)log);
> +		u32 __user *log = (u32 __user *)log_base + write_page / 32;
> +		int bit = write_page % 32;
> +
> +		r = set_bit_to_user(bit, log);
>  		if (r < 0)
>  			return r;
>  		if (write_length <= VHOST_PAGE_SIZE)
> -- 
> 1.8.3.1
