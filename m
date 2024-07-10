Return-Path: <kvm+bounces-21319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D8C92D530
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1E90B231A8
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA55B1946CA;
	Wed, 10 Jul 2024 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="etqYWTrI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC291EB2A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626146; cv=none; b=HR3/y+z2zDAT7kBSk0SthO3mwwglP43dSWk0H8K7SvTwt2sGs24IEaQ+FQ5GtW6HIrQ7vsg+ra7w3c7m3ri68U7NEKOHc4XGJE83VQ+/S0dDkvQEU6fQJq2Njg0OBLDCA4viXW3kYjFeWMg29hDDGtRUhZHcIOC+iq7qcfPCp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626146; c=relaxed/simple;
	bh=C5gY+uljMJ/TRBVbOsR/U+KA7yyl6SUm21CDlJJs9PA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WlZQdsEU2SPgYIWeaqZ+0CU+uF4pFX8b0dwWlIl3MxQJmgPdbjWgIdFoQ/T8W9WaBh989/Z8nijYBO5l6FooOUGOH03bSuPrO0nlt1mjWfkb48g8sNRkE2Epqg9LPJknW//Emx34sLQuvaF43c/spi/Eu6kIfn4HnqZSIFkqZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=etqYWTrI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c98105058fso4424311a91.1
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720626144; x=1721230944; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vr1BiQBEp9CDY456xclZlBCD5OqWtOAN5xfFP72uoHk=;
        b=etqYWTrIVfLDQODIy3T1a3X0m1dxtnn2r3ccGn92e2eIwab5Hite794/6HLJt+4Ieq
         +e5h2VRDMhBRQbJnAH3hZcj82JalX8xFB63c0rKdKbvJHyHaIlGuxc0F8dwF7OJ4GAB5
         HAYXnkj6JVES2ogGf4rK/6QjeprpDJcj6wQ/OhN8V/bPlSS46PRuhPZM+FgvlWhx/k+b
         Xxxy8TbRNl9ITs1NdqiJiDha4NtzcgQLXEa69kcWSBjfyMw1eNUU3PodFSwcnchIaxxO
         BJwMyLcXgCNrxGtT/Zbq7QDjmcw/Lk72k1KHRbI/M/CgLNbLCm4zQOZn5tL+GlvqOzMJ
         Nguw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720626144; x=1721230944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vr1BiQBEp9CDY456xclZlBCD5OqWtOAN5xfFP72uoHk=;
        b=NvgAgTcL7on6xeinbjwIAmDdLLmJm3Y+T6RNt6gxf8HzIvG1lNN2/JldzGCDIPtZ+G
         D/6rtKZO5qjmcrDMSdO+6+6zuaBziHoTpny+D/6TDdZWQKs9fzuDtdUHhJpLYubToEPN
         DA9/5paQDlkfmro/DsEe8sQEhAxFBSP760XyhLnJeSnYDtMQH42MlABKBcLY90HRVvTR
         6EHnR2wfmzjrn30WqrkozkI2+aoH8nZTMHFmdWeK3AqTRehGqKFf9iLzFuincEytDv+E
         Acm0Q8XA1LLCvtd6XyjfNq9k9Z2haUzOq4a44oKLPbrDFX1kptGE0lo0nv89FwQkUnjx
         0MWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzcsBSiYuJzwoHEdhn3K2HFkvfTgCdupFwz73wItUQAfwVFpYcy2pk+YJGrHDg28M4Qs8+I7QAkpRG6AelhifSaO8P
X-Gm-Message-State: AOJu0YxkwKn7LUmpLi4iBccO1r7hM7AKlDQw6SluwWcehksbKGNn9WDa
	MVYedsl4Fc+Az72gzuno8yE9XaI589BRXRc77VVMujZnp7oYClUOmyUYWPTeh0zt5Zbhl3q3ksi
	GvQ==
X-Google-Smtp-Source: AGHT+IHIj7Frqqn9vAIzHqtf502PiSXlpH0diSrPuQbhr/RJ6vdXrfi41gkE/7i/gmNkhPd0gOtvr19TZbE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a412:b0:2c9:6abb:ee40 with SMTP id
 98e67ed59e1d1-2ca35d524b8mr13373a91.6.1720626144135; Wed, 10 Jul 2024
 08:42:24 -0700 (PDT)
Date: Wed, 10 Jul 2024 08:42:22 -0700
In-Reply-To: <5354a7ae-ca32-42fe-9231-a0d955bc8675@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <171961507216.241377.3829798983563243860.b4-ty@google.com> <5354a7ae-ca32-42fe-9231-a0d955bc8675@intel.com>
Message-ID: <Zo6r3if6rTERxnwl@google.com>
Subject: Re: [PATCH V9 0/2] KVM: x86: Make bus clock frequency for vAPIC timer configurable
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 28, 2024, Reinette Chatre wrote:
> Hi Sean,
> 
> On 6/28/24 3:55 PM, Sean Christopherson wrote:
> > On Wed, 12 Jun 2024 11:16:10 -0700, Reinette Chatre wrote:
> > > Changes from v8:
> > > - v8: https://lore.kernel.org/lkml/cover.1718043121.git.reinette.chatre@intel.com/
> > > - Many changes to new udelay() utility patch as well as the APIC bus
> > >    frequency test aimed to make it more robust (additional ASSERTs,
> > >    consistent types, eliminate duplicate code, etc.) and useful with
> > >    support for more user configuration. Please refer to individual patches for
> > >    detailed changes.
> > > - Series applies cleanly to next branch of kvm-x86 with HEAD
> > >    e4e9e1067138e5620cf0500c3e5f6ebfb9d322c8.
> > > 
> > > [...]
> > 
> > Applied to kvm-x86 misc, with all the changes mentioned in my earlier replies.
> > I'm out next week, and don't want to merge the KVM changes without these tests,
> > hence the rushed application.
> > 
> > Please holler if you disagree with anything (or if I broke something).  I won't
> > respond until July 8th at the earliest, but worst case scenario we can do fixup
> > patches after 6.11-rc1.
> 
> Thank you very much for taking the time to make the changes and apply the patches.
> All the changes look good to me and passes my testing.
> 
> Now that the x86 udelay() utility no longer use cpu_relax(), should ARM
> and RISC-V's udelay() be modified to match in this regard? I can prepare
> (unable to test) changes for you to consider on your return.

I don't think so?  IIUC, arm64's "yield", used by cpu_relax() doesn't trigger the
"on spin" exists.  Such exist are only triggered by "wfet" and friends.

