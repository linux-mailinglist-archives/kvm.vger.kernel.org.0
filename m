Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18255351A2
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241792AbiEZPrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiEZPrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 11:47:19 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C6ECC169
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:47:18 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n8so1776544plh.1
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 08:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Fx8vCzhWUjdFRzXfN9cU8/D8Ts/Rmfp/Gt6ZmJXtRo=;
        b=CB+0U1qFaHdkAiyzSVkBLvbseHKjxoekSG8yydZzqm+OgjUSICeTSwkVGT6wn7qMiE
         aGfE/0Nv5dGxpwoZASDkaKyn0OOMrg3GDIqOaNz8pTW15+yrK82YABD8WzC5ir6xymVt
         i8UcyEEkHM60n0o3rlDBP6ZHoY+bB8dEKd6/DMkIJqhnxdsWLzQkFdznyGpmSaUhC1jF
         6p47J2x4aLwGEi+99xM4Js9KimuTf3OZAO6/yG26jJd0APD88xJsRl7w0I0D0VSGNLmf
         4labC065Q7AFEYd+zuSxqYtrC4rYToGhB/r+O2WtNP37K0GdgVuzJkV+u+1WCKJYsiag
         kCCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Fx8vCzhWUjdFRzXfN9cU8/D8Ts/Rmfp/Gt6ZmJXtRo=;
        b=t2iHBF1hxWeFU4QcvhXffNcFB+vEQ4eRGFmkK1f2f9VLmzAssxULAr3UZwK9rbFWVj
         recXsrS7FRMK0Sk9G3XcRaykUNkdwPbitpLSxBsC8X5B+kR2RS0uiqMt57rMRdgLWTLu
         uszbww+jAC/rOVERz84D7KwEp7djA3rz8pVHRV2RgRGgFWd4aIs8KQEzCDQ0SQWILr5v
         Ke78rh0gjRAgOHLXZ9dJtzddIcEQkWpw2e5oVG7C5YlVk3Otck+FFP/c9xCaqIZtGcpo
         eITKwHaQ6RHcdTABALu8F9kXdk3PPe7/tpoNJbH5BTbNVfxCp74u6xGEcKWjVtLnTFIc
         s9aw==
X-Gm-Message-State: AOAM533v6UCMT8qhOPAOerpK3CtgTcZv3PP4Ndu4q7grasiCKqrxfSBO
        8g1flbXSIh8OSIM1H2hAvLvmCw==
X-Google-Smtp-Source: ABdhPJzzSqMccL19vQokWCWc5+stt4j+6CDHwRflzasvHZksmMP/PorXV95hUMCn41xfVKhb6JAOVA==
X-Received: by 2002:a17:902:f78d:b0:14d:522e:deb3 with SMTP id q13-20020a170902f78d00b0014d522edeb3mr38316902pln.173.1653580038116;
        Thu, 26 May 2022 08:47:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090332ca00b0016156e0c3cbsm1803425plr.156.2022.05.26.08.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 08:47:17 -0700 (PDT)
Date:   Thu, 26 May 2022 15:47:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kbuild-all@lists.01.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Dinse <nanook@eskimo.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 3/4] KVM: x86: Omit VCPU_REGS_RIP from emulator's _regs
 array
Message-ID: <Yo+hAtKdaCNhUx3Z@google.com>
References: <20220525222604.2810054-4-seanjc@google.com>
 <202205261040.m1luL6IW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202205261040.m1luL6IW-lkp@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022, kernel test robot wrote:
> Hi Sean,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on 90bde5bea810d766e7046bf5884f2ccf76dd78e9]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Christopherson/KVM-x86-Emulator-_regs-fixes-and-cleanups/20220526-062734
> base:   90bde5bea810d766e7046bf5884f2ccf76dd78e9
> config: i386-debian-10.3-kselftests (https://download.01.org/0day-ci/archive/20220526/202205261040.m1luL6IW-lkp@intel.com/config)

Doh, forgot to build and test 32-bit KVM.  For this patch, I think it makes sense
to just hardcode the number of registers to 16.  But in a follow-up, that can be
reduced to 8 for 32-bit KVM, and then rsm_load_state_32() can use NR_EMULATOR_GPRS
too.
