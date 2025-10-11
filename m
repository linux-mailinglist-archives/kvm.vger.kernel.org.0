Return-Path: <kvm+bounces-59798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9A5BCF0B6
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 09:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C81984209E5
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 07:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2162192F4;
	Sat, 11 Oct 2025 07:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCbrsyCF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031BF13959D
	for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 07:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760166146; cv=none; b=cGbF2CqccHNtIiZhPizVNOsu37wvplpLhY5FmQ3ejL1bLU3YisFZ+kI7lMLpRgC7wWdfQx2qFKuVo/z4OSG5qLJEh19mvmNjyYN0vy2w2sBLWMku3c44eiUD2/BSZRal4ocRQcnrCXhgB8KMEvuM53SfeObDXQLhqoeob6NZKq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760166146; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6+skrZ19btyYgE/iLYeRNu1ItrxQ0zWtaJ7svYime6Nf8eUmpuJAyLnI21kDcbC+giQPXOdBQVhpyk+qP3RTMdy6JISR713zO4LCaFoWiVtwpL4FOWSF7x8yhL4myH9hQny+T0UOid9HPul0SdLnv/xv1PEg7BuEkhNtBhE2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCbrsyCF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760166143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=FCbrsyCFDmDEhocUPT3G7KsDGgz5fNp3IlcyhuWsmnNtKKmtLNyWGJIEGmRH8qod9R04WW
	MeY732DIrWGnaL/WPtx88KDT+toVIRlNGAyZPNElhT+fDL1zUNKFwtXppUTWuhsplDTEST
	2gQuBEGVhguGJshIbnBWEIdNUaKK7MI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-K-xZDbS1MqG05ytwlQP5-g-1; Sat, 11 Oct 2025 03:02:22 -0400
X-MC-Unique: K-xZDbS1MqG05ytwlQP5-g-1
X-Mimecast-MFC-AGG-ID: K-xZDbS1MqG05ytwlQP5-g_1760166141
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-afcb7338319so315364566b.0
        for <kvm@vger.kernel.org>; Sat, 11 Oct 2025 00:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760166141; x=1760770941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=lmxDFa6lBO5CFhz9/3J7+ytcz7zJqs7XJyYVvZhvZ8oLWal0Y/JQC/knNSTkb+AVDW
         MDf1c/Wy0hQHL/UoQIdqqpoSPFS5CxoZUsV2+BROweB5nXVR4a+tCYH/+E0gyH2iS0If
         +FSvy8w9haxNmG3E2VR2DFdxwhzOUZZ5M4vr1c/PXT7G9NnnWRLS1BD8/koZFBHLPTUA
         ad9dH1EbTm3mjI1ABfEep4+8H5IA5jMe1L7g/Ukp7E4XfLfALQRq8nJcxXXK2Qgszjvf
         o/3jhPhJ6ONi8X1wmhv6yHCuRuwHeFIl1KXe+2XObyGhKwuRKJNAW87YP3uLAHGKUcK7
         QOQw==
X-Forwarded-Encrypted: i=1; AJvYcCXBu0Bh6v1IRRmfQWi9Rqsfc8zNP0I9KtqZoiXn00kqRCvfAPwGw0y6/KeMP2RrATfj1Rg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAgPvnbnBAxwS4v8E4TNw5pno8vAm7ZOo0lnIz0vAgJOPI1grl
	RAoAvFeuuViGn5TU9RsSqtgOhkitOsInyW0pIOC8fIGAxcWpAgUhqI0BDKEHWlmm5oPRyV8+KIs
	ucd0QFCbs1O+D2x2jRjlDOL1eMc84IqKAPC8c1iLFljTTgYvUv7dSPg==
X-Gm-Gg: ASbGncuhHyYAs+WMLxUr02c378gANPui+Z+mUcZW8QU+YXAW82k4ycwsUuMOVLZeg2/
	05SNTcVg1nIc88yb/K7Hee6HFoHsB8VBve0ZlMBJQ4El3O54NgXWyUADOv7sehdi2c7X7bRNe2x
	SOWQBAqDeRtzu3llOIqYhToRJ2a0WKz1N7yZvE+3ko38VhHCEMDrD7kgvoD1HfOlWqntoaITlgr
	hZgrYEZadNqwwI1Xda1ebETvfX/e+Gyntke4x13Be4oTWkVSeLdLt+Muy8EbcmbmMOoWEtL9mSK
	Ox040p5iaTc8Btb53b4wMr7uTtMIC92E2VUaX2CxAO38+IhfMDZZNEVjd4y+3IEdnGrC5JDnsMc
	iWcBl49wt+6yXZiEUkzhDuyigvmwQmjfy7g8qAohuUcZ7
X-Received: by 2002:a17:907:1c0f:b0:b40:9dbe:5b68 with SMTP id a640c23a62f3a-b50aa792c29mr1323297066b.5.1760166140846;
        Sat, 11 Oct 2025 00:02:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5OrkATRsLF1SM/7eNVOs7v3IljUCwtF03UsJxXTO7GzhQA6qsVWyLAiZxJrw61q/YB4Tqfg==
X-Received: by 2002:a17:907:1c0f:b0:b40:9dbe:5b68 with SMTP id a640c23a62f3a-b50aa792c29mr1323294366b.5.1760166140400;
        Sat, 11 Oct 2025 00:02:20 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.231.162])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d67d2da2sm428678566b.33.2025.10.11.00.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Oct 2025 00:02:19 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] i386/kvm: Expose ARCH_CAP_FB_CLEAR when invulnerable to MDS
Date: Sat, 11 Oct 2025 09:02:04 +0200
Message-ID: <20251011070204.864385-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008202557.4141285-1-jon@nutanix.com>
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


