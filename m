Return-Path: <kvm+bounces-35213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A47D3A0A134
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 07:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA4F93A977B
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 06:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D590B16BE3A;
	Sat, 11 Jan 2025 06:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Mjqi712+"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C80515383D;
	Sat, 11 Jan 2025 06:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736576124; cv=none; b=tTnLYuyd/9ig7wIcfJGrQbCc/SRmCJ8j3Pz1Ird2XPDuCvJpeCDH1oMjPX/2JHLPttRhAfU+PTM4cOyvtudJHxMlcIiHq2xiQC67c5acI+PVm4/Tzfn4+UJSfxw+TGSYhomo24e1ufQYi90nQ8TLkwTMNVA/b6KU0vdnhgCLJuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736576124; c=relaxed/simple;
	bh=38RaDs87PAaxibWI5mIf84vwxxF7MUkRDRsC5TlwFhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ps4B/y+SGjKaPN4lPb2Xiz39XQmlN/guj1zhKDcOSMlFLpu9INXolBDpgKCZUTrCc21+8aXZSkyGsnkAEN9dBTgz546gz9Pnp6wG4ebpuKjU5m5geUCd86S5806/IG22KcSE036Iq7ukuslSP0sfl/1yekLT90d7QcfPDpRML6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Mjqi712+; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=pFD0qqzOGd0US3edIzgXO+FcPjO8z4JifZsLny7fPyc=;
	b=Mjqi712+1XP8sqESPgfyLRK3goP2RxD+kAA/vDQ4io5aiOVeUsWTugbNIjLGmw
	2v+sjn4RZwDZ6ID1ODd0LqVx9CMB3lxJT/fJIpZeFkd25RLV6RcnmFgWeTrnzKxD
	4INkYa3YVvHjQRAOy0l0baaqCer/EJ7mVDUTXALUbKYHk=
Received: from [172.19.20.199] (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3f+JcDIJncOh3Aw--.43996S2;
	Sat, 11 Jan 2025 14:14:53 +0800 (CST)
Message-ID: <928fc38a-687f-4aa1-9a98-103a5e784e8f@126.com>
Date: Sat, 11 Jan 2025 14:14:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] KVM: SEV: fix wrong pinning of pages
To: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 21cnbao@gmail.com, baolin.wang@linux.alibaba.com, liuzixing@hygon.cn
References: <1736509376-30746-1-git-send-email-yangge1116@126.com>
 <1d020344-37e0-4386-a064-ddd0ca71d110@redhat.com>
From: Ge Yang <yangge1116@126.com>
In-Reply-To: <1d020344-37e0-4386-a064-ddd0ca71d110@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f+JcDIJncOh3Aw--.43996S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr45Wr43KFy5Zw1UXryUGFg_yoW7Jw47pF
	4rGws0yFW3Kr9FvFyxtrWkur47Z3y8Kw4jkr1Iy3s5uFnxtFyxtr4Igw1Ut395A348WF93
	tr4DGan8uw4DZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYGQhUUUUU=
X-CM-SenderInfo: 51dqwwjhrrila6rslhhfrp/1tbifh3RG2eCCUAiJgAAsB



在 2025/1/10 19:53, David Hildenbrand 写道:
> On 10.01.25 12:42, yangge1116@126.com wrote:
>> From: yangge <yangge1116@126.com>
>>
>> When pin_user_pages_fast() pins SEV guest memory without the
>> FOLL_LONGTERM flag, the pages will not get migrated out of MIGRATE_CMA/
>> ZONE_MOVABLE, violating these mechanisms to avoid fragmentation with
>> unmovable pages, for example making CMA allocations fail.
>>
>> To address the aforementioned problem, we propose adding the
>> FOLL_LONGTERM flag to the pin_user_pages_fast() function.
>>
>> Signed-off-by: yangge <yangge1116@126.com>
>> ---
>>
>> V2:
>> - update code and commit message suggested by David
>>
>>   arch/x86/kvm/svm/sev.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 943bd07..96f3b8e 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -630,6 +630,7 @@ static struct page **sev_pin_memory(struct kvm 
>> *kvm, unsigned long uaddr,
>>       unsigned long locked, lock_limit;
>>       struct page **pages;
>>       unsigned long first, last;
>> +    unsigned int flags = FOLL_LONGTERM;
>>       int ret;
>>       lockdep_assert_held(&kvm->lock);
>> @@ -662,8 +663,10 @@ static struct page **sev_pin_memory(struct kvm 
>> *kvm, unsigned long uaddr,
>>       if (!pages)
>>           return ERR_PTR(-ENOMEM);
>> +    flags |= write ? FOLL_WRITE : 0;
>> +
>>       /* Pin the user virtual address. */
>> -    npinned = pin_user_pages_fast(uaddr, npages, write ? FOLL_WRITE : 
>> 0, pages);
>> +    npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
>>       if (npinned != npages) {
>>           pr_err("SEV: Failure locking %lu pages.\n", npages);
>>           ret = -ENOMEM;
> 
> Sorry, looking into it in more detail, there are some paths that 
> immediately unpin again,
> and don't seem to have longterm semantics.
> 
> 
> Could we do the following, so longterm pinning would be limited to the 
> memory regions
> that might stay pinned possible forever?

ok, thanks.

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d37..4b0f03f0ea741 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -622,7 +622,7 @@ static int sev_launch_start(struct kvm *kvm, struct 
> kvm_sev_cmd *argp)
> 
>   static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>                                      unsigned long ulen, unsigned long *n,
> -                                   int write)
> +                                   int flags)
>   {
>          struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>          unsigned long npages, size;
> @@ -663,7 +663,7 @@ static struct page **sev_pin_memory(struct kvm *kvm, 
> unsigned long uaddr,
>                  return ERR_PTR(-ENOMEM);
> 
>          /* Pin the user virtual address. */
> -       npinned = pin_user_pages_fast(uaddr, npages, write ? 
> FOLL_WRITE : 0, pages);
> +       npinned = pin_user_pages_fast(uaddr, npages, flags, pages);
>          if (npinned != npages) {
>                  pr_err("SEV: Failure locking %lu pages.\n", npages);
>                  ret = -ENOMEM;
> @@ -751,7 +751,7 @@ static int sev_launch_update_data(struct kvm *kvm, 
> struct kvm_sev_cmd *argp)
>          vaddr_end = vaddr + size;
> 
>          /* Lock the user memory. */
> -       inpages = sev_pin_memory(kvm, vaddr, size, &npages, 1);
> +       inpages = sev_pin_memory(kvm, vaddr, size, &npages, FOLL_WRITE);
>          if (IS_ERR(inpages))
>                  return PTR_ERR(inpages);
> 
> @@ -1250,7 +1250,8 @@ static int sev_dbg_crypt(struct kvm *kvm, struct 
> kvm_sev_cmd *argp, bool dec)
>                  if (IS_ERR(src_p))
>                          return PTR_ERR(src_p);
> 
> -               dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, 
> PAGE_SIZE, &n, 1);
> +               dst_p = sev_pin_memory(kvm, dst_vaddr & PAGE_MASK, 
> PAGE_SIZE, &n,
> +                                      FOLL_WRITE);
>                  if (IS_ERR(dst_p)) {
>                          sev_unpin_memory(kvm, src_p, n);
>                          return PTR_ERR(dst_p);
> @@ -1316,7 +1317,8 @@ static int sev_launch_secret(struct kvm *kvm, 
> struct kvm_sev_cmd *argp)
>          if (copy_from_user(&params, u64_to_user_ptr(argp->data), 
> sizeof(params)))
>                  return -EFAULT;
> 
> -       pages = sev_pin_memory(kvm, params.guest_uaddr, 
> params.guest_len, &n, 1);
> +       pages = sev_pin_memory(kvm, params.guest_uaddr, 
> params.guest_len, &n,
> +                              FOLL_WRITE);
>          if (IS_ERR(pages))
>                  return PTR_ERR(pages);
> 
> @@ -1798,7 +1800,7 @@ static int sev_receive_update_data(struct kvm 
> *kvm, struct kvm_sev_cmd *argp)
> 
>          /* Pin guest memory */
>          guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
> -                                   PAGE_SIZE, &n, 1);
> +                                   PAGE_SIZE, &n, FOLL_WRITE);
>          if (IS_ERR(guest_page)) {
>                  ret = PTR_ERR(guest_page);
>                  goto e_free_trans;
> @@ -2696,7 +2698,8 @@ int sev_mem_enc_register_region(struct kvm *kvm,
>                  return -ENOMEM;
> 
>          mutex_lock(&kvm->lock);
> -       region->pages = sev_pin_memory(kvm, range->addr, range->size, 
> &region->npages, 1);
> +       region->pages = sev_pin_memory(kvm, range->addr, range->size, 
> &region->npages,
> +                                      FOLL_WRITE | FOLL_LONGTERM);
>          if (IS_ERR(region->pages)) {
>                  ret = PTR_ERR(region->pages);
>                  mutex_unlock(&kvm->lock);
> 
> 
> Thoughts?
> 


