Return-Path: <kvm+bounces-10146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AE3DA86A1B8
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 22:31:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65C4D28D924
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:31:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2098714F972;
	Tue, 27 Feb 2024 21:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s2q9JW4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA35D14EFED
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 21:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709069489; cv=none; b=MfRpFADgKh7WqTQ7gLSDm2wr1u/IFYzeMfz5Gs/h3Qz3Az+oeRksxz3rCyupXsTaKx+05PR913LS6hfRNmcAXgQWouDHyo/bwYtSaXFNBOOShFNoX6h6/sFiQ7ZnKxnxbxP5PQ8FKSCBH9M4ykL2YySPAg7Ga2mhJC8ABIKXwj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709069489; c=relaxed/simple;
	bh=1ngWzFe6552eXSygHbHQWcAZZReIAzpNojL6T+WcIv8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I8UoXZRQzza69RIyzEWSCmH4w7Qwesc76u3hEry1pWSmPCQYOZhpZmic58NDdpy/fkag2UA7LcC0GQlTG021CYPCIVs8GmE0843bDtApck/kgTfeL89DlQmefIfxtnI0xXKZIZBnTMUXsXYGEbFkKeVoQ49ePBo1uzzPDlDNKpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s2q9JW4q; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64e0fc7c8so7155989276.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 13:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709069486; x=1709674286; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hZP15haE9JalPlKvzqt0FWShTWzP89HEcDeWVmjgfEs=;
        b=s2q9JW4qhwf+kyq1+52HxMyBAc2FgHuoPNe8moEBDBakTIje4+kvUXju55tkZOPWgI
         BXSj3mDlx9+RkziNB0Otwncu0gdO0Ifq0JtVvSTy6mqebMk5k4rOanLIwDWFYwqHQfRd
         1VDv6yPqTsHySKr1Y8Ebt8/ZBrOGiKPEa9mS0dYFEWNzbHj7b00ugDKXd0Dxr7e+07zt
         UNvVM+APPZ5WKXilr4e0trsMZmB5yF49O7kfhUyh075pY5B4RR/JwtLPg/1PvL5Ihm9h
         Paj1LqUKjkkM/P6UuUQCQYP6wFePPDg7HOGTRQvqpMfnP/5JOlSDqXHm4rCwjvmd3WY8
         7qPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709069486; x=1709674286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hZP15haE9JalPlKvzqt0FWShTWzP89HEcDeWVmjgfEs=;
        b=StNG5L9Wsa6E4oXRjTgQKhxCko/0SOCZI7ed0qRKyXJRwX0/uXNNhGTYGtocPdXBnv
         kfzM1u1JunmCcXSbo9pyulIW/T9Q+Of8DcO+rrt2Gohjh+D2Mf5wT68WYouNuaocI7nK
         5Yfr4U0IOfch3XPbV9CTAyZkqcKg6vbjdVzAyTcMzE3a8SX++wS0ooyPtKqjclaiB34n
         uNqqv9DKNefuhXRZRh/9XmyXrkyr9j/th57bc5SXVhwBrM69lIVIsHNceP+lRyQ1XsNA
         gbeLVgzFtbah7odCZaEn1uvdZLowr81RzLJ38e0z/09+AJIBKOWXCJybMYGWpugTRU1R
         nTng==
X-Gm-Message-State: AOJu0YyEnfMicZh0CDUPYbhsRx0O/DZhG53kSYMOT1tMe6Wu/4Qdmcc5
	N11ji3Kt2NL4b1ocUdLRh4nvBX1EZ7xV4avMBnk5pU5SfnG3jpJq8XFbEe1I2M+v3rt4TJZ7dI2
	iOg==
X-Google-Smtp-Source: AGHT+IE40eaTQIy4w8adAPFQCTUbDyi33sF2AxJ4EP+nO/Hdde6NYg8So6iu9F9Goc4SPQMp+xou9z4+mvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1082:b0:dc7:9218:df3b with SMTP id
 v2-20020a056902108200b00dc79218df3bmr51209ybu.10.1709069486746; Tue, 27 Feb
 2024 13:31:26 -0800 (PST)
Date: Tue, 27 Feb 2024 13:28:20 -0800
In-Reply-To: <20240223202104.3330974-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223202104.3330974-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170906381686.3811155.13601943682251493126.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: MSR intercept/passthrough cleanup and simplification
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 23 Feb 2024 12:21:01 -0800, Sean Christopherson wrote:
> Clean up VMX's MSR passthrough code, in particular the portion that deals with
> userspace MSR filters (KVM needs to force interception if userspace wants to
> intercept even if KVM wants to passthrough).  As pointed out by Dongli, KVM
> does a linear walk twice in quick succession, which is wasteful, confuing, and
> unnecessarily brittle.
> 
> Same exact idea as Dongli's v1[*], just a different approach to cleaning up the
> API for dealing with MSR filters.
> 
> [...]

Applied to kvm-x86 vmx, with Dongli's suggested comment indentation fixup.

Thanks!

[1/3] KVM: VMX: fix comment to add LBR to passthrough MSRs
      https://github.com/kvm-x86/linux/commit/8e24eeedfda3
[2/3] KVM: VMX: return early if msr_bitmap is not supported
      https://github.com/kvm-x86/linux/commit/bab22040d7fd
[3/3] KVM: VMX: Combine "check" and "get" APIs for passthrough MSR lookups
      https://github.com/kvm-x86/linux/commit/259720c37d51
--
https://github.com/kvm-x86/linux/tree/next

