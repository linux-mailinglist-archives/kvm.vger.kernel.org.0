Return-Path: <kvm+bounces-12026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C2D87F2C5
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C097E281A26
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 22:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0365A4C4;
	Mon, 18 Mar 2024 22:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hs1/DWul"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD67959B55
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 22:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799287; cv=none; b=jCyMOMwsWqfv43bcZXDeYmDm7IATN1P/lmSIRy5970Kj9wCc/743ZkgDFq0iZb2gBtMK7Ua9/dRKXvZ3KBfrQ7oXKleuONO0E7WXafRHRb7hA5WocImsdlvzL+pLHF5PzP7ftWPGydo+y/tbNbKioA6q3qsHZZm6o1kVoIsdiR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799287; c=relaxed/simple;
	bh=7EdK8NAm1pxBaAUpg57HenZat5hfoEYA3UgL0477Yf4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WnuV8LbC6oViK9AdBcwKY6h6kbG61c9ner+FAbmAiZTFiugSazVHkfF24bGfTFd0DDvk1gytr77nvV6RBo8D0PDlJQnJ2+hWrRzFW/aehTeJh3HmTduf8f5g1ZrUDbmYkN6myYXj23kesmkVnPZs0kUS+FMvONrDB/bWCY7gtUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hs1/DWul; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710799283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfZZXfR1kSbJWAilZOdtsf7QJvf/A9npXvRYhQ2sZZc=;
	b=hs1/DWulG93uSw5BDMUjpNFSeaPOzr8ce+G3iJgnWbpUSJMx+8MMBskmrZSXkmtS2Wvq9V
	hHjb5KqnkK3p79jOjaM5FZz3eUNGMRUSa10s9NzcJ3aPFZ7wCA57jAlTb6gUUybMSPgXa2
	fNO7p2nZvL11LGcDJcKKhp/K2EODG0g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-KwkG3CaIP0-cEAmUn6vfBg-1; Mon, 18 Mar 2024 18:01:22 -0400
X-MC-Unique: KwkG3CaIP0-cEAmUn6vfBg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-414105984aeso7783135e9.0
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 15:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799281; x=1711404081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bfZZXfR1kSbJWAilZOdtsf7QJvf/A9npXvRYhQ2sZZc=;
        b=gnyhF1+G/La39j/wHomzQjL/zewBWqYOS//C9caA1UF1G/AruamFHnv+hsP/EVg49x
         2D0HQycpxEuxPLHr7reXSMOPPTpe9fk89tep+XWL/2YuVFncoRu+eyIoLY8nXcF6D0ag
         DE3lf5M85lsVuI3WagPKtRCkDAQryfQ4aa4fjd3Oh1fCpLVqC1Q/e3rVEO09eveAxQC9
         2vArNGeYZJjTW9aX5CRagUAXetdBgKyWyqAUDGl1rXDf6DhGXASEPk+0fy5qxxX60qVc
         eQyYH+mzfatBMVGxf1P8zhlTT2ZFmong+LhANYRY5JNr89vWKxdL8mAYIG2c2qsyZ39y
         Tzvw==
X-Forwarded-Encrypted: i=1; AJvYcCVkUDNrl7Ovyt00L6b9OASXUcrsvxzyHp6pMXs3wnRrqt36YgEXz5yFM4g3D/EU07nCl5Sc4d4KoUHsAs1sHVWsTTSJ
X-Gm-Message-State: AOJu0YxKTpU/xm+9FZlmrA09AT/iAofiii+OQ83XE5FEag8mikYwLZUn
	I0j0FnIYG8wb/muGYTjJr432FYhT2sfOyT9hzowvExgqIQRXuG0GURbvT3rNPSUYTUQKCggjKJP
	IIW+RGyOV2KaBIMymHl+Mj/FpaBzj3bEnRuQt+s/D0AWjGyWpviyF8uMCXaxdcta1eIDGk2L1He
	SCcSnp1DTDdkxb1FX5gZILxFaG
X-Received: by 2002:a05:600c:314e:b0:413:ee58:db7e with SMTP id h14-20020a05600c314e00b00413ee58db7emr559870wmo.3.1710799280954;
        Mon, 18 Mar 2024 15:01:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPBtYKJBfOb3aBQLqb3AHBFvSowntgdfM4R7ayXLVxzEAxtnXjLmVXKjhj6EG9VnTPbKNmqcKmxN5CCTPdHHE=
X-Received: by 2002:a05:600c:314e:b0:413:ee58:db7e with SMTP id
 h14-20020a05600c314e00b00413ee58db7emr559860wmo.3.1710799280659; Mon, 18 Mar
 2024 15:01:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com>
In-Reply-To: <20240314024952.w6n6ol5hjzqayn2g@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 18 Mar 2024 23:01:09 +0100
Message-ID: <CABgObfYpGUBYj94PSNkYsa_NDGVE=NOJnjHSZoE5d7sSGmVfQA@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for CoCo features
To: Michael Roth <michael.roth@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	aik@amd.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024 at 3:50=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
> I've been trying to get SNP running on top of these patches and hit and
> issue with these due to fpstate_set_confidential() being done during
> svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
> SNP_LAUNCH_FINISH it errors out. I think the same would happen with
> SEV-ES as well.
>
> Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
> site as part of these patches?

To SEV_LAUNCH_UPDATE_VMSA, I think, since that's where the last
opportunity lies to sync the contents of struct kvm_vcpu.

> Also, do you happen to have a pointer to the WIP QEMU patches? Happy to
> help with posting/testing those since we'll need similar for
> SEV_INIT2-based SNP patches.

Pushed to https://gitlab.com/bonzini/qemu, branch sevinit2. There is a
hackish commit "runstate: skip initial CPU reset if reset is not
actually possible" that needs some auditing, because I'd like to
replace

-    cpu_synchronize_all_post_reset();
+    if (cpus_are_resettable()) {
+        cpu_synchronize_all_post_reset();
+    } else {
+        /* Assume that cpu_synchronize_all_post_init() was enough. */
+        assert(runstate_check(RUN_STATE_PRELAUNCH));
+    }

with

-    cpu_synchronize_all_post_reset();
+    /*
+     * cpu_synchronize_all_post_init() has already happened if the VM hasn=
't
+     * launched.
+     */
+    if (!runstate_check(RUN_STATE_PRELAUNCH)) {
+        cpu_synchronize_all_post_reset();
+    }

Paolo


