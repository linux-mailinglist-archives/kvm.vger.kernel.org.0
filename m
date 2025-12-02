Return-Path: <kvm+bounces-65117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C02C9BEFF
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 16:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 82BAC4E3532
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 15:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C50425EFBE;
	Tue,  2 Dec 2025 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K3wuuAXp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E514F252292
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764689234; cv=none; b=RWWYTjnIfjP9Gy7JOJmxQZ99ij8W8U6tF7V6ExtYjkCxxXQzXGwp8RNnSTJs2KefilwPP2xvPWHL5AIoF29+EAbUNg1/jvBbAUeLA5FON3hu3FQwuJyi9lpdJDFDrctUqE2/GLFHrbdkGEtQqTbhzLe0bEr1aYpVpnfhE9rIpyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764689234; c=relaxed/simple;
	bh=H+rBOGQRY8iwXaLnmYSjB3wNuaemUT2VNQocG5svCK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=U77GY5whCpGh4ItDkWWJBajRYRCIde09+j9spcz17hi+LeZB8eWuv37VRn1HkzPZLIlXTzyDLvrTMYRYFhVx7kn94Xye3AIWJePFbavX92pV6MsAL6tLl4He7RdD4dLiJCTFzfEKAo7/XKI1f/rrgC9Su+QeTMgEcNVNdfTG1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K3wuuAXp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-341aec498fdso6554850a91.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 07:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764689232; x=1765294032; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Orny64yCul+MV1Pms4wehlYly0YZEji2U1uJ3NC+LQ8=;
        b=K3wuuAXpZ/s04O1Q56EncQcVmX+v1mnED0CECG9mg9VRJlbCeQZQwq4yn61T0rbTnf
         ChQTnGLwgQ5FwJW5ZeUpMnIZ02KgBuyNaQo0ZmwvxhzoOkBoXgyZ0Dtn0HBHAjhMC1Po
         stSoMrrDKGRwg289RdroeETmRSqZTKtIumL4If6kIlbS+7ipUcc9J3/MFndZFybpxcFB
         mOxGS7Wserq0J3qn655HhH690Q5AmWrxpoNi5WURrK3dYNZuvYifZmDdepdAOijvoEmn
         yRjqlV/NMUI46VB0jFr2YQIm2SvOsOIvr1bh8owpcyNCfH3kjZDgrRMqeRqYm2ht6fTA
         GmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764689232; x=1765294032;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Orny64yCul+MV1Pms4wehlYly0YZEji2U1uJ3NC+LQ8=;
        b=NRTA/ZO8S6Z7fY/z8gaOJ0b43vReUJGYkRZ+v7OnVR3Qt3HqUl2FPeQomDj9uSjMqS
         7X/I99RfEjz0eleNhY0mz8opIH2YNLjhS24jllCmH9STEy7vSMGpflPOBHTwa7iFqRp0
         gWBIQxSKJjzBWaFNEvRGnA0iJvG/8W5sOewA4CZAZ60g5jWYEPYH4rSu+YSX8SBnp31e
         SgmYGvWe67Vf0cj4de6aTzecpMn/R7DSwnOh3iooS4h4dhP+yjrGg3faSVYC9MFosd0L
         RXa6X6z8X/REp0BEMFmAV9xCa89aCTlvjYVQDLNdDtG4Lvg3PGJ1eDWVmOLCgSVGAzLl
         v11g==
X-Forwarded-Encrypted: i=1; AJvYcCUDJC9u/QkeQfS/k6pYBfZHuY7l6nPL5GBNiEmoFrjo5GnEsCxkLdudjMGna0uqviiqgSg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqi9eTjUsxHRkZdBUsKvpvsxnSQ97l6HmUAcsLUKx4I/XtLrdv
	nC6PEGfuwyoTZZcFc4GqiHrrhrqezrX9Ik4x0sbGyz+nxucPg32dru7clZFFTtQPFE4u78qARgr
	cFo4ENw==
X-Google-Smtp-Source: AGHT+IGQgBm2f7MBgeNPNiOST5+5uXlbW4GbuouSx+idpH0+WuLL2SiEYxWcT+xKLnx1WXLgUzDyjncR9+A=
X-Received: from pjbgk19.prod.google.com ([2002:a17:90b:1193:b0:347:76e2:5ff6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f88:b0:341:8c15:959e
 with SMTP id 98e67ed59e1d1-34733f305bfmr44774155a91.17.1764689232200; Tue, 02
 Dec 2025 07:27:12 -0800 (PST)
Date: Tue, 2 Dec 2025 07:27:10 -0800
In-Reply-To: <20251202020334.1171351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202020334.1171351-1-seanjc@google.com>
Message-ID: <aS8FTggpT_7cY3cr@google.com>
Subject: Re: [PATCH 0/2] KVM: Fix a guest_memfd memslot UAF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="2/MWZxQFC6AlmTv/"


--2/MWZxQFC6AlmTv/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2025, Sean Christopherson wrote:
> Fix a UAF due to leaving a dangling guest_memfd memslot binding by
> disallowing clearing KVM_MEM_GUEST_MEMFD on a memslot.  The intent was
> that guest_memfd memslots would be immutable (could only be deleted),
> but somewhat ironically we missed the case where KVM_MEM_GUEST_MEMFD
> itself is the only flag that's toggled.
> 
> This is an ABI change, but I can't imagine anyone was relying on
> disappearing a guest_memfd memslot.
> 
> Patch 2 hardens against the UAF, and prepares for allowing FLAGS_ONLY
> changes on guest_memfd memslots.  Sooner or later, we're going to allow
> dirty logging on guest_memfd, so I think it makes sense to guard against
> that so that whoever adds dirty logging support doesn't forget to unbind
> on a FLAGS_ONLY change.
> 
> I'll respond with the syzkaller reproducer (it's comically simple).

And almost forgot...

--2/MWZxQFC6AlmTv/
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="reproducer.c"

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

uint64_t r[3] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff};

int main(void)
{
  syscall(__NR_mmap, /*addr=*/0x1ffffffff000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200000000000ul, /*len=*/0x1000000ul,
          /*prot=PROT_WRITE|PROT_READ|PROT_EXEC*/ 7ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200001000000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  const char* reason;
  (void)reason;
  intptr_t res = 0;
  if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {
  }
  //  openat$kvm arguments: [
  //    fd: const = 0xffffffffffffff9c (8 bytes)
  //    file: ptr[in, buffer] {
  //      buffer: {2f 64 65 76 2f 6b 76 6d 00} (length 0x9)
  //    }
  //    flags: open_flags = 0x0 (4 bytes)
  //    mode: const = 0x0 (2 bytes)
  //  ]
  //  returns fd_kvm
  memcpy((void*)0x200000000000, "/dev/kvm\000", 9);
  res = syscall(__NR_openat, /*fd=*/0xffffffffffffff9cul,
                /*file=*/0x200000000000ul, /*flags=*/0, /*mode=*/0);
  if (res != -1)
    r[0] = res;
  //  ioctl$KVM_CREATE_VM arguments: [
  //    fd: fd_kvm (resource)
  //    cmd: const = 0xae01 (4 bytes)
  //    type: intptr = 0x0 (8 bytes)
  //  ]
  //  returns fd_kvmvm
  res = syscall(__NR_ioctl, /*fd=*/r[0], /*cmd=*/0xae01, /*type=*/0ul);
  if (res != -1)
    r[1] = res;
  //  ioctl$KVM_CREATE_GUEST_MEMFD arguments: [
  //    fd: fd_kvmvm (resource)
  //    cmd: const = 0xc040aed4 (4 bytes)
  //    arg: ptr[in, kvm_create_guest_memfd] {
  //      kvm_create_guest_memfd {
  //        size: int64 = 0x200001fe0000 (8 bytes)
  //        flags: int64 = 0x0 (8 bytes)
  //        reserved: buffer: {00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00} (length 0x30)
  //      }
  //    }
  //  ]
  //  returns fd_kvm_guest_memfd
  *(uint64_t*)0x2000000001c0 = 0x200001fe0000;
  *(uint64_t*)0x2000000001c8 = 0;
  memset((void*)0x2000000001d0, 0, 48);
  res = syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/0xc040aed4,
                /*arg=*/0x2000000001c0ul);
  if (res != -1)
    r[2] = res;
  //  ioctl$KVM_SET_USER_MEMORY_REGION2 arguments: [
  //    fd: fd_kvmvm (resource)
  //    cmd: const = 0x40a0ae49 (4 bytes)
  //    arg: ptr[in, kvm_userspace_memory_region2] {
  //      kvm_userspace_memory_region2 {
  //        slot: kvm_mem_slots = 0x4 (4 bytes)
  //        flags: kvm_mem_region_flags = 0x4 (4 bytes)
  //        paddr: kvm_guest_addrs = 0x80a0000 (8 bytes)
  //        size: len = 0x2000 (8 bytes)
  //        addr: VMA[0x2000]
  //        guest_memfd_offset: int64 = 0x4000 (8 bytes)
  //        guest_memfd: fd_kvm_guest_memfd (resource)
  //        pad1: const = 0x0 (4 bytes)
  //        pad2: buffer: {00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00} (length 0x70)
  //      }
  //    }
  //  ]
  *(uint32_t*)0x200000000180 = 4;
  *(uint32_t*)0x200000000184 = 4;
  *(uint64_t*)0x200000000188 = 0x80a0000;
  *(uint64_t*)0x200000000190 = 0x2000;
  *(uint64_t*)0x200000000198 = 0x200000ffc000;
  *(uint64_t*)0x2000000001a0 = 0x4000;
  *(uint32_t*)0x2000000001a8 = r[2];
  *(uint32_t*)0x2000000001ac = 0;
  memset((void*)0x2000000001b0, 0, 112);
  syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/0x40a0ae49,
          /*arg=*/0x200000000180ul);
  //  ioctl$KVM_SET_USER_MEMORY_REGION2 arguments: [
  //    fd: fd_kvmvm (resource)
  //    cmd: const = 0x40a0ae49 (4 bytes)
  //    arg: ptr[in, kvm_userspace_memory_region2] {
  //      kvm_userspace_memory_region2 {
  //        slot: kvm_mem_slots = 0x4 (4 bytes)
  //        flags: kvm_mem_region_flags = 0x1 (4 bytes)
  //        paddr: kvm_guest_addrs = 0xffff1000 (8 bytes)
  //        size: len = 0x2000 (8 bytes)
  //        addr: VMA[0x2000]
  //        guest_memfd_offset: int64 = 0x8 (8 bytes)
  //        guest_memfd: fd_kvm_guest_memfd (resource)
  //        pad1: const = 0x0 (4 bytes)
  //        pad2: buffer: {00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  //        00 00} (length 0x70)
  //      }
  //    }
  //  ]
  *(uint32_t*)0x200000000240 = 4;
  *(uint32_t*)0x200000000244 = 1;
  *(uint64_t*)0x200000000248 = 0xffff1000;
  *(uint64_t*)0x200000000250 = 0x2000;
  *(uint64_t*)0x200000000258 = 0x200000ffc000;
  *(uint64_t*)0x200000000260 = 8;
  *(uint32_t*)0x200000000268 = r[2];
  *(uint32_t*)0x20000000026c = 0;
  memset((void*)0x200000000270, 0, 112);
  syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/0x40a0ae49,
          /*arg=*/0x200000000240ul);
  return 0;
}

--2/MWZxQFC6AlmTv/--

