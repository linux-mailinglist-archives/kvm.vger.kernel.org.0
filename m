Return-Path: <kvm+bounces-34532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFB9A00B47
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 16:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D99777A1984
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 15:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2EB1FAC42;
	Fri,  3 Jan 2025 15:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AZVJgi4L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5E1FA27F
	for <kvm@vger.kernel.org>; Fri,  3 Jan 2025 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735917545; cv=none; b=YR/WFSjVNUm7H+J4iWekYXxFp71iTc6MRzuo0HCN1wHqXJepHSPz7wtdXWEuPXuu+YSqmItGT4bHWSkTvF537EO2tGYm30InzntktkHupyLtrH6Uhu38RBkSxCi8B/91lJ/kcsrvEpaPcgP0N0m6RN9Fc3Fqgv3GpmU2wWjliNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735917545; c=relaxed/simple;
	bh=CGB8nJCzb5yHLiu2JB0xT5s1DN9ayx5bmIexjSS5sZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBNkpuu9VstfV7ft3dKOoycD9sJHbD6zYJnM4zMh51AJo8Z4rWp71SiBbu7Ys+K4COYN4ZuUsK9jqMzqgW4CEXgovas+fhF5EY9E6YZ35tSxkIlxKsVsy4GXOs8Byq2yxopuiN91RKGuEN9alzWv5ZjxwPO3EZC+jCLS/DIG3W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AZVJgi4L; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7b6f75f61f9so1655455885a.0
        for <kvm@vger.kernel.org>; Fri, 03 Jan 2025 07:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1735917543; x=1736522343; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CGB8nJCzb5yHLiu2JB0xT5s1DN9ayx5bmIexjSS5sZE=;
        b=AZVJgi4LFgjJiTQIAexsmTdplUM0cWXGuBu6YqQg7Iz980c0iZh9jKFmhCdv69yx7R
         OSA1IF7JVTdhaLuhamsR1j6cgm5HcPpMbML1A4zOT4LPaJoQdoMxb0cJQR0Rk/HYLgxx
         kkYwhV5gYv9uOx0gGUWOYjjZHGD9tW7vw6WMmvnPo8CvY4XAD47cBbanFAplj0NMY0hz
         fK1IY25OEu5xjZKUd7JDzTqWktBCqew5ZY7H+OR2VvSy74obzVUaEiD2QLXoSDZ/SVn2
         WuYSkTKRqjIw7dGeJC/ZIqfYOlDRhie3CcxG8ppgErfuvX2XqADNQg/4+Hg8UXXh1qNQ
         iicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735917543; x=1736522343;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGB8nJCzb5yHLiu2JB0xT5s1DN9ayx5bmIexjSS5sZE=;
        b=JLmccZl0IY+DcwyJ4PApPi9kprZ+wvEoyQPQ/fcve3TJz1nOwUh4nbXcE1Pehpv4Bp
         fURiP5EP6Zv1y/fUHzbRODWXv7Rgnlm8ywfgGgq2y4BjDZGxMfzCdPq8dBm7IZum4uMc
         KNb+0SOlVRj3D7dgZ5cw227anE6Q/vxNoiN/QPvuycfR1CaoAVRRO4wwXUE8WB0u0tID
         SuGDzRVp9EJIyw5bpMpJ7MHQIdJSKc+Azgw8OI2L2Gm5sVEibMX6vj+5AVZ/zeHz6ovq
         kWPJ+8nPmjuezSfIBJYnJLIpJbVj2eVs/qtRPBwJXeLTqvY31sb9zU0iAmguILD76KhH
         qnxA==
X-Forwarded-Encrypted: i=1; AJvYcCWpaKzRz+fEM/NFYEv9AVgDowwg2E5K1SoPHZXXBgIPVfSJNBxP6mWphigDukeA1UmUxXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwgxxTFi+PC5IAkGBk0TK+rvJG7cQ9nUlZfZ4mSuosxEDCWfOfU
	ST6JSNGL2/ZW3DdJBIhaBCiaCmSghsdx0BQTl4sEag6aioIfU22g6RfflelFat8=
X-Gm-Gg: ASbGncstrXXIPkNi4PXtZUR5xnfIZzNf5UAluTkId4DYm1obqUkC4ZhY/mJhUgdUQ/9
	tH1vDrrabri9mZnFQtl2lneieVmHQEWW4BibeCpKxSiu+VvPmEg/nwCPPNIhso3nlUFUyLrKUSr
	WtvlPJ8vgZFGJ78vSNfl7Dp4d6yebTF15Fg3QrSL5J4ubLxmykVzhTu7a3/O7sdJPLDxHqtlYhk
	XtdoDE0e7yejbm6rWn9zLqkHi4448xNgBRWO7sQxk1XhTGG6HBtdtS4LOSQ9/8pGrFj7z79ekZQ
	+IhzwX/5wkManOF5I/ntYvZn49Ur7g==
X-Google-Smtp-Source: AGHT+IHTG+Bq32SHg17tHpm9vXIkHAkuaGHUCVV1avASRsb7eSYGQtc9W1/GwgW3NuW7igfw1fFU3w==
X-Received: by 2002:a05:620a:488a:b0:7b6:d5cb:43a9 with SMTP id af79cd13be357-7b9ba773db8mr7230744485a.23.1735917542951;
        Fri, 03 Jan 2025 07:19:02 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac478f0fsm1277723385a.71.2025.01.03.07.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 07:19:01 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tTjS0-00000000iwx-2edn;
	Fri, 03 Jan 2025 11:19:00 -0400
Date: Fri, 3 Jan 2025 11:19:00 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
	quic_bqiang@quicinc.com, kvalo@kernel.org, prestwoj@gmail.com,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	iommu@lists.linux.dev, kernel@quicinc.com,
	johannes@sipsolutions.net, jtornosm@redhat.com
Subject: Re: [PATCH RFC/RFT] vfio/pci: Create feature to disable MSI
 virtualization
Message-ID: <20250103151900.GE26854@ziepe.ca>
References: <adcb785e-4dc7-4c4a-b341-d53b72e13467@gmail.com>
 <20240812170014.1583783-1-alex.williamson@redhat.com>
 <20240813163053.GK1985367@ziepe.ca>
 <87r0aspby6.ffs@tglx>
 <03fdfde8dc05ecce1f1edececf0800d8cb919ac1.camel@infradead.org>
 <20250103143138.GC26854@ziepe.ca>
 <432d4304b579c5bd6973628c3c4aaad476627f7b.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <432d4304b579c5bd6973628c3c4aaad476627f7b.camel@infradead.org>

On Fri, Jan 03, 2025 at 02:47:11PM +0000, David Woodhouse wrote:

> Probably best for the hypervisor to have some way to *advertise* that
> it's handling this though, as guests also might want to run on
> hypervisors which don't.

If the hypervisor doesn't properly virtualize the device it shouldn't
assign it to a VM to start with :\

Intel looked at the question of advertising clean interrupt remapping
when trying to virtualize IMS and it didn't seem so great.

Bare metal machines need to work, so any test they could think of
adding would either fail on bare metal or fail on existing VMs.

VMM's have taken the approach of not telling the guest they are in VMs
and then also not implementing the bare metal HW behaviors with full
fidelity. So we have no way to discover that the VMM is, in fact,
emulating broken "hw".

Thus we get this push that all kernels need to accomodate the worst
VMM behaviors :(

Jason

