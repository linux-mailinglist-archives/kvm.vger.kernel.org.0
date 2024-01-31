Return-Path: <kvm+bounces-7591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8025E844327
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 16:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDFB8B2DB8F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 15:31:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E188C1292E9;
	Wed, 31 Jan 2024 15:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XfRaxlP/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B963683CDB
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706715103; cv=none; b=g0JR0sKd35n8ufzlvBR0M5JtVLA1e2+HFdBNQmW7jRLwwM7VGHMDKjsSl7Mi0X/sAspotmwKSXuEWRQHx79RrtaR7sPeTmOeEHlnKWQnNp27CFIb6yn/f1NI5LTvAuCxZF6bDHZ66GVG6ySOX5eUQtaZtAAIuinkvG2IyB3txyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706715103; c=relaxed/simple;
	bh=oL4W9D8uTGF08rS1s/ZYdHS1i0mWCq37SyhQwBq1J/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pDlgDGkCb2tx4jAAySwKNPwFu1o7Zk0ES1p2ZbRK5ViSXMxWd2owkS0hmb91jbvfV7DS5Rysp6K1Z6D/ol0mzDZiEEcafid1jICcoB8bfJlZpiiOW9wQKVkR5NdQ9BriVLlQc3LDZCSbHklG1IKywKRVKgeNpPlv4aaHMDOMaMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XfRaxlP/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6de331e3de2so961862b3a.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 07:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706715101; x=1707319901; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLI/CdVyu9eHQa8UHfDtmUbiN6ljlyx0ki16JonNEL4=;
        b=XfRaxlP/wEWHmRB8W4qh16naOXVxrnXbKK9v7R6GTvB3Xw5YP8A8K9HBrioKIaNPsW
         Oh2KGtNCBJp7Wi+1ppueO66FuDd7NcrAI7r2kKkQGS5E3NzWoX6wz2Ss3Kf7NkucYL4s
         TxfbemAIA7jIhwtzneXJudfw3jXy8NvfqhHeCqdE96ktNG2XcPSHN2WbWEZcy7qJMOg0
         EQ9sE+bKVtw7eV9iZ1MdJo0RozdLFxkUCbJiPxvr6H1UIP2Y/E9b3AkT/xGCgRgNZK8H
         UE6VMEEE3JYUpHu8RGr1zluteiM0sc8fISNEpZDUnH7l5hdVN8bxZ+2b1lzEWztvQ80q
         eG0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706715101; x=1707319901;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLI/CdVyu9eHQa8UHfDtmUbiN6ljlyx0ki16JonNEL4=;
        b=l9Kd5Rp1g0o76rZSXcg5TD5dy9zJyle557LEmP9lHOAs2ps/QR7NcMWm8se2mLVAk1
         ifqJPOD2lzTX3K7BbQsfAXtfBFWVqBYeJS+E5fXWXqiTJVzykI81fuXDCpNg9RRFOl7Y
         47jInzJo5COQfSk6FVlKBMxEy8aT2bxBMfRhMzU73aKi7TKN1/i1o7qPYK7oDDcjwB6d
         FmAxKi4eYbfhbvrl3pkm63QqT745vCBCCnEDFI3iACVZWsG4DpuGkVsgkPa/KLJl8+iR
         cZoyh18AaTO0j8CeoR37VxTuXhvSYV1DQ358Evpy4AwgOW+tq+PT7IRxO5VQFqOp8v3p
         e1OQ==
X-Gm-Message-State: AOJu0Yyw0cHwcQGxDIGWwRRyk8ZHKM4MdwvaPu+gNwo1nFfDybmQQnCr
	+Fl8hVXt3IOTsNLC+hDIr9H+VLUQoQUk7byBWEjj7Xv1vtDt/LEsxqXc/zb6CV8dWmpWnqVJ9C9
	dSA==
X-Google-Smtp-Source: AGHT+IGakOzZSxJMYgkN0htnKhLJoZV0JKpLbOKc2nO+hNe/P1Xdl9Oswur6+6pTCFd171+nGMSVDK6fWyg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cca:b0:6df:dd47:ff3d with SMTP id
 b10-20020a056a000cca00b006dfdd47ff3dmr85585pfv.0.1706715100889; Wed, 31 Jan
 2024 07:31:40 -0800 (PST)
Date: Wed, 31 Jan 2024 07:31:39 -0800
In-Reply-To: <d24dc389-8e73-4a7a-9970-1022dcbfa39c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com> <20240109230250.424295-17-seanjc@google.com>
 <5f51fda5-bc07-42ac-a723-d09d90136961@linux.intel.com> <ZaGxNsrf_pUHkFiY@google.com>
 <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com> <ZbmF9eM84cQhdvGf@google.com>
 <d24dc389-8e73-4a7a-9970-1022dcbfa39c@linux.intel.com>
Message-ID: <Zbpn284rPe3pMBwI@google.com>
Subject: Re: [PATCH v10 16/29] KVM: selftests: Test Intel PMU architectural
 events on gp counters
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 31, 2024, Dapeng Mi wrote:
> BTW, I have a patch series to do the bug fixes and improvements for
> kvm-unit-tests/pmu test. (some improvement ideas come from this patchset.)
> 
> https://lore.kernel.org/kvm/20240103031409.2504051-1-dapeng1.mi@linux.intel.com/
> 
> Could you please kindly review them? Thanks.

Unfortunately, that's probably not going to happen anytime soon.  I am overloaded
with KVM/kernel reviews as it is, so I don't expect to have cycles for KUT reviews
in the near future.

And for PMU tests in particular, I really want to get selftests to the point where
the PMU selftests are a superset of the PMU KUT tests so that we can drop the KUT
versions.  In short, reviewing PMU KUT changes is very far down my todo list.

