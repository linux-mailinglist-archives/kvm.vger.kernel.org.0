Return-Path: <kvm+bounces-57661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 568FDB58974
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A67F2A4B6F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563DB230D1E;
	Tue, 16 Sep 2025 00:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZyyk1Pp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E0A224240
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757982559; cv=none; b=p3stsi6NfXjS687m7Y73hzMUHoEAAnONNFDs0caeB9zdIrRZuZB4ty42Ivc7H0Uns+yG1h3Ej2Q4a8A/+OCBWam2Ejvg1Lg2vVKjPe3ydMsg4LadXmXXZtJhpTHm2mZcbBtcnXOTzycerjMHRspZh8r5ojhUPGrs0epoDDxpTLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757982559; c=relaxed/simple;
	bh=2wOnBKKCaFqNYjyYc1v49OMoQyv2y72DCIFRe5yU+wc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p7VoZuXH41ihgsTPfzNTbH45hjl3oUh1n6sb5In819R3McyZdI7JEum8o/6WZ0SpJqejDzBMttYoXT8SPnSssn/GVaVlRZdrgv4uB1Z5faQmPEhJ7V4YYBXzw2w5+Coghnr0wexd4Q1RR+Ysy061KU+FGcXpdkc3PpgPaKuQrCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZyyk1Pp; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77618a8212cso3107345b3a.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757982557; x=1758587357; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncvI8QqpwL/ZLQ3Rb9ROAQpWcIVFT5sOJk27qsYiqbQ=;
        b=HZyyk1Pp0fzQQFhPR65T0OOEvU5Nr6Akj3u6rFzcIg/zviamSRMZO639CDTZI1GuKK
         TExUvqFZJG0p1keRzpQKnYT4zbhE28odMoCLycgDnIpTs1L8x5rV9uR9xdFX5ZTdfNTw
         7RAF6ZiV3Vh9ZQ2T4qLarkJHWQSIoZA0fFJFiwPEe4VqjsDhCaHzLHYJVKPJweIHqnJ1
         BixfdYHdpHk+qRpyZ5rndkTVUdu9LxlhkRqpXutVFXSkowJm3Xp+ddgLK77FZQjdTte7
         o/+z4baZVPhA+qAliT2ndfm06s6v3zwsWEOmwV7p3q3R/yyH0sV6m/O+nLWMSkes2QwP
         xodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757982557; x=1758587357;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncvI8QqpwL/ZLQ3Rb9ROAQpWcIVFT5sOJk27qsYiqbQ=;
        b=MC7oRBnNh8qWu77MJvNNsnC4pF5LP4Aun2yE/sNOeUuZi6CK7PAmmLyhowTN74xEkM
         ollkt7AN/ukiW41MiwX8HdtxVBMlbgC4SfOzLh9XE6KtSlHcLttUzxRT+EU5UeTJjCDm
         OPfvgP8FFlP8GcGqyYrDKjCn4J29o3YqSOGaitqNRDP7rDMbYrP0VOxsNI3EaRMkaejj
         /ba3vdK/k/RUW5h/OcPojQ/GZk3nOURUq0PEfsI/hZz5XZga+Ta91kARYVHeSoxmWm0u
         SHG0oDZeqnLs9iOtWBGNwSgBMG+9bwzGTtVd5fITP/WDR7234mh9HQ1q68CeZKzllQP+
         LmSA==
X-Gm-Message-State: AOJu0Yx1ETueWvp0/cWA1nm0Wvcuyc3vpPLIHnq6KZeC8NGSQLGvjIef
	IRde2VBBMIrv35c5Py8uIavWQmwmaRUSQV39lFYqAcexBnlP4SFZPaQstRCv/ityVFxQMtzJ8jD
	co3OE2w==
X-Google-Smtp-Source: AGHT+IHkRT4DqkkQPQ6Wz5aWthlvDZ9K4ii4O1nKvY9tLx3KTJzRJCPn4VDALnbl5lqF54kV9tqqjrI/mfE=
X-Received: from pgcs188.prod.google.com ([2002:a63:77c5:0:b0:b4c:5356:a130])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e083:b0:240:1e4a:64cc
 with SMTP id adf61e73a8af0-266e19e33bcmr585198637.12.1757982557184; Mon, 15
 Sep 2025 17:29:17 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:25:55 -0700
In-Reply-To: <20250821213841.3462339-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821213841.3462339-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <175798183763.622105.13979061125365252819.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SEV: Save the SEV policy if and only if LAUNCH_START succeeds
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kim Phillips <kim.phillips@amd.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 21 Aug 2025 14:38:41 -0700, Sean Christopherson wrote:
> Wait until LAUNCH_START fully succeeds to set a VM's SEV/SNP policy so
> that KVM doesn't keep a potentially stale policy.  In practice, the issue
> is benign as the policy is only used to detect if the VMSA can be
> decrypted, and the VMSA only needs to be decrypted if LAUNCH_UPDATE and
> thus LAUNCH_START succeeded.
> 
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SEV: Save the SEV policy if and only if LAUNCH_START succeeds
      https://github.com/kvm-x86/linux/commit/2f5f8fb9de09

--
https://github.com/kvm-x86/linux/tree/next

