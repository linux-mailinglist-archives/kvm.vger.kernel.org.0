Return-Path: <kvm+bounces-60553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 584E9BF2755
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 18:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBC1318A6092
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 16:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F0C287505;
	Mon, 20 Oct 2025 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZZzZ1aWf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEFA9476
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978041; cv=none; b=EybRSsb1RhY4wXiv/E5RVUGxswVA4U0xWXYapMpzmpA8Qg3dK3SdZnx+WR5f+oaTuTT0S5q3reG70z47WErHzh4pDEVq3ObjHGVeqSie/yhCSNhpt7dN7XwLE6wtQ2jZCkOTnTVmKsZcBgSkSicpk4JdII7fiLXa1D6kyEbbn58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978041; c=relaxed/simple;
	bh=Y5CEGs0t9LeXRLRCfmnRV+V4yK09SUomkNMkTtKhZbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YAgiumOmeF59BGY9njpDwug6R9KwX0ijwxfA//dgUsiT8J0T4qPvmRG0Ri145h2XYNeb+ed68+dUGajj2MHMwfxmJca833enIOVDxIQL2/2g3eTEgcGmBXGJ+0su4B7ZzC4JNjNZt/Q+f/d1RkptOT2D0hUjOT17N2fCLspdyZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZZzZ1aWf; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b631ba3d31eso2859831a12.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978039; x=1761582839; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xahSst9CglR2qFJe71Is8QVBM1v0GjyVtyRULSD/218=;
        b=ZZzZ1aWf/BGewykJ8Q9qUGbrPQukcfrZt0B02Oi8ff+QqNUVMJQjYsyy2eLUcNCzQ8
         5HUHH6CiSmyRtZ4EDVYXBa8dFjApSUowuVUgYXjV5bacbe9dO9RyDPv+JF9nclfLqqpt
         IdfMppAP9uIeK6GMJU96xuSsTC2AeCDaNma4X96UKPETy6Eo64osK422sR8SRSNNpf4o
         Wyc6s1n8stoxlJWqlLQqkgniG8OkK33jVGq5LqE58beJO83LfvVx9gUmnwB/GKNMBo2t
         yOXseyiy1R7ee9Ng53rEj6jUciJoh6UWzoj6MbOaz7+/qxUoVKU52BrbMv6wW0qmSAzn
         LY+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978039; x=1761582839;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xahSst9CglR2qFJe71Is8QVBM1v0GjyVtyRULSD/218=;
        b=L6WH9QYsxrhpGPuSd1PGGVpuGp4dOxOL/+LLXUnLhBqjHSbJtnjvEL/dF2i3Sjpfmt
         DOr7uwNK0Qv6CFS087mLG1mhgbHUEcMpuZKy8M487XyZ++6614i2lG7YH4bN8H1fmof4
         yqRTd3AzUVOAc8e0rY5MyQuYd/RgDMiUWfUVl4sYCRAnuybPyUJfoku9ScpHnQ/SgC1K
         the08WD9ZSp8j8PUbTQTngwAtO1J1PFM72BEH1rCHHQpI55JkFdGOBpjN2qntvmp+RGX
         wnOXWLTjWGmyKBWpWLke9W/gcsqycjqOHC8P5gFnr2VnzDleyzMb1So8DPFJDU0fPP5e
         M55A==
X-Gm-Message-State: AOJu0YxEa4oT/dvgmdfLKu7XVZLTUPtopB46hhd6IjbCScCNtYI4KqJU
	jIpnpX6sE/ZKaNb++Cqlw33QgjTbZ9m4jV3QctUAFavTUOFXng6m/FrQ1R+CeBi27vjuwiownyk
	VPG6ypg==
X-Google-Smtp-Source: AGHT+IGz3l2nSx5AlR6WsV3KMbX/iOTStifDphqigGBgItnK5hyzgl82eH4fn8NCfPXntYDzW0XJZScJ2gU=
X-Received: from pjbgk9.prod.google.com ([2002:a17:90b:1189:b0:339:ee99:5e9b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db09:b0:290:a3ba:1a8a
 with SMTP id d9443c01a7336-290ccac6d3cmr177014055ad.53.1760978038920; Mon, 20
 Oct 2025 09:33:58 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:01 -0700
In-Reply-To: <20251014152802.13563-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014152802.13563-1-leo.bras@arm.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097609826.440019.16093756252971850484.b4-ty@google.com>
Subject: Re: [PATCH 1/1] doc/kvm/api: Fix VM exit code for full dirty ring
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Leonardo Bras <leo.bras@arm.com>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 14 Oct 2025 16:28:02 +0100, Leonardo Bras wrote:
> While reading the documentation, I saw a exit code I could not grep for, to
> figure out it has a slightly different name.
> 
> Fix that name in documentation so it points to the right exit code.

Applied to kvm-x86 generic, with a massaged shortlog.  Thanks!

[1/1] KVM: Fix VM exit code for full dirty ring in API documentation
      https://github.com/kvm-x86/linux/commit/04fd067b770d

--
https://github.com/kvm-x86/linux/tree/next

