Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2851A57C126
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 01:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiGTXwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 19:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiGTXwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 19:52:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394A37479C
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:52:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b10so34203pjq.5
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SU+9sdPjEoRKmN/+4YAaKjeCSLcuvjjP9XQXJ5JufIo=;
        b=HMaq22EC0enIkaf20mnApdcThcuBHrGnBSRVBzIGf3G6LTM4/PIMb3lzucOmNjbS46
         MlGJJ+X6aqwKkhhld4deW5I/pSa3hW/O32/vqjxYpA7csHggdRf3hmPWKzxqrNgIe2tI
         1Zq5qgCZPxUH0+UxiPFsxAViqD7Vb7ENgtSILPBccfChKbAhIYBlYPCJK3ZEfL76cUlq
         Nq/DFCVyf2ggh0tC8488Yg1Klc13+vZWsm2KIvmYPHcR7CfzFtwVtXHVxnGx3dUI8h3D
         90ybd8o+edm3L73S2U3/vr39T+elOUtDciCxJxKp5QHPJM2jy+uR516SoL1bKQhq6o7C
         x7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SU+9sdPjEoRKmN/+4YAaKjeCSLcuvjjP9XQXJ5JufIo=;
        b=vB0C3uGExfgXjLw9zFAUytHTv/yASawGIjbTWZ4BG08b9X0hCrzOwPn26l87HuWEep
         iLaRgF/zOi1NWSWBFP213z96M4NzqMLroUr9XqDjYyVFVXmEirMthlOKPCG7vYcjnGlU
         mN19KM1mIRimGietySi7q/FUon2Vn/sX34NjKzRQMeynxSBphdgKTAZWIaA35tC1FAoH
         q7ysCphOApUAtfDguaCla6G7fVgg4OYiK+0Zc+q5OEdavNw7vpPxFVtR1AHeSsY60v0i
         UF9Al/9fSy0eZlyE0GN1eYqe5oOnKN3zJmGCx8W7BubXidVGps/EWV+y1YY96nFARQRH
         z2iw==
X-Gm-Message-State: AJIora/3kVaJp3cu2UkpB+gKsUOq+hbLNjwkUxqpCb/L3Px9xES+9N3I
        e3Utsl4Uut1EERDaS19nQHjovg==
X-Google-Smtp-Source: AGRyM1sxyR/moI24p2/oEu61NcnYh2V2iHNMcppQJZZVK/mvzyXnsCZF99nKIElCIO9KtiGa03OKjQ==
X-Received: by 2002:a17:902:d4c6:b0:16d:2f7f:9a71 with SMTP id o6-20020a170902d4c600b0016d2f7f9a71mr1327233plg.36.1658361123518;
        Wed, 20 Jul 2022 16:52:03 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z10-20020a170903018a00b0016bfb09be10sm109064plg.305.2022.07.20.16.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:52:03 -0700 (PDT)
Date:   Wed, 20 Jul 2022 23:51:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 03/11] KVM: x86: emulator: remove assign_eip_near/far
Message-ID: <YtiVH83GZwMkSJP1@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-4-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-4-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> Now the assign_eip_far just updates the emulation mode in addition to
> updating the rip, it doesn't make sense to keep that function.
> 
> Move mode update to the callers and remove these functions.

I disagree, IMO there's a lot of value in differentiating between near and far.
Yeah, the assign_eip_near() wrapper is kinda silly, but have that instead of
a bare assign_eip() documents that e.g. jmp_rel() is a near jump and that it's
not missing an update.
