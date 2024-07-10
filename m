Return-Path: <kvm+bounces-21273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961AC92CBD0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C3A51C21C54
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 07:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C843839F3;
	Wed, 10 Jul 2024 07:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pq6nq2ZZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC382D70
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 07:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720595913; cv=none; b=LPhec9LtKqDCyCiNrLXE0RTMNgziB6guVwaUpSsXr16iF6gDiYq/tRd8L3/sIJKylwSN0SZPr6v59jqfalbp2HDDQPKKr8tod6norA0iKtHxrliDGYLvRIUMLskEWFJqM50OYPbAFdiiHAQlvX+78U05UfxC3cVkuJhPLCaa3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720595913; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcAFiV18lzKJzEc21e8YuoVKNvSyZOS877VV0MrjxZiWCBJcG0QuKPDlfg7xTf+iA0//FB/Mg/vrl+NN8mQ5juaVC4mJgFT6UV0ueOY7yGBAnZ4ves4vukh6OsBwH2m9aX74ah9RZGk4ce7Uhv5UXJoLU5FVouH7AiL+PsMNEPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pq6nq2ZZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720595910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=Pq6nq2ZZJNPEwZYhShA80q4GugeXnVlxVrGpNAbW+P6Sssru1ZEHP2x6Tf5YVnkl5XJ+7T
	OBKJMmKU5ovh8lJsHP+x8CWmHtZc2MZB9Bucn4YKHZYDvO0vV7Nwp7nPU9pIlPW482WvcA
	QkszyYF/BoOB9D35PdqlV+WPXdpx+yI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-152-mkEJs6mUN8KoRIpFRyEmXQ-1; Wed, 10 Jul 2024 03:18:29 -0400
X-MC-Unique: mkEJs6mUN8KoRIpFRyEmXQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-426d316a96cso9709715e9.0
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720595908; x=1721200708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=hRbhvhQgy4rBE7igRpcO8eb9rD1bCJ0W/0LPHmj6GWnHhhG5LwvZvsz8owQOqXvMpI
         ztYHNEh66XhIu/SqzNoa0E5VR0o5b/K1Rg7ldJzpmcEsV8U6Axd1fdsy9Id2wvBd30co
         JYK2lBDI2vY6JrU5CtpTKqst+BWOdozcmghH/6EWMgkyo88RhSCcuOq1ueeJVeA97f6y
         mkLlkmyWV2tyYvgbQl+KQ8qsN0R+IPbV/ItXRb0kDrmvij50gzirzKxHqDYy1TxnLsdE
         FBpxeR8QfNpbbxtPF6XHIo+s8Kd6qmiKQsC4zAFeiXHtU+tpei24iU5Pwb8EYb0r2dQF
         VwcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFjWjisbaZpcwnEfLufZDTHfAbUq3HUKYsLYXasWyzk0junqy7YCbOotzT5GU8EIrxU6INfs30aXsvEEse5Sp8CFws
X-Gm-Message-State: AOJu0Yzo7GPnKe5gdyJvu0pIgImwGmvwKSjbOI0UDRr6A2zVgwcm2WJP
	P/M2Wrd+BgCF1bwBsS4DoMfc/JQBnB+DHqeZZ2mZ+Rojw+OY913pfSoBn5QcV4SlCsztTp8PRt/
	qccke2vE5tJNxMZrv+g7E+doy28v2QfnDPTUuew6wVYFrHmm8Pg==
X-Received: by 2002:a05:600c:6d8:b0:426:6822:861 with SMTP id 5b1f17b1804b1-426708f0e26mr32321395e9.36.1720595907980;
        Wed, 10 Jul 2024 00:18:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkvsi7WUjnOEoVPlLsTI9WvuyBMvHYGfg/fRiw/gzhUH6gBW3jCKdZbMMfr4J/vaeokDmH+Q==
X-Received: by 2002:a05:600c:6d8:b0:426:6822:861 with SMTP id 5b1f17b1804b1-426708f0e26mr32321345e9.36.1720595907663;
        Wed, 10 Jul 2024 00:18:27 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f68e0edsm70568655e9.0.2024.07.10.00.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 00:18:27 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] i386/sev: Don't allow automatic fallback to legacy KVM_SEV*_INIT
Date: Wed, 10 Jul 2024 09:18:24 +0200
Message-ID: <20240710071824.78372-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240710041005.83720-1-michael.roth@amd.com>
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


