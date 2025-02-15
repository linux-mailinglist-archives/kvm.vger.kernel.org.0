Return-Path: <kvm+bounces-38217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C58CCA36A62
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 451DE1893C0B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 00:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4900719ABA3;
	Sat, 15 Feb 2025 00:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wtod9iN6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA817BEC6
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 00:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739580902; cv=none; b=Rxc9sXYZElRBKsZ8mZIK5UxM3lVc/LAsXTeaTK9FVyWbf9h7eJaVj0bDsSizXG+DhJQwT+BwVdMIPXwKBrdsXs/W+Hwc5p94WZbx90qK4PNNdEvNYgoEmObNfi+Kau1LsQN8QXXtf14NNYn+bSju571I4T7kRCYRUN38wcMX8/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739580902; c=relaxed/simple;
	bh=EOahgPz6fyQhSLBWqHv6GC8sZf/XOeLdOvMNVwUIpnY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o6z7nPA+zevb0JIrTbDN0O3CIlz4nUA9l1JofWZ8vPDgIU2qKVVTU8gzBbMrw/O/0AtcmbSxMeqASJGYoanWcp/uggGwveHgKWmRxG8QbR2c6fAsr7WP/RaboxMS562w/kClFgsKjYN2DtEPS0eny4OhxYVUU/NkmQQ5L5Ozc8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wtod9iN6; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21a7cbe3b56so43492265ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 16:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739580900; x=1740185700; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gTgQsorQjh14TutxhLLCxQmV6p+nBtXX/1kn8rG1LNI=;
        b=Wtod9iN6Ol6G1C2+n1COE1+3IjxIyqlCgOZuiNA91jEzp5cPW2wYUmAPhKrT4v0t7I
         j+VEZPjvV1cXMDEaNcKxBv36Ai8pgKLYQ98JOjaIQtIyWbpCMTTaxR6Mi21stYMRRssY
         YBXBfuxQDRUnKzED+ijt7k527hVQAsCZl52W4OSePiplLvj/FPhNgVMbizhRCEouRb+6
         yWckVuoUSLT+gRApobHMwWEhfGR+y2lBlXk2JP3eweaJJ1YQlBPhZNDgm2ddryVupYmy
         jhN9G6DQikxakNfMo/GMoMXZGQoYgg5bwo4Fz4ZRhCUXPk3/k4eWuaHS2cx/wIa8VV5e
         uBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739580900; x=1740185700;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTgQsorQjh14TutxhLLCxQmV6p+nBtXX/1kn8rG1LNI=;
        b=Rcwz5nAA3GV7xlS3JQ3vWFWuIQRQXwNm/FGXIPXCXfqdyru/lceXnyRnF9deZJD1UE
         5QTe0wOYJRYkkA3ltkmwn9Tm3dLpb6XcQEu8sJFwuL+IX0eQN6n6Rc6HjQiBZ2LC1q4f
         7xubMgq34d57IfZyZncyh538nBW78P2BahssjvrW1deGovyTdMp52EsHWXfVPM4WsOBM
         mqeBrmfgIJ2NylrTfHbORDQQDgTCHquBNn9e7EN0roggqvzwqqNHNE1czrrsdsqSbFjm
         H3cgotwsWROybVRhxJYi78prnbPfjyg/RB7Z/M0u5unuckbwHHkYaePBIh7hgYyA/2Ap
         5fCg==
X-Gm-Message-State: AOJu0YwDnj/tmBcda8Jo2B+NRoqT1EdQ1vV0S40cepJ09ycpirhfov7y
	oAfJNQ3Ko5jdDhJS2OYPHSPLn6pCa/1UBDcFOIqTalG2U5izjZJC9QV4Kw/dMs1bk7mlsgoosWI
	Mtg==
X-Google-Smtp-Source: AGHT+IFnNgJr4fAST/anqb/OhGfaJPL4qFzSio+iAadkBSAqDbENgFOFYfhtq5SRt2eIpuzxLd/Yc+sQw1s=
X-Received: from plblg3.prod.google.com ([2002:a17:902:fb83:b0:21c:5115:8766])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f787:b0:216:410d:4c53
 with SMTP id d9443c01a7336-221040b1916mr20971295ad.41.1739580900440; Fri, 14
 Feb 2025 16:55:00 -0800 (PST)
Date: Fri, 14 Feb 2025 16:50:18 -0800
In-Reply-To: <20241211013302.1347853-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241211013302.1347853-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <173958033580.1190199.12371307462069862956.b4-ty@google.com>
Subject: Re: [PATCH 0/5] KVM: x86: Address xstate_required_size() perf regression
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 10 Dec 2024 17:32:57 -0800, Sean Christopherson wrote:
> Fix a hilarious/revolting performance regression (relative to older CPU
> generations) in xstate_required_size() that pops up due to CPUID _in the
> host_ taking 3x-4x longer on Emerald Rapids than Skylake.
> 
> The issue rears its head on nested virtualization transitions, as KVM
> (unnecessarily) performs runtime CPUID updates, including XSAVE sizes,
> multiple times per transition.  And calculating XSAVE sizes, especially
> for vCPUs with a decent number of supported XSAVE features and compacted
> format support, can add up to thousands of cycles.
> 
> [...]

Applied 2-5 to kvm-x86 misc, with a changelog that doesn't incorrectly state
that CPUID is a mandatory intercept on AMD.

[1/5] KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init
      (no commit info)
[2/5] KVM: x86: Use for-loop to iterate over XSTATE size entries
      https://github.com/kvm-x86/linux/commit/aa93b6f96f64
[3/5] KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the vCPU has RTM or HLE
      https://github.com/kvm-x86/linux/commit/7e9f735e7ac4
[4/5] KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the CPUID feature bit
      https://github.com/kvm-x86/linux/commit/a487f6797c88
[5/5] KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID emulation
      https://github.com/kvm-x86/linux/commit/93da6af3ae56

--
https://github.com/kvm-x86/linux/tree/next

