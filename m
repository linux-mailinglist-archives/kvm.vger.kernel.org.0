Return-Path: <kvm+bounces-8681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1D8F854A74
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 14:25:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B58D28B16D
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 13:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABD954BCB;
	Wed, 14 Feb 2024 13:24:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F7054745;
	Wed, 14 Feb 2024 13:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707917085; cv=none; b=haFfAVNY/+LI2EC/fRVQ9FuA7uMrdUg5eQoNkBVryaewAgCMHTxY3JJx8mWeTYqn77XvitPzzLzMq4hBC9mGbFBZ5/PQV9sT1e+1N5ZFl3sKXeuYH18OBavMbiEAaqIaiUb+MhvF8R22W4Ual/KbDg9HgUDWFgn13Ycj+X33XTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707917085; c=relaxed/simple;
	bh=FsQPWaH/zjqZ0YupICrU4eLUep9haB5a31ExMi0u37U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GdwHFsUNX3N73rEf6REh2HSgDmH2stEeiKZHffX15SxlpwGuA0ezsqTKDsmyWdZjwJH5b/lVXZNCXB/A65Ui+1MKUwBAf9MkdPKjBrkI3oBtKWT9olQeWFBatqoKVnPd/zGMYhARFaYghab2lhmfXoOQm4VcSjHxIf9AYJv3VyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 1DFDB48171;
	Wed, 14 Feb 2024 14:17:22 +0100 (CET)
Message-ID: <19ac27b1-1da1-4b31-a0b2-c25574515ac5@proxmox.com>
Date: Wed, 14 Feb 2024 14:17:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] KVM: x86/mmu: Pre-check for mmu_notifier retry
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Yan Zhao <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>,
 Yuan Yao <yuan.yao@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Yu Zhang <yu.c.zhang@linux.intel.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
 Michael Roth <michael.roth@amd.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 David Matlack <dmatlack@google.com>
References: <20240209222858.396696-1-seanjc@google.com>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <20240209222858.396696-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/02/2024 23:28, Sean Christopherson wrote:
> Retry page faults without acquiring mmu_lock, and potentially even without
> resolving a pfn, if the gfn is covered by an active invalidation.  This
> avoids resource and lock contention, which can be especially beneficial
> for preemptible kernels as KVM can get stuck bouncing mmu_lock between a
> vCPU and the invalidation task the vCPU is waiting on to finish.
> 
> v4: 
>  - Pre-check for retry before resolving the pfn, too. [Yan]
>  - Add a patch to fix a private/shared vs. memslot validity check
>    priority inversion bug.
>  - Refactor kvm_faultin_pfn() to clean up the handling of noslot faults.

Can confirm that v4 also fixes the temporary guest hangs [1] I'm seeing
in combination with KSM and NUMA balancing:
* On 60eedcfc, the reproducer [1] triggers temporary hangs
* With the four patches applied on top of 60eedcfc, the reproducer does
not trigger hangs

Thanks a lot for looking into this!

[1]
https://lore.kernel.org/kvm/832697b9-3652-422d-a019-8c0574a188ac@proxmox.com/


