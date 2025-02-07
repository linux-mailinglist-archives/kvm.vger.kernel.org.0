Return-Path: <kvm+bounces-37543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A57A2B7F9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0420E18895BB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86EF8133987;
	Fri,  7 Feb 2025 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="vp8S0KzV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11EC14A635
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892321; cv=none; b=e9agishOxJ0XQ2p/dyT90oVrvrDXj3HPJGWstztRDidlyPpr88pbCNYMPBLRwiNutgJJU6XmC0KKY2D3shjnJstSHq/Wg1y+sHJTylUUmpDT7w10yleH6QrzYGwVEUXrH2YjwtVGhk6I2mWOU8Z0Cw2KkPnSyF48pWkCBfJkSaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892321; c=relaxed/simple;
	bh=gY9UBQG9ViXpcGeddZUd8H24jY3ujl47h2VTZ5EnH60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oqtF7xMlsi029/C+bc2ubJcsE8ZgG4P68N61bhZuNNZDoiPpstZxjMeqY0xG9Yspqk1AtOvInlsBGJOB0v6qlPqoRL8lF/bQ/zZNRsiwK8guuqG9Xngh0fbrXs1IruKPAxNarl1itJwVzWLk5YuGAnnpABV4Mn6UKMS2s7UMwNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=vp8S0KzV; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4597E3F291
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892316;
	bh=gY9UBQG9ViXpcGeddZUd8H24jY3ujl47h2VTZ5EnH60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=vp8S0KzV913F/XGggcZES9ysxF+3QjwXsDLTCJMj6H6rfJ/uE+IVA4mNWxvwPwsyX
	 S5E03ki6tnDkz4RoQsuLtdXKWgBrTOxwhlNlFPTTWIh7VH/bAv11SW4/2P30Sd9lHr
	 ViRCG36hkD38QfRTovMhadSverHXpmr5a0ux8AqCwk+hWJ8AUF17pH5UKcTTRJ4aCV
	 HoMRyVEsvBjxRdqVh2dVd5UmqHkKGsWqhsPYPEgx6C/YSOiT2kZbai6Ix6WPHDGsmB
	 WkeT2GBLQ3xgP/uhXAqS3FxFlv15jeGy3jz2pu9QMwtsuSKsE6EQPVm/z3Bkctddsk
	 kPJv1swbN9T1g==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d90b88322aso1717927a12.3
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:38:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892315; x=1739497115;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gY9UBQG9ViXpcGeddZUd8H24jY3ujl47h2VTZ5EnH60=;
        b=p10+mgDpMjIyBeD0wh5vNB3SdWpvZ/CTp0yhRPgZcElwBpL3yl/FT3aBbUPyPw5ujY
         PAKJCGFPDVSMOrQ71DjX5ATCDr//DvmUTQLKRnrw9zNiXZhJcjU5LjwZ+xlZmhz+1HYW
         nYIJm53NecYbhrUQ3KqSBwCp45r5xMEeos8ZoHcokVv0i0EGlEI49vM5hSZoTfTm8WMR
         NrtVWmYZGnflMutCnxJhEg2+VWngttJ2jDCIGA01jcj29QHxzoiIhbD2jQtMtDENkGfK
         raesqoHyf6XHJjTDFAfYGQO2WmBpQ7UBG5MnOyUnMEewNfTRSQ9ztyAy+NVPPceomsbF
         ZMiA==
X-Gm-Message-State: AOJu0YwY0IVGhFpfM8s1Pwf7YjOkzRVuTO1eipHxXdBI4IVbrWpQvWen
	FZwJjXQmnsKUHQFFPl/pdxLxdjKqfDCpYrZtkYMN7I8JdgreUvbPqATDKEZW3GY1tHMK4Xtfv5O
	sSW34HhUwn2w+NGRHp6v+Rjr9U/grLFQh67z6guE0ywwV9aVISuDfGFdC4bSK5EhrUUZ/4zp91p
	yi+tMPD/hZNWXeLVAUE+kZOqi27YQWPyBk7cjSltDF
X-Gm-Gg: ASbGncsC+iqV/AbrQkXxtrNqSETtywKmyt26R9Gsd1SSGaQBw5HE/0CBrs2KNA6X7Se
	/jOkjXD1Ftc923UEoTG3iiT75jp8+ul+INnZPoq8zloZg3do1SDJAKj49kaSJ
X-Received: by 2002:a05:6402:26cf:b0:5dc:7f96:6244 with SMTP id 4fb4d7f45d1cf-5de45089cddmr1426840a12.23.1738892315674;
        Thu, 06 Feb 2025 17:38:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEIwxXUvbAeypACKoqCkHY9+qiOo7WcXxv8y91E2dSxGdm9+lDZtZFYwE31YWSzIiGsqq1YA3Dm6T1oMmn+6c=
X-Received: by 2002:a05:6402:26cf:b0:5dc:7f96:6244 with SMTP id
 4fb4d7f45d1cf-5de45089cddmr1426831a12.23.1738892315362; Thu, 06 Feb 2025
 17:38:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com> <20250205231728.2527186-3-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-3-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:38:24 -0600
X-Gm-Features: AWEUYZk_st6wSeMA_Mj52i8EgOFzFSeeZ4LQVCVBHDd3uRL4CKa2f0gbE5lrulA
Message-ID: <CAHTA-uYuoNb5xFcHtEVkD8gy0LF7zkZx6aUtT+55pTMKchR=cw@mail.gmail.com>
Subject: Re: [PATCH 2/5] vfio/type1: Convert all vaddr_get_pfns() callers to
 use vfio_batch
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>

