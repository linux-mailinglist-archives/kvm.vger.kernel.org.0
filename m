Return-Path: <kvm+bounces-32267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 718A19D4E49
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 15:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8A96B23D8A
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE841D9587;
	Thu, 21 Nov 2024 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ecn6E2ar"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975EE1D86C3
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198031; cv=none; b=rebweHCjBoPjfy5sIHGMEXG/493sWabOhxZOZKko+WfQCB7ZyNtULseGb+tF3R1wIJ3P6xFcQ6fKQnZFeyaRiPOAS0/+LaMQNo+9hFGoLTLODOiaj+DqQDvzspZTL9NA+nUIEeKusFUxbufdItSKUAtLmVMm5ZKZOkJgGjR26k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198031; c=relaxed/simple;
	bh=9uW5Dudj+swqaGbCjUsjteU63w49eLJj7HUQPfq++9Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dNkJg1IIRNjX45yt38WVpyttQhl3Mk0hJOwnYumDiXaWgVDvtNDLIbwUFfFCmL/w/dsq34H/kjEsklUj7DdFKef1RGCEfrz2JiaXe/0WCNjag/V9AXzFDY2wh3JigWaTMhs3v67jlgmSxp1RVEWp5mTD9iwjnZ1+21CpwRUnGAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ecn6E2ar; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732198028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C7tRH6nT8tzUEIZ5n33ADSmY1zfI1f6F5ul499NjvQI=;
	b=Ecn6E2arKsjyCBjrEZKI2sw6RVeNMx+DMgn6+Xz6lOQsiy/1cLtx37Q+kgG/Gbm+Vs8XU7
	nePNOIFlwxg9YDOyijVwDkGfP7fv8SD7TB6K0Oud5RK0rXTiU5S/Pgtuwp7hExwqscjtqa
	uy8T1a883A/6ka1DFkCUraETq9MBIlU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-QrT5ZkkyPGm3LTofFfd9fw-1; Thu, 21 Nov 2024 09:07:06 -0500
X-MC-Unique: QrT5ZkkyPGm3LTofFfd9fw-1
X-Mimecast-MFC-AGG-ID: QrT5ZkkyPGm3LTofFfd9fw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4315eaa3189so8410855e9.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 06:07:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732198025; x=1732802825;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7tRH6nT8tzUEIZ5n33ADSmY1zfI1f6F5ul499NjvQI=;
        b=kZVucpMgtMHnh3iDONZImekN6M0mnsYOAMkMlaq0jeXbz1vUjKiAtgvuITZwqEoLii
         1o2S49cz+PuzbRwtu4KNWNMyjQ1v89kRatDRrwmObTSYnQGji+UUVLOU1oXVJ1oxe5S5
         eGDsUNNzfGIT1BVw23ZhNhWkVUVBeknwa25TmN4Bxn5QdHVarnfLP+lNJ9lFMxgjIM89
         5mi7HnF53AfLTfKC2SF3IgS8n4e3vQvkLZkZn61AG/WJvMqzY80KdEOSaI3yR7b+TBh9
         gahj+kdJIgGOEknM155HzYIFybO2k8D9Ul2ISI9WCqELK4NVrIA6DlTcSl8fT+mkaggt
         yfVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4MvhcOzAsre2gWk1vIkr17Aw/19DjaX7ZECNFH/qC3aetsmz4BVjHFBoDakGr4PtQlOg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFhSjbhNRvJDnCc10+pCqMBYNe13CLph+M6fPqRGXYPPcHWrgF
	YN0BTicVtj1Mt1R+DQh1B6wcJCARoyQ7VlSYjih7QbNVyUmKmyi2nafCWj6YkEeSTBcuhtv158I
	b0hH5QlkJxT01NV3pTBqDKShz6Egxrlm8nr36M2WNRfGwwvF0Cg==
X-Gm-Gg: ASbGncvpCAeAnuphG0CJ34vbOIGpk2SmAuRR15Mf4vec6xZsc+GVD7ce9uzUAHGQTh7
	cNtS/dTvaluw4L6YQGmDvdR+pm6p+Lg3JvcvzzbsoHDdihHlUaD06wFat1YTMNE3JdGUfV24Uy/
	gxH7sbJot8482ewVbEPg0u8mRe4maulvaTxfZD8lGjd/rw5iptGL/WZe0SjyDg7rnl+QGIA+3ls
	PkPOiCAwkKtbV4c5ECggVY6tnrmkD0sBnL6aXwZ5GFS3C6uTJ4B
X-Received: by 2002:a05:600c:a01:b0:431:59b2:f0c4 with SMTP id 5b1f17b1804b1-433489a02f2mr70066525e9.8.1732198025404;
        Thu, 21 Nov 2024 06:07:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGErVlXnz0iTStRiT3lm2XztCeR4j5PanjVYk+18Bw5BOFsvkHxWCMSfhXHKVKZNlEzY/r/6w==
X-Received: by 2002:a05:600c:a01:b0:431:59b2:f0c4 with SMTP id 5b1f17b1804b1-433489a02f2mr70065855e9.8.1732198024879;
        Thu, 21 Nov 2024 06:07:04 -0800 (PST)
Received: from [192.168.10.3] ([151.49.91.173])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432f642f15esm85373565e9.0.2024.11.21.06.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:07:04 -0800 (PST)
Message-ID: <901c7d58-9ca2-491b-8884-c78c8fb75b37@redhat.com>
Date: Thu, 21 Nov 2024 15:07:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
To: Nathan Chancellor <nathan@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20241120135842.79625-1-pbonzini@redhat.com>
 <Zz8t95SNFqOjFEHe@sashalap> <20241121132608.GA4113699@thelio-3990X>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241121132608.GA4113699@thelio-3990X>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 14:26, Nathan Chancellor wrote:
> On Thu, Nov 21, 2024 at 07:56:23AM -0500, Sasha Levin wrote:
>> Hi Paolo,
>>
>> On Wed, Nov 20, 2024 at 08:58:42AM -0500, Paolo Bonzini wrote:
>>>       riscv: perf: add guest vs host distinction
>>
>> When merging this PR into linus-next, I've started seeing build errors:
>>
>> Looks like this is due to 2c47e7a74f44 ("perf/core: Correct perf
>> sampling with guest VMs") which went in couple of days ago through
>> Ingo's perf tree and changed the number of parameters for
>> perf_misc_flags().

Thanks Sasha. :(  Looks like Stephen does not build for risc-v.

> There is a patch out to fix this but it seems like it needs to be
> applied during this merge?
> 
> https://lore.kernel.org/20241116160506.5324-1-prabhakar.mahadev-lad.rj@bp.renesas.com/

Yes, this works.  To test it after the merge I did it.

   curl https://lore.kernel.org/linux-riscv/20241116160506.5324-1-prabhakar.mahadev-lad.rj@bp.renesas.com/raw | patch -p1
   git add -p
   git commit --amend


This should have been handled with a topic branch, and there is another
nontrivial conflict with Catalin's tree that should have been handled
with a topic branch.  (I knew about that one, but his topic branch also
had a conflict with something else; so I un-pulled it and then forgot
about it).


Linus,

if you prefer to get a reviewed pull request with the topic branches
included, then the changes since commit 2c47e7a74f445426d156278e339b7abb259e50de:

   perf/core: Correct perf sampling with guest VMs (2024-11-14 10:40:01 +0100)

are available in the Git repository at:

   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus-with-topic-branches-6.13

for you to fetch changes up to bde387a8d81735a93c115ee4f1bd99718e5d30b0:

   Merge branch 'for-next/mte' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux into HEAD (2024-11-21 08:53:23 -0500)


Alternatively,

the best way to get the RISC-V fix is the curl invocation above, and after
my signature is the conflict resolution for Catalin's tree.


Thanks,

Paolo


diff --cc arch/arm64/kvm/guest.c
index 4cd7ffa76794,e738a353b20e..12dad841f2a5
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@@ -1051,11 -1051,13 +1051,12 @@@ int kvm_vm_ioctl_mte_copy_tags(struct k
   	}
   
   	while (length > 0) {
  -		kvm_pfn_t pfn = gfn_to_pfn_prot(kvm, gfn, write, NULL);
  +		struct page *page = __gfn_to_page(kvm, gfn, write);
   		void *maddr;
   		unsigned long num_tags;
  -		struct page *page;
+ 		struct folio *folio;
   
  -		if (is_error_noslot_pfn(pfn)) {
  +		if (!page) {
   			ret = -EFAULT;
   			goto out;
   		}
@@@ -1090,8 -1099,12 +1097,12 @@@
   			/* uaccess failed, don't leave stale tags */
   			if (num_tags != MTE_GRANULES_PER_PAGE)
   				mte_clear_page_tags(maddr);
- 			set_page_mte_tagged(page);
+ 			if (folio_test_hugetlb(folio))
+ 				folio_set_hugetlb_mte_tagged(folio);
+ 			else
+ 				set_page_mte_tagged(page);
+
  -			kvm_release_pfn_dirty(pfn);
  +			kvm_release_page_dirty(page);
   		}
   
   		if (num_tags != MTE_GRANULES_PER_PAGE) {


