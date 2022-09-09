Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450D65B2E7D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiIIGHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiIIGHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:07:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACA7FBF20
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 23:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662703619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MqbPv6lnJSzxepc8DOW/ygA1tXx3gSoD2I+uvu44Z8c=;
        b=gpBiiOWTmKljVW+Zy1BU2wGGop08y3/sWS1GT9ik9VARrKalTYTOAUBm8C30ejTDhKQRwU
        1n27HfElZs1cTc99IDpnu+0jnDIWKLV8lUt42AHTcv/Zr+UkVyY3e2OXlCJ6H5Tgv0AuxF
        eW6xNC+NCkjbTZQN8c1tVXGqT50mbj4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-8bcq4jlTNDi9Dg9MEUeZiQ-1; Fri, 09 Sep 2022 02:06:55 -0400
X-MC-Unique: 8bcq4jlTNDi9Dg9MEUeZiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720B485A585;
        Fri,  9 Sep 2022 06:06:55 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30B7D4010D2A;
        Fri,  9 Sep 2022 06:06:55 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id CFFFE18000A3; Fri,  9 Sep 2022 08:06:53 +0200 (CEST)
Date:   Fri, 9 Sep 2022 08:06:53 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Message-ID: <20220909060653.s4cf7caaem3p7ac3@sirius.home.kraxel.org>
References: <20220908113109.470792-1-kraxel@redhat.com>
 <20220908113109.470792-3-kraxel@redhat.com>
 <20220908101757-mutt-send-email-mst@kernel.org>
 <20220909051817.vlai3l6cjl5sfgmv@sirius.home.kraxel.org>
 <20220909014106-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909014106-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > > I think we still want to key this one off host_phys_bits
> > > so it works for e.g. hyperv emulation too.
> > 
> > I think that should be the case.  The chunks above change the
> > host-phys-bits option from setting cpu->host_phys_bits to setting
> > the FEAT_KVM_HINTS bit.  That should also happen with hyperv emulation
> > enabled, and the bit should also be visible to the guest then, just at
> > another location (base 0x40000100 instead of 0x40000000).
> > 
> > take care,
> >   Gerd
> 
> 
> You are right, I forgot. Hmm, ok. What about !cpu->expose_kvm ?
> 
> We have
> 
>     if (!kvm_enabled() || !cpu->expose_kvm) {
>         env->features[FEAT_KVM] = 0;
>     }   
>         
> This is quick grep, I didn't check whether this is called
> after the point where you currently use it, but
> it frankly seems fragile to pass a generic user specified flag
> inside a cpuid where everyone pokes at it.

I tried to avoid keeping the state of the host_phys_bits option at
multiple places.  Maybe that wasn't a good idea after all.  How about
doing this instead:

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a599b..279fde095d7c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6219,6 +6219,11 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         env->features[FEAT_KVM] = 0;
     }
 
+    if (kvm_enabled() && cpu->host_phys_bits) {
+        env->features[FEAT_KVM_HINTS] |=
+            (1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
+    }
+
     x86_cpu_enable_xsave_components(cpu);
 
     /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a1fd1f53791d..3335c57b21b2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -459,6 +459,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         }
     } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
         ret |= 1U << KVM_HINTS_REALTIME;
+        ret |= 1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID;
     }
 
     return ret;

