Return-Path: <kvm+bounces-64621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 07AC4C88A83
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:33:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C1ED44E53C1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3D7318143;
	Wed, 26 Nov 2025 08:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5zz7bJy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IS8FVFTo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028AA307AC6
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146020; cv=none; b=CBertT1ZmZ1zTFLPGlrgOYV0paiCm/zpQNsOUk2MGsIyw7vTTDUcvL+OOAD3uO6d+vqTaEdfpR3VSx5CcVlPHTgaksaFN6Hvkmn0y2KKsZY/wYNAkYd/ZhBVZSfpxuYiEz4Ri8TwailojTg5kq5sMr2CZrfP4eRJZT8z9lA9yOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146020; c=relaxed/simple;
	bh=Ya7XFgB3nBm6kjlRCDNfnF5LANR5gw93p2vTKcToG94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n9KS1PmdZz3OVrVwM0cRBy7Uyf1YfsVZoQC2IOCQVFYAuQzZGosbkOM22jAvSDEKHPIf0rjNW4Wp6nrwDyN4xSZptEiMDBPZ1XVUWgv6d+GclJXB7RacWiygEWghYCiqM4QWLeOyxYSoHTcs/gzFea9gTqhx/TauWeef4JcpPT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5zz7bJy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IS8FVFTo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764146016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0n2z24nKK0nhZ77vlR8hFRXtBZMkuBaZlxaCA0h+aI4=;
	b=M5zz7bJy0pme9E2EasiCUSML1AZVl5KyTNed+CvdgtILfrthJ0G9MxB1LvMwQuClgYVCvK
	/z6NgxCAQLbqU2rblXt5Hw38Ov+mAxMYkw1roQpXKs17e+fN/WcIoxI+YaQPf1jJwd1Bc1
	y/vQYp5QUfhVB+gIdAbnxc6f+42FnqY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-vT_DCK2cMM6Fteplv2KdNA-1; Wed, 26 Nov 2025 03:33:35 -0500
X-MC-Unique: vT_DCK2cMM6Fteplv2KdNA-1
X-Mimecast-MFC-AGG-ID: vT_DCK2cMM6Fteplv2KdNA_1764146014
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b5556d80bso4607359f8f.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764146014; x=1764750814; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0n2z24nKK0nhZ77vlR8hFRXtBZMkuBaZlxaCA0h+aI4=;
        b=IS8FVFTokHIFo5uS+u7XlrSBByqaQND7Zex2hF9tZznmuTUTHYaVvDjqKFf4HlQIL+
         UKQdEmnuO7GlzVnEGjr+OJK9gM/sKtFg+tCP6efWrCmq4luQBg1vkxEUTqIMGgakLOfx
         TVofS1dsyuDZnqlRRi0VySpRa5CexVrvoMLUgQ+qK6hmRVSy25ePVU43UkcBOYw95Fhy
         x5SlvKduTzhz/9/ifNfZEqtj3sgkWKV504pAb7cfBo/bko6loLyJnaxcpXegMYf9Uiux
         RhZKu2EG1gd6NEWU0zEWQ7bnWPxaCTzYzErBAXJYODdDqjgwWpFrkU+8ueqBqirrg3nB
         LLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764146014; x=1764750814;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0n2z24nKK0nhZ77vlR8hFRXtBZMkuBaZlxaCA0h+aI4=;
        b=EouHe6X4AOdDYkmQ++YzZyj+Pzi9uj5FQ5XR1/LWptJTt10+jlMDD+t7dLnckRnSLp
         Ouam5UO8YWltwtORZTFaZhOivLCWZMkCGvmvwYxydbtN4OGRTYV1bA/JUzZa0T2lB8MZ
         UezxsDkUAa73FBfq2OeKPXjE+utTM8AGSlOl2DEJ5zAPvuL9kkl8OAEWfw9HEjyva6ii
         E9yGk5JUVsxtwXpGB8G+DbubkRXNfNQQaXXLG0iOlfM0YC6IEiL5Dey4HQlw/LJEGcPs
         WZNiKDWd9aYM+r1Gs5pcvxt++ev/nZbNRZj7yGFm99cd0EPYU45Fz+WicUPU6n9W2dar
         /JFA==
X-Gm-Message-State: AOJu0YzFMw74oMA6wPyvN/R2m14kjZMDCKZEC5xXoHeWHI+ZMZKmlfaZ
	b6bC5QjSM1D6KnSdodbiFp6IUVBrjO73EYCdnJ8PR4+lpeKnHM+xc9wtkDX3YDTFbP0YZhZMQQS
	V8UZqNYV0B3PdcsSxtHdP6Uwkj8oMl7gy4pB3xD3Z9Ul/rtOGcUAiLPYeThfrEKlT8SKHCfGhL2
	jG51obCy8yU+9ajGtXBBwlHePj2CId
X-Gm-Gg: ASbGnct8+/oGPohlVhwEeqKbfpj0lVLc14oFo6HJ67IyDdASKOIIEhWD3X06KtzqmMP
	kSgj1610TvU74AwUqzXXFKTdBVb1DiMmjhIbDArgpxs18Pz0LYTK8OAvFytiLa6tEs5gnr8F1J0
	F3IgKS5XQnoCxHrYB22Fy11w1VBEKvsviyvGfzU/t2c2ujAdxR7T033Tg9zt7OCQPIK97wpXHVS
	STbOfAqcEqFXQmxPOuHxb4o24Sc7KrOmBAmEWHP0C4LobHlI+4Fnvc6nzI5oMnL2jyof8c=
X-Received: by 2002:a05:6000:2c0c:b0:42b:38de:f00b with SMTP id ffacd0b85a97d-42e0f33f7d3mr6178742f8f.35.1764146013705;
        Wed, 26 Nov 2025 00:33:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3+4nmCwwSpjfHO/NECnawQrSviE0HgVuSp+3QDejyvNpg+xBO4eMBYMxmd+6yLfA46in6b0dTkkPghvI8da4=
X-Received: by 2002:a05:6000:2c0c:b0:42b:38de:f00b with SMTP id
 ffacd0b85a97d-42e0f33f7d3mr6178701f8f.35.1764146013226; Wed, 26 Nov 2025
 00:33:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-3-seanjc@google.com>
In-Reply-To: <20251126014455.788131-3-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:33:20 +0100
X-Gm-Features: AWmQ_bngmY4BVIlPp-11jwoZ-hn9io3yZZjlxx9JFDJgciUkkPiU0W98cMdMfgo
Message-ID: <CABgObfYPpmyTyC94OgSqRPmR_ejuhHg4f_gLL=fo1vb4u8n35w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: guest_memfd: NUMA support and other changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull NUMA mempolicy guest_memfd support, along with a handful of
> guest_memfd cleanups and some tangentially related additions to KVM selft=
ests
> infrastructure.
>
> This will conflict with kvm/master due to commit ae431059e75d ("KVM:
> guest_memfd: Remove bindings on memslot deletion when gmem is dying").  T=
he
> resolution I've been using for linux-next is below.

Pulled, thanks.

Paolo

> --
> diff --cc virt/kvm/guest_memfd.c
> index ffadc5ee8e04,427c0acee9d7..fdaea3422c30
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@@ -623,53 -708,31 +708,49 @@@ err
>         return r;
>   }
>
> - static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct kvm_=
gmem *gmem)
>  -void kvm_gmem_unbind(struct kvm_memory_slot *slot)
> ++static void __kvm_gmem_unbind(struct kvm_memory_slot *slot, struct gmem=
_file *f)
>   {
>         unsigned long start =3D slot->gmem.pgoff;
>         unsigned long end =3D start + slot->npages;
>  -      struct gmem_file *f;
>
> -       xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL)=
;
>  -      /*
>  -       * Nothing to do if the underlying file was already closed (or is=
 being
>  -       * closed right now), kvm_gmem_release() invalidates all bindings=
.
>  -       */
>  -      CLASS(gmem_get_file, file)(slot);
>  -      if (!file)
>  -              return;
>  -
>  -      f =3D file->private_data;
>  -
>  -      filemap_invalidate_lock(file->f_mapping);
> +       xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
>
>         /*
>          * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
>          * cannot see this memslot.
>          */
>         WRITE_ONCE(slot->gmem.file, NULL);
>  +}
>  +
>  +void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  +{
> -       struct file *file;
> -
>  +      /*
>  +       * Nothing to do if the underlying file was _already_ closed, as
>  +       * kvm_gmem_release() invalidates and nullifies all bindings.
>  +       */
>  +      if (!slot->gmem.file)
>  +              return;
>  +
> -       file =3D kvm_gmem_get_file(slot);
> ++      CLASS(gmem_get_file, file)(slot);
>  +
>  +      /*
>  +       * However, if the file is _being_ closed, then the bindings need=
 to be
>  +       * removed as kvm_gmem_release() might not run until after the me=
mslot
>  +       * is freed.  Note, modifying the bindings is safe even though th=
e file
>  +       * is dying as kvm_gmem_release() nullifies slot->gmem.file under
>  +       * slots_lock, and only puts its reference to KVM after destroyin=
g all
>  +       * bindings.  I.e. reaching this point means kvm_gmem_release() h=
asn't
>  +       * yet destroyed the bindings or freed the gmem_file, and can't d=
o so
>  +       * until the caller drops slots_lock.
>  +       */
>  +      if (!file) {
>  +              __kvm_gmem_unbind(slot, slot->gmem.file->private_data);
>  +              return;
>  +      }
>  +
>  +      filemap_invalidate_lock(file->f_mapping);
>  +      __kvm_gmem_unbind(slot, file->private_data);
>         filemap_invalidate_unlock(file->f_mapping);
> -
> -       fput(file);
>   }
>
>   /* Returns a locked folio on success.  */
>
>
> The following changes since commit 211ddde0823f1442e4ad052a2f30f050145cca=
da:
>
>   Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-gmem-6.19
>
> for you to fetch changes up to 83e0e12219a402bf7b8fdef067e51f945a92fd26:
>
>   KVM: selftests: Rename "guest_paddr" variables to "gpa" (2025-11-03 12:=
54:21 -0800)
>
> ----------------------------------------------------------------
> KVM guest_memfd changes for 6.19:
>
>  - Add NUMA mempolicy support for guest_memfd, and clean up a variety of
>    rough edges in guest_memfd along the way.
>
>  - Define a CLASS to automatically handle get+put when grabbing a guest_m=
emfd
>    from a memslot to make it harder to leak references.
>
>  - Enhance KVM selftests to make it easer to develop and debug selftests =
like
>    those added for guest_memfd NUMA support, e.g. where test and/or KVM b=
ugs
>    often result in hard-to-debug SIGBUS errors.
>
>  - Misc cleanups.
>
> ----------------------------------------------------------------
> Ackerley Tng (1):
>       KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
>
> Matthew Wilcox (2):
>       mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
>       mm/filemap: Extend __filemap_get_folio() to support NUMA memory pol=
icies
>
> Pedro Demarchi Gomes (1):
>       KVM: guest_memfd: use folio_nr_pages() instead of shift operation
>
> Sean Christopherson (10):
>       KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_us=
er_mapping()
>       KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
>       KVM: guest_memfd: Add macro to iterate over gmem_files for a mappin=
g/inode
>       KVM: selftests: Define wrappers for common syscalls to assert succe=
ss
>       KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIG=
FPE by default
>       KVM: selftests: Add additional equivalents to libnuma APIs in KVM's=
 numaif.h
>       KVM: selftests: Use proper uAPI headers to pick up mempolicy.h defi=
nitions
>       KVM: guest_memfd: Add gmem_inode.flags field instead of using i_pri=
vate
>       KVM: guest_memfd: Define a CLASS to get+put guest_memfd file from a=
 memslot
>       KVM: selftests: Rename "guest_paddr" variables to "gpa"
>
> Shivank Garg (7):
>       mm/mempolicy: Export memory policy symbols
>       KVM: guest_memfd: move kvm_gmem_get_index() and use in kvm_gmem_pre=
pare_folio()
>       KVM: guest_memfd: remove redundant gmem variable initialization
>       KVM: guest_memfd: Add slab-allocated inode cache
>       KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
>       KVM: selftests: Add helpers to probe for NUMA support, and multi-no=
de systems
>       KVM: selftests: Add guest_memfd tests for mmap and NUMA policy supp=
ort
>
>  fs/btrfs/compression.c                                         |   4 +-
>  fs/btrfs/verity.c                                              |   2 +-
>  fs/erofs/zdata.c                                               |   2 +-
>  fs/f2fs/compress.c                                             |   2 +-
>  include/linux/pagemap.h                                        |  18 +++=
--
>  include/uapi/linux/magic.h                                     |   1 +
>  mm/filemap.c                                                   |  23 +++=
+---
>  mm/mempolicy.c                                                 |   6 ++
>  mm/readahead.c                                                 |   2 +-
>  tools/testing/selftests/kvm/arm64/vgic_irq.c                   |   2 +-
>  tools/testing/selftests/kvm/guest_memfd_test.c                 |  98 +++=
++++++++++++++++++++++++
>  tools/testing/selftests/kvm/include/kvm_syscalls.h             |  81 +++=
+++++++++++++++++++
>  tools/testing/selftests/kvm/include/kvm_util.h                 |  39 ++-=
--------
>  tools/testing/selftests/kvm/include/numaif.h                   | 110 +++=
+++++++++++++++------------
>  tools/testing/selftests/kvm/kvm_binary_stats_test.c            |   4 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c                     | 101 +++=
++++++++++++-------------
>  tools/testing/selftests/kvm/x86/private_mem_conversions_test.c |   9 +--
>  tools/testing/selftests/kvm/x86/xapic_ipi_test.c               |   5 +-
>  virt/kvm/guest_memfd.c                                         | 374 +++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--=
------------------------
>  virt/kvm/kvm_main.c                                            |   7 +-
>  virt/kvm/kvm_mm.h                                              |   9 +--
>  21 files changed, 646 insertions(+), 253 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/kvm_syscalls.h
>


