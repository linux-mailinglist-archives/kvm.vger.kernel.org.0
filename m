Return-Path: <kvm+bounces-47798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5CAAC52D8
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 18:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 675574A144F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 16:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026DA27E7EA;
	Tue, 27 May 2025 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RMH3hmLy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F027F752
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362438; cv=none; b=LoVWZ1zsLfbI5BlobvieI/D5VOed+Tq3tIiBNEZnNpY13hS9L4olfqZBGj6IXRwGZPy226v0UyUeBisXRoa5/hPGaxe6TBCrNbTBU0Y+JvM3EBdUJWeP/FRHdjknfHRVOv0Nh7speioK3ANJkjU/334HYdbg+8nor/DlkWb0aG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362438; c=relaxed/simple;
	bh=iqiXA6Rbb03tF/HCDxpk+ZKgjSzt6H2Xax2VkzI4ddM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qLjyla2BntuJNBt9TrOcx7Rw0MvT7z5e25/qkvWs8gv3grxyV0li49SIOhAY6DUCs6qCqidEua0n+OPC/109SO8S17TWaviWk3QSxZxGWJUgSJRFIdkzdicLkd9n8rzhand4yVqRztY7K4seJ+1DinQ1e/++P81ymbmXv3Xhti8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RMH3hmLy; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-30e5430ed0bso3366677a91.3
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 09:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748362436; x=1748967236; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CyI6lRGaIfXB7jxaPrJKSQO0H+oxISfyvnAekkvYBnI=;
        b=RMH3hmLyHISH5G40SFaCFagFLlD/u+x0m/nughYU6Yb/2VD0SwjvTl737SYtgjfBJL
         swt2IN5HaAZIhiXJCf/2PTdwWKdi/S5hMZ9wwqf8oIwu4s9mjHBQosaixGjEbyxsmJA1
         B1LD4SahbsWCw1CydOmIO9r+fBQD/cdMXdsOAt+HhF553+wEnmjUPlFoMkGsi4a04N5H
         Vs7I//EBoKNFSDuRabYMtl50ozP2uImtEn25ENMAgtCthpl9PEgUd7M+lf2K5tbncA/f
         qk/dKMax1F9fd7oFfNihRO9k/n9liX7b9vnnrcKvurBxGaditzFTjWTEIFoW7ABohRcc
         X/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748362436; x=1748967236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CyI6lRGaIfXB7jxaPrJKSQO0H+oxISfyvnAekkvYBnI=;
        b=Adk1pbtcALd+/HsyNNz8sbFOWxkWLf1NZbG15hqZOfAjpgJSsXY4XgI9aP+754XpjV
         zVjcTlPjj25Lv9OHlTeVvRXJ0/FealC5ty1hICEnHdyM0Uje9BfUSy64P1eegTSY4Rjq
         InZqvk/FEkLM0eghrCm9u0+GUocMUWgID4SqzYOSYHA+mj2dfWIQp/fjw+odOlXVIdzP
         KvcUNNV/sBs/ci5XVk4t1fg8z1n22MKWqMPBd6SxCe2MkVQ3WtgDPwVjoeWAnsoi6csf
         NzWcisb4UmQPin0yYIBN7Y6o1cm/cd2UM1jF1I9t5irVm2Dwmx76yjqtMxfVGLC67+Wy
         xrGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP87CexWBr+ILTurJAja3fEz5uFkCXUa58H49f0mvI4outpM3WS7YXh5VIYCeGWO4rhhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+RLK50y00eGgX6MlsF+btmqQ0ISoEzWifsIe37EQL7rJeVTiz
	viWPo17XXIYEyxGKp/0Quo4aETbHYWQ8GitUAw0YhjgKWwCFXyZgV/1W/mMzisx30essW3tLgnC
	AP69QydivS6R5QC0Ukn7vS7Q1OM6ECE8jnG76cqXa
X-Gm-Gg: ASbGncuSppcwhhT4blpw0wxooo9Rcl7Uso+d98kM0M7o/zbS7ecQSfSgSbh3wiTFec+
	yI+qWB3ok9jabgJMj6cmyxXRYq19gsvwLW3unv68Ul3A1xi0FzojLPrldL8tUeDIDiN5CoJYuxQ
	GiWIt0OdD/9/ynHuewOSfaKaGILlnmDQlvXURX/bSUkkK7
X-Google-Smtp-Source: AGHT+IEFXnUmQcAwZf0IdnuZbXNQFTMc5YTTUzgjQQa6keoKBAojGNaeiYVFV4H1X8znHWDrSoSoOeOR7BiDVmVBRMw=
X-Received: by 2002:a17:90b:574c:b0:30e:3718:e9d with SMTP id
 98e67ed59e1d1-31110d99815mr22155423a91.35.1748362435541; Tue, 27 May 2025
 09:13:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428195113.392303-1-michael.roth@amd.com> <20250428195113.392303-2-michael.roth@amd.com>
 <aC3m1uMmp28gSm3r@google.com>
In-Reply-To: <aC3m1uMmp28gSm3r@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 27 May 2025 09:13:42 -0700
X-Gm-Features: AX0GCFuVQ3lRhOu8bBMkwtNkd8VOCPOAbdPGDH93Xwsy8_b3o-5N_Qdrv4KHUx8
Message-ID: <CAAH4kHbcLkGQ4yLKOzRzW=JP5QouonneYnAMU3eqZtPKVVF_jA@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, liam.merwick@oracle.com, huibo.wang@amd.com
Content-Type: text/plain; charset="UTF-8"

> Side topic, what sadist wrote the GHCB?  The "documentation" for MSG_REPORT_REQ
> is garbage like this:
>

Dude, please leave this kind of feedback in your head and treat your
collaborators with respect.



-- 
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

