Return-Path: <kvm+bounces-51950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A96DAFEBF5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C402179B8D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EBE2E541B;
	Wed,  9 Jul 2025 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ATCuB4OP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A5A2E0411
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752071245; cv=none; b=lZfVEdPP/Odx+hdAoLvK1OKTzPcSbQQAU3sUAyGchDp4cGV29j/fxY1OQChMrNZSoXn/xyP5GTa/Xv0uvlCK5IO0l9SR/FIxamiPBEMwKQLMKl6r6ca9nIfOh7l2V396wDINsxKA4fjyPtS9vJHpovbbOQf8pPQXoh3ju/D5Cb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752071245; c=relaxed/simple;
	bh=pvkwBrcqCz/q7TbAy/707f2NDn31fDmeAF6bySTr6Ic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J17Ll3x2ZW2ADAUtdOqOy/PtCKCYVi8gftGXh8DZFxF+sbf3tELyx62I5dQmt/0Vn3ufbC4vB4UfNf+0VeoYYS3zeCbWn8hrNLYm2oIce2UBLBij3yD1bsZY8KT7NQNSY8XUXH9qPyuYA8xhc/DDNzKQKgY4BVMAaIH3bNkvpLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ATCuB4OP; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31bc3128fcso4158a12.0
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 07:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752071243; x=1752676043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ny4OheUvtoLgeKPBXu3zvqh0EKHCtc/bq+iQEnC2Ww=;
        b=ATCuB4OPm2JrQ8VZzrN+rTJK57JI3Do2WfSxO9+7NP+yKclh6m6DasSc4CCB9AelNx
         sgO0GxHZW19n+O9RWJrWyHRcA9y39o+wuftkVC9F6fOKMXOWqq+N/VMAs7PgZbv8kYBG
         NhGrXvMxDDfzM5cU7NO3iA6q+DmU0Z8Gx7hArtaB01OrWflXWb4+oa2DvV4rvhb95tnT
         zwwsGYLRePAku6o7KIH7RUOXDXqQh6vd90IspzWg/7DOLfBsMYDc6agGs23Vv3f/jcRN
         fKmJiv7VpgvO90qOzKNS4JsqU+2O6SmZfDjzQ78lhJDykSWAJhWtyVQxh01y6NwWwcLw
         UBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752071243; x=1752676043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ny4OheUvtoLgeKPBXu3zvqh0EKHCtc/bq+iQEnC2Ww=;
        b=wpojz4lwy8BUI5JFivGRLOnnj5y4qZaaIlcj5ITccWk3WqOLbsGS86OeZ+BLpbDrmk
         sIesHpiZUPPh4Me7RuYrimXH4ylQpJYJSZg02ipW4jL9dqzfic7l9IJS5KSumk2fJhGC
         tANNBi1U396oUudplwWK8zFy6Eoo39ctMqGDlUZbSArKvbqMmK7N1HWWGv1cor/xB7h1
         QPMJcEVJPYdnjLkPShrSGcsWeMNM6469ozzGaljoyIfy90S9j2p3EdYyu/lfYK4eTHiO
         lRHqq0ej7Rxa5ZSEhmJlDertRDFLi+tQCLIVgPFWqxFDx/xtFT/lGthDdz1EmnwOlX83
         GWQg==
X-Forwarded-Encrypted: i=1; AJvYcCX9z1++TC276+Kw6O+Qcg1h0ZP/368xsQMaJw99vaugZMm9rbzTb19OhuBIMnwqU3wqRDk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxeXvVssq6gR5BS8P9FcpxpNgf8BtJddYC2s3acPZR05uPShvy4
	G6zmN4RnCdrcXNnWtFwiCOi4UlYLjbTdgEOHdeD7cb2Uv1OCfR0n6SJDv/e1pBmQo3rL9qt+wxY
	AV62rqA==
X-Google-Smtp-Source: AGHT+IGcOXxhoDOk+P/ex+nqUAh1f+wKkBdBcrVKVPPMAEpZzWU3sIlfK65sSX3bA5bYd6D9J3w71Pwer9Y=
X-Received: from pgbcj11.prod.google.com ([2002:a05:6a02:208b:b0:b38:f5cc:7771])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734b:b0:1ee:d418:f764
 with SMTP id adf61e73a8af0-22cdaad6959mr4171366637.38.1752071243305; Wed, 09
 Jul 2025 07:27:23 -0700 (PDT)
Date: Wed, 9 Jul 2025 07:27:21 -0700
In-Reply-To: <20250709141035.70299-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250709141035.70299-1-xiaoyao.li@intel.com>
Message-ID: <aG58SdS7HibYuoW-@google.com>
Subject: Re: [PATCH] MAINTAINERS: Add KVM mail list to the TDX entry
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Xiaoyao Li wrote:
> KVM is the primary user of TDX within the kernel, and it is KVM that
> provides support for running TDX guests.
> 
> Add the KVM mailing list to the TDX entry so that KVM people can be
> informed of proposed changes and updates related to TDX.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

