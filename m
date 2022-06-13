Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC58549953
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiFMQyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 12:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242043AbiFMQxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 12:53:24 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C01F4FDC
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:38:26 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so9010512pjm.2
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EgVDRPRugv4ujo5MlXy46Y2xsAkIKPNhty2/8oM5/Wg=;
        b=KwqgjGM0eBdCdkcc6qQNpnbNsPwCU6a14MiuQNhI/ngLn7bWw730F9pp1vXj0oUSeG
         GklcOhBQcFP/D3PB1eocetgio7EJTVh8pb5bpI22DnwoYKT0d0oL4bhwqU4yt+UCBjuT
         nukW77qWFdanU0gL6XpROUqvobtjGKkzfQsvYuP1B5bMhTVFvLblRX8ZOsNbvMK6GlRc
         PJzWZK0/ShNOWJwX+7xKAPEy8ZfSaKeIv5Eo3ftGGjqJARoLp9k259VT6PbtS6Y6Yf/y
         9TDpw0C3ugdLyqSRQv6JlH769XJ6SZU4NNvWKvGLwkR1YScWTqZLfieoGhteF7sNRXh0
         +cnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EgVDRPRugv4ujo5MlXy46Y2xsAkIKPNhty2/8oM5/Wg=;
        b=UMcApwQxIrX3E8Q+FBIQPnoVwZ5Ej2MN01nsEyS3sI4hWe+hShcNgPm++5WDeMxYIG
         j9z/k/0zd9PoDdtYlAXv1f+6pV2m4scWD2RTisN9CyttVdtxp3fGNfQCQZ4Bp1FClqrf
         0p8WWC3mXepkoA9FiLI03OlQPh3qrNb/hSGzrXtV0P+fksan+AsxLlwhB/yH9NheXcp9
         /FlWsQR5EoYEktzRq7RIphixdBgLFMpCgTSf2B3y0D1wbaNJpHUsacI9s48Uu02DEVVR
         NZuM7T4x2Q/1Sq8+mhx2Jx4v0kIHDL5wRon1zxOpYfF6xAsdrTArZF83bQBOCIPGPLP1
         MCGw==
X-Gm-Message-State: AJIora+uvmKdhObh0JZ3VXY0rogBvVTsIT19niWbsw+zLJyKnR7a3Ree
        sLAIEZLw8nmngAqaqOUFCZa+skW91kzTSQ==
X-Google-Smtp-Source: AGRyM1uZW1amWfrjvJhQD8uNTN5nzx0Vj+9UGzYAKdiNwSSw4GtdS1C2c35xiXNlAnRcP30G4NIapg==
X-Received: by 2002:a17:902:f54e:b0:166:3b30:457c with SMTP id h14-20020a170902f54e00b001663b30457cmr126340plf.1.1655131105550;
        Mon, 13 Jun 2022 07:38:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z9-20020a1709027e8900b0015e8d4eb208sm5233408pla.82.2022.06.13.07.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 07:38:25 -0700 (PDT)
Date:   Mon, 13 Jun 2022 14:38:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 144/144] KVM: selftests: Sanity check input to
 ioctls() at build time
Message-ID: <YqdL3R/ep3b0XoCo@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-145-seanjc@google.com>
 <20220610184953.34yn2eq2mmm7cp4n@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220610184953.34yn2eq2mmm7cp4n@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:43:31AM +0000, Sean Christopherson wrote:
> > Add a static assert to the KVM/VM/vCPU ioctl() helpers to verify that the
> > size of the argument provided matches the expected size of the IOCTL.
> > Because ioctl() ultimately takes a "void *", it's all too easy to pass in
> > garbage and not detect the error until runtime.  E.g. while working on a
> > CPUID rework, selftests happily compiled when vcpu_set_cpuid()
> > unintentionally passed the cpuid() function as the parameter to ioctl()
> > (a local "cpuid" parameter was removed, but its use was not replaced with
> > "vcpu->cpuid" as intended).
> > 
> > Tweak a variety of benign issues that aren't compatible with the sanity
> > check, e.g. passing a non-pointer for ioctls().
> > 
> > Note, static_assert() requires a string on older versions of GCC.  Feed
> > it an empty string to make the compiler happy.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     | 61 +++++++++++++------
> >  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
> >  tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +--------
> >  tools/testing/selftests/kvm/s390x/resets.c    |  6 +-
> >  .../selftests/kvm/x86_64/mmio_warning_test.c  |  2 +-
> >  .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
> >  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  6 +-
> >  8 files changed, 56 insertions(+), 54 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index 04ddab322b6b..0eaf0c9b7612 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -180,29 +180,56 @@ static inline bool kvm_has_cap(long cap)
> >  #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
> >  #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
> >  
> > -#define __kvm_ioctl(kvm_fd, cmd, arg) \
> > -	ioctl(kvm_fd, cmd, arg)
> > +#define kvm_do_ioctl(fd, cmd, arg)						\
> > +({										\
> > +	static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd), "");	\
> > +	ioctl(fd, cmd, arg);							\
> > +})
> >  
> > -static inline void _kvm_ioctl(int kvm_fd, unsigned long cmd, const char *name,
> > -			      void *arg)
> > -{
> > -	int ret = __kvm_ioctl(kvm_fd, cmd, arg);
> > +#define __kvm_ioctl(kvm_fd, cmd, arg)						\
> > +	kvm_do_ioctl(kvm_fd, cmd, arg)
> >  
> > -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
> > -}
> > +
> 
> While we've gained the static asserts we've also lost the type checking
> that the inline functions provided. Is there anyway we can bring them back
> with more macro tricks?

Gah, I overthought this.  It doesn't even require macros, just a dummy helper.
I wasn't trying to use static_assert() to enforce the type check, which is how I
ended up with the sizeof() ugliness (not the one above).  But it's far easier to
let the compiler do the checking.

I'll send a small fixup series to address this and your other feedback.

static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }

#define __vm_ioctl(vm, cmd, arg)				\
({								\
	static_assert_is_vm(vm);				\
	kvm_do_ioctl((vm)->fd, cmd, arg);			\
})

static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }

#define __vcpu_ioctl(vcpu, cmd, arg)				\
({								\
	static_assert_is_vcpu(vcpu);				\
	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
})


In file included from include/kvm_util.h:10,
                 from lib/x86_64/processor.c:9:
lib/x86_64/processor.c: In function ‘_vcpu_set_msr’:
lib/x86_64/processor.c:831:33: error: passing argument 1 of ‘static_assert_is_vcpu’ from incompatible pointer type [-Werror=incompatible-pointer-types]
  831 |         return __vcpu_ioctl(vcpu->vm, KVM_SET_MSRS, &buffer.header);
      |                             ~~~~^~~~
      |                                 |
      |                                 struct kvm_vm *
include/kvm_util_base.h:232:31: note: in definition of macro ‘__vcpu_ioctl’
  232 |         static_assert_is_vcpu(vcpu);                            \
      |                               ^~~~
include/kvm_util_base.h:225:68: note: expected ‘struct kvm_vcpu *’ but argument is of type ‘struct kvm_vm *’
  225 | static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu)
      |                                                   ~~~~~~~~~~~~~~~~~^~~~
cc1: all warnings being treated as errors

