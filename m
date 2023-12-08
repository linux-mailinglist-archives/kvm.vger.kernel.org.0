Return-Path: <kvm+bounces-3922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3AEE80A8A5
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 979D02816A2
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 912C5374E0;
	Fri,  8 Dec 2023 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qGS4TmoY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A44C1997
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 08:21:14 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1d0b944650bso14883205ad.1
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 08:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702052473; x=1702657273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn2js7FD63PZPF5/U2hMAUmYqMluIo8bm6m0EGWnrq8=;
        b=qGS4TmoY9gPpC5+oOBgbzik/oBUuVsjqWviOS/YVQOdiL1QEWoKLdDXb7kbKeA+6xi
         EcFpg1+JrRUdHhqp6YJ4Uf/yoBEn51RNjghzDZZPtaJNitLsyNHm/oIFngU7ItCtUUXy
         3EtiqdBG+lL5nqKiwSOb2CATFZgqjYJr4FAlYIQFUWdEoGcpwWu4WICDfwiVaxB9gGTW
         pWPnr2vE0cK26rYSMWJGH3B4jVFmdPP6Kqw1bLa9hiQ5asORfbSf1qHP2s4hpGTBEtA4
         N9ejwWw/e3vjSSXmQg4gFPYWbd2xbppQyeoZzG7AT9KDQM/efhmYkOphgxV38eOAFPsr
         87VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702052473; x=1702657273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tn2js7FD63PZPF5/U2hMAUmYqMluIo8bm6m0EGWnrq8=;
        b=rQ+fs9sXjxKkXvqLgZ1kaYSFXX57RY763BSRlUPe7a2bUlgbGd4PsOcadOz7kcpxxr
         uLYZaQdk6geW/nRdzrmalCjiVN3SDiz3QVzHZCaxPWaC8m+s9BgBJGuIAUTMB29oKIiO
         FwhEyEqufwHuL5sRbE9WccZL+JzibxASwcbyVJ5+mMAYRFXk74AOOnt+Q8wm4Ir8v4JA
         528NVEZk6eFvkyGKVgE+5ma+IGvWfdn996A5zmBI9E+LtdQiGiCIOZFyeDutpwBdmSHA
         +DkL7Uan3uHrSVmr/xNjOc+rVpsLt8MPhrRpsmWSeAXNZxlmwl+msiOjqXV5KPnvvqP5
         drSQ==
X-Gm-Message-State: AOJu0YxEnBMRer7GlSZBLxF243Hk/y/rdgvINpQdq4+L8+svtMNXl6yu
	A2jmZ4byitEeTip4GDuFUI6jQHAy/AM=
X-Google-Smtp-Source: AGHT+IFWQtVJ0r4eHGvVtUIeVYSgkmqQlzHfiGMIkd/nLI8qwI88lt5tQTOe7hJPAwvkVngG53ghJy8eGhM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e804:b0:1d0:c2be:3d9d with SMTP id
 u4-20020a170902e80400b001d0c2be3d9dmr3772plg.7.1702052473502; Fri, 08 Dec
 2023 08:21:13 -0800 (PST)
Date: Fri, 8 Dec 2023 08:21:12 -0800
In-Reply-To: <20231208033505.2930064-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231208033505.2930064-1-shahuang@redhat.com>
Message-ID: <ZXNCd5UKYS_90xAD@google.com>
Subject: Re: [PATCH v1] KVM: selftests: Fix Assertion on non-x86_64 platforms
From: Sean Christopherson <seanjc@google.com>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Dec 07, 2023, Shaoqin Huang wrote:
> When running the set_memory_region_test on arm64 platform, it causes the
> below assert:
> 
> ==== Test Assertion Failure ====
>   set_memory_region_test.c:355: r && errno == EINVAL
>   pid=40695 tid=40695 errno=0 - Success
>      1	0x0000000000401baf: test_invalid_memory_region_flags at set_memory_region_test.c:355
>      2	 (inlined by) main at set_memory_region_test.c:541
>      3	0x0000ffff951c879b: ?? ??:0
>      4	0x0000ffff951c886b: ?? ??:0
>      5	0x0000000000401caf: _start at ??:?
>   KVM_SET_USER_MEMORY_REGION should have failed on v2 only flag 0x2
> 
> This is because the arm64 platform also support the KVM_MEM_READONLY flag, but
> the current implementation add it into the supportd_flags only on x86_64
> platform, so this causes assert on other platform which also support the
> KVM_MEM_READONLY flag.
> 
> Fix it by using the __KVM_HAVE_READONLY_MEM macro to detect if the
> current platform support the KVM_MEM_READONLY, thus fix this problem on
> all other platform which support KVM_MEM_READONLY.
> 
> Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags")
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---

/facepalm

Reviewed-by: Sean Christopherson <seanjc@google.com>

