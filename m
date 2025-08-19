Return-Path: <kvm+bounces-55054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA24EB2CFA9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 667EE626CFA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3642749D1;
	Tue, 19 Aug 2025 23:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Dy0rrFeA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E02259CA7
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645229; cv=none; b=tVYd8Hu80uLAkkCms1IWwVqYzSbcVusasb4i7Ix0B56xHph5HvSneikJElc9DdOjvjoGnkMDKC0Dp/LaiPBN1YJdU3oF+GaZiUdS+VgpxD4EDFT78+gQZeQNZ8j/9DwssJ95cz+e13N+/GB8vrMeOqWBdbc5GjAwUxBzGbFS0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645229; c=relaxed/simple;
	bh=cGNOTZMVGC8+irNnOZMJx/9tij9MyZWxTQqOv08umiw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TsdlJxLpFJMGe9ruG2vlHdqRnm8bnpOTC1WYVbboODH/zJoTHmyC86v5CauJkKtV6be7tFwNRusATtnmjhbplrJvpgZ2egCWmaCf4yVg5o9wJP/RdVV6QzuP5JxXg23/3IZWPdjbmBKzQ7h/SYkkzpzat6Wc1+LZorhJTIB0eL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Dy0rrFeA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b47174b3427so4897892a12.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645226; x=1756250026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=msUMnF7kfiP2kpaQ8gwocYWiZP7HxJwC7ohBJtbK3C4=;
        b=Dy0rrFeA9Gs/PAvq22/75hBjcAhs7qZePnONXc74q/nYuL8KMvEz/ovuw1N3mblD++
         g4WMIr3DKntRWinF6Bw+IDwqDGjkGGwexbOHrbCwN/kxcR5WbqVOQJzHAn+wmzmiQ+Wp
         63zBkDiEXX2H8KkfNFAf8fqOKYRayHRecx19HHdlq4/7KQQPRPuktFAxIWDiJbokgiZ9
         hSvOwsP1K8Le0Pnjsn1/2qOs1OJgdHMwLUZ5h3IbBJqEzXhy/+KnUTVQugjtpbAkBWuA
         i7bvPemZaxJtWQVlGdr9c4LCrcjx+puTbypT/7Nu2WCCexqxcTU40Y9sgifK1AouPnN4
         6F3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645226; x=1756250026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=msUMnF7kfiP2kpaQ8gwocYWiZP7HxJwC7ohBJtbK3C4=;
        b=hpq7AFG1fsD4JVa4R3m9pMGdIlYXWsjQmc4PLnq5LbFWkhXrCbb2mYLEgHf6TZEz3r
         mH5cxH8Q/vdDnYrL7nNCzF6xVkqDUG+CQnShDEpErPGNHE4yRnllOkYV8wNqTN8PQCzB
         b20sEW1oHNbjH4AqijmqNB3N0PG1PniT92RM7UMMPgMJ/Cbhb/u26Edvl3HKeo123b5w
         jen1rJdTx7C+4MiWYtyYdmYGdNT5dhkf99agVruwnmuASDjl+O2mWMuZAAtvmwUVGwDI
         0y8bPEUjAeGSw43ci9Bf/riGzzQbyuQHwLB060+wKzRM6CjucQag7hIRccuxypVNWAiQ
         ekWg==
X-Forwarded-Encrypted: i=1; AJvYcCUYCaUWtyAkFee6d4TweGyzMkdFaI3Cgn2JYhCqhpNEBuUTbvDYkDc9aaSl++sfRJwbHys=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnbpwjW0ewE+FGBeAOVRcfqARjzd7PPjNxf4BecacqP/Cb9w2w
	gEWyfhq6bqOFg1iL1LID7fGBtByeQ07IzptKNKmNTqUQrXsDFRzxLajQ2H9VE+SVtPYxj1oh6Q0
	HH/bEmw==
X-Google-Smtp-Source: AGHT+IEzrQ3E2CTunJTK0cD2CEbgpKYTdCc3ho6c674KY67nTnizKNX9Zz4wx9giYRjnRZd0mIVmjvJzo6A=
X-Received: from pjbqx8.prod.google.com ([2002:a17:90b:3e48:b0:31c:32f8:3f88])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5868:b0:311:c5d9:2c70
 with SMTP id 98e67ed59e1d1-324e12e200fmr1160909a91.15.1755645226282; Tue, 19
 Aug 2025 16:13:46 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:55 -0700
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564447877.3064634.10238926163407823114.b4-ty@google.com>
Subject: Re: [PATCH v12 00/24] Enable CET Virtualization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Cc: mlevitsk@redhat.com, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	xin@zytor.com, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 11 Aug 2025 19:55:08 -0700, Chao Gao wrote:
> The FPU support for CET virtualization has already been merged into 6.17-rc1.
> Building on that, this series introduces Intel CET virtualization support for
> KVM.
> 
> Changes in v12:
> 1. collect Tested-by tags from John and Mathias.
> 2. use less verbose names for KVM rdmsr/wrmsr emulation APIs in patch 1/2
>    (Sean/Xin)
> 3. refer to s_cet, ssp, and ssp_table in a consistent order in patch 22
>    (Xin)
> 
> [...]

Applied patches 1-5 to kvm-x86 misc.  I still plan/hope to land CET support
this cycle, but I wanted to land the MSR refactorings in particular in case
other in-flight code is adding users.

[01/24] KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
        https://github.com/kvm-x86/linux/commit/d2dcf25a4cf2
[02/24] KVM: x86: Use double-underscore read/write MSR helpers as appropriate
        https://github.com/kvm-x86/linux/commit/db07f3d0eb19
[03/24] KVM: x86: Add kvm_msr_{read,write}() helpers
        https://github.com/kvm-x86/linux/commit/c2aa58b226ab
[04/24] KVM: x86: Manually clear MPX state only on INIT
        https://github.com/kvm-x86/linux/commit/41f6710f99f4
[05/24] KVM: x86: Zero XSTATE components on INIT by iterating over supported features
        https://github.com/kvm-x86/linux/commit/c26675447faf

--
https://github.com/kvm-x86/linux/tree/next

