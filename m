Return-Path: <kvm+bounces-29112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7929A2C8F
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 20:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 931F92820D4
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 18:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7042194BA;
	Thu, 17 Oct 2024 18:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b="a+sK/kik"
X-Original-To: kvm@vger.kernel.org
Received: from gentwo.org (gentwo.org [62.72.0.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEC1D86E4;
	Thu, 17 Oct 2024 18:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.72.0.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191055; cv=none; b=HFt7vk0dr5fiLQuIqXb9RMLIcSagyBTo8yqikHdmgn58A/7OUPmGJVTaEze/Vvs4SCILmI2ci5nOvPA5GCgUrupUClNrBDBtz6chvrKhcGzYcsK24UIm/axYUbWYTYqZhUzGCzZB707LwpDmyRLhgy2z3/ybU+L6uzVq1TKFPpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191055; c=relaxed/simple;
	bh=qohtvOtI6k0iO4BEpGvj7ijKYjF2/6jk/iwxseaq3JY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LJKNOmDjBCp9lIggoRYSZwMLNz+eIrmZ9K2/7LqNQHRQe3KzJ1Q203cjEK2QakJiQoBjIHwAQKhdY6ll4nyGE8uj3yWPghowkCYT/qqkxr5fmVwotjCrPsU/GUv9vMas27H6yZX+uBm6/kllIYgbIGVDvjicOCRjzed3Ey5TFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org; spf=pass smtp.mailfrom=gentwo.org; dkim=pass (1024-bit key) header.d=gentwo.org header.i=@gentwo.org header.b=a+sK/kik; arc=none smtp.client-ip=62.72.0.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gentwo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1729184173;
	bh=qohtvOtI6k0iO4BEpGvj7ijKYjF2/6jk/iwxseaq3JY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=a+sK/kikDiKYSdqJeh8QT53+R9kSPD3kC82d8AP7w4agt7nQl6qIJXHVBwMHRB+yG
	 buG+wSCF7PtjDNjkBY1g/PyPl17ch30X4crABM0DeVrxirSnO7AgzFtuUllN5bA+nv
	 X4g3kIp1foSOLX965TghrsES65Or4s0oAenoK9gY=
Received: by gentwo.org (Postfix, from userid 1003)
	id 2FECA40681; Thu, 17 Oct 2024 09:56:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 2E368400C9;
	Thu, 17 Oct 2024 09:56:13 -0700 (PDT)
Date: Thu, 17 Oct 2024 09:56:13 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org, 
    kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de, 
    mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
    x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com, 
    vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org, 
    peterz@infradead.org, arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com, 
    harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com, 
    misono.tomohiro@fujitsu.com, maobibo@loongson.cn, 
    joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, 
    konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-Reply-To: <Zw-Nb-o76JeHw30G@arm.com>
Message-ID: <53bf468b-1616-3915-f5bc-aa29130b672d@gentwo.org>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com> <20240925232425.2763385-2-ankur.a.arora@oracle.com> <Zw5aPAuVi5sxdN5-@arm.com> <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org> <Zw6dZ7HxvcHJaDgm@arm.com> <1e56e83e-83b3-d4fd-67a8-0bc89f3e3d20@gentwo.org>
 <Zw6o_OyhzYd6hfjZ@arm.com> <87jze9rq15.fsf@oracle.com> <95ba9d4a-b90c-c8e8-57f7-31d82722f39e@gentwo.org> <Zw-Nb-o76JeHw30G@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wed, 16 Oct 2024, Catalin Marinas wrote:

> The behaviour above is slightly different from the current poll_idle()
> implementation. The above is more like poll every timeout period rather
> than continuously poll until either the need_resched() condition is true
> _or_ the timeout expired. From Ankur's email, an IPI may not happen so
> we don't have any guarantee that WFET will wake up before the timeout.
> The only way for WFE/WFET to wake up on need_resched() is to use LDXR to
> arm the exclusive monitor. That's what smp_cond_load_relaxed() does.

Sorry no. The IPI will cause the WFE to continue immediately and not wait
till the end of the timeout period.


