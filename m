Return-Path: <kvm+bounces-53846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC896B18503
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 17:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4271BA80E5B
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 15:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0FA273803;
	Fri,  1 Aug 2025 15:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vr5g86bw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704DD14B96E
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754062389; cv=none; b=bV/YMOrdEujAWa2BTnC1AsFkxlK7Iq89I6ItUlcCkaiU+Q0NNdVPVvCrT3Upy6wka7lpYgLqZyKbkEsa8CgD/WubABMoliIPQ+c3QEiGIoTLvQzZed39cDjmw36P/1dJ8syIwhvWw61EmCxVtDVneXOaai1rryx3XdZq/nn4HQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754062389; c=relaxed/simple;
	bh=76zm5mLsx7bheh6RWXQy50AwQ/nwArGGKpe4OQEkatM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=aYlr8YbYMNeBQNeOpVWh6c9P3oNe7W3JDfXnIEdboex6n79hnTQEoT2AHMVwzXZqnRGzRRfYJVMBMY62Yu1Q0CwWey7uxA1Ax8EjUQob9dOjsk5s46BsbSwGSeKPW18ODMH2OSVbdd4cUep3HgogQr/5tMgP1XNvchA1qlaVmY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vr5g86bw; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-32ca160b4bcso23633201fa.3
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 08:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754062385; x=1754667185; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8l68DoeiceI3IKbSzGhlcOAyQDPZ9AokScWPeUJfCvI=;
        b=vr5g86bwpIl2LXDIebUD37qzLFb3f7UA3VvE+fZoqf2Dwv+CuI/cj0ohNBRTqQ0sJT
         JKYotsrCyOTTXYZifeMjV8CwSRqCvMSLA+whf/aIv8WuVP1tWWzxE/gl89SkDmFtvoOC
         UgUxJ84puM4iAWrwe5m2mMsaU2qcKokWtfWvkdmIAvKFz1b0+3SOp5JQuXaATD0yF9RK
         8o3s+lxJ/iN2bUbZowFkh8Aw/SM8+dTOQYCeEYsstroSsqXRqNPd9d4u9qtgXYutuUqQ
         86tr/wMRnRqNWq3z3AmogE9YALuUB6LX/VD/6/hEz4SQ/9OIQg8D5Nd4fOV2PsN7OKsS
         OgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062385; x=1754667185;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8l68DoeiceI3IKbSzGhlcOAyQDPZ9AokScWPeUJfCvI=;
        b=boSC9v6RpskCrB3CQwB43ftvHOVP4GNgF2LXzi9vGm6WW8G34Rh/I/ZM20Ps7PcYnm
         zVbju2D+NgQFHYiRKyJas8Bdei2aY53j0agp/779x95cC/wREjVX+8YlYEbie8x/IAsw
         D+5EE890DjnY6/AHpPIxEmSZqLTxul2+C67xqjAB6DNdT5j9Vy6qQpR8BJzNGEM9+rdp
         C9Y9/yzHg5tsPfWhGCXoIGsyvBBrCKzuDytwEo/Vca2oBBsHyPFLA5De1oFy2MEBnhyo
         7e4IZACzw3AFcrF78BPnsgWGk/B+wpo52hGlftfIsqZmN/jj1DZBFPdyfO8ln5A/Spgq
         b9zg==
X-Forwarded-Encrypted: i=1; AJvYcCUpIKc1MFxhObm2j0q6sIddKwC1wLXy/gvOHggjHC1lMURuJmnyvycgVr9oBZHdD2q2zGg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe2ku7YM/Xwh8rmHvUQtS3PQGv7vfu/I6k+ibbL7CQ/Jyg+1IV
	OhwBq0xERM+8qKC4hsydZp/0CUsIYjD0JzGvP/hYotd7CUBMex+lgPLu+mobWBM9VuoG0xOF/8l
	eoWHDiBNckOZmEaA4L/hbOtJrlJvP2/dd8tI8bhCH
X-Gm-Gg: ASbGncvGPBgB1YA5jpJyE4IlUrojYiuE0EFAwMW9Rf+IEe7rMFPcsZyhHaz2DGlTaG3
	c+UFN+lg8m+qKOldTNknkEu5nAcmfKkfdKWb+clRBKtNWvSpnzNnx4LEp5rTO/NFnGP4WDg12g1
	uLnVi+N+LaJHw7nych7zX9LQ6f+tHQgyilDKoaYz37e4m9Yt0u9ZTKZZvRKJCgHyvuW6nyYTh17
	zT+ueXA21x553oQFA==
X-Google-Smtp-Source: AGHT+IElqGqJCtZOhO3R6EOALjhIxAosCdG4c6JAw0Ii5GIvvlZsjTd7NWmVyt9CTRdEgA600P6iKWvTGZcKiA6jmn0=
X-Received: by 2002:a05:651c:4117:b0:32e:aaa0:b06a with SMTP id
 38308e7fff4ca-33224a5e95emr27853181fa.8.1754062384765; Fri, 01 Aug 2025
 08:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 Aug 2025 08:32:37 -0700
X-Gm-Features: Ac12FXzLKnSwpLBskXSaJfx0o2ePwkZV7fNIT0lZA44HGFkBJgr6jkivWR4r114
Message-ID: <CALzav=d_Bjfy=6if+rPmxgGJfUV8ijnQ5hf40HoH6Yozg_H6Ew@mail.gmail.com>
Subject: Live Update MC (LPC): Call for Presentations
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>, kexec@lists.infradead.org, 
	Linux MM Mailing List <linux-mm@kvack.org>, linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Cc: "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, David Rientjes <rientjes@google.com>, 
	Chris Li <chriscli@google.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Josh Hilke <jrhilke@google.com>, Changyuan Lyu <changyuanl@google.com>, 
	"graf@amazon.com" <graf@amazon.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, 
	"jgowans@amazon.com" <jgowans@amazon.com>, "ptyadav@amazon.de" <ptyadav@amazon.de>, 
	"jgg@nvidia.com" <jgg@nvidia.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu US <witu@nvidia.com>, 
	"anthony.yznaga@oracle.com" <anthony.yznaga@oracle.com>, dave.hansen@intel.com, 
	David Hildenbrand <david@redhat.com>, Frank van der Linden <fvdl@google.com>, jork.loeser@microsoft.com, 
	Junaid Shahid <junaids@google.com>, pankaj.gupta.linux@gmail.com, 
	Pratyush Yadav <pratyush@kernel.org>, kpraveen.lkml@gmail.com, 
	Vishal Annapurve <vannapurve@google.com>, Steve Sistare <steven.sistare@oracle.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

We are pleased to announce that there will be a Live Update Microconference at
Linux Plumbers 2025: https://lpc.events/event/19/contributions/2004/

This microconference aims to bring together developers from across the kernel
to discuss topics related to Live Update support in Linux. Live Update is a
specialized reboot process where selected devices are kept operational and
kernel state is preserved and recreated across a kexec. For devices, DMA and
interrupts may continue during the reboot.

The primary use-case of Live Update is to enable hypervisor updates in cloud
environments with minimal disruption to running virtual machines. During a Live
Update, a VM can pause and its state is stored to memory while the hypervisor
reboots. PCIe devices attached to those VMs (such as GPUs, NICs, and SSDs), are
kept running during the Live Update. After the reboot, VMs are recreated and
restored from memory, reattached to devices, and resumed. The disruption is
limited to the time it takes to complete this entire process.

With Live Update infrastructure in place, other use-cases may emerge, like for
example preserving the state of GPU doing LLM, freezing running containers with
CRIU, and preserving large in-memory databases.

Topics to be discussed at the microconference include:
  - Live Update Orchestrator (state machine, userspace API, implementation)
  - Generic infrastructure for preserving file descriptors across Live Updates
  - Live Update support for specific files (memfd, iommufd, VFIO cdev, etc.)
  - Integration of Live Update with the PCI subsystem and Linux device model
  - Integration of Live Update with IOMMU and Interrupt Remapping drivers
  - Serializing, deserializing, and versioning kernel state that is passed
    across Live Update
  - Persistence of movable memory
  - Leveraging suspend/resume functionality for device state preservation
  - Optimizing kernel shutdown and boot times
  - Support for Confidential VMs
  - Automated testing

Please submit your proposals at https://lpc.events/event/19/abstracts/ and
select "Live Update MC" as the track. Submissions are due on or before 11:59PM
UTC on Wednesday, September 10, 2025.

We look forward to seeing you at LPC!

