Return-Path: <kvm+bounces-25880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2E896BBFB
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:23:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2836D282CF9
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 12:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2B81D88C0;
	Wed,  4 Sep 2024 12:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ly40wk/k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF081D5893
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 12:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725452580; cv=none; b=QeR9yFHCFBDpI0JNzHG2Gf7SBNRAsm7D69eKL/3ERwJfnRWHSM6UAKDFw2EwoeKD0OWh7nAtGyPx59njcXXLEodMmwtONTN6LId/b9hvt7/r4NinM0xeC+K2kGqZEwCUwdhvnzxvBHFhML91SqLvKvuGp2hsgIp0Q4fyjTy9JYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725452580; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FA9YhVWoEdBdW9DByetmAZJ9bOkl3kCh5yJsP4/AE2BT7E/+dPRU7OXr8uVVmbh0nxXnaq+Lhmm8CUGaiv7t0nZjaU808TLIsRZ/EUkMOIk0IOwTu/gX6x0qtbRmXIPrjSYHj8FhBUzb1xmile9XwHXwuxarmsb35n02aBeAq8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ly40wk/k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725452577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=Ly40wk/kjYB2YC71PbPwsJ7sspUMBcfX4jW55+9Zxcyik6Ik1Tq8Q64eCyrs/2F5hjrFbv
	mEvL2+83pjiFPjIL7VBXp3e2xUo7CxW+kaJfvpmHlhdph3gZ+3nHOd2KB/nlj5m+Y1Xz1z
	mh2+zEbjKE9WjpddQY8O//G2AZ5nnPs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-t6A2ZthgPhy9DxxcNiWdCg-1; Wed, 04 Sep 2024 08:22:56 -0400
X-MC-Unique: t6A2ZthgPhy9DxxcNiWdCg-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5334e41c3acso6449492e87.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 05:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725452575; x=1726057375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=N9AIzWrLXHG3dJj1pVB4DjrqjCW6uYa+8qR9mgMZhfPd8Sgqb/3sUUjCBVxV7Dq0mb
         Yce5EOosmh7KyPECmwpxBveXMylgYqR/SrfGvv3YJ6vbkDFHPYCJL4BcE0XF8P/i0AvT
         pLdcGFhKmeaaq06tGvc2HVF+nhgmtHWmttb8CettzYeKtf9TSWeqU6CaF1cFL1jf7bVT
         F2GFjNieStPWzTg8UBHMSJYRx1ViQUbo25Oty2YRgFYSU1dap6kAfrtVDU3vtfZQASnO
         qs28pgJCBOaRtEdY1wn4zoJfPV2spyKPMNau9+IS+7k/oeFA5o29g4W2sT9z142ykbv/
         wuig==
X-Forwarded-Encrypted: i=1; AJvYcCXkgnkP7Y5zcLQqLNGknBgiILPNSrR3YWjFYnd3I8GlEmaDWYgqQIBaFnC51WABvN4EkGM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNaVYQL9nI658Yq2TwD1/UulXvYXizEy804MYtKcGqHDQOk5PG
	S67Ze0UHrKd6jBgtZgQ8cX09HkeEolgfWj7a1jhfa9hMDpzYO3Dj0iBrfo7xkBN1go1g05UNeUQ
	Ao0CCsNAKNBTwnlg6y0U0TzymospbqLo+XZxExcdghntL6mf/4A==
X-Received: by 2002:a05:6512:1394:b0:533:45dc:d2f0 with SMTP id 2adb3069b0e04-53546b931c8mr12244906e87.46.1725452574924;
        Wed, 04 Sep 2024 05:22:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+Em0B4WQdVj+ndnKwa/MbfNw8FPzXnZlE20GbqZw5nEF0AYhy1vnhNsCfI1VGJOe2LODBcA==
X-Received: by 2002:a05:6512:1394:b0:533:45dc:d2f0 with SMTP id 2adb3069b0e04-53546b931c8mr12244886e87.46.1725452574413;
        Wed, 04 Sep 2024 05:22:54 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898922295csm798832966b.198.2024.09.04.05.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 05:22:53 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: qemu-trivial@nongnu.org,
	zhao1.liu@intel.com,
	armbru@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH v6] kvm: replace fprintf with error_report()/printf() in kvm_init()
Date: Wed,  4 Sep 2024 14:22:53 +0200
Message-ID: <20240904122253.281351-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240828124539.62672-1-anisinha@redhat.com>
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


