Return-Path: <kvm+bounces-64618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 027B9C88628
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 53599351276
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB3E31B82E;
	Wed, 26 Nov 2025 07:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzRSS7oI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBNTWf+F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BA728DB71
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 07:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764141329; cv=none; b=D3/EqOMga7bqwQF3xrcypRMxaMlAHaMpleznNw6xHh/6nDu8Bojaz8J5akkWYtfm9TYYH+CnKP040RWp382eaBZqcMhOXAdFtZVQPD5M0lRGRwbbaVuaSIVw75dPM1SpMfGWr4tbXzmCCiFSviJ615ihq0/FjuUR/GJPif6Mii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764141329; c=relaxed/simple;
	bh=mkf/uHCKMjQSjVKT+d3VdATYkS+teAGvnv+BKYIEsOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWENWTh4OaEAWKXEHC1GEJSQgl0lMCfG5RlCn68FN0fyLK8UXEpQwPrmxYzT1eStPFEkFdnFzicIjyCqjHMkL2bGx0XLcRkvpeRVxcrt83U3Dtybq49RyGSZrseMXg1nfqLXM2Q3W3kEYVVueSFbXHztwWJSjR7CcZTF2oSipcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LzRSS7oI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBNTWf+F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764141327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TCcjoQrJmDMV6tt4i7nrzjlVcToLbxZK4bwTpqKMBw4=;
	b=LzRSS7oICTLHZTzTq0JW3zIcly1w8BkPUSu+XF8w+qbj/+9/D9AlH6qWbZ4mz375ShPOru
	iLDev0fhY7Ubt1NJloKVm/QOIBBq4xRjUr5Js90gQ81thvawywSwtuKCADsrQf4YO+d1/q
	47103FYCtuwze69cYx6mbOCDfZO0b/k=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-Puw_KfqRMUqMFs0DqP6IOg-1; Wed, 26 Nov 2025 02:15:22 -0500
X-MC-Unique: Puw_KfqRMUqMFs0DqP6IOg-1
X-Mimecast-MFC-AGG-ID: Puw_KfqRMUqMFs0DqP6IOg_1764141321
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-429ca3e7245so3098933f8f.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 23:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764141321; x=1764746121; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TCcjoQrJmDMV6tt4i7nrzjlVcToLbxZK4bwTpqKMBw4=;
        b=aBNTWf+FRh9H73ynMEQPJvV4QlzwEYW+cZkwLPE8t+Jjhz6WVAiemC8nNTesfDbKnQ
         b3vWRUNDsmsRIP5ztUGUx4Qb6FS5JOisofV4BYvVNLONmdqkntT7crOVU4VGauf6ZMNc
         NNCozMQg3Xys1W9jiXR3e9fGDJag9KA0TdtDmkWw9xnV1uxpxCp2+NKsiX8+Jq72eXAD
         KT29gGwoSGuatF4lv0fCqbY8cJqS9CECFe3jvg71sb4V3KcYDPK07/NK+FSmPCURRRko
         XG6muxEWW5kSYExyDXF2JrawtbngLdZPU15qlWAWNuEq5eoBzqqakCmUGX9zpKII/Ece
         pzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764141321; x=1764746121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCcjoQrJmDMV6tt4i7nrzjlVcToLbxZK4bwTpqKMBw4=;
        b=pkJc9co3d3gVHgEVJ72nRpE3l9o6tMbsoVtfEH4C64jwE5+RklgTS1bdH7Cp0InBkr
         xE9Ukv8JNuqOLVPTbWLdiEOpHGEzw+qqOGfdn+j1aJ32xnOVf69AfxVKRMRabEAgDOB3
         os5iaDQ0W+igP5BE5ZnigeRtuszS2Sb68yY1LV8XRpmLpeGWs1+66DDHSBDnqK/gah/T
         UuwvkQ6YN1KIrMCse2W0scLPBpDn16GjqEsI5rI5O1uEGPIVGAF9bwFdiSbYAP6jrTWh
         0iJ8/YSizzJrVBd8DR6cTHCVOTo49L6G1xtjH+8f5uznjJVa4gcGPIvoG44Dj2bSFTGW
         uG2g==
X-Forwarded-Encrypted: i=1; AJvYcCWgsUhA4VVSc2wL/AieBGXUf3a9hXQd/KJ6WcyEOulVzTAieMvUsXKEB9y/hwkTqt3q85Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzey712QEJtMmZT7tAZiMGD74252v4vhBt2dGuRNRt+X+9JlRUh
	MWUXGhyXpIIL4eVr+e9NtyRIbj9e5bSAWxZS5xd8xoQPQ3D91dnfj/7SoFqmHrc2u1bylft/R6b
	Vf0h2PwMXRyHeADtKYf+zLRmG0SzDR5oYqPDPSNdvY+da+9fO7xiZUw==
X-Gm-Gg: ASbGncuYds2r7fUOxSeIAa0R4nrgRvCND2b2ySd+KBsYAB2epn93NBlWBoxUWVrw97a
	gKJkdvCvJVElPnvyVv4vPVFpzMdekfOhw0aqWxGp8VUwvl0AcXMOX3GJYTaxkX8USJz4iil97ct
	lmaoIQ9tDmMC4ADdfhwzRD3vU7ce/AVtM0C8D3juwKGGZWQuwwwSqBIjMgcqtVZtbRnSOzIZ1cB
	q1Q3LuuG8UIeWUhbnc0sO6TZVicRp4HFg+8vwCXjZ97zisllBCcy7pUJA2NSOz3C7W/FlDuLwRh
	ZHK9tlZraYrjdHNK8Ee/whseDFt6DN9NEVmdn23I8T3Di9YWxeORcrXKfnlgMIcbpMVoF2HJQCV
	BEZ+z/cQPEChDCqXi8kiPN+RExR/ZXQ==
X-Received: by 2002:a05:6000:40e0:b0:42b:4081:ccec with SMTP id ffacd0b85a97d-42cc1cbd1b9mr17399189f8f.18.1764141320711;
        Tue, 25 Nov 2025 23:15:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFxNo/Afpg3Lg6XEk3Ct+TLvZVCI8wWmYfzMD7t72pHQNYX6jVKGgWygBu70JI/2p3ZTBPPRg==
X-Received: by 2002:a05:6000:40e0:b0:42b:4081:ccec with SMTP id ffacd0b85a97d-42cc1cbd1b9mr17399153f8f.18.1764141320200;
        Tue, 25 Nov 2025 23:15:20 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f363c0sm39412154f8f.18.2025.11.25.23.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 23:15:19 -0800 (PST)
Date: Wed, 26 Nov 2025 02:15:16 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v6 0/8] tun/tap & vhost-net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20251126021327-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <CACGkMEuboys8sCJFUTGxHUeouPFnVqVLGQBefvmxYDe4ooLfLg@mail.gmail.com>
 <b9fff8e1-fb96-4b1f-9767-9d89adf31060@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9fff8e1-fb96-4b1f-9767-9d89adf31060@tu-dortmund.de>

On Fri, Nov 21, 2025 at 10:22:54AM +0100, Simon Schippers wrote:
> I agree, but I really would like to reduce the buffer bloat caused by the
> default 500 TUN / 1000 TAP packet queue without losing performance.

that default is part of the userspace API and can't be changed.
just change whatever userspace is creating your device.

-- 
MST


