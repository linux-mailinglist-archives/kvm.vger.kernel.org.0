Return-Path: <kvm+bounces-55909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD845B3888A
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 19:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E50F17B5FD9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 17:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FDC2D73BC;
	Wed, 27 Aug 2025 17:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pko1IfCp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DAC2D640D
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315581; cv=none; b=CKLe3VgUADXEQ6fpf3RqkowFm0A82jMz8CJ7rntmAe4ipAX3H4h9gSpfV/5Qp3M1rYUyr72kdbksDu4bxa2g83y/aBAnkziyp9p1KRdgOJz4pPLhbUYvXaOfp6o58P9bh5CAsvpnTLrRxoUU0Q2HbsxJ9fCzEl2qKUs6kRfD4QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315581; c=relaxed/simple;
	bh=m92QUz1VhMSyOszNetqONR33Mmv2yjPyx2FnMM/xhIo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YmS/ySafxC8AHJnmFs7MYNzA8QO0b/kouXdTohIkWG7UPDhWPYlvyY7e9S3c9RZzyVGHt94lFkz5o4UsItihkFRmz11hLIQw34YIx9TNXq6omOKcCiZUPxh0P74omCQKfu5BHSHc+RNixPfstoonMjRF9I1BxbuCV76d8lTTGME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pko1IfCp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b4c1d26b721so92594a12.2
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 10:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756315579; x=1756920379; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4zC71Fr5dEaFm5d2WzjHFy75uKfi1gcdKd+IVowOXDs=;
        b=pko1IfCp8fM/XBv+s9zpX+Bixqwd88gNCmJuz/enUhw7d2YEIOtP2cAh8rg8Lfszzm
         UCNiZ1PNIisgx/76xnbWiVbEuxLAm9ZRwKFZUrfDQD/Gr67KDCSrztZHEgfBGDy2dl/F
         Fyb9JlfqSoYiBnqpGudB7FCEWWu1zwkfBxM1xIHhHS2CrQml1nnqFt/BgjWr+Rxm5t/z
         EPWUTTj07ftAb9XRKz0lEAMldOCAOwKrPvY0/ed+Nt4p+tuFLkdvfacpdMD+QZGP7qC8
         c+Uq+L1Q7CNbCas15tCIB26FROf1MrX2vb5lCU5Qm0/gVRtTDt2EpvyUmo0hsh/FoEqy
         Dy8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756315579; x=1756920379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zC71Fr5dEaFm5d2WzjHFy75uKfi1gcdKd+IVowOXDs=;
        b=tJxzamyveBIOtPPaHMXizS5DsvGKQmTsV2vBM3Z7kWGDCRjrTBKfZul5wtp1cMOtgh
         mpZBse8aZfbX52NXcy4qsL+hnpSE7tszfE+5raRJGcK9r0q9KZinaXP393DF4U0n47nT
         8OSODT158jMEgnQcrq2f2Jh7hAna61NI779hGPdt7IoTYfRWUa53QGDifOF0Q9XKz57k
         pmYE+oianLhS0qUdWDDkZvCsEP1KvRdpKccm+eTtLeoni2sn0dnxpe7TTle4F+3gSzQI
         tqe9tb4SBfjsV18c2uQ7qCW3VZKm7EXcS/NC5G8s0M/DHK0PbeaX0XjyHLhGfqWOzA9i
         qvBA==
X-Forwarded-Encrypted: i=1; AJvYcCWe2QbK2vIWaDdRPdELuCcMfSDreHSya+7U8yTsqWlJ3abyJ/JTe59LJamqF/jx4Mgl09s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn4gBLggz+tcVNRiXPW2bjkImykS95eTnVJNTj9m2CwT3IXuse
	lEmxw0QF+uJzNrlN5Ypxifmd2Q9pnN1CGxNucxmZrQpjuQN8Nnsel/ByC+MCEhZfxG5ezVIl5TP
	tOrIbQA==
X-Google-Smtp-Source: AGHT+IESDg1LpI1nrcySAHRIbTDAuZOVpz+EhAMxyOIaskvr7KoA6Zvhs2DchP1jwY2+XdFu+UizmDI+Zbc=
X-Received: from pfbkt3.prod.google.com ([2002:a05:6a00:4ba3:b0:771:f274:bc54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7495:b0:240:1fb6:d326
 with SMTP id adf61e73a8af0-24340c489demr29235354637.21.1756315579455; Wed, 27
 Aug 2025 10:26:19 -0700 (PDT)
Date: Wed, 27 Aug 2025 10:26:18 -0700
In-Reply-To: <aK7EQH44UOr46Hdx@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250827000522.4022426-1-seanjc@google.com> <20250827000522.4022426-7-seanjc@google.com>
 <aK7EQH44UOr46Hdx@yzhao56-desk.sh.intel.com>
Message-ID: <aK8_un-TyaeXAkgG@google.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Yan Zhao wrote:
> On Tue, Aug 26, 2025 at 05:05:16PM -0700, Sean Christopherson wrote:
> > Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> > when a VM has been killed due to a KVM bug, not -EINVAL.
> Looks good to me, though currently the "-EIO" will not be returned to userspace
> either. In the fault path, RET_PF_RETRY is returned instead, while in the zap
> paths, void is returned.

Yeah, I suspected as much.  I'll call that out in the changeloge, i.e. that this
is really just for internal consistency.

