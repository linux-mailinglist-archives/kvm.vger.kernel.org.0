Return-Path: <kvm+bounces-62519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C60AC47A37
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C2ABC4EED15
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E06F3148D0;
	Mon, 10 Nov 2025 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zL6ZXU+1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EE52236E5
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789119; cv=none; b=GI1X0jNsW+BwaQ+pPY99+A7oCXYxik021Kske08Zwg4C8Fg9zlItJrm5DYrtMhghjBlsR/HD5QoI74hEb8kkVJoL+yEYZyeJkOqnZR9ilMEeoM+pW781Iikeh/zICjOvhARl3msMd2myQyhTFl+oSWK6GD+MueuC+RrUjIg70mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789119; c=relaxed/simple;
	bh=wWF6uOjqUv6W+Plh3B4k3LA4DNAjjEGlwhf3dBu6NtY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f93q5E3W1hC8R/3qYAT+9ZpDFTBhX9ix8oHkKW7HGHvD8SLIGAVcbkbobdUn3y5B5b+ILhgdy/8Lm0FtxTR/JtYl/pckUmfLqvMDXRhORl942xRULEiedsnwTvHPUXRh+w4JVHCAK6sFS53s55FGa8of069fqRkxw1tqoDVh9f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zL6ZXU+1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340c07119bfso7742054a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789117; x=1763393917; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yfPsA9R0m1PbgxrFpo4vz1rRRYntzKHoCzeS0KAV2Qg=;
        b=zL6ZXU+1kZvN2/nDjtTNLLS/91EPST7S/A/BgiUDrMIHamYQI5Pi3/yxTF9ze5j3XV
         Lk29HOsx3HFkpQSIAaKhV+85TL2Qy/ybstwq/o6BEylxuYKkj4yjTfZVbuX4qAJ+LFjl
         19fuZ54Fij6hnmDvSl2BxViA2p3s2BjTq3I5MdT4YH0FEg3mGBZ5h0TUHV0v6Lo3Iezr
         Z7shCvBLrR+CC2KUdK7IHW777D6AqmWtMTr2LEHhYVGyF6Lggn0wIj1yX09SqSS1AdX6
         /0eRZVtCxm0rCYXTe0VI7B6H9Rn4jcusJhZcJur01i9yPOT/2XNVFu2aUs+OsuNKMbWj
         H+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789117; x=1763393917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yfPsA9R0m1PbgxrFpo4vz1rRRYntzKHoCzeS0KAV2Qg=;
        b=YwV9lPKgAw8j7TzlxvSf/7RQYhovC3LDQybRthKtitTwRfWNknJqTD+leyDmhvV5HU
         G1pBIhxXSGj7UPD4TfZkn/QTjdUIzlsJckwva0EralUvkRo6FQkwHr7CWh7SPbxEEeB2
         mH4RHXLqJf6zMHQtvakJ/Zn9Wp047UZ9AJXS2XAtLoInck8LLkRDWK7jYkugeJpHp8XA
         8/Hh/YNIuNiI2obNSmuEfu6J5M5yvghCg9gnl6nJLXbUOPSK27oFgvutkE+t3GOhf51R
         z/xlVT97RXI6o6euvBepzhlvviYlPj9cKAbUst77YYeSPkZD3OVsfmXuWP6FDTJY0A4l
         yEew==
X-Forwarded-Encrypted: i=1; AJvYcCVFaXRuTSxEtYrKT2FZVioFMVqPoShWqO7kxLC4dg5sBBaA/OkaYPDyhJlWmHIa7R43B3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOrJKr8tB5Vaa+T1mtR64z6DlVWpzDMNU5VzwtOWMVt7rmCvSr
	j1w/51B/EtufnzrWuQvr6RmpW/A5/95gylWf9lzu6gsIAm6JBvddJ1xhHLy3bA1DIeloRq5htXj
	MD9gIkQ==
X-Google-Smtp-Source: AGHT+IGK1wZ3/zucTg6yFltfJmAFT0YJdOBTxemOkKdCIS/Efg08CIE0m38N8M4xq0bxiDvgMiQUD2dCHdc=
X-Received: from pjbgv9.prod.google.com ([2002:a17:90b:11c9:b0:340:c625:b238])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3811:b0:340:29ce:f7fa
 with SMTP id 98e67ed59e1d1-3436cb7ae1emr12134871a91.7.1762789117528; Mon, 10
 Nov 2025 07:38:37 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:17 -0800
In-Reply-To: <20251015033258.50974-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015033258.50974-1-mlevitsk@redhat.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278796977.917257.9553898354103958134.b4-ty@google.com>
Subject: Re: [PATCH v2 0/3] Fix a lost async pagefault notification when the
 guest is using SMM
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 14 Oct 2025 23:32:55 -0400, Maxim Levitsky wrote:
> Recently we debugged a customer case in which the guest VM was showing
> tasks permanently stuck in the kvm_async_pf_task_wait_schedule.
> 
> This was traced to the incorrect flushing of the async pagefault queue,
> which was done during the real mode entry by the kvm_post_set_cr0.
> 
> This code, the kvm_clear_async_pf_completion_queue does wait for all #APF
> tasks to complete but then it proceeds to wipe the 'done' queue without
> notifying the guest.
> 
> [...]

Applied 2 and 3 to kvm-x86 misc.  The async #PF delivery path is also used by
the host-only version of async #PF (where KVM puts the vCPU into HLT instead of
letting the kernel schedule() in I/O), and so it's entirely expected that KVM
will dequeue completed async #PFs when the PV version is disabled.

https://lore.kernel.org/all/aQ5BiLBWGKcMe-mM@google.com

[1/3] KVM: x86: Warn if KVM tries to deliver an #APF completion when APF is not enabled
      [DROP]
[2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
      https://github.com/kvm-x86/linux/commit/68c35f89d016
[3/3] KVM: x86: Fix the interaction between SMM and the asynchronous pagefault
      https://github.com/kvm-x86/linux/commit/ab4e41eb9fab

--
https://github.com/kvm-x86/linux/tree/next

