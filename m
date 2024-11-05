Return-Path: <kvm+bounces-30629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA4119BC52D
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:02:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BBF21F227B5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA10C1FE10C;
	Tue,  5 Nov 2024 06:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BSASd48J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB651FE114
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730786406; cv=none; b=MTMyGDRf5ZoKl2yqyDtc/SOWIQFiPKjXJs+WG7Jw0JxefRxPrcqbd5FDZCaUhSbMY4yZi7y0kzpH7PJHe4pX1VGVBdYNQy+VuDWmfF9uA+Rw0YShpKzx5FTIdycLKpjKiJGn9BlgE5SjxnatrCV+yHszVxEDubCabqdZdb+UTYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730786406; c=relaxed/simple;
	bh=kf+7Accy6CZITG7h9C9RSJTgRVLioJ3IQ+T+jT0W/Yk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lrWYL1bSgl4AR3HI7OfOg/nrdvTlvUrfwW7paf8kF9eVZM0qsq340YSK/bZGP4GMaglKu/elgHBIPv61B/9gZAkXkyD3abIxpLDHCazt3BX9gQ6L2DxsGDG9nQ5NME/o1wL9/cr1PUzm3NVKyvMuc1R4I7sC3jkrAmpt4u6hvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BSASd48J; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30daaf5928so9698398276.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 22:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730786403; x=1731391203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri3RqHmTLiZgbXf9JSoGbE6G1FscJroKHNnlpbYcnZo=;
        b=BSASd48JH6PkZd2PH9Za5UTfMUIZy24M2nYugeeLRNHEQPOmD/fUfMysVG8AnJ8c9t
         Un3SDlUGzcODTW+U0mfJXz5qiTf3yU1bxDt7jhd1be67EMyveUysYdRliieRWmozQABk
         JMtg5xmPFQAgopzuKaudXqeXLDjQwkHUMdkM4kFDYtIaRcDEziO81v9dBuhLdbEmLzCv
         7kH1v/qbeNuBNdlYMcL0nEdQAKnc5xWiUwF9ZbLv9XOU5jEkFbN840sHvtG/KAt81q3k
         Zml9XEfB+txkARx7frVZgOCUjDq/rFPnETzGgeewQ8sVLjcz8xf/3eLvVU09pMcQQ2X6
         e/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730786403; x=1731391203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri3RqHmTLiZgbXf9JSoGbE6G1FscJroKHNnlpbYcnZo=;
        b=Pn2PBlbNaVMFD7SSkFJjcNjuZAbiH425ULZZVHeLaFdoSaEqzH6RKX/Xop9m4Zf12P
         u5FXgTB2aU9w4YmnucDhrXAA8pv0Rz85iqXWz+CJqFmK5WefltjZCjMGV7B7YAH3MeVI
         0aWO4Hn+ZjDxpRQiz4Ji2PvS8VSItaWGrhjm+20452XF3g9Z0MW5OnR9mKGLibq+CeCn
         mAgqHzxWCummSH5uODzTPNcoqHr6f1JfBP2fdx74Iik/YAkY+d0s33RCDu2dpKiVk5S/
         SGFETwa3ZvCk0N0KEMUV8cB01Z8uEZTsfiOuYaCeC3EYiwtzMZxQPI7dTE2ol4GsrXgW
         Rp1w==
X-Gm-Message-State: AOJu0YzWqQsuX4fVen9uaOI4Jj+wLzgZOOpMFhNaJ4HM5m0OVuXPh3HU
	5u7MgTjzApS9LYHBYvfMxaqf8bZByKojAGns74xqn0xjTN2nMasAcJXkaw7A17lQ1MbgsyVNxRd
	dlg==
X-Google-Smtp-Source: AGHT+IGKVKtM8Ffc2jO4jvTWqz5yAvsn/9n3AuRdgX4tVf4RVSfxkazIleVhDhE7sntsbdibbJREfdYK7NM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:c78c:0:b0:e30:cdd0:fc0e with SMTP id
 3f1490d57ef6-e30cdd182bamr29895276.5.1730786403410; Mon, 04 Nov 2024 22:00:03
 -0800 (PST)
Date: Mon,  4 Nov 2024 21:56:05 -0800
In-Reply-To: <20241101183555.1794700-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241101183555.1794700-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <173078282116.2039208.10289720113824611268.b4-ty@google.com>
Subject: Re: [PATCH v2 0/9] KVM: x86: Clean up MSR_IA32_APICBASE_BASE code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 01 Nov 2024 11:35:46 -0700, Sean Christopherson wrote:
> Clean up code related to setting and getting MSR_IA32_APICBASE_BASE.
> 
> E.g. it's absurdly difficult to tease out that kvm_set_apic_base() exists
> purely to avoid an extra call to kvm_recalculate_apic_map() (which may or
> may not be worth the code, but whatever).
> 
> Simiarly, it's quite difficult to see that kvm_lapic_set_base() doesn't
> do anything useful if the incoming MSR value is the same as the current
> value.
> 
> [...]

Applied to kvm-x86 misc.

Kai, please holler if you have any concerns with patch 9.  I'm more than happy
to tweak it as needed (or even drop it if necessary).  I applied it quickly
purely to get more soak time in -next.  Thanks for all the reviews!

[1/9] KVM: x86: Short-circuit all kvm_lapic_set_base() if MSR value isn't changing
      https://github.com/kvm-x86/linux/commit/d7d770bed98f
[2/9] KVM: x86: Drop superfluous kvm_lapic_set_base() call when setting APIC state
      https://github.com/kvm-x86/linux/commit/8166d2557912
[3/9] KVM: x86: Get vcpu->arch.apic_base directly and drop kvm_get_apic_base()
      https://github.com/kvm-x86/linux/commit/d91060e342a6
[4/9] KVM: x86: Inline kvm_get_apic_mode() in lapic.h
      https://github.com/kvm-x86/linux/commit/adfec1f4591c
[5/9] KVM: x86: Move kvm_set_apic_base() implementation to lapic.c (from x86.c)
      https://github.com/kvm-x86/linux/commit/c9c9acfcd573
[6/9] KVM: x86: Rename APIC base setters to better capture their relationship
      https://github.com/kvm-x86/linux/commit/7d1cb7cee94f
[7/9] KVM: x86: Make kvm_recalculate_apic_map() local to lapic.c
      https://github.com/kvm-x86/linux/commit/ff6ce56e1d88
[8/9] KVM: x86: Unpack msr_data structure prior to calling kvm_apic_set_base()
      https://github.com/kvm-x86/linux/commit/c9155eb012b9
[9/9] KVM: x86: Short-circuit all of kvm_apic_set_base() if MSR value is unchanged
      https://github.com/kvm-x86/linux/commit/a75b7bb46a83

--
https://github.com/kvm-x86/linux/tree/next

