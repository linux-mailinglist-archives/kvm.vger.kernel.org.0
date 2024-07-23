Return-Path: <kvm+bounces-22132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCDF93A868
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 22:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 970661F248DA
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 20:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A157D145358;
	Tue, 23 Jul 2024 20:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tmVQCXjI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCC4144309
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 20:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721768238; cv=none; b=ZeJBVDuwdGI83bzXIVvsvqkpyAHvOMyDxbUOCgHtOQz6xvKpqHA3j7m14QjKDZAUdUMrAGvCkq8KF+xCKxsfAMzOSGLN9NrxH12OzzWo8wrx2Jy8dyMMm83syKC2eSCfwJR19TBiFY5mBpoa7I4kcUjnmqUVghdPlrKtZdjJS+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721768238; c=relaxed/simple;
	bh=4T4Y/ahuIFxvN3hIa12yx4/KmF8PSrzOgG04njrmpD8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=X8lV/PKxSCzVg0px41MYyGTHGv6E7ZnaouZ43Ou9l9ZazrG/MMuWZv44HH7mGjItKIkveIWLIxT0EKmgm3OiBqXj3eyMJusVrXQ0vNJ4m/3QaKcF5pKjoGAWLTSXFNGRQGWnjvfjtK7RYuskb2OC2+JeoL+MxLIwdE6w5vIxCmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tmVQCXjI; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-708b273b437so3233832a34.0
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 13:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721768236; x=1722373036; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r44QZ8+w1nidH1ujLT4M3R1mzBATcx+GmQkqk92Ndxw=;
        b=tmVQCXjIDhWMgNbgPx02Cgb+4Yg5RZZqii4wA3b4c9mZ9xac1V9ODYCuQJ1R5PF5ms
         JVHxlMHyUANpYXNrnKTMAz/n8bP1ikxwN2eewPwsUFUUXHzMjMzVrmVbsHsnZt+qd8FW
         ynqL5qJu0WrYKFYInc3V0vvnn7s5zYxeUrgKfe2oWmutjNkOTI6v9ytVANJ9MXyqF1sd
         na5l66jzfsrxnOIbib1zWVrU/SQGhMFMEB8DPlzLdYgrqclWSIOpUumVAJL5vH7802oo
         UN1jmwk+0Av8fHcakA7y5h9xcc2/P2vyh84vmPNCQ5Ca/+aLyzbKKKsZf3+ojhvnfe0j
         7XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721768236; x=1722373036;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r44QZ8+w1nidH1ujLT4M3R1mzBATcx+GmQkqk92Ndxw=;
        b=v2Q6a759nttb9BEb8DKTstjGsdlaoYrynihCalM7sSeqVuDgRLO2aH/MdSxM7KDXan
         smyQE03NTZZmn5H1pgcXNrkpcmYEONrP4zhvQyxVq4qY7Zs5BFDSwbG1rFly12TBA5yE
         PsMj3D7ylyv224rtB9F0KUA/9Yo2XYgBap0u0pIJB0tWsPiGO1wVRkLXn5WHfTdhkeQa
         9XO4zQET8RbiYmHNnyeErDgf8PMBWVws5I9QiK3OdnON1/p9IEmD/8DZdgGUT6L+C3M3
         hvgQ0DQOaRpeKtDKWXceoY3KN2WAQWy3YDSwRz5cBEwuDUpEq2yeflYgHQic+X4yKbl7
         sObg==
X-Gm-Message-State: AOJu0Ywxvd5d27fvh56M38Gax2IUpJ7A6kc5E23wItN/a7RTz7YpjxCR
	w5UpNY2kakWnrWXSEKgKP9+1urPH6+0iVNBiWkOOnNKSNxABd59DiKEgS+//ebTb/s43hjKRuys
	OSgE=
X-Google-Smtp-Source: AGHT+IGCn67cdA1Y2MGWGroqT84iL/PwfGTeoxloI7R+jnJo4tClnrSCdqC6cwEniEEjDmCCFocKhg==
X-Received: by 2002:a05:6830:2a15:b0:703:6a50:9091 with SMTP id 46e09a7af769-709252b8a6bmr164521a34.8.1721768236174;
        Tue, 23 Jul 2024 13:57:16 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:bbf0:72d7:a27a:93ce])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60cafccsm2187683a34.29.2024.07.23.13.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 13:57:15 -0700 (PDT)
Date: Tue, 23 Jul 2024 15:57:13 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Brijesh Singh <brijesh.singh@amd.com>
Cc: kvm@vger.kernel.org
Subject: [bug report] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE
 event
Message-ID: <11d9ba37-42cf-432b-81df-380b4605b15f@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Brijesh Singh,

Commit 88caf544c930 ("KVM: SEV: Provide support for SNP_GUEST_REQUEST
NAE event") from Jul 1, 2024 (linux-next), leads to the following
Smatch static checker warning:

	arch/x86/kvm/svm/sev.c:454 __sev_guest_init()
	warn: missing error code here? 'snp_guest_req_init()' failed.

arch/x86/kvm/svm/sev.c
    443         ret = sev_asid_new(sev);
    444         if (ret)
    445                 goto e_no_asid;
    446 
    447         init_args.probe = false;
    448         ret = sev_platform_init(&init_args);
    449         if (ret)
    450                 goto e_free;
    451 
    452         /* This needs to happen after SEV/SNP firmware initialization. */
    453         if (vm_type == KVM_X86_SNP_VM && snp_guest_req_init(kvm))
--> 454                 goto e_free;

This feels like we should propogate the error code from snp_guest_req_init()
instead of returning success.

    455 
    456         INIT_LIST_HEAD(&sev->regions_list);
    457         INIT_LIST_HEAD(&sev->mirror_vms);
    458         sev->need_init = false;
    459 
    460         kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_SEV);
    461 
    462         return 0;
    463 
    464 e_free:
    465         argp->error = init_args.error;
    466         sev_asid_free(sev);
    467         sev->asid = 0;
    468 e_no_asid:
    469         sev->vmsa_features = 0;
    470         sev->es_active = false;
    471         sev->active = false;
    472         return ret;
    473 }

regards,
dan carpenter

