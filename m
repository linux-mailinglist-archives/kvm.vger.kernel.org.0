Return-Path: <kvm+bounces-62087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D201C366B3
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C47B762589B
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A519933A002;
	Wed,  5 Nov 2025 15:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ILGDIP5O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDFD338939
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762356398; cv=none; b=gAJ7g9v+ztMG/Xehgr79oFGtWrj8qfBTwAVGlsLApyEYmGIKJRJvs9VU7c7Ud+kUnEvLF/fOVTpWqRea7sEuXAyseG5GsYfqsO3NDq7qXsa90LaPRgNXFqwYh5iP7Htq5XoZjbIkdZag6ayaNDkRifzupMEvfWLg2zjliW6sSpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762356398; c=relaxed/simple;
	bh=d8JWxeRGmjq8jXPHzr0bSzSADeEyMQIUeCD2xQhaO6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vz2+ZtkeDhkhw+6M7n/+WreuCz5YkEm9npiSWjNGDQxvjmiJeuZx8AmkbmBx7bXwln7E/enjZC+lEUbnto8HZ+P0d45ArTWL5IUVldzkjA14hz8jn/XvumHiI/A0XGXFl8iJ0nM1Tdoj15q2DrmjCRJNbx2pCURCL2bADq/adgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ILGDIP5O; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34176460924so2154324a91.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 07:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762356395; x=1762961195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dmjmfo22QwufKip+RFN2GwcKXDk7+fDMohFzNqFh1wo=;
        b=ILGDIP5O5BP+SYZYgKaOIaimg87TU8QKC8EJF/uP7rDmTzgvxHRnjh26J0McWVE2tX
         xjdiyiYpL9TXxeCED6TAeEs8jD6PIIhWiDvgW1l4mcsTpVDqohWa8u8IQD8dOmuRI9Td
         uDNxLQRlPc1dydrRYVGUNHzgHi3xAr5yNki7VN6iKVXwlAx1pN1l999r5o3knbR0QoT4
         Z2ImKQQjei9H+0BOVHp7DXRQ1IgTVPloVQk3p9UjN3JreJpiEQt3YYxwp6cbLRpB639k
         AzbBvE8/jpXoFZPNwmqGculRqBCQzzCh7DC6qg7Qt8aZZQ14Z5eDxix6hs1K8iTqhfqx
         YhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762356395; x=1762961195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmjmfo22QwufKip+RFN2GwcKXDk7+fDMohFzNqFh1wo=;
        b=Ql88NzzH6qSvcoEpVBS6ZqwSolXRvXo1poXYxIvWEG5y+w4lZ6K/fD5TF8zmgZAI2H
         ZdpK9zgbM+/UOjOFeo/br/cEM8OhtMpZ3tbijK4kENcTJPv1wO/xWvqU9fz4pclb2v7I
         5SxUBbPWQYEu7BD1rtjwmCH5zBr9P+BMoHb5CwMeoxnKlQCQEd7FIuJraIWzTxu8pG6w
         4breyMYciBN4sp/ZWBvBogCiGb7IcR6nl4CWM0aRRunZXKhugUrUh9iqjhlRMvzk+GAb
         VGbIes0NED/RF9//m8kRGyWi1q3HmI710JsEIG3SvM5VixxqBNlu2QaJFH+0+hQuby6q
         /zhA==
X-Forwarded-Encrypted: i=1; AJvYcCXlpdZ8nfFcatEVl3nHaLfahxzuAeV/8RPu5LrfQosd10xzXiBdhUXpiFLZOYhsU8FmmiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+r/YuP1N3Mz+hW1QOLH2DTDFiFQnZNGxwIQQa0c9yhAARZDER
	h+7d7Zl6+2mbWutLmJK42eYjurwyPFPirMRBDl8YNSyAUF9AmJDVRlf4E8YsbLmqP0hsja+J0Ya
	Gcht6fQ==
X-Google-Smtp-Source: AGHT+IEksiko2nLkYHDcuQoizh41Xk4dhEPlLcSxUswEaWhydqjlp9gNPv6q5VYl/pXem0FsGEVxprPZGIk=
X-Received: from pjbtc7.prod.google.com ([2002:a17:90b:5407:b0:340:b503:505f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384d:b0:340:9cf1:54d0
 with SMTP id 98e67ed59e1d1-341a6c08e65mr4623520a91.1.1762356395074; Wed, 05
 Nov 2025 07:26:35 -0800 (PST)
Date: Wed, 5 Nov 2025 07:26:33 -0800
In-Reply-To: <aQsBI1/SIXGbf9nA@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-5-seanjc@google.com>
 <aPhjYcOFjL1Z8m2s@yzhao56-desk.sh.intel.com> <aQMi/n9DVyeaWsVH@yzhao56-desk.sh.intel.com>
 <aQo-hus99rE7WBgb@google.com> <aQr9jW/7zwWJaDFf@yzhao56-desk.sh.intel.com> <aQsBI1/SIXGbf9nA@yzhao56-desk.sh.intel.com>
Message-ID: <aQtsqXPaZo2SMdJU@google.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 05, 2025, Yan Zhao wrote:
> On Wed, Nov 05, 2025 at 03:32:29PM +0800, Yan Zhao wrote:
> > On Tue, Nov 04, 2025 at 09:57:26AM -0800, Sean Christopherson wrote:
> > > On Thu, Oct 30, 2025, Yan Zhao wrote:
> > > > On Wed, Oct 22, 2025 at 12:53:53PM +0800, Yan Zhao wrote:
> > > > > On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> > > > > > Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> > > > > 
> > > > > Hi Sean,                                                                         
> > > > > 
> > > > > Will you post [1] to fix the AB-BA deadlock issue for huge page in-place
> > > > > conversion as well?
> > > 
> > > If you (or anyone) has the bandwidth, please pick it up.  I won't have cycles to
> > > look at that for many weeks (potentially not even this calendar year).
> > Got it!
> > On the other hand, do you think we can address the warning as below?
> > The code is based on [2].
> Hmm, updated the diff.
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 7b4a4474d468..543e1eb9db65 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -853,6 +853,9 @@ static int kvm_gmem_init_inode(struct inode *inode, loff_t size, u64 flags)
>         inode->i_size = size;
>         mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
>         mapping_set_inaccessible(inode->i_mapping);
> +       if (flags &GUEST_MEMFD_FLAG_MMAP)
> +               lockdep_set_subclass(&inode->i_mapping->invalidate_lock, 1);
> +
>         /* Unmovable mappings are supposed to be marked unevictable as well. */
>         WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
> 
>  
> > As noted in [3], the only scenario can trigger the warning after [2] is when a
> > process creates a TDX VM with non-in-place-conversion guest_memfd and a normal
> > VM with in-place-conversion guest_memfd. The two invalidate_lock's don't contend
> > with each other theoretically.

Hmm, no, I think we need to hoist gup() call outside of filemap_invalidate_lock(),
because I don't think this is strictly limited to TDX VMs without in-place
conversion.  Even with in-place conversion, I think KVM should allow the source
page to be shared memory, at which point I believe this becomes a legimate AB-BA
issue.

In general, playing lockdep games with so many subsystems involved terrifies me.

> > [2] https://lore.kernel.org/all/cover.1760731772.git.ackerleytng@google.com/
> > [3] https://lore.kernel.org/all/aQMi%2Fn9DVyeaWsVH@yzhao56-desk.sh.intel.com/

