Return-Path: <kvm+bounces-62139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 665A5C38820
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 01:42:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 936C34EC2D5
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 00:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43741DC985;
	Thu,  6 Nov 2025 00:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jxYZZLVR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF791AF0BB
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 00:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762389727; cv=none; b=BCMYCoYVOfICkIl1O8SKLSdHL6K5JwFknax1vZly9J6doK8zPB5KqpK8j+vvjatGUf0OYlE94AeI+BQMeyYiHrbkgBwJgttwxDvaB8prMGXJ0lDbeFI+kjGI38yMnA7KfiK3SGGc4ldMkKxJcUokrudpDLkNVqsWOLW2VFrkToI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762389727; c=relaxed/simple;
	bh=IlSwVwT1VuvzUynUU4Xj+hFZKWXPHeFJ1t0CgyLYuU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RkfMEZqyQjizJVzdEEFbO02lVkY6ysWMUafWfESntuLOFdXRgphNzU3bQBX7H6Gzv1NMbJrWWf/UU4T6JWV6Py9VaLjtA8GnDbdTOKYW61ZqLc/jISzTHS93TCjcvssvlKs0N0dhuUN7D7XWm+/cCsSDziayWfxk70aZCUtPR5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jxYZZLVR; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso284021a12.3
        for <kvm@vger.kernel.org>; Wed, 05 Nov 2025 16:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762389723; x=1762994523; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlSwVwT1VuvzUynUU4Xj+hFZKWXPHeFJ1t0CgyLYuU8=;
        b=jxYZZLVRmKD+A/1jnQUWCe+E+/WBS48P+l5h9b7jghDKwZkyINezQhB/k2bxPDpl2A
         ueM92wOHyvjh/Hf0zfaU99gs/2RwMuGhoEvXSQ2uUXqEv/cE0GuVzlI41baY7+kh1nRR
         Oq4xQfi8Y+4tmuvyxE2CFmilTWQdV2ERTMjT13C6fitbHMYjcRxJaxb8S3YkbOGN97/R
         uEnV1gZjzqeRECL8sbVabcpLstDsGeOW3i1abup15/srQikrAyoChfJ7GCV4qntBtMTq
         /4Uc7sIXMkTMW1m8BYzIv/HvzUN9/0CY19+KqNr+eDWoK3MyinE1x3Xh8kI+pI/QGhDd
         gEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762389723; x=1762994523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlSwVwT1VuvzUynUU4Xj+hFZKWXPHeFJ1t0CgyLYuU8=;
        b=o4cUdZgAm/p34iOWFPBDp1QRLKewbIWaG6HFKeG0+ujjaTVboM2goG6zqqYnMRqtGH
         8bjy3nw7R3CYjt7utAFj04dLjctnmR/oMGrj3vQArLNjKF3HIU9YUVIlEISfzVegOmjx
         drD6CagxlJ36kK31awx5mAxuIu2fCTSVB+YcEy9vmfLmoerEzr9X548LFCY8jw9esrh0
         /mV67XvKDXZVPb3Qb201ve3x+pVJGtMW27UmmPK4KkxwQ7uBH8FN3nyOS0QN5JlWzaBs
         OHIza/o7Uou4LssgY74YzWBXVT6t0/IzLJhJgWumBge00LFMU94JwCoHiIRMWAeH72h7
         oekA==
X-Forwarded-Encrypted: i=1; AJvYcCX78CAi1iI0eqPkchRZKyv7Y0XnZbLlHNkWc0pqDjIsG9jlVG6qNU3rMVOLG3Kp3+V5LrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0i0yi9dwdhtjTKpb5cvTee8eilfJYupj5QkQwv4XXxxDMmiCt
	hyitQgFxKAL0+yJKRTUkMwj1qlLAMj2KeH7RlbBzEQVWkLFSY/TpwjtQ/yi9ZHWjfA==
X-Gm-Gg: ASbGncu5xeOElb1l5kItwNBzRwES2EGwGV8usZmKAD9iV9ZEBrxeZj1jmG0nQN1pXTb
	G8aFl5ErCuM0Thz151m3My0xhsD+HOt5htJQddd+N9L0SgQMzkNPbdPJwg+QjSvuC2Y7qL2rep0
	eXi5Z3zXuBK0l4bU6gLZohv15zoc5kXBkkjk5PR11yGoGEkpxSB0xGYTAZD3eYD8jVnRDk46PyL
	6ov57nUTC7cqc0HFxK2+wCMbkVU/3ZmU+wmrCWid7hWabIAcDmiaw5W2WPMjiow4e/AZoxE+XYO
	F6Cvth6H1Xbq3/C78/Y2QoS8yjqd3GPKYc9ii7AF2pku3R0FfHDHbZDBBmzlm69JSMTLjg3js4n
	iYo1CWiXAkd3auhrLjdOK9acIhSb79hTzf+7Fskev5D5AmMyObZWN7s/kAlgEJga8cDp2l5NKWj
	pkNvfIMZB0ETC6TmJ5zYBu+Pm27JT+EbByT3ePG6vUSP/TlK2itWin
X-Google-Smtp-Source: AGHT+IH41on4jpXBOi5c2bKsIC6xn61T+UyJ69pWDeAn3RI973fXQ7iyPYS01mgsWNu4I+diNqvKWQ==
X-Received: by 2002:a05:6a20:3d11:b0:33e:eb7a:4476 with SMTP id adf61e73a8af0-34f84dfc120mr6673105637.23.1762389722735;
        Wed, 05 Nov 2025 16:42:02 -0800 (PST)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba8f8e750c1sm539201a12.1.2025.11.05.16.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 16:42:01 -0800 (PST)
Date: Thu, 6 Nov 2025 00:41:57 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: selftests: Export vfio_pci_device functions
Message-ID: <aQvu1c8Hb8i-JxXd@google.com>
References: <20251104003536.3601931-1-rananta@google.com>
 <20251104003536.3601931-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104003536.3601931-3-rananta@google.com>

On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> Refactor and make the functions called under device initialization
> public. A later patch adds a test that calls these functions to validate
> the UAPI of SR-IOV devices. Opportunistically, to test the success
> and failure cases of the UAPI, split the functions dealing with
> VFIO_GROUP_GET_DEVICE_FD and VFIO_DEVICE_BIND_IOMMUFD into a core
> function and another one that asserts the ioctl. The former will be
> used for testing the SR-IOV UAPI, hence only export these.

I have a series that separates the IOMMU initialization and fields from
struct vfio_pci_device. I suspect that will make what you are trying to
do a lot easier.

https://lore.kernel.org/kvm/20251008232531.1152035-1-dmatlack@google.com/

Can you take a look at it and see if it would simplifying things for
you? Reviews would be very appreciated if so :)

