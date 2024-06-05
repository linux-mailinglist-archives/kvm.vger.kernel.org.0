Return-Path: <kvm+bounces-18975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BEB8FDA5F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 01:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66DF12856D0
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 23:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8384116C864;
	Wed,  5 Jun 2024 23:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="deXPxK5j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4316C6B0
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 23:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717629713; cv=none; b=An7+YO32jcTme9UhqD9xSnKxfEFdlllz4nls5qsoGU5vx9cbADZ5hRJbyGYFFPwvZNQmYVjXiaRhWWW6wOFl3cgUHKLJoasOawy+X48MIthDzXeb/iESbiueO6m63V3WGE3LUEwjRvtb+L8cMpDkT47zJX3m4uVPRg3RqtqLNrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717629713; c=relaxed/simple;
	bh=lgpxBdMkoYBom864wCBVUJwjiAuSstt3ymEWVVAUMPU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RvRPY5aTOeHceLzPXHe/E6VaD536Wtvv8avpFdGezEdvhrZh97oHlz8bZKy9lvbnJkOY8cmvPHEAQ9kjLm/yYDRxDln84y8Oo57ArCSni5agiFDY2DH7S8WhgGthmAcWceG5ZTzItIL5Jggum7t+PricPy0hEzeaKnf2mzgnBOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=deXPxK5j; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e4afa326so4678177b3.2
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 16:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717629711; x=1718234511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUTg59MP5vjRuiWIv1iq2PwAJbiMY7XpaWT/V2qdsKg=;
        b=deXPxK5j4dJDXTALiCvw78PbJeRS0Jk9S58gflTXFpt+BDJK8M2Y+7nWW13LaVv6FR
         k6y8iDFSo3wO54K3Xpmer8ZqdP/4HRLeMT4fETiXJylc+mg3XGvf3kAjEaxHne91aNma
         iXubMHD+15gqfXlzO50cwwZKC6sV+KuEjXdKsNEeavWpp9VjNNVfe8h4zcuQ/587G4dk
         1jP0QkITWta4mSxd6n7zuZx34xl7lnhNtPX/JqIKmvEUgeE6fnPHZ8xKtka57xFsHOXP
         H1uEZ4N3YnWBGcsb+KsG0MlzhEbp8gz/uVU2xHLs/O1UA/oXEWLDxwVaG0H5t6ey7Ntb
         YAAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717629711; x=1718234511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUTg59MP5vjRuiWIv1iq2PwAJbiMY7XpaWT/V2qdsKg=;
        b=kZeIzYpn0pP+JhzPabwwaUUkUxcSkEmKuG42CZLx2Dpo28zxhd99eDt5+WiWF5u3IM
         ggFXHlg3QyUpZ/h43rcGfdykeWJHY3DnRXcYcf2KaX+YyyC0HFxMysz890FoUUtacVom
         lnEOzTbGgj5HJjvJ0jQhpieUbLZHIm2J/x1vgXjPnoEXYGUzWCwqLXt2oWuvsdgWHaG8
         R+pEQSmjNUa0UzLmWwAwfw2k31OB8S3mKk1fDLFaxZTKjp7TToQJ/YziB0TzJrTNUavk
         H34/UhGWidD2L+ZHzGPjJkYJsDxgM9yFOlMhEEz0mQhFvKhMCzzung9HJcby1hHMcUYA
         Q9jg==
X-Gm-Message-State: AOJu0YyGDy1E2LP/clBMucHYeCZpdjYOSMNO8BhhWU2qWrOYw7upvUrv
	WQE8WK/Q78ntFthGHVkdXmVahlOnXio1A6XY4a+tqjBiPPTPPHhKj3oNSruHVgNwSgTIDDV5+WB
	d1A==
X-Google-Smtp-Source: AGHT+IF27CQtlitB6xshVLa7xj7cW8wDq1c69klrXZNK47gzJNQ/ePTzxDwW+o3ijQHseqAGK7NgB+cgIjA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4ac:b0:df4:a393:8769 with SMTP id
 3f1490d57ef6-dfacacf18c6mr199674276.9.1717629711320; Wed, 05 Jun 2024
 16:21:51 -0700 (PDT)
Date: Wed,  5 Jun 2024 16:20:44 -0700
In-Reply-To: <20240417232906.3057638-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417232906.3057638-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <171762855564.2913523.18402472407663682910.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Fix testing failure in x86/msr
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Wed, 17 Apr 2024 23:29:04 +0000, Mingwei Zhang wrote:
> Fixing failures in x86/msr for skylake on MSR_IA32_FLUSH_CMD. All code
> suggested by Sean. Thanks for the help.
> 
> v1: https://lore.kernel.org/all/20240415172542.1830566-1-mizhang@google.com/
> 
> 
> Mingwei Zhang (2):
>   x86: Add FEP support on read/write register instructions
>   x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM
>     emulation
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/2] x86: Add FEP support on read/write register instructions
      https://github.com/kvm-x86/kvm-unit-tests/commit/51b87946279c
[2/2] x86: msr: testing MSR_IA32_FLUSH_CMD reserved bits only in KVM emulation
      https://github.com/kvm-x86/kvm-unit-tests/commit/13a12056be1e

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

