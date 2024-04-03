Return-Path: <kvm+bounces-13407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA83C896159
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6AEB2B24A26
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 00:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8CFD299;
	Wed,  3 Apr 2024 00:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rCctj4kc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C949A1843
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 00:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712103959; cv=none; b=V0zsqLRKijnLs+9iIfEyk94P19vTM+d8biC7LHvxjDP0IpZzsPkGHH8C0f9rArYRpeSx3uGTW9Zpu1qgmkdqwbQWX7ANgj5kYziQKFUMk54BLO55K5Y2NlwKzaewMkM+iZ5damZYs1OvqE4apvTBxjVdDX8jaTR9kLRyw6hot5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712103959; c=relaxed/simple;
	bh=CMZjqoXY0RIZMdPXHMDU53a4jFQWckzmNS0LQOaH+CA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=A2BkACxcg+mBxg+rmGIGVaPaXhNVpFoW0iERqScHqoQ1u1i7DmmmLaRIffb8X+sp5cgDmIypzWEHbrXvoDbWoso/ZVmY9WEMiG9/NaJYfpcNnsueKva3MjEmZksS7r5tWfNOUxwBokUR0j9c0dBLZquwUqNdaS0gYX7XEBRba8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rCctj4kc; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8dd488e09so4919179a12.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 17:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712103957; x=1712708757; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kr9KWWXSbwQMl1W3P1ShdqzyIsb6ffEOm9kzhYBT1o=;
        b=rCctj4kcQ6NwtKYTUUG9MvaaeiL8UYKbuLsZM1ZqJ8TGliaPu0Eg6Uax48S+IDKXel
         1XfZtsLr0HqaGljpu2T7taI5DnjBLJDEhK5ElbeRWQ8m8qs8XRg3ctocGvu7UWDNWKcb
         NGlXpxTxIkJUkZZclov/Hfgx/6PSlBMsrpOim64Zmk1EhQuuqK/1dlfehoSHYLba0kMf
         Of3Tfq0ygP52hyR1TxXicD/Wm3E1ZSuF+5A+Z0sOijDJ8wMCfYW5N0wJxbO5Gl9kz8XU
         YxEuPUcDUeqVSnWVW/1MLdOXN2aMvHoRkJsisO8XLpmtnQ+5v9zRhPX7yN2QWIsoXLBB
         OZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712103957; x=1712708757;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kr9KWWXSbwQMl1W3P1ShdqzyIsb6ffEOm9kzhYBT1o=;
        b=i6E+xTnvMTTAk9xCoVZLOt1FyxDxph02iCb/UTPYZj6dA0+XUyJomU2/e9h+GfNaCP
         jS870uJhGapjbPHDFHYFHUIgOsyovFl1/obMXSn5GkYhT0ArzFao6ojQkUZ/LqrBQO5E
         a+Pu4nkzFQSHmZ81tWJ/P1GPjm0Dbtnz+JYOUSQAVjxARpLY9xwCYXsSRM4BNwHEKCpt
         Gwp6KkNckpdbbN51X/ELXMNewYrwDgLA5KFEHXdjgVCi/EEYrCqQfFe7D+mz7JaEdFwg
         Yg84nKYMSx1xJ5kbZq9YGpbTZJWX9rYEksz77wf9WwwT9zBbC9l3dAPMjtS0hVIoFjxp
         S8FQ==
X-Gm-Message-State: AOJu0Yw+JVvc17rDlo2BW+WipTPBjpFsQpIhJBssJoXgK1vUqGZrtxRX
	QvbOfAQ/gP6IoLOA6Tg2o7a0ACj+B9hkGDsNWJckJSEqNwCgglvN4r7oEwHeNiOr+IoHz51ql7G
	prg==
X-Google-Smtp-Source: AGHT+IG9MI8Qnt15d8mR4lpsuvXzZoy/+itHKZOa4aH+2/d2VW5Qk0S0HV6LV4xAAm4immTfskhZnGmM1Vo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea0b:b0:1e2:26de:c622 with SMTP id
 s11-20020a170902ea0b00b001e226dec622mr1094018plg.12.1712103957230; Tue, 02
 Apr 2024 17:25:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  2 Apr 2024 17:25:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240403002554.418953-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.04.03 - TDX upstreaming strategy
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Wei W Wang <wei.w.wang@intel.com>, David Skidmore <davidskidmore@google.com>, 
	Steve Rutherford <srutherford@google.com>, Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

The primary topic for tomorrow is how to get the beast that is TDX across the
merge finish line.

If time permits, and no one has other topics, live migration support for TDX
and SNP might also be discussed, but I don't expect that to be much more than a
high-level overview-ish discussion at this point.  In other words, I honestly
wouldn't join *just* for the (potential) live migration discussion.

Future Schedule:
April 10th - Available
April 17th - Available
April 24th - Available

