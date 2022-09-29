Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50CF5EFBB6
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbiI2RNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 13:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiI2RNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 13:13:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C6E1D1E2D
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664471624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jP2+V//iwKHWAsMXL2UuJlJ8Pu2Vn0yXrg4O0Po/pQ=;
        b=djiHOdJUmyD02EuzfMrncXVrClRSgFFbdmpmMvnDutNYjao1Y6gqyzbSoPP4s+HxYEFzhS
        4jm3rEiJrDRyOZAuk2DTZnmwHm5/L0KtEXAlQs8n6rlN4RV2RDGhU2ddt22u+knCjQ/z7N
        JeGygG1qCg9g8fQ6Kz+7atexnJixzHM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-135-dStOboUvPuOIoXODdyvdig-1; Thu, 29 Sep 2022 13:13:39 -0400
X-MC-Unique: dStOboUvPuOIoXODdyvdig-1
Received: by mail-ed1-f69.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so1708655eda.19
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 10:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+jP2+V//iwKHWAsMXL2UuJlJ8Pu2Vn0yXrg4O0Po/pQ=;
        b=XQwu4dSg3ddlmLy2/ETezPs8hOwFwUzheO9bsV/egen/DJ09cTNzfrqtGb8wl8k4O7
         w0U+R+QtsgTPPA7aCACRubjrgf1xEW2EeSL/HoN4+NxYAYc1+6go4VBEXWauDd0fds5/
         jbZjHwtdjMi0kds5jSDs9zszIKPCkrKnK4QrIVEsCKvl3NK7YLeV7DJy7vaXU5BC5MQx
         DFVzTIWGX6NGoAOc76gH3DFTH7mYd0Pa3poJX+79OzaPqrtvRJuViL2FP4FWCWu3/pPx
         ECUOtil+DaUuuO79ddxooXj48s2NxfpaamqU4sNpTmRuyM8bjOzYFSkW8V4CMsUSCLkn
         dCeQ==
X-Gm-Message-State: ACrzQf2f40iZNdc2an+TUxj/3O55JZKtCnN66NaggM3lnmDJXkjpc1NB
        /OhKTTNdDjAQHNGiXWVajBX3Atu0ikyAxtxpOPkd97CI1wsaSbwEf3nv6kGERN6bqPrYfo8tI4+
        QfG4hLAVrCXis
X-Received: by 2002:a05:6402:44c:b0:445:f2f1:4add with SMTP id p12-20020a056402044c00b00445f2f14addmr4278358edw.257.1664471618441;
        Thu, 29 Sep 2022 10:13:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM55NWq0dd/K0GXYaHWuZoiCkHyATpx7PrXwwgAPZSEWFIFQ+us5fRFF1etkh0JX4vOCrcWxpg==
X-Received: by 2002:a05:6402:44c:b0:445:f2f1:4add with SMTP id p12-20020a056402044c00b00445f2f14addmr4278338edw.257.1664471618218;
        Thu, 29 Sep 2022 10:13:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id ss4-20020a170907038400b00781be3e7badsm4263254ejb.53.2022.09.29.10.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:13:37 -0700 (PDT)
Message-ID: <0e1eef64-b157-c87d-ef54-3b5a8bae9aad@redhat.com>
Date:   Thu, 29 Sep 2022 19:13:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] hyperv: fix SynIC SINT assertion failure on guest
 reset
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <8474c6ca63bbbf85ac7721732a7bbdb033f7aa50.1664378882.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8474c6ca63bbbf85ac7721732a7bbdb033f7aa50.1664378882.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/22 18:17, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero"<maciej.szmigiero@oracle.com>
> 
> Resetting a guest that has Hyper-V VMBus support enabled triggers a QEMU
> assertion failure:
> hw/hyperv/hyperv.c:131: synic_reset: Assertion `QLIST_EMPTY(&synic->sint_routes)' failed.
> 
> This happens both on normal guest reboot or when using "system_reset" HMP
> command.
> 
> The failing assertion was introduced by commit 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc")
> to catch dangling SINT routes on SynIC reset.
> 
> The root cause of this problem is that the SynIC itself is reset before
> devices using SINT routes have chance to clean up these routes.
> 
> Since there seems to be no existing mechanism to force reset callbacks (or
> methods) to be executed in specific order let's use a similar method that
> is already used to reset another interrupt controller (APIC) after devices
> have been reset - by invoking the SynIC reset from the machine reset
> handler via a new x86_cpu_after_reset() function co-located with
> the existing x86_cpu_reset() in target/i386/cpu.c.
> 
> Fixes: 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc") # exposed the bug
> Signed-off-by: Maciej S. Szmigiero<maciej.szmigiero@oracle.com>

Thanks, looks good.

hw/i386/microvm.c has to be adjusted too, what do you think of this:

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index dc929727dc..64eb6374ad 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -485,9 +485,7 @@ static void microvm_machine_reset(MachineState *machine)
      CPU_FOREACH(cs) {
          cpu = X86_CPU(cs);

-        if (cpu->apic_state) {
-            device_legacy_reset(cpu->apic_state);
-        }
+        x86_cpu_after_reset(cpu);
      }
  }

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 655439fe62..15a854b149 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -1863,10 +1863,6 @@ static void pc_machine_reset(MachineState *machine)
          cpu = X86_CPU(cs);

          x86_cpu_after_reset(cpu);
-
-        if (cpu->apic_state) {
-            device_legacy_reset(cpu->apic_state);
-        }
      }
  }

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 27ee8c1ced..349bd5d048 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6042,6 +6042,10 @@ void x86_cpu_after_reset(X86CPU *cpu)
      if (kvm_enabled()) {
          kvm_arch_after_reset_vcpu(cpu);
      }
+
+    if (cpu->apic_state) {
+        device_legacy_reset(cpu->apic_state);
+    }
  #endif
  }


