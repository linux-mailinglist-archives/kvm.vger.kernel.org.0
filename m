Return-Path: <kvm+bounces-53457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA944B12073
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 16:59:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B50E3AE0353
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 14:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78240235368;
	Fri, 25 Jul 2025 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k1sWRaXK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72912238C12
	for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 14:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753455564; cv=none; b=HKW/YY+udnE+Ks88oqckrVePvEiZdbPrzAUH8LHHvcEwF21ayNfqbX5hlvvLyuYWEKg4w8LNTK/SE49AjtSuAqEg4V+aD+fBPebwMb2oB7l+sl+OgaM7slhTBc0ErnYsy3j7W9i1ODi109Vz5xSEfkBXkFpbeevN6/X6FepC+bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753455564; c=relaxed/simple;
	bh=ixKJZ131X7DLb/fIFlcMTloGWlC/AIvG/UdPHPhgJag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X7T7HBcErj/Gc4E62T2F5gfI4WLfaj2KuUCMrI+E+HiUtMzFTV5cPfdIENH5DHEIhVbrHb9d2t9Nk6jsIc6kRbJa6cPrU8qpKupydJzz7oLhRQYFGG/znDoBJbEiONFkidnToczyDJBI9dbrGrrNbvrGJonamxUYaoESlGBMnKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k1sWRaXK; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-235e1d66fa6so22612625ad.0
        for <kvm@vger.kernel.org>; Fri, 25 Jul 2025 07:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753455563; x=1754060363; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jRIpv6z9xuIyFwnKQ1z6FnAeGn2PYDaQhA6EKMmoaPM=;
        b=k1sWRaXKlLbJSGyzFQMVFplRFHsMiObXiThSyyftlC/sV9hPx0cH9WmFH1Li92wQG6
         vD+Ax8maD8t29rDD7K5zX54i3wZ1YjtyFuM/WvJrtBR+74dO8siujS+EOZaffrUjkMR6
         J0PueLyuTqgN3udXp6m2QJ4EcPoc3cN6SjNrpBcBKk0XnFLM7XQdZ0CE1XCV7RWYk0qI
         qtpaL5eL0A0VqCUzJ7/2hveI+CnalarBhPp2N0KbuH5O0k0uDOa2J7gYbmwPZg1o9uw0
         TGSJu7z4mxzpKoZxj8HECeQR6jKJODk4bfm1ml6SgZy6C1LvwkeNUMGdNqmderhYN1id
         RrjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753455563; x=1754060363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRIpv6z9xuIyFwnKQ1z6FnAeGn2PYDaQhA6EKMmoaPM=;
        b=nXuuMvKGKSW7gCq0744Y9YG4b+pT/C1tQ/bAuL4SufHRfCymK0GkKPBuzkK9u+tn+k
         I6MUC12PHbwFd4iazlj8blxFxtOGZ89pPSQwzrk6R4SKbkLXrv9PoxhIfDKa7HzytlqC
         TloMZYjVyMTFX9UI0xXvMLPbe96Rzi3TRNBcciKf5rqm+ewiQPZ/T+L79JoO7tkw2hvx
         i8wTViVCTU534mCP3Bbd7a6bRFXCk4ymO4Gm8dg8g+ridifTHOco27xdOfo4AX9LbZ9Y
         7jrnb7e5KsZsUZxNQ5EE/sAEoiH9Muyed/JQiQXMqJGFsShFrpR6rNBNfLrtUa+A+cJQ
         09eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOz41YK6peVwkXJ+Zc+IlY6ryeGEJNnUMhicoo/202ic7dkSkOuxI+8iBw4Thz5l6qwlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5sfSrDN9wusZi4SnsYU+bt4IQ5JVGwW2iX6lowBCPel7amhf/
	HaAhvoRjNSg4X1iQQIQ3MARlTThpwmR+bhxlqMbIPRd1brWCx6fke/uybBn2H/EXNm1OrwiAPPJ
	8hZjcOQ==
X-Google-Smtp-Source: AGHT+IGcNpmnHIDt5vuDnKz4Z5PQxOcekjZoRgAfUDL4gv7HZdu2LOA9zo/e7zk1ZSljYpL2Zb35pa8dzKg=
X-Received: from plbmf3.prod.google.com ([2002:a17:902:fc83:b0:235:160a:76e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c1:b0:235:e8da:8d6
 with SMTP id d9443c01a7336-23fb3050a7cmr38030205ad.2.1753455562745; Fri, 25
 Jul 2025 07:59:22 -0700 (PDT)
Date: Fri, 25 Jul 2025 07:59:21 -0700
In-Reply-To: <20250724235144.2428795-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com> <20250724235144.2428795-3-rananta@google.com>
Message-ID: <aIObyUg77Um6VB45@google.com>
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table periodically
From: Sean Christopherson <seanjc@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Heh, without full conext, the shortlog reads like "destroy stage-2 page tables
from time to time".  Something like this would be more appropriate:

  KVM: arm64: Reschedule as needed when destroying stage-2 page-tables

