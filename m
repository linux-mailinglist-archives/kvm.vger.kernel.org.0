Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE3589E34
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 17:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiHDPH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 11:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiHDPHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 11:07:51 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F031F1CFE0
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 08:07:48 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ha11so15153pjb.2
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 08:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=neB+q0Kh/QsWUNLfDZS1PKd7092ZvbprenIhcvXZr4s=;
        b=DEtCTuZuYtlNCKENrIWS/qrP6UQrptimFrP7vr/8hGEfVxGNVAqaGxVs1Mqahh3fJf
         Bk8KfmBIyI2ctXtvBZ8yDNsVrvvumQU+Y395lVQju+2V1hs0PKE68RlkcSPVWHTOTL/2
         KBO5J9nzOj09abxmKMh61PutppsEYFH+qAyutY6ntxdijTFkg3Z9Vl3W8ItxXlYwoc62
         qYRqdStaJn4e9fw7YPAtUq0kDQ9F+l1royE+v4mZgpIA9xi6VuvhXezVDhLWxacvVRVN
         XTiuz3CEDMVaaP23QuuUGKS8aObobALB2lOYSdnHgRuQopka5bRyrcoIrQ+HGDYOdtzO
         yysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=neB+q0Kh/QsWUNLfDZS1PKd7092ZvbprenIhcvXZr4s=;
        b=2PXjyyZfR1y0glf/AK/xDkTj0evoOofX+KIw5AsA4rnzzegq8cYWgjtu8il/WPRoNp
         ajaTEFqJixGDLyunGRz3m93omVIyZqX5ttryeSLIwjXQ858Gk8Wkg3l8/2MKJfSFP+kk
         z9bCB/YYh/vsHAjDQJgRCvVfCkMsWo2Phb1aMp/0+rpmZBwt0nTaIboQcpOGZ5s4VgzL
         rcVKYIQ5CErZxmpnICm0rpeFrIjGsMBHaOA9RaNTq/8cOB5u90uAPQ++NXetHV/nmCpO
         p1DIKkVJ0olgdeC6/IrsOzevXJ5wMpslNDcoVIvYKa0/jfmNY4ObarYvRUlEYfQtIsws
         vNYg==
X-Gm-Message-State: ACgBeo0xj52mk6BpN523dQ5LlJ9s3VcsOFgmP1yU3XNq98+n7XV3K8fl
        ABDedKl/unxpIa8fUGNvcvtEzg==
X-Google-Smtp-Source: AA6agR70GYTX3ilAS5d1f2gctcAwETJuwcR3TW4OSclNNeLqgXdvT9Jce7p5cZBSSsf9/7R9avPxpQ==
X-Received: by 2002:a17:902:788f:b0:16e:f6b8:16c6 with SMTP id q15-20020a170902788f00b0016ef6b816c6mr2331324pll.3.1659625668331;
        Thu, 04 Aug 2022 08:07:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x16-20020a170902ec9000b0016c9e5f291bsm1103441plg.111.2022.08.04.08.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 08:07:47 -0700 (PDT)
Date:   Thu, 4 Aug 2022 15:07:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v2 2/7] perf/x86/core: Remove unnecessary stubs provided
 for KVM-only helpers
Message-ID: <Yuvgv4QC3oKPlKs2@google.com>
References: <20220803192658.860033-1-seanjc@google.com>
 <20220803192658.860033-3-seanjc@google.com>
 <fcb0e878-29ff-e408-ccf3-3b594160c0df@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcb0e878-29ff-e408-ccf3-3b594160c0df@gmail.com>
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
> > -#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
> > - extern void amd_pmu_enable_virt(void);
> > - extern void amd_pmu_disable_virt(void);
> > -
> > -#if defined(CONFIG_PERF_EVENTS_AMD_BRS)
> > +#ifdef CONFIG_PERF_EVENTS_AMD_BRS
> >   #define PERF_NEEDS_LOPWR_CB 1
> > @@ -566,12 +538,13 @@ static inline void perf_lopwr_cb(bool lopwr_in)
> >   	static_call_mod(perf_lopwr_cb)(lopwr_in);
> >   }
> > -#endif /* PERF_NEEDS_LOPWR_CB */
> 
> Oops, now the definition of PERF_NEEDS_LOPWR_CB will not be unset.
> This is not mentioned in the commit message and may cause trouble.

PERF_NEEDS_LOPWR_CB isn't being "unset" in the existing code, the comment is simply
wrong.  The #endif pairs with CONFIG_PERF_EVENTS_AMD_BRS.

  #if defined(CONFIG_PERF_EVENTS_AMD_BRS)

  #define PERF_NEEDS_LOPWR_CB 1

  /*
   * architectural low power callback impacts
   * drivers/acpi/processor_idle.c
   * drivers/acpi/acpi_pad.c
   */
  extern void perf_amd_brs_lopwr_cb(bool lopwr_in);

  DECLARE_STATIC_CALL(perf_lopwr_cb, perf_amd_brs_lopwr_cb);

  static inline void perf_lopwr_cb(bool lopwr_in)
  {
  	static_call_mod(perf_lopwr_cb)(lopwr_in);
  }

  #endif /* PERF_NEEDS_LOPWR_CB */ <=== should be /* CONFIG_PERF_EVENTS_AMD_BRS */
