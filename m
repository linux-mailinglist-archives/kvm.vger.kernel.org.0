Return-Path: <kvm+bounces-44370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0130FA9D593
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49EC34C0657
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A88629117B;
	Fri, 25 Apr 2025 22:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bmxKFfCR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42240293B4A
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745620208; cv=none; b=M6L/+z7iJ5aMN+atH/25t3/pIz5iL7RLr9zcppGC/vfreAgJgYGnjA/EK9n+K6gH3ZZU1WJCK6gTgPybMz+VWGkU5g3HIMmBNiXkkBqWkZr8Pvgxfqhx4HC8pGuwfhhn6X/O3bAE6aHiFF1Q8IScDtrLhA/ZPF2kRTBCj08eb4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745620208; c=relaxed/simple;
	bh=No2WdcR85nQLhD9Rcq+fHij7hSPtf+sRVRTw6HaupAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eUUVOdj/9PJakSyhKo1SgAnuNaDbcr47FlEW6f4/pWtDPgVgf7GY0z+/kV0l0CYTL6jmOy+7xdmKfFzdkILGActM4hTla9ql8OmcLvCVE0EyAV3LEB6MjXh2N1+JBMGorNdQ0bVTeWb39kKIJryq26Q0tj4SaitZR6nt3pGiOpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bmxKFfCR; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7375e2642b4so1920633b3a.2
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745620206; x=1746225006; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2vrxKS37XFkzYSXdYDYazU7IYtsM4nDy6zkgVBtQZ0=;
        b=bmxKFfCRt/CTKpXMYCTfKyUR7H9F6DC9IWmJDeCrfWHVaVtsjQd5R8o7dMVpOgpWyA
         cfilJVUEssrtOPNzIrXUzfB//ObYHqyXBvvo6/hfKZiMYxWvNp/zXpgz6sH4oU3GZPvg
         cu1wVp+jQjNraQEWwhgD9V7ebhuuMWrmvpZdrkfRkPd+k/i+eHm5i1WYxbNe14Lg7BnT
         QVy8vTVTfGNXXAwDlvxKHwcz4mkwzl6OWt0OQ9w5G+2+TRrZTwHjRhNk5tMSWCxvS2Iy
         KgxF5DrqctP9sZEyleKaUehZfdM8IBFE/2pSwSKnthijNdtJZrZA811iAtodrcFrXdC6
         783A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745620206; x=1746225006;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2vrxKS37XFkzYSXdYDYazU7IYtsM4nDy6zkgVBtQZ0=;
        b=U4qTm/WecliNQLZLzTj9SlWvLMZyDp51qc45iF4EbxwcpX27uOoAuk3VhDWSk66C7g
         KnhnTGObaLWXJtsCDELCDA9mxgn+pZcawIClKKGsDYcHmhInpv1D1mwpiTy3BAgwNdGA
         y22dK67AtPJ6bboSJZN3ENNI3gc5PgTHOZ2BUnxHNKRdUEZM1b2OPDFhkfRgbcaF5nas
         pjftKhvRw2MkZmqqNbU6CvzV3wz0adlvzEtBN/tv4P0RxAJSY/FYV/Vv330qID/ftmZT
         G4cyE5GohWrvIoq7z7v87gy3UuLDfoiu4rv+U6vaWtaMb3kfgR7B/f7AJapnVuTSpn8t
         8YCw==
X-Gm-Message-State: AOJu0Yzl7bk49sX8hks2p6Gw93anuXCAnliJ2PQGa7t8CzOrVfxMp5jD
	gprgq3xayeAtFIDaQaUkcUwMuvCMBYlAoNPU/EoDWkJhKITj+BX3n+b84zIcTCPOoRldoakwi25
	zMw==
X-Google-Smtp-Source: AGHT+IFyEmW/h75Y0a4u5zU8k/xtyBAAGO36YOhCBdvDLlZHji33XZ6TelcG/U3Ix6o3kynmbJjWiJBqCfA=
X-Received: from pgah14.prod.google.com ([2002:a05:6a02:4e8e:b0:b14:df7a:ff1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9203:b0:1f5:6a1a:329b
 with SMTP id adf61e73a8af0-2045b99e11dmr6794527637.32.1745620206560; Fri, 25
 Apr 2025 15:30:06 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:09:10 -0700
In-Reply-To: <20250304013335.4155703-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304013335.4155703-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559673791.891425.18442555338696362642.b4-ty@google.com>
Subject: Re: [PATCH v5 0/3] KVM: x86: Optimize "stale" EOI bitmap exiting
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, xuyun <xuyun_xy.xy@linux.alibaba.com>, 
	weizijie <zijie.wei@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 03 Mar 2025 17:33:32 -0800, Sean Christopherson wrote:
> Slightly modified version of the patch (now mini-series) to optimize EOI
> bitmap exiting for "stale" routes, i.e. for the case where a vCPU has an
> in-flight IRQ when the routing changes, and needs one final EOI exit to
> deassert the IRQ.
> 
> Kai, I dropped your Reviewed-by as the change was non-trivial.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/3] KVM: x86: Isolate edge vs. level check in userspace I/O APIC route scanning
      commit: b1f7723a5a5b018f4bc3fb8e234510be7c44ad00
[2/3] KVM: x86: Add a helper to deduplicate I/O APIC EOI interception logic
      commit: c2207bbc0c0f4b6ae8dbb73ec26e17aa0c45a3ca
[3/3] KVM: x86: Rescan I/O APIC routes after EOI interception for old routing
      commit: 87e4951e250bbccac47a8822f6f023a1de8b96ec

--
https://github.com/kvm-x86/linux/tree/next

