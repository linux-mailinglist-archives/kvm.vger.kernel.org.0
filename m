Return-Path: <kvm+bounces-44369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4343BA9D58F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99EE49E136D
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A59F2918E4;
	Fri, 25 Apr 2025 22:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qL3M7l0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9A229115D
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745620200; cv=none; b=YytyTwk46jayJDxUGFPX1OD3PZ6IeBVtSzKlNpX0TvdvZzr2sIB7lRyEqM7PsOGY1MIsYVW4+J0eLu7PoeYyVAxkRA6WWKNRTR6cLBD8bQHQMRc/jyUKPMJ0Db2yvHsTwzcIVxpGPDkTegs0JU8CBELy5b0+oFR2dUbYsfccJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745620200; c=relaxed/simple;
	bh=K79ARpalsPHqhRZuuyCYTexejOtmmc729FwDTg55yl0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JimaL/O5PaRGOwUjYOMfL1LPOV6PdTNUqn7LJgWaqC1SSuWysje2pE7azrRVsd8z3EcZdC3ZRnmOWpIXJdrLnC3uDYyjQWfohFDShmeA1dYgEQ7BUIAXqXyo8rNJVETFo1k5idxB/kPF1DJ3pXQe7FxdNf4Bepbtz8uwid/p6l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qL3M7l0w; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736b22717f1so2374413b3a.1
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745620198; x=1746224998; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rq95FJhRe6YlRIqzlmqKzY8TpJsOGhmr8x+Q8dJX0yo=;
        b=qL3M7l0w50iM5jGOPwUMsedH6uAqx9UVeHOmwwAjLrVvbp8fsx+H+U08+mvDafIIxn
         p8M2Td7AAQPJs2+KWYONQeG9yJvgLyFopGspQJGj1I27WvZLJfQ26LCyxgmRbVuJMaP3
         RoU7pn0RyB8olpvXdnG03XqELPI5QYKtBXnC+Mh/yqjRlv31UeyKbbgChyV9Z8pR8qBf
         XlpJo9fFamfyGvF5s594cMKyCvkMdQwr1Sm85e7x8HTOEdfTt+OfLEqAeTs/YDzOEjW4
         /SIT8hsHtDHV2zwN7elDqMswpeZUofmlFhuboZwLvb6H/5FBZxKLqXF+xRNpNp1l4PZn
         e2ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745620198; x=1746224998;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rq95FJhRe6YlRIqzlmqKzY8TpJsOGhmr8x+Q8dJX0yo=;
        b=EgBaYPLUVNyaF9+WFV+CUOmGyRYwewEH7XBw+GAosbMSLEq7VObChMBBqS6G7ehWVz
         lOmkvkSuajfMwnUP5jkTixsaBafbBHBNHg4cZWxsu8nUumqMTJe1f2+dh03XtsUZVskZ
         vlAQMTN7ItKpYrIP+nLLmUjsXO7xjj1RSF6bnrJPkn0eHx4a4kLswVZ+GmWK5OJrCIed
         Acvyfgl8HFWjHGwroAKX4QeLQ8WadUeXtMUPgeRSg/BHsaoL0pzUzfJgiXQlp7bBsjnT
         AwMUIawkh97VyImBVpafBqotwEr5UAhNZyUBSQs32V7fKJ4Wx4IjRdEcWjlrNCaE1UT8
         JITg==
X-Gm-Message-State: AOJu0YyK9KYtfcVZG0E/cRzQawbWpnB7Guk5TOR3IB78+5ogmmVOBLTo
	MdLiEpwVcYKS7afRExbLfeF8TbU/AFOjuiKa5DgVKG3yMSfaxkK2LOPRJ3sKJd9MNsp+OCXksDz
	OJA==
X-Google-Smtp-Source: AGHT+IHgOxp9FtKgyinxgL94UTJQoiRIn8aPLx4A8eRkBdbGwDHAR8qov/9/vV1/fTmak70TzkvGbzDQecs=
X-Received: from pfnv19.prod.google.com ([2002:aa7:8513:0:b0:73c:26eb:39b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c68e:b0:1f3:31fe:c1da
 with SMTP id adf61e73a8af0-2045b4583camr5420265637.11.1745620198189; Fri, 25
 Apr 2025 15:29:58 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:09:08 -0700
In-Reply-To: <20250401161804.842968-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401161804.842968-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559668507.890985.4658135689153245169.b4-ty@google.com>
Subject: Re: [PATCH v3 0/3] KVM: x86: Add a module param for device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Tue, 01 Apr 2025 09:18:01 -0700, Sean Christopherson wrote:
> Add a module param, enable_device_posted_irqs, to control and enumerate
> KVM support for device posted IRQs.
> 
> v3:
>  - Put the module param in vendor code to avoid issue with reloading vendor
>    modules, and to match enable_apicv (and enable_ipiv in the future).
>  - Fix a shortlog typo. [Jim]
> 
> [...]

Applied 1 and 3 to kvm-x86 misc (2 was grabbed by Paolo).

[1/3] KVM: VMX: Don't send UNBLOCK when starting device assignment without APICv
      commit: c364baad3e4f114284581c35d4b9006d59d2629a
[2/3] KVM: SVM: Don't update IRTEs if APICv/AVIC is disabled
      (no commit info)
[3/3] KVM: x86: Add module param to control and enumerate device posted IRQs
      commit: 459074cff66f77af3f327e2c1f9256cdb146d798

--
https://github.com/kvm-x86/linux/tree/next

