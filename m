Return-Path: <kvm+bounces-60405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 29BAEBEBEE5
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 00:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9A92C3563AB
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 22:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB6C321F43;
	Fri, 17 Oct 2025 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nvi96oV/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2D52E6CA8
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760740756; cv=none; b=oRTZS5Tz1nrY+4c7dexmdtdE0oDtgsUcHFEeJHcRPqhj5+ArSKnw0AJqC3Cnr+7LMdM4w86AayfiGUQ5B3ybQtaqXDyOzLGohE7WW7IE9g2OViKXi+utDzNIWDk2pgEPIZ2LY/5OGXlVaxbcuVMqbxiO5tBHp0t5j1dyDQ5yGU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760740756; c=relaxed/simple;
	bh=b9r/yE/BB1IF08a6BryFtLN5XeROQ9YihoNyBbj76Sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RTjQJv7L9t/jz+q/6KFRYaq6XMWn5MhkFytPk3r+HVypb0fG2AxP7L4TlKthFZ3ygtDQZ3F0Alq8FSIK5CreatNqIza4/VrP19we+Y5I0YGowxTe74arIP5hXCpDFrZIsi0FYaqQvDgD6cpu4b4xqrTwM6bKG9WHIbRylcVMB4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nvi96oV/; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-57992ba129eso2876656e87.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760740753; x=1761345553; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoqzKQNFCddpnwTwWMxWSsHCHOracpeEvFEON9b+5D0=;
        b=Nvi96oV/wQLmuMbrzVkVmZCgUz1JFd918ZIzyZLQswJeP9VdpnxaPu9C8VBwhAhfFX
         DfSj/ScvyA/6fC89WFsu3ATUYAawzeCF5exGhqm9VLdcONyzZzAPfUdjnwBrvrWLVrC1
         Sd9rM8C6WtiW+YJ9No4t3cRRdq7r1qh6KBaLkJucrcv0XfEfz27Hk0f7jCy9XekNDWfa
         v0Ny4F2NbvRgL9eYy2Ey46W0K0rWHgsjPK8tQPipKhz1KIBKsjT4yvM/U5uVVXbtH+x0
         U3hXWPeBx7r+S5NLucwe0GwseAp0Vtr4sfQ3YntFF0SdvcpjAPdyNkKqbVUuyv5YmUY2
         wIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760740753; x=1761345553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BoqzKQNFCddpnwTwWMxWSsHCHOracpeEvFEON9b+5D0=;
        b=IZ5oOqNoCdqXqJdAEbzIiphksNylsDTETvSBy8/J+9B9JHjvfNqmb4zcvDGcic08wz
         zXY86e3/1rCZ1uoTasFftfzmr2hDWrDSN6ZLy9En/M753bRmhB+v8tOVNXwXSl9KDRkl
         O4MRDiU9jlXtu8F/2/mnenr3eAMAI3pf7Uuhw6BY7B/WMX9TU0TUwqvh/wc7j9t8Z7gg
         5nQny16/DKIzJ/8XXiGTa+41kRZ7wBJbScmJ8H1BJXq+dcuEII0wI768N79nfWyvq2YA
         KEPPSUW7w1qbiCq7ULQf3uhG/1GjxkKCQxWfL7m/9CIDCpMJpxy0dQXASoBjFx2zQpma
         oHAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVt5FtYVO8ARlkaSwkHhnaea3A5PBBiuvByrSYQ7SN4tTDRQrsbLIeBLSgkzUVbdavA7P8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7JM+FkqiJQKBfoh4FvLvUC1HOtffZB8v8ggka3ZqDmja2BDv/
	CmmAFtLRwqFlXVyPyYCEt8W3Y/ebWpGbbYrQeagJAcZNm/Ko0L9k1XBrT/B4RW44GiUAn6IuV4S
	HnLHgdw5+j/Xb3vJjGp6FirtAiD3sEdEe9dwX9HmM
X-Gm-Gg: ASbGnctV8h8RvjKAmicc+XZ7pyvr77zN2QbSZkcDIJirr/m8D8o4PK+XK6cEdQGBaMu
	Gs0fT6L27SPGU8PpTdrIugoR+IqgPkqCGo2UDwrpuqfJPZIzxec1Y+j5xnsnyqU3qp6hpDkM9UM
	L/8rnDsK37EuWLrgkN73hgHKuXMGjH/ZRQzgGq2+AqTu+II7EihA7epH03qcgi4pNbTwt66W8DR
	2+nEDFIIhBY4nu1OqGNGkOkidkpivYS7EzlIzZ4X0baTTD6ngEn55T/eGL/Sa/JE5tRhgcr
X-Google-Smtp-Source: AGHT+IHS0n4/1zDhYDG11j/phEtQioVcSLIhzKZxyKRafka2oa60va2EzlIsG9E+0PXvk8E7U9fUvkCXKxOf+kRpoho=
X-Received: by 2002:a05:6512:131d:b0:590:6119:6b73 with SMTP id
 2adb3069b0e04-591d85aa092mr1710058e87.48.1760740752394; Fri, 17 Oct 2025
 15:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
In-Reply-To: <aBPhs39MJz-rt_Ob@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 17 Oct 2025 15:38:45 -0700
X-Gm-Features: AS18NWAC2AsnIEyOuBJBf6AwyLhxj7CRd7TcYAURWBeq_wPcJYz0GvazO3M1Rc0
Message-ID: <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Thu, May 01, 2025, David Matlack wrote:
> > This series renames types across all KVM selftests to more align with
> > types used in the kernel:
> >
> >   vm_vaddr_t -> gva_t
> >   vm_paddr_t -> gpa_t
>
> 10000% on these.
>
> >   uint64_t -> u64
> >   uint32_t -> u32
> >   uint16_t -> u16
> >   uint8_t  -> u8
> >
> >   int64_t -> s64
> >   int32_t -> s32
> >   int16_t -> s16
> >   int8_t  -> s8
>
> I'm definitely in favor of these renames.  I thought I was the only one t=
hat
> tripped over the uintNN_t stuff; at this point, I've probably lost hours =
of my
> life trying to type those things out.

What should the next step be here? I'd be happy to spin a new version
whenever on whatever base commit you prefer.

