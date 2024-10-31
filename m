Return-Path: <kvm+bounces-30236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2695B9B83D4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C60DC1F226F1
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585811CC886;
	Thu, 31 Oct 2024 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BaB2DkJ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76A1CCB41
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404588; cv=none; b=fZgcpsTSL6bpqdaEUV/EG1NTPlEktuN63IFYrsKqmtG839Q7dezCg2j61Gx7rpj6yHFc1fv9rLVVJiCNBJGbEEp9I/JjfUHCMdI7yWeTiqNHoEVmSJkbXUPxQmnMLBJENyqNAslFIEPWbR8uKPA5mivQzhdXvZ5UsH9zqT4h9xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404588; c=relaxed/simple;
	bh=irdmhu416PxIF988xDa7tIMGyvRLyDF64RSqw86O0Ts=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sctgzBrPvzNhGDb9O/JhtKu6e+7hqUQJW3o/R2NGMJ2zJSb5Foad5Tvu3TksX3yybreU92jQFSTOtquN6NixeonpLlFnpUAz0ij0STfkzSh/daeVTDTdGwkdACwVZ5fFyVVJL7Y3caxPbNRHY6JjCA/wxwc5GHshntTBwf3BuWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BaB2DkJ5; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e376aa4586so27640697b3.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404586; x=1731009386; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xcT/J95b+9035Ya9JfyYQ0TCrJz/IdJHOD9xyZsiM0Q=;
        b=BaB2DkJ5z11RKP6zMu2c5UAGueRrf1xWbbXDcBNXYQ+kZVdON7wr4WTuCLwzrX/XMZ
         YeLjnoMxbz99V7p3vdr1bvLowfxVuMiPq7+mp0C+UCppPg7VW9KDuCptMJ0KWxH1psQe
         fOHNaG4pHRXBro1+bgpqwMonH2FEo8qBmNcK/HveGrJxyvrJyjbf9nORfR/ksT37fooS
         KT4z/KBKpalFKSvw4uMNu3MesiwkOo05wkCUDk8oVA9u35xqfsrW2L+Y4o7pQelnvNad
         XKNwzjlZNAZaDjBsUmnDK+X/J4rBIGFurWv9mF9ZKrnkVAPalwlM838oyp7VYH61eo2G
         HI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404586; x=1731009386;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcT/J95b+9035Ya9JfyYQ0TCrJz/IdJHOD9xyZsiM0Q=;
        b=bjeO7OD5naSyy6XVTVxanG6Uw30Ga/6LTCw+49PQlkWZzlzbym5FJbFAn9syB5NfRs
         JoVQX2c6FHugA3mSZcJ9HEGv3v8el9kUAs50R/o1L2EQJ8PrhCjIFx4vWRuEtgVXIvA3
         R2n4VHuE3pil1NtS2xNy2+Age4gNBKUzv4xPS4vxDhSmuckOtsc1ma89cbBQbNuiFz2X
         4N8mx8Y1wx/UuHpFaFuSckaW0qspbXbP17PDQsXtX1v7+Pig1iPDUhbSFm5NSaXEL9kq
         LQ7sCfgiFDscb7i76R1rFPCe3l49eu+9o1sRacd+OEbKGCMXPVlWVioHxl7TDIg7x7ij
         ZL/A==
X-Forwarded-Encrypted: i=1; AJvYcCWOO0C45zFRZzo+uDN2m80H253+lakPv7sPmZlL3TGhMIy7DCAopRKBgGlFEknw67HJyGs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv1e/i4kw9TEuxeWSjufwiJrh7iM8sz85BdmSm6dEixyPMIRSW
	t2F32G+SsFlO6ObYE7zRtZYQuK1xSrtWTsqctKwosqGG5GxqSNLZKCA/1fWGSft/pnLJEW7COj5
	5Iw==
X-Google-Smtp-Source: AGHT+IEmEp8u0KUn1vgmjUZHb/5zJ8j0UI9051gpFeWX3hQBJbdaH3En+U7SxFv81ttx+3Vv7JsNluVX+3g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181e:b0:e28:fdfc:b788 with SMTP id
 3f1490d57ef6-e30cf4d455bmr5615276.9.1730404585605; Thu, 31 Oct 2024 12:56:25
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:50 -0700
In-Reply-To: <20240903043135.11087-1-bajing@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240903043135.11087-1-bajing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039502633.1508201.6734292194726141989.b4-ty@google.com>
Subject: Re: [PATCH] hardware_disable_test: remove unused macro
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Ba Jing <bajing@cmss.chinamobile.com>
Cc: shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 03 Sep 2024 12:31:35 +0800, Ba Jing wrote:
> The macro GUEST_CODE_PIO_PORT is never referenced in the code,
> just remove it.

Applied to kvm-x86 selftests, thanks!

[1/1] hardware_disable_test: remove unused macro
      https://github.com/kvm-x86/linux/commit/600aa88014e9

--
https://github.com/kvm-x86/linux/tree/next

