Return-Path: <kvm+bounces-3009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9810F7FFAFC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 423E91F21003
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7C122061;
	Thu, 30 Nov 2023 19:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NkeVa3Z6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8571D48
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:16:30 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d032ab478fso22839707b3.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 11:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701371790; x=1701976590; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y5pHXwknceWGmaj8OtPnr1WYaFoTOExKtqzqtLwiZ8o=;
        b=NkeVa3Z6eAGPfhlVFcEzrrGM8v8z0cy+WPcJLKZra1Nv3GthJ8W7rN0Hk8bP+PTGWO
         k1NvXlLxQd6Z5BcLCHUnF9pae6Lj5zAT1wQc8fPbwIkAUI+F3HwtckjqAOVhGtbTh1Uz
         C95QyYZ5zK/hDjaiXx7d2VCkRMDTNFFwYPTNEV6jIPv0P+AG35DM6AZMM6k8y/qlgj+T
         3L8qdjLpUq8mOtVct+FMjqaejUsVANxxnip2aYxk2ORnay+dykdPK9DRWu1eW3DKbDnj
         eX3uI+ieQ/6kfN4TQvGuIz/hFTfni1spFSZvnRCC2XoY0qCab6/DyzTkVDh70ZcvnWsj
         prAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701371790; x=1701976590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5pHXwknceWGmaj8OtPnr1WYaFoTOExKtqzqtLwiZ8o=;
        b=pQ1CWheS9p25dGI8j1XJO3aixAnVMCpw6YVF3+D9T78OmpBwgzTu/hRHhluRIQy+He
         EAj8XIQzdD/13VA9IleyYeffjD7cIjbDXZsTaiADUIVvPvSH/qi24gZLcyYPb+tiQDmn
         jiSsRDB00mBEYfgvi77tWX3RdH2FuZCX99y3QwbKbU6irueT5NAd89njscAJPp4DabCI
         /L5hLBeDOUllowwfFcA2Pcu0nNwUAi2e8Q1MkmPJx523vwaGw8I2b9u8Rcak6dREVgX4
         iML0Exg4yDCem2Fqr8ffV/cfIu98fIRQENCw0QnDy6vH++fSKG9LAxT8ghG98e/q+KWz
         MuMg==
X-Gm-Message-State: AOJu0YwjmcmapseXEuMGr98FXhSXZdTlE5sluPBcMh1JdTipJbu0Gr5v
	0lHA/BbT+Gu9ipoQldNqzBS9lfOlaOQ=
X-Google-Smtp-Source: AGHT+IGVQZH2hOZFevHTov9IVKBE8YAxCPoqEmlg+QCfshG7BGBWF+3pFeFyRhsJII6JOxcwz7vPkyXZa3U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e87:b0:5cc:3d0c:2b60 with SMTP id
 eu7-20020a05690c2e8700b005cc3d0c2b60mr620993ywb.4.1701371789943; Thu, 30 Nov
 2023 11:16:29 -0800 (PST)
Date: Thu, 30 Nov 2023 19:16:28 +0000
In-Reply-To: <20231130182832.54603-2-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231130182832.54603-2-ajones@ventanamicro.com>
Message-ID: <ZWjfjAnZcomGa1Ey@google.com>
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Andrew Jones wrote:
> A few __TEST_REQUIRE callers are appending their own newline, resulting
> in an extra one being output. Rather than remove the newlines from
> those callers, remove it from __TEST_REQUIRE and add newlines to all
> the other callers, as __TEST_REQUIRE was the only output function
> appending newlines and consistency is a good thing.
> 
> Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> ---
> 
> Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> MAGIC_TOKEN change)

Heh, and then I went and created a conflict anyways :-)

https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com

If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
MAGIC_TOKEN conflict.

