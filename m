Return-Path: <kvm+bounces-36172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC459A1831C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:39:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0F503A3D37
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 633521F5438;
	Tue, 21 Jan 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGgyks9m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E091F238E
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737481190; cv=none; b=toetzSdH89MW9M9EOR6AuokRlT52LPULqSbmfHZ2/EiJof+jgItWTebIoAG25GoSeDi/OtBFByBU2WZG/tlHg9mkdTbWVdZgYf4m+QfH+vsk1N8g11i+NQv3H/I4+FD5p7gSEp3L70FW/QzlJ2K7y+dmV7jna2zZy/Ykh7twqQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737481190; c=relaxed/simple;
	bh=J8xsf8i3jZbNizB6xr9MPh/79m5AORC5e9ZkvuMwxMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUCxAqnFHGpl+eSSpiCUuzHc2eX6m4Gn0neZIcyCFfuVie5E88ITN9DNGEHPzn8sSfs2L7iUw6V7J4j6NtCvZHlxatjddhRGtQAxKdLsiSnCML7BiAEjavyM0CA9NR+yL1lEVfJpruLiNYrr0TP3Vc4jda9gzchjnnVqkzAHVLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dGgyks9m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737481187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SJpAcBBlL0DkF/rqvAnTAxWXBbsgTzsvUrzs6vqSQas=;
	b=dGgyks9mp1EwabKGXxR+A8FdFbitQrjmnlzBJfqFF6eoEiTImP2SomzJ4pAhEJriAwrfuv
	lVYSfpvdhLI8WJCbN2WqXsZZD7FVMhwkm6qcDRzsX0l2uD1qrv9UMXHMNZc6/oTiiTqVGL
	Tzqn1UpHNKf5WUVcMq5sfHUHQ3Y+6Cg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-NklMFWjROG29AC6kyYzKoQ-1; Tue, 21 Jan 2025 12:39:46 -0500
X-MC-Unique: NklMFWjROG29AC6kyYzKoQ-1
X-Mimecast-MFC-AGG-ID: NklMFWjROG29AC6kyYzKoQ
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-467b645935fso102819521cf.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:39:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737481186; x=1738085986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJpAcBBlL0DkF/rqvAnTAxWXBbsgTzsvUrzs6vqSQas=;
        b=LLVLk0mrBAnR68SF1x60IZGypqMZZ3tkJBg1iQz9XIVH+p2XifzJAOe+yC7uCKykVV
         wfbVja215KXaSo8OtKIEgj0Mi2VKJLhnZRtUryESz0AoL6PzWPHz0P+MD18a5x3Iyfri
         PzubyRjUNgLsvPeRLNKmIovIA1HEpFFIIFSm9+ZaMBd4rtTVjx40BfoxgSAMypUzOr0K
         FCyt0IRx5MPPC58Lm6lwj3r274QR9GiyNbzA+1LVesL4TdYEAl7/wr56nsAP6Fxzp7Wr
         K3P5gLm7ZPoBXiRcJAErg2PYlQIWPyHV79o+JQKKwuj7mYuNFpayEoloV8RjTPr0xv9W
         GE/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWLetVA1a7E2ahGcSfbfTguVCV9cknVp+Dp0VfjbCJgMEaK3YXeEC1eAr9iO8dpYhzenTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLrKBcziPX55bl5KCadwU5fluXz4on0B9A2yVdkydP/k8Io+Iu
	Tn/Hi8qPtHFZrdrH3jL2eFj53PGkJmKWQPq2jVEVWMSc79En+1B+2EbNZ3bu2EsCgpJS9duzfzU
	7JI28wggVoKJQYr5aUqFd6ojBDSeMeqIWSWr+pEi104a3zeNCdg==
X-Gm-Gg: ASbGncsUCEjts2PPKgEhgT/O3tH10gc6IzTJe2B2ghRuaMkpQ+cPBETw35aXn4rwh1l
	1SJVNe3v+TT507hIHogOGSSiAdPf+CHQHrfjyE43jv63il/pF11mt5h6wDiOVKsAaFJqJ+N24EJ
	J3rHxYtiXifULY68c30qGbrwpcltb5lJYpqV2qCT1TStnqTvSjHxfFbpT4OSARCNtqkv7k2MEXL
	eNYZa/m3s+jjaRVLqNgkkqGoWOsoO3qoTQYb7NXjxzn2Ybn9/vcZfr2hTCSylH8VkWiVnt47N/B
	lWOq3dvnxYvoWt99Lw2reZnryfo0ejs=
X-Received: by 2002:a05:622a:593:b0:46c:716f:d76 with SMTP id d75a77b69052e-46e12a54b3cmr222521681cf.12.1737481184511;
        Tue, 21 Jan 2025 09:39:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGSOzWJGHqmg9LOa5rr5rY8CrqVpDRBLBM3pf64QCL1gsb574jLKWMD64nEaccRrEDcspqvnQ==
X-Received: by 2002:a05:622a:593:b0:46c:716f:d76 with SMTP id d75a77b69052e-46e12a54b3cmr222521401cf.12.1737481184132;
        Tue, 21 Jan 2025 09:39:44 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e1030e4ddsm56320121cf.40.2025.01.21.09.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 09:39:43 -0800 (PST)
Date: Tue, 21 Jan 2025 12:39:40 -0500
From: Peter Xu <peterx@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Isaku Yamahata <isaku.yamahata@linux.intel.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3 07/49] HostMem: Add mechanism to opt in kvm guest
 memfd via MachineState
Message-ID: <Z4_b3Lrpbnyzyros@x1n>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-8-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-8-michael.roth@amd.com>

On Wed, Mar 20, 2024 at 03:39:03AM -0500, Michael Roth wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Add a new member "guest_memfd" to memory backends. When it's set
> to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
> guest_memfd will be allocated during RAMBlock allocation.
> 
> Memory backend's @guest_memfd is wired with @require_guest_memfd
> field of MachineState. It avoid looking up the machine in phymem.c.
> 
> MachineState::require_guest_memfd is supposed to be set by any VMs
> that requires KVM guest memfd as private memory, e.g., TDX VM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
> Changes in v4:
>  - rename "require_guest_memfd" to "guest_memfd" in struct
>    HostMemoryBackend;	(David Hildenbrand)
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  backends/hostmem-file.c  | 1 +
>  backends/hostmem-memfd.c | 1 +
>  backends/hostmem-ram.c   | 1 +
>  backends/hostmem.c       | 1 +
>  hw/core/machine.c        | 5 +++++
>  include/hw/boards.h      | 2 ++
>  include/sysemu/hostmem.h | 1 +
>  7 files changed, 12 insertions(+)
> 
> diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
> index ac3e433cbd..3c69db7946 100644
> --- a/backends/hostmem-file.c
> +++ b/backends/hostmem-file.c
> @@ -85,6 +85,7 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>      ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
>      ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
>      ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>      ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
>      ram_flags |= RAM_NAMED_FILE;
>      return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
> diff --git a/backends/hostmem-memfd.c b/backends/hostmem-memfd.c
> index 3923ea9364..745ead0034 100644
> --- a/backends/hostmem-memfd.c
> +++ b/backends/hostmem-memfd.c
> @@ -55,6 +55,7 @@ memfd_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>      name = host_memory_backend_get_name(backend);
>      ram_flags = backend->share ? RAM_SHARED : 0;
>      ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>      return memory_region_init_ram_from_fd(&backend->mr, OBJECT(backend), name,
>                                            backend->size, ram_flags, fd, 0, errp);
>  }
> diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
> index d121249f0f..f7d81af783 100644
> --- a/backends/hostmem-ram.c
> +++ b/backends/hostmem-ram.c
> @@ -30,6 +30,7 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
>      name = host_memory_backend_get_name(backend);
>      ram_flags = backend->share ? RAM_SHARED : 0;
>      ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
> +    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
>      return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
>                                                    name, backend->size,
>                                                    ram_flags, errp);

These change look a bit confusing to me, as I don't see how gmemfd can be
used with either file or ram typed memory backends..

When specified gmemfd=on with those, IIUC it'll allocate both the memory
(ramblock->host) and gmemfd, but without using ->host.  Meanwhile AFAIU the
ramblock->host will start to conflict with gmemfd in the future when it
might be able to be mapp-able (having valid ->host).

I have a local fix for this (and actually more than below.. but starting
from it), I'm not sure whether I overlooked something, but from reading the
cover letter it's only using memfd backend which makes perfect sense to me
so far.  I also don't know the planning of coco patches merging so I don't
think even if valid this is urgent - I don't want to mess up on merging
plans..  but still want to collect some comments on whether it's valid:

===8<===

From edfdf019ab01e99fb4ff417e30bb3692b4e3b922 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 21 Jan 2025 12:31:19 -0500
Subject: [PATCH] hostmem: Disallow guest memfd for FILE or RAM typed backends

Guest memfd has very special semantics, which by default doesn't have a
path at all, meanwhile it won't proactively allocate anonymous memory.

Currently:

  - memory-backend-file: it is about creating a memory object based on a
  path in the file system.  It doesn't apply to gmemfd.

  - memory-backend-ram: it is about (mostly) trying to allocate anonymous
  memories from the system (private or shared).  It also doesn't apply to
  gmemfd.

Forbid the two types of memory backends to gmemfd, but only allow
memory-backend-memfd for it as of now.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 backends/hostmem-file.c | 8 +++++++-
 backends/hostmem-ram.c  | 7 ++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/backends/hostmem-file.c b/backends/hostmem-file.c
index 46321fda84..c94cf8441b 100644
--- a/backends/hostmem-file.c
+++ b/backends/hostmem-file.c
@@ -52,11 +52,18 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
         error_setg(errp, "can't create backend with size 0");
         return false;
     }
+
     if (!fb->mem_path) {
         error_setg(errp, "mem-path property not set");
         return false;
     }
 
+    if (backend->guest_memfd) {
+        error_setg(errp, "File backends do not support guest memfd. "
+                   "Please use memfd backend");
+        return false;
+    }
+
     switch (fb->rom) {
     case ON_OFF_AUTO_AUTO:
         /* Traditionally, opening the file readonly always resulted in ROM. */
@@ -86,7 +93,6 @@ file_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
     ram_flags |= fb->readonly ? RAM_READONLY_FD : 0;
     ram_flags |= fb->rom == ON_OFF_AUTO_ON ? RAM_READONLY : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
-    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     ram_flags |= fb->is_pmem ? RAM_PMEM : 0;
     ram_flags |= RAM_NAMED_FILE;
     return memory_region_init_ram_from_file(&backend->mr, OBJECT(backend), name,
diff --git a/backends/hostmem-ram.c b/backends/hostmem-ram.c
index 39aac6bf35..8125be217c 100644
--- a/backends/hostmem-ram.c
+++ b/backends/hostmem-ram.c
@@ -27,10 +27,15 @@ ram_backend_memory_alloc(HostMemoryBackend *backend, Error **errp)
         return false;
     }
 
+    if (backend->guest_memfd) {
+        error_setg(errp, "File backends do not support guest memfd. "
+                   "Please use memfd backend");
+        return false;
+    }
+
     name = host_memory_backend_get_name(backend);
     ram_flags = backend->share ? RAM_SHARED : 0;
     ram_flags |= backend->reserve ? 0 : RAM_NORESERVE;
-    ram_flags |= backend->guest_memfd ? RAM_GUEST_MEMFD : 0;
     return memory_region_init_ram_flags_nomigrate(&backend->mr, OBJECT(backend),
                                                   name, backend->size,
                                                   ram_flags, errp);
-- 
2.47.0
===8<===

Thanks,

-- 
Peter Xu


