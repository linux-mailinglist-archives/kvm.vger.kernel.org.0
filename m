Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6865B2E8F
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 08:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiIIGNf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 02:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiIIGNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 02:13:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EB5AED82
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 23:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662704011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rNLh4hKFEpap8uDZVtpLjKKsyiyJp2moh14q/PZu9mo=;
        b=duJ+OaDokVmFJnk7KCr6fvgaGWu3E5lgeqPXg2UqqEOVgF8la9jiZwEqQFp+F/0ZJZVnFk
        Px3YXIewa3rjBDtt/zXxgnaIOU5eYttYIm+zfkkmOsHxnxX3D+Pr0YcDslrekSojBAd2Id
        NtVSk2NC3UP/AhxvJXHb5/zrwmmIs5M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-132-vUpvGEf9NeWaT6SCbxwAZw-1; Fri, 09 Sep 2022 02:13:29 -0400
X-MC-Unique: vUpvGEf9NeWaT6SCbxwAZw-1
Received: by mail-wm1-f69.google.com with SMTP id c188-20020a1c35c5000000b003b2dee5fb58so351688wma.5
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 23:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rNLh4hKFEpap8uDZVtpLjKKsyiyJp2moh14q/PZu9mo=;
        b=ebs1qpwRKg0tWD1kVm+hKy++CMlQQz+yuNFy5FqiFbbv+CJ2Q/9REwWUsArqGm8epl
         b+/BmvqjzyB3Vw/+wEaqPOuntyYLCyqvJul55r21JfbA7Bh5mawsI5jRVYQWLHfon5Fy
         O4SsMgCDuv84cK0tIs+4gAj4tkw+5GFMyspJlE2TyYHXBL0spM/63SNdjWXFkCFUNSs1
         kgK1UKrAZ0Jkii9QNgZtDdU1vg9hl3gPSqziD1A4IjGLHVQUYGgp3fZahB7gXaIe7mCk
         Q5esNnMSRcGE7WmBDLWKtWz3AKLLytQvXMI6ilE6SdbTapImLHHuXcHDF8LwKjii9ad+
         uNHQ==
X-Gm-Message-State: ACgBeo2E/Y7bv9kz7GK95nfFeV+IMbd36oISF+0/n8P1s31kM0FPd7tX
        Lzq/fo9iaJw5g/b38fkNS8soL0im3RxXppG176cYWs++OtNcaa2+2HxUhS0FDGgCqBwLlLOkuj2
        UbgjBECWJ2+KU
X-Received: by 2002:a5d:5350:0:b0:225:7560:8403 with SMTP id t16-20020a5d5350000000b0022575608403mr6627109wrv.507.1662704008008;
        Thu, 08 Sep 2022 23:13:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5S0Avumx7TLlDBIxldAD6k1vkdGmnLy165kGjXCLD0Znmbo2lEl3oPZ0StD+kgXAJRbFOXFw==
X-Received: by 2002:a5d:5350:0:b0:225:7560:8403 with SMTP id t16-20020a5d5350000000b0022575608403mr6627098wrv.507.1662704007768;
        Thu, 08 Sep 2022 23:13:27 -0700 (PDT)
Received: from redhat.com ([176.12.154.16])
        by smtp.gmail.com with ESMTPSA id p12-20020adfce0c000000b0022a2f4fa042sm995562wrn.103.2022.09.08.23.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 23:13:27 -0700 (PDT)
Date:   Fri, 9 Sep 2022 02:13:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: Re: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Message-ID: <20220909021213-mutt-send-email-mst@kernel.org>
References: <20220908113109.470792-1-kraxel@redhat.com>
 <20220908113109.470792-3-kraxel@redhat.com>
 <20220908101757-mutt-send-email-mst@kernel.org>
 <20220909051817.vlai3l6cjl5sfgmv@sirius.home.kraxel.org>
 <20220909014106-mutt-send-email-mst@kernel.org>
 <20220909060653.s4cf7caaem3p7ac3@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909060653.s4cf7caaem3p7ac3@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 08:06:53AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > > > I think we still want to key this one off host_phys_bits
> > > > so it works for e.g. hyperv emulation too.
> > > 
> > > I think that should be the case.  The chunks above change the
> > > host-phys-bits option from setting cpu->host_phys_bits to setting
> > > the FEAT_KVM_HINTS bit.  That should also happen with hyperv emulation
> > > enabled, and the bit should also be visible to the guest then, just at
> > > another location (base 0x40000100 instead of 0x40000000).
> > > 
> > > take care,
> > >   Gerd
> > 
> > 
> > You are right, I forgot. Hmm, ok. What about !cpu->expose_kvm ?
> > 
> > We have
> > 
> >     if (!kvm_enabled() || !cpu->expose_kvm) {
> >         env->features[FEAT_KVM] = 0;
> >     }   
> >         
> > This is quick grep, I didn't check whether this is called
> > after the point where you currently use it, but
> > it frankly seems fragile to pass a generic user specified flag
> > inside a cpuid where everyone pokes at it.
> 
> I tried to avoid keeping the state of the host_phys_bits option at
> multiple places.  Maybe that wasn't a good idea after all.  How about
> doing this instead:
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 1db1278a599b..279fde095d7c 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6219,6 +6219,11 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>          env->features[FEAT_KVM] = 0;
>      }
>  
> +    if (kvm_enabled() && cpu->host_phys_bits) {
> +        env->features[FEAT_KVM_HINTS] |=
> +            (1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
> +    }
> +
>      x86_cpu_enable_xsave_components(cpu);
>  
>      /* CPUID[EAX=7,ECX=0].EBX always increased level automatically: */
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index a1fd1f53791d..3335c57b21b2 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -459,6 +459,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
>          }
>      } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
>          ret |= 1U << KVM_HINTS_REALTIME;
> +        ret |= 1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID;
>      }
>  
>      return ret;


/me nods.
That seems much more straight-forward.

-- 
MST

