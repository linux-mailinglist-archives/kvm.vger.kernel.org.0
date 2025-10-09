Return-Path: <kvm+bounces-59745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D7BCB2DC
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 01:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A75A1A6479E
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 23:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D0E2877DF;
	Thu,  9 Oct 2025 23:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ji3V7HVL"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6603D72625
	for <kvm@vger.kernel.org>; Thu,  9 Oct 2025 23:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760051606; cv=none; b=MRNgo9JcFOkutpYGjbQUVpzHHbCShfrYqnentwNxnAJekTTnZa6lpm3fY2ZxbAtrvS0fuphUKo+tKyqSFxK/QFFektXhiEp6jjTGJq7YA6Jt78WXDKqAzYweEhfUu5UVb478tEKNLpCYoQYBOKHiPY8cud1Ugw3JgCK7JlLHW60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760051606; c=relaxed/simple;
	bh=tkpbKMEIXMsEMApozpOvFaM3Sa/es7WGMxTbt4bHprM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSd7+suNWqWjn+bpIfxAwlXLLIgHcI2UwtmeH9IRWGVcBhivxPfdA4xE58Fx9vwFMyNv8V6HU3J1qumf9w0lW5qF2TP+V8+JbFMdoBzBIYwW0JJfePh/HcXY9aUiYo88bfiXEcEtISRMOcSY1cQcnsvFFETb+XpiUhfGqgr97wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ji3V7HVL; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 9 Oct 2025 23:13:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760051600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eULQRUxREHXAhedpXv9LT6GIAoMo/fpeG3RPg5j5dOM=;
	b=ji3V7HVLGKi7XR4qCsAtJj1K+7RW8pT7GEqe4AM0FuhNsZ2eB+hYbmqC9e3iJgUwZDpBla
	QIdLbpBUIxdDppW1Hgul1XpXkCIRiC9r/0CmN3uixf6/Wh5Uiv3wdZ+NbG2vmV2GnmrmNa
	TKDrdtpWZ5O5ShUVNhfxtqTpLCewbyQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] KVM: selftests: Extend vmx_set_nested_state_test
 to cover SVM
Message-ID: <r3yesty3ujmrlymhkkfhdrjdrbvl45yfvmcmyrkrrcm4sqkiiq@eb6raabphib4>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
 <20251001145816.1414855-3-yosry.ahmed@linux.dev>
 <CALMp9eQi15V1+5EqCevm9aWMv4OAGbUb14dazBcjhhL8mVGHww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eQi15V1+5EqCevm9aWMv4OAGbUb14dazBcjhhL8mVGHww@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 09, 2025 at 03:40:44PM -0700, Jim Mattson wrote:
> On Wed, Oct 1, 2025 at 8:03 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > From: Yosry Ahmed <yosryahmed@google.com>
> >
> > Add test cases for the validation checks in svm_set_nested_state(), and
> > allow the test to run with SVM as well as VMX.
> >
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> > ...
> > +       /* If EFER.SVME is clear, GIF must be set and guest mode is disallowed */
> 
> The GIF constraint is not architected. See
> https://lore.kernel.org/kvm/20251009223153.3344555-2-jmattson@google.com/.

Yes, I didn't connect our discussion about clearing GIF when EFER.SVME
is cleared to the nested state code. I will remove the GIF assertion in
the next version.

Thanks!

