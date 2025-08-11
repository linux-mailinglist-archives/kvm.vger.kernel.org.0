Return-Path: <kvm+bounces-54411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD2D9B20C29
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 16:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FD673BBC0F
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 14:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89226273D6B;
	Mon, 11 Aug 2025 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2CmociFb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6586146447
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754922858; cv=none; b=hI23yE77XriT+afuH7ogWNfJSKqwiWYefY4oydpK+X22L7cRXW4bBIodrpsXg1jO6e37jqjyzIWlORRCMcQYyKLyYOchLEqOIagKucmhKwF66RDTSTptLs+N+Xg/+6rNIaIrb1MOHxl1F81NKVxg/yIzvpNGqDOASAupZO551tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754922858; c=relaxed/simple;
	bh=bruREYZz13FVqwhmiTuhvJnq89yjM0qtV4JcUUKirMo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sXR2uCP+8CkQ01XmKwIUO7nOGuMG1CQQCJ5hK4JH7CMepjtFsUFDJeabCipDLhPql7yV1hUpbRZhLM9jDiRX9TpIMi6r9MAfXiSh1DE0PMXsdyoJ2NB+wf0WWze9gV5zHKIkFFmHeJKX7YukDk4rjG7aaresTMawGaGXGTPhY9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2CmociFb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-76bf30ca667so8488541b3a.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754922856; x=1755527656; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3QC/DofyyJ1kIbquP7TygGRJBogDIdpEUbLnTdcdHg=;
        b=2CmociFbY/uRpj9R5kTE42Mvx+/ViT5ZJp8T42BWTq0l8Eclo1rg3BzpAXWiQip89S
         2M8Is78QbEjMUf2RunEIZ6hNzLXcfFIRZGeljaNAeE5+pxUhF+EG3bNdNvgJOams6jI2
         gTc6A6L3xE9t1TOSlxCHVBYZeu+C55KLJ10wmJlfVSqxGWcecA12INiUAkB8+8GWR5/B
         ei1ICP3ky9zDJBewW6gEZ9PDQ15kDV0r13Atyco0tiA93641TJbDrDP/YAwzYgVUm5jG
         ntQYaQ42WaSDyNNIl9/SsLmqWwkCsSsEgKTbiqLE2Ih+wNRbkzKnAzgtiEd9jJqtr9uT
         pVXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754922856; x=1755527656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s3QC/DofyyJ1kIbquP7TygGRJBogDIdpEUbLnTdcdHg=;
        b=gqoxiT9P+14EvJ1JEBBSWw9vnTYwV28saipY1p+Z8ZWxGqEebrMqFVuhpaNQHfyVtt
         Vr6d21FdcEVwUVsYV3WfLLctPSC0bUIF3NXelCTuDBqTZde+jYJW6MeWo+l9Zn6+ruIh
         PqWmeq8Un2xHn1KhbqYLowbVDNH+HW0Qs0AIjKE7LQmNMlngL+8KQh8Pb6Jwvx6SD/HP
         jktXRzwe3GDbtifpqrQMBTGSuP/8HCJmk2/DW6u7AC0n/XhPPx+9vCCL+QOsiHWAxqT9
         8lW0zwWxgnT06Vpp1Yve68Bmp4N35y2SbzK4Mo9BbB8mc44YCzJlM3TozKy8rVNzWZaO
         shRw==
X-Forwarded-Encrypted: i=1; AJvYcCWb78hrh01O8rmXnvKU75O333GWZ4R+z9RjAHSA7dLIlz6dgTGMpPGsyIC60Zi7betUaD8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8waBv/QmTTS5JTC/Vz2l6s3+M6tZvP9U7jfIoXGCS0iEUlnoj
	w+b1KUeQ30eA9lBEe54Bl8zxSUK9WQz9g8XgRxp9P+7NGPxl8C0oyZ0uCdOw4eAr13lZG8d5IXN
	Xc3tW5Q==
X-Google-Smtp-Source: AGHT+IHDzFt+0zXjA0CUz3si8YkwDTRVPFUsiiRh4VZN4Dkprgq2wlq3CPL9ofZgO6/62HnwUQZt6ujhFVk=
X-Received: from pgos21.prod.google.com ([2002:a63:af55:0:b0:b31:d198:ffb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d8b:b0:240:6dc:9164
 with SMTP id adf61e73a8af0-2405502ffeamr23223057637.15.1754922855887; Mon, 11
 Aug 2025 07:34:15 -0700 (PDT)
Date: Mon, 11 Aug 2025 07:34:14 -0700
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250811090605.16057-2-shivankg@amd.com>
Message-ID: <aJn_ZvD2AfZBX4Ox@google.com>
Subject: Re: [PATCH RFC V10 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: Shivank Garg <shivankg@amd.com>
Cc: david@redhat.com, vbabka@suse.cz, willy@infradead.org, 
	akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Shivank Garg wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1].

Is this still actually an RFC?  If so, why?  If not, drop tag on the next version
(if one is needed/sent).

