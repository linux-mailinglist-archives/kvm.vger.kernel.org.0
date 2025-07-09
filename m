Return-Path: <kvm+bounces-51940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88307AFEB8E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F9DC5C24F3
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0F02E7170;
	Wed,  9 Jul 2025 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GDa9Crzm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9D2E62C7
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069970; cv=none; b=Vcmo/PDl7WrzhpG3sg02H2J21Fox17/kBE+DRJiCmelgOI3/M/qw856Jq1hpWAtuqEvo+AN5q3WD4GEGwGYRvFrVvCNpbYESNIKkntXFHKz1Ql7EF6zQryGciZwT/Ubf0I+gEgEkhLCsLTQRXN1EIl29jrTrz6ShJiE8YXLBO8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069970; c=relaxed/simple;
	bh=y6xqr/wBNWhU0qZp0A/9KgmB0vwEU0Tbgf2ufBCTot0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q9tMS3gcBSa6HFRWAdwSgPP5gFQw/62vyS+Rn2YZQXlS6lXpr1PMRa+ExpWdfDfTmCZWsi7M/hwRTYEpnw+88n/gIbKoChJQPG7jeYzBhz0HhgfT7bz7XOjaH6eYhFFBakiN3Y41LlgllBmnKDo7FO8qaw45L/2SAshTjS/IGGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GDa9Crzm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-313f8835f29so8931339a91.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752069968; x=1752674768; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IlRzbsbIQZ4T2BRMJH6FD0A9BGwUR7v2I2NL5oQaD40=;
        b=GDa9Crzmg/tbVQWFuCN3i5y+GpNS1qCN6rnGfAryKGFwQSkps4ZRGvhK/gb4mWfZDU
         NGEH0HqERXqBpF+gt630dZxEgoLBpxw27GMxFZ78qkiMWqtWepOHlLwi+TSkdtZvsOTA
         ORDD6kC51qMKsuOPa7vKn+tln0AMexzWDm4z/yRS1vVI8LBlBt4jfjZy+EzxMcfYqPnk
         6AtihbO9OTGqACYjcYTSfiphF1FtkUHhojmgzWwDAUSnpNYh0X9pGl6zOiVt5fORQDG+
         u/CG7I935VIxoKUMWdwDsvanFiSSv3Vd3+ZS/0CGxldWqCg9EBsxuy9FWV0H2kLWhbzt
         Pc+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752069968; x=1752674768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IlRzbsbIQZ4T2BRMJH6FD0A9BGwUR7v2I2NL5oQaD40=;
        b=oPzEyKZ6+Mugb+zMIMMo3P3FVqCaKZO+w45MpTClutdhaVgbT5GWwKL95T9ASce6Vh
         CxBY/5KhQKTce3TwbjygiaBh5kfLGVi4n3CzhMzXwRhkJsuTDHvzWm6YJWQPKs7G5UsJ
         g8MJmajzlV9mRfhDkNPPIKTyB98S5cCc9bKY8v8SmXe8iBaIv/47lGp3QV6Aa4sjJULR
         LLe4kE+n8B3QAIcumhVB6S3BfxM46gQ69yBzk2uN7cBkFtkKHPmOjNWJ9iR0R0Flh8vU
         RpjqqGyUD3HZSFJ53C7NQ7qNyRi+yauI8WR0g1jdD9WA2i9ehDDN4jHi8UqSjfpiv1xL
         RjAA==
X-Forwarded-Encrypted: i=1; AJvYcCUsKb+068jbWyMMvOvwHTD4zyu/M5aYFkTgmdDtT4UTU8qFDEPqIK2nH0GmFSd4h72NgyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE3VG0NxtFBqxUnb/U/kF0rOeYdjkg+ETJ0BttgM1ab+NzshF3
	LvhSOui+IqQiBrPtjnjb7mS+OQmN/YLOXPpjLH+XAA2E+YAT3F95X3zRutoZk9JvBmfkEmCNaiM
	zRAqOdw==
X-Google-Smtp-Source: AGHT+IE0oSgaxWq0fZDSOwOBPIswqkFjMD5haT9ucE9SRBQPhdVVhvHREWsvywwcFfqohS2D08NmtNBBbnI=
X-Received: from pjblw1.prod.google.com ([2002:a17:90b:1801:b0:31c:2fe4:33b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5147:b0:311:c970:c9c0
 with SMTP id 98e67ed59e1d1-31c3c2e4517mr54015a91.22.1752069968097; Wed, 09
 Jul 2025 07:06:08 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:06:06 -0700
In-Reply-To: <20250709033242.267892-8-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com> <20250709033242.267892-8-Neeraj.Upadhyay@amd.com>
Message-ID: <aG53TnZw5H3Tffb8@google.com>
Subject: Re: [RFC PATCH v8 07/35] KVM: x86: Rename lapic get/set_reg() helpers
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	kai.huang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Neeraj Upadhyay wrote:
> In preparation for moving kvm-internal __kvm_lapic_set_reg(),
> __kvm_lapic_get_reg() to apic.h for use in Secure AVIC APIC driver,
> rename them as part of the APIC API.
> 
> No functional change intended.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

