Return-Path: <kvm+bounces-48651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53471ACFFDA
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 11:55:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13A1A1756B6
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D2F28689C;
	Fri,  6 Jun 2025 09:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BrHMMoRq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6DE286880
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 09:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749203733; cv=none; b=TJ4zrE8PTp1s3J0fxiHh76SGIbWx4TeeYcEayoEcFIlERus0y6DpR/kq5BoubhEOxGurSXdg3d7SNRBrhlG6HA5Bzoui6JLQ6Qho8RsOuRYffxO2jbxBUO1RSLPPXKj1QTl0XfDdOQk/IH7Ub1+jMc0nzLzsgfeoxqrzreEuqRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749203733; c=relaxed/simple;
	bh=8z5COODJejti2xFP1aVpZY5KU//E8XL2IDYE7yP1rQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=agw6iJW03aT2RlRccqT+qzADanI+eCBSkYdCa618tsgaAg+cXCMihXE7BFIjic+fKwKMHyljKaYjw57f718vrsFfoS64SwkyoB9p1267VHwB5NCMqop/QwLYf0bpamBQKTj+o1qd712WEkr95eH6hTe/oDQLc5H7pLd5VFpur4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BrHMMoRq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749203730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XYPvzLB0B211kBxU7YdUxeFIxKTuY0q8/SdkHBljN4k=;
	b=BrHMMoRqdpIN1c96rXNQLmKTkG/N48ruwegt2D4rkNbdZOabQtyEyZf/iM8qB37tg/rYZq
	KKpj1AV0NIirum/I35HDRW6A1zgNPznyQIfsRab6+gCjkwIf9rn7NJPtrTJBTLluq8VM+n
	QUXD7NMt1RyopN1L9g9JY/0Crc65rpU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-UuX8MpE1P4KEIO93BzPnyA-1; Fri, 06 Jun 2025 05:55:29 -0400
X-MC-Unique: UuX8MpE1P4KEIO93BzPnyA-1
X-Mimecast-MFC-AGG-ID: UuX8MpE1P4KEIO93BzPnyA_1749203728
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450d64026baso11146875e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 02:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749203728; x=1749808528;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XYPvzLB0B211kBxU7YdUxeFIxKTuY0q8/SdkHBljN4k=;
        b=J2JL4IKx98mCPR8kKfmKLEvhx9k+eZmFt40u3RJuFl+/3qSjoBWSM3upG9JCvhhTr0
         QPbMKNJz5UTTOKurDbFALpHUOxvcad3UESp1OMvIPNcpQ+7wq5HhfxvDnMn9BQG6OWxJ
         gL10m230VfJeIOmSdIrsSh8WeQICTLywKLyzG32InPoMlaX/jmq1vJpvMdIcPAtY6V/B
         lzPnHt+EvSKj1o6UWpVnV9vYIN8CzHarcCd1UluIToDlLF5+ontNFtC2zAjDGrAQ0dYU
         PeIoEwCe4e3JFr69QEbPhlazPo3iuBjFCR/pxDZMv+nuiF120gwplXhgFYIhuwiGOirE
         mTrQ==
X-Gm-Message-State: AOJu0YyWQnWgYsltqI6ODk+YFytCkC0DA1SlC0E0w0+0A7AsWNK5lcOr
	iF4lSiSY9yZwsddp1iKMusBFutgJsJoC6r3Z96ywOMqLVrPYF3Fk+2SF30kcOqnfz7XP9ifqDW7
	w4ablJxS3XzNEuqz1YHondXhYfHcyKFHzDbmD9lewRQGqMnTAlgOTSw==
X-Gm-Gg: ASbGncuxT3S3YU7aT3UQsFy33Xy32MvtWVfzQOuzdmJgHhdBJxSQ1CNu5o4phK5z5/w
	Jqnnq8JPKtmS55X+oZDNXPqCmURhCutkJZNpRPvakUUKzu/o1kjpnUQxb6elLy+Flxe/hE/K8TC
	E7wh2WlHtZYmYf6Wqlz7m09MT5UjXkCAMv3MIZkBdrQrpmTELgSk2xmuBtjnB7AN1h67A4RPOaC
	vYzFcZpsajJggn8E/EX6ydloQs121M9ehSQF8ToHHCeUxTZwNLE++mFreegbm6sJnIaiS6kLA+c
	05tSUf7lDRqUWe0EWluyOvjiQOYAV/PeHEwhLix/j8NFRAwDc0w5XzAN5fLXvQEiBCUYixxykIE
	BUj3TUvSJzdfF1qF2l5K6S4YmIxVHCjQ=
X-Received: by 2002:a05:600c:45cf:b0:442:ccf9:e6f2 with SMTP id 5b1f17b1804b1-45201369ac3mr31877015e9.16.1749203727921;
        Fri, 06 Jun 2025 02:55:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbFfATpHmt52/SwEr3fiQRZQishUyJBS28J2OiszOXQEs+yvbEEz8LejgOozxxU+1u0mZVjg==
X-Received: by 2002:a05:600c:45cf:b0:442:ccf9:e6f2 with SMTP id 5b1f17b1804b1-45201369ac3mr31876225e9.16.1749203727347;
        Fri, 06 Jun 2025 02:55:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452730d15f4sm15690935e9.40.2025.06.06.02.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:55:25 -0700 (PDT)
Message-ID: <6cf86edb-1e7e-4b44-93d0-f03f9523c24a@redhat.com>
Date: Fri, 6 Jun 2025 11:55:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org,
 mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org,
 akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
 chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
 dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250605153800.557144-1-tabba@google.com>
 <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com>
 <CA+EHjTziHb5kbY-aA1HPKYpg6iAPcQ19=51pLQ05JRJKeOZ8=A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTziHb5kbY-aA1HPKYpg6iAPcQ19=51pLQ05JRJKeOZ8=A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.06.25 11:30, Fuad Tabba wrote:
> Hi David,
> 
> On Fri, 6 Jun 2025 at 10:12, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.06.25 17:37, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>> mapping that memory from host userspace.
>>>
>>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>>> flag at creation time.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>
>> [...]
>>
>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>> +{
>>> +     u64 flags;
>>> +
>>> +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>>> +             return false;
>>> +
>>> +     flags = (u64)inode->i_private;
>>
>> Can probably do above
>>
>> const u64 flags = (u64)inode->i_private;
>>
> 
> Ack.
> 
>>> +
>>> +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +}
>>> +
>>> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>>> +{
>>> +     struct inode *inode = file_inode(vmf->vma->vm_file);
>>> +     struct folio *folio;
>>> +     vm_fault_t ret = VM_FAULT_LOCKED;
>>> +
>>> +     if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>>> +             return VM_FAULT_SIGBUS;
>>> +
>>> +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>>> +     if (IS_ERR(folio)) {
>>> +             int err = PTR_ERR(folio);
>>> +
>>> +             if (err == -EAGAIN)
>>> +                     return VM_FAULT_RETRY;
>>> +
>>> +             return vmf_error(err);
>>> +     }
>>> +
>>> +     if (WARN_ON_ONCE(folio_test_large(folio))) {
>>> +             ret = VM_FAULT_SIGBUS;
>>> +             goto out_folio;
>>> +     }
>>> +
>>> +     if (!folio_test_uptodate(folio)) {
>>> +             clear_highpage(folio_page(folio, 0));
>>> +             kvm_gmem_mark_prepared(folio);
>>> +     }
>>> +
>>> +     vmf->page = folio_file_page(folio, vmf->pgoff);
>>> +
>>> +out_folio:
>>> +     if (ret != VM_FAULT_LOCKED) {
>>> +             folio_unlock(folio);
>>> +             folio_put(folio);
>>> +     }
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
>>> +     .fault = kvm_gmem_fault_shared,
>>> +};
>>> +
>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>> +{
>>> +     if (!kvm_gmem_supports_shared(file_inode(file)))
>>> +             return -ENODEV;
>>> +
>>> +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>> +         (VM_SHARED | VM_MAYSHARE)) {
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     vma->vm_ops = &kvm_gmem_vm_ops;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>>    static struct file_operations kvm_gmem_fops = {
>>> +     .mmap           = kvm_gmem_mmap,
>>>        .open           = generic_file_open,
>>>        .release        = kvm_gmem_release,
>>>        .fallocate      = kvm_gmem_fallocate,
>>> @@ -428,6 +500,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>        }
>>>
>>>        file->f_flags |= O_LARGEFILE;
>>> +     allow_write_access(file);
>>
>> Why is that required?
>>
>> As the docs mention, it must be paired with a previous deny_write_access().
>>
>> ... and I don't find similar usage anywhere else.
> 
> This is to address Gavin's concern [*] regarding MADV_COLLAPSE, which
> isn't an issue until hugepage support is enabled. Should we wait until
> we have hugepage support?

If we keep this, we *definitely* need a comment why we do something 
nobody else does.

But I don't think allow_write_access() would ever be the way we want to 
fence off MADV_COLLAPSE. :) Maybe AS_INACCESSIBLE or sth. like that 
could fence it off in file_thp_enabled().

Fortunately, CONFIG_READ_ONLY_THP_FOR_FS might vanish at some point ... 
so I've been told.

So if it's not done for secretmem for now or others, we also shouldn't 
be doing it for now I think.

-- 
Cheers,

David / dhildenb


