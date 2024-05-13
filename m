Return-Path: <kvm+bounces-17316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA13D8C41CE
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26C701C22A44
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 13:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1422915218F;
	Mon, 13 May 2024 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U9z5OKlE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10D81514E5
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 13:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715606661; cv=none; b=nr2bQM5n4nTcka4+LgJxu3b1dimn2DsJhwPhA8d0uC7lJHrbK6GPQBfM8wdaaxkyItdhlTKgb7nertiJ87+OyBLyf9pDNaY+6MUoTWwXI8CU9AbVlXWmOhZc9/PkYUuihlwKTHS1a6sTOZfV5hbJr4w2IFhAio5uWMyzmxzSnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715606661; c=relaxed/simple;
	bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pei6Me0wFLVtE45R78zTxlvpMf9DSSV0Ofd4SsL6cSbkOB99BnQPv3Ylb6uc7SGfT7FS1aqGdOVthmQenS1NPL+qoiRp61VZmdXMYuLljJsEtGC7DTm/gRK+PjGIBxgBaYH5XaPqEOC3AKze7ckz0ShPcpijZnMXolfkLtee5E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U9z5OKlE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715606658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
	b=U9z5OKlEYmY/5a0ukxUaB3GJcR5kXgxv4koCCewAOM/03e7cnGQJicuLnqDVPjDNSavd3S
	fvXyk0E8l9Qc8tFYD+wYJalCpUUHzwJxkjKU19gR6mf9mNryIy4EJtnqnVY6NAFYJUFgHG
	Z5RLPHsvCx5QBg6aa6XJ0HLv3VlTMkI=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-28-znhdvkUAPce1K50qJOnPnA-1; Mon, 13 May 2024 09:24:16 -0400
X-MC-Unique: znhdvkUAPce1K50qJOnPnA-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3c9a75ea4ccso922669b6e.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 06:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715606656; x=1716211456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jWgwDMmhPr51PSrvy3HxwSLmzIln6gb49e+7ScKUKaI=;
        b=MJpIv6RiNB1ywJDoGtaGBRPmx62AZeCzTM84DQwrUsoCDiwL5Spezcgd4ZvDymLJeV
         2uj+ljpRoBVzPk1Y2zSlBlCcOfxKgrDqcTrSbM292nMcaaLBimwKpnX8fXs13g7jI5yh
         2EsdDdJ1frG64hqvHi/vZ5Pw+L3Bp+Ibeds0w25PXUQp3Jhz6ba8aXy2pYU8EffzuzH6
         FjohqmMb7OKw53sKqDTek3PrXZrhLpLokM+FKcJGDgOohdfPpfjQvehQfRbMr7ir88A1
         PLcEBpTeOsdqeDXOoqWvZcPLvEinThLwPkUGfR+6SyjjkLVfrplPfBE9IKrdojdYJZra
         Y9aw==
X-Forwarded-Encrypted: i=1; AJvYcCV38j8rGHVPDGMe5NhuM8jc2AJ5FY6acAPlveDgWkFnCHNr5fn6THCUYloEHNUTnPPDoGVl3pYuJAh+7bxsqFd3jLCW
X-Gm-Message-State: AOJu0YyqX7kzd940vHL3Uln94M5leBYL9r1Sm0AtRZ6+e753gV4HO77e
	flzaSVj6H8KM/YCAau3euvXJR7aLgUr54F7qE/bAhPkEdgAoPFJeeadM44bcefIUP8fuNu6p/HP
	AkT+Hv2Cx19T2KD/uw9wG4T199FKVEU0bLXcxDDhfYhoeftDt1A==
X-Received: by 2002:aca:230c:0:b0:3c8:4aff:649b with SMTP id 5614622812f47-3c9970cf848mr12498549b6e.41.1715606655925;
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE1SJBjApdI9h30qN1A1Ax9CGL2jjZnJns6O/3RadMVtbnCEbV/aF8/UeID/yOoTqYATTt3Gg==
X-Received: by 2002:aca:230c:0:b0:3c8:4aff:649b with SMTP id 5614622812f47-3c9970cf848mr12498521b6e.41.1715606655586;
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f203e21sm43077366d6.136.2024.05.13.06.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:24:15 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 1/7] KVM: arm64: Rename is_id_reg() to imply VM scope
Date: Mon, 13 May 2024 15:24:11 +0200
Message-ID: <20240513132411.14102-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-2-oliver.upton@linux.dev>
References: <20240502233529.1958459-2-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The naming of some of the feature ID checks is ambiguous. Rephrase the
> is_id_reg() helper to make its purpose slightly clearer.

Reviewed-by: Sebastian Ott <sebott@redhat.com>


