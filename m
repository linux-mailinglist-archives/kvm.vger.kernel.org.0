Return-Path: <kvm+bounces-58029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C73B85E9D
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF1A41893DDD
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 16:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B68D4315D2F;
	Thu, 18 Sep 2025 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aj/CYEPv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57444314D28
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211602; cv=none; b=teoTohjXrFRfCZoqcMvjRDv0si8IflOxUvWQ0z7TyWnVm+GG0pBecLIl0rZlvof/kLtb/TeMkg+61khH288dVAyb8RZgTH8XzLXmf+Y4wJL2SS5A8dvX12wbA0AbJKblbHVoQWKw4TH1SfvjdJm9c1WdyLq75kSh/vfL8CKRaTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211602; c=relaxed/simple;
	bh=P+Wmf0yqfouH3Oi06gJJiikblIWfpXgZcHs/2usguFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZFK7PGye6EdomuJ26g0KGtHE2Gkpz+CoACEpuli+yN8vH9/eTZdMBCJkHLMeC1jyMmobgXPWYc5H2WYNRkgAs6z4dF5nZQWTYCjhJo/0BxyENNTWCZIgm/vlLwZDrSwaN7kRzj6bnIrUlJ+07Y4uTk3m311KD+OSLfnqQiSVp70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aj/CYEPv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758211600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T/W5lCTYIz1tvKkOImL2aA/ps1g+KzlVk0fBujrhKzM=;
	b=aj/CYEPvfqMUrNIYGNd7qD4zFMGyIT3ZnydDRg3DekyckBkkxGhfeERgfUKw4uIMUpfYLe
	1wBAjrt5W0QLAFwpdOkXmXYVSODexXsinPYaqzDpTk8IEooZES5vv0qvwHL2RduQGtXjRA
	XpcDzYjm8Gd3E0u2fjNTdkZbTiJdC10=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-AasyzzAlN_qAWWkt3Hmdjg-1; Thu, 18 Sep 2025 12:06:36 -0400
X-MC-Unique: AasyzzAlN_qAWWkt3Hmdjg-1
X-Mimecast-MFC-AGG-ID: AasyzzAlN_qAWWkt3Hmdjg_1758211595
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so692037f8f.2
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 09:06:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758211595; x=1758816395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/W5lCTYIz1tvKkOImL2aA/ps1g+KzlVk0fBujrhKzM=;
        b=oDL6/uL3ZyhBTnx7TO311INTYVVSARIMCTTE72PVrfUY8x/hoLMIXy1UbeXJE+G6kE
         oOtzNUYkldm5AVirgPWTO3FjnfXu7d61V3TARANG12/6VVWw+P8hYi1s6O+Xb09BaiFf
         5mRSdm4gDCwfES9B9RVQlk140WULX24Y9KISAQNbuX+8evwGkWoFXIFqb1k0m1vFd93g
         y9E8K6x6IOrezhJAXAL6KgA0ZG+Sg8ASwzCH/tFsQjXb7bRP6s+EcJQyNYseTUlFVGxg
         RFPsehxvXFxMUjTFOfUnnd8zbWUxAIkRiZAQYjd//YILQrGDfZ1XIS3d9fPc19ghHW6F
         nc9A==
X-Forwarded-Encrypted: i=1; AJvYcCVnpOjwpKICI4ZzEejH/eAEO74g8qd0rr3buUq4l+0o9UR8nPVv89pFnjQsATqwny5dC4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YynNX8+Gh+6dvRta57hmPXjxbKA2+1mRvsbbk6Rd++5xyNiXx2q
	ltWNsSLpxEEFilNNi39I/pGZwpmcirDrmYQW964hrjXSiqcPXAoL1O92/T9+BglYH1hH3AbiGJJ
	O9BFGrtEQgjWbzHUloCCG+aZ41WccE/cMtMoVJPwPkZ4ZsE1Smu0Iqg==
X-Gm-Gg: ASbGnctauMm5b0+8SPwg+M4L6kDz8yL8/qwQ5qAcEpKHkTvSVCcdvFGK38PX/S83PNb
	rL6K3onBv4LmHTD2485CdOxn9OP3npf6Am58jh453WN+rP3krxVDg2BncT/Q0+ae3CZGDSMC+z+
	26IGXlhF3o/7FrPkXRYPcIpHI6Qnz2KQyyBHpJ7EmbTWFaMs3GFI489iLxLzVr7gb7Erc8y85Tt
	2VwxuK7Iu/BezIX6g0BmVvPBmOQ9ElHZdAD29j8IwqMhXdX2TpPLo9IdumE0iGdEePJVnPKCjVS
	aPynWh0oJ0APu3+IrRgO2cxltxHM6djz4LE=
X-Received: by 2002:a05:6000:2881:b0:3ec:df2b:14ff with SMTP id ffacd0b85a97d-3ecdfa14161mr6207937f8f.40.1758211595340;
        Thu, 18 Sep 2025 09:06:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk3vFxLumDhq+BR9Bo4nIsWcXRAcKMyNyvcVzS+eyg8tV4+vQBxrdk3o5AQ7UyoiyFo7QtNw==
X-Received: by 2002:a05:6000:2881:b0:3ec:df2b:14ff with SMTP id ffacd0b85a97d-3ecdfa14161mr6207900f8f.40.1758211594963;
        Thu, 18 Sep 2025 09:06:34 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7300sm4062735f8f.34.2025.09.18.09.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 09:06:34 -0700 (PDT)
Date: Thu, 18 Sep 2025 12:06:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250918120607-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918154826.oUc0cW0Y@linutronix.de>

On Thu, Sep 18, 2025 at 05:48:26PM +0200, Sebastian Andrzej Siewior wrote:
> On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> > So how about switching to this approach then?
> > Instead of piling up fixes like we seem to do now ...
> > Sean?
> 
> Since I am in To: here. You want me to resent my diff as a proper patch?
> 
> Sebastian

Yes please, if Sean can ack it.

-- 
MST


