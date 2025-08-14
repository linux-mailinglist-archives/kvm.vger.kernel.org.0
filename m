Return-Path: <kvm+bounces-54635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBB4B259B5
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 05:12:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6AEA1C25A26
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 03:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7BC2580FB;
	Thu, 14 Aug 2025 03:12:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A993234;
	Thu, 14 Aug 2025 03:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755141140; cv=none; b=IQ9KkNC7MiwpuZ9B28vcr3ob3cYud+ifsqncSjHaecJbNMDJ9aN46oqsjDer6TDFLtTnqNZWcVAHZmO5UwIqa2ZWMOJaRyyfQN1z9HUK0ClBrpVw+n5/Zjr0LS6enME6hN1P9lsakcAYLe1PRzZn/krpfSqnqR5mSxTJxQXb5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755141140; c=relaxed/simple;
	bh=hD6G01xUFxAMo8yTPpCJAcvP0fFbdI7tS5+ZWk89JbA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FCcDATZqnIbgjyE70u4j5sN2tjRQU82vo+xVeiP1bQ39FtlFfQIj6Vvagz8X9nThW/UeKuRGBdj0tXPZ5dW11Iv7XRKDIgwd0QWo168oBONPENAR80I4deRj8k4/GLIEkZLoRXzxgL38/jWjUdxwB9XWVXt7GUebQkwiaKZIZ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: "Li,Rongqing" <lirongqing@baidu.com>
To: "Guo, Wangyang" <wangyang.guo@intel.com>, Peter Zijlstra
	<peterz@infradead.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Tianyou"
	<tianyou.li@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Subject: RE: [????] RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism
 to virt_spin_lock
Thread-Topic: [????] RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism
 to virt_spin_lock
Thread-Index: AQHcDGAgcSqykxiqsUqQs7C13JefpbRg1jKAgAChcMA=
Date: Thu, 14 Aug 2025 03:10:46 +0000
Message-ID: <bb474c693d77428eb0336566150a1ea3@baidu.com>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <20250813143340.GN4067720@noisy.programming.kicks-ass.net>
 <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB8018B027AA0738EB8B6CD55D9235A@DS0PR11MB8018.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.13
X-FE-Policy-ID: 52:10:53:SYSTEM

> On 8/13/2025 10:33 PM, Peter Zijlstra wrote:
> > On Wed, Aug 13, 2025 at 08:50:43AM +0800, Wangyang Guo wrote:
> >> When multiple threads waiting for lock at the same time, once lock
> >> owner releases the lock, waiters will see lock available and all try
> >> to lock, which may cause an expensive CAS storm.
> >>
> >> Binary exponential backoff is introduced. As try-lock attempt
> >> increases, there is more likely that a larger number threads compete
> >> for the same lock, so increase wait time in exponential.
> >
> > You shouldn't be using virt_spin_lock() to begin with. That means
> > you've misconfigured your guest.
> >
> > We have paravirt spinlocks for a reason.
>=20
> We have tried PARAVIRT_SPINLOCKS, it can help to reduce the contention cy=
cles,
> but the throughput is not good. I think there are two factors:
>=20
> 1. the VM is not overcommit, each thread has its CPU resources to doing s=
pin
> wait.

If vm is not overcommit, guest should have KVM_HINTS_REALTIME, I think nati=
ve qspinlock should be better
Could you try test this patch
https://patchwork.kernel.org/project/kvm/patch/20250722110005.4988-1-lirong=
qing@baidu.com/


Furthermore, I think the virt_spin_lock needs to be optimized.

Br
-Li

> 2. the critical section is very short; spin wait is faster than pv_kick.
>=20
> BR
> Wangyang


