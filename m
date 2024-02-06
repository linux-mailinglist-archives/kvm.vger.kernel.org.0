Return-Path: <kvm+bounces-8153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A573584BF4E
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:37:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D792E1C24546
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2508E1BDD9;
	Tue,  6 Feb 2024 21:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WXmvLAUx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF7D1B95B
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 21:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707255411; cv=none; b=X/QyPbv2Y7N/Px+vSv3E2iSkPHYOOaHOZdjyxemawRJNM++bwZ68l6pdzR0uplJEqs4IXkDxLQDOVn8UXOkw7Ayn/gWRRsWnPeDlc4X6UtH4i0ZlPk+sdVW2i4VlWr9Udp3zLKS/eeD1a2bg9wXmR5k0QklIpVDx2AE4f68S5dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707255411; c=relaxed/simple;
	bh=FknqZ+WNmZz1THT4v9fAbYqlAUOH+X/XxDV/AeuUIO0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UGvEmHeNYHYtOU+nSpOMBS/MBWxO8dv673p919z/OqCRm88t/0pri0wCwhH7kZOhqlcx1QHFBOpHfHya7oGyy5U8JTg2ly23c27PsDi7KaWzxk3NhRQ3/K9Nh4OHgHsOrtrfmnJxtGH2WslcI4ZLKDxZ8e/v+diHMEhEqJyQQXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WXmvLAUx; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso11517916276.1
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 13:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707255409; x=1707860209; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=34mktqDKXmw57whU91oMD9AEN7YGrzS8LH/0whEakSE=;
        b=WXmvLAUxw7y/cRAzoLcUsCY/0U/jlrbHEGvnsKFRFy6h4gBiVLAkcqiLvYJOWCWyCc
         lAmKq4KKZFH1g4fMR6HxWlHmFz0zKj1QGMCdIVO2rH4v1MDI5KcjFuC5Bwnfx4yExgMi
         dcIIm+/IzuPuMYvDchrQrazulTKb/Yto2XZVB4zL2eVe5jueBNUELvLRe6u/0tDY9Hz2
         B8kP0AP+O0teCqBMou+Sgpci8fnl/KEsPBNZuhMWiLunyYwiwF0RyfXSIWOD4nZAbLVP
         C63ZakI2ZWDKYyfhrBoR0o2IspUsJBvHhNO+hvrqEECIs7AOwjrThU1TeRhKX0KKVZjW
         hpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707255409; x=1707860209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34mktqDKXmw57whU91oMD9AEN7YGrzS8LH/0whEakSE=;
        b=rDQLSSbIuqRxWH/YCCvEdkKNwwyZUwsRyn3fOtSRXzOuPjH4paIevIdU1pzjZuEeuY
         0JbLkRH5H5IhtYuhALfcIcHeqTl2XN0aK8jiaa18ACWXnZRm7lQrqR43q7FVVMuc/rsn
         Ap49lFz836mpewzqlGPhGd03Mpg/sxX0WEfGPSwuIzK4QeQcHYJhI0UYwcBI9Y1jSkbz
         znjOpHGayIbGOp/QQpklOrIbrdYfO7E4oUrqtp444oyuoyPlf17bP75kmAkK04eIT8jq
         SJzrQw0ybe4RvRkv3P7eUuWRgj0DLlXNAVi1WJO40Gl69hEnkGqtSI259e/qZdqAUNBG
         dSJQ==
X-Gm-Message-State: AOJu0YxAuqelXFRLHfRmqua5+hdGsag2mg3OF5FhlevE3tu9NsqtypWm
	WXTfosA9hB+oKC1pT6eaO1sQbYYOja8E+ZHA4us/sHSkWpmUBI6XNL1M2xo3fCqZ4qWOYSxPA/h
	PrA==
X-Google-Smtp-Source: AGHT+IHdPZHMZB6qjbGkbN4fYBOtMR+sI0A1AVYgiujDy1NaSqqqM5xHnjK+Xr4vKELP5tDRmdGSLpe16qA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2187:b0:dc2:1cd6:346e with SMTP id
 dl7-20020a056902218700b00dc21cd6346emr741389ybb.8.1707255408886; Tue, 06 Feb
 2024 13:36:48 -0800 (PST)
Date: Tue,  6 Feb 2024 13:36:15 -0800
In-Reply-To: <20240131222728.4100079-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131222728.4100079-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170724571856.385900.17051156735736269281.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Don't assert on exact number of 4KiB in
 dirty log split test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, Tao Su <tao1.su@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 31 Jan 2024 14:27:28 -0800, Sean Christopherson wrote:
> Drop dirty_log_page_splitting_test's assertion that the number of 4KiB
> pages remains the same across dirty logging being enabled and disabled, as
> the test doesn't guarantee that mappings outside of the memslots being
> dirty logged are stable, e.g. KVM's mappings for code and pages in
> memslot0 can be zapped by things like NUMA balancing.
> 
> To preserve the spirit of the check, assert that (a) the number of 4KiB
> pages after splitting is _at least_ the number of 4KiB pages across all
> memslots under test, and (b) the number of hugepages before splitting adds
> up to the number of pages across all memslots under test.  (b) is a little
> tenuous as it relies on memslot0 being incompatible with transparent
> hugepages, but that holds true for now as selftests explicitly madvise()
> MADV_NOHUGEPAGE for memslot0 (__vm_create() unconditionally specifies the
> backing type as VM_MEM_SRC_ANONYMOUS).
> 
> [...]

Applied to kvm-x86 selftests, with the assert print goof fixed.  Thanks Tao!

[1/1] KVM: selftests: Don't assert on exact number of 4KiB in dirty log split test
      https://github.com/kvm-x86/linux/commit/6fd78beed021

--
https://github.com/kvm-x86/linux/tree/next

