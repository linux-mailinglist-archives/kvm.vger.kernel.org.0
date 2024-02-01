Return-Path: <kvm+bounces-7707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4480C845955
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBE34B2351C
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B1C5D467;
	Thu,  1 Feb 2024 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueiC7CfB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF8F8663B;
	Thu,  1 Feb 2024 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795554; cv=none; b=uSSY17aZYFRLI2tzFxWUqUYOWUe8XmwKfdFlHusTOL237kEDUyic09d8ccZiAIEYRb2Z83H9E5j4txFdRLuinimZ9X3iGeWQnYV0DrU5IT4yuUvG7Arjd5OCh88BVAqdsf4eurF5EBVcDS42UA7idBIFiMbyeFpmOPvDXUXDNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795554; c=relaxed/simple;
	bh=hU+ObxdoMg2MlAgcOXqMatFJ02oxVhmfiG3OEicRvus=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cLCupQ7rHJVreglaT93Yqc5dtL77zMULFrEBD8wxNJKW1f7t1acGDTqNdVKpewkA0R/HkxOqHo54djkaMQqqWoYdpn3cx1kndziMpZ5qoFKwGEAt+s5hNgFz21KDcF/YfHIvPQVslsm7EjG1yETYwHf4Sx90C7tjIogZKe8i+w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueiC7CfB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C90C433C7;
	Thu,  1 Feb 2024 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706795553;
	bh=hU+ObxdoMg2MlAgcOXqMatFJ02oxVhmfiG3OEicRvus=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ueiC7CfBdVH8cLEkErjSzc5fwcnpU9NQYkgJAZKkZdye5Ve0ZZKpNZkx3AVRwFN75
	 KWfgD/PQh0yb1xyYnWyQvuITxKNcSfvokL/qgPm60I6VUngyErYQtVbkmm1HxINcWy
	 n25D8upedMPS0wwORv12rv5WLwDH8rBYraNM1Y7jw90bRRBqH1TqBkIoZ12b47Q4S5
	 bEmHqC008jveWDP4yVx3r2spzj2wAyJRWlp1SH0MdHpKOkZvtZFnwQ9upnvCRmf22x
	 zVTDquAJf3Foz2m00hXuZMXU0GIh/8UrrPALF8N2+BjvcH4xIUHomOf1jE4UFs2Asy
	 Y9zyJjvGVo+VQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rVXUU-00GwZa-OY;
	Thu, 01 Feb 2024 13:52:30 +0000
Date: Thu, 01 Feb 2024 13:52:29 +0000
Message-ID: <86jzno70ma.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Peter Hilber <peter.hilber@opensynergy.com>
Cc: linux-kernel@vger.kernel.org,
	"D, Lakshmi Sowjanya" <lakshmi.sowjanya.d@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	jstultz@google.com,
	giometti@enneenne.com,
	corbet@lwn.net,
	"Dong, Eddie" <eddie.dong@intel.com>,
	"Hall, Christopher S" <christopher.s.hall@intel.com>,
	Simon Horman <horms@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Richard Cochran <richardcochran@gmail.com>,
	kvm@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/8] ptp/kvm, arm_arch_timer: Set system_counterval_t.cs_id to constant
In-Reply-To: <20240201010453.2212371-6-peter.hilber@opensynergy.com>
References: <20240201010453.2212371-1-peter.hilber@opensynergy.com>
	<20240201010453.2212371-6-peter.hilber@opensynergy.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/29.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: peter.hilber@opensynergy.com, linux-kernel@vger.kernel.org, lakshmi.sowjanya.d@intel.com, tglx@linutronix.de, jstultz@google.com, giometti@enneenne.com, corbet@lwn.net, eddie.dong@intel.com, christopher.s.hall@intel.com, horms@kernel.org, andriy.shevchenko@linux.intel.com, linux-arm-kernel@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, wanpengli@tencent.com, vkuznets@redhat.com, mark.rutland@arm.com, daniel.lezcano@linaro.org, richardcochran@gmail.com, kvm@vger.kernel.org, netdev@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 01 Feb 2024 01:04:50 +0000,
Peter Hilber <peter.hilber@opensynergy.com> wrote:
> 
> Identify the clocksources used by ptp_kvm by setting clocksource ID enum
> constants. This avoids dereferencing struct clocksource. Once the
> system_counterval_t.cs member will be removed, this will also avoid the
> need to obtain clocksource pointers from kvm_arch_ptp_get_crosststamp().
> 
> The clocksource IDs are associated to timestamps requested from the KVM
> hypervisor, so the proper clocksource ID is known at the ptp_kvm request
> site.
> 
> While at it, also rectify the ptp_kvm_get_time_fn() ret type.

Not sure what is wrong with that return type, but this patch doesn't
seem to affect it.

	M.

-- 
Without deviation from the norm, progress is not possible.

