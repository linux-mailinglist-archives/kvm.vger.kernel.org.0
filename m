Return-Path: <kvm+bounces-60579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 970A2BF4159
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 01:56:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 49A9B35139D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 23:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D47334363;
	Mon, 20 Oct 2025 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wKJDhg31"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977745733E
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761004560; cv=none; b=O4vwDDr3+9gdHQBGD3pgQMiVrus8ZAad9s8HX5xl0+wmMon1VU6pbN99PKYAMNua8lUTbjdeczLauNFqY5SNZeVr1MHujf6L+gIpy9hhZ4WT8iNro5pBslVemdJkTz5GjL2YRn2A1MGcTALndYKEtcwZbtlDyuHXgozrVX9TIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761004560; c=relaxed/simple;
	bh=mcUKfYrdQSpgEynl2UwsrQ2Hve4TuJQzk8+mUSe+wHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PFjd5bqK7Ud9ZT5G5o5tJSrrmbBFtJrQXi8v/Fhrx/8wYfDvplgpcO7HTePleann2jwdr5E38KCue20RFD1OLWc5m0Yk2S88+K7Mz/2y53QHBIMKEdQy5Oxq37k+X5sS7OdKCh/AYm1ITuEkj0G1845ULtcNpdPXXMDHSZ9gB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wKJDhg31; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-290da96b37fso57225ad.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 16:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761004559; x=1761609359; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u0nnZ8bRb5CyQ3D4M/BOIhfpk20sndQZa2pgDITOBD8=;
        b=wKJDhg31+uMG8tNCOQ6dOFikOV8xNjjHTlI0dheKwrNLRKSZyfyIwpHDwsvlHsAgCP
         Vic2x+oWGa9lJpAhMELz3u46qNSngEypjDZ8WfPCe3geqdgnLPYHuO7kwVCnQSwpOTMN
         46c8HkTYok5k8qTzt9sOUIhyfqAdN74wbZsgl9DVbO5BeD1CTSb9osW84mGcO76iTlX9
         toldUfnk5kGkqgXsA09dN5Bc81m9f1lPeywv/2lUSeK7tJN7kH5MJo5pmkIwypdkpqHs
         /G4itnMUYSxFrSvkRJw+VOWpKUpg/5lqDPg47V2r4xwbuioQVXgV86GQUK25w9+m3fZB
         mtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761004559; x=1761609359;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0nnZ8bRb5CyQ3D4M/BOIhfpk20sndQZa2pgDITOBD8=;
        b=mFLJeIUAtNXQT6PmsYOKZFllbeVS5o5xgzivUW+ogasF98+a+Yl5/J/desv49UGidG
         29Ko9ouiiHQeNzApw1UScmA0mi61uaTr6Ern1Uc7JHfe92dplaU5jddEx1llhwhZ+akX
         UdKBK+McJtQYIEF4hbD4MptiLerbNRDIxakytN14+Th6Wi9MVNn7XCB7nZq8N8kbBHho
         qdJZWwzRRBJGTVPX60L3X/8nag8mAxTGc0zAVzPrkAmSBbuMMh/MvMn9qj5qxobzdUVb
         9gU9xgSFzbm5P0aV3dUf9SOivpUV9rK6ttdMmXP00/cK2JmClPkQvscKSYIxP3rv7BfX
         eznQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRpk8pSQp8AxxHQMtkMwciMjE/L/x4CWtrzN14IBZYGHVOoOiaXzF+qd7V1e7/lYEWClw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNEGvj3kL/scCpApr+CXHZyhBdSourHsUv7BNcIZy7lPcAmyRi
	4HPnVVHL3Kl8YQuoBbKKYQ9hKuPhFFCOD595olmtUFMH01kv753PXLqmvmLTVVEOSg==
X-Gm-Gg: ASbGncsBDABpoOhbTilyc+iWYMyPFMzlQgkHC2lfgr4MhrEy67tuYrcgIrmuzzUOc51
	VHY2MeUmOLv1G3lBCVc4DA1rhCvPjwDYvuBAmB63U9lIXlWylN6goTh+gtJS2Q0syp7ymwHL2ra
	XQkVZeC2vE5eH7ucnZzvQQoDj2VRKyPsB3j2qlmWXAv9txBbrSYDjv4XyEpgzFWTHk/8n81XJTy
	gPE0EhuV1m9OAr1b4ybsiIuHGtALyMZAGnNED/p9Yplyguxcr7OeeUxE4IYOz8H2leZ5cDF5WUS
	NxEGcRO98CiZbAeb6EKiebk+yF4eZ22hcyUSH6+nljKzxvJizgr6N3gn55XiQfPVpU5I6LwQ6Z1
	PNKCEagBjLqw+6W6JoPSSJTMo9rREFnNST7VDXobY7m1/A3HbV/oRjkA7+47Thw78HjyCL+ef+D
	FCjW2RJg3nnqcZ155yYO1hcCZsuAnwakv9wqLph/sfddBd
X-Google-Smtp-Source: AGHT+IG32aKEvMqQdCicoH1rwzi9rTqB/3kzHLOxoWRLdvRJmMsuPKuV9j72408kyB6QWaxlgj5D/A==
X-Received: by 2002:a17:902:e547:b0:25b:ce96:7109 with SMTP id d9443c01a7336-292de616a3bmr863795ad.3.1761004558570;
        Mon, 20 Oct 2025 16:55:58 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5de8090csm9243673a91.18.2025.10.20.16.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 16:55:57 -0700 (PDT)
Date: Mon, 20 Oct 2025 16:55:53 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: bhelgaas@google.com, alex.williamson@redhat.com,
	pasha.tatashin@soleen.com, jgg@ziepe.ca, graf@amazon.com,
	pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org,
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com,
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com,
	david@redhat.com, jgowans@amazon.com, dwmw2@infradead.org,
	epetron@amazon.de, junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 18/21] vfio: selftests: Build liveupdate library in
 VFIO selftests
Message-ID: <20251020235553.GD648579.vipinsh@google.com>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018000713.677779-19-vipinsh@google.com>
 <CALzav=cD4WLKX0roP8mvWEO1dhLGLtopeLTmH=f-DeV2Z3mAJA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=cD4WLKX0roP8mvWEO1dhLGLtopeLTmH=f-DeV2Z3mAJA@mail.gmail.com>

On 2025-10-20 13:50:45, David Matlack wrote:
> On Fri, Oct 17, 2025 at 5:07 PM Vipin Sharma <vipinsh@google.com> wrote:
> 
> > +TEST_GEN_ALL_PROGS := $(TEST_GEN_PROGS)
> > +TEST_GEN_ALL_PROGS += $(TEST_GEN_PROGS_EXTENDED)
> 
> The TEST_GEN_PROGS_EXTENDED support should go in the commit that first
> needs them, or in their own commit.

Yeah, this can be extracted out from this commit.

