Return-Path: <kvm+bounces-2591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BCC7FB4CE
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 09:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 961C5281F84
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 08:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7626419BD7;
	Tue, 28 Nov 2023 08:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nYHzmgu+"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA07A7;
	Tue, 28 Nov 2023 00:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U4zEsxIBsLahGMZZYNnGegu2oI4a59iX9SFLCvRWtLQ=; b=nYHzmgu+9P9Empy1r8CED4qj4l
	MxPjN6hJKHk3Y5+MoUBQJa7c4XNAYhTXs0qsXEUomhqb4EqhFoWwX1xH5n0aCfFxhe8miFZnRdPrq
	ylt9DCjgnoztRLHYN2Jlr6C6n9Nm1y+A6H1VdWWtrdxpRdxOMb4X5DaEZboVg3dOQdeeu8o1iZF/O
	De12Tebe/22PXvrbjPMYoZ7Wurz0YTTkaWzDXz4XJpbqiT8Jkpd8DoZTRupxs3f4RO2Xx4WJM/PCu
	HSZff4EhjU5e11rM0iHi6+I1P6uTN1iJ/szpDuNdi9ZfURiP/zahwDFKoBL3rMAhJ9wj4GVAN67xA
	TSwaA9Hg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r7tnX-00CCWm-9v; Tue, 28 Nov 2023 08:50:28 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 276CB3003F0; Tue, 28 Nov 2023 09:50:26 +0100 (CET)
Date: Tue, 28 Nov 2023 09:50:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yang, Weijiang" <weijiang.yang@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v7 02/26] x86/fpu/xstate: Refine CET user xstate bit
 enabling
Message-ID: <20231128085025.GA3818@noisy.programming.kicks-ass.net>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-3-weijiang.yang@intel.com>
 <20231124094029.GK3818@noisy.programming.kicks-ass.net>
 <a45c2e25aaa1f195e7fccff6114374994ffbc099.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a45c2e25aaa1f195e7fccff6114374994ffbc099.camel@intel.com>

On Tue, Nov 28, 2023 at 01:31:14AM +0000, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 10:40 +0100, Peter Zijlstra wrote:
> > So booting a host with "ibt=off" will clear the FEATURE_IBT, this was
> > fine before this patch-set, but possibly not with.
> > 
> > That kernel argument really only wants to tell the kernel not to use
> > IBT
> > itself, but not inhibit IBT from being used by guests.
> 
> Should we add a SW bit for it then? 

Don't think we need a feature flag for this, some boolean state should
be enough.

> ibt=off sounds like it should be
> turning off the whole feature though. It doesn't sound like kernel IBT
> specifically.

Well, the intent really was to just not enable IBT, clearing the feature
was the simplest way to make that happen. 


