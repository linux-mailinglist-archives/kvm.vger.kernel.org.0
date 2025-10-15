Return-Path: <kvm+bounces-60086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF9C2BDFFC0
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:05:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFF123BAE60
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:05:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC3D30101E;
	Wed, 15 Oct 2025 18:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cT5LTNf/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84AD21B1BC
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551536; cv=none; b=O7cf+3AetFAX0DCbYjZVQdnoZVYACH8Ivkn35bjov/vzM+t984KaNFGcZUDpRoypZsZt+H87EdBY/yl6sIUfhRKYHyMCBosV6pbIFB4XE7F7YTN9i7V5+vUfL4dhos/XoHRzaoh21OoEIHuNcGYXoSgj/+q6rP9g/9crTEpzUZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551536; c=relaxed/simple;
	bh=UMsdyjzBO+xpQAtmVF2K42FHZE3eVQ96vmVxMXpt6JM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tyROQwKyeXjvMaEdDA1Lg+Dbn0wf1M4jaabySfBmIaqTun/1NRAz4odoWDbrCEPCHDmsIruO73vltMd0btanriUl69JjlGpHgbeX8j5GAyKvIVc4hUb/2Pv6UrLIDYz7xELgJlygvhWtEtpOsJmXjOmGgSZcHPKVUEd6VJtrteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cT5LTNf/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso8562164a12.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551534; x=1761156334; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yqvjk57rc7iKF+vXl7Uf8rmg/+Ppe3Al9zg0afoxasI=;
        b=cT5LTNf/2b6kYu/sXszHG+MgOK8685Bw0DC3pPiiGXMLJ12J6kol1tQkEFzidGOuYI
         NXubH1VTGLtaGjn7FrkmqGud30A8ke0mPczHxueW4vcm5OOc1lgEmniBHHuxuuGSc5zQ
         pU3D76vkTYlc9g4Z2PW60NZSZ9YBVKNXRUd53Sd46nZ5WXv3qLPHwCqgffrEecYZkfH+
         5ajdyobSwL5p4n8f9VLCoVKyWaTqE1WTM5uzjSlrV/xufcJ0f3XHUxDlxWY5Oa5RaHzG
         TMOwCQYxWM1oUfGPaOvSEC2tbVP19ggB5ito6G6A5dIMapiNoJah+1R7mODuafWee5lN
         XU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551534; x=1761156334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yqvjk57rc7iKF+vXl7Uf8rmg/+Ppe3Al9zg0afoxasI=;
        b=swmt9kOwNiwcWon1aPGDEl/Q2hRt3ujePLfrzvSeufpS+sDPuxJE15yxetVsbN/SMZ
         ZQWQghU5KflRzj9VQHqsfzsb6zO6L5LS/D/dVct4NGtJB+9D/9jx1soRVQUk0QlYIwd4
         1vSzLFzdAHGr/GMALuagbryPx4o80pm8+h9JHqMmZKRcV2oQAkMcxw2t/aIhnCMNVad0
         W34AcBwGd0QWDNm+UfBCrIuNMZQGwdalPclG+/NZBUbRopOD5JAwCqZBWcnBCCGWjPyp
         yHPRKitbeIB8khY7giEUM1xtd6de84beDfTFLeQEX/brh7CiRbmeRSMEn7GWgF1TouUM
         xVDQ==
X-Gm-Message-State: AOJu0Yyi8d/fVUgFzmNEhHJLd4MetJdCv13nVVqUrNNKfR+kozFG83jy
	qehOwSFK+/+wB1iWUpUBehd4TVZe8dMKbeF4+anJGThXu4z7lYsltMuU06pHtMOwQtTDhYvYO2/
	UncsuiA==
X-Google-Smtp-Source: AGHT+IElZs0fBcFdjim1seSgDsyWxn2S91gbcqt//KzWmfvX3qRt8iq0IJ31IzrSDUiTdF9bCDDM8CcfROc=
X-Received: from pjbds16.prod.google.com ([2002:a17:90b:8d0:b0:32e:e4e6:ecfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a91:b0:32e:2059:ee5a
 with SMTP id 98e67ed59e1d1-33b5114d52fmr43204782a91.8.1760551534243; Wed, 15
 Oct 2025 11:05:34 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:40 -0700
In-Reply-To: <20251004030210.49080-1-pedrodemargomes@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251004030210.49080-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055116678.1528393.4651749265873372559.b4-ty@google.com>
Subject: Re: [PATCH] KVM: use folio_nr_pages() instead of shift operation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sat, 04 Oct 2025 00:02:10 -0300, Pedro Demarchi Gomes wrote:
> folio_nr_pages() is a faster helper function to get the number of pages when
> NR_PAGES_IN_LARGE_FOLIO is enabled.

Applied to kvm-x86 gmem, thanks!

[1/1] KVM: use folio_nr_pages() instead of shift operation
      https://github.com/kvm-x86/linux/commit/fa492ac7fb04

--
https://github.com/kvm-x86/linux/tree/next

