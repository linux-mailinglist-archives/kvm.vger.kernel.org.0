Return-Path: <kvm+bounces-27245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B276597E080
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 10:04:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26A082815C6
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 08:04:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A7519341B;
	Sun, 22 Sep 2024 08:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2A+Ceo/m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC812C6A3
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 08:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726992285; cv=none; b=jPLMHmDwZpakRidsItHNfn81UIjyI/RncHnYVVNZK7JvK+lZufBAYBnfpnfDh5E6eapa1P1YYqXo441HwEPliuDWiRD+YqSXmQvOLtRgG1ufHyMpSHghFmW5ZCe2hT2wIJ4Rg6WwToaGLbCYLAuDfH5J1OBJhYXTtwu5l5Eqyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726992285; c=relaxed/simple;
	bh=kFIP/wTtIov8gaYYZQRMLUa2A9DFJiPU6vH9pzNhHsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lGYpX4LprIXwYKqW1S8nqHV5KZMcJPyezI8UUK2VQDP/R4t05XYWKUpOdVOkCx3lzpy2ij1qhiYeDK+Mo7aTqClO1QBpVM4OngRVwdS2O2hkYALR09i6p8N4ENe36FqioNQsXLI9LMPqlx6S9jGy+2toZyKriwKb92SFVFgS5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2A+Ceo/m; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1dc21ca19aso4953243276.3
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 01:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726992281; x=1727597081; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=adTV4LWKS4uJp5V1QRRytEhV0K8481uxq0Gm1t+3V0s=;
        b=2A+Ceo/mCLjMseVjbvCsXAzMAtClcjttl1YTiDqOWLqd/53n8rIPguhmtIjfU5g2Nd
         uvLD2CFVNvlANd3hFk2G5rpBXxoM0i4RfU+VTAJRbXgA4qNsVHqjpdQY9bif3/tqeZb3
         kNSDrACfotPkZeHu3iSC/mPwjPyElnvfar4t8vxBRXdwA3etmOZsA8m9EeCEqeKlatt6
         86wLJxGO/gHtIagnG/yu1aPVXErtu+tOWWdXxin3KmKxw/2z5WtA/asvFPc+VVbngVDq
         ShQmpwQLwW7CMVaQ2NQYWtbQvAC21hVT+8X7pA6+ICNJT5EoWJhMxqNQEbhGOi7AqWHa
         tojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726992281; x=1727597081;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adTV4LWKS4uJp5V1QRRytEhV0K8481uxq0Gm1t+3V0s=;
        b=Gq8s3ahV7DrKcCURDBPzxrUGVzboS+ePa5yTfo0XtN0BZGaLZff6Pg/S5lW0iFByla
         lJpJOOE7JO6hmlgqqibLMj66E4eW/cBJ5uKEOI0qYod3mTV4qtKbESrpq/Iwf6XYVSEy
         xh1U0Q9clm/OXtL15Gncqe1A7XONk9tro4/0Z64R1s0GW6MWEWO098feE+mnasUBPjkz
         /JYqmjMr9jwl8sf3qIdvRk7xHqZx9UCjwrpeQJzeOyHU4llc+jwpjc0Wvkq9Mc/i1hTp
         S1AuNJNkvyc8SGxmRsK+sfYgXgWuhw55oKs2mIaZYm6cd34+UpJbUZTyvrRa8l+uywQZ
         mGpw==
X-Gm-Message-State: AOJu0Yy209b5rTHwMhmIN/Nmrg1rqWGlTcuOjsUQNdSM5Zgj8oiEuBtQ
	dJC2x9D4fLXjeYQQgO38ycQuNkwghg7eKYO1UGl0keihRbD11mmg6XkUIFZeClxmclWvDiybj96
	F/w==
X-Google-Smtp-Source: AGHT+IEwJweEbOI6acnK6ZpOXs1qSrEZoBam4fT1Yp4H3oBzQF0AOvkHVngY0fb2QytEVzzPX/dijXmQN5w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:b20e:0:b0:e20:298c:541 with SMTP id
 3f1490d57ef6-e2250cd4633mr6150276.9.1726992281039; Sun, 22 Sep 2024 01:04:41
 -0700 (PDT)
Date: Sun, 22 Sep 2024 01:04:39 -0700
In-Reply-To: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240917112028.278005-1-den-plotnikov@yandex-team.ru>
Message-ID: <Zu_Pl4QiBsA_yK1g@google.com>
Subject: Re: [PATCH] kvm/debugfs: add file to get vcpu steal time statistics
From: Sean Christopherson <seanjc@google.com>
To: Denis Plotnikov <den-plotnikov@yandex-team.ru>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, yc-core@yandex-team.ru, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 17, 2024, Denis Plotnikov wrote:
> It's helpful to know whether some other host activity affects a virtual
> machine to estimate virtual machine quality of sevice.
> The fact of virtual machine affection from the host side can be obtained
> by reading "preemption_reported" counter via kvm entries of sysfs, but
> the exact vcpu waiting time isn't reported to the host.
> This patch adds this reporting.
> 
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/debugfs.c          | 17 +++++++++++++++++

Using debugfs is undesirable, as it's (a) not ABI and (b) not guaranteed to be
present as KVM (correctly) ignores debugfs setup errors.

Using debugfs is also unnecessary.  The total steal time is available in guest
memory, and by definition that memory is shared with the host.  To query total
steal time from userspace, use MSR filtering to trap writes (and reflect writes
back into KVM) so that the GPA of the steal time structure is known, and then
simply read the actual steal time from guest memory as needed.

