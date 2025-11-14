Return-Path: <kvm+bounces-63177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 845D7C5B680
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4D0294E1535
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 05:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6CCC2C326F;
	Fri, 14 Nov 2025 05:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bJSDNZrc"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413821F4169
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 05:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763098859; cv=none; b=WSKgSLySYv4JG1Nvtuwe+V8HrsrbP5lfL6/rm5XMIXZRO5uiwCoUHx6/yz/utO8X43R3qc8AQcIi18+kTKrQ5Ni7BlHqupLZjNT3rCn5Pj5dc1zLnFKUGBFze63kbbndRlwcctF4C6B4RHSkV1TNUlq6Hl3FIVFUtunNzOTFIEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763098859; c=relaxed/simple;
	bh=UnSWGpTNc2xv2ZRu1VjsBKA4E7pDlmNzwuN72FFpzfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BP+bVlSW/jH92888zjuYRf+7Zg6LbMaLQtlmc6gRTZ5YR5p9qGj6z/t2etrWBHOKFGqZIFRWisx+XZRREGqXT3wYG8wf6g4Hhyd24fTJyYSj0YOoRCooz/TgC0dwSshXG88ei80GcBLzvVb1YMK9gIkmFhqHj9NXwIN9LShd82I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bJSDNZrc; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 05:40:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763098854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zJbqf8EYgW5eRInZGLge5MVn8srVkWZgqqnzRPsPfxs=;
	b=bJSDNZrcTMDqVikYYuFIbqRzmpBvqfu/WaRBkY2cW9cQI8xKsszqT1Jy7JOR9P/bQdTpqL
	NU9DbxHuTZcGd5nVD33k6FN4OOWKeil+wmqgFgjchOZNFUaKSzq/gFQv+CGhvpPYwt2qM+
	MStF9JrRC8RdfFwRDdM+9LiN42WPwF8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Shivansh Dhiman <shivansh.dhiman@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/14] x86/svm: Cleanup LBRV tests
Message-ID: <pdqv3jhoyspfj3tvhgzgqwsxhixfdnbbllye362kybzcnf2ulb@m74e4ndlrrxi>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-13-yosry.ahmed@linux.dev>
 <1f39d5a3-e728-4b2b-a9c6-50cbc4fffd17@amd.com>
 <66tns2r4rgrugltijbrxoqyvrpxy6udebpod2udcjnuu6qhsj7@roagtke7znaq>
 <76608bf1-a47d-4974-8ec9-28e8df7bd43a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76608bf1-a47d-4974-8ec9-28e8df7bd43a@amd.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 14, 2025 at 10:27:07AM +0530, Shivansh Dhiman wrote:
> Hi Yosry,
> 
> On 13-11-2025 20:29, Yosry Ahmed wrote:
> > On Thu, Nov 13, 2025 at 05:28:11PM +0530, Shivansh Dhiman wrote:
> >> Hi Yosry,
> >>
> >> I tested this on EPYC-Turin and found that some tests seem to be a bit flaky.
> >> See below.
> > 
> > Which ones? I was also running the tests on EPYC-Turin.
> 
> Most of the nested LBRV tests had this issue. I checked your other patch to fix
> this. I tested it and it does fixes it for me. Thanks.

Yeah it was an unrelated problem, and it only flaked on some machines.
Apparently even though the APM does not mention usage of any of the
higher bits in LBR MSRs, they are in fact used. The PPR of some models
show that some of the upper bits are reserved.

I think the failure was due to bit 62 being set, which I think is the
speculation bit, which explains why it's inconsistent.

Anyway, thanks for confirming.


