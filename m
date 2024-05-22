Return-Path: <kvm+bounces-17945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 796518CBDA4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:20:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1737C1F2321D
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 727C480C07;
	Wed, 22 May 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LeBYgo47"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D86770FB
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 09:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716369624; cv=none; b=a/lXWL0OUgWvgjJY1l542CWl1iH688yK2fPqNhC5DVEpHRUQd6re1+RRA72B57vrb2qPyh4EUu+n11FBt+xIZcmVUcEfx52IvQ8HltorosYCkjraleXw+o0LsT0jUcBmWRSgFs0w3WHg88XrZkndPhldXx7nAwn+7L4t2Zv8b04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716369624; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFPny4CgfOcm8M0rrUmmpd9C8Xw4Jd/DHAxMPdKPQOVP+7pyL1g1PKE2BsWE31bixZOpQ7jo+PkO5gPVWygsrMbgCVTVe75ot/9TwQfOUP8faC6W799x8tIH8Q5WTb7EOLoSRIY0RbFgoimRN7Nekx5MGgTvKFUIiNnPWpG4gYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LeBYgo47; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716369621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=LeBYgo4734Rgiu49q2rzGz04efm/b8owVNM1XcF37inJKyNBDOI2wJsXyJHB7XAMj6vbev
	RV7AG8X5IyRaAbJHp3/zEJrBlpEgDLV7z/Bo5PEprd7KdtAqttZMN1obXX/lbm/ohlFd11
	QWB7LRgJPtZJo6MlyZczCYFuz5J2UVA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-N-rg7_BiOAyjvKq83MEFOQ-1; Wed, 22 May 2024 05:20:20 -0400
X-MC-Unique: N-rg7_BiOAyjvKq83MEFOQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a59eea00cafso54398666b.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716369619; x=1716974419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Je7ey5OkD6UIawPEJ0MAMYyK1bxmAHtDoPSxrSwZRBUvXJ1jLpypZCTpTblsD8KNUm
         RXw6NTupCN98gyjNfHV1HFALlWi56AoKGmKH2lnBjvkPBn2kFuHBjp9KUhdThEpYR/kr
         auRtdyDimJwotKbV3nlS/I1PfJR9scXMi2eciDvZYKm8uBU75vieAjk8YiCqw/OZ2ect
         O3w70nBORGLLBN6K76V/qCcJEF0VhFDDPvONVfwtizY5w4ThnqByuzXTHl/SjEvtS29p
         JrcF4ocJ+uVg0w32ipuFRAezqpdNxMUUQvR5x1bX1KSz7/PrIq4N4PEqVsqC4NcuISOa
         mETQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjidle9oZy8TxG6r8bY+UR7pXr+usq1nwFCmKq3BkK/1kjlEEFEHeTKH0hSyXnZosN9c80ntOtYRcwjKG2wg2StTPD
X-Gm-Message-State: AOJu0Ywwi670fctZkIG+GeRfYC4FWRap0wYE8uIOFuY++pbrXArxuKEJ
	dc+efp9DoE6PXvtUtdNQIA/7FIjl1sXPbLnTFRafXtpTQMLZhZ8Rzd9ggk+U+JB06lERa0FUWlM
	0qV1i/DGyjCK//sVtdDKq2jga5pPZPb9XJr9QjO3kW40nckjQfA==
X-Received: by 2002:a17:906:3455:b0:a5a:423:a69e with SMTP id a640c23a62f3a-a62280b0b82mr127045166b.15.1716369619486;
        Wed, 22 May 2024 02:20:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYPcVfPSbkAXS68vBqRtM1OqnF0XUIfdHR2qup5zLEObWYFFmu64efJ42K6olXzXuLrAmeEw==
X-Received: by 2002:a17:906:3455:b0:a5a:423:a69e with SMTP id a640c23a62f3a-a62280b0b82mr127042766b.15.1716369619066;
        Wed, 22 May 2024 02:20:19 -0700 (PDT)
Received: from avogadro.local ([151.95.155.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b17f37sm1746100566b.224.2024.05.22.02.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 02:20:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com
Subject: Re: [PATCH v4 0/2] Add support for LAM in QEMU
Date: Wed, 22 May 2024 11:20:16 +0200
Message-ID: <20240522092016.568512-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240112060042.19925-1-binbin.wu@linux.intel.com>
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


