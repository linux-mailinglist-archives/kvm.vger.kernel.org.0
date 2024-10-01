Return-Path: <kvm+bounces-27795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B6FF98C897
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 01:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 351791C236B5
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 23:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68C951CFEAE;
	Tue,  1 Oct 2024 23:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sz2chlU3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4751CF282
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727823643; cv=none; b=rRC94nbB6WG6PoA4DTFdUYNTRKlM3F0nVq0AZuo0+EIzyHPSlC7o/fHD+pd8dixkQ4zx9LTSIqJQLL+EIuvTMZwZ3UO4pHLngVx2Yd+eLtlYP+7CoSqU+qyyREUISOnu7qfLQnx16bJ9T9QUiTZzh7PT+B7Ab0MZhAouX3ARqlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727823643; c=relaxed/simple;
	bh=fN2zhR/oAJLjodnx94s0qNDAmLYSl4bm7T1l3NdvWKU=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rHiQ+W7PLFPlignqQEw/Nna2bGUoZ/w4RBFHpjyK7jNfHxiTGTj8XX24kuBC/EEOEWEf/77MXHekZ3QX1mdowLd1H8s3sGnApuL4xmiIag5gY1rps3aCOY9gr59VC1EZN76+6bFuTA9XaRHNC4AELijINnDUs7KxFMWdZvFbEdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sz2chlU3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e2270a147aso94259507b3.0
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 16:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727823641; x=1728428441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4gCtU5HfgnWFhWLB0iKDEWMiCCXFJXlISNEaZ8KzdwM=;
        b=sz2chlU3fFHs0Wklp/MQUm6e4CZ6MnY9dTVBn25c+G/kAx6nyNr+OaQ9NV/6EyGBF1
         U38dVVxvFnTatcCdJJaWbvmD+m5zEtBL+rvkL366dNdt+xk0O6EjtUiOMYdAAFBWZ3b3
         pjxIdM3MPydEhoPscVr+DWZB2JPl4KxGMtJwf9DkQhqWWVfrMHIBPKE6XERsbImtY+l7
         spJvf8fFDHNRzJ7pMgUKju3cYwUvBzz7UogI3SFg4f+VXR+ABB6ZPON8vNt7l3Ze2Fdf
         UYXmrMoi5GE9lgBMBe0RQsNJ/yyQ2Ih4mj7DT05MG555HQ/ecZsFPPj6cf8SUGKVz6qp
         pW0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727823641; x=1728428441;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4gCtU5HfgnWFhWLB0iKDEWMiCCXFJXlISNEaZ8KzdwM=;
        b=KChs9PaHGwFvujz4zP+0lCw+LDipAjpef6BlRSaLrFlOhqmrwvzT2sfgnOKW8g9P71
         036745fki8ws351Pj/2O2T8gXQLfWn5dedoF2w5Q6MVdzVaYAwawT05u+mYtiQt2rYnH
         8fA2kmvmx2K/5N+iIan0aOc+XMgynt56gyAtajOcy9oMXlFQ116UZozq3PJAHYrhu+CB
         wL4/i15FpP9uJcoPViKagZK0mQ8V6NRtQF0/zXs1mVKCKDGJ4E5agG9rKZO+WABiWo3q
         RZl+UugKUckEff1O1J2tVITHEN+ZqV1YxK0SjJA5U+u82yGZ1NHOKg88+fCc23WAaKBx
         lsyw==
X-Forwarded-Encrypted: i=1; AJvYcCUBqEth5bRyamPoaV4YuAHwJ5s8hkZmeCnOYsDyY5sAN37pR9a0tCXDR2Zq1bLPwbe9OcI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywez8Z/MdVVFcF8rLaCYQbSmVfOU6FH1R5zSI899AQNaQb284xD
	w3b6I9u1jeqHW+9D4badgNzkuux4Mv9mDSgbHkH7EwF0M9Te5nUw+ahGAlYgV0heYK86aTmEChb
	dRsLDtnekmzjEX7k1kaH4Hw==
X-Google-Smtp-Source: AGHT+IG3j6THonxAJt6TEJKN7NO5HT8bgSkq/EkXQdPd0/DIlLt9YIjJDCnSMc65fW4q5aqiWvBO7ZRe6vvgfxZcVw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:146:b875:ac13:a9fc])
 (user=ackerleytng job=sendgmr) by 2002:a05:690c:6001:b0:6e2:12e5:356f with
 SMTP id 00721157ae682-6e2a2e48277mr357187b3.3.1727823640635; Tue, 01 Oct 2024
 16:00:40 -0700 (PDT)
Date: Tue, 01 Oct 2024 23:00:38 +0000
In-Reply-To: <CAGtprH-xw9DFwheTicNStXKhMJTsuXviBnq1PwvrxEHMNkb83A@mail.gmail.com>
 (message from Vishal Annapurve on Fri, 20 Sep 2024 11:17:45 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz7cartomh.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH 14/39] KVM: guest_memfd: hugetlb: initialization and cleanup
From: Ackerley Tng <ackerleytng@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk, 
	jgg@nvidia.com, peterx@redhat.com, david@redhat.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, seanjc@google.com, 
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev, 
	mike.kravetz@oracle.com, erdemaktas@google.com, qperret@google.com, 
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org, 
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev, 
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com, 
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com, 
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com, pgonda@google.com, 
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Vishal Annapurve <vannapurve@google.com> writes:

> On Wed, Sep 11, 2024 at 1:44=E2=80=AFAM Ackerley Tng <ackerleytng@google.=
com> wrote:
>>
>> ...
>> +}
>> +
>> +static void kvm_gmem_evict_inode(struct inode *inode)
>> +{
>> +       u64 flags =3D (u64)inode->i_private;
>> +
>> +       if (flags & KVM_GUEST_MEMFD_HUGETLB)
>> +               kvm_gmem_hugetlb_teardown(inode);
>> +       else
>> +               truncate_inode_pages_final(inode->i_mapping);
>> +
>> +       clear_inode(inode);
>> +}
>> +
>>  static const struct super_operations kvm_gmem_super_operations =3D {
>>         .statfs         =3D simple_statfs,
>> +       .evict_inode    =3D kvm_gmem_evict_inode,
>
> Ackerley, can we use free_inode[1] callback to free any special
> metadata associated with the inode instead of relying on
> super_operations?
>
> [1] https://elixir.bootlin.com/linux/v6.11/source/include/linux/fs.h#L719
>

.free_inode() is not a direct replacement for .evict_inode().

If the .free_inode() op is NULL, free_inode_nonrcu(inode) handles freeing t=
he
struct inode itself. Hence, the .free_inode() op is meant for freeing the i=
node
struct.

.free_inode() should undo what .alloc_inode() does.

There's more information about the ops free_inode() here
https://docs.kernel.org/filesystems/porting.html, specifically

| Rules for inode destruction:
|
| + if ->destroy_inode() is non-NULL, it gets called
| + if ->free_inode() is non-NULL, it gets scheduled by call_rcu()
| + combination of NULL ->destroy_inode and NULL ->free_inode is treated as
|   NULL/free_inode_nonrcu, to preserve the compatibility.

The common setup is to have a larger containing struct containing a struct
inode, and the .free_inode() op will then free the larger struct. In our ca=
se,
we're not using a containing struct for the metadata, so .free_inode() isn'=
t the
appropriate op.

I think this question might be related to Sean's question at LPC about whet=
her
it is necessary for guest_memfd to have its own mount, as opposed to using =
the
anon_inode_mnt.

I believe having its own mount is the correct approach, my reasoning is as
follows

1. We want to clean up these inode metadata when the last reference to the =
inode
   is dropped
2. That means using some op on the iput_final() path.
3. All the ops on the iput_final() path are in struct super_operations, whi=
ch is
   part of struct super_block
4. struct super_block should be used together with a mount

Hence, I think it is correct to have a guest_memfd mount. I guess it might =
be
possible to have a static super_block without a mount, but that seems hacky=
 and
brittle, and I'm not aware of any precedent for a static super_block.

Sean, what are your concerns with having a guest_memfd mount?

Comparing the callbacks along the iput_final() path, we have these:

+ .drop_inode() determines whether to evict the inode, so that's not the
  approprate op.
+ .evict_inode() is the current proposal, which is a place where the inode'=
s
  fields are cleaned up. HugeTLB uses this to clean up resv_map, which it a=
lso
  stores in inode->i_mapping->i_private_data.
+ .destroy_inode() should clean up inode allocation if inode allocation inv=
olves
  a containing struct (like shmem_inode_info). Shmem uses this to clean up =
a
  struct shared_policy, which we will eventually need to store as well.
+ .free_inode() is the rcu-delayed part that completes inode cleanup.

Using .free_inode() implies using a containing struct to follow the
convention. Between putting metadata in a containing struct and using
inode->i_mapping->i_private_data, I think using inode->i_mapping->i_private=
_data
is less complex since it avoids needing a custom .alloc_inode() op.

Other than using inode->i_mapping->i_private_data, there's the option of
combining the metadata with guest_memfd flags, and storing everything in
inode->i_private.

Because inode->i_mapping actually points to inode->i_data and i_data is
a part of the inode (not a pointer), .evict_inode() is still the op to
use to clean both inode->i_mapping->i_private_data and inode->i_private.

I think we should stick with storing metadata (faultability xarray and huge=
tlb
pool reference) in inode->i_mapping->i_private_data because both of these a=
re
properties of the page cache/filemap.

When we need to store a memory policy, we might want to use .destroy_inode(=
) to
align with shmem.

What do you all think?

And there's no way to set inode->free_inode directly and skip copying
from inode->i_sb->s_op. All the code paths going to i_callback() copy
inode->i_sb->s_op->free_inode to inode->free_inode before calling
.free_inode() in i_callback() to complete the inode cleanup.

