Return-Path: <kvm+bounces-65687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0011CCB4736
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 02:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA2E5300B806
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 01:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4715123B62C;
	Thu, 11 Dec 2025 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IVQV1GC2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0248A22A7E9
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 01:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765417379; cv=pass; b=OYU4XY1z1iQT5hVx0Z2rqfJVDO2C8E/pgbH+xDDB4JxJCwgtllaLl+cGWrH9QZadyZP/+9Rvd3CZQG09h7wiPaWLsOCXpk5+cd//+hQFN0qb845X6XBAZkWtdtJRF7t78VDiEb9Hn9aSYSb8JHlL6oSaPW02SrbYsmPZP+EFnhc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765417379; c=relaxed/simple;
	bh=Up9/0bs/T1oZC/MIQHCZ2awsAq2wQ8MwOT1BDx0mXaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ddh4KHwfLqLe96dSzPGHfJnIiUYKOYoHzqCyHetGPs9hW+/IoRDy39l5DjheH8u9Dk2NM7cUWQg7ONg8s3LphJfJ+Bgr2xU4wd6pAZ8RhZyj8FN9Mef6hXX7Aa2KRwL30oS4sq06YGsph83gdYPFTikR+Ogzq6kxzyXE8OixqqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IVQV1GC2; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297e13bf404so93335ad.0
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 17:42:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765417377; cv=none;
        d=google.com; s=arc-20240605;
        b=N17uXWZYN0Yjjx65Ernk28WjDZ32N+uaIOMBPserXXMJfvO4k2N7+yOMU4DQAfHFAu
         cph7b1a1PyVY+2kC9+H0uNbH28hl9C43zcdSXBwyZX3fjgMnNA7xClgSuLkfGWoIO7Jo
         bvEG4Xzi82vkQgWjVnVDcPHSHzkqKXB5bv17Vpye90nbLqgydnEXoEb4mhmvUazFgjX5
         8U46RwXZ2krKMKJXy4cyiUOqFvGPhGUni/tFlORoHV9pWHLoApPQJLDZNh+i3+pF9iuu
         +jqDWLKqBbLs0o1J2mCA0hzpyV3vK/PdAtDOeu/du7dj8lvNekwStxz8BsxdaIxOPQ3z
         MTNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rlV4B+ZekxQvYdkN1z0KRCFfBxqncD2TBL18PW/RR6o=;
        fh=CSBsqiZdkPS2mh4pFwiyeNIGLC2k0CT+liOJiHWaQ0w=;
        b=ljHuPCwP5V2Z1BHsAtJitPs5azIv1F4nNSu7D7JFcnDdyaEzM7b0xWOfJFbB3jVEHS
         zS0DzjyMflurQ+xmyMPOpYPJ3oHSY4iv1CTiOkh/inujE3ZLIrowvVojOKze5NBzWOt5
         lQf2dRW/tHQkUuPIR/sLZdqBfhJCJUhSj3/rViBGp5T4nBptfYRA8kffqGxVdtUk63UN
         FNlmM/YuldQe9J1Oao/5KZa5MrMUkNAT5zow+tYjqY7d6F11p8skRyMRJPzFt4TG47Z+
         BrauKGmTYdtiZHuc6xgr+R+DRbILrlxTTrSyHRk1yrBGbfFJcNzED4XkxCgbdInPNuwh
         NW8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765417377; x=1766022177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlV4B+ZekxQvYdkN1z0KRCFfBxqncD2TBL18PW/RR6o=;
        b=IVQV1GC2O6KI6Rtmv+fsQq1dmvIIEPyrvY8wDxem881VXCVgRqq5S9+frI3l//e2oG
         MdSUE0/Ww3ndm+WOffv9Ej2WDIvhdMnTemoUOCgERuQSA0f9lmRpqO4+xmKvotUxZFFP
         RDuXdKwhdhBuk9Sgj2h+7fThsq7mxumfG0s8BCQS4VEpqf2tltL8CkQeh6KATdRN2aC8
         T8pJ4duNW0LaDAAZHyZr9YnbYaEPUXOu+4FmMAr9ZQ9r+MnDpOXdHZapKuLmOFsco4GQ
         6t8mo/AoUyvnAOHjMblByT6+HUZaN/axKykA6AbKZi38C5tRM3XFgW4rV2rMc9Ytxp4r
         l7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765417377; x=1766022177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rlV4B+ZekxQvYdkN1z0KRCFfBxqncD2TBL18PW/RR6o=;
        b=LhKLdMw4szPUFtMWNNUuT4AUl2jKwGPdGvovkVCsHdVMxhTecLl9bsFyUwX0RFfhsU
         N1LsRXCaZLVvjhoHehaGCCWUVofJL9a+WmgmNR+652l7/98TGvl8JXfOKnDNe9PGupwn
         xOy6u4HGL/aEyCtlL+QvGYFK1Nfjl/diLmRf5xCeWOs8+DSt1p3eiP+JOfw3vCl7oUXj
         vZzu4a61re0uajm/OicaNo7WTC/Gg++VkgthZkI+CPZkW+vAubP87KKaJ0K8/Bba83sq
         1gEb8WfAbCqMKlEtLhDz3VqvGNct1xm9fY2ktd7rk6Ai8+J7SZzTL/OYnD7o+5mSrjRw
         Jc/A==
X-Forwarded-Encrypted: i=1; AJvYcCWIjHfAbCm9++2wcSKiliNpyNYLMxupbyX1cGBdKYcC1N33AHNZRwPrcbBKkWDLjlHI6Fk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfq5Ew4gV0hfzCbrQQGMRvpqKeFqFh8BZ0WTGUBDIynqufRrRo
	QmH0t1DwZRZXWGAJMH04jkAVgkDgZo0bEQBPKSM8URJa4Y6GkyjNf2cRbRKuwmPnJciaNb6iLzN
	Xxk2O76Jw/nH3yb+KwVoNiQbcPzn3BQUCQI/ZbKaD
X-Gm-Gg: ASbGnctBpw3+kbTKL3pAwX9t5lxeyb/4jzhsZjHdH68n2V9WrlCyynioLhA8peQlWJL
	1dKmpKhIV3kkVkzFEd28h2YVJROnQri/i5ah/Wqiqe2gH6R79zl0nLafaFNLAVdz2u8KBBjx+jx
	pSmN43/nj/ExZGuXh1Vn5VB0WaPaFJc7ziveOLd2B04yUC1ezT82MHr6PqBAbDF1xl5U028WX+E
	THksBDMqiJIMBpMYlIkqgC/be5kal6JHB5Nl/oKFqoS5VidTdl2BaNtIZl/PFu8nCbjY6HKghgg
	8vR9lwJm6MGQRZ9FxTM14hLg1w==
X-Google-Smtp-Source: AGHT+IET9VTfR4tiyWsJeDDBcHkYsT/F7uB7jgERGIK1GC7mtlBFGqO2bf7sUGk/jnxmGx12OIhogu2MYLgLJNAxyf0=
X-Received: by 2002:a05:7022:784:b0:119:e55a:8087 with SMTP id
 a92af1059eb24-11f2e4267b2mr136729c88.4.1765417376796; Wed, 10 Dec 2025
 17:42:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094604.4762-1-yan.y.zhao@intel.com>
 <CAAhR5DF=Yzb6ThiLDtktiOnAG3n+u9jZZahJiuUFR9JFCsDw0A@mail.gmail.com> <aTZmY1P6uq8KWwKr@yzhao56-desk.sh.intel.com>
In-Reply-To: <aTZmY1P6uq8KWwKr@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 10 Dec 2025 17:42:44 -0800
X-Gm-Features: AQt7F2p8eNzGnDqzxGTfoK5s9iSyv8CdCCwYQynst4VEY_zZj97GUTmOz319irc
Message-ID: <CAGtprH8hk0akN1pbxO95O_AyHf-BDN5tOH-Lbxg-qcTMg-27UQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Sagi Shahar <sagis@google.com>, pbonzini@redhat.com, seanjc@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	rick.p.edgecombe@intel.com, dave.hansen@intel.com, kas@kernel.org, 
	tabba@google.com, ackerleytng@google.com, quic_eberman@quicinc.com, 
	michael.roth@amd.com, david@redhat.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com, 
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 9:51=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> > > index 6b6c46c27390..508b133df903 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1591,6 +1591,8 @@ struct kvm_arch {
> > >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> > >         struct kvm_mmu_memory_cache split_desc_cache;
> > >
> > > +       struct kvm_mmu_memory_cache pamt_page_cache;
> > > +
> >
> > The latest DPAMT patches use a per-vcpu tdx_prealloc struct to handle
> > preallocating pages for pamt. I'm wondering if you've considered how
> > this would work here since some of the calls requiring pamt originate
> > from user space ioctls and therefore are not associated with a vcpu.
> I'll use a per-VM tdx_prealloc struct for splitting here, similar to the
> per-VM pamt_page_cache.
>
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 43dd295b7fd6..91bea25da528 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -48,6 +48,9 @@ struct kvm_tdx {
>          * Set/unset is protected with kvm->mmu_lock.
>          */
>         bool wait_for_sept_zap;
> +
> +       spinlock_t external_kvm_split_cache_lock;
> +       struct tdx_prealloc prealloc_split_cache;
>  };
>
> > Since the tdx_prealloc is a per vcpu struct there are no race issues
> > when multiple vcpus need to add pamt pages but here it would be
> > trickier here because theoretically, multiple threads could split
> > different pages simultaneously.
> A spin lock external_kvm_split_cache_lock is introduced to protect the ca=
che
> enqueue and dequeue.
> (a) When tdp_mmu_split_huge_pages_root() is invoked under write mmu_lock:
>     - Since cache dequeue is already under write mmu_lock in
>       tdp_mmu_split_huge_page()-->tdx_sept_split_private_spte(), acquirin=
g/
>       releasing another spin lock doesn't matter.
>     - Though the cache enqueue in topup_external_split_cache() is not pro=
tected
>       by mmu_lock, protecting enqueue with a spinlock should not reduce
>       concurrency.

Even with the spin lock protecting the cache topup/consumption
operation, is it possible that one split operation context consumes
the top-up performed by the other split operation causing failure with
the subsequent consumptions?

>
> (b) When tdp_mmu_split_huge_pages_root() is invoked under read mmu_lock:
>     Introducing a new spinlock may hurt concurrency for a brief duration =
(which
>     is necessary).
>     However, there's no known (future) use case for multiple threads invo=
king
>     tdp_mmu_split_huge_pages_root() on mirror root under shared mmu_lock.
>
>     For future splitting under shared mmu_lock in the fault path, we'll u=
se
>     the per-vCPU tdx_prealloc instead of the per-VM cache. TDX can levera=
ge
>     kvm_get_running_vcpu() to differentiate between the two caches.
>
>

