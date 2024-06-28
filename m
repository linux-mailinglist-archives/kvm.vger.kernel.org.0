Return-Path: <kvm+bounces-20710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B34791C969
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBCFD282889
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97675142E98;
	Fri, 28 Jun 2024 22:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HUUIOkX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8A484FC4
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719615454; cv=none; b=T8lD0dSfVoem0XVn8u7zfXXu9Dfotf/WznCBASHAmCf+i2luEvMAgCapy70ruvC+ofn2gACQtU/VGXj0OiF4DLXBZmYzSrBEgwdUxU9jSkbgGqQnE0VhK/awoChBWkdW/LStHHpGtCw9xJTb3+hMmWtFsM80K4cWTXQ8FZQiZJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719615454; c=relaxed/simple;
	bh=UE1GEfWG/RQCZIGjYHv14ta8lQXIgActZd5eUFkSLac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WRYRnPvdchOtXaev+rPC3fMayxXn4arEJYW6fQfu7GI7LhoVvo/7MBHkisMF6SnvVTKedINFk3T13EBh8IP84B738/sSn+jLGVciKEraNABrFf0zTS6I0rjlhe/Lgm2P7Bi4bmQPbOStsIxlGZi/HJAIO009t/dxA99nyDD+wdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HUUIOkX4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f9ddd8e782so8337275ad.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719615453; x=1720220253; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DI0rAvTMJul+eySxlS3p7a2HOzqZmk9miEinxweINkw=;
        b=HUUIOkX4/QQPMsh45SBaGO3jaJtr0wCLzl3Rxi9Y/VblvUByHQERw+OLd6ducMSzmR
         qiaK78DSM2C30uqrtUswCpGobeuVsrbmgvAXCTW6H7haWH+O0mjjT/LWQrPJzGGCkdEv
         lAdhbamGliNMRk6zQVAxoNS2XrlbNTBB1AEArh6ZnGElD9N5ucgAt/6eMEqH9lD/l4QH
         /F9VjipyuvZfDlDcSfmW52TCTRWLl+iA+H32ih48tecffIu8ZW7ZBFkB6en7DjPwtVha
         kbVScEx9bOS2JQTOm9Alkz51W+30QZ/rGWC9enn+LnK3HE5NObJ+VvfYx/9nO3yNUDPL
         JZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719615453; x=1720220253;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DI0rAvTMJul+eySxlS3p7a2HOzqZmk9miEinxweINkw=;
        b=MsgGgLKDNUEZC1qLm3dPflEEYnj0fiuO8NCFdpFHBO1hmjFo5P61BKr8BiyXzxYMvG
         30aGynDN18fUv2ldaxGg/ZtlMSMP+oBmepQ07ew2IwXxv+1JSGgzDaoa25mXrA/RDvmr
         llph/cd8E+UY0ymCDcpGTrkRZIXBuKgOqQAW1orSqKoJV8IfsGeksBG38GgBAsw21d7p
         xyhv+L3Hk1epMVFByKvT9BxkCG9pIv1cVpSQRaR1KMdd9fw2hQcMJuE6oG1hw7CUfiy3
         whz77ayiTMeL9VCCH/sy2JAyvbmfj9PfmCFS2+0Ey71KlqBhbxXAqA6juVcg1PrbufEV
         Swfw==
X-Gm-Message-State: AOJu0Yz2ENBDuGYB0zscl2RYrV93hQeGr8QH4p3g85CMR+UvIcwxbdEd
	TRShWVstq0F5xzCWRV8wXcDHlexbzFtIdE97yCWvq5w3DHjdbmA90Ld2ti+PVYKoRUC5Gvvcmnx
	slg==
X-Google-Smtp-Source: AGHT+IE5ylsu4IsEYZrb3jhOZ4jBbJQJNE6HwwL0xQ0K4nV+iOu+bddFcbHQgbamXQnreJBiHlfR4XGl3ec=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1250:b0:1fa:8f64:8b1b with SMTP id
 d9443c01a7336-1fa8f648f0amr6494925ad.7.1719615452847; Fri, 28 Jun 2024
 15:57:32 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:55:40 -0700
In-Reply-To: <20240613190103.1054877-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613190103.1054877-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
Message-ID: <171961396745.229913.4199964283603115354.b4-ty@google.com>
Subject: Re: [PATCH] KVM: nVMX: Update VMCS12_REVISION comment to state it
 should never change
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Jun 2024 12:01:03 -0700, Sean Christopherson wrote:
> Rewrite the comment above VMCS12_REVISION to unequivocally state that the
> ID must never change.  KVM_{G,S}ET_NESTED_STATE have been officially
> supported for some time now, i.e. changing VMCS12_REVISION would break
> userspace.
> 
> Opportunistically add a blurb to the CHECK_OFFSET() comment to make it
> explicitly clear that new fields are allowed, i.e. that the restriction
> on the layout is all about backwards compatibility.
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: nVMX: Update VMCS12_REVISION comment to state it should never change
      https://github.com/kvm-x86/linux/commit/cb9fb5fc12ef

--
https://github.com/kvm-x86/linux/tree/next

