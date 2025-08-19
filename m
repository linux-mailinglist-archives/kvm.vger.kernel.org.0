Return-Path: <kvm+bounces-55017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A1DB2CA8A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 19:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0A30189B37A
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF759305E24;
	Tue, 19 Aug 2025 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dHP7SZqY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67A2882A9
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755624468; cv=none; b=fGz82UGrvLyi2H+eMjt2NoykWpgkRaOB07IHTTwL62SVCCjDF9W95v3iuHnPKHaA2uujSEN0UbbceqrsyICDVbuB9gxlGZ2XayCh4x6127X1ufhcim68g1hVfYauP0S9TN50odxDxsmpBxJSW26t1G2c8++Xtkl6f8qmWjx+EKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755624468; c=relaxed/simple;
	bh=PXKnFxWhVcGvgDGwHV+luZExw5s8ijooTkSu3WVfGS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EE/vtFiaOTjHChkbOOVHnNZplKDsr3V04889y5jhWsNKlvUijyB6QagE/3y3MS8zRGnXCBsZdx48aAsWkZs+JirBaiOcn1kX1xDfKyxQ4l50GXQbLSM5+1QMSZZqHhnV3FixKF98IwOzXjZwDM2vye5oOVvAxtcEitXyPfftEjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dHP7SZqY; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e0c0baso5713891a91.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755624466; x=1756229266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXKnFxWhVcGvgDGwHV+luZExw5s8ijooTkSu3WVfGS8=;
        b=dHP7SZqY3C7GLkktNmWyq+GETmuwjt5z8Xrue3xAxBwXMoQR6ZOyk+XEklP56OOVxM
         ffHaMzBAAhKACtbFKixzmycVDJyPBynlDOak83DRB37Aqd8qMfB9EnQX78v59upjSgUJ
         GldfuEm9lq+WvSbQbSi4uno/AQo5SSahI9oUn1lPJN9+6kmMf8JEUjxT2gXK2Iz7uPKS
         YNTaNXHyXrWjV2GQxrcxWcHgbUYPZANv5jpBf7Jlpl4qkeB9/4wRiGqEL8OB0zzafB0A
         HTSf5LyU7wXpHXsXtKgxpOpjputV6dkCjyUkGnU04XqdK9qep3Tu6JlFc6TXrMin32bJ
         yN9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755624466; x=1756229266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXKnFxWhVcGvgDGwHV+luZExw5s8ijooTkSu3WVfGS8=;
        b=hA8/7GFqdbCoc9jYTeXVUDSC4UmUgdu803Ko+mk2hL/28UhoOv68Dd+edqTbNhWH49
         utZNDcqr+BbWWyFoUuosZfSvPFnX9xgH0En4t75YfZ6Ff6d3iIUqpobBnj5eOS8gXI+q
         lmyj9vHUizksndZc+nYTuSyZPA53DwlC2oKM7EQf5xYxBfAZ9e8bKQgOfMVlXa9o1sGx
         pgQP9cRbsdZocpGLl27Y+IS55XQ20g0PiSOFciA47HTW0efOtYfvUYjo3UQBHIDfhwNl
         2Dk7+m8bv8ME+sz376ROqNytcqcIMiJhHAsJWVVgR9tgj9eaaHFFQNk8PS5BozQR5v5S
         Xy2Q==
X-Gm-Message-State: AOJu0Ywk5LELtJHLVUVl7rWd9gQKH4ZN2IZofkeo7Y8d5CHmZGRnT0vT
	8daIfvT0inq0HmE3pnrX/Y5ED7z3u6VIaRJ0GN81nKUQu45YNt1mmEDyekZiYOiMESAqzyl0cr1
	wynbJ+A==
X-Google-Smtp-Source: AGHT+IHq9/xlNa/fyvpnSyboZMxDaMYV6UTMAPtqcgnXojqjwHvvh9FSW9dIpJS0BWWWAlcs9SsTSZ/tGjE=
X-Received: from pjbqn6.prod.google.com ([2002:a17:90b:3d46:b0:31f:1a3e:fe3b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b48:b0:323:264f:bc42
 with SMTP id 98e67ed59e1d1-324e128ea93mr74729a91.3.1755624466263; Tue, 19 Aug
 2025 10:27:46 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:27:44 -0700
In-Reply-To: <20250812025606.74625-24-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250812025606.74625-1-chao.gao@intel.com> <20250812025606.74625-24-chao.gao@intel.com>
Message-ID: <aKS0EADlViB2Mg4e@google.com>
Subject: Re: [PATCH v12 23/24] KVM: nVMX: Add consistency checks for CR0.WP
 and CR4.CET
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	rick.p.edgecombe@intel.com, weijiang.yang@intel.com, xin@zytor.com, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 11, 2025, Chao Gao wrote:
> Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
> area in the VMCS12. This ensures that configurations with CR4.CET set and
> CR0.WP not set result in VM-entry failure, aligning with architectural
> behavior.

The consistency check patches need to land before KVM lets L1 enable CET for L2.

