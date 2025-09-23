Return-Path: <kvm+bounces-58552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E29F5B967F2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEA342A2A2B
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:05:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033A62586CE;
	Tue, 23 Sep 2025 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TZkEjTGb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B316B14A09C
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639888; cv=none; b=bErwXYtULiOhTUXnDaR6f8gnhGYRji76sUuVYtwuJ8Un9hhlT8i9YTDIcumKDvMutIG/wpyHeZgey5M+Ryocsfxppm4TreeT4wy841KNV1LCh36OLui1epTNS7ZNukIsH2VFfmKbdzweZ+GGUPIVsO0iPv6+lhfhQqz2W036vxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639888; c=relaxed/simple;
	bh=ozbjkzsxrfDX5twIBmcTO2kHly5O52Kundnyuo+ro30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bbIWz4ZxWdD1N9hPjcUWeliNczXtSOLWybdczeLc2zGgrf+DfznVK4U6Hds5/VKR7Zxvg/bTFypLyXDb+jO9WZ4Y4+RLVr7x1zS7AvbGfg44XE5Oz/F1vNCrpEYTYAEJTpr76I6ANQVfOFButmx3+AJlf/QcXbcaFkXYnT1jSpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TZkEjTGb; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-267fa90a2fbso74373875ad.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758639886; x=1759244686; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ErECzswpmXilrcdrqAzLrqqOTo2DOFzxXEwQQ/WZhFU=;
        b=TZkEjTGbTXzsIa3SiFaheml5bXlNHtUwac+3yWdW46MRtKjEqTLUXqgLnWzQAOZDIT
         lFPxz98OQqXm+GZExC8zaXWf2QPh+8lifBwdnuyTFZV1kuW7yqr0fXXVE3ZcErJjaAkO
         fodudtlZIF7IU3BnoRKfVNDqzUCrEtqajtBBGETeDHLsqK8lB7hTx6w48yBlmRm031x1
         9r+jSEXpF7ejbyWVUsw0UJzdTSKELFWJ8CLi9Dr+QtlWU8APLOqxkM3UV4CWvw3AQIkf
         uj6CkQwYROF9w9Hd0oW0/BAiSvPA/Iofm2RWelHtv8fgUCFyvic0crhtaU+zOTRu+GQS
         1NyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758639886; x=1759244686;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ErECzswpmXilrcdrqAzLrqqOTo2DOFzxXEwQQ/WZhFU=;
        b=Eqh/99AVh4RPOQLSth0sQ759CHBjVfXOyS7e8fshNOKv2a2H6zYxKJkOqzpposKYyd
         G/cFCmTuCqonP9252rzWBT6YVLUpzqx09VRJBVg82/SsY6pVngWXNpQeB/P8Pbq7GE1m
         hbZMBJLG9Gom+XpeC8pjXz9DyVMUkPiSy6ZueqQbvX6HKgrZfcHBoNOpqX+f1uK0O1L7
         3v3Q6Rc3eZJSehh06kLXqByFRwut1Y9wmoSY6ve99aIgbWHYf0LQtPnKiqfKjMsZTep4
         iogFm6Z/i0SuRse5XvQvRM67kycRcH6Rg/DP7tZK9MVyi8lCz+TcIy/Qa32nkqbjPYMs
         P5LA==
X-Forwarded-Encrypted: i=1; AJvYcCXMIB7Ya4fUTiicJ0O49Nq8TctzG6WOjKbLYyhdSNCuJgPFIO9Z3Q+cvJsGhvEqFvWRsvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YztuWn6JfQTikC/ItlHPHxDi1CX29qxVtpEofPtfjtXnTG+gi4d
	nNiZW/GscCcf6x1PUmnkrNXZRpbG39nXHVCgVcwbn8axQ6oikvXVcgaZrYCXXv5l9eunHF9958z
	ghXAeBg==
X-Google-Smtp-Source: AGHT+IF4ZDboFmV40ApjmHOAmwOGV2D+zkJJCq8GgZtfkHMqT5N+FHSoPo4NgY8Mi/pKYS+mmYiwXpjMrwQ=
X-Received: from pjbsj18.prod.google.com ([2002:a17:90b:2d92:b0:32e:a3c3:df27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ecce:b0:26c:4280:4860
 with SMTP id d9443c01a7336-27cd7268870mr34596895ad.8.1758639886056; Tue, 23
 Sep 2025 08:04:46 -0700 (PDT)
Date: Tue, 23 Sep 2025 08:04:44 -0700
In-Reply-To: <5dbc1100-6685-4eac-aa04-07f5621d3979@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-28-seanjc@google.com>
 <5dbc1100-6685-4eac-aa04-07f5621d3979@intel.com>
Message-ID: <aNK3DMk81Flftdaf@google.com>
Subject: Re: [PATCH v16 27/51] KVM: x86: Disable support for IBT and SHSTK if
 allow_smaller_maxphyaddr is true
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Xiaoyao Li wrote:
> On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> > Make IBT and SHSTK virtualization mutually exclusive with "officially"
> > supporting setups with guest.MAXPHYADDR < host.MAXPHYADDR, i.e. if the
> > allow_smaller_maxphyaddr module param is set.  Running a guest with a
> > smaller MAXPHYADDR requires intercepting #PF, and can also trigger
> > emulation of arbitrary instructions.  Intercepting and reacting to #PFs
> > doesn't play nice with SHSTK, as KVM's MMU hasn't been taught to handle
> > Shadow Stack accesses, and emulating arbitrary instructions doesn't play
> > nice with IBT or SHSTK, as KVM's emulator doesn't handle the various side
> > effects, e.g. doesn't enforce end-branch markers or model Shadow Stack
> > updates.
> > 
> > Note, hiding IBT and SHSTK based solely on allow_smaller_maxphyaddr is
> > overkill, as allow_smaller_maxphyaddr is only problematic if the guest is
> > actually configured to have a smaller MAXPHYADDR.  However, KVM's ABI
> > doesn't provide a way to express that IBT and SHSTK may break if enabled
> > in conjunction with guest.MAXPHYADDR < host.MAXPHYADDR.  I.e. the
> > alternative is to do nothing in KVM and instead update documentation and
> > hope KVM users are thorough readers.
> 
> KVM_SET_CPUID* can return error to userspace. So KVM can return -EINVAL when
> userspace sets a smaller maxphyaddr with SHSTK/IBT enabled.

Generally speaking, I don't want to police userspace's vCPU model.  For
allow_smaller_maxphyaddr in particular, I want to actively discourage its use.
The entire concept is inherently flawed, e.g. only works for a relative narrow
use case.

And IIRC, Sierra Forest and future Atom-based server CPUs will be straight up
incompatible with allow_smaller_maxphyaddr due to them setting accessed/dirty
bits before generating the EPT Violation, which is what killed allow_smaller_maxphyaddr
with NPT.

I.e. allow_smaller_maxphyaddr is doomed, and I want to help it die.  If someone
really, really wants to enable CET on hosts with allow_smaller_maxphyaddr=true,
then they can send patches and we can sort out how to communicate the various
incompatibilities to userspace.

