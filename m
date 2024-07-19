Return-Path: <kvm+bounces-21994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19053937E44
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF3DB1F24B9C
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 23:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF3E6FD3;
	Fri, 19 Jul 2024 23:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wu/yZEyw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6E9A35
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 23:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721433329; cv=none; b=qe6cP4SFmDvbUAxHI9grG/RuCM+ZEw8QhTWrrK9Lbqh0zB//pCyHOQI9PKkuqZ5msBSPGCFFg4ha23hSfSW3CN9JAY3RjNMPeRUFU0ueUsxW/GT1RDHHMdBfkcxOjZIMSLjKMQWds5BZfuKjZYi3TM06xmti22qgtE6wX/E8C74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721433329; c=relaxed/simple;
	bh=YGhXmPRb9E5yw5phwhLZb5C5ya7AuLksV9ngTWigj8U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PdklaPN5GEiOS9fPwmOttNIXA9H9R60Vqgv8ZRfD8CDixMQ6ndMREUWIGpwgETRtXYZICqFt5xtau09Lj4Fc5Asf6Fr4jx6Rj2/DDpYdPYHMfH/slgEC8Uhfq7rcdDI8Ox7YDTdKZkK2jseSVmq39/TKEXke/eEc+zKE85JiVLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wu/yZEyw; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5c667b28c82so1111162eaf.1
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721433327; x=1722038127; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9HIj0M6C0s0y+JKlqlI7I6keP+bHQVc6RasllVrdKs=;
        b=Wu/yZEywit2cOwQkBu1Ml0fPqaggUtBQy7kB3Dze6f2EagyD5GCn6hV619odfHrXlK
         I/bgqwM800f1UNt9XIikXD75UdTU4R4VBjoCWwu2cbWJKLyzSUlEKvrWe+2mQigHEpq4
         MAbl2tzZNtJm9A2XBS7ADuelfWo0QOwUj66j6RegCbakEVmLTwiEGeWfvxDms8zI0351
         /ikd8fSzYdO4VjqjnYKtJSmO8uUxwGUQ48sDTGTFK9F3ixrDYML1LZOv6tg7egafFycj
         +CDQlNj3KfuUVQB8hgm4RI+6BpHoY+TlAzw4olx6aFwiwFPqzuAtP06wIwFZfAqnsrtz
         sekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721433327; x=1722038127;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L9HIj0M6C0s0y+JKlqlI7I6keP+bHQVc6RasllVrdKs=;
        b=g/DqT6yfXwalDK4u4fEeBM2iM7tvI3x22Ah551/wHZKciT+heBnKS+J5X/G4uM9nBm
         OGFjYQ5rODOwFBviuoEAwIvH8k7XG45XM5wljIk2XaBMPJFESZTAy5WKu4EuniWurS06
         2sps6UsUQRQpxWQS19eGaD5j7nzqCcfYYeCzHamBiw7ENEgGuBcDtP/rpFJT8oRyodK1
         GA7BsXnWNEkZ3ACsN244ALRrNZW7Mzz1l9Rc8Uxpp4DfapdB+ALZL6kLIczXhPbvb5SH
         IQ3nlxHVWn1QXq5Jm9WyNsul/Evdz4X+bDIpV7f8Ww7nAcND9gr5x0fLHZm+ZbofcduW
         hAXw==
X-Gm-Message-State: AOJu0YxltO8dqTvPtHi8WreEgvwo3QP3rlV9EexzTulCmP6FQW0NgIve
	z+tm/p2AIjxmTFvwjraI5l6Iu+KoTHXJdAVcaHze7EJ9IGe75NSkFAV5f+7c/ZE=
X-Google-Smtp-Source: AGHT+IF59StVrSx/HovxKAbdr8HlbnsnwRIkaBAT/Mo9IyD4gK8AjyDyk9b0i0H1PK9BKsO+RvZndw==
X-Received: by 2002:a05:6820:1e05:b0:5ce:3ccb:2118 with SMTP id 006d021491bc7-5d564fedb98mr571111eaf.3.1721433327328;
        Fri, 19 Jul 2024 16:55:27 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:739a:b665:7f57:d340])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d55aaee1fasm407538eaf.42.2024.07.19.16.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 16:55:26 -0700 (PDT)
Date: Fri, 19 Jul 2024 18:55:24 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] KVM: SVM: Set target pCPU during IRTE update if target
 vCPU is running
Message-ID: <d28f5bbb-14ce-455b-be75-a079f28eafa8@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Sean Christopherson,

Commit f3cebc75e742 ("KVM: SVM: Set target pCPU during IRTE update if
target vCPU is running") from Aug 8, 2023 (linux-next), leads to the
following Smatch static checker warning:

	arch/x86/kvm/svm/avic.c:841 svm_ir_list_add()
	error: we previously assumed 'pi->ir_data' could be null (see line 804)

arch/x86/kvm/svm/avic.c
    792 static int svm_ir_list_add(struct vcpu_svm *svm, struct amd_iommu_pi_data *pi)
    793 {
    794         int ret = 0;
    795         unsigned long flags;
    796         struct amd_svm_iommu_ir *ir;
    797         u64 entry;
    798 
    799         /**
    800          * In some cases, the existing irte is updated and re-set,
    801          * so we need to check here if it's already been * added
    802          * to the ir_list.
    803          */
    804         if (pi->ir_data && (pi->prev_ga_tag != 0)) {
                    ^^^^^^^^^^^
The old code checks for NULL

    805                 struct kvm *kvm = svm->vcpu.kvm;
    806                 u32 vcpu_id = AVIC_GATAG_TO_VCPUID(pi->prev_ga_tag);
    807                 struct kvm_vcpu *prev_vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
    808                 struct vcpu_svm *prev_svm;
    809 
    810                 if (!prev_vcpu) {
    811                         ret = -EINVAL;
    812                         goto out;
    813                 }
    814 
    815                 prev_svm = to_svm(prev_vcpu);
    816                 svm_ir_list_del(prev_svm, pi);
    817         }
    818 
    819         /**
    820          * Allocating new amd_iommu_pi_data, which will get
    821          * add to the per-vcpu ir_list.
    822          */
    823         ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
    824         if (!ir) {
    825                 ret = -ENOMEM;
    826                 goto out;
    827         }
    828         ir->data = pi->ir_data;
    829 
    830         spin_lock_irqsave(&svm->ir_list_lock, flags);
    831 
    832         /*
    833          * Update the target pCPU for IOMMU doorbells if the vCPU is running.
    834          * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
    835          * will update the pCPU info when the vCPU awkened and/or scheduled in.
    836          * See also avic_vcpu_load().
    837          */
    838         entry = READ_ONCE(*(svm->avic_physical_id_cache));
    839         if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
    840                 amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
--> 841                                     true, pi->ir_data);
                                                  ^^^^^^^^^^^
The patch adds an unchecked dereference.  It could be a false positive if
AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK implies that ->ir_data is non-NULL.  In
that case could you just send an email saying "this is a false positive" and
I'll ignore this warning going forward.

    842 
    843         list_add(&ir->node, &svm->ir_list);
    844         spin_unlock_irqrestore(&svm->ir_list_lock, flags);
    845 out:
    846         return ret;
    847 }

regards,
dan carpenter

