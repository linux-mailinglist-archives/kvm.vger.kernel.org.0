Return-Path: <kvm+bounces-53137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1083B0DF39
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 126CC16E31E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF1D15746F;
	Tue, 22 Jul 2025 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f0uq3hwN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171027F9
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195200; cv=none; b=ULV1hFGzXSq4hyHr6qY6qeAYElQ5LXVqYQ3j1OKY7LtQQBnVB+UDQFcXAlDf9g6MxLDMIlvHh3Z6RYtz/ocIy/6h2gKb6LyhjpT+hdw4naKNNx/Kam1kpapQUy3XcRyk88HWxsk6ctp/6trXMHMWeRyWt6yVxARzbNZoVDnkhAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195200; c=relaxed/simple;
	bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=K2dfP+reJTtKiKC5BJ8G+KGgcE1kQ53QsboKG2Aq+ffpSrzGaI7hb/l8HjoXdzrEQj0aDbzyLpMo9unlcCGOTRGxfNRKx8Se8xGV7upQZYq+SCr4JWoRqC2rJ7m7WBFUKSGxYictKp5SPxAq5JFnUwFz/9+FgXD963gJshypJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f0uq3hwN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753195196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
	b=f0uq3hwNHbR9qY9mQ3mgHO9P2CAiH2D+5h14UECcrmKDzEtEFIZoMqAPlTwYisWOIhW2E8
	2aLzqZ6GoqIuWRGYWnEnwCSEFmqT770sQlvJFi653/iIX/qcISfN/qkZbdoN3Ppx224kZR
	GLbLKpY9lh1q7GrapbYvzPhONcwnQbg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-L2PBCipgM5-hKyO4lZJOWQ-1; Tue, 22 Jul 2025 10:39:55 -0400
X-MC-Unique: L2PBCipgM5-hKyO4lZJOWQ-1
X-Mimecast-MFC-AGG-ID: L2PBCipgM5-hKyO4lZJOWQ_1753195192
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-455f79a2a16so47892885e9.2
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195192; x=1753799992;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUXfcJXt3yUtERWhIkgUGnNxGAtGAIrftLIQwcp3snI=;
        b=MTaHUC7OIsrH9dzBNDGoYDeiH270iucjZUlP8Gldap9h/O+DI4rAxy6wmtRrHayq/+
         f2GAWyfXCOUna9S+yikNKm/HB91XlnJlb6WL4mnjdFtrWAXE7Qh9Bc/bb5xSMb7xT/YV
         CYjdKjs5uVIgfVAfJc28YdhFtPEJthW/6DECE6HhxJyq7JiChRGs5e4atpan9BUoc+UU
         caa1cNYUH6hMgH1grKVxxNAbRT4u+v4g6ZTVuP9eIOIt2eoPcq4z6IWQNiiwAELrZ8Oa
         ttmEqn6OSeVGpCwr7lSTkZoW7kt41ExPB92r30nOuvpmHZwkySROcqPfbvnXJ0zl0OAl
         QQNA==
X-Forwarded-Encrypted: i=1; AJvYcCUgf46tLIdKRH630Jc0g+gzh2i2OwwVHCu0Z89lmr0Ia6SjbWnzyoyQOMnqXrPyVR2H9g4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgMUGfP03o+hwOybXHvzzL8omlLgOMed0wucTJR17ttOxCrtut
	uxQ7xpXL9DVxqis4qniNX88b731U5c/iDbOw5AQTbzwbVbV67SYk9Hh1X3eCCr5l2U5wdVcLgQj
	SsnBYxHrWNMUyXTOFrHkf/6YXm8zpITNJWKwhqcZes4sGfnz6+aiCng==
X-Gm-Gg: ASbGncvpGOpcMUPIohswq5+P7B3OL3v8rHicYxuTkBhtxTySUl2Tvsr7nYMiaDKdDTL
	TfPdWfvU4dpi5aQZVMwvZpHoKa0hLIj69ai+TQ1l8UyFFNCjcggl8gvPUsgZ4Yz4HUbf7iOBSU5
	pVYhjwDQY6A9IT3cDsA/2R99Pj9k6n23FWY5isxe8mVSRhH+SQvvdJqpz9Nd8WwAROvpBts807J
	uQ7VF89i+XWmx2wXJJvtRr1h8i9W4LzkijDjgwHGNS4VfFQDjH0aSFEbgFJD7zJ4KnnuBaEIXI6
	Vw5WOxl2lQnV6pWVJ945dosz2MVUDu2UjkjKt0aNM7RydNLh4C/sfcHAF/RtEYmde0PwKEYdMb8
	JYZxuO5nPYOnM
X-Received: by 2002:a05:600c:310b:b0:453:9b7:c214 with SMTP id 5b1f17b1804b1-4562e29c33emr210945165e9.29.1753195192083;
        Tue, 22 Jul 2025 07:39:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiFVJztAJAsGCwFkVWQjDHWa5km7SIwfTibnU0fsbIHs3oWXWzepmUGBqcNc5EYazTcDWqmA==
X-Received: by 2002:a05:600c:310b:b0:453:9b7:c214 with SMTP id 5b1f17b1804b1-4562e29c33emr210944865e9.29.1753195191605;
        Tue, 22 Jul 2025 07:39:51 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e886113sm196183095e9.23.2025.07.22.07.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 07:39:51 -0700 (PDT)
Date: Tue, 22 Jul 2025 16:39:49 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, 
    Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
    jackabt@amazon.com
Subject: Re: [PATCH] KVM: arm64: selftest: Add standalone test checking for
 KVM's own UUID
In-Reply-To: <20250721155136.892255-1-maz@kernel.org>
Message-ID: <aa2bbb09-c9bb-100e-b4dd-a3010c8458eb@redhat.com>
References: <20250721155136.892255-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Mon, 21 Jul 2025, Marc Zyngier wrote:
> Tinkering with UUIDs is a perilious task, and the KVM UUID gets
> broken at times. In order to spot this early enough, add a selftest
> that will shout if the expected value isn't found.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20250721130558.50823-1-jackabt.amazon@gmail.com

Reviewed-by: Sebastian Ott <sebott@redhat.com>


