Return-Path: <kvm+bounces-40323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0254AA56407
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 10:35:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 50AD93B0412
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 09:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C002147FA;
	Fri,  7 Mar 2025 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vz+90Hi5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3C420C47E
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 09:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339931; cv=none; b=u0zQjY5QjDu6omecDrAUGSm3nPNI2+kc0aS3HwHv4in0NdNO7UVxGlMp6qYBkmvgeGaRGkPzdu3M7Def6H4qo0onx6in+J4W9/82jai9aHFeDDGuEkcxrejFEws56R5/ANlYlppN7zYf7YV1UU5b8CLFTTjGYnnnkX98ev3YiSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339931; c=relaxed/simple;
	bh=UYX4cO0FWTOBk4ku65COnGTG++Uo9Jm4Yr4n/u0s/Dk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HnZ5A2YK687Woo3oHuGJWF4fS3+OHMgf/UmxRmS819ORflBUBv/CLy+UK6kieU1FXEwLD6L5pfCcG+r2+9JIUX/5+MQ6WbJxiVzVyo9Szn3+8b90DGUciCEnOzVm6B7Oie5J5EsmiC0adl9A1v0iK4IbNb1kPqrptSSgySwSgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vz+90Hi5; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43bd87f7c2eso9078475e9.3
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 01:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741339927; x=1741944727; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=maWqOAK9ITN9fg36l0lVK+mxGEE7G0VpPgh4/IlSq6E=;
        b=vz+90Hi5KhL6dduqNLrkW9wzls1EPcE9ifCG0+bzJaNudI08Uw2nYvAXQ33xH1kaMk
         YXusp4I0wFRNNuSUQ5g2YFFrrOf6g4knnT/YaLuSV4QilSZlgRmOLfB46lT+icklrvsF
         Q1P4UHaQOjBFPYDEURJZ3bLRsePZNfTALGVeKnOJrvS4+dU+joodvtraafd3I+S+qIhI
         qQOjcgP2D5mbsI+9ZC6yX6lWFPDyc8zFz8ApFGdhDKMYLdta1EVucv+cU3uewEifaQzE
         rFlmzkZye4Ue8Oegw1kOjNvsk95QQb/lYHwLPVFjSzFlDknKWOUZVkZJ6AA4ccQDqCnO
         BWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741339927; x=1741944727;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=maWqOAK9ITN9fg36l0lVK+mxGEE7G0VpPgh4/IlSq6E=;
        b=ilO8HQnTYSFwW+z0vZFnbg5gRfDXEDRrpPaVTpf0w1GhAztYzdcUFDkv0NoKu1fY+u
         okFq7EIZla/Z4SkBq31dXfybeRTc/9tbVVz3AqaXkKqNU9ofilINZLD/mZcWIwTNXl4L
         LdHEDGUOohDyWVBh1zmDHg/gElUxGCWb1gUnW5Z5vj0+HQYB/Tnslo29MViIsBdIVYGZ
         bcBupsT3z3lOMsrt/tQx+bGzDHeEqi4Dsv8ef85ZIqB4osePypMrw5ZCY3mSpIN+611A
         X8rZtcI6Rj3AQFuIUMy+09oc30qVsn5pfGaNtpbo8tGbhh4YafIm6ekEbGybPiGXPKjl
         GjLA==
X-Gm-Message-State: AOJu0Yy86IFTtc5LWyBIrKraIUhiJIoXtwT/VeFFNZiOcx63Zv7bfJbg
	MuUGzuvf+ConIwYrW+mSHWZLpY+Xa84uDwIbIQN8q9kV/bdamiLenpQjNtFFJ5s=
X-Gm-Gg: ASbGncuN4tnRRdq6Ak6cU9YCortpVTXe38AKcGdVDbVn+yV8exqNzH5kNdxIfK5WGtF
	fOkcGAVgKpI2OYkygIpcgDE/no2n3xk/xwcC8fqiU9ixDtYa4bVETr3OKAjQMXy9CtQYcu7RzuP
	2CEpO2C6bBucocqBIsOQfGbBdfYr95ui48+Jo5SbuVwwKPOBBamYP/vLI3uDCvMtNVxbfLnIhMt
	giTGVDhthEK1uVo1uKdtPRXnYm7jdguOWPpscLgwVtkhsTCWwRyo3eSoASTFmmcC8BujkJoqC4L
	lu0n3cBd+sk36uoA8zAJXscKq/o3hoTZEmxwZt0NFVIeAinY0g==
X-Google-Smtp-Source: AGHT+IGvfiSw+lpGYO8YGvI2d9Dv4644pOHAp4xw1uRxsi0Rl3L3FeloaKJR1YOhcV27krR6gAFlzA==
X-Received: by 2002:a05:600c:3591:b0:43b:d04a:34fc with SMTP id 5b1f17b1804b1-43c5a6017c7mr21062515e9.11.1741339927492;
        Fri, 07 Mar 2025 01:32:07 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43bd435cd8csm75685275e9.40.2025.03.07.01.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 01:32:07 -0800 (PST)
Date: Fri, 7 Mar 2025 12:32:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] KVM: VMX: Use GPA legality helpers to replace open
 coded equivalents
Message-ID: <44961459-2759-4164-b604-f6bd43da8ce9@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Sean Christopherson,

Commit 636e8b733491 ("KVM: VMX: Use GPA legality helpers to replace
open coded equivalents") from Feb 3, 2021 (linux-next), leads to the
following Smatch static checker warning:

	arch/x86/kvm/vmx/nested.c:834 nested_vmx_check_msr_switch()
	warn: potential user controlled sizeof overflow 'addr + count * 16' '0-u64max + 16-68719476720'

arch/x86/kvm/vmx/nested.c
    827 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
    828                                        u32 count, u64 addr)
    829 {
    830         if (count == 0)
    831                 return 0;
    832 
    833         if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
--> 834             !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
                                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Do we support kvm on 32bit systems?

    835                 return -EINVAL;
    836 
    837         return 0;
    838 }

regards,
dan carpenter

