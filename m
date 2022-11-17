Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98862E5CA
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbiKQU2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiKQU2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:28:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DAA697E3
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:28:04 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 140so2878458pfz.6
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjPvhUtx2vpq21G6yppeUkSS2gj9D+uNetGzarYUrGk=;
        b=HOUcxMgkGsrLHQg9cgfl2AGgr+gBpBVzZsKBIMmL0NWLOpU16yxxBrKvjr3dAAHVk3
         ShvcqhvIHigUkfSoUbhib8KYcJ3kBJzNDcvN6Fr+yvjVIn0KXdmuPM/7oZkHMalQvK4i
         JX9OBUGpDIho/I3FKJBR4Tgw1KB+p+SbrKiIHYCLXCuZk9unlCObWDSpkYt75kRhWWEZ
         1Z3hAvoiMNrQwLfeSQnZvA2Kwdvfoh2BMy75LExHyMX2oRDkkBkvRAvCvqoeF0gSgHuw
         HJp2JUcbJT5BUTJuBIBv7+9e5BuvJxF6s0l2HVTIF/a5GXv4Yti4WFjPIqVRa3MhrJd3
         C/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjPvhUtx2vpq21G6yppeUkSS2gj9D+uNetGzarYUrGk=;
        b=RRJTd3ectc2SOcaBnS7mZ0SJ4MygUCwzgI+z/uSatDQOp/WrDrkk6SHcwyU51ZG6v5
         XUYMZ3YNvTt9jaebecHZjKG4LZPgqTdiCvdll1a4vjLc1qK/ayDbMQWFuNvFU6v6vik/
         pcMBlcMitl9qboz8Hbpujz1pFJnLST+WsjbHp/OWyeMPymwU1SUKLpL8uBrhl7Dd4o/I
         a4GAEZOApHU3n44HjG9ua4r152wbi6OKgQKvzkmUWY21XwwhYZlGZsLlOkaSExn3nztd
         OYCt2uoCjPGiwOrj/x99PuIsRywu3zcJznSU6dJl8rhwt8u8zgA63BIAyOWvDS+bSjYE
         oDGQ==
X-Gm-Message-State: ANoB5pkMGHY3LF+fkPJ2j7oFFOejl2KYauBwDYiSr9gxIXdPolgc/YXC
        iAGjPdRbs3doUoeY+yK6+i12ZA==
X-Google-Smtp-Source: AA0mqf6QEuP6PFMMMMFXf39ThqjNyEzo0xFa9vySIpJbOAvYdrHdkQVXA6QS+NHZXqqTMJ7fYppzNw==
X-Received: by 2002:a65:5541:0:b0:476:759b:7952 with SMTP id t1-20020a655541000000b00476759b7952mr3658694pgr.316.1668716883589;
        Thu, 17 Nov 2022 12:28:03 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b00186e34524e3sm1797697pln.136.2022.11.17.12.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:28:03 -0800 (PST)
Date:   Thu, 17 Nov 2022 20:27:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 06/13] KVM: SVM: Add VNMI bit definition
Message-ID: <Y3aZTyqc9ZafQSfG@google.com>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-7-mlevitsk@redhat.com>
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

On Thu, Nov 17, 2022, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 03acbe8ff34edb..08a7b2a0a29f3a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -230,6 +230,8 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  bool intercept_smi = true;
>  module_param(intercept_smi, bool, 0444);
>  
> +bool vnmi = true;

This can be __ro_after_init, e.g. see
https://lore.kernel.org/all/20221110013003.1421895-4-seanjc@google.com

> +module_param(vnmi, bool, 0444);

The exposure of "vnmi" to userspace belongs in the last patch.  E.g. this patch
should only stub in vnmi:

  bool __ro_after_init vnmi;

and then the last patch that actually enables it can default it to true and expose
the param to users.

It obviously doesn't matter in the end, but it technically makes this series
broken, e.g. nested_sync_int_ctl_from_vmcb02() pivots on "vnmi" without the extra
V_NMI_ENABLE check, and advertising the vnmi is enabled when it actually isn't is
wrong/misleading.
