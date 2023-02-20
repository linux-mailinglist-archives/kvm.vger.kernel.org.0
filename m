Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628C969C8D1
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 11:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjBTKl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 05:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBTKl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 05:41:26 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B53EE397
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 02:40:59 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g1so2570694edz.7
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 02:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+eAFzJgAQpcC9VEGPniXtKBPMuCgVjnMF20YBpaeWM=;
        b=efrQDZi3JcWpS907l2e1Ycsl45yQ7twvtI7todBCKfucVcvSDri1C8WCVout0o6nIt
         ifQilTJbMNoo5oJ6GYdPfQCuG6ThCgeaPzg88Y9PUZ5ss4Wqfmtfu0n1+CD1wmlPrfGQ
         MZbtc/9vFdcsx3xhU0Isjk7uOjcjCT8Rm+Qyth9W0g4JpzpUpP5XpbQgGz7BzHOZLKDM
         nedHWfK2MiQ4k1V0p8vMhOTsugNLyymJVQpFMacD3X/hLFJ/ue5KdBkii18XT4N41849
         7pxH43OLbURWHGZvV6ATNWGrc/dxM/wwqcxxdy137TVXcYgmDbirZ0wjVaazvXTpoK5r
         BZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+eAFzJgAQpcC9VEGPniXtKBPMuCgVjnMF20YBpaeWM=;
        b=rEEvYIdpMif3TDI2m4bU5eIVXQvxdmvNZUArC1NCvPzu0z+OXLdaP0U89l5XbRLL2o
         Q9nzC3tk418DqB7dedB6I5e4H0aNClTKIC0x5TOIMgawdp8ShZQjNDxBnPl8bPH/+JC6
         TJmqljCwUZzj2Uc48g2UdN/zMF+o9mT5MTWaQy9r/YgMpYaV1lrUBiB0zczGEdIFptP8
         8WeiIC1phSe0ennZlODIZ8FFouvk5HYHqekZrDlZ4CSjcifqNbJSUGS02ofAMVMA8TXN
         xOEtPGr6AdnqMmP/TUVA8Df4QvMFtsg5mphIgXIURX0ps9W6sQRYuB/xmB2ymwo2j4FX
         qwmQ==
X-Gm-Message-State: AO0yUKXzXTDHB8/lNAvvjqh9qD9Oo95bgLEwgeBLFUD0fAf34OY40Z43
        ZmNr/wT5scGZLamOnyLTnGg30A==
X-Google-Smtp-Source: AK7set9YSsK3XlQtgqXayCh5Z251nsX/bKXrhXTztxDePk9N8sFp5lY9SNzDgjrMB6pM/zACr8c4Yw==
X-Received: by 2002:a17:907:a0d5:b0:8b8:c06e:52d8 with SMTP id hw21-20020a170907a0d500b008b8c06e52d8mr12288750ejc.36.1676889658006;
        Mon, 20 Feb 2023 02:40:58 -0800 (PST)
Received: from bell.fritz.box (p200300f6af17b800ede54e0189be431e.dip0.t-ipconnect.de. [2003:f6:af17:b800:ede5:4e01:89be:431e])
        by smtp.gmail.com with ESMTPSA id u21-20020a17090657d500b007c11e5ac250sm5626050ejr.91.2023.02.20.02.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 02:40:57 -0800 (PST)
From:   Mathias Krause <minipli@grsecurity.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
Subject: Re: [PATCH] kvm: initialize all of the kvm_debugregs structure before sending it to userspace
Date:   Mon, 20 Feb 2023 11:40:50 +0100
Message-Id: <20230220104050.419438-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
References: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14.02.23 11:33, Greg Kroah-Hartman wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..50a95c8082fa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5254,12 +5254,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  {
>  	unsigned long val;
>  
> +	memset(dbgregs, 0, sizeof(*dbgregs));
>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>  	kvm_get_dr(vcpu, 6, &val);
>  	dbgregs->dr6 = val;
>  	dbgregs->dr7 = vcpu->arch.dr7;
> -	dbgregs->flags = 0;
> -	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,

While this change handles the info leak for 32 bit kernels just fine, it
completely ignores that the ABI is broken for such kernels. The bug
(existing since the introduction of the API) effectively makes using
DR1..3 impossible. The memcpy() will only copy half of dbgregs->db and
effectively only allows setting DR0 to its intended value. The remaining
registers get shuffled around (lower half of db[1] will end up in DR2,
not DR1) or completely ignored (db[2..3] which should end up in DR3 and
DR4). Now, this broken ABI might be considdered "API," so I gave it a
look...

A Debian code search gave only three real users of these ioctl()s:
- VirtualBox ([1], lines 1735 ff.),
- QEMU ([2], in kvm_put_debugregs(): lines 4491 ff. and
  kvm_get_debugregs(): lines 4515 ff.) and
- Linux's KVM selftests ([3], lines 722 ff., used in vcpu_load_state()
  and vcpu_save_state()).

Linux's selftest uses the API only to read and bounce back the state --
doesn't do any sanity checks on it.

VirtualBox and QEMU, OTOH, assume that the array is properly filled,
i.e. indices 0..3 map to DR0..3. This means, these users are currently
(and *always* have been) broken when trying to set DR1..3. Time to get
them fixed before x86-32 vanishes into irrelevance.

[1] https://www.virtualbox.org/browser/vbox/trunk/src/VBox/VMM/VMMR3/NEMR3Native-linux.cpp?rev=98193#L1735
[2] https://gitlab.com/qemu-project/qemu/-/blob/v7.2.0/target/i386/kvm/kvm.c#L4480-4522
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/kvm/include/x86_64/processor.h?h=v6.2#n722

An ABI-breaking^Wfixing change like below might be worth to apply on top
to get that long standing bug fixed:

-- >8 --
Subject: [PATCH] KVM: x86: Fix broken debugregs ABI for 32 bit kernels

The ioctl()s to get and set KVM's debug registers are broken for 32 bit
kernels as they'd only copy half of the user register state because of
the UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
bytes).

This makes it impossible for userland to set anything but DR0 without
resorting to bit folding tricks.

Switch to a loop for copying debug registers that'll implicitly do the
type conversion for us, if needed.

This ABI breaking change actually fixes known users [1,2] that have been
broken since the API's introduction in commit a1efbe77c1fd ("KVM: x86:
Add support for saving&restoring debug registers").

Also take 'dr6' from the arch part directly, as we do for 'dr7'. There's
no need to take the clunky route via kvm_get_dr().

[1] https://www.virtualbox.org/browser/vbox/trunk/src/VBox/VMM/VMMR3/NEMR3Native-linux.cpp?rev=98193#L1735
[2] https://gitlab.com/qemu-project/qemu/-/blob/v7.2.0/target/i386/kvm/kvm.c#L4480-4522

Fixes: a1efbe77c1fd ("KVM: x86: Add support for saving&restoring debug registers")
Cc: stable <stable@kernel.org>	# needs 2c10b61421a2
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 arch/x86/kvm/x86.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c299d47e69..db3967de7958 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5261,18 +5261,23 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 					     struct kvm_debugregs *dbgregs)
 {
-	unsigned long val;
+	unsigned int i;
 
 	memset(dbgregs, 0, sizeof(*dbgregs));
-	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
-	kvm_get_dr(vcpu, 6, &val);
-	dbgregs->dr6 = val;
+
+	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
+		dbgregs->db[i] = vcpu->arch.db[i];
+
+	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 					    struct kvm_debugregs *dbgregs)
 {
+	unsigned int i;
+
 	if (dbgregs->flags)
 		return -EINVAL;
 
@@ -5281,7 +5286,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 	if (!kvm_dr7_valid(dbgregs->dr7))
 		return -EINVAL;
 
-	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
+		vcpu->arch.db[i] = dbgregs->db[i];
+
 	kvm_update_dr0123(vcpu);
 	vcpu->arch.dr6 = dbgregs->dr6;
 	vcpu->arch.dr7 = dbgregs->dr7;
-- 
2.30.2

