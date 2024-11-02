Return-Path: <kvm+bounces-30388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 814689B9B67
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 01:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E76881F2197A
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 00:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BD938DD1;
	Sat,  2 Nov 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="he55DuwU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78DD1BF58
	for <kvm@vger.kernel.org>; Sat,  2 Nov 2024 00:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730506120; cv=none; b=MT9u64YsDZUs/4fjc16n1q8OXTReOQhiQTns3OgBnmNAIa0ndwnn1jFoXKz2J+CNpU7MIBx6VbXqEIot53vAxEk3/ri3NpHzjyGoxHxRs2qyrpBmBO7b4RB6ZwvGtvAiKHDjAnXbGQh+3tEhK8UWCyQvOCk9cRuOKaDvJ1CmEi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730506120; c=relaxed/simple;
	bh=qPFYuz9BrK2CIqbnqSJdveevoaimtQftTkcT6cnXqi0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nPRoClL4PgSnXHYLbPNtvXidi9it8BjVadmMlTx11Vv5ZKodwfp2cZFIthFxslnGEUSjcnkYZOfGzxZvNypUc+ngnjBmibj9Eu0Ui6H5n5166QJwrfec0p3jsSUMyzxqYc48PNKTs91zbnSzX2SizkQAFMenboWi+bTRkQzALew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=he55DuwU; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3497c8eb0so33017637b3.0
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 17:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730506117; x=1731110917; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMflO0iOxZawpN5ZUgjewO0l15Uk7dsPv9bQCJvRKFM=;
        b=he55DuwUdUaFBDjvf39y10k+kx8Bksm2nGxi+fp5T2q283iHM6tE9acNq/cQDZKLd/
         FDXq5cdNFd+zsez0y0hR7e8arC1zGs9Eno5voH2qYYSRd/0OJyTz2jRsWTbf/HhabItq
         akMlkQ8T17qttIhgQEPjDA4qazs+QTEIdTdKMP+pB/ZWmW1pZvPPzzNBCjEgXzZ1fMVs
         MQwW/n91QTinpaLP3xjaDOiEeiWTSvAwMUOCybeGBfCQcx+Nju7fngb6ZIMSOvqzjfOj
         ym05lS/8rZ8NGcyvWUygzkFHdj+b9kEaB2gCjDfQN7jPLh/jqCPE8praiegMgqPaSmdV
         0Qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730506117; x=1731110917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMflO0iOxZawpN5ZUgjewO0l15Uk7dsPv9bQCJvRKFM=;
        b=i2YDCcIFs/1rYwbNHFabgqRUb3f4EMBTig0h5F3w1Rk3xtNQS0A0JJMYZvhC7Cc6pT
         d347/2qu2/pMxeo4Ruf+nOY1YwRJf3VdH+LIsrtNFroAwWFov9BmnAAdr5nhs9Bm9f8y
         bKHPK2tAr0N56LBCzD0+qVy1Y3tcyKf2YpoF+PN1E56YAOhj8ocliyfsVym1zCyZZSIa
         daV/Kc7bD2VAHoEWa7D9qzVvScvOLNmY2tdKOuKR0aVyf1+tVaUkJ4X8efVM5sUeYhky
         +PlNoob68VmCyU2SWjLfooVDEnIefP2ESm2GBR2Qkl16clpfB7XTrI5DQN4tNzoX/6uk
         Tx5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXAKILQ0oPtsD8vinxrSSHd1KpMLgO/sIy3eMh3r1m5gd3SZUz4aAPtdAczakOzSomfm9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUsXVYqW0uS92fJxrT0S4RiDfOxaycJGoCeHaD9AhfytqaGjqA
	ZTbqUzn866pOr9Vlm2sqhJ3s1FK53qsk6JQwKBUx7Q17lYlpdrTHIMRX0nB9tNoRAjH7vsfKc3N
	2Z6lr//XsGTXDQ6+Hnh7i3Q==
X-Google-Smtp-Source: AGHT+IGk0DQ4lZzrHSF/msR4LceTfpO9UC2r93MoAUGhrBvpkJQaqubi60bBsN9z/YYJPlV+RQpFn5dca8i1rnQL/g==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c9e8])
 (user=dionnaglaze job=sendgmr) by 2002:a05:690c:6711:b0:6d9:d865:46c7 with
 SMTP id 00721157ae682-6ea642ec3camr940447b3.2.1730506117249; Fri, 01 Nov 2024
 17:08:37 -0700 (PDT)
Date: Sat,  2 Nov 2024 00:08:14 +0000
In-Reply-To: <20241102000818.2512612-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241102000818.2512612-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241102000818.2512612-5-dionnaglaze@google.com>
Subject: [PATCH v3 4/4] KVM: SVM: Delay legacy platform initialization on SNP
From: Dionna Glaze <dionnaglaze@google.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dionna Glaze <dionnaglaze@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When no SEV or SEV-ES guests are active, then the firmware can be
updated while (SEV-SNP) VM guests are active.

CC: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Ashish Kalra <ashish.kalra@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: John Allen <john.allen@amd.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Michael Roth <michael.roth@amd.com>
CC: Luis Chamberlain <mcgrof@kernel.org>
CC: Russ Weight <russ.weight@linux.dev>
CC: Danilo Krummrich <dakr@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "Rafael J. Wysocki" <rafael@kernel.org>
CC: Tianfei zhang <tianfei.zhang@intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>

Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f6e96ec0a5caa..8d365e2e3c1b1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -445,6 +445,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		goto e_no_asid;
 
 	init_args.probe = false;
+	init_args.supports_download_firmware_ex =
+		vm_type != KVM_X86_SEV_VM && vm_type != KVM_X86_SEV_ES_VM;
 	ret = sev_platform_init(&init_args);
 	if (ret)
 		goto e_free;
-- 
2.47.0.163.g1226f6d8fa-goog


