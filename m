Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAB776DB23
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 01:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjHBXAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 19:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjHBXAd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 19:00:33 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE51810C7
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 16:00:32 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-686daaa5f1fso245852b3a.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 16:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691017232; x=1691622032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJnNH7WPlbwS2WClazkQnfqZCkMxIFmtb2LvCA2s5hY=;
        b=PRZiS5O8wBcvvUzqrOvMaeZ5T5OZh46aUekP+3vLtexyWIPeY3PMmAXL1qammA5ns3
         ef4yQcyLaDxmyAFlxciDobRB7RXjrBgBHl5JamD0X18Sghu+7oVi9KZkcniq+QNJqvHO
         mem/xL+Ir845sbxCDDk47TYrwXQz/FVGhC/xrcGogaXPzgmKu+65IIVs0GsL/3LhA3wa
         PYCzFCmQP66Fugr/Zg5N1mgkBeATJPb56JLNu8tLT4GLS0nScwfLKZAGsCLEehAZOvmW
         Q3+kpyL3DA2XBjkGXljrZXUXUpPsgXkKE+bHlttcLS7ofJrU7VXfpBgJZNWrZlNDe0eg
         F0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691017232; x=1691622032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJnNH7WPlbwS2WClazkQnfqZCkMxIFmtb2LvCA2s5hY=;
        b=dEtda2Gkk5o63JNBC/vpiGA2lzQKyRbo1AkP1xvH/psvXYNwTYtSTizBLDRc+c5hr4
         64LK0dnM2qe4O4khHHMk5FkNxCgfO3OtinDEqpakICOhl5G29f/dcDteV3dcyGXtC85f
         oRk3MMgMaEnOLUB8uc92KUwUuqt8Ch4acOInlUl4+FEIaPo47iJoY7Mzh6Mo5I0YJ0FM
         kPRLtES4MksxCPmSuzX6yFj069vTwCRu3GPFWtkppSPL5FztpY9cwU3/KBV3dL6k8fqZ
         SJ/tiaqyWb5CrgIElE1ox/zjWa/R0H6Wh8lYGrDZhpUnZYiB2XVufCUfKxPsTlW78em0
         PvVw==
X-Gm-Message-State: ABy/qLYID5KmihWBipcQZrvjiqiL/W1A3fb3ooiH48RVyLQE7uB+x1B2
        GCbLU8nGoer6Wc+UqKx6M0o=
X-Google-Smtp-Source: APBJJlHayr7+GgVEbAQkj1il9BK+TyTIl/mdfB4GgsJzblb3tZ5qdjU+FPXKHwje4fqyzjGJDBDQBg==
X-Received: by 2002:a05:6a00:16c1:b0:67e:e019:3a28 with SMTP id l1-20020a056a0016c100b0067ee0193a28mr18795785pfc.16.1691017232330;
        Wed, 02 Aug 2023 16:00:32 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id g3-20020aa78743000000b0068725ff9befsm7372004pfo.207.2023.08.02.16.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 16:00:31 -0700 (PDT)
Date:   Wed, 2 Aug 2023 16:00:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 06/19] i386/pc: Drop pc_machine_kvm_type()
Message-ID: <20230802230030.GF1807130@ls.amr.corp.intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-7-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731162201.271114-7-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 12:21:48PM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> pc_machine_kvm_type() was introduced by commit e21be724eaf5 ("i386/xen:
> add pc_machine_kvm_type to initialize XEN_EMULATE mode") to do Xen
> specific initialization by utilizing kvm_type method.
> 
> commit eeedfe6c6316 ("hw/xen: Simplify emulated Xen platform init")
> moves the Xen specific initialization to pc_basic_device_init().
> 
> There is no need to keep the PC specific kvm_type() implementation
> anymore. On the other hand, later patch will implement kvm_type()
> method for all x86/i386 machines to support KVM_X86_SW_PROTECTED_VM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  hw/i386/pc.c         | 5 -----
>  include/hw/i386/pc.h | 3 ---
>  2 files changed, 8 deletions(-)
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 3109d5e0e035..abeadd903827 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -1794,11 +1794,6 @@ static void pc_machine_initfn(Object *obj)
>      cxl_machine_init(obj, &pcms->cxl_devices_state);
>  }
>  
> -int pc_machine_kvm_type(MachineState *machine, const char *kvm_type)
> -{
> -    return 0;
> -}
> -
>  static void pc_machine_reset(MachineState *machine, ShutdownCause reason)
>  {
>      CPUState *cs;
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index d54e8b1101e4..c98d628a76f3 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -296,15 +296,12 @@ extern const size_t pc_compat_1_5_len;
>  extern GlobalProperty pc_compat_1_4[];
>  extern const size_t pc_compat_1_4_len;
>  
> -int pc_machine_kvm_type(MachineState *machine, const char *vm_type);
> -
>  #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
>      static void pc_machine_##suffix##_class_init(ObjectClass *oc, void *data) \
>      { \
>          MachineClass *mc = MACHINE_CLASS(oc); \
>          optsfn(mc); \
>          mc->init = initfn; \
> -        mc->kvm_type = pc_machine_kvm_type; \
>      } \
>      static const TypeInfo pc_machine_type_##suffix = { \
>          .name       = namestr TYPE_MACHINE_SUFFIX, \
> -- 
> 2.34.1
> 

It seems strange for MachineClass to have kvm_type(). Probably AccelClass.
(struct KVMAccelClass?)

Anyway this is independent clean up.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
