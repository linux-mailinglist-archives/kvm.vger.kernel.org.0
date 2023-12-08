Return-Path: <kvm+bounces-3950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE50080AC9F
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 469C7281AB6
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 19:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D43A1481CD;
	Fri,  8 Dec 2023 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eQ91siv+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEED10E7
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 11:04:55 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5de8e375768so12666487b3.3
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 11:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702062294; x=1702667094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FaBQJ3hZrcjmPrQd+jYi6U6TZUHaUJywmO1UrbOss5M=;
        b=eQ91siv+hX7ilCV9ttVUa/8Tyn6DZbtImV8yXBBkLkZ4IUglr9vTVD0Bca8ehUmgq2
         pZr0CJVEZ8uWG1ygf92MZaEC6fdALCF3dhXMpe3UsAw/1jfL2USydz5OyoT3mynlhZVr
         XoXk9lhggC8Ie1V5p6EaFORDczsE8+HFkNxkUMlJoli/gL3i46r2/O/mM238v+Rr2kb8
         +7A4vgZppJGF/DUsNi3EHbTSLKuFMQdbucjRBoTeC0Ovh05JPq7V1CqZjsSjywMpETHF
         8j+k8HCSuMXTuHYmnvkUJPbhrM/G8VLrGmsLIy4c4HUB++3OCTONniPy84YMKh9MsOi4
         AY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702062294; x=1702667094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FaBQJ3hZrcjmPrQd+jYi6U6TZUHaUJywmO1UrbOss5M=;
        b=nqB2FzTN5gRnZmO8p20/RmJPN/gv4gFuHuYhYw66qMzwLePzQOUa/6RSocyfFW8hdk
         Bdy318owLFnuo7DUcPo8AJDdr70HHqPNvgBfYtqN1N42wg1d/JEwsolxTliFoKZ1nYxM
         Ao44SjymVJRIhkj8EXfYaams7JXBVLXUuS3Sl/i0klJ1IC8oW/zAZscADb6q1oUQEGPN
         Q9yq0YtmTT7mFnX3Y0aihrR8W0aOlkkeVoL5gZHqoIyaCt4MvyegdOHf9f/YPcdp9aGz
         8SRqQtzkY41EJJtm4hu05i9wOVUZdu6LnCvXeOjjR21tRMoY3RVS5F4MrRkt0A7Ojyhl
         P4Bw==
X-Gm-Message-State: AOJu0Yxpp23qimdIhsFCCbnmDz7eMiAiD4GpPcQHLlw/fQC7p6gr1IvC
	dEcXoHg947l2MUK8tXioIDJx4COCY/c=
X-Google-Smtp-Source: AGHT+IFbZkBjd3HF6V02hYYKfry86AYCnPZiPrBQt5m0oHmgAQfsetl9n/CXi8Ziz13kkCERMT8yZ6+2s/4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:338d:b0:5d6:e473:bf60 with SMTP id
 fl13-20020a05690c338d00b005d6e473bf60mr4374ywb.8.1702062294577; Fri, 08 Dec
 2023 11:04:54 -0800 (PST)
Date: Fri, 8 Dec 2023 11:04:53 -0800
In-Reply-To: <20231208184908.2298225-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208184908.2298225-1-pbonzini@redhat.com>
Message-ID: <ZXNo1Rdla2zghM9s@google.com>
Subject: Re: [PATCH v2] KVM: guest-memfd: fix unused-function warning
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> With migration disabled, one function becomes unused:
> 
> virt/kvm/guest_memfd.c:262:12: error: 'kvm_gmem_migrate_folio' defined but not used [-Werror=unused-function]
>   262 | static int kvm_gmem_migrate_folio(struct address_space *mapping,
>       |            ^~~~~~~~~~~~~~~~~~~~~~
> 
> Remove the #ifdef around the reference so that fallback_migrate_folio()
> is never used.  The gmem implementation of the hook is trivial; since
> the gmem mapping is unmovable, the pages should not be migrated anyway.
> 
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

