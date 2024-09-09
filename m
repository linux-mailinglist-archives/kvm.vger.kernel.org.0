Return-Path: <kvm+bounces-26123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A92C3971BE2
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DB431F23717
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBAB1BB685;
	Mon,  9 Sep 2024 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UpmeDKDD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C71BA26B
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890149; cv=none; b=n41sNIwpj5xEmHpqGy2WC9PDEMi5+r0ZsUeOBN/AiYCjg9UaRzzGRqJ9gzdoYjZOOGqb+cSaQg2MaGYvY3iNeFZjZiXa/mnBk+ovGj6HuACHLd0qBANukERVH2U9ndvI52bDkxkvLNwTfkUGJluFVlduD3uflptugEU9ggdzoP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890149; c=relaxed/simple;
	bh=DBSqSKKZCT86Ns+OwHm8+kGgzIhmdP3PE7fnwZ2cnSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e1XGnnWJc46DI8j/qfcO8mG1Ime3PMyDTuVciRVuyjGeclcalbw2CIiGEtajRyiGPbKy2iarKbVgWf7RJFryB99BHiE3fgZum0GP0Z39yTTx9zyZlpCwP0G9KFsmREihWkFSsfyQE3OqPShz8nm90wLpzaEEDam4un0LyFpNgZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UpmeDKDD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725890146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phI90hKtthNRNf98RPRiQsc1bPNjYM/u78Q8gnoGCn8=;
	b=UpmeDKDDlprjtQyy1a1fYdvIWuW7FEbNlwGrcs11Dn7BGfybkfnJn31Q25Ltl+i4JBKYDm
	x2etvEh/QyfpjQB74KEF5P5Z/ulguUVs4yuHYn2SHcDebYbpd7Y7UOm9rVpRE5+kBBciik
	PAe+fUpVPiDY+v++BI03MwV+iXuX1w4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-sAIQ47nWMO-s0bBFDhKP2A-1; Mon, 09 Sep 2024 09:55:45 -0400
X-MC-Unique: sAIQ47nWMO-s0bBFDhKP2A-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6c360967e53so54945626d6.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:55:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725890145; x=1726494945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phI90hKtthNRNf98RPRiQsc1bPNjYM/u78Q8gnoGCn8=;
        b=eBQ4b+gn0ebkqMQjdFm2zHHAT1pWwzoxZq+s31pKob85xVJ5V/WFk+mHpSPSpv4hT1
         og/KISkEm8/23sNz+K/xMsn729M+FAuv8VAhROZOGnGxHTEF1jGs33ayWNeUEeXrrMPr
         OxsZF4YKfoQWH6JnXlEv+rMjoqglPPssRwM1rej07aDZkDnI7QQvp+WC3VJ67Z/HOYra
         bxMLHMHjzX7pCg2sXTn/3O4qHLsnYNWYoohHCArGo24wSjLmqw9FPin7J8OJAUFGJbe0
         otop2LtZ24VtIB5B90iC+x83iqPDbX8HMtf5xdkWzn8MSaZlo7cXMd2YaC7PrNqaVWHS
         Pk6Q==
X-Gm-Message-State: AOJu0YzYOiTe26tMK3fyNpGQyO1kzBo95BJwHQeSDmR1XGxhSnQQ00l8
	YR1EU2Tclz/Dp5MaRx49IACS9Zr4w08tHaO/Ic05kWjhWKn6HHIYAmSc0ap4cEe/gNqyBwIbyR7
	uVsU7srm1/uAkcG5RY7v94nCmigckNbC+3qd4PBBwaF6JI9n2Fw==
X-Received: by 2002:a05:6214:1843:b0:6c5:2a13:b8e1 with SMTP id 6a1803df08f44-6c52a13b9c5mr96954376d6.43.1725890145004;
        Mon, 09 Sep 2024 06:55:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQcseXYtQRpNWe4UC31AKTYj4V8OS7K7G0X+aaWgh8qtUW96w7rIdRupRfllbFa2yALO/OQg==
X-Received: by 2002:a05:6214:1843:b0:6c5:2a13:b8e1 with SMTP id 6a1803df08f44-6c52a13b9c5mr96954066d6.43.1725890144589;
        Mon, 09 Sep 2024 06:55:44 -0700 (PDT)
Received: from fedora (193-248-58-176.ftth.fr.orangecustomers.net. [193.248.58.176])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c553803dd6sm940686d6.14.2024.09.09.06.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 06:55:44 -0700 (PDT)
Date: Mon, 9 Sep 2024 15:55:39 +0200
From: Matias Ezequiel Vara Larsen <mvaralar@redhat.com>
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
Message-ID: <Zt7+W56+dKhQl7GG@fedora>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819131924.372366-13-steven.price@arm.com>

On Mon, Aug 19, 2024 at 02:19:17PM +0100, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Device mappings need to be emualted by the VMM so must be mapped shared
> with the host.
> 
Typo. s/emualted/emulated 

Matias


