Return-Path: <kvm+bounces-55756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF762B36C85
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 16:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C53461C43BB1
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7ACD26CE2D;
	Tue, 26 Aug 2025 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFstDtCB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA7B23909F
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219560; cv=none; b=MzccWi4vQJY5j0NLE5cwX1XEZ6doTt9FW+ZDRo1uTeg7hCf3IqDg8bmCBsJ2kUNnE+nVl/Sqkx1uMsJFbpUsDaBIfjOQBVuedQ5MeJ+cSbFWW4RUSE0OeouHYvTEMih6GPtjPTCJBOJy+DZWjnup3Gsrdt9JzaMcrxwan1yIEVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219560; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yte88RqkXitFCBptUXbJR7uZ/deABGoch/VBrVThZzJ9bSiXZtitfHxV/n7MEoxTuvcRHa5XAuaDaMTtppRy0QeGwkMGSZpBJyqWTQ34aVRFLaGyxDfIxmvpwFmGbeVxLixnAhmfTEu06g11sW1iiUoan0ZyZF7IUmOvRR3SElE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFstDtCB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756219557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=QFstDtCBh65bQebtpAPHzU6jQ/1W6jX2eV6ekUm5Ijb4i5TVOGZjrrJRrxwHt6hC1McX3I
	MpsaVib5k47rslePNW8H7Sb5SjYY5W7X/HUn1hDRa1TD2zGfiUWSGteIEaZNwi6EZ7F/70
	5Xxdos/hcglE3N+KEincXVEBbq9v3KM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-Ue-JUokRPduNmg7rrGHjiQ-1; Tue, 26 Aug 2025 10:45:56 -0400
X-MC-Unique: Ue-JUokRPduNmg7rrGHjiQ-1
X-Mimecast-MFC-AGG-ID: Ue-JUokRPduNmg7rrGHjiQ_1756219555
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c380aa1ac0so2179493f8f.0
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 07:45:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756219555; x=1756824355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=icIXb7cmYUCST5pJbrKGELh1dP9gC6NhPDht947ru63T2Hd9Ub87F8f089khPsn/M0
         ZqnD1NAp+iknEjXVF3o43TxEMcwwAdxDm5cqck6Z90ZSpf4CWrABAwid7UMtg5H6my7A
         qIHjbsL4Z4Ciwuu4cxairV1VBPOeIXgQv9aNIfPkh4cRswjSPuNqZyqRzpVOfPaJlTfx
         7ZV9PBQWxo1SQ8kiapnUS/lCF9Tv7eVDmod80IT5eSTLa2vMHGRbAf8P99A66wSTshZ1
         M+UzZPxvNQMnZ1QlZpY3shhG7VKZ3brmKflRs90rhXpy1hg6iQcB34OJmmd6sK+fhNxC
         OBcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVPALmGwdlvb8s0Bi7QF7gEeca6Ot8relIyI/kmem03F69/5IK6coCMwdyoASwKk7CYMQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL1A2mD/qJ+6610s98ju3ExseNJbbFXNiGj/4G7NwuWCBRfUt6
	vSgu14JnaD4ENJv0FqcdKIab0b+uIXTh6QC2gXiDiOXLTdtrs+xDzW6p9QsY4Pj9js8QEUCpjrj
	vX/VRuiX6MA8U7fErnPHXM8A2Lhm9tWFiWN5Lqjn3/nMHhx0MbJbbBw==
X-Gm-Gg: ASbGncuBXEvnsiLjKKRIoWrcPuI7dF0oqVQHZQBNTCvQ/2yYlVYX90Rbqr6GOUz8Av+
	aVsOu2xTf6auhrvdhH2i5E5uBcK4HwhnpEoahuYwDp29930Qq2VRXXNe4f+ivSpm76j8iizOcm1
	41zQeMsMl4MYMuCKSWMOgwTwKQrjp9BrCZrcCRbmN1jujs7yN2X7f5wAUEZ9LLGPrktK8+9OcFD
	u/GhHtK+JU9gJ01we+PkFvdi2VeSPys5LtUvc3cPg/TtzLa9AU6jxqNHuuejyRANNasfNfWpsId
	aZBrD4nNqNgLdKLx3G6Svq1ssIffX2O+smkyHNoGy69DUYiWY3iZ1P2pT6Vm6528lJ24DJyS89X
	epGIQdvFSdREVAOaMxEY0crVB
X-Received: by 2002:a05:6000:2dc5:b0:3ca:83e2:6339 with SMTP id ffacd0b85a97d-3ca83e26928mr4110279f8f.49.1756219554603;
        Tue, 26 Aug 2025 07:45:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0GwVFw/WWL+tC25zVvljNEPyYp1Lg4PacyHJxgzmxoNUeYLiDxItEKF2kvv8lM7QXT/H2Ag==
X-Received: by 2002:a05:6000:2dc5:b0:3ca:83e2:6339 with SMTP id ffacd0b85a97d-3ca83e26928mr4110262f8f.49.1756219554240;
        Tue, 26 Aug 2025 07:45:54 -0700 (PDT)
Received: from [192.168.178.61] ([151.36.40.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ca6240b4f9sm7193834f8f.15.2025.08.26.07.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 07:45:53 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: richard.henderson@linaro.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to kvm-all.c
Date: Tue, 26 Aug 2025 16:45:50 +0200
Message-ID: <20250826144550.556967-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250815065445.8978-1-anisinha@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.

Paolo


