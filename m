Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350C676DAD2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 00:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjHBW3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 18:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjHBW2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 18:28:45 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C9B44BB
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 15:27:59 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1bbc06f830aso2563155ad.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 15:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691015278; x=1691620078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=diAn+FKr0zNwv+Q0FyEJsNfox3GjhgMx9VJ8FYcl68k=;
        b=b+4GnyMp4cySJ8LvGAQJAvfv+x8FmX9W+RN3TYE/+lDoM8ZbQZtEVrJwzKqO693s3r
         kqHixRM1hPLcOFMGlH6id60RvuwrGl3C8xbOAU6i5Vmgg8LCDKytjhePJaN8emz2Nl6b
         F8gOt0YtqFkuhe5M+j4p9xL14jtzsj1weHHel8P7kZlrNODd92BzKM0JN8Vpk8kVl4wH
         emZMi4GD7tB3uMPWPZZZP0qj3iPpdPEHWdxH8mJquMsiyTL/eauEEa5y45HWv7/hh2Ti
         6kMV67ynWsH3uDI13UrZQasodF9f+u6cQs84ZQEUW5cAxzQGM0enukMIhS98nHdgBzee
         MOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691015278; x=1691620078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=diAn+FKr0zNwv+Q0FyEJsNfox3GjhgMx9VJ8FYcl68k=;
        b=PH9AdmPjsgiGHnfD/Lz30oggRvqqvzgckXWhzslOEVFLbZWQSqilB0NDVmv73mQgmx
         8o2DhWqQQh+rp/loWGpoQ+FIFq+hvTNcEb7Xwcpnuzq0BtB9dwlV/fkljLpbioXMI+bp
         rkWOuRYABCjU6bwsnyQvCmvKWv+bcYWqBBnR+Rxf8MjDSrxkBTZmY3cOgDhdk19TcY1i
         kbqxyurmiEvPymr0bhGDFttlRhoNOz8dMIohNa6At0oblu78rIJhJ9Gfgkp3CkOIiWda
         g7PYqa1rILt0A82FNgF4QcBBX1tD/DZw+NmcYO+JuOZcP+/EILNtR9f4GZuvXKGOhf3M
         gvFQ==
X-Gm-Message-State: ABy/qLbC59vnmG2HxI4YRCBSt5GmKjNYuH6ipY1TwZ1g4WTCLn9Nq+M7
        eK3CKwRxZ9TcCiR6eF4VmvXwGevOeXAz5A==
X-Google-Smtp-Source: APBJJlFJk2qUGcY8yfvQufY0guAPyuz7ZM1+yh+At2xeYTF+hZtFPVyavvUs2veqwUXF9r/gwWqMug==
X-Received: by 2002:a17:902:e5c5:b0:1b2:676d:1143 with SMTP id u5-20020a170902e5c500b001b2676d1143mr23438318plf.15.1691015278245;
        Wed, 02 Aug 2023 15:27:58 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b001bba7aab838sm12891445plg.162.2023.08.02.15.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 15:27:57 -0700 (PDT)
Date:   Wed, 2 Aug 2023 15:27:56 -0700
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
Subject: Re: [RFC PATCH 19/19] i386: Disable SMM mode for X86_SW_PROTECTED_VM
Message-ID: <20230802222756.GD1807130@ls.amr.corp.intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
 <20230731162201.271114-20-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230731162201.271114-20-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 12:22:01PM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/kvm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index a96640512dbc..62f237068a3a 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2654,6 +2654,13 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>  
>      if (x86ms->vm_type == KVM_X86_SW_PROTECTED_VM) {
>          memory_listener_register(&kvm_x86_sw_protected_vm_memory_listener, &address_space_memory);
> +
> +        if (x86ms->smm == ON_OFF_AUTO_AUTO) {
> +            x86ms->smm = ON_OFF_AUTO_OFF;
> +        } else if (x86ms->smm == ON_OFF_AUTO_ON) {
> +            error_report("X86_SW_PROTECTED_VM doesn't support SMM");
> +            return -EINVAL;
> +        }
>      }
>  

If we use confidential guest support, this check should go to there.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
