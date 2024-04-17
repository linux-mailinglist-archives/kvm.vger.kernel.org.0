Return-Path: <kvm+bounces-15026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5428A8F12
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:02:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40AC41C2156D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864CF85633;
	Wed, 17 Apr 2024 23:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0ZdFPFJq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811D37F7CA
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713394942; cv=none; b=mKURjJvd5kHKQaM0VZ7tRsNF03g8wP5rFICabmYqvfJNLNPfkRJQD1ZYAt1r+6uBfeF/85f6CFQuAnFowkhe1brVnfpUJ+0fDHvv7hRIJylkdyCYYwzb1CZ+/CKnr3TQiPKkxLSeX6UKLmNg+4J0umexVp7O2e+P9S+g55476IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713394942; c=relaxed/simple;
	bh=MjGEyWU6iRwQGLCvLbsauuSqXMR5IC0GgjI1b0nT/PA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XwzPFO5IwZ+fRVcTtZdyO9RtfDgIuoYpnYpDy9Gbem2QfLpmLtfeK1oDqqaZX5AidNm0e7oavk2AGQ3P3J5JpuXXcI2dktKbgSs9BD0z+cqINBLPfz3gZLSWZeUGtbLygk1UUH0easF9Ce9G02Y0Bwk0QaK1Pa902CXQc1Sk7Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0ZdFPFJq; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26845cdso474159276.3
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713394940; x=1713999740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5We5W+rsfzPdvXFTCnohAUBKzbHH6tan/Fy+crluqZA=;
        b=0ZdFPFJqlBL0VRUml2c3qUsAt9V6MhLzw8pN6j5zQaOrXMGbrX4aM2oqQqlE5jpg2G
         xSASIIqJLah1q6VUUsgImyV7kcxQLEQfM1XS1G3Ks9OtwiJilMloPJIw4wz9WPnpKOHE
         VL2G3y7yTWEGOJKpZkgePEv+4QKb5Z57d669a397Nw8dIgnbT103lLX8TUeCD6tw+re/
         DOCZ6zkxyaJQaRF4kVYrRuoeGv+8kJ4R5xPxmv1b/XOwb1HqdHUjTeFEcmfWAQVbjkYu
         yw0qf+IOfiu/hRNZWjWvDle+Wt0G3BTUz2TsWprjZmt/emWQYdkJ9tXirM+h+BWzwb/k
         RQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713394940; x=1713999740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5We5W+rsfzPdvXFTCnohAUBKzbHH6tan/Fy+crluqZA=;
        b=mhu5wAZJjEMPFWwC7EGrfBeZbRt6Qti51k9tI9qpH7WmZth2QbDOqcXEoZ4Q2mAg5n
         ZeWIjNBBTtKGSdL1teaa2vpFEWYjRUPqQrK/ax0+jN1XBZ+Z3TyM6k/xNFUR5cVmUrL5
         sU8zQ/ERUD06cDRAbgY5c2GQd8smUATvFvhDFMKePIBF5ks+biVBpAb7KW4V7Isd1qIz
         w0iwrl6jS6a5PRmHdF2nULwhGjtLoFqKkYsq+tGVVZuhB/axF6/oGnSmT58f15xRqxqt
         pYJU40JvfTC1mdzD6t+F77jKLDuRFphoUB+s5dxTdhQkiD4YcdjLw+0RfvPEAWGzpjLv
         Qdxw==
X-Forwarded-Encrypted: i=1; AJvYcCU8GfmNmSFDbrbZjbc2vSLFjvFc+UykNnm9zsX5xWXxCK+pF8fiuOV1wnpRb9uJSwElb6m5dmToUc33EqSB/G3HNOoy
X-Gm-Message-State: AOJu0YwDcpISHZYNJxlkO4tva+0aGEAC1MSKbjMnb8ucwLatNJTuRJ6u
	z7THNzkgPo1PF4o7g8sHRqjPilnXrpab0QqAaHUbA59ciFjRJE+HWZaAXFlYQ/15fFkdpso+FMZ
	o1w==
X-Google-Smtp-Source: AGHT+IERzpfBosJp5941x37Yo9n4uDrw4qeM+u1IpyiGpJYuIIdVxD1NzoxJcFf/f2t5gypae1skW2hucLw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1007:b0:dcc:6065:2b3d with SMTP id
 w7-20020a056902100700b00dcc60652b3dmr221743ybt.8.1713394940536; Wed, 17 Apr
 2024 16:02:20 -0700 (PDT)
Date: Wed, 17 Apr 2024 16:02:19 -0700
In-Reply-To: <20240416201935.3525739-9-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416201935.3525739-1-pbonzini@redhat.com> <20240416201935.3525739-9-pbonzini@redhat.com>
Message-ID: <ZiBU-3PlL4dp3nFP@google.com>
Subject: Re: [PATCH v2 08/10] KVM: x86/mmu: Pass around full 64-bit error code
 for KVM page faults
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.gao@intel.com, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 16, 2024, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> In some cases the full 64-bit error code for the KVM page fault will be
> needed to determine things like whether or not a fault was for a private
> or shared guest page, so update related code to accept the full 64-bit
> value so it can be plumbed all the way through to where it is needed.
> 
> The use of lower_32_bits() moves from kvm_mmu_page_fault() to
> FNAME(page_fault), since walking is independent of the data in the
> upper bits of the error code.

Heh, I prefer my version, which is already in kvm/queue :-)

0a5df50a2d6b ("KVM: x86/mmu: Pass full 64-bit error code when handling page faults")

