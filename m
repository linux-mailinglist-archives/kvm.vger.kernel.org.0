Return-Path: <kvm+bounces-31509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 117309C4392
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 18:28:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D672B2807D
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6971A76A5;
	Mon, 11 Nov 2024 17:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yfgPUtoU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A236C1A3A80
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731346053; cv=none; b=EgUOGHvlh/ilK6JHmJoaxdL30HXI001QK5JoKoko5F7RTiH7NS909rOiHbQ0L7dbFB+Ra/AvIwCNCq+nXWHItf/eP6tgEEcMmt91UC43r+3Wui/NhoabgknJrhF0egsx2PHGAX+1djF0EoNp3NznzTJ5adr3YPoEV76EoZK6EuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731346053; c=relaxed/simple;
	bh=WYFgUndS+KzKZFVk4xzsNFADcQ4DyMgY2lgh6bjlHJg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M0EVQ/gogGKKE5rdUNZcjrCBmGPNpt76TiGMjeCgDazrln1ZAOBKAV4RpUjcRPyKVTj//TZChK7lePnQuh1nRJ7FVTxSGoMt4dm9TnK6lOd1Q1HV8MAIvTTsj93dIFLGfsGrJcnJHS4rX7SE2f4+mkak3wZ2+D3ICpVRJ16vgec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yfgPUtoU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30c7a7ca60so5914243276.0
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 09:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731346051; x=1731950851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vmKizeQaKfhibWJZ/2erOOyrrRJ4rvJRJ+g7NHKLI9A=;
        b=yfgPUtoU6jud26MmV8uJ2jp72DVX3Ekf4xExpXF2NHA0RwozSP8KOZxESwPL4EsqEH
         64NX7tpaAwX3MtnnCtXrWo6tAIfITVjMZTMRPk++eu7Er2XNumHGAo39uZk9TMwccy2N
         0O2S/WzDGXw0HLuKYPJ0gm50fF7VmdFOwonLfwFzOaEwO9k9VBx6fTGruymeYMVD2gEg
         0ozY5n0NCihp4JJin8YWUkinbFLRY7zkANbnUuC21LRNgNIxh4Jc1BEozLvGQEItvn/k
         TK7+e0VNS9i+ahl8KV58sPxCyyEhOKGqMMs6BTge5Rs0NjkYorx4vk8XZxSWq4TnDibX
         aJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731346051; x=1731950851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vmKizeQaKfhibWJZ/2erOOyrrRJ4rvJRJ+g7NHKLI9A=;
        b=lBXMQrlOE9HNS5rKscZkx7PCiSv/pyU2iGkdKDViBXpJAuuLx9I1jmbSgCLCNhf2sR
         ls8pyndis2pISEHlZYC+HSC1vRBX7NMHpBi6Hwy/DPTUBDHYRaefXftUhqhDHQdHuHmC
         coCyUcKmDh/qN9gR1nkzDNeWGcrHksnSfHeaw3VQoYSrrEZeOAktswx7xayeFeeon8ZS
         5jrxvcOOJD6TEib5dvblE1KGnDOcTxvnWuJT+/XLwtxrwOuf+XFESJs7xZXHQWMgQW32
         0pmeFJQI+KRMnJ/azqW65Jxjf89Z9G61xJ/aP2NXFgwmHp7X9QIPUznUL52Squs8l8M+
         Wevg==
X-Forwarded-Encrypted: i=1; AJvYcCXhxLnrDKESRXbDuIZsVNJQ/If/80JqrdiFyy6oNPWYBCraZO9onDBNzRof0Azsekb0PJU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7/ZAyCcOnvWFJRfp0xONVnv1+nLR+CmWP9Z94z4jZO7sORg4H
	1m8M4RUjnVukGW9MTJjHVqGaB5F4OetLHgOgIKuAZBEX7nUGGYT/K//ubebtTI81O8nB1yawECj
	tXg==
X-Google-Smtp-Source: AGHT+IHAAU2e5YnmnPTi1KW3zzMNtGPxVYMB2bEkL/o+Wnl4gRUGSDioaDbR1aybQBx/36KLZnDxqf/1xek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:809:0:b0:e2e:3401:ea0f with SMTP id
 3f1490d57ef6-e337f8f63a3mr25772276.7.1731346050773; Mon, 11 Nov 2024 09:27:30
 -0800 (PST)
Date: Mon, 11 Nov 2024 09:27:29 -0800
In-Reply-To: <20241111115935.796797988@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111115935.796797988@infradead.org>
Message-ID: <ZzI-gcYieawJeCyV@google.com>
Subject: Re: [PATCH v2 00/12] x86/kvm/emulate: Avoid RET for FASTOPs
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pbonzini@redhat.com, jpoimboe@redhat.com, tglx@linutronix.de, 
	linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org, 
	jthoughton@google.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 11, 2024, Peter Zijlstra wrote:
> Hi!
> 
> At long last, a respin of these patches.
> 
> The FASTOPs are special because they rely on RET to preserve CFLAGS, which is a
> problem with all the mitigation stuff. Also see things like: ba5ca5e5e6a1
> ("x86/retpoline: Don't clobber RFLAGS during srso_safe_ret()").
> 
> Rework FASTOPs to no longer use RET and side-step the problem of trying to make
> the various return thunks preserve CFLAGS for just this one case.
> 
> There are two separate instances, test_cc() and fastop(). The first is
> basically a SETCC wrapper, which seems like a very complicated (and somewhat
> expensive) way to read FLAGS. Instead use the code we already have to emulate
> JCC to fully emulate the instruction.
> 
> That then leaves fastop(), which when marked noinline is guaranteed to exist
> only once. As such, CALL+RET isn't needed, because we'll always be RETurning to
> the same location, as such replace with JMP+JMP.
> 
> My plan is to take the objtool patches through tip/objtool/core, the nospec
> patches through tip/x86/core and either stick the fastop patches in that latter
> tree if the KVM folks agree, or they can merge the aforementioned two branches
> and then stick the patches on top, whatever works for people.

Unless Paolo objects, I think it makes sense to take the fastop patches through
tip/x86/core.

