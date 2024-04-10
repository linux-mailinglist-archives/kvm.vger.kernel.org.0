Return-Path: <kvm+bounces-14047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6159D89E6B3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 02:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C93DAB21B7F
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 00:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1A5633;
	Wed, 10 Apr 2024 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ub7DOFbU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18847F
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 00:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712708413; cv=none; b=sCDpXRir0cfCEjD70OP5XnqdJrQFwtdnff/pjqb5pj6coH+c0dWlKr90QaOHwaZyU52wVgKJigMYTgyQCq36QmpjHrnR9G5ipDjwhhiabm7wW9b7lLqGg0wARSHb2J0Z5E9Azpx2GeoGXxsZ1eQ3cpKVDa33eQCaf9swGlcfd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712708413; c=relaxed/simple;
	bh=rgXODy2ph3QTsJ+TzC+9u8V7jJj6efhvE+ySyj9lOBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=euwOa7mwb7HXdAW/lgohfGzF1yC1fVPITG9U2aeSMAoEZqt8cvyU8JxmzYhWY/F4dwHpRxCY2IuhUb2tFkOGLCgkGmoypPGARKPPXFC1AM6j4q4qdTgA4F9vY8esAJxF4Cb7cYD0bpq+53s1abhPoXqjhptMIgU1nnWT9Lx2h3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ub7DOFbU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf216080f5so9944455276.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 17:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712708411; x=1713313211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+nXhC2uEnvRoe18LERxjOAfUYR5Gw84SM8FT2kd76AY=;
        b=Ub7DOFbUwZjmQIpM4lG8dZu1mPymxxrILP99ZULFx104AdjOh/vw7i5SPcCvtiR4Xc
         YpIVSmK1kIUvlK5b1766y3uQ1tI9l7OrO4gNcXq1tqE5a/X6681aAZPPFg7xAA469DHy
         rHkwJNn7YQe1S7kKCH25+5/fpJk86FnxBxdZ7w4ss8P152lruZ5GACX3wyjGMhs15op/
         d6oSeHA0H+gKmGTONcs/ybHo5L+4rpkDPZa/NECccljibDWd51c9W1whHkG2PF0sa593
         Wz9aayCt7WNBY09xQShblhtz61FJkO/nEQqozpngaU63dpHKXMUNMNrbHnu6MHUFT+hi
         ZK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712708411; x=1713313211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+nXhC2uEnvRoe18LERxjOAfUYR5Gw84SM8FT2kd76AY=;
        b=Wn9UtzXzU6StaFjtsEoi7CPlTSmyyXyVvg61UoqPMT4KuljJOJXo17lW7uoyG5e3IX
         Tlepo8QIzWvp5jNWe6xfA61tbW7EpTU/79uxMlgVRZzS4tnhVm00Dyx6dhq0y4U3hGep
         C7sUPdyqogL+yVelj23et1F2aDug8sLFtSj50ExUXvLGAZsFU+hLoefGCNtd8xGYPASN
         3jhzFfpyoTWdnLfSAapTm8oDTL/O+BdMmADBkjJllizEV0OXHmyIUcJnAcxb8Bs+M3ll
         g9DydMYsiZMw80j1IfDwCTUqGGPAQqKXQtHtkzP3ZwO77Qw6ghTFaiq8xqWafR7YXE/5
         dI2A==
X-Forwarded-Encrypted: i=1; AJvYcCW1SRozfmKcSp4qJA5Mbs9LI4L+vBCtcu1glErdlPVBiMbC+bMwBw+/QzIhpvgzXFkhjIt+xa7Whe6FCFdqT7dn7xJW
X-Gm-Message-State: AOJu0YzsMoNJZvQqfz7MZnRjppvAWv42Z9C4r027yVBBWpRCcczOQKx2
	03l9pNHUaMalfHnq03WJOF+5F0u558PccBXf55zpJEHIPc8tXsBrVuWAxqBJ1iip1QZcPIvbbK7
	JrQ==
X-Google-Smtp-Source: AGHT+IHzXT4LbAbWa2hdJCJoY4LE5MMcuwltAJotTGJ2hTcaq/rivu7hvlDlWX0NK4hDLgVhn27o98YPP7A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c07:b0:dc2:550b:a4f4 with SMTP id
 fs7-20020a0569020c0700b00dc2550ba4f4mr403919ybb.1.1712708411001; Tue, 09 Apr
 2024 17:20:11 -0700 (PDT)
Date: Tue,  9 Apr 2024 17:19:42 -0700
In-Reply-To: <20240315230541.1635322-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240315230541.1635322-1-dmatlack@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171270408430.1586965.15361632493269909438.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Fix TDP MMU dirty logging bug L2
 running with EPT disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: Vipin Sharma <vipinsh@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 15 Mar 2024 16:05:37 -0700, David Matlack wrote:
> Fix a bug in the TDP MMU caught by syzkaller and CONFIG_KVM_PROVE_MMU
> that causes writes made by L2 to no be reflected in the dirty log when
> L1 has disabled EPT.
> 
> Patch 1 contains the fix. Patch 2 and 3 fix comments related to clearing
> dirty bits in the TDP MMU. Patch 4 adds selftests coverage of dirty
> logging of L2 when L1 has disabled EPT. i.e.  a regression test for this
> bug.
> 
> [...]

Applied to kvm-x86 fixes, with the various tweaks mentioned in reply, and the
s/READ_ONCE/WRITE_ONCE fixup.  A sanity check would be nice though, I botched
the first attempt at the fixup (the one time I _should_ have copy+pasted code...).

Thanks!

[1/4] KVM: x86/mmu: Check kvm_mmu_page_ad_need_write_protect() when clearing TDP MMU dirty bits
      https://github.com/kvm-x86/linux/commit/b44914b27e6b
[2/4] KVM: x86/mmu: Remove function comments above clear_dirty_{gfn_range,pt_masked}()
      https://github.com/kvm-x86/linux/commit/d0adc4ce20e8
[3/4] KVM: x86/mmu: Fix and clarify comments about clearing D-bit vs. write-protecting
      https://github.com/kvm-x86/linux/commit/5709b14d1cea
[4/4] KVM: selftests: Add coverage of EPT-disabled to vmx_dirty_log_test
      https://github.com/kvm-x86/linux/commit/1d24b536d85b

--
https://github.com/kvm-x86/linux/tree/next

