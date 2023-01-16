Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AD666BD00
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 12:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjAPLj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 06:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjAPLjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 06:39:54 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F451F5C4;
        Mon, 16 Jan 2023 03:39:51 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id g13so42330198lfv.7;
        Mon, 16 Jan 2023 03:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SYjq5rjyq/gQNXaOnM+SRcPQChR5QlcqEa1dQSiY8Us=;
        b=hDSkiBpCahfIMkpD8Mo2oQP1Cr6xA1R/Q/4qhlWOY3RfDtR+veuiHI+WtFZwDMMSyL
         l8qOrNdkYWYA1BMi5fsnxBditnyHeabXyG6Zuk1EXfI06l5dUtbHkVcSh5m2gmLzqmu1
         XPqzkZcDvM9uWP/eKMKCZgyKiQkm6TFZjeXsiKkZ6gBUFjgjBkvtkVRNZBApZVLYxLFO
         7XacVW7De7z/tdDiY82nnHFtv9HFlCtBxwJvjJO+U7Fauy4RbAP0hOY7JyTj9CjGRmcm
         YKEPtgPyWR0FUqx93lyd1TU/stlpQCNxwhYugUvAZ8Cqp9cFXPyC9qpaKu99KOWl9fDF
         N2GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SYjq5rjyq/gQNXaOnM+SRcPQChR5QlcqEa1dQSiY8Us=;
        b=MVJ7aoIhkXbsCR33acr1xhoJU5RN9GJFha9HN21prXqljqD/0zyfKijxdhM7T414W2
         IdYDE+TlLmifFO7zasy37s99ytBdQQ7J+QAoGFTDlUtPq59Ij4lOqY7XQi6/riRKssN7
         rBURVfaVRsSum5qy3ewNwteHfb7zBkB4mVEZA7rhrZemQdUkrAlNhuYhDA/oDF0oaNCp
         NREzjicrY3mNbsVwyBj7No89pHacCqkGbDgaLCsgTojxmjKWUPIL3xebGFnmbEWWLvdJ
         g+GhzajP8GKqYUDbfGg1xKCwgbZWUxgSsoYH07CYDJf2TqBx7a6VBF+IVd98NSK3epCF
         mQFg==
X-Gm-Message-State: AFqh2kr0Kq7wf/Ttx3X5XsJjfmO+uD7/uir57jwqpnW8XzjWvKRGy1b0
        bluzB/V2P95gWoDkNqyKP2c=
X-Google-Smtp-Source: AMrXdXuKczK/KmpP4p91NxGEK6yF/iCpCPozNoxjx4vxgN+Iy/0cPBVcfDRSHnkjhs+4j6LvV59Uzw==
X-Received: by 2002:ac2:43b2:0:b0:4cb:22ab:cdf8 with SMTP id t18-20020ac243b2000000b004cb22abcdf8mr3801504lfl.5.1673869190042;
        Mon, 16 Jan 2023 03:39:50 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id b6-20020ac25626000000b0048afb8b8e53sm4990334lff.80.2023.01.16.03.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:39:49 -0800 (PST)
Date:   Mon, 16 Jan 2023 13:39:48 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation
 support
Message-ID: <20230116133948.0000474b@gmail.com>
In-Reply-To: <4bca96ee-3665-5503-bb88-baae98e700e2@amd.com>
References: <20230112084139.12615-1-nikunj@amd.com>
        <20230113135326.00006f06@gmail.com>
        <4bca96ee-3665-5503-bb88-baae98e700e2@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 13:53:56 +0530
"Nikunj A. Dadhania" <nikunj@amd.com> wrote:

> On 13/01/23 17:23, Zhi Wang wrote:
> > On Thu, 12 Jan 2023 14:11:39 +0530
> > Nikunj A Dadhania <nikunj@amd.com> wrote:
> > 
> 
> >> diff --git a/Documentation/x86/amd-memory-encryption.rst
> >> b/Documentation/x86/amd-memory-encryption.rst index
> >> a1940ebe7be5..b3adc39d7735 100644 ---
> >> a/Documentation/x86/amd-memory-encryption.rst +++
> >> b/Documentation/x86/amd-memory-encryption.rst @@ -95,3 +95,39 @@ by
> >> supplying mem_encrypt=on on the kernel command line.  However, if BIOS
> >> does not enable SME, then Linux will not be able to activate memory
> >> encryption, even if configured to do so by default or the mem_encrypt=on
> >> command line parameter is specified. +
> >> +Secure Nested Paging (SNP)
> >> +==========================
> >> +
> >> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be
> >> enabled +by the hypervisor for security enhancements. Some of these
> >> features need +guest side implementation to function correctly. The
> >> below table lists the +expected guest behavior with various possible
> >> scenarios of guest/hypervisor +SNP feature support.
> >> +
> 
> > "guest needs implementation" seems a little bit confusing. I suppose it 
> > means the feature is mandatory for the guest. 
> 
> That is not correct. None of these features are mandatory for the guest.
> The hypervisor can enable this feature without the knowledge of guest 
> kernel support. So there should be a mechanism in the guest to detect this
> and fail the boot if needed.
> 
> > If so, on the second row 
> > guest can boot without it. Some explanation? 
> 
> In the first and second row, HV has not enabled the feature, so the 
> guest should boot fine irrespective of "Guest needs implementation".
> 

Feel free to educate me if I understand correctly or not:

There are two kinds of features in SEV_FEATURES:

1. Features that HV can freely enable/disable and they won't distrub the guest.

HV   | Guest needs impl | Guest has impl    | Result
Y/N          N            X (not necessary)    Boot

2. Features that a guest has to be aware of and handle when HV enables them.

HV   | Guest needs impl | Guest has impl | Result
N            Y            X (Dont care)     Boot
Y            Y                  N           Fail
Y            Y                  Y           Boot

> >> +|      No         |      No       |      No       |     Boot         |
> 
> >> +|      No         |      Yes      |      No       |     Boot         |
> 
> 
> >> ++-----------------+---------------+---------------+------------------+
> >> +| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
> >> +| by the HV       | implementation| implementation| behaviour        |
> >> ++=================+===============+===============+==================+>> +|      No         |      No       |      No       |     Boot         |
> >> +|                 |               |               |                  |
> >> ++-----------------+---------------+---------------+------------------+
> >> +|      No         |      Yes      |      No       |     Boot         |
> >> +|                 |               |               |                  |
> >> ++-----------------+---------------+---------------+------------------+
> >> +|      No         |      Yes      |      Yes      |     Boot         |
> >> +|                 |               |               |                  |
> >> ++-----------------+---------------+---------------+------------------+
> >> +|      Yes        |      No       |      No       | Boot with        |
> >> +|                 |               |               | feature enabled  |
> >> ++-----------------+---------------+---------------+------------------+
> >> +|      Yes        |      Yes      |      No       | Graceful boot    |
> >> +|                 |               |               | failure          |
> >> ++-----------------+---------------+---------------+------------------+
> >> +|      Yes        |      Yes      |      Yes      | Boot with        |
> >> +|                 |               |               | feature enabled  |
> >> ++-----------------+---------------+---------------+------------------+
> >> +
> >> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> >> +
> >> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> > 
> > Probably update the link here as well.
> 
> Sure.
> 
> >> diff --git a/arch/x86/include/uapi/asm/svm.h
> >> b/arch/x86/include/uapi/asm/svm.h index f69c168391aa..a04fe07eb9a8 100644
> >> --- a/arch/x86/include/uapi/asm/svm.h
> >> +++ b/arch/x86/include/uapi/asm/svm.h
> >> @@ -116,6 +116,12 @@
> >>  #define SVM_VMGEXIT_AP_CREATE			1
> >>  #define SVM_VMGEXIT_AP_DESTROY			2
> >>  #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
> >> +#define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
> >> +#define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
> >> +	/* SW_EXITINFO1[3:0] */					\
> >> +	(((((u64)reason_set) &  0xf)) |				\
> >                                ^
> > One extra space before 0xf should be removed.
> 
> Sure.
> 
> Thanks for the review.
> 
> Nikunj
> 

