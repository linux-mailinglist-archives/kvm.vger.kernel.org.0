Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F06A7AA9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 05:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjCBEzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 23:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBEzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 23:55:02 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188A1311D6
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 20:55:01 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id h8so13052269plf.10
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 20:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677732900;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OSV9EBJ3P3dFApW07AlVktvqVMw/A+Em9/JPld3wEWY=;
        b=KUtPzUWOOcN3+TqjjjVpbRkOYtHn/gTcu6B8NzE1QZdhldXf8NP13g3PY9xuotDopz
         x03oTbOj4BQTgRpE9j0IYmQKKM9xwaGrv7K+nQV5cPWZOe6nmpVj1f7L2i9RGpr2YKMT
         LcvNX8FiYptexGLuEcGZGEWm8EFmz1gY8VyXWcQNKHo0o3i7FM9Wv5p2MFl0u9hAdtiM
         0vAkqi8otkyH7xDqGKDdu6xGzuKbtdXugyVxtTyTEAnqyu4HQszQ+iBdnC4f/VU68z+J
         DQHIFSsnr9gYqaK0XNfT7NnVgw5tf2ItVGgyWEjqDeJ7j6hEZfk3bvmQauYtuMXCe+dn
         5Wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677732900;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OSV9EBJ3P3dFApW07AlVktvqVMw/A+Em9/JPld3wEWY=;
        b=14HHRuHVEvTZpskOIU+bgDkuy43dR3msGaTqFZcDb1w8jdRVBXur4V6a9rpZ+yccSA
         tuh3sBJLvz96f7Y0sDoM0beQZH9yvkbnoURx6pjwCNQknErKp+DBgspbOVabrIrRPVMo
         0G+S12rA4xt1xOZHJqY6w05d/leRwKNHF1sSkAgOWCSTvJb03n2ITNdMvr5c5kFO7Bck
         1zh5cET+QHAo39I5tLhUL+Burkv0Dw6rxRlBjnIYL9KxW9sWvz8FfFLaHzp0UJFlHLhE
         5hcn0YdW44qYOCMqpvCCx3A5Hk1hpowQI46xxmbMcCg4825N1ysJxIPtQufCQUKKCMfS
         U/SA==
X-Gm-Message-State: AO0yUKVUNJ8csPPENo80AtaezN1heCJWdVW9j7PSLW9+EHS333/kb1ak
        V+ou2xw7Uv8IocS3zkhnZR3JTQ==
X-Google-Smtp-Source: AK7set/npSCOG2kD75BxOl3ksZp512V9bCxeuqI0X0zRQDzrIgZuGCDo49Jsc2qM6r7OrKzhsMaepw==
X-Received: by 2002:a05:6a20:5496:b0:cc:50de:a2be with SMTP id i22-20020a056a20549600b000cc50dea2bemr1078211pzk.14.1677732900328;
        Wed, 01 Mar 2023 20:55:00 -0800 (PST)
Received: from google.com (173.84.105.34.bc.googleusercontent.com. [34.105.84.173])
        by smtp.gmail.com with ESMTPSA id y5-20020aa78545000000b005a54a978c1bsm8741244pfn.7.2023.03.01.20.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 20:54:59 -0800 (PST)
Date:   Thu, 2 Mar 2023 04:54:56 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Wang, Wei W" <wei.w.wang@intel.com>
Cc:     David Matlack <dmatlack@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] KVM: allow KVM_BUG/KVM_BUG_ON to handle 64-bit cond
Message-ID: <ZAAsIBUuIIO1prZT@google.com>
References: <20230301133841.18007-1-wei.w.wang@intel.com>
 <CALzav=eRYpnfg7bVQpVawAMraFdHu3OzqWr55Pg1SJC_Uh8t=Q@mail.gmail.com>
 <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB637348F1351260F8B7E97A15DCB29@DS0PR11MB6373.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 02, 2023, Wang, Wei W wrote:
> On Thursday, March 2, 2023 3:47 AM, David Matlack wrote:
> > On Wed, Mar 1, 2023 at 5:38 AM Wei Wang <wei.w.wang@intel.com> wrote:
> > >
> > > Current KVM_BUG and KVM_BUG_ON assumes that 'cond' passed from
> > callers
> > > is 32-bit as it casts 'cond' to the type of int. This will be wrong if 'cond'
> > > provided by a caller is 64-bit, e.g. an error code of
> > > 0xc0000d0300000000 will be converted to 0, which is not expected.
> > > Improves the implementation by using !!(cond) in KVM_BUG and
> > > KVM_BUG_ON. Compared to changing 'int' to 'int64_t', this has less LOCs.
> > 
> > Less LOC is nice to have, but please preserve the behavior that "cond"
> > is evaluated only once by KVM_BUG() and KVM_BUG_ON(). i.e.
> > KVM_BUG_ON(do_something(), kvm) should only result in a single call to
> > do_something().
> 
> Good point, thanks! Using 'typeof(cond)' looks like a better choice.

I don't get it. Why bothering the type if we just do this?

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..10455253c6ea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -848,7 +848,7 @@ static inline void kvm_vm_bugged(struct kvm *kvm)

 #define KVM_BUG(cond, kvm, fmt...)				\
 ({								\
-	int __ret = (cond);					\
+	int __ret = !!(cond);					\
 								\
 	if (WARN_ONCE(__ret && !(kvm)->vm_bugged, fmt))		\
 		kvm_vm_bugged(kvm);				\
@@ -857,7 +857,7 @@ static inline void kvm_vm_bugged(struct kvm *kvm)

 #define KVM_BUG_ON(cond, kvm)					\
 ({								\
-	int __ret = (cond);					\
+	int __ret = !!(cond);					\
 								\
 	if (WARN_ON_ONCE(__ret && !(kvm)->vm_bugged))		\
 		kvm_vm_bugged(kvm);				\


