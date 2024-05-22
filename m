Return-Path: <kvm+bounces-17944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77DC98CBD8C
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 11:13:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A86231C21BF5
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCBE580BF7;
	Wed, 22 May 2024 09:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5b+qzTe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7632E80639
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 09:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716369200; cv=none; b=h7EvSs0fHXBa2kyzSv2GHLLyHI52uddYyKdyXEQP/r2+vRB34YNNfN77cdNf0yT1xq9SvZYwTtXYZF9YfFgp0glLGMHRmD+C0VqfvQAJMByf28CDtChv0G35Dx6z0IhlwxXW6Fi7KSE/XyL7DgBkbfO/WTY14xCB2B3LDrMBPDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716369200; c=relaxed/simple;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8QDpV/RtuJkCTI6F0TfEH13uJzk0YfjZFCMwOcX3YO/RRemoNCnejc6N2z7qBgLREdQOePV3uFO0Qva6tZFxlrHmSMbSQV/Vdd6+hgsByukO6kgQnBLbqqmj1dUmJU1Wk5sHQe7LfUzRqTmZerbSHQ5VrUAmWLkulzcduhBGuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5b+qzTe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716369197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
	b=F5b+qzTeZubLYCZ9IN3zRzLR3DvsvHdkT1Xt89wobkTbV2EmoXKGJKm0rRnPNf3tsnI9jD
	9MMgX0CtJNUGWTiUJtcJlJvJ3NIsEwoiihacXzHIvSxi4U4kS8ndRgu+hgbv1xe+G9k2bv
	vakavnZqNCiR46OnFwq2f0TC/mhDtFQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-01YusFlHO9S42mJxFVKItQ-1; Wed, 22 May 2024 05:13:14 -0400
X-MC-Unique: 01YusFlHO9S42mJxFVKItQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2e1e7954970so114341501fa.2
        for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716369193; x=1716973993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=QA5G7lvTL01zoyBDlkrRAcE9Dh1GcMWxQhiw0nliM846fhi4OYuBBBXa780HOZ1N5i
         jQQL6SwxI3KgXsjDZXSKAsoMFlHJkjpIGHwyiFBeguVN9Lk3iLd+VGmV6j1M5ZG8KCBE
         nT3uQ6o/5PziNgarNucTvIlChffmJc/JQdZ/PFpqA93A1MeQtq0elB6qjg8sqvnY74fi
         eKwcgLRgorSTI/OqoZ3U2xr31qR2/7CHkwwJLmgt+q2i4SX/DHNSAYu2dr2RoHtU+rnK
         WO/cMkv8FjMix6EUJY5WTlnp2+PA9ErIYHL1vYgiP/x2lcYs27wI+ifGB/+AjyA3K6J5
         KKjg==
X-Forwarded-Encrypted: i=1; AJvYcCX1VW9ZJU6IhA9tPTkG2315KkoxTUG99WrGCLBsH+9LUrcjYLLuz62moThnK+Xo1I8e7i8VBGH/1D23JMGnLdU1qGqN
X-Gm-Message-State: AOJu0YzC+AUJA2Taq5Eiy9Q1ME0AlSDrvLuDo9MYFeSRfGmiX0iGezDZ
	hYqRjguj7Y/SFaNlcqQnx9Hfu25HQwNaFLuCmE4xumBtMretk2FxBn+SiX7/1bzQ7khPdigdAqs
	lXNzsQPMtqZUscUd5BUPKO5oPKbFt7HvNL+/uT/eGiTD5SGKx812RWSvR3w==
X-Received: by 2002:a2e:240d:0:b0:2e6:935f:b6d3 with SMTP id 38308e7fff4ca-2e949466edbmr10570201fa.14.1716369192785;
        Wed, 22 May 2024 02:13:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFpyyA44hFQF4ppETk7HLGaQKmoD1bt87vKreKCyrhr8nGC5a7wmKaHL7suDwGgp7m4Arn4A==
X-Received: by 2002:a2e:240d:0:b0:2e6:935f:b6d3 with SMTP id 38308e7fff4ca-2e949466edbmr10569971fa.14.1716369192348;
        Wed, 22 May 2024 02:13:12 -0700 (PDT)
Received: from avogadro.local ([151.95.155.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a61a00e96c1sm392966266b.151.2024.05.22.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 02:13:11 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	robert.hu@linux.intel.com
Subject: Re: [PATCH v4 0/2] Add support for LAM in QEMU
Date: Wed, 22 May 2024 11:13:06 +0200
Message-ID: <20240522091306.567300-1-pbonzini@redhat.com>
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


