Return-Path: <kvm+bounces-3906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A27B4809F66
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 10:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CDA12817EF
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 09:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B04E12B72;
	Fri,  8 Dec 2023 09:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eK8feyvc";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ezKUFhDk"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DC6171F;
	Fri,  8 Dec 2023 01:31:22 -0800 (PST)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1702027880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ypJIbnUsUGwwnCZqSIYAJ+IV09KDSne8At3TT8svy18=;
	b=eK8feyvcv7dCOLbb3xHKW7Acre82SMz5YWHKDZFYbnvXnZOB1I1/Bi0Uj6sp/Gh3o7+ABJ
	m37gEy5bRrzDFqd3kkVnXrhP85y9xB7WkvZigcVJly0zOktwV0RBgiescyBr+RQnsuPXVQ
	Xd3p8bDEIeeoG//vNQWxRno19a1nNuzorDgeaFIN/lFtZK0ZMAyD3caGo6q9aQDIdxLxep
	41/D8OKXO5lNoch+sz7xx9fAcQfnVTFZ3FxC5S60E8WUa8FKOlQz4iLbS66pE6iEr0l2Md
	2vtKjc4WjhNDbw/3sH+9PuR2Yy1eIqX8QZpmT/D+eoVuuhvwmMTFJAfSXDLUdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1702027880;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ypJIbnUsUGwwnCZqSIYAJ+IV09KDSne8At3TT8svy18=;
	b=ezKUFhDk5y4jvHILEopD7H1/aDqy17wzslA8uxl3siTltIT35KLucBg9bN7BUKNjtSpp/J
	aLNnYfiHrVnGimAg==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 01/13] x86: Move posted interrupt descriptor out of
 vmx code
In-Reply-To: <20231207205431.75a214c2@jacob-builder>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-2-jacob.jun.pan@linux.intel.com>
 <87wmtruw87.ffs@tglx> <20231207205431.75a214c2@jacob-builder>
Date: Fri, 08 Dec 2023 10:31:20 +0100
Message-ID: <875y19t507.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Dec 07 2023 at 20:54, Jacob Pan wrote:
> On Wed, 06 Dec 2023 17:33:28 +0100, Thomas Gleixner <tglx@linutronix.de>
> wrote:
>> On Sat, Nov 11 2023 at 20:16, Jacob Pan wrote:
>> 	u32			rsvd[6];
>> } __aligned(64);
>> 
> It seems bit-fields cannot pass type check. I got these compile error.

And why are you telling me that instead if simply fixing it?

