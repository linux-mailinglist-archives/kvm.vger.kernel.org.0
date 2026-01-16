Return-Path: <kvm+bounces-68350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 313D7D37A1C
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 18:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BC5673080F74
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 17:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1895396B7F;
	Fri, 16 Jan 2026 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3mD1TG0+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5336BCC2
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 17:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584618; cv=pass; b=AgmM3EP8Jt/gi/nxxTq8w8VDGE+zCoNxd7u0uxdD8f6eS66/dyCclFWniEufebUibJJGw6kBZSTJRW4tFXgMAP1g8RvcgZhjJvsMB4TnGpbAzeyUbfJWJfF7sf36bMv8rG09f1YJ5E5+sjg8R8O1XDkvHKJzWXCPi5twK/VENuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584618; c=relaxed/simple;
	bh=dI/o20x9Y2HfQtj2OfDVbvhM6LWHTEelpWzil3w2nKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNEOLmFxyjApMdIzDFTCgB0wMilcy/5Ix2HwZLCDlI7XpG5mhOysbSDxaBgVRPUTYorT7ITfN3rlfccyF1z0vb44zMcM1sfuTzmX4H1fPjSHZtCnh7YlmTo2w3V11d8M9up7thSDyeBgRHP05pODLEWeDng/4a02fUd6R17gPLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3mD1TG0+; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12331482a4dso10042c88.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 09:30:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768584615; cv=none;
        d=google.com; s=arc-20240605;
        b=Qp942iNssi1jX0qV3w0C5wiuLBJIOatCV+qnyWLeF5qBvb6eqMngcO6Vo6P7z8IpcT
         YGqPIOlmKhAtAkpTITEI6pb9gzGzHC5cZzUQSSKKd1X4fAiTA8Xi8i9f+sOT1L58SKTo
         sw0Z48xZB4Pul98Ok3J5GfT0rqCtxUWqargsz2ow8xhJyVwzSP99dvNhKI0y7M4MPomH
         WQ8JjMGVgOxJZIRXXCY41HtpRp3mjGEZZNRPMXOCWg7NcjZATXo/T391g5ONRWdi0JqO
         J23c5fBfGIibypBqzPgkEdh3/a6GCuZ7wNu1/YuUho5GONRyg57Z3U077f6nWzGOGp2A
         MIxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        fh=PdgrYMuLhOrwmldZoQhQJz/IMjowe19YvQzY9w5MYWg=;
        b=MBf1YKHoa1vxORZpebjQVtSkl6ISpTpbykvtiFcJu6SNOb3nMt9UyJeVb/IRbQ9jOy
         VIMaKmM9TtmfkGz05WhPKaWTEXg798+STamBz8H+liwBXfXruv5BfNSPSaY3c1j54zkB
         xCbZl0oIlZ9NBb4mhZQ3xNW4uqPvhLWI5pEKLLNumF5JGpvZhARIYaQ925B4uMvxpzWQ
         KEqky1ZHx/JemkwNZFbg2DrW2Xn9hJ2DJJc3ODF/AsnqjQTHRXLsQvA9M0BkUm6Zal4A
         Z+BBvY+6mf/L6vTkD/67VmKu520R837pl+DsB0iVu8z70WdSNmxqBnfJAaDLJfB5RA/0
         sLBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768584615; x=1769189415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        b=3mD1TG0+dMwPXYG0SmVG0MaKWdwu8Gn/jYBskohb8JXBE6eX7Eu7Gsmtwiziv/aXa3
         KmF1VLqJI1Aa6h/nUMHRrVO6HaSEkG2YcHnX1VHEU6Jl6m4DIUBE5wGna34h0JJq/i8H
         690BhTEvNMAAt2FHhhDemQexF5KOoJ/KZTCSJ+fNRHfUTrQnIr3Ax3x+akY3CYl67nq8
         HLFQUDu2Iiv2q7Ziio0O0IfWPXZmAjtuyTRV2qPwI6r96O7OK1XMt7VpXgpn78Cp49nk
         j3rHfFsTumguC1FAGxZQgXCMHMyYXBWw+kJ7gpjk62sDz/Tybd40IZkraYCB8+BiabVY
         UWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584615; x=1769189415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=53uWNErBo7wI6ZcBPOrPDVWa4idMxyXiq3MzbljTtl8=;
        b=FTDXjUtuDDI8xlVh3dbWYn34RTgnwCgzR2/f2RWbQf6QGE4t76kUalhX4gLVAov+R2
         KnP6IVb/XxtlO69dQPnzYePvT0FuWionhx5at0nA6lRCGSbZ5nC2rLLbAOmY2uzIksP+
         RBBPxqxLKxJD05U8VwfqhqeYlQXbVfQUQ0OyRpOPRBkbxqqgGA8FWAgh8i+8VYPJvOPs
         DiKqw25YCFi2zijAL10JtiEx6BlPjopv7mVX1w1OEMeb2Hmxy1js7jmvL8FcSCEjOqOo
         /2k7t0AjdTDSPm8ZNsyoklUxO2dW/uKw2ARONH4/QVcOOAW0CQIyuMZILARh6LjrW/I1
         4YIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyUXA2GO5XoAgLf/Hy0TJnCkbYnoPPNXvgvWG7xfwdJAwhlJGsXKx6oUcr0YGAvXotsUA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy/XaPINdqyipmH8z+oftym4HuqYq1pRVUugkgn8t+0N1KcZgf
	riqWiukyNIq65NPSis9vhAS8nccg5BvkgtROWNAXLwoVfMcrp4RKQEgJz6ZEgzGpNiMBC9+rLXx
	zCfGHx4j/s0JyBoTGA+KUWJ9qWahp5DhO5TWaIgg9
X-Gm-Gg: AY/fxX6S7aVuO8+Z9ufo0Mcn9AArZdtSmENbY8ffIRK3L2hKvSvytAs1hTSxvqgmHfQ
	lFODltM9yO2AAStkuAKNR9J0XU7LMs3Eo+45TidlGZ5EqwdiCwIWXH7DanA7PB1pW+xf/rMP8XY
	twmkG08E+toECJ0rNvytN/u3IU6aOki3yam6JGVqGfxG+T+Qg9oBZfGNCExJ/zGQxmPN8mlPL0M
	mR3nzRtV6HLkLlbk+RoX1JWTQCBE2h8KXAFXFnHbFlojIFE8AeTgQZPZcbe6eJjoF2Ws47RHlgw
	mGohhwKutXrxelMzpE+mtF6sdDCMGASSehD6Axw=
X-Received: by 2002:a05:701b:2212:b0:120:5719:1852 with SMTP id
 a92af1059eb24-1244b44d299mr107912c88.16.1768584614413; Fri, 16 Jan 2026
 09:30:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
In-Reply-To: <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 16 Jan 2026 09:30:02 -0800
X-Gm-Features: AZwV_Qg33M1rO31dgikgfsTaot12EQbVpaEnX3TxsJMPXzhkvu_Y-NHzJrI17yU
Message-ID: <CAGtprH_qGGRvk3uT74-wWXDiQyY1N1ua+_P2i-0UMmGWovaZuw@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, "david@kernel.org" <david@kernel.org>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"surenb@google.com" <surenb@google.com>, "riel@surriel.com" <riel@surriel.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, "peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "pjw@kernel.org" <pjw@kernel.org>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "willy@infradead.org" <willy@infradead.org>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "wyihan@google.com" <wyihan@google.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"jannh@google.com" <jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, 
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>, 
	"seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 3:04=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
> > Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()
> > ioctl. When set, guest_memfd folios will be removed from the direct map
> > after preparation, with direct map entries only restored when the folio=
s
> > are freed.
> >
> > To ensure these folios do not end up in places where the kernel cannot
> > deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct
> > address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.
> >
> > Note that this flag causes removal of direct map entries for all
> > guest_memfd folios independent of whether they are "shared" or "private=
"
> > (although current guest_memfd only supports either all folios in the
> > "shared" state, or all folios in the "private" state if
> > GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map
> > entries of also the shared parts of guest_memfd are a special type of
> > non-CoCo VM where, host userspace is trusted to have access to all of
> > guest memory, but where Spectre-style transient execution attacks
> > through the host kernel's direct map should still be mitigated.  In thi=
s
> > setup, KVM retains access to guest memory via userspace mappings of
> > guest_memfd, which are reflected back into KVM's memslots via
> > userspace_addr. This is needed for things like MMIO emulation on x86_64
> > to work.
>
> TDX does some clearing at the direct map mapping for pages that comes fro=
m gmem,
> using a special instruction. It also does some clflushing at the direct m=
ap
> address for these pages. So I think we need to make sure TDs don't pull f=
rom
> gmem fds with this flag.

Disabling this feature for TDX VMs for now seems ok. I assume TDX code
can establish temporary mappings to the physical memory and therefore
doesn't necessarily have to rely on direct map.

Is it safe to say that we can remove direct map for guest memory for
TDX VMs (and ideally other CC VMs as well) in future as needed?

>
> Not that there would be any expected use of the flag for TDs, but it coul=
d cause
> a crash.

