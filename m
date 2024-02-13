Return-Path: <kvm+bounces-8588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5608527BE
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 04:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFBA3B248C7
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E95A94F;
	Tue, 13 Feb 2024 03:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hPAsLX4J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340818F5C
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707794826; cv=none; b=uPmdRbrXAwQDniTouEItfLvn5mNNTSD+tqb34h76asJm4QBBqlnpGHp7XJ/8gUEGWC3esp8WCW0blGuFAg1ISORSVj0OnbZM9K/5fcdCLZGlVv+KQJ81rarf+vmFcyXmNByPyFDMVh3d/ivjnS6+uNKhu+RgwJl43fafgppnK1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707794826; c=relaxed/simple;
	bh=k2gfEby2avrtvHzBUfVvHLiP3n7nkuPha9dr1uxkNDY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N4y2mi0J4zakt1NP6iq4KZMKO+mBu9mO4dH3PRjxr9acf4AFC31qMa58iu8F9w3Tusdgr9lJIRAFtwIND8VJSCjYtBAvcXcRNCrGOSZI1+R/Uv9gveB4tTnny7yYNrvKdHXyuEnMNbP8mcVOrQgaZPboWS+8B9mhnn5QMfQ//cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hPAsLX4J; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c670f70a37so4450629a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 19:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707794824; x=1708399624; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ol3QEcIEiOh1BLpsgDjP1PLEFR06C0O0EZBWIwePAQ=;
        b=hPAsLX4JAFtWSeIXBiYDp/mqdk/QYjb/PkY6qxc26+n1eDWL5fPuc0z6MlUfOS31wF
         nU6uW9aeSFqMJ8pV9a7JRn1oG2FsouvxhFH8IOh511oCTCDZCeJGXj9hEcPpudfdbMuh
         le/q1Aj582nIGj+Alts/b07IfsG8GkDKerzsJuTdho97VH6hSEE6xtA8s50b7bIBH7J0
         fL6RjOvaSJYAMPLdfyaLxkYxDm9mBmGOhD8CX77/ffYt/Lo78wPLWF8k8uyB427lcpEv
         /cy3E41HUzlCN4psYW/EEjv1ccsFK3qYSmuN0zREpFF7vVK+bOo+1Tu8ii1mrNoVJla2
         xPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707794824; x=1708399624;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ol3QEcIEiOh1BLpsgDjP1PLEFR06C0O0EZBWIwePAQ=;
        b=UmLPi3A/iom5b7DQMv6bSloUGWVamXmZDexuTuo87ryNqbIY1aIQBSDhTNmg4PuFdY
         y5ADKVQwHRXeoZNFd4596N17iCx95CXRyRkDrOz/037xrwg1/5M38t3C5OsB3rZcLW5C
         VoJsp+DagNqAESEZiCuXBSHbnl5ROUApaMNncnb89gk+TBMUpOEgsvWVQLls8W0g+O0N
         nZWdlPNW9h5UroapO+3H3GOWk9MvQGMRweidtrBGNYmyzqtDEccaYhbHuIwg7EQ3iU6a
         JgWy0ucSilauqTdx8dPdgkyIXN4qK2rHAfezZH0msA06ergIMIwvdMjbnwlms9a0Mliv
         ajJg==
X-Gm-Message-State: AOJu0YwY7RzKAzqwOJtvyFXkdj2slR0WZ7AgW57GhZDI9cYXKaiaTdJV
	7/WPOkz0uIFo7kR5q1spbjbeD/yiwIyTa78jrfl5luFrTri056aPlPmUH1PCK6R3Lrbv25PUkIF
	cBg==
X-Google-Smtp-Source: AGHT+IE2/lvtUFa4iT45UhB99RCmacSvJqZ8c+JoTQ8zKhR7XCLP/GpvbJ/Z65s2wACzXrxrb6MA3pLj5cc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c5:b0:1d9:3d47:a440 with SMTP id
 u5-20020a170902e5c500b001d93d47a440mr278839plf.9.1707794824407; Mon, 12 Feb
 2024 19:27:04 -0800 (PST)
Date: Mon, 12 Feb 2024 19:27:03 -0800
In-Reply-To: <20230911021637.1941096-3-stevensd@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-3-stevensd@google.com>
Message-ID: <Zcrhh1CyWjCn8eQm@google.com>
Subject: Re: [PATCH v9 2/6] KVM: mmu: Introduce __kvm_follow_pfn function
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 11, 2023, David Stevens wrote:
> From: David Stevens <stevensd@chromium.org>
> 
> Introduce __kvm_follow_pfn, which will replace __gfn_to_pfn_memslot.

Please use parantheses when refeferencing functions, i.e. __kvm_follow_pfn(),
__gfn_to_pfn_memslot(), etc.

> __kvm_follow_pfn refactors the old API's arguments into a struct and,
> where possible, combines the boolean arguments into a single flags
> argument.

This needs a more verbose changelog, but I honestly wouldn't mind doing that myself
as a way of refreshing all of this, and to lay out out what the end state will
(hopefully) look like when all architectures are converted.

