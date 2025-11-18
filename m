Return-Path: <kvm+bounces-63616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CB5BCC6C007
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1AE3734AD03
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 196AD3112B6;
	Tue, 18 Nov 2025 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UddXLnjh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F063101DB
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508488; cv=none; b=F4mb3RyK1jOcz3sVgg7rP9B3k0QoOEpMUYI99lKDl1eqFEAu81bi/9SFvcON0pTfSbfIIq9Lm5ubBSTUs5+a5Go9QgiEdnSzX86QbSHrgVJfmq7kz02iZtcu/k56LVUMH+jDmh4CJeoryHaN9+r3Osj/Rr1Rqm4HQf5yFKFMB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508488; c=relaxed/simple;
	bh=+8XawmTy0t8LM48hngOcYXx+rEF9DgQHN+h2mK+MRc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fk03XNUcwI2xMO8uO98GbAvgcd3rxL/vNNA/nq2MBKWYB/Ixw3eyDZfaS5wLr0oMCiToLCw0u2dJDrp+WwN8EOvJsXBF5tEogH8SgH2mvcA+pFpP9aNgXWLZTEb0azecJZluuXORpX0oakyNyN2mavMemz37giKBSP0lko3nr3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UddXLnjh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34378c914b4so12984533a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508484; x=1764113284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqh1A6YG1sWsvtVK6BPfUeiOws1icxNQwhIYnxYFLFA=;
        b=UddXLnjhhZ/gKtxiN3w7glS93R4ewSOcid/Xb3IMHm7Y9JiiPVDNYqRe7iiMCqwt/1
         zoh66sN0fshkDGEjpa5JYcxzAZQ4NMZ0d7ZtmV2SFhmT9tCmS++WL1jmcLNPzErCVqhw
         IviWYc15OspxGeb2HK+gbivuF6TRegBf1Ob2zbNxIvkM1e9JRnN5TMbKEp3mohV+/Qzy
         q45Z7aWZHyy4GSgG3c8OxTrFn9YHxAmK04vFt1y2UkVmJ/r0YCXe5ashJ3TobJlF7SHj
         nSTzalhbNhyQxS/erw+8G9B6NNoWa1M/Lva+7w5XmDAOWXH169EgN39VRnIfQqASICav
         s0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508484; x=1764113284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vqh1A6YG1sWsvtVK6BPfUeiOws1icxNQwhIYnxYFLFA=;
        b=U7Cx7fhG8BfTLfw+nJAc0G97ZB//HtiXHmWV7rcTfa4IbeXF+513nzC2pdD9pDigmU
         wtAlRcZy3IqxZWozXlB6AGfV2m62n3Tfr6d4we2Kr+fj4eqoGXLCrVlu6zb+K7qUh9mK
         Z31RfjWQyjJ+pUM2Q0CILX9/k90cxNGb2W+yUyRwxhjWu8H67IAY44J2yvDX4wZ3Oxmp
         VP+cB6DXpb/cclPowiuqtiCJDHC3IUAlswoDsZz2LurjEomGnB+XnA84dPJvuBp+5Ofh
         DefaTbFys51ngJkGRIASBiIiwHofBs7UTb6WTnxmVrPDCtfOJ2o/w1WP5ABZpcUowFMN
         iO/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjzbKjsfmjxLIu2zcTSQ7takr9edZqSMoKXSeK5Eu/efRSAoalZ4goLlsHBUcQT0tc05k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlfU6aJdBh/j6sKNo8DKKEPhgZGsq0PVCLsDbSPy76esKi3ee2
	gubL6agTnMRF5Ti/COuM3reFIBLgX5Vy+VsCET4eLsDU3ocz6Z8ok4/BEK8SCOwp/vmr4vOI3Tp
	nCVlLuA==
X-Google-Smtp-Source: AGHT+IHUFHCIfU0mQDY+pFiQYb78egVBMHMdLsrVoIBRaXUyadkJuBlRNFZWxx3HqW0v+8BjzfzEy2XA09U=
X-Received: from pjbhi24.prod.google.com ([2002:a17:90b:30d8:b0:33e:3117:f86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b46:b0:340:54a1:d6fe
 with SMTP id 98e67ed59e1d1-343f9ec8b6cmr19219744a91.15.1763508484062; Tue, 18
 Nov 2025 15:28:04 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:44 -0800
In-Reply-To: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350815194.2284775.7554077996044651405.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Omar Sandoval <osandov@osandov.com>
Cc: Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Content-Type: text/plain; charset="utf-8"

On Tue, 04 Nov 2025 09:55:26 -0800, Omar Sandoval wrote:
> When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
> instruction, discard the exception and retry the instruction if the code
> stream is changed (e.g. by a different vCPU) between when the CPU
> executes the instruction and when KVM decodes the instruction to get the
> next RIP.
> 
> As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
> INT3/INTO instead of retrying the instruction"), failure to verify that
> the correct INTn instruction was decoded can effectively clobber guest
> state due to decoding the wrong instruction and thus specifying the
> wrong next RIP.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced
      https://github.com/kvm-x86/linux/commit/4da3768e182

--
https://github.com/kvm-x86/linux/tree/next

