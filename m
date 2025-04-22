Return-Path: <kvm+bounces-43828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6098BA96F16
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:40:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CAE617A267
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 14:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6382428CF44;
	Tue, 22 Apr 2025 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xvXnzesv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1728C5C5
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 14:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745332810; cv=none; b=MrvsF29AqGe5eL+1zW/qMcNgMmzrJU/fpraYn4TgYcbE9oa8usMhJK05s+B4p3yzZF+GyWmYPJ4ZBe07xLUhI1VoHU1mLV+i9oY1WVeBclr9nGEdiNYF+FBoOJb0e0bJxbLfpHYl5ZhAnMRW34IfNxZIiF9s3e4P9mlFMXbRb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745332810; c=relaxed/simple;
	bh=H6SmG8zfZRpF/NNqVIU+UMtU8feZniQBwXGO2NIJxnI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qAoQtKq+GcaiPuqEiNcH9ilTY79SETbltj0eLcF4gSMLoRtAc3vr8hQHnKFTVc3J/CZlyVG+YdYTdFMBFmUNZdVmFXgVgMCkUhSyXzwPCxCcvE7ewisngsvJpBNWATCVzaNNhxEYSjRJOLQ+BUkgbBLd+6I3P2DqEeKIoKlobl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xvXnzesv; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-73c205898aaso3828245b3a.2
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 07:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745332808; x=1745937608; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4kse3i/9a2wXrwb5fWBr/bq3/Gxj8YgN5EpIYvK3Crk=;
        b=xvXnzesvHWT/qlP1TLbvjkE4GSmpWLvuTlXNUaJC/YuXFkpIW8mmmsIrXTYdUJhYep
         Rvz1SJEJu+lJadVid+8bcN6eOiEooQhqRy3pWE3bdJsv/9ckXiToNza4vLVnVMlj8khC
         XSG0vBB97OASdnelxP4pwe/k3p33sXRzRsDuG/FglT9Hm7sWqdLtrJzVoUgWgOjjhx7N
         lUtu0HlhI1x6Nf3Ad1UPiEJ23HBI+mHlPpNl1MML6HXDH7gHShw+XOTN7pqrh/CthvQb
         48gbAZnB0KfIUPjP3LNoyHDxa+CwIwMdlUzhv1pqDktGSqHqbVMJfs5zNWLL5pxg7o5X
         l5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745332808; x=1745937608;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4kse3i/9a2wXrwb5fWBr/bq3/Gxj8YgN5EpIYvK3Crk=;
        b=FFczAD4AS3Di6x6VQC/843zkl2cKpN7+dr3FlkewY9ORgKQwLntQZ7wh1B8V0oSGG0
         HLfah2lv4NHSbYPxpaBHBpQUMUlH+Ntrl/ONKXxzQVuim0biIq9vnrc84XtJ/GCNQvlY
         CAihNkKq3KuV9GOADnz0wz6mv2XSEwmZcs0rJleQFwA2usP3+qbnpFKXI4Rpd4EKXO7W
         IL/xwFmglEJbR1OXARWrUEYucGo41vm/XXHmfSxY/4kujLHD8dWcp5HhzQaxQKn1YbZc
         i42bQivK1tDrabMpZa5OJEHdki1nZyR+EYiWwsmLef//XNYZI76yPlJEKrzKbDxr8Wqy
         rk/A==
X-Forwarded-Encrypted: i=1; AJvYcCXcjbtFNtJKghrKRPeFRp9ilmtUxMVvSyoc8O+8+40nATNnPhn5zjMaZLs1aTBV9g3q2Lo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNwzo8hm0BKArFkJRQgXY2Vt6EjhY08/w2nJTt/QiHLiixebDW
	XJa7WvUrvi/f/aYx4K9kTEMEPgHKyI70O+kWtt6zqbVPCOpe4flCin6GfT4c3I6iou+DZiIoq4h
	Oew==
X-Google-Smtp-Source: AGHT+IEqJub0IjABqAHfS37ByzLd7WwIavXyDFMuCxLJ5z8Czie0a5FeUJW/ZUjHDlbSCiXqb7H4nSjCbvU=
X-Received: from pfbgq27.prod.google.com ([2002:a05:6a00:3bdb:b0:737:6b9f:8ab4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a62:f24e:0:b0:73d:ff02:8d83
 with SMTP id d2e1a72fcca58-73dff028da0mr4353385b3a.3.1745332808429; Tue, 22
 Apr 2025 07:40:08 -0700 (PDT)
Date: Tue, 22 Apr 2025 07:40:06 -0700
In-Reply-To: <a82f4722-478f-4972-a072-80cd13666137@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <a82f4722-478f-4972-a072-80cd13666137@zytor.com>
Message-ID: <aAeqRk8fk8mvutw2@google.com>
Subject: Re: MSR access API uses in KVM x86
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2025, Xin Li wrote:
> It looks to me that MSR access API uses in KVM x86 are NOT consistent;
> sometimes {wr,rd}msrl() are used and sometimes native_{wr,rd}msrl() are
> used.
>=20
> Was there a reason that how a generic or native MSR API was chosen?

I doubt anyone knows for sure; that'd likely require a time travelling devi=
ce
and/or telepathic abilities :-)

> In my opinion KVM should use the native MSR APIs, which can streamline
> operations and potentially improve performance by avoiding the overhead
> associated with generic MSR API indirect calls when CONFIG_XEN_PV=3Dy.

As J=C3=BCrgen pointed out, they aren't indirect calls.  Though IIUC, there=
 is still
a direct CALL and thus a RET when PARAVIRT_XXL=3DY.

I agree that using PV APIs in KVM doesn't make much sense, as running KVM i=
n a
XEN PV guest doesn't seem like something we should optimize for, if it's ev=
en
supported.  So if we end up churning all of the rdmsr/wrmsr macros, I have =
no
objection to switching to native variants.

Though if we do that, it would be nice if there's a way to avoid the "nativ=
e_"
prefix everywhere, for the sake of readability.

