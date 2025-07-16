Return-Path: <kvm+bounces-52663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77E14B07ED3
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71421A437CB
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D899C2C08DC;
	Wed, 16 Jul 2025 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ConPimHK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37B27EFEF
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697451; cv=none; b=LuOtN6Ij0VNm2EQY2gMZY9haKRc6VwKEFE3X2R0dh8/xynThTMGqSo73CfYiN5YiG+L+i0uGM0cNcx31+TBYHkm9t/gvbiUoI1c0panSkRCMOJzP+n85IeX+wzz5WhtwTP6j7y8JXeUwvN1ays3r9Q13ucwPAKB9R7JQsrPuUeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697451; c=relaxed/simple;
	bh=OWwOEwoL4c/cHl9tlOPdM7T7kTDMxYThoiSS5XwyRkw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJ/ytoQf13IRwCEkHxDsAPxBiFQY0rP/WmbZa7xrUCmXifbpc+GN6sYNgayN4ynCTxHaqKt17Xso7jS1rMjLdrwW7+sIKFIy6Zff5fPLZ55iQigshBN89ZCGFex4NeptbioZCKhtwuyhvVp12qaSY8dkHSoArN7dh8pEO0R6/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ConPimHK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fPvdI3YhlO9GI6rBP8ySVGpgSYgi0LJtZ9QTwrrpP/g=;
	b=ConPimHK8z3teBZr/hzOQhU4Mqj63QGYUiMZTvMQY2op1PKF648w1wDITirnkthpdPgraY
	F2+cUN/x4hmMt5y1tGIaM6X3kq9DSDS7dxTpeMK9jYrfKMKd9lkfVxGseKWqg/u9vufzke
	MnnPWLnvzBdrFLoR+bXqF8apBYYbNuY=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-WC9d_bhJP4OOWNckmWkH7A-1; Wed, 16 Jul 2025 16:24:05 -0400
X-MC-Unique: WC9d_bhJP4OOWNckmWkH7A-1
X-Mimecast-MFC-AGG-ID: WC9d_bhJP4OOWNckmWkH7A_1752697444
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-86cf14fd106so5466739f.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697444; x=1753302244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPvdI3YhlO9GI6rBP8ySVGpgSYgi0LJtZ9QTwrrpP/g=;
        b=pxEwY8hUJVDfEKIyPe/MlaUJiaEayvZO8QxJEf2Ftg6Vv5idaajFau6FX2Z2RYQ3A5
         Ira1NFtFvouE1/pf2WRHk9m4ol/5Keo63C8soW4nn3wyhJLdBb1jTW2ee4v1Kv5drePP
         4E7NBS0lxnXacmuw6yBAygqVcEVeVkByrZTh9b957ObNGqkT8RaaTU6xvFjIb7WUKZrB
         sGv7CGoefULtv96w3QwDsefzX4zTmEqWIHtjAN63MgFF0aTkHMEpwDPp7WBi3taERW5e
         Xp+G7rS8zKVfV3A3/TImDubyKjpI1gQ9OZ4kBS3FQlvIMEibW2s6a2zJ708JaGIvnraA
         3pig==
X-Gm-Message-State: AOJu0YzGD00+0Rsi8U0iId+nPevhwNls9IO1NolEac0eCbzjTpDvVpFv
	nyu+XsKeJowclysPCl4pR7jIO5seLbYneASkYvdbSy/yKmoQ+VGa0EoxQMraOOxerfxU9j7JRTJ
	QSA01/l/HGXlrWT/TEgZFf6I02y2AnTf2nKnvgvLfld3/HL664ls16w==
X-Gm-Gg: ASbGncvgGWg6ckfI76uvgFxPTTxIOrF954yij5MnuVLa721fI76xPPU8P1AVxnmVjrX
	WcD7clEK4l3Z24YiIVfx+y2iOkOh3lTIFn7suen4a5NXC5vS+xApJRbspWbfCQ68AN6+5tXd+Jy
	nMm8pyS2GH8xC3lznE29myB0rWv3gGLAkNz4QJ27LbloP0K4S+oQ9vMLSFC0uJIeYU+TThpwUL8
	0xvju9PlFtMttqVCpg7bb343tiW46XE9Kbt3JSTZbQbecx3NsUnac8TtQY573Ie3DFePl9Q8cVt
	tJaDKVPJ5YZeqjKWNiYBcNEUDiMhsD9O0/FFArhCMwo=
X-Received: by 2002:a05:6602:2c93:b0:876:6fc6:1358 with SMTP id ca18e2360f4ac-879c090005fmr159784439f.4.1752697443991;
        Wed, 16 Jul 2025 13:24:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQM57KH4/hrYzJ2qXCdt8qoMrmX+6pQyjYsFU6u0/Mwn4A6JffpiIcPzJ2oqyc3L8xzdEkFQ==
X-Received: by 2002:a05:6602:2c93:b0:876:6fc6:1358 with SMTP id ca18e2360f4ac-879c090005fmr159783739f.4.1752697443521;
        Wed, 16 Jul 2025 13:24:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-879c3419538sm52469639f.19.2025.07.16.13.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:24:02 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:24:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: <kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <paulmck@kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250716142401.3104ee01.alex.williamson@redhat.com>
In-Reply-To: <20250715184622.3561598-1-kbusch@meta.com>
References: <20250715184622.3561598-1-kbusch@meta.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Jul 2025 11:46:22 -0700
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> A large DMA mapping request can loop through dma address pinning for
> many pages. In cases where THP can not be used, the repeated vmf_insert_pfn can
> be costly, so let the task reschedule as need to prevent CPU stalls. Failure to
> do so has potential harmful side effects, like increased memory pressure
> as unrelated rcu tasks are unable to make their reclaim callbacks and
> result in OOM conditions.
> 
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu:   36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
>  rcu:            hardirqs   softirqs   csw/system
>  rcu:    number:        0        107            0
>  rcu:   cputime:       50          0        10446   ==> 10556(ms)
>  rcu:   (t=21075 jiffies g=377761 q=204059 ncpus=384)
> ...
>   <TASK>
>   ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>   ? walk_system_ram_range+0x63/0x120
>   ? walk_system_ram_range+0x46/0x120
>   ? pgprot_writethrough+0x20/0x20
>   lookup_memtype+0x67/0xf0
>   track_pfn_insert+0x20/0x40
>   vmf_insert_pfn_prot+0x88/0x140
>   vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
>   __do_fault+0x28/0x1b0
>   handle_mm_fault+0xef1/0x2560
>   fixup_user_fault+0xf5/0x270
>   vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
>   vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
>   vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
>   ? futex_wake+0x1c1/0x260
>   x64_sys_call+0x234/0x17a0
>   do_syscall_64+0x63/0x130
>   ? exc_page_fault+0x63/0x130
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> v1->v2:
> 
>   Merged up to vfio/next
> 
>   Moved the cond_resched() to a more appropriate place within the
>   loop, and added a comment about why it's there.
> 
>   Update to change log describing one of the consequences of not doing
>   this.
> 
>  drivers/vfio/vfio_iommu_type1.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 1136d7ac6b597..ad599b1601711 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -647,6 +647,13 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  
>  	while (npage) {
>  		if (!batch->size) {
> +			/*
> +			 * Large mappings may take a while to repeatedly refill
> +			 * the batch, so conditionally relinquish the CPU when
> +			 * needed to avoid stalls.
> +			 */
> +			cond_resched();
> +
>  			/* Empty batch, so refill it. */
>  			ret = vaddr_get_pfns(mm, vaddr, npage, dma->prot,
>  					     &pfn, batch);

Applied to vfio next branch for v6.17.  Thanks,

Alex


