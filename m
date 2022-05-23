Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50285314D6
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbiEWOzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 10:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbiEWOzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 10:55:47 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D29A5B3D2
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 07:55:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id w200so13914526pfc.10
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 07:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JHZ+R8Y8nA8S+oeUM4/Av24R+MguK57xUegrXNCI6YY=;
        b=NxGxg7NCKOGD3NgKeUyIl4/81JURx+DfN+SqGO7Hih0+trYAFwZKfWK2SpAqZhPb0G
         UgGIr9LILMs5BpTWkUL2X0X3pjxnOpU6EQmBVRo6pH0w/vxJ64l+0iWKL3UooXkt89+p
         q7ZWfIuzujEkkOmytgb5aCWpH6+z+I87bXJ408ubHX0cYDG4qlhsSIJcNUnI9tANlcTF
         yfcSop4aGCPhqv6/No6omXgcCDwvrBecylukmAIETlu6LcIvg5bB52/XU/AM8R2AznAh
         M0nkyypgkDEbjlnWm7jYLaazKNWHqe7BZlSXkeEzpRqHj2etiosdsTayXhE4VJklfV3l
         2k5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JHZ+R8Y8nA8S+oeUM4/Av24R+MguK57xUegrXNCI6YY=;
        b=YZP+2sTSFEUsPPjdGTaIb5pbYmuFHa54fzfYLGrXuG8fP3cTuFVoX497Y9GCUS+yl9
         HHMYoHCaT6eq5sRHmUy0rNzGqU1FncZmWnzudjltKzh8qmCygJpd/88dKQkCCiSmwBP8
         VAu4ojxEhEaKAAaAch8dg6oQu8LMkQ+fxwRUtAfdtpuF7ut1WBqLbJmZoSMhV/VlqYuy
         DkvfZhyP7N2WRV14f6zVqnDSYihKFUNyXCVDt5dLxsSvzKINMQ9YEhVOin4iQgqtBFm9
         HfHaCuPkZGAnyt87+YHJj01fah3g0U/yWJNNTwicWNg1My9OvpVIF5jddCjZIz7T8g/z
         M/Jw==
X-Gm-Message-State: AOAM530bsbRhQ4xJcyURqa4AeDBN7Ys4Tjp8To2yN7LDcEatdfUSj7+E
        OjYebPNQ7OjqoMvSLvKWDSY=
X-Google-Smtp-Source: ABdhPJwTZjM/QwGDJuy8asN+V0scGGfehl7ckOZ+uLX7DFgwp+yyy3GSF1eE8scscN2qlgorO/+Dvw==
X-Received: by 2002:a05:6a00:1582:b0:518:7aa0:d6d8 with SMTP id u2-20020a056a00158200b005187aa0d6d8mr13817706pfk.27.1653317745584;
        Mon, 23 May 2022 07:55:45 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902d58c00b00160d358a888sm5235975plh.32.2022.05.23.07.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 07:55:45 -0700 (PDT)
Date:   Mon, 23 May 2022 07:55:43 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 03/36] target/i386: Implement mc->kvm_type() to
 get VM type
Message-ID: <20220523145543.GA3095181@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-4-xiaoyao.li@intel.com>
 <20220523083616.uqd5amzbkt627ari@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220523083616.uqd5amzbkt627ari@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 10:36:16AM +0200,
Gerd Hoffmann <kraxel@redhat.com> wrote:

>   Hi,
> 
> > +    if (!(kvm_check_extension(KVM_STATE(ms->accelerator), KVM_CAP_VM_TYPES) & BIT(kvm_type))) {
> > +        error_report("vm-type %s not supported by KVM", vm_type_name[kvm_type]);
> > +        exit(1);
> > +    }
> 
> Not sure why TDX needs a new vm type whereas sev doesn't.  But that's up
> for debate in the kernel tdx patches, not here.  Assuming the kernel
> interface actually merged will look like this the patch makes sense.

Because VM operations, e.g. KVM_CREATE_VCPU, require TDX specific one in KVM
side, we need to tell this VM is TD.
Also it's for consistency.  It's common pattern to specify vm type with
KVM_CREATE_VM when among other archs.  S390, PPC, MIPS, and ARM64.  Only SEV is
an exception.  It makes default VM into confidential VM after KVM_CREATE_VM.

Thanks,

> 
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> take care,
>   Gerd
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
