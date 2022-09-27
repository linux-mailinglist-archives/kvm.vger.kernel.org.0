Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89D45EC3EE
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 15:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiI0NOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbiI0NOk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 09:14:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F82029E
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 06:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664284478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9rXxLIQnWrMqUt+pmfF/ecM0Ncb+G5tyNjeW9seWiqs=;
        b=bG6u04iqTjwxTL7VaWlKC34gZFQO2+wAH3aXpvIV8lKKutktfNCWjzFWD5FQJ+dMWXPJUA
        5XFzGcwANhpQ3c4l/Ct9mG9+s/fpDz6E11nrvk0RlXx4b6QqQQcJoG5wi6AOhwPSgdbNXI
        I/3kS5zK1ExVF8N/lwkqcrm48XlCMLA=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-F32fd7Q_O0KBUDGaX5mkgA-1; Tue, 27 Sep 2022 09:14:37 -0400
X-MC-Unique: F32fd7Q_O0KBUDGaX5mkgA-1
Received: by mail-ed1-f70.google.com with SMTP id m13-20020a056402510d00b004519332f0b1so7709659edd.7
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 06:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9rXxLIQnWrMqUt+pmfF/ecM0Ncb+G5tyNjeW9seWiqs=;
        b=xWgzU3qqe8slHgKWzusC9p4fqjtg+0c4LEZuB/UUx8o7TDfoyBI1jHekUIOV1qbOG5
         TJd6R3CCv1SWW/h/DLGjxpYzkPF0yPRDAB6A33qYS0/GtbwnQrSe2lpOLBC9d3Qp64g8
         PGqhfe2nGbTWXE23Qt1UGlAaGVuiaWilobwEQsNWTxYCIvziyt27U8WCiGVNEHJ2Nn+K
         NXvF4wyjEJ0Ec7GI6O0YpsnBGHYlU1q4MzoA2wnN52DnfxXVIoE3A8cSdb1OyRkqDByw
         trxI9+N5/W2aOjYAbR24ypRSLnhHQ5E5+LwdGRy+EXk6FZXHAUO9nxsEHJwjMkaUIXkG
         NdAQ==
X-Gm-Message-State: ACrzQf387y7d3DbYmw9wQl0BZB841UqOS9yJBUQW+1XRzzZgEfyJk83Z
        urA8XSXujBXg48n/xa0W8YFXrWD9YDWDiMT+HCccYP1yn9MnjNt/dOZAtLU3MIvsUhcT1iv0ouc
        OL+xcbBrpe3Ht
X-Received: by 2002:a17:907:868c:b0:782:d6b3:33bc with SMTP id qa12-20020a170907868c00b00782d6b333bcmr15867019ejc.134.1664284476008;
        Tue, 27 Sep 2022 06:14:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5fFe8Bs1L7keuFtSr+WCTkDKpB3RdTwfJQJSn6gB6nIRYHX3+H22gzBbraORNQ2KD+c1aIdg==
X-Received: by 2002:a17:907:868c:b0:782:d6b3:33bc with SMTP id qa12-20020a170907868c00b00782d6b333bcmr15866946ejc.134.1664284475054;
        Tue, 27 Sep 2022 06:14:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id p24-20020a170906141800b0077ab3ca93efsm747188ejc.223.2022.09.27.06.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 06:14:34 -0700 (PDT)
Message-ID: <c773b5aa-19b0-20de-5818-67360307abd9@redhat.com>
Date:   Tue, 27 Sep 2022 15:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v7 1/2] i386: kvm: extend kvm_{get, put}_vcpu_events to
 support pending triple fault
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220923073333.23381-1-chenyi.qiang@intel.com>
 <20220923073333.23381-2-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220923073333.23381-2-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/22 09:33, Chenyi Qiang wrote:
> For the direct triple faults, i.e. hardware detected and KVM morphed
> to VM-Exit, KVM will never lose them. But for triple faults sythesized
> by KVM, e.g. the RSM path, if KVM exits to userspace before the request
> is serviced, userspace could migrate the VM and lose the triple fault.
> 
> A new flag KVM_VCPUEVENT_VALID_TRIPLE_FAULT is defined to signal that
> the event.triple_fault_pending field contains a valid state if the
> KVM_CAP_X86_TRIPLE_FAULT_EVENT capability is enabled.

Note that you are not transmitting the field on migration.  You need
this on top:

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b97d182e28..d4124973ce 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1739,7 +1739,7 @@ typedef struct CPUArchState {
      uint8_t has_error_code;
      uint8_t exception_has_payload;
      uint64_t exception_payload;
-    bool triple_fault_pending;
+    uint8_t triple_fault_pending;
      uint32_t ins_len;
      uint32_t sipi_vector;
      bool tsc_valid;
diff --git a/target/i386/machine.c b/target/i386/machine.c
index cecd476e98..310b125235 100644
--- a/target/i386/machine.c
+++ b/target/i386/machine.c
@@ -1562,6 +1562,25 @@ static const VMStateDescription vmstate_arch_lbr = {
      }
  };
  
+static bool triple_fault_needed(void *opaque)
+{
+    X86CPU *cpu = opaque;
+    CPUX86State *env = &cpu->env;
+
+    return env->triple_fault_pending;
+}
+
+static const VMStateDescription vmstate_triple_fault = {
+    .name = "cpu/triple_fault",
+    .version_id = 1,
+    .minimum_version_id = 1,
+    .needed = triple_fault_needed,
+    .fields = (VMStateField[]) {
+        VMSTATE_UINT8(env.triple_fault_pending, X86CPU),
+        VMSTATE_END_OF_LIST()
+    }
+};
+
  const VMStateDescription vmstate_x86_cpu = {
      .name = "cpu",
      .version_id = 12,
@@ -1706,6 +1725,7 @@ const VMStateDescription vmstate_x86_cpu = {
          &vmstate_amx_xtile,
  #endif
          &vmstate_arch_lbr,
+        &vmstate_triple_fault,
          NULL
      }
  };

