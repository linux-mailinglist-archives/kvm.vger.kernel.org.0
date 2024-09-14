Return-Path: <kvm+bounces-26880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01591978C56
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 03:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E53AB237CE
	for <lists+kvm@lfdr.de>; Sat, 14 Sep 2024 01:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 955198F54;
	Sat, 14 Sep 2024 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cfxope0/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828AA17D2
	for <kvm@vger.kernel.org>; Sat, 14 Sep 2024 01:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726276432; cv=none; b=GGr2ux8gGQ3hkPuLsdF0Zzx+1GnOA8UDqzMZGOMhLnpoLkLMSmSQixyEPWZOTPBgHKL+8WqkMAYM50gkVjsAVa9MXDNg4sT00ARF36FsKMUoVAgLKf+FWZYfdKqOjUGGzg3MsSPlL24bRoxhGCH3rDDapIyefTy7SCJkfIj8Lro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726276432; c=relaxed/simple;
	bh=gcP1d5/adPAHxF7Qok0xdcyskhGFswGFas4U0pjrwTg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZC5pSTwFtKrQEWy5tnmHwBHGXFDJsyZVhd1GcBED6Qz8eXSy3H25KL6HgdI/AV7Hn+8mWNmfBwBFyzOfMOYbFbwEateUpbL/e6o5GwccFwpRfGCY7wrGls0u4LzugYOrvoZFA0kHBqVpmBOFShcssipLJLdCQzMnjppMU+fDSh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cfxope0/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7db1762d70fso1289747a12.2
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 18:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726276431; x=1726881231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NpeOoAccYngMspBIARyW2CFrQWEtxcmGt/k/U8TuGY=;
        b=Cfxope0/T/b64oLwt82V2I1QBqAA1kScOJQ+/9OQUB02dWWwUTQSjOfH3mM1ZqNg0d
         hrLd2VzIHjM6NJ9p9Wh+cD3zPUzsEiBcHKGR68JmH8OjEY/boWBYIT+HBeTuE+1jzfCK
         ciC6CUevyZpliPXLyVD2KlOP2sbjmBVyxHuBk2oJ51EnrgGE0c+0YNJahaf3Nk80Fo+A
         FQjsJk1+usWE451IcAOrnPTQcDe308cSvkF1WY1pQ/t6HlgSCsh4/Gpe38dxBCkpOjw5
         EGsBgr3C/C2Ph8/CWSMryAbRVzAeqET2Ylo3EF39Rb3+K/k6t5uC5VAjvkLIRLCvSm6F
         VWAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726276431; x=1726881231;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5NpeOoAccYngMspBIARyW2CFrQWEtxcmGt/k/U8TuGY=;
        b=cLiWcai/Xe7kuAltvRWfeA+jzqlwKEQxV51xz4VpjNNyT+K/+ys0I1VyrMoLLYtd2N
         10W0iDHVG7m+CSo/z+NUusA2els05dvkgyITrav6IsTLiQFC+PUhsu/P3iYLX7FGOGSC
         DuwEzlxpODG5uVPMrtW+LIhya4lXN/ElDdOc9Cj3DFObxQpoUqLR9TccubrWCzHl0rhQ
         DyH9aycFigCKtoz5bATH4DgC0RO1zqBEHCvHyvJ8bjsaHh/hZ2NZPOL3yC2qqlb5tUfE
         ISJ2p9Mf+LxkVBRDas/9bymRmX6q2FT1Z/lsaX99Xaj0AndqIqfDzjHU7TA9ZauI1JAt
         0xnA==
X-Gm-Message-State: AOJu0YxD74TooBGrfMd3P15Dz3NcHRivxS9k+V2nFBCr+ev3FwXOChCp
	UdsxRjtaJZt4SZ8c9/0aHpe3y050XInQY3/TegACNzo0P3mAz5F6dh6w9N7DY/bHSnI6AFqZIXn
	KoQ==
X-Google-Smtp-Source: AGHT+IHULH2tF9oDvmh/sHPtQfHOTi7ZTvhX9tJdMzJSMmziRAN9nUnTJxM1X2qISi7jH/CWHB2YfMfz2+o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7004:0:b0:7c9:58ed:7139 with SMTP id
 41be03b00d2f7-7db2f6f4995mr8989a12.2.1726276430461; Fri, 13 Sep 2024 18:13:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Sep 2024 18:13:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
Message-ID: <20240914011348.2558415-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.12
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

There's a trivial (and amusing) conflict with KVM s390 in the selftests pull
request (we both added "config" to the .gitignore, within a few days of each
other, after the goof being around for a good year or more).

Note, the pull requests are relative to v6.11-rc4.  I got a late start, and for
some reason thought kvm/next would magically end up on rc4 or later.

Note #2, I had a brainfart and put the testcase for verifying KVM's fastpath
correctly exits to userspace when needed in selftests, whereas the actual KVM
fix is in misc.  So if you run KVM selftests in the middle of pulling everything,
expect the debug_regs test to fail.

