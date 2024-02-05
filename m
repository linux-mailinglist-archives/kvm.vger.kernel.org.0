Return-Path: <kvm+bounces-8025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FF95849EB3
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 16:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C322281543
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 15:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94DA532C90;
	Mon,  5 Feb 2024 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uSkN6g/x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B5E2E63B
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707148122; cv=none; b=qdbXdc0Nqs0KnH9nEE1Uvj8ISagNwmj80dWp4MpU0+vELbZRYVOxrPE7QPvwL8cfpO6EjTxfwNluTiru2YaNKAFnwDgPy19kqb3gfGjItKY89RzxvSj/w8RirTK7IdCPh59zGJ9J5kgr/qMSH3MWM/QIOcl9F2yaw5U2HCJDx4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707148122; c=relaxed/simple;
	bh=7rkf12TOWb99NCO8cw69r+ag/35aJdcQATF4XdTqq4w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pAwbM2coxAyrDyb6OUEO0T0572MBzjZrpnFHbTjRCHh/xR6d1odTdUnpq6n61b8nX0UXQPBxg0y5aOsRpbRyxX3CgI/TiXVLR+2d6SHREp/gIUwlSVpl3KwBJ+3GLrTMwbdmzZ2/JnSZPssZkXDOSUImkz2WeuwvmqJQzMD4g60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uSkN6g/x; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc3645a6790so8363015276.0
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 07:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707148120; x=1707752920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ca1DgeOD/Evth6Nl9wg+8TBPqKi43Qu1Qd6uanxITM=;
        b=uSkN6g/x/nZBqufRasYJeycKiMotRIy24BE0RyL2w4na2yJAsyZF3uMoX56+G9QKhE
         IMc5kjAlrHquAH81S1AE78dNIuqjPblNj6ktGPO+UaaJVq/Sunz2379b3F2pRGfS0eKm
         fcwCn/XaAWpADaS7K8Ia7EBKwEK9tAkCt7SSgUclik+vBXEauPLFPHitRzFhapWDmR+u
         6WN1ZMFHeqwgO8EEh8k4g/kYZmlKPMcGi+aWR40+rk251xppcd7bBPlUPtyFnnpEQeeX
         vS0m3KxVAPdMvwReq3USn7IZLuEkeUOmp61x7ZpYd60LoxoORI07cj9s31efQ32MkaqW
         kR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707148120; x=1707752920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ca1DgeOD/Evth6Nl9wg+8TBPqKi43Qu1Qd6uanxITM=;
        b=R2Xx16dvvA1/bymrnAkSXIeQi8A8WgszHbeJ9iRO6ql8Tce8CsVVrou4XHV+uFTkI+
         q0zdVNEZqWvR95O8YGy/swhhzCG62iDGEs75zVRVw2MFE1K8tOLbe9Ey46LswfOPxNY6
         OMDfREPbtZzi1tWUJewidRUf9L1tGwMCspoRN3Fu87jLKpDiE6op53ThxwC6CrVieASN
         TD99Axk0USIYDnDWFG8bDJ5R0Gxo2tlMYWiXsGNoJR8JkMErRYyWD2UGTEQHDNLn9yPp
         /G0mY790sjMNfyrT3hegApfBUu3mehIcs1Mss6QaZD3hM0+BT3+iJ/xzc52zdD8F0BhV
         YctQ==
X-Gm-Message-State: AOJu0YyLtP2gzNShmhZp8CX5NLTT3/HGzpTrfojI7diADZwP//eJFJVP
	i3jaTXOrf6/U9z2w8ZxiPmolDyWK+7ApRJegaAgTFVQ4obFWI3r9wmjmHVC0tqUNcBMjjgzDg1/
	/qw==
X-Google-Smtp-Source: AGHT+IFB3jAtcHJg7BYQi3G1y0V2MSCc1gHZ9mzGrWPsJByQcO2pBEgRSpbteeewVJXgcOVMVCxr4HgFYFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:138e:b0:dc2:1cd6:346e with SMTP id
 x14-20020a056902138e00b00dc21cd6346emr4365042ybu.8.1707148120444; Mon, 05 Feb
 2024 07:48:40 -0800 (PST)
Date: Mon, 5 Feb 2024 07:48:38 -0800
In-Reply-To: <ZcCyzrUhXSlhKyqC@x1n>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240202064332.9403-1-shahuang@redhat.com> <ZcCyzrUhXSlhKyqC@x1n>
Message-ID: <ZcEDVkWp6mXoyZsu@google.com>
Subject: Re: [PATCH v3] KVM: selftests: Fix the dirty_log_test semaphore imbalance
From: Sean Christopherson <seanjc@google.com>
To: Peter Xu <peterx@redhat.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 05, 2024, Peter Xu wrote:
> Shaoqin, Sean,
> 
> Apologies for a late comment.  I'm trying to remember what I wrote..
> 
> On Fri, Feb 02, 2024 at 01:43:32AM -0500, Shaoqin Huang wrote:
> > Why sem_vcpu_cont and sem_vcpu_stop can be non-zero value? It's because
> > the dirty_ring_before_vcpu_join() execute the sem_post(&sem_vcpu_cont)
> > at the end of each dirty-ring test. It can cause two cases:
> 
> As a possible alternative, would it work if we simply reset all the sems
> for each run?  Then we don't care about the leftovers.  E.g. sem_destroy()
> at the end of run_test(), then always init to 0 at entry.

Gah, I posted v4[*] and didn't Cc you.  I would prefer not to reset the semaphores,
mostly because it encourages sloppiness in the test.  There's no reason to allow
the two threads to effectively get out of sync.

[*] https://lore.kernel.org/all/17eefa60-cf30-4830-943e-793a63d4e6f1@redhat.com

