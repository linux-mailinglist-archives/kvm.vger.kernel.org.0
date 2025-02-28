Return-Path: <kvm+bounces-39777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45367A4A6AF
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02F4E176DE6
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1942A1DF740;
	Fri, 28 Feb 2025 23:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4tsCLW6L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E751DFDA2
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740786077; cv=none; b=PkFHAffQD1+tG3yQslO3TnAsFvhaCMV/+YPcpcOFzSStu28gWpFMzI6P0nq/Hs82sIc+rkQjylR9WRLzs+qH94YNM4B2Nvs59/z/AG7x4aFbzWS7n9D503VQmPOVS+Jp5Yec3qis4Vz7j6aXgjA2L3zl9AGYSYF28k+sFG1fXZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740786077; c=relaxed/simple;
	bh=VZaWhNFcwt5XvrgsVIF7qDd4aPAU35RM2M0dEEPfiZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r3PLDAVFwsfOawwfHH1JM7+KNBW0FiGmIwuqZMuppwHXDNMtmmCsTNwd7ImIh5WvF/kOSms+K9S9qeAS1TOtVWcziQgZPTolW+TzmQwgaADOiWBOtDigs8qCRWbrr5fkD0bBXafk8JCUeU09J6bpS8SWXz8vM7qIyeUnczgVZQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4tsCLW6L; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe86c01f5cso5523936a91.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740786075; x=1741390875; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4W5heUzLectKYu5MZ6IBjmNxe9q2d1ZANr//2+ACfY=;
        b=4tsCLW6L+rQxEmWGesMOBwJQkoXMAXcCnUrEMiTap2u6eFpZm3udqQn90kslDnBT++
         s5pCHlTuXFgbsU0fwAFIhWJmNJEExKy1JksPvBb8vaXly8ou8m5j/zJzjXtQsfnZ1O9q
         Nc6/jLurk/iYoR/by3bb+jq0BgWYv35SC9ei3qD8K+V4rUMIP8NjWZ2pVqe/4lvOsLyK
         +FPLQcnbbXN04Notf5tih1xUV+Aken0/7fAyVDLrMx3+Er2cEP16kSdBImLA1kmIfO3H
         5R1XsVNykwaWj4iHqf2gxYIVjL5dw0GhbD3JhaweiSRcAtQ8p+bolNxPK6W4eWzxLcur
         eDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740786075; x=1741390875;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S4W5heUzLectKYu5MZ6IBjmNxe9q2d1ZANr//2+ACfY=;
        b=gV7nNPZZz7kbDS3NJx5gDUCKPKiacOyneSqQ/ju/amWXiOg32eoA/zBGpWxBA2D8Au
         cLZ4axwbJEhhwBrJGIxVnrfuOROC39x92Q0yFWvwAIXo8Ya5CS3zfnEVZs/U79elx/Si
         N/mGdfmlXPQgdKfO2MK1SnKX6UPz4V1olIK7lqxQTgw4TB86wXaXCmjdlUEDRfBSERoa
         WBKPp/WeIUj3u24HZVLKVhrsW8GFAA43C65o1SXncZQScSebWrnvLS+MsxQ6UkdPAgpx
         gVaOJOmmBEtwPe7uzuRpcmn05KcZ1plMBYGQO9VMbZ0gVxJr0uoVfMxIgXlm248C5wwM
         E/kA==
X-Gm-Message-State: AOJu0YxQ5QyVGoVqUqomNIeHKqFlg7TIWRnbc0P+9NOHuu9Oi8UR4Fr+
	42PrVZBLC3HmAZcSWpdgn7LltVOb1gx3tSOkyHzM81gj3OY00jQoHD5n8wL4Xh24N13Ul7MbJ/4
	31g==
X-Google-Smtp-Source: AGHT+IHMJGELR0g8s6kFtP0OlO+wS6g87QFvzzqDkm7fCbSZKLbp2IMfj5jalPyiZwe+abPOHauFjdE/Ke8=
X-Received: from pjbhl3.prod.google.com ([2002:a17:90b:1343:b0:2fa:2661:76ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4e:b0:2fe:b9a2:fd3b
 with SMTP id 98e67ed59e1d1-2febabf8336mr8612908a91.30.1740786075182; Fri, 28
 Feb 2025 15:41:15 -0800 (PST)
Date: Fri, 28 Feb 2025 15:40:34 -0800
In-Reply-To: <20250224171409.2348647-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224171409.2348647-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174076295226.3737514.12262094016523053976.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Reject KVM_RUN if userspace forces emulation
 during nested VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+ac0bc3a70282b4d586cc@syzkaller.appspotmail.com, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Feb 2025 09:14:09 -0800, Sean Christopherson wrote:
> Extend KVM's restrictions on userspace forcing "emulation required" at odd
> times to cover stuffing invalid guest state while a nested run is pending.
> Clobbering guest state while KVM is in the middle of emulating VM-Enter is
> nonsensical, as it puts the vCPU into an architecturally impossible state,
> and will trip KVM's sanity check that guards against KVM bugs, e.g. helps
> detect missed VMX consistency checks.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Reject KVM_RUN if userspace forces emulation during nested VM-Enter
      https://github.com/kvm-x86/linux/commit/64c947a1cf35

--
https://github.com/kvm-x86/linux/tree/next

