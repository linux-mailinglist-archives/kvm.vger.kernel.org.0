Return-Path: <kvm+bounces-60894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70304C0251F
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D84B4189BBE4
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 16:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239FE279903;
	Thu, 23 Oct 2025 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k1pwrSbl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65F2272E51
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 16:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761235677; cv=none; b=hk8CNgdq27p7A4N3KGkNv5oqst+X4QngkVAYhtozMvfx2o22Egz7bNWcu3q2PDf0W1yEcIsBXhd+8eEnqYiR7KD5cotQfHD0F+fmuic2xOkQN04ikHa1T/tgfNnYSDUyF3LGOf3Vvfk/Prm/LrFZgNV+NLsT/Zi6TfTOWWEJO6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761235677; c=relaxed/simple;
	bh=1nVKA7foUkRSyS9Wrqb+5MZp+cy2gWR48rPSz2xIT74=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TTFtgF+NROJ4PIxcJQ/sMEFGkVmcT1WK/NmM4i4IWOP4Q5+qZkouXvexS1NwxvR3zO1zNrPpZQPkY3/RTQkdIdGWk5naWXBRBxU0L2EKsx5vUpSWfKizlxMQ424/HcJCRVXR5md/Ze1BHRxRIL3cPPHN2rOn9Kf4uq/laXAmdBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k1pwrSbl; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6a33319cb6so748681a12.2
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 09:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761235675; x=1761840475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iw+RxJFrvLXotShsX3G3u/lNQNdh4+3g/W60yOnZyHo=;
        b=k1pwrSblX6uuqh7hx65iIw56Swxet+M2XtgT3ZB1JZVnp7+vByNEl6aCwrRDMQEBvG
         MSqpIuxF4BgByv/kYhv83XG9KVJ4wXpBecXuWrRPeorNk67BEMW7ABJfYLLPISYdwNeX
         k+OoxwxyKyTnOIpDcgejrSLpbWz46fUHUW52m/ALiNBa8xV8VGKW7EAGPFMgXnP6hdEV
         WFprarvXrINWZ1w2kSuxIRf7K+597XK54x4FiuCNFswneM8p+bzJq5xvjl/JUooItw/p
         gPHhgg8PAF2onNxpnAwVK+k5wga+Luot5147YsdKTj+k9pkQw2UDiqOjY2Gqf+xfvIcl
         caIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761235675; x=1761840475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iw+RxJFrvLXotShsX3G3u/lNQNdh4+3g/W60yOnZyHo=;
        b=TykRu9lafWsclezpCzOd6ZZeXds4Xu51pM8G6TvNoBrJQRgPnocolQiqeE9w17yM85
         pgIa+h0RtvUjEWwkqYrS0Wnb7pTDFiMJCczfsyMGgSAzbv9fpM8wYouAGXq7u0BXlE2P
         FzonA7H9NVdQn2xkmAyccfnGtZeH4xFEcV6xMWBvfnP4CSO98KEAtWQ0dkK5Wj5NTJt9
         lbMXYT1b8lUg4EKGduSnQFWJB/NQZZ29jgCD4jwxmktJstU5lh4rbziAkIpsil6dtO7d
         bCGfDZT5u/HqL0KcCh7P87DbzwJN1JOxXTU6PIgMx/tca67y6mFA0a4SBWV6EIkTnPuk
         x2Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUNgvMNVClM/UQs6FKmtKwnF/zOnCbvJwk/gDKsSerZq05gnHkimWf3ofmuovGf6kPw4OU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2VRI09o2WK7eEpGwscYpUBJmHq3mXZ4IFL8OYdtJic0SKKwSo
	NkSLxjbcTYxHVM6UDAFMZtBNorRgX0KtGbG12NGgs8qaoAFyqNWYA9S1ilyl7uT0NGc4/P8pF+O
	2c2L1vg==
X-Google-Smtp-Source: AGHT+IF6SU0i3VjzGwoS1hsfvvAoYKHCfX1teOWArnTGZGjyd5oKJzCEyV/9N1Mdqw+d1V9YcutI70FGQeE=
X-Received: from pjte14.prod.google.com ([2002:a17:90a:c20e:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c02:b0:32e:3686:830e
 with SMTP id 98e67ed59e1d1-33fafc1ce07mr4286914a91.23.1761235675127; Thu, 23
 Oct 2025 09:07:55 -0700 (PDT)
Date: Thu, 23 Oct 2025 09:07:53 -0700
In-Reply-To: <20251020161352.69257-2-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251020161352.69257-1-kalyazin@amazon.com> <20251020161352.69257-2-kalyazin@amazon.com>
Message-ID: <aPpS2aqdobVTk_ed@google.com>
Subject: Re: [PATCH v6 1/2] KVM: guest_memfd: add generic population via write
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Derek Manwaring <derekmn@amazon.com>, 
	Marco Cali <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 20, 2025, Nikita Kalyazin wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> write syscall populates guest_memfd with user-supplied data in a generic
> way, ie no vendor-specific preparation is performed.  If the request is
> not page-aligned, the remaining bytes are initialised to 0.
> 
> write is only supported for non-CoCo setups where guest memory is not
> hardware-encrypted.

Please include all of the "why".  The code mostly communicates the "what", but
it doesn't capture why write() support is at all interesting, nor does it explain
why read() isn't supported.

> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  virt/kvm/guest_memfd.c | 48 ++++++++++++++++++++++++++++++++++++++++++

There's a notable lack of uAPI and Documentation chanegs.  I.e. this needs a
GUEST_MEMFD_FLAG_xxx along with proper documentation.

And while it's definitely it's a-ok to land .write() in advance of the direct map
changes, we do need to at least map out how we want the two to interact, e.g. so
that we don't end up with constraints that are impossible to satisfy.

>  1 file changed, 48 insertions(+)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 94bafd6c558c..f4e218049afa 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -380,6 +380,8 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>  
>  static struct file_operations kvm_gmem_fops = {
>  	.mmap		= kvm_gmem_mmap,
> +	.llseek		= default_llseek,
> +	.write_iter     = generic_perform_write,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -390,6 +392,49 @@ void kvm_gmem_init(struct module *module)
>  	kvm_gmem_fops.owner = module;
>  }
>  
> +static int kvm_kmem_gmem_write_begin(const struct kiocb *kiocb,
> +				     struct address_space *mapping,
> +				     loff_t pos, unsigned int len,
> +				     struct folio **foliop,
> +				     void **fsdata)

Over-aggressive wrapping, this can be


static int kvm_kmem_gmem_write_begin(const struct kiocb *kiocb,
				     struct address_space *mapping, loff_t pos,
				     unsigned int len, struct folio **folio,
				     void **fsdata)

or

static int kvm_kmem_gmem_write_begin(const struct kiocb *kiocb,
				     struct address_space *mapping,
				     loff_t pos, unsigned int len,
				     struct folio **folio, void **fsdata)

if we want to bundle pos+len.

> +{
> +	struct file *file = kiocb->ki_filp;

ki_filp is already a file, and even if it were a "void *", there's no need for a
local variable.

> +	struct inode *inode = file_inode(file);
> +	pgoff_t index = pos >> PAGE_SHIFT;
> +	struct folio *folio;
> +
> +	if (!kvm_gmem_supports_mmap(inode))

Checking for MMAP is neither sufficient nor strictly necessary.  MMAP doesn't
imply SHARED, and it's not clear to me that mmap() support should be in any way
tied to WRITE support.

> +		return -ENODEV;
> +
> +	if (pos + len > i_size_read(inode))
> +		return -EINVAL;
> +
> +	folio = kvm_gmem_get_folio(inode, index);

Eh, since "index" is only used once, my vote is to use "pos" and do the shift
here, so that it's obvious that the input to kvm_gmem_get_folio() is being checked.

> +	if (IS_ERR(folio))
> +		return -EFAULT;

Why EFAULT?

> +
> +	*foliop = folio;

There shouldn't be any need for a local "folio".  What about having the "out"
param be just "folio"?

E.g.

static int kvm_kmem_gmem_write_begin(const struct kiocb *kiocb,
				     struct address_space *mapping,
				     loff_t pos, unsigned int len,
				     struct folio **folio, void **fsdata)
{
	struct inode *inode = file_inode(kiocb->ki_filp);

	if (!kvm_gmem_supports_write(inode))
		return -ENODEV;

	if (pos + len > i_size_read(inode))
		return -EINVAL;

	*folio = kvm_gmem_get_folio(inode, pos >> PAGE_SHIFT);
	if (IS_ERR(*folio))
		return PTR_ERR(*folio);

	return 0;
}


> +	return 0;
> +}
> +
> +static int kvm_kmem_gmem_write_end(const struct kiocb *kiocb,
> +				   struct address_space *mapping,
> +				   loff_t pos, unsigned int len,
> +				   unsigned int copied,
> +				   struct folio *folio, void *fsdata)
> +{
> +	if (copied && copied < len) {

Why check if "copied" is non-zero?  I don't see why KVM should behave differently
with respect to unwritten bytes if copy_folio_from_iter_atomic() fails on the
first byte or the Nth byte.

> +		unsigned int from = pos & ((1UL << folio_order(folio)) - 1);

Uh, isn't this just offset_in_folio()?

> +
> +		folio_zero_range(folio, from + copied, len - copied);

I'd probably be in favor of omitting "from" entirely, e.g.

	if (copied < len)
		folio_zero_range(folio, offset_in_folio(pos) + copied,
				 len - copied);

> +	}
> +
> +	folio_unlock(folio);
> +	folio_put(folio);
> +
> +	return copied;
> +}

