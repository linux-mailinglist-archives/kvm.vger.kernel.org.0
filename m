Return-Path: <kvm+bounces-2333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 611BD7F51E5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 21:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 900EB1C20AB5
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596291A58F;
	Wed, 22 Nov 2023 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [IPv6:2a02:4780:10:3cd9::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA268112;
	Wed, 22 Nov 2023 12:51:19 -0800 (PST)
Received: by gentwo.org (Postfix, from userid 1003)
	id 75B8148F4A; Wed, 22 Nov 2023 12:51:19 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 7503D48F41;
	Wed, 22 Nov 2023 12:51:19 -0800 (PST)
Date: Wed, 22 Nov 2023 12:51:19 -0800 (PST)
From: Christoph Lameter <cl@linux.com>
To: Mihai Carabas <mihai.carabas@oracle.com>
cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
    linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, 
    catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
    pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com, 
    rafael@kernel.org, daniel.lezcano@linaro.org, akpm@linux-foundation.org, 
    pmladek@suse.com, peterz@infradead.org, dianders@chromium.org, 
    npiggin@gmail.com, rick.p.edgecombe@intel.com, joao.m.martins@oracle.com, 
    juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de, 
    ankur.a.arora@oracle.com
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-Reply-To: <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
Message-ID: <6bd5fd43-552d-b020-1338-d89279f7a517@linux.com>
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com> <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed


On Mon, 20 Nov 2023, Mihai Carabas wrote:

> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> smp_cond_load_relaxed which basically does a "wfe".

Well it clears events first (which requires the first WFE) and then does a 
WFE waiting for any events if no events were pending.

WFE does not cause a VMEXIT? Or does the inner loop of 
smp_cond_load_relaxed now do 2x VMEXITS?

KVM ARM64 code seems to indicate that WFE causes a VMEXIT. See 
kvm_handle_wfx().

