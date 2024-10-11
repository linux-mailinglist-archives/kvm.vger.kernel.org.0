Return-Path: <kvm+bounces-28604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DACC999F4C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DE7C1C214B7
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 08:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DD620B218;
	Fri, 11 Oct 2024 08:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iAbWGM9c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EC820ADE4
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728636712; cv=none; b=tWLIQbWYFz3nWuNqf897yaW0Y6QLky80TvF1KGvd17cKqd3+WtBd4yhAJVeNKkqITvhSWNw3e4Q7lRH/T0CWstqL4hJYQImEGf0TYxIjPVFQy27uDqmNXlZHY3l9Qh6QgOX4Ik3os2sRaiPgy/ecZiVhpPKHAjwLuFQ2oZiusJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728636712; c=relaxed/simple;
	bh=FIFiJLPgL1uHU5U3v3bfEsyjunHOCqNBXZPt9lDX0gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIRuAe55xUqdYe0MUtuC/sS5ce9FrU/fGksfMZ46YDx7Zbw3ZLVB84sx9aWaMQ41OZhyb3ktY7Fyv6zh71wCkwD66ABEAbviIXR7uNCxV440e/zlkJ1r0DI8Rsfq1olHObD0lH3wovCkN3QE3t0vUOhno4vnqo8RokXyJ3fFK+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iAbWGM9c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728636710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PYZIH1835haa67HCCPbZ8XMH65EjXy4XQri9iGj1jvY=;
	b=iAbWGM9cLITco0jMtY1CJ8hBD8s9IpO+U6xGEhRrBLhqE2fBB9AB1sIvV6+l/5lAtAwfLI
	iTgREAYdXt/lPp+H3nEZYYEgozj5FK/cMaU0ylo5g3ZW+pMmhHO4MHm6g8Z0eLpEcBLUV+
	K0T75Eg9OLjdqmL6L6TIBK8GqUXgKWU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-VSIZZDkFNluX8QWG0pHJiw-1; Fri, 11 Oct 2024 04:51:48 -0400
X-MC-Unique: VSIZZDkFNluX8QWG0pHJiw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a995056fadcso116049666b.1
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 01:51:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728636706; x=1729241506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYZIH1835haa67HCCPbZ8XMH65EjXy4XQri9iGj1jvY=;
        b=JB4qlnrcTfIpAO5jVFk0yWcDyRJPua2PzAAZ6KItDiVBbuyrjaExYFT9MN1nSqfJwZ
         yYWpdWEXobEVIMqoF1pnaS3zO+AEB3INojnG67Xvfj1ZLXv0+5//1G3jWBT8ey9mqRlz
         NzI1zuebazAwzoMz5FtiXXwTC+KndVMpVK5ESdrLPGyu1Rw0quSVuRsLNKWCj9NXp7Vk
         hdYO/pVe0Q3+hY7hofx3sbk9DtF4A+MJCajmCOGuF+6HqxKKcc0KFIyzGjY78Rgo0cNG
         9U8WRH5D9Sf1q4BFASE1lLm7b3yq06Ce+/DHC71G2gqDzbXo/S+67AIszZntIPsuAft3
         jLOA==
X-Gm-Message-State: AOJu0YxnAWtxUjPZ6RKX2WxIAWqnKhdUnMK4CIu1EyI53YrGCPyjTwAh
	qCViv9tsK/D/oQQY7DKP7qih9NtfkTTWOoEtyKO0chu0b8t7X+j869EaFsLUhM0NgbiqQ0YTArA
	tS0M6fERdx5HOZ8oJNf6rP9cadOc3XmFsjHKfmN8N+Bk6qmflc+fJoDbZfFCW
X-Received: by 2002:a17:907:96aa:b0:a99:4261:e9f7 with SMTP id a640c23a62f3a-a99b940efe8mr138335066b.39.1728636706012;
        Fri, 11 Oct 2024 01:51:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjLkR6KNnfNDTe6MGrn/erNOc00pK6j16hOkFKiGM79jmUYrioihBFa9FPpA0bo9mcFzzNrA==
X-Received: by 2002:a17:907:96aa:b0:a99:4261:e9f7 with SMTP id a640c23a62f3a-a99b940efe8mr138333166b.39.1728636705577;
        Fri, 11 Oct 2024 01:51:45 -0700 (PDT)
Received: from avogadro.local ([151.81.124.37])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a80dc687sm189074066b.147.2024.10.11.01.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 01:51:44 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Tom Dohrmann <erbse.13@gmx.de>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: Re: [PATCH] accel/kvm: check for KVM_CAP_READONLY_MEM on VM
Date: Fri, 11 Oct 2024 10:51:11 +0200
Message-ID: <20241011085110.20303-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240903062953.3926498-1-erbse.13@gmx.de>
References: 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Queued, thanks.  (Sorry about the message I have just sent with your
patch, I used the wrong script!)

Paolo


