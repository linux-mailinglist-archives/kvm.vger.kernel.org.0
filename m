Return-Path: <kvm+bounces-6149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4D8582C354
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 17:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A0BB1F22913
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:08:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9397F7319C;
	Fri, 12 Jan 2024 16:08:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BAA73165;
	Fri, 12 Jan 2024 16:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 46C69490CC;
	Fri, 12 Jan 2024 17:08:09 +0100 (CET)
Message-ID: <533e4b73-105c-401d-b496-25d20eba2d76@proxmox.com>
Date: Fri, 12 Jan 2024 17:08:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Temporary KVM guest hangs connected to KSM and NUMA balancer
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <832697b9-3652-422d-a019-8c0574a188ac@proxmox.com>
 <ZaAQhc13IbWk5j5D@google.com>
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <ZaAQhc13IbWk5j5D@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/01/2024 17:00, Sean Christopherson wrote:
> This is a known issue.  It's mostly a KVM bug[1][2] (fix posted[3]), but I suspect
> that a bug in the dynamic preemption model logic[4] is also contributing to the
> behavior by causing KVM to yield on preempt models where it really shouldn't.

Thanks a lot for the pointers and the proposed fixes!

I still see the same temporary hangs with [3] applied on top of 6.7
(0dd3ee31). However, with [4] applied in addition, I have not seen any
temporary hangs yet.

As the v1 of [3] was reported to fix the reported bug [2] and looks very
similar to the v2 I tried, I wonder whether I might be seeing a slightly
different kind of hangs than the one reported in [2] -- also because the
reproducer relies heavily on KSM and AFAICT, KSM was entirely disabled
in [2]. I'll try to run a few more tests next week.

FWIW, the kernel config relevant to preemption:

CONFIG_PREEMPT_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_PREEMPTION=y
CONFIG_PREEMPT_DYNAMIC=y
CONFIG_PREEMPT_RCU=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_PREEMPT_TIMEOUT_COMPUTE=7500
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set

Thanks again!

Friedrich

> [1] https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> [2] https://lore.kernel.org/all/bug-218259-28872@https.bugzilla.kernel.org%2F
> [3] https://lore.kernel.org/all/20240110012045.505046-1-seanjc@google.com
> [4] https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com


