Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B587414C94
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbhIVPAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbhIVPA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 11:00:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A1C061756
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:58:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f129so2975551pgc.1
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4BWFRlURH0zCIzDJvPF7W8LOo55K5uYFem7UNOAo2W4=;
        b=P3j9Vr5KoI1hGqte/zzUiZq9ueEus3vwpVyhweN4PzPXBSF6gJEpN2JysyuxyUbH+c
         hTJRqQQQz5xcbLGhfs+ofgEvrmkd+XZJNiSkM/9N5q7QpzX/OJceRjXeT7U0s5FlAvuN
         NuYhM+bBKIDbrGfD31uEdiue5ZFcIR+SK9Jxr/HUJU2u0W1gILQ9TaYreehyonGdh3bs
         3xX6zro4/xGqGj/WqpOHRxJ/jUgjWdtKB8FTFDKZ/OC5UmJHVBiBJx/n3Ges4rEpkyGx
         Hb6J/vje2oXUtI8tWq0Z1zDTTm5T3sdxP3kl0qSKzbP4uuzuneyIDU2PQ1JfdvkNmVPl
         pkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4BWFRlURH0zCIzDJvPF7W8LOo55K5uYFem7UNOAo2W4=;
        b=Feb+DVO5LZKBaO0/UBJe6Yp+RS51EfKuOzuJIRTrpk5aVSyAibmz83DeQZi/TiuT3b
         jbeOcKM1hdtoB9awlr1S0wEeuO+9KRGC7D4ELlhgT5xGW8zgEKeaj0mnQpV2b/X0R5S6
         HCvtmFuKi0o5CcXW2SBMuAFszSQ7eVcMRG0b45EiHtHrHPnbuTzvjfpduoLVqecl48SI
         bfbO76b/qmFJSNmF1dttxTIs6+ym+SQyCteQbJU4/LbXkaoxArIkt8SDPx/K5VT4uNPO
         On1FyEcxDY+QLISmCdecZhZgFUID9SDcjrqH4745/SDQxamvvHKIkohr3pSzcRhnwuCm
         MUgg==
X-Gm-Message-State: AOAM531ZsRKJcrYo/iEjyA7ndQ4IJFZCI9JkUCvD9WQXzVwn1cZpTbNK
        DXX+CFvg0AX6JPvEEPu5BpF92w==
X-Google-Smtp-Source: ABdhPJwdYeOPs+9n16+HPBDRZMNwU3ntjxP7QSgPHZIuMryueYJCypE73VnvJPFH3zw0ebvOvgxc0Q==
X-Received: by 2002:a63:f959:: with SMTP id q25mr64757pgk.79.1632322738517;
        Wed, 22 Sep 2021 07:58:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i27sm2830809pfq.184.2021.09.22.07.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:58:57 -0700 (PDT)
Date:   Wed, 22 Sep 2021 14:58:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenyi.qiang@intel.com,
        shannon.zhao@linux.alibaba.com
Subject: Re: [PATCH] KVM: VMX: Check if bus lock vmexit was preempted
Message-ID: <YUtEraihPxsytaJc@google.com>
References: <1631964600-73707-1-git-send-email-hao.xiang@linux.alibaba.com>
 <87b411c3-da75-e074-91a4-a73891f9f5f8@redhat.com>
 <57597778-836c-7bac-7f1d-bcdae0cd6ac4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57597778-836c-7bac-7f1d-bcdae0cd6ac4@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021, Xiaoyao Li wrote:
> On 9/22/2021 6:02 PM, Paolo Bonzini wrote:
> > On 18/09/21 13:30, Hao Xiang wrote:
> > > exit_reason.bus_lock_detected is not only set when bus lock VM exit
> > > was preempted, in fact, this bit is always set if bus locks are
> > > detected no matter what the exit_reason.basic is.
> > > 
> > > So the bus_lock_vmexit handling in vmx_handle_exit should be duplicated
> > > when exit_reason.basic is EXIT_REASON_BUS_LOCK(74). We can avoid it by
> > > checking if bus lock vmexit was preempted in vmx_handle_exit.
> > 
> > I don't understand, does this mean that bus_lock_detected=1 if
> > basic=EXIT_REASON_BUS_LOCK?  If so, can we instead replace the contents
> > of handle_bus_lock_vmexit with
> > 
> >      /* Do nothing and let vmx_handle_exit exit to userspace.  */
> >      WARN_ON(!to_vmx(vcpu)->exit_reason.bus_lock_detected);
> >      return 0;
> > 
> > ?
> > 
> > That would be doable only if this is architectural behavior and not a
> > processor erratum, of course.
> 
> EXIT_REASON.bus_lock_detected may or may not be set when exit reason ==
> EXIT_REASON_BUS_LOCK. Intel will update ISE or SDM to state it.
> 
> Maybe we can do below in handle_bus_lock_vmexit handler:
> 
> 	if (!to_vmx(vcpu)->exit_reason.bus_lock_detected)
> 		to_vmx(vcpu)->exit_reason.bus_lock_detected = 1;
> 
> But is manually changing the hardware reported value for software purpose a
> good thing?

In this case, I'd say yes.  Hardware having non-deterministic behavior is the not
good thing, KVM would simply be correctly the not-technically-an-erratum erratum.

Set it unconditionally and then handle everything in common path.  This has the
added advantage of having only one site that deals with KVM_RUN_X86_BUS_LOCK.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33f92febe3ce..aa9372452e49 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5561,9 +5561,9 @@ static int handle_encls(struct kvm_vcpu *vcpu)

 static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
-       vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
-       vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
-       return 0;
+       /* The dedicated flag may or may not be set by hardware.  /facepalm. */
+       vcpu->exit_reason.bus_lock_detected = true;
+       return 1;
 }

 /*
@@ -6050,9 +6050,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
        int ret = __vmx_handle_exit(vcpu, exit_fastpath);

        /*
-        * Even when current exit reason is handled by KVM internally, we
-        * still need to exit to user space when bus lock detected to inform
-        * that there is a bus lock in guest.
+        * Exit to user space when bus lock detected to inform that there is a
+        * bus lock in guest.
         */
        if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
                if (ret > 0)
