Return-Path: <kvm+bounces-9471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D23E86085D
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F16285B67
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F015C12E5C;
	Fri, 23 Feb 2024 01:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mMoszKoS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAC31426C
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708652215; cv=none; b=OjMhTr8bWK8BMDJlegWlygtCoIj2xgCkY7XB9iO8No9vt9K8jr6hMuGZSjpApY4YFXzcG0UfcGNdIXN33WrFgWqJaukRfWO/O4QKoshiq1HIdP+G6vLvQAIywxtu8zcbajkPrQi3KKoiUe3wLzg9rnaLyqrMD94qdcUqkuVDDwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708652215; c=relaxed/simple;
	bh=fI3ejT6Y2Z8uFS5y83UfDEJ92PnySLL/joA3XMKsaaI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mOAfNV0NOj5tkX5sRn4VH8z9jeiUZT4sLHqS6nVg//ZrB0he6myGFF43CFdPwghq63JBfvTQ0R2Xj/EKZJQPqtqOWLScHfAlFpb7McXkF2hwgQ2HR46IqjNeAlkb6aC7FWrG0gB9oeebqvk8auwBsFfcARpS/BYh5CGuzC9r09w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mMoszKoS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dcbb769a71so315931a12.3
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 17:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708652213; x=1709257013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LislQMo+ty6pik6/y36wdyvKCsWJplgKdipRzrWuMSw=;
        b=mMoszKoSnwz3CuPc0dth9LHEDisi3RhwUk8o0B7zUKW1HreDHp/+jfZ5bb6CMvyC6X
         Vge7/gq3q1ghOLeFQneJ6/yMiTt7pOBSg54tmMIIrDoWFeDJry1qkebtx4Ibfs5VAbzQ
         V12n5uwsuBr2IwLgX46GSrt0a74M8rxloj0/oup8KLaxRW4J8S5pCQFwYq0UJfhomFfd
         LLsR+HO07qmJAvIaT3he6nAmtkDU67IQloEW+PkzG8msBusZmiHaIHxxtAZaUHsPSVZ+
         g7QHY/Eo+Tvl04cxKrVv1PIyxDEsx007oP7/royA7CEC1iVDmat9NII5CHwqFXPWeAKq
         mjZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708652213; x=1709257013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LislQMo+ty6pik6/y36wdyvKCsWJplgKdipRzrWuMSw=;
        b=D8D+Wet/sGzXRBVUtZ6AR7CubqppBRUiA1bgqeadfPQDPVNDG4VOeNkReqcVwtKapZ
         0UwPZe6OJuLeVXE3HZcAGgFJHp5eBuqnd9Reo6wWq0tXzcpyEjgoQEXF7LbmSERMkxlN
         rSqWIjBUFZLHmgsVMFb2WboPJj2ZLZ58+XoN8TR1D5h9PJfianhdzZicYP6AbLbA1KQ5
         PPQ+bdv4+4BDcgrbliBx784DxVbzJYWZBnl68RAaJvjekdsxbayu4EpfuiyRrb8xOirr
         yCUDMOKP6Ly5A7ikNGGLjOsgjbH90YMcKIKuGEAF2AmZTDRVCpeVEgJNc5mNrlmG1fDf
         nHfg==
X-Gm-Message-State: AOJu0Yx3IEbZEcPnq9Nzf7m1sISDodB/1ZNqUCjxXhNTECOqRFO1F8NC
	1FKG1iiNNdV2VG+pCoYUZIJC9gOmIIZdDgsOsqHrMMISplutRUWZvE497nCJLpZEON50XYzvMVo
	Whw==
X-Google-Smtp-Source: AGHT+IEV4yYhuTiaX0bKMSzbKg9NeAK+kXUk9I8iM0XFxl1GMCmm4rxR7Pi7eAb62VnuUo7MIb3Dx4Dp+TY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:996:b0:5dc:8f83:ca2e with SMTP id
 cl22-20020a056a02099600b005dc8f83ca2emr1444pgb.0.1708652213216; Thu, 22 Feb
 2024 17:36:53 -0800 (PST)
Date: Thu, 22 Feb 2024 17:35:50 -0800
In-Reply-To: <20240218043003.2424683-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240218043003.2424683-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <170853139870.2603264.8863273316877757640.b4-ty@google.com>
Subject: Re: [Patch v2] KVM: selftests: Test top-down slots event
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="utf-8"

On Sun, 18 Feb 2024 12:30:03 +0800, Dapeng Mi wrote:
> Although the fixed counter 3 and its exclusive pseudo slots event are
> not supported by KVM yet, the architectural slots event is supported by
> KVM and can be programed on any GP counter. Thus add validation for this
> architectural slots event.
> 
> Top-down slots event "counts the total number of available slots for an
> unhalted logical processor, and increments by machine-width of the
> narrowest pipeline as employed by the Top-down Microarchitecture
> Analysis method."
> 
> [...]

Applied to kvm-x86 pmu, with a very slight tweak to the shortlog.  Thanks
a ton for the verbose changelog!

[1/1] KVM: selftests: Test top-down slots event in x86's pmu_counters_test
      https://github.com/kvm-x86/linux/commit/4a447b135e45

--
https://github.com/kvm-x86/linux/tree/next

