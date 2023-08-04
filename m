Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC69E77070C
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjHDR1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjHDR1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:27:47 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70DE212D
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:27:46 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe383c1a26so4080191e87.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 10:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691170065; x=1691774865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eGH739+21kK5T9cM0wXgX92MjcA/CsrPMd8UJ5iOhUA=;
        b=s/PWlVoIICkGKGfZ5NJYfPVRfwSjfJ+EEXIAKpkn109enBZgeYu3VzbfMEqWHLpXaz
         0zBw0nixNCvXuNH/7VUPPxZfdPHBiKnG54lRg3SgELKXkaEreTrr3o1gLC/mJPLsh+FH
         XK7RpbZfVt5yOByXNTDWMkaZxNHN2BQHTFjI9nywDR3FXaEwiq4IGY9isV0T0cMc7h//
         /KPOs/lLnaIZvj+mCXMx3juG1CDPPWPYEVH9LMjnEiwtj5V3TeMYzQJ7pX81Z6UBLXuc
         MquvnYcYOsDEwgAJInIHHtu83j9s/yqgwI1bTcjxtMG2d6cgrlx36P6s6CUz6shU32Hr
         zMRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170065; x=1691774865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGH739+21kK5T9cM0wXgX92MjcA/CsrPMd8UJ5iOhUA=;
        b=Eae6gHyYo3r+gRiI5jgNWtFrP2UNdx0mhfklfHoJjbQ2MWSG76V+qLpq8U0YBHPKZn
         RjD83ySjN/+imjC0TV9MXcApfemFOxDvVUN/aJYdmD487KmUFOIm5ZloDWaBa7b1a53T
         YG/bD7qF7FtqjhGNCsuIGGWtoE+6G4g3ksPDhXddEBQ2l+ZEqyy/2twjywAkcPzccPOd
         N5aZXs9idyIf7a7QtMp5IkpGsABjJ+0AUJrvGUqOC5iq/M6voX8eVwY5NPhejvz2q08Z
         0KTNCuG2eH6jbPjteqQ+w1I2eIJLdqKZCONc00k+yNAeBvKSDOGOTHWe+N9i0dw/LGNn
         TWtA==
X-Gm-Message-State: AOJu0Yxj38ER+fyNMAKaZawExSpecss0h1Fg9dx9WHHNoCeDZBcqZQfg
        1Go9c+UOFNyKY0++0DW1OhsktY3tABg7o78pvNof5A==
X-Google-Smtp-Source: AGHT+IHrt+YjfdNJEvDjOHWsAMq4eEiYzCLSTLcDO79rbvst91rSeEv27MZrEyXfE1RblzzaUJSOOgNUWJVnD+1YsBA=
X-Received: by 2002:a19:5e1e:0:b0:4f8:587e:cbe0 with SMTP id
 s30-20020a195e1e000000b004f8587ecbe0mr1651446lfb.52.1691170064899; Fri, 04
 Aug 2023 10:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230727073134.134102-1-akihiko.odaki@daynix.com> <20230727073134.134102-4-akihiko.odaki@daynix.com>
In-Reply-To: <20230727073134.134102-4-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 4 Aug 2023 18:27:34 +0100
Message-ID: <CAFEAcA8xUepaabxAq6sRKkCLecNkMVqZo3g+fOs0FuakRFa1Qg@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] mips: Report an error when KVM_VM_MIPS_VZ is unavailable
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> On MIPS, QEMU requires KVM_VM_MIPS_VZ type for KVM. Report an error in
> such a case as other architectures do when an error occurred during KVM
> type decision.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/mips/kvm.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/target/mips/kvm.c b/target/mips/kvm.c
> index e98aad01bd..e22e24ed97 100644
> --- a/target/mips/kvm.c
> +++ b/target/mips/kvm.c
> @@ -1278,6 +1278,7 @@ int kvm_arch_get_default_type(MachineState *machine)
>      }
>  #endif
>
> +    error_report("KVM_VM_MIPS_VZ type is not available");
>      return -1;
>  }

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
