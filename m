Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8725589E06
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 17:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240140AbiHDPA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 11:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240152AbiHDPAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 11:00:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6765713F3C
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 08:00:50 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 17so19640381pfy.0
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 08:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IaifTpn3u0w2qUkig48qynKFfInn0OoAePTEgfMQ/6g=;
        b=SM4HtroITzHOZUFHTx7wGP7tvdu9IAxGSxtCMAsBe810xu9aIob9MCZbOolfYzn2+e
         j79pj5EZWJJzVBm+DlQ9qL0YGGyMyf/egYOSXlw8RgRiClXjQpthTrp7Iqh3PIPjnPAn
         8+TJD8GinwO57p/omdUnuI5NwqNeM/WSRUkLJT77l1kK5Z4bFz3EuPcZDKrCtkP+ptrr
         0n/tLCQMaprvpWJ4hh+JWoWexfkLJE+kbl41zeroCm6WyfmY97oCLde4x/mAI5hEbBin
         fSB7HHpNIuAsqyLbyIMYwB3mCYCMkcOCi78C1cbpMRas/0ldqGJvXkvK2lzByC0iONsi
         oEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IaifTpn3u0w2qUkig48qynKFfInn0OoAePTEgfMQ/6g=;
        b=u+YCmBpw6Cxrz4qrCGbE3Ld0iLUgcnx69DtkAyzGZw/NX26kjvFXtAbewmw/i9z1ZX
         ETbPDhUpwLwROHwa34xrDpL5bXxSV9ktu4WPtAyiwg+PQKZbnLa7s28HqlGDYxxIal+f
         0XjfoxNb2R5MJh0WB2bEFMo7KqV/JDNeCVodqr003v2MAMLQyC/GyZHcJYJEXkTjF2AC
         2z65KjEaX0rhE/KcwgstW/aPhMkWqnN8aSXCdAwcOdr5D7Rs12+Nd01xe7XP4U/gCrp6
         VuPer+3ha+gaLl6Za4bBTTuVsTEN0/kPuVVo4lRvS1Y+ReYjqq3wVuEcicWdF3bcX8y/
         hLQQ==
X-Gm-Message-State: ACgBeo38wkr/CP+9W+uQ9oNDgdKwks39DaJ2SBIdiU6ntOZ9ZG7AcFJy
        qo/iot23B6VWxA7PO2qELnCnFg==
X-Google-Smtp-Source: AA6agR6vOOf5eInTDw94W1UE+cE40wpAwMxYjG3kliNFyyKOGQTat2W+Q3wfOpjiZ2CFqYuVxfrSRg==
X-Received: by 2002:aa7:919a:0:b0:52a:eeef:3e65 with SMTP id x26-20020aa7919a000000b0052aeeef3e65mr2112688pfa.15.1659625249718;
        Thu, 04 Aug 2022 08:00:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e6-20020a170902784600b0016357fd0fd1sm1119297pln.69.2022.08.04.08.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:00:49 -0700 (PDT)
Date:   Thu, 4 Aug 2022 15:00:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 7/7] KVM: VMX: Simplify capability check when handling
 PERF_CAPABILITIES write
Message-ID: <YuvfHZLGbU08S4ee@google.com>
References: <20220803192658.860033-1-seanjc@google.com>
 <20220803192658.860033-8-seanjc@google.com>
 <41e0b2a0-c53d-870f-d619-4008eb222d42@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41e0b2a0-c53d-870f-d619-4008eb222d42@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Like Xu wrote:
> On 4/8/2022 3:26 am, Sean Christopherson wrote:
> > Explicitly check for the absence of host support for LBRs or PEBS when
> > userspace attempts to enable said features by writing PERF_CAPABILITIES.
> > Comparing host support against the incoming value is unnecessary and
> > weird since the checks are buried inside an if-statement that verifies
> > userspace wants to enable the feature.
> 
> If you mean this part in the KVM:
> 
> 	case MSR_IA32_PERF_CAPABILITIES: {
> 		...
> 		if (data & ~msr_ent.data)
> 			return 1;
> 		...
> 
> then this patch brings a flaw, for example:
> 
> a user space can successfully set 0x1 on a host that reports a value of 0x5,
> which should not happen since the semantics of 0x1 and 0x5 for LBR_FMT
> may be completely different from the guest LBR driver's perspective.

/facepalm

I keep forgetting the caps need to match the host exactly.  Thanks!
