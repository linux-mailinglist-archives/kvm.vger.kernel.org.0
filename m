Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F17751548
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 02:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjGMA25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 20:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjGMA2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 20:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFC91FE9
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 17:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689208088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=voWVlpmm7MeCDv7tg7yl30rZqUK9Zw54JqfyPKuCRLo=;
        b=gyrGSnIXMga9K2ESqHL5/4xbRGvV4VWGQVy5zfkU5/ZS62x5ZnMQeED3QkTdaFHp2MtspH
        1pGkrA5fftFZSMJ6Aznguh4ZZ+P4bITrwCMGwFD2XFmxsNV4S6VoHqAsSCe3jUC716rSo4
        wCEgorlvi4Eva7cK/ghYq8Q83zevyyM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-P3TN92thNCuAqkGVRG86Pg-1; Wed, 12 Jul 2023 20:28:06 -0400
X-MC-Unique: P3TN92thNCuAqkGVRG86Pg-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b8a8154fcaso1282685ad.1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 17:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689208085; x=1691800085;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=voWVlpmm7MeCDv7tg7yl30rZqUK9Zw54JqfyPKuCRLo=;
        b=howPHOCszDgQ8n+VX0DpEBUmRMS+57XxYvjEIoPZA3ayNyh/fNG55mXTtKq6DZHfE+
         FarLldl90gSfvFmQ+OUG5qa5+UW5SwpeFNzGfMai/oE8/eZYhM5xSvqoHQfKGrtNtScG
         gQdBHGAKiBTzjEZ/qASbhiKfhci+Tb9wK5fuEUzgyhcA3smKC4QOzJWI5t4bR80OpStH
         eTOMfZYHVnAcC6Am4NA4NKqR+1LXTMnH7UV6a5tzIzVyAX4msYqDvlky36GqbuDCN0GN
         i9FKW35kiyxT4kMya3fZ5jfEwR0lmC03dqtPYNHUJSMDs46cqDfwsWLGDrzBB/kMb0MY
         OD/g==
X-Gm-Message-State: ABy/qLa0ENpBsoCxfGPlPkmMHOLrwPJaGgM0CM2MGZ/GgxZytZv+7LDB
        2EBPuSwG/Shz7B4XLYRGsSkqEJG2xFu5l1adgiu37CYm3FbE4GuyPS9pDKJUzP8/mwcLpHcwMWz
        loRT20BcTlw2e
X-Received: by 2002:a17:902:f68c:b0:1b5:91:4693 with SMTP id l12-20020a170902f68c00b001b500914693mr266226plg.1.1689208085442;
        Wed, 12 Jul 2023 17:28:05 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGEjFAvk5eqLeJeEU/3QkGgYzn7vfM7lAYQwnHa5EWYocjBHtJs1x+2EwaaYQfdNtaq2LOoGQ==
X-Received: by 2002:a17:902:f68c:b0:1b5:91:4693 with SMTP id l12-20020a170902f68c00b001b500914693mr266210plg.1.1689208084952;
        Wed, 12 Jul 2023 17:28:04 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id io12-20020a17090312cc00b001b9dfa24523sm4531541plb.213.2023.07.12.17.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jul 2023 17:28:03 -0700 (PDT)
Message-ID: <7f524e2a-e773-4de0-09ed-b18eaec8ff16@redhat.com>
Date:   Thu, 13 Jul 2023 10:27:57 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v1 0/5] target/arm: Handle psci calls in userspace
Content-Language: en-US
To:     Salil Mehta <salil.mehta@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>
Cc:     "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "james.morse@arm.com" <james.morse@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Salil Mehta <salil.mehta@opnsrc.net>
References: <20230626064910.1787255-1-shahuang@redhat.com>
 <9df973ede74e4757b510f26cd5786036@huawei.com>
 <fb5e8d4d-2388-3ab0-aaac-a1dd91e74b08@redhat.com>
 <539e6a25b89a45839de37fe92b27d0d3@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
In-Reply-To: <539e6a25b89a45839de37fe92b27d0d3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Salil,

On 7/4/23 19:58, Salil Mehta wrote:

> 
> Latest Qemu Prototype (Pre RFC V2) (Not in the final shape of the patches)
> https://github.com/salil-mehta/qemu.git   virt-cpuhp-armv8/rfc-v1-port11052023.dev-1
> 
> 
> should work against below kernel changes as confirmed by James,
> 
> Latest Kernel Prototype (Pre RFC V2 = RFC V1 + Fixes)
> https://git.gitlab.arm.com/linux-arm/linux-jm.git   virtual_cpu_hotplug/rfc/v2
> 

I think it'd better to have the discussions through maillist. The threads and all
follow-up replies can be cached somewhere to avoid lost. Besides, other people may
be intrested in the same points and can join the discussion directly.

I got a chance to give the RFC patchsets some tests. Not all cases are working
as expected. I know the patchset is being polished. I'm summarize them as below:

(1) coredump is triggered when the topology is out of range. It's the issue we
     discussed in private. Here I'm just recapping in case other people also blocked
     by the issue.

     (a) start VM with the following command lines
      /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64       \
      -accel kvm -machine virt,gic-version=host,nvdimm=on -cpu host \
      -smp cpus=1,maxcpus=2,sockets=1,clusters=1,cores=1,threads=2  \
      -m 512M,slots=16,maxmem=64G                                   \
      -object memory-backend-ram,id=mem0,size=512M                  \
      -numa node,nodeid=0,cpus=0-1,memdev=mem0                      \

     (b) hot add CPU whose topology is out of range
     (qemu) device_add driver=host-arm-cpu,id=cpu1,core-id=1


     It's actually caused by typos in hw/arm/virt.c::virt_cpu_pre_plug() where
     'ms->possible_cpus->len' needs to be replaced with 'ms->smp.cores'. With this,
     the hot-added CPU object will be rejected.

(2) I don't think TCG has been tested since it seems not working at all.

     (a) start VM with the following command lines
     /home/gshan/sandbox/src/qemu/main/build/qemu-system-aarch64     \
     -machine virt,gic-version=3 -cpu max -m 1024                    \
     -smp maxcpus=2,cpus=1,sockets=1,clusters=1,cores=1,threads=2    \

     (b) failure while hot-adding CPU
     (qemu) device_add driver=max-arm-cpu,id=cpu1,thread-id=1
     Error: cpu(id1=0:0:0:1) with arch-id 1 exists

     The error message is printed by hw/arm/virt.c::virt_cpu_pre_plug() where the
     specific CPU has been presented. For KVM case, the disabled CPUs are detached
     from 'ms->possible_cpu->cpus[1].cpu' and destroyed. I think we need to do similar
     thing for TCG case in hw/arm/virt.c::virt_cpu_post_init(). I'm able to add CPU
     with the following hunk of changes.

--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2122,6 +2122,18 @@ static void virt_cpu_post_init(VirtMachineState *vms, MemoryRegion *sysmem)
                  exit(1);
              }
          }
+
+#if 1
+        for (n = 0; n < possible_cpus->len; n++) {
+            cpu = qemu_get_possible_cpu(n);
+            if (!qemu_enabled_cpu(cpu)) {
+                CPUArchId *cpu_slot;
+                cpu_slot = virt_find_cpu_slot(ms, cpu->cpu_index);
+                cpu_slot->cpu = NULL;
+                object_unref(OBJECT(cpu));
+            }
+        }
+#endif
      }
  }

(3) Assertion on following the sequence of hot-add, hot-remove and hot-add when TCG mode is enabled.

     (a) Include the hack from (2) and start VM with the following command lines
     /home/gshan/sandbox/src/qemu/main/build/qemu-system-aarch64     \
     -machine virt,gic-version=3 -cpu max -m 1024                    \
     -smp maxcpus=2,cpus=1,sockets=1,clusters=1,cores=1,threads=2    \

     (b) assertion on the sequence of hot-add, hot-remove and hot-add
     (qemu) device_add driver=max-arm-cpu,id=cpu1,thread-id=1
     (qemu) device_del cpu1
     (qemu) device_add driver=max-arm-cpu,id=cpu1,thread-id=1
     **
     ERROR:../tcg/tcg.c:669:tcg_register_thread: assertion failed: (n < tcg_max_ctxs)
     Bail out! ERROR:../tcg/tcg.c:669:tcg_register_thread: assertion failed: (n < tcg_max_ctxs)
     Aborted (core dumped)

     I'm not sure if x86 has similar issue. It seems the management for TCG contexts, corresponding
     to variable @tcg_max_ctxs and @tcg_ctxs need some improvements for better TCG context registration
     and unregistration to accomodate CPU hotplug.


Apart from what have been found in the tests, I've started to look into the code changes. I may
reply with more specific comments. However, it would be ideal to comment on the specific changes
after the patchset is posted for review. Salil, the plan may have been mentioned by you somewhere.
As I understood, the QEMU patchset will be posted after James's RFCv2 kernel series is posted.
Please let me know if my understanding is correct. Again, thanks for your efforts to make vCPU
hotplug to be supported :)

Thanks,
Gavin



     

     
         

