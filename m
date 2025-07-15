Return-Path: <kvm+bounces-52536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD1EB066B9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AD5A3A5E4F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F812BEC21;
	Tue, 15 Jul 2025 19:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3+CJMyf0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F05C26D4CF
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 19:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607262; cv=none; b=qT6o2a0VosimbVA0UwDUJwYmFfOutr8ivmd7axDDFaqET03d52+vvs+E3ADr1QE7xEkGPmOHyt4/1aFVw4DPodg9qJeGcS4q5ynxBJ1mdaC5Qt3Uh6BDiTiTcINo1rXIMCy/0b2E7BXtYDOgT19OJdzAGKde+q94YlXXbs/oO+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607262; c=relaxed/simple;
	bh=tQ/l2kGsknXYJgcrQryjZtkeQfE1o01QgQp8Q3K992c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=IgvEe+SnUcNhH7dVAdc/Nyhf+1Wc61Fu4VXea2i8+Q1zzbjt3ybrswmkr7TecJwthRHdB0d1D8q2MFyGRJeH626EH7EIwUoV6u/lUpueLycAG1PRIgpZGwJyv/LXCmUxLBFh210MvjAgMLrWaGEHdMBrn4SaCeq6VhUeSSlaAF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3+CJMyf0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so5198455a91.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 12:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752607261; x=1753212061; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQ/l2kGsknXYJgcrQryjZtkeQfE1o01QgQp8Q3K992c=;
        b=3+CJMyf0zFjKaezbsg7atwsw5wGeSmHxr8Ws64F5xrJNR1nJOgkRo3KUySnL8D8dc0
         htOvIHLjTk/bBQ9NM71Qm2rmlKq5CVxLxyG6UlSjAljlJdVDi5z5sfsYAPAEvhaEegX9
         Wv3TWXJADxbyhU+C/zY2qVoQoucD7dDpLSJ6bgu0Idee+9DabBFeR7jIHqiO7dhtjl8n
         d9yu1i1Fj5BepyFEdt+l8Yw+0mZdfFTTUj5qcOGUd79kIauS6O0MpcWUnaR4EIB6eiWU
         J0kthIER85Rfd+ngkqMa87rflK9PlL/ElhOvgrL34NQ/0WB9ruguH6BnkEjNo8mASzcV
         AqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752607261; x=1753212061;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tQ/l2kGsknXYJgcrQryjZtkeQfE1o01QgQp8Q3K992c=;
        b=WatjmY2ABwbvUXgdnq2ePVHxwmNxru1jC4noorQVAXaKcDrkG0wqDQQdHDGpm+D6lN
         4en0wzudPGb/BkEjMKZ75GF4RS7Fgr1u7MBzZ+WB8JrPZpP0snRowyi2m6AbNE+pZZ8X
         Boar9tzGMnZ6WFCRT0B8nQvoMVmcx58EsSCJvOC9vj1uXTF9VixfYsHuMluTHOc2v1V9
         femjOumcjRgtWoerR36Vf51e/fLfU2930009CxP9/AECHUfgnHi10mIyl+nxcFAakeGi
         gDXXL3DNNFlWppghFR8fta9BuynmD1DsQbIxdvq6ytNEpTwlQfRMO3wYQAKTJN5wZkPc
         +bUQ==
X-Gm-Message-State: AOJu0YyzVKK+ejmwMdzqBikvNKtxqDtuFeoxNUiDe23OclvKoVhSdqGV
	qiwiFAi9j8WcZsU4HS/PRn695eMacgICpTZpKXBsWHghwcLPh710xKNMQp+5tBn2+HGbumNVr8u
	2pqud8g==
X-Google-Smtp-Source: AGHT+IGJywdBfeyK1E4aMcIC63AEdlB583+D5TiEUYz0wX9xLYkVmcHHpm71Gk7QmZ9DlartAf0cxOa5NQg=
X-Received: from pjyr15.prod.google.com ([2002:a17:90a:e18f:b0:31c:2fe4:33b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d:b0:311:eb85:96f0
 with SMTP id 98e67ed59e1d1-31c9e76be29mr527056a91.29.1752607260807; Tue, 15
 Jul 2025 12:21:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 15 Jul 2025 12:20:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715192057.1901877-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.07.16 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No PUCK tomorrow (July 16th), as I will be traveling and unable to attend.
Though as usual, y'all are more than welcome to meet without me.

