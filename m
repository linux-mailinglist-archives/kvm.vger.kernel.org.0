Return-Path: <kvm+bounces-28817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 103C299D9BF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 00:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A10AE1F22B47
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 22:23:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09BC1D0E13;
	Mon, 14 Oct 2024 22:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dmscKdKd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75913BC02
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728944609; cv=none; b=Vw0IH05f+GndVj4/xHd4OlEUp2VhFsR64aoy02r9anZmjyGmdXrz+IFUneWNgyBAssDtHpNMESK4mxnUJeM8zKObE6EDtTKvrnef4D+WHVUUehiswQdbhxFRx3itvD2LOX+qcDThfzmlVXHZ0+baaQt4KuzTV25wGXQq6Eot0g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728944609; c=relaxed/simple;
	bh=gv0x2b2PoNf+TkwQtGQA+hFg+JPenw8viKr0DO6+Lrw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KUPyO/7Zxx/tkubSskmnvOdGj22Do8O8uyDKMp/aDK1EXkQhKPHPTnsGb32Jk68ycBfOd6r7Cwcb9IEdXXceB9d76nXELd9CACCHAhZDiXBD19GDAh9zdSNotWw6brDmtFsUAXXTOp0qUHJ8a075LaG2RKAmxkx2r/GAtr+kirw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dmscKdKd; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e321d26b38so82243327b3.2
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 15:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728944607; x=1729549407; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=04cHKHgrL7/J8cmYsPL4VJWOHoKjBPFN4M3VyEvV5R0=;
        b=dmscKdKdFgr4vIWTzKuUpRr/TiJcXCjGaqTjdrm+niwpeDtiHbW65afu3m4uRbhg/+
         9+WXKrWeOhLddjGcxl/44D9ppNphOQyYtnzy6iaDdK3RYkLriVacumNslrqHrFsHnXNt
         ERPPhN5kytTwA3Zv39PDA4Fg34QARkOBTWwSWAqZudZsLrGM6/082rCpkG/ziXyopRo6
         aa7vkHcF57N50vNqpR7iMJ52FJNXrDcnt78d3FE8XOdOxitnQEgAu65dnRzaOnO4kJ9Q
         OOZdHqIWrGZwUFcbNJchK2coSwXMT6j3PUmTpW4KXueET75JJbkUJq/XmtTocxAE+MSA
         W0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728944607; x=1729549407;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04cHKHgrL7/J8cmYsPL4VJWOHoKjBPFN4M3VyEvV5R0=;
        b=AY0BXapENN0vmwv5idPl9kbbTguYFPJl9k8T5MtAkjoksZO/dAYYbgllvsP6EMeghs
         yTlRW1kM3UM8lx3RSQmu1ldrOcEKG5+O55aAP+c3BhSCgnLrKxYR6Bzr2jlBArru+wvm
         PbGu+mVd6WBGMBJHL0egbpMeKq4EksneyXRuqddelVwYTpc4zV/cNG3fTa45YWErsnV+
         IECFS4JknoeDcXTwi8yPj36fCYpEShFlBu/0pgwWmEzwO4VUHqJ4Hn0JKmEDY6SBRsdc
         OkopMraooZt8lVNvr0rz7nYmAc3Tfg0CeWYFM0uDPCmTQVPZppL4MIJ6L2yCA0KG/faj
         wCsQ==
X-Gm-Message-State: AOJu0YyMaH4pGa7RHJrDPzZ0dwLuJEx716AfUNh9PjTK/9LwP2cWjE75
	idqjEwfEWvgaKh6wF+CwSj5Zxq9Hl0r9T+mFyWOOU1+QxjeB/cmpsr+oeJ/iQLIh58Z7Ds5ICCl
	MnQ==
X-Google-Smtp-Source: AGHT+IG1Ae3jO/kXIxxJfLv3WIvlsTh01ooR6ufsPDh2fil0948QVn7sffNeuOmPj+rxynNQ01OzSz8yDL0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d8c:b0:6e2:a129:1620 with SMTP id
 00721157ae682-6e347b2d7d9mr281187b3.3.1728944606659; Mon, 14 Oct 2024
 15:23:26 -0700 (PDT)
Date: Mon, 14 Oct 2024 15:23:25 -0700
In-Reply-To: <20240905124107.6954-1-pratikrajesh.sampat@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240905124107.6954-1-pratikrajesh.sampat@amd.com>
Message-ID: <Zw2Z3WUYjOZ1rP59@google.com>
Subject: Re: [PATCH v3 0/9] SEV Kernel Selftests
From: Sean Christopherson <seanjc@google.com>
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, pgonda@google.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 05, 2024, Pratik R. Sampat wrote:
> This series primarily introduces SEV-SNP test for the kernel selftest
> framework. It tests boot, ioctl, pre fault, and fallocate in various
> combinations to exercise both positive and negative launch flow paths.
> 
> Patch 1 - Adds a wrapper for the ioctl calls that decouple ioctl and
> asserts, which enables the use of negative test cases. No functional
> change intended.
> Patch 2 - Extend the sev smoke tests to use the SNP specific ioctl
> calls and sets up memory to boot a SNP guest VM
> Patch 3 - Adds SNP to shutdown testing
> Patch 4, 5 - Tests the ioctl path for SEV, SEV-ES and SNP
> Patch 6 - Adds support for SNP in KVM_SEV_INIT2 tests
> Patch 7,8,9 - Enable Prefault tests for SEV, SEV-ES and SNP

There are three separate series here:

 1. Smoke test support for SNP
 2. Negative tests for SEV+
 3. Prefault tests for SEV+

#3 likely has a dependency on #1, and probably on #2 as well (for style if nothing
else).  But that's really just an argument for focuing on #1 first, and the moving
onto the others once that's ready to go.

