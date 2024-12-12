Return-Path: <kvm+bounces-33610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B114C9EEF23
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 17:11:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2C2018890AE
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 16:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174E0236942;
	Thu, 12 Dec 2024 15:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChNQwghG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B4E223C79
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019083; cv=none; b=p30+jXfBIlwxlKQfG99KgwHvVcF8CIwC8ipssNTPyeBCnK7SLpJBHK9pRvVoJzUWJ3cc4o5qliqzJa3D0iYVJ1weS30LxmLftnYHoIX4aFaSfXxh1yCHxevQTLfyexFPD/HsmhGyrCtkPsT+hr/jdn+irBaMYUYRcu0AocbrHtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019083; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMR9wX0qL4GfgJ3clMfAxZH3gT64a6OYXvV1DFfQ9E2zLpqtnREXyscMpCjaC0jy1dOJIdwgeEl9QL0Y/rlQ9/Me9GAcLIPUDm0a71eT90tYXKYn7JVesa/KsvjYo+UpiMQ4cXmRMjMvDhYq5v+IDyOGkIquQxpjKQujwIANbUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChNQwghG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734019079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=ChNQwghGMmOxvOhnVcBeMl7HUhKJG+JaWggEymmf3/tVwgZx+/bTIORRTo1CsUHHji4zDW
	USmR3eVKuBehvilJ1eTvm6HyK09nIMm27jDSA3Bqq091rCCfKBNoffdAPmcMn4Rd5egc8F
	4mTTK5P65qBrhSsMMssfDQfJdf9K3ik=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-MqRagtswOuy-PPfTnblRUg-1; Thu, 12 Dec 2024 10:57:58 -0500
X-MC-Unique: MqRagtswOuy-PPfTnblRUg-1
X-Mimecast-MFC-AGG-ID: MqRagtswOuy-PPfTnblRUg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385dcadffebso375318f8f.0
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 07:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734019077; x=1734623877;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Ofnoe9omofwAo8IAGX+3873laORZyGN01BohCq2jJ3CSE0qvHX03pUyaipHKmPt2rG
         LBTuFvGcS0yVTvMqPziUO8JuZZ6etwa9WOU7XN2DxECawjUpmatEklqbPh6kDJWRDjLc
         pJqsWb7IkfimyHD+Cw9Yd3nivagttnkBbFj5aUKSwYj6Y2Na1Lq/kMa6LBVuWoCIak5G
         P/NaHO7bYh9jodHY3qB19nJa//5X/mHs2LYG1iwVuqPTqcSuaqBhBMZkHmmo8yOoxFze
         mHzRdRuw9rIq9tul+ER0wgxiea+00OzrtFIDnlXqcRWhFPXLHIepVxy7HFYGRXhazPRf
         cYCw==
X-Forwarded-Encrypted: i=1; AJvYcCUduNSKLIqoAc/1HfDtJk2eeukp5Xk4y+goc76tsxWmW5Kyu+9GOLzCScBqSZzQy7sK+Po=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJXAOSd7vQQ8KmJ5OQiZcidbsxJD7l9IBDrI80IyCfXgJKVOPM
	jLmReN+Lz6C4cbwE3aEje3lV3IAdaLnmABYrfAzSzpkaz9WuODCfreWkaBAnsS4SI9ASmkr9Rux
	goGDx5SdMLVfWIBwSmRKmZI3VUvKliZ4iboGzi+w2Gol7fSRQkQ==
X-Gm-Gg: ASbGnct15Ls4L3QnSLmHMQY5mH1abJUgwdFLppajrr2a5w1EkT292u6X30kd+hTCLJW
	+/B2JQ2nXG2TggtU7aGJhzF0RIA9PhmP4F+lOrML0lUEipN6JP29oAyCrVvFwXVgLxVwDLRWTCx
	vVxc8OtSmfpG4KixSVfVhoKK4BDRBdycYhXfb2usUe+/oivrTYpHiwMaPJnyumjtzIvtGiQxx3x
	0KAeWLDcL1r+WTZDkXfhOI9uBv4N6iaVHB7hy20pRIBTFGwt6bMOhKbukSq
X-Received: by 2002:a05:6000:4013:b0:386:3e3c:ef1 with SMTP id ffacd0b85a97d-3864cea4553mr6574617f8f.35.1734019077126;
        Thu, 12 Dec 2024 07:57:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR83C5MMeDF8fnzp4KAbDZ9IwQ9YCimFBYLAP7JHpn0+TXjU2U2saynfWppJ2/nv7QP+Warw==
X-Received: by 2002:a05:6000:4013:b0:386:3e3c:ef1 with SMTP id ffacd0b85a97d-3864cea4553mr6574608f8f.35.1734019076832;
        Thu, 12 Dec 2024 07:57:56 -0800 (PST)
Received: from [192.168.10.47] ([151.81.118.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3878251dee1sm4340989f8f.102.2024.12.12.07.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 07:57:56 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Cc: Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH] target/i386: Reset TSCs of parked vCPUs too on VM reset
Date: Thu, 12 Dec 2024 16:57:55 +0100
Message-ID: <20241212155755.524767-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <5a605a88e9a231386dc803c60f5fed9b48108139.1734014926.git.maciej.szmigiero@oracle.com>
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


