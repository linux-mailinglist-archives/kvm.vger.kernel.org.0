Return-Path: <kvm+bounces-12196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 519D6880871
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:15:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83F321C22267
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32A4A23;
	Wed, 20 Mar 2024 00:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bfSxA5jO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E91718E
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710893747; cv=none; b=HAQPa1YrrGIB+wW72zr7NEDh6JqMGviXvRWfue9QzdLRK/6w2lhCoGvO1AB/dW0mNaVqa0v3btln2l8IjrHOYqjNl0DtaZQm3GMUemJp+4K8Rp2FqVYNoEwlOmKFUCqgb4MT1YNmP/piVuIBR58Q7whKFy0+9uM0rABdHu3z8wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710893747; c=relaxed/simple;
	bh=9M12NXD3dtnNHAjqsgvhN+VjqoN4vkfcG3ZC8N7PFng=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Kxetj1beTCtKmpLprrbZ3tTgd3ut9VxTQ/QPGT/2uEUzaQyosY391GgKTvn8NYE5iBbE0DmOihkgJNzUkD5DkipKWygJKTcEG/RrG7vQfa9/XOVS7TX0nNxjR0VYsdVrsVLD5SZm911pcFpiRgJiF3ILnTG8KJWQG73smnkvuTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bfSxA5jO; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a03635590so94753007b3.0
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710893744; x=1711498544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yXW69hbgzeuHAbIm4Wagg4PsoRhn/DM4eoDcBzj7jGA=;
        b=bfSxA5jO6WLFqYM/QYdG6x+P7A6SrHNYOauytlV1Stj/eb/IOQ9Giu8lw0RVTooWKE
         d2z8sq0p0nx5EqxP+RMd4JRY85hlVXgz8YXbZg16cwQ3gKtf149TJkIGaqgeHkkfGS+N
         yPsrkFNaG5x3qx3jMf4CO2GfQPTjzVq9JMBPz4chUrOW/3DiiS3uLmPlO/QGmQW1Oafs
         lY/vfp12nrzQkoV6utK/7XdXjBwdJHKe6vP6ngdCbjylibiDvtPsvvxCqIIeQY4ItxRT
         z6OvDs8FlGxZesyuESIVb0lczaNXeXysrcHMw/3/RJpyqIwz1B/3TI/bI7ZpcuIQQw2b
         vfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710893744; x=1711498544;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXW69hbgzeuHAbIm4Wagg4PsoRhn/DM4eoDcBzj7jGA=;
        b=Tcf7HCZrGdQNT92BlfIJbo1RxeItGcooeLPnxScy8hsU6x2fj8ORi8dOHctb0Lu2K9
         uQF6t7JZWxLVoXCQuDjnzQIcPIHfn0TrRfJFsHXgDhbv/3ZlzQhSHaFDucA2sPOPvEim
         f6CftUbNDvEOqwXCTG8Gr/WXPBf1nnhPbkNrROqLe2iyBCj2tGY1QfKOV29nwr07yCxb
         H+v8UBga2E/YacGYWUPADJAKrPXbEr7NXgjFr6j8Eo4EuO3fVSksgB3bJaLnXR4ox611
         XW4R8CswFviLjZlSN0Scmt5OYupycc2uGOKdQEFRKk1lVbPeb5bHbEy6+ZSBiTTwFF2T
         z0sQ==
X-Gm-Message-State: AOJu0YxuBo6g4bndcMnINnhGb4DIf32foG3fZmRuUXaTQUPCxDtLPhHZ
	SderYNCdXQkn9M6/iGQsJZ0FDLVzccWY+7D3Syp6wtOKKVEXkFFDQ4GvL/s1CjHvjdeEn0o4GtC
	HAg==
X-Google-Smtp-Source: AGHT+IHHuREo88zfsLYjwlL9BxdoOQBVpLscWZ5Kr2wwv2FwKsKbCP/+PnxUJqClFUMwX0gBtriS9OH+Kuw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d7cf:0:b0:610:f2d3:d33 with SMTP id
 z198-20020a0dd7cf000000b00610f2d30d33mr275348ywd.6.1710893744675; Tue, 19 Mar
 2024 17:15:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:15:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320001542.3203871-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: Fix for a mostly benign gpc WARN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, syzbot+106a4f72b0474e1d1b33@syzkaller.appspotmail.com, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Fix a bug found by syzkaller, thanks to a new WARN sanity check, where KVM
marks a gfn_to_pfn_cache as active without actually setting gpc->gpa or any
other metadata.  On top, harden against _directly_ setting gpc->gpa to KVM's
magic INVALID_GPA, which would also fail the sanity check.

Sean Christopherson (3):
  KVM: Add helpers to consolidate gfn_to_pfn_cache's page split check
  KVM: Check validity of offset+length of gfn_to_pfn_cache prior to
    activation
  KVM: Explicitly disallow activatating a gfn_to_pfn_cache with
    INVALID_GPA

Sean Christopherson (3):
  KVM: Add helpers to consolidate gfn_to_pfn_cache's page split check
  KVM: Check validity of offset+length of gfn_to_pfn_cache prior to
    activation
  KVM: Explicitly disallow activatating a gfn_to_pfn_cache with
    INVALID_GPA

 virt/kvm/pfncache.c | 48 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)


base-commit: 964d0c614c7f71917305a5afdca9178fe8231434
-- 
2.44.0.291.gc1ea87d7ee-goog


