Return-Path: <kvm+bounces-22678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F169414E8
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 16:56:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DF82285B50
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 567781A2548;
	Tue, 30 Jul 2024 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jec0lEoY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F995CA6B
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722351386; cv=none; b=laI+FmYmH5sf2ZKU2WihNuuC8Z4MI1MkgAlqXByQwktpDNzSqJZqyCG+xnWXdMZDsMKR0RUyRppVV8smObqBnyq8OVZabuvAo2KkGXvfrT2fjaKUxXlM7Mrj+VTDSszWTSfhh4/luKID+L5sxZAfu7/32iFul+cwf6w6rHVYV+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722351386; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD7f7oriy2ccXFa7izOnSn/PeGiop5BeuTbQZAnXZM/kWFN4cJ7My3bVOtCeKkfxY7JZh+hE3xJjQZvLJ9x+XW+L9nJebvR1+4d5VmSPvfDCYrklLZvxFiXJFvv2OTiXcduvjolTuklspzzWiVt8lbIvHMs+vTEFNkflVxGdivE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jec0lEoY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722351383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=Jec0lEoYdwpG/Mv6kIOTBLFnevgaurGC+XZMfh6Fdb7VzvW3zQYTJr2C6BsrgzWBQl3jh4
	Okv+TTS52pyLQ1llvTz1eirPYe42F5qEC1A4P2aVTB6xjihLDEB/sXmTtQRk1dxhjCIfkh
	nP19md+Q6ksFqWX6nf+9cwvkLoTk5kc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-wYZJgtdxPGeuxoMrzRsFkA-1; Tue, 30 Jul 2024 10:56:22 -0400
X-MC-Unique: wYZJgtdxPGeuxoMrzRsFkA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5a2d4fb1e73so4891517a12.2
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 07:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722351380; x=1722956180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=KljfzP9lIlj7omH+aa10z+iGLFWinRD8t4YlHsz892tLBz5QnqLkKW0wbZrTH6hZYk
         C1ITMCPLN0sF7Nud+qL1ZYJh6kz/4H4EOeWa9IOl6HR9lubJrdyyKDEHKz732fw5UqbI
         YVXJrUq1TQyITnmiNmml6XvZI+dEz8gW+xCOcusGIsF7D2z6XkrVXRGagW1sxxWZ/JPd
         X4jsA9tMGSRceXl+7Dvw4Y2PkTqp6vkSgsWGSA1tHs/AJb/7lopgKOUyMHakqv/HAosB
         y6ZNtL+LTNZ4i1pm07uWZaiIuNlrrEEP/6nuF0/K6S43yxAH6dEPZoc4lNljFwCmv2XC
         YLYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXruU4k2Dzrm3Y1SP5Um6m2dtHH2AB8qoYL12KAo6Dl+Y/IDncewPFHmue/WnFUGoXEwc7a9yfZaVqRxYi8xigLCNUG
X-Gm-Message-State: AOJu0Yxam641ouy8gahiMgfDNYHCgw19RCRjPnxByFPCf26sfThURrLX
	qtifrE5rAjhSpmnb1qJtuVX0lVp5TjsDjMuJMUndNx4xG0bkvBiq3UUK7lHtqLs8tN1+KJeYp/O
	rhR2mOPrYtF/tjuKWhZgVtL8N/kXkcIZuPyS2Br4n3SY0cyDUtjXsw00UOA==
X-Received: by 2002:a50:bb45:0:b0:5a2:597:748e with SMTP id 4fb4d7f45d1cf-5b0211908bcmr7058324a12.2.1722351380190;
        Tue, 30 Jul 2024 07:56:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzzkn0CxyMA7XirdZLScOn8lScLNigW5ihTEJ84cC/RZHY/Rsy5JfAFWsr9PCl8delBc7icA==
X-Received: by 2002:a50:bb45:0:b0:5a2:597:748e with SMTP id 4fb4d7f45d1cf-5b0211908bcmr7058307a12.2.1722351379849;
        Tue, 30 Jul 2024 07:56:19 -0700 (PDT)
Received: from avogadro.local ([151.95.101.29])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac657836f9sm7188729a12.90.2024.07.30.07.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 07:56:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] target/i386: Change unavail from u32 to u64
Date: Tue, 30 Jul 2024 16:56:12 +0200
Message-ID: <20240730145612.62437-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730082927.250180-1-xiong.y.zhang@linux.intel.com>
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


