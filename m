Return-Path: <kvm+bounces-3081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 405028006D1
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 10:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEA6C28196B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 09:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF4B1D52D;
	Fri,  1 Dec 2023 09:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="OWpNbHY0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583CFA0
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 01:26:20 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40b27b498c3so19725035e9.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 01:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701422779; x=1702027579; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjnUIjZvPfyuyaADWQAn6lsAbXJm4+j0sZmUamispe8=;
        b=OWpNbHY0FUpRYTbYrSygzSbCao+y54Bs2lrUt9XCKsdY9ZZaDpC1SafnCe+Hxcp2Jy
         0nPuDdeYirFjD5EpHxjnEvTEL1FgKv9XQY680sDedQnj3+XCf7EcDQXR+TujDX51BkW4
         ycPYcdpXHFJ3m81/uVkdyI7/maawh2xtx7qFWKFaV4gLXJCQ+mnoeFExTL2pFILvytSH
         JxptHNkutd8tEQSsJQgT1uI1N7VTLgCzl4Nm9xQGO4F2oxCZ8ac60nASJGJ5JLd89mc5
         kccYiRvdNIZTihqdkv5WAlK77BB6oSM1ZfqG3cDO7cK6CcIzDhX4GJzPyNMoyhZ+kGn8
         6qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701422779; x=1702027579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bjnUIjZvPfyuyaADWQAn6lsAbXJm4+j0sZmUamispe8=;
        b=WAmRGRppXHgF/XcdpXiSd7E6WIEcmghExIujaBtLHkVLhz3z/jxig2KlJ2jpGrNhb1
         Eu5ha50kw5zve7GT6epPqUiYCTNyBk9Z2bNpxE2IPBCfSZzBZ0y2O0gJsEk1IzJ18ajP
         wxWl90SXKt2qZZvVX/EtZycUDiIc6/NILd6qME2FHhROQIQ1eyZO95hgeC6b4biekEM/
         HOoO8G04wjfpZhuxzN8s5Vc24vMSuKLLUTM3hbRJXMw5rkgf521oKOUpjQOfJwpNSEzi
         fRVxpETvd21DcnXZexLodq3/7GqQK00TES+uoLiTmd8x2iSm0ap9b47nkESzLb1Tl/F7
         JBzQ==
X-Gm-Message-State: AOJu0Yxk+5rS53igWUgSEFv+WOIgFPPxEYfke1AZuJIy8kVZa7+yWDNq
	ewG386hgmPQxFPycmsPkzkgkFQ==
X-Google-Smtp-Source: AGHT+IFqzSTcoNxST3FhOHCG+Us/Epbb855+4fIW887wnW7kaEu5A+g3d/FtOLxG6on8h/bTU+QRLA==
X-Received: by 2002:a05:600c:4709:b0:40b:5e1d:83a3 with SMTP id v9-20020a05600c470900b0040b5e1d83a3mr297560wmo.55.1701422778732;
        Fri, 01 Dec 2023 01:26:18 -0800 (PST)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id bi19-20020a05600c3d9300b0040b54d7ebb9sm4688580wmb.41.2023.12.01.01.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 01:26:18 -0800 (PST)
Date: Fri, 1 Dec 2023 10:26:17 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
Message-ID: <20231201-08a259a1ef0bd02eba0c550d@orel>
References: <20231130182832.54603-2-ajones@ventanamicro.com>
 <ZWjfjAnZcomGa1Ey@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWjfjAnZcomGa1Ey@google.com>

On Thu, Nov 30, 2023 at 07:16:28PM +0000, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Andrew Jones wrote:
> > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > in an extra one being output. Rather than remove the newlines from
> > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > the other callers, as __TEST_REQUIRE was the only output function
> > appending newlines and consistency is a good thing.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> > 
> > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > MAGIC_TOKEN change)
> 
> Heh, and then I went and created a conflict anyways :-)
> 
> https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> 
> If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> MAGIC_TOKEN conflict.

No objections from me.

Thanks,
drew

