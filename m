Return-Path: <kvm+bounces-54451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 848E1B216D2
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 22:54:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44558680AB3
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 20:54:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725232E2DED;
	Mon, 11 Aug 2025 20:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f6hqc4XA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652E42D6608
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 20:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754945628; cv=none; b=N74DMfjRN7v1WtMi/Hbmuhy1s6yYMFdJFvRgtTmtFW54xkRbkYyNTI8CmIprKOEhRiUMsQuae7dlPQ7qbFY+C9VC0EwGCo7PJGrkz5qq9eAhHR3i+kXsbc2Um4mVY4yrYRiPaFk4AuFBP0KMawaTiFn8g+zyGkDokdtXbV+S8kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754945628; c=relaxed/simple;
	bh=JAqQRpQuRD1gv5XSPrDmnd2nskW03QCSTIn0+0VPuag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W/DZshurHQsqSrTf4EOQbFr4tjs4e5nHNK/mE+W9cq80u5pV9mInAQrBwLS1rHHJ8pHAQ/vpVVQSwMgSLSj/PG71KxUFdWO4HM3HjcluH3sbNTs1rJ5mfyVxdrXEPhy90Jbfd9IEz5UZJ/MOQ/wAeVZWxHnfFyX+sdhPJnz2yrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f6hqc4XA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-242fe34add1so741345ad.3
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 13:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754945627; x=1755550427; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OIjVfeNq+ApcEX/TD0b/1d8mPe0JYmLtItfn+lVbGBE=;
        b=f6hqc4XAtmSp4LaqoiFu1kQ0VTvQMysRApUX5E8TFOKP3Np5v/MvJU58j4Lm0Gw/yi
         6tkZM8viSAmLKg7oUBzi6lyZ0QjS2OgbjvYibxvuHlX/bt6IoNNQJXtHMpgHGOoxfcPP
         2JJVvUBdtTM36fYWRfFMsdiKuNhtq+ZKal34tgk7Tnqho6K4WNJ8HLWpR5NhKAd8I7jf
         GRSpsAqF4753xLoJrtEzMk1dDTuY9jzhSbWetXXGxMUozUKxNznrCqwO+USMAK2zRvLL
         NKZx0L5vGwAiaUAdNGtvLyiBE3Pxe03AOKG+IitN+E57sxSNZb+zW2vRPHh53YvesJtT
         6W/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754945627; x=1755550427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OIjVfeNq+ApcEX/TD0b/1d8mPe0JYmLtItfn+lVbGBE=;
        b=uUIHRmiWy/x1GKyOH3MuNWBQZ0fb9YlfE3uHUmiqRI/dcDhqV4NFC4grz9tJvgzDzl
         bGObN4CMtJa7GXbBt7blgRYp3w82yLhEi+EAcf93/gxQCWdNMiiagjqmGgW/XGDfsDLV
         +6Meq9jFjp6E6P7u3enG9sO9CdXvXKX5rNa5T/X/DcCrR50YCU4h09yHuWnHWGIAFkdw
         ew5+Xa1IMKIEUMZh4n6AU4Xvy6NUrd88kNXPB5QorhdYOp6ssJ/knWzw1qen/SDuRIZA
         d394EnntE1/Ut8VYjqbsixqShQSzLwoaT4cExh8xszO87PlmGbgsK6o+wj/yQ0ksA9K0
         66pg==
X-Forwarded-Encrypted: i=1; AJvYcCVCbOJyXcLRCrkXHxBoFJ94pIuSNhnGYUCjTLrd4C7d9wWuycdYcGV9MkyZu8+72n3tc/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJNMjOrn+HdatAz3pC1kp0b7qF5cIer0EWf9r27TAPBv/e1TAk
	3QKyl+nz+iNVqpkwQFTn2hIUeILQu+ZvXMFC66pEwKCHJlfEHOb6R2aoxWMi/zFwnMWloiPjmre
	yBv+DEg==
X-Google-Smtp-Source: AGHT+IFQy54dyug1fwyF7mFE+kG2LTj1gs6Ocg/a2BRYAoLkWItNyzLA1YfJte7cQL0UErIPYnECfSs/jDA=
X-Received: from pjje11.prod.google.com ([2002:a17:90a:630b:b0:31e:998f:7b79])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c7:b0:220:ea90:191e
 with SMTP id d9443c01a7336-242fc1fcf98mr12784565ad.4.1754945626697; Mon, 11
 Aug 2025 13:53:46 -0700 (PDT)
Date: Mon, 11 Aug 2025 13:53:45 -0700
In-Reply-To: <0976e0d50b1620c0118b8a5020b90f3959d47b4a.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com> <aJoqqTM9zdcSx1Fi@google.com>
 <0976e0d50b1620c0118b8a5020b90f3959d47b4a.camel@intel.com>
Message-ID: <aJpYWVvNXjsewl-b@google.com>
Subject: Re: [PATCH v8 00/30] TDX KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "sagis@google.com" <sagis@google.com>, Erdem Aktas <erdemaktas@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "shuah@kernel.org" <shuah@kernel.org>, 
	Ryan Afranji <afranji@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Reinette Chatre <reinette.chatre@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	Roger Wang <runanwang@google.com>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Rick P Edgecombe wrote:
> But Sean, if you want to save some time I think we can just accelerate this
> other reviewing. As far as new-fangled features, having this upstream is
> important even for that, because we are currently having to keep these tests
> plus follow on tests in sync across various development branches. So yea, it's
> time to get this over the line.

Yes please.  The unspoken threat in my response is that at some point I will just
start NAKing KVM TDX patches :-D

