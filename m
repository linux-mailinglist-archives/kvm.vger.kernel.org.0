Return-Path: <kvm+bounces-17318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E5AF8C41F4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 15:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E38341F23A2D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 13:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE6D153561;
	Mon, 13 May 2024 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FxDrX0bH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3251152DF7
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715607074; cv=none; b=gWmtwMCdJjoKACOL8GLjF2wpwLx4BE2JBDdhAFyaPjtHXGNnLPOZh9jKwRvQVtOa8HS3V/IJLs8QKB1hKbruKVaLiLH8V85BAC3Db5A5Fx4NVbAkwouJtq++WRRsuU9muyCicDnPXQiCpIg9DZH7n0wck1oPF+td7npTkXY7saQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715607074; c=relaxed/simple;
	bh=Fqm2Gp4Ea2AnXbueV/ZqoPCx8y1qciRzdl8bP0tCGxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2Mlh5du5EPnVzA15LUd8bNMq2Qb0+hHwfnazzJQcsksjluy5U+eqGB6en0xYfF9cHdRZg1WiKNiD7m6dojiPZ1UK+PU8N3I6MjoTyU8ElOvq8RwsupB+fMcjpJfs5Sm9K0O7QVEh2LL+2ljkmnSpmNQkWu4PJ1Uy9kzcRZtP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FxDrX0bH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715607071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiIb+3nFVswBrkEwxMPkqHn0y0Q1J4bxwK2n9xhUWW8=;
	b=FxDrX0bHTltCfYE65mZj8EUwRTX2MT3nFoz3C8Ht/rBB0uDYyRZl9l9fv4aetSTPBt0JAB
	BaTwI9RBdj18Pgg2QYSwLof65dDyH50T91qJTyp+21nSSA9POCLQ0OHvoBjAPChWgboW+7
	3qX6RrDJ5/vmargL2CWeLZpsBSEceWg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-ohwxMj59NRWvpHydWe0djQ-1; Mon, 13 May 2024 09:31:09 -0400
X-MC-Unique: ohwxMj59NRWvpHydWe0djQ-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-792ba069a97so650405285a.0
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 06:31:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715607069; x=1716211869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oiIb+3nFVswBrkEwxMPkqHn0y0Q1J4bxwK2n9xhUWW8=;
        b=I57o9NA0P+eZ0T+Cx2icO+OfRz7j4YhXbfGmRZihJf3EMnoTqag9hC33xfZpPmcgSu
         BKzHShob8xXbM7o51aDmCjdX3GGQYkYGPyuyq0XuPfKQPWLdZRel0Sf2obhrxzTFCYRI
         FrKBdl1iNwJnLelhJ2a0VGp3lFC8+q7z6xx8HrcVkpfnKiOkAYfiR1CR+qleGcIm5a3P
         GTOr4v5NfBztdB4dQaP+Jeu8rya0PFRjgdakCcYjgzVcgQrKQFGfCXMpdrs4KTyW/nJ0
         6rc2cQwiEWMjtSIAIpRDf57fFMeda731ky6zOa2AZHREJFMdwSaGH5QLgfZ6ZKmpZE45
         fbcw==
X-Forwarded-Encrypted: i=1; AJvYcCV7eKUEcovwZ4cTwXcK2jS128gC2D+7Kr4/JAsXppxYhizCoCnFpgeIZPFhxV/i5Oa7MPPBwZ8HjBC4H1l8h1TxS6c/
X-Gm-Message-State: AOJu0YyKHY/wxLE29/a4rJVtnLDUuU5NPDwbY4RpqiEulHDZSuREXMvd
	cmtusXaCOuV9LshacNI3q6I8lMkjSKqnrM4Finhivo6nG9BOCL9oaAlETEQt8U/YCdc+5p/+zrG
	ZT2cWlv5LrhyOjWaO1+IxFxRr6LU6slTQWeeN5R0zZ4CsVwAz9Q==
X-Received: by 2002:a05:620a:100b:b0:792:c32f:caf0 with SMTP id af79cd13be357-792c7600c34mr1006623585a.70.1715607069147;
        Mon, 13 May 2024 06:31:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpj8HOhXADrX5aLoJtT9KExs3Lc5Cv2uyawKonMctLWoub/CtUpkqTjUxSYvXa9xO8aQIf7A==
X-Received: by 2002:a05:620a:100b:b0:792:c32f:caf0 with SMTP id af79cd13be357-792c7600c34mr1006621385a.70.1715607068752;
        Mon, 13 May 2024 06:31:08 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792e3a40492sm59551785a.86.2024.05.13.06.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 May 2024 06:31:08 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: oliver.upton@linux.dev
Cc: james.morse@arm.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH 3/7] KVM: arm64: Only reset vCPU-scoped feature ID regs once
Date: Mon, 13 May 2024 15:31:04 +0200
Message-ID: <20240513133104.14444-1-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240502233529.1958459-4-oliver.upton@linux.dev>
References: <20240502233529.1958459-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The general expecation with feature ID registers is that they're 'reset'
              ^
              expectation

> exactly once by KVM for the lifetime of a vCPU/VM, such that any
> userspace changes to the CPU features / identity are honored after a
> vCPU gets reset (e.g. PSCI_ON).
>
> KVM handles what it calls VM-scoped feature ID registers correctly, but
> feature ID registers local to a vCPU (CLIDR_EL1, MPIDR_EL1) get wiped
> after every reset. What's especially concerning is that a
> potentially-changing MPIDR_EL1 breaks MPIDR compression for indexing
> mpidr_data, as the mask of useful bits to build the index could change.
>
> This is absolutely no good. Avoid resetting vCPU feature ID registers
> more than once.

Reviewed-by: Sebastian Ott <sebott@redhat.com>


