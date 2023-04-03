Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBFF6D4DC3
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjDCQaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbjDCQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:29:53 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60582122
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 09:29:51 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y15so38827258lfa.7
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1680539390; x=1683131390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFwQPWx8Ux6bh8rA+x2qSR6v2JLfRrPIjTrTWUE6sUM=;
        b=JsE9dOfwevJTrgylHsmRIAQrW/XpqPASmMDZIkt7x5yxpY+WtRKsPyRz7b40Q/Xco8
         0ImnmF+a9fOWPml6ZJbl5pS9ZEnXFYkMRNKN7p0LG+7i+36BSC+qfmCAMVconMtQ9IQr
         24ZZbziPyidujhwVKbBwgkv3XhU8WbJhH8k1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680539390; x=1683131390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xFwQPWx8Ux6bh8rA+x2qSR6v2JLfRrPIjTrTWUE6sUM=;
        b=s2FOLQ902q0923kIHHzaFYznayYSs9Hx8wLbjBs246zLZEKk90CJDxSOeKuO5eoC2G
         DNP/UXSqxt9EV549E7PsAAjflyhh5rN38EimzYTA2zjADCQp8hIqJ/czUJbPQKa7zVxU
         2uZksbHTgA/rJj+fTXfETRkFtKa4s+gbqoTYKV1hUvkHRBX2MyXrESQj5T9hIEehAGAB
         YlfzYU7QsKm1Gk3LqgHQHNGYsHtfXHlPfirg1CLuxs4UEooLNCREvxg41PLiSBGkkWOf
         uvHAynO1WvIu1eZFVerl9haJ5Zrbi5TOjFDf3RnL0ILCVXpjLc5MLeVD0T6bKfD4Ilrw
         KumA==
X-Gm-Message-State: AAQBX9d4r843fMLAycCuxOI7cT/1asg+L8/oTsG2ZV1kA6UH/OfIsnwc
        Dd39VRdECeRIuZrMAzUuDkTuTtQrPEm/xHESEyBuZA==
X-Google-Smtp-Source: AKy350Znd3frXzB5zMeZr362/rNL1qKxEreWI3gRntXFsBjVf/gdyYHm0pHON2GFlMmxs6OPr9ojWg==
X-Received: by 2002:ac2:4438:0:b0:4eb:3149:cbe1 with SMTP id w24-20020ac24438000000b004eb3149cbe1mr2346317lfl.10.1680539389874;
        Mon, 03 Apr 2023 09:29:49 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id c8-20020a05651221a800b004e80b23565bsm1845872lft.198.2023.04.03.09.29.49
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 09:29:49 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id j11so38799772lfg.13
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 09:29:49 -0700 (PDT)
X-Received: by 2002:a17:907:3e16:b0:932:da0d:9375 with SMTP id
 hp22-20020a1709073e1600b00932da0d9375mr11670367ejc.4.1680538904942; Mon, 03
 Apr 2023 09:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140605.540512-1-jiangshanlai@gmail.com> <20230403140605.540512-3-jiangshanlai@gmail.com>
In-Reply-To: <20230403140605.540512-3-jiangshanlai@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Apr 2023 09:21:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=whY8tkKJoFjzP1-kR5rqCmgTEiX2i+GJgjdJcn+q+3HTQ@mail.gmail.com>
Message-ID: <CAHk-=whY8tkKJoFjzP1-kR5rqCmgTEiX2i+GJgjdJcn+q+3HTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/7] x86/entry: Add IST main stack
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 3, 2023 at 7:05=E2=80=AFAM Lai Jiangshan <jiangshanlai@gmail.co=
m> wrote:
>
> diff --git a/Documentation/x86/kernel-stacks.rst b/Documentation/x86/kern=
el-stacks.rst
> index 6b0bcf027ff1..be89acf302da 100644
> --- a/Documentation/x86/kernel-stacks.rst
> +++ b/Documentation/x86/kernel-stacks.rst
> @@ -105,6 +105,8 @@ The currently assigned IST stacks are:
>    middle of switching stacks.  Using IST for MCE events avoids making
>    assumptions about the previous state of the kernel stack.
>
> +* ESTACK_IST. bla bla
> +
>  For more details see the Intel IA32 or AMD AMD64 architecture manuals.

Maybe the cover letter description could be used here, rather than the
"bla bla" placeholder?

              Linus
