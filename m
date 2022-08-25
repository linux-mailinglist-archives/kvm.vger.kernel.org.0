Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2F35A1575
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiHYPTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiHYPTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:19:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14CCB8F09
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:19:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso5287870pjl.1
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=0cKABFUN+wnQcetiBFS+ZWvGWfmSSFXH2Vy7bIP70To=;
        b=n4VTCk+hi4atd4sl9xX8mkpWnVRvlZsWhrI7z1ws5nNsnjD5c/UZmgA62xHwFEBC77
         QH/tB5H1R5AOYoiEK7tFDt17r2gpvL1Y/ulfhtQGJ1GkwGBFB+fQX5Tm+zrr+/EhlcLE
         C23Yyjog5FobgJ7Dj8N9uHobenLy9t7bP7TjQbOTJtu8HGF9d8LrPm15wls7xzCuZ/79
         IOTP508EjxCfVszWalUtem+LafKgjjJ9vzKpITgkTbH8VuXCou/ccTkTotHY19aKr+F5
         r8vKvV04QJmuZghSxWCBpuTIYro+juj2XzlNZ5r7Ehv9dyGBLf9EFNkTH7TM9nR08iJJ
         iiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0cKABFUN+wnQcetiBFS+ZWvGWfmSSFXH2Vy7bIP70To=;
        b=XNlk0wC80KmZoDiC6mr9DNTskjPNFkQe81v9W5W6zkFfWsovhvwQpdPjD6IO7RmNUE
         jN6dbo+tlezo+6qH5xjK/0QXHKBAwLr2e7lQdKPHRwq+ckq4/j+QRp3nBDvpZjNYY/k0
         s+LOTLOA+tF/9EpsMc5eLeCnHSGjIVTrJnxn5a24/ttFplDhk+OOHeQO8qPjNaP5UvfR
         qjEBE94w9pHQ+ZqzBkFU49IqSuU5r0FT+YKhIxpsp1R6fs2ojOm4BAa+YgDfsS69LJde
         O71EfWg3/mDsdqjTGnylM4/8DPHSZfIydv9dpMnfLJ7PODNYVD0I5G9sQXnnORDsahVN
         jwHw==
X-Gm-Message-State: ACgBeo1QM+OjHJ+igGvzYFY2lxIbklqBjQ748BkZ/TM7hDtEBdTpSXjk
        BVoo2+K1MTOti4L+wdDpw5gnLA==
X-Google-Smtp-Source: AA6agR4ECS4oI+ONI4GnXK4C2r5ILO0emxVW6B//31Dq/MYub15KoTEv287azdYa76yYflAVM1Wq2g==
X-Received: by 2002:a17:902:db11:b0:16f:342:a439 with SMTP id m17-20020a170902db1100b0016f0342a439mr4140450plx.13.1661440761992;
        Thu, 25 Aug 2022 08:19:21 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o17-20020a17090a9f9100b001f51903e03fsm3636235pjp.32.2022.08.25.08.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:19:21 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:19:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Kai Huang <kai.huang@intel.com>, dave.hansen@linux.intel.com,
        linux-sgx@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        haitao.huang@linux.intel.com
Subject: Re: [PATCH v2] x86/sgx: Allow exposing EDECCSSA user leaf function
 to KVM guest
Message-ID: <YweS9QRqaOgH7pNW@google.com>
References: <20220818023829.1250080-1-kai.huang@intel.com>
 <YwbrywL9S+XlPzaX@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwbrywL9S+XlPzaX@kernel.org>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Jarkko Sakkinen wrote:
> Nit: shouldn't be this be x86/kvm?

Heh, no, because x86/kvm is the scope for Linux running as a KVM guest, i.e. for
changes to arch/x86/kernel/kvm.c.

But yeah, "KVM: x86:" or maybe even "KVM: VMX:" would be preferable given that all
of the meaningful changes are KVM specific.

> On Thu, Aug 18, 2022 at 02:38:29PM +1200, Kai Huang wrote:
> > The new Asynchronous Exit (AEX) notification mechanism (AEX-notify)
> > allows one enclave to receive a notification in the ERESUME after the
> > enclave exit due to an AEX.  EDECCSSA is a new SGX user leaf function
> > (ENCLU[EDECCSSA]) to facilitate the AEX notification handling.  The new
> > EDECCSSA is enumerated via CPUID(EAX=0x12,ECX=0x0):EAX[11].
> > 
> > Besides Allowing reporting the new AEX-notify attribute to KVM guests,
> > also allow reporting the new EDECCSSA user leaf function to KVM guests
> > so the guest can fully utilize the AEX-notify mechanism.
> > 
> > Similar to existing X86_FEATURE_SGX1 and X86_FEATURE_SGX2, introduce a
> > new scattered X86_FEATURE_SGX_EDECCSSA bit for the new EDECCSSA, and
> > report it in KVM's supported CPUIDs so the userspace hypervisor (i.e.
> > Qemu) can enable it for the guest.

Silly nit, but I'd prefer to leave off the "so the userspace hypervisor ... can
enable it for the guest".  Userspace doesn't actually need to wait for KVM enabling.
As noted below, KVM doesn't need to do anything extra, and KVM _can't_ prevent the
guest from using EDECCSSA.

> > Note there's no additional enabling work required to allow guest to use
> > the new EDECCSSA.  KVM is not able to trap ENCLU anyway.

And maybe call out that the KVM "enabling" is not strictly necessary?  And note
that there's a virtualization hole?  E.g.

  Note, no additional KVM enabling is required to allow the guest to use
  EDECCSSA, it's impossible to trap ENCLU (without completely preventing the
  guest from using SGX).  Advertise EDECCSSA as supported purely so that
  userspace doesn't need to special case EDECCSSA, i.e. doesn't need to
  manually check host CPUID.

  The inability to trap ENCLU also means that KVM can't prevent the guest
  from using EDECCSSA, but that virtualization hole is benign as far as KVM
  is concerned.  EDECCSSA is simply a fancy way to modify internal enclave
  state.

> > More background about how do AEX-notify and EDECCSSA work:
> > 
> > SGX maintains a Current State Save Area Frame (CSSA) for each enclave
> > thread.  When AEX happens, the enclave thread context is saved to the
> > CSSA and the CSSA is increased by 1.  For a normal ERESUME which doesn't
> > deliver AEX notification, it restores the saved thread context from the
> > previously saved SSA and decreases the CSSA.  If AEX-notify is enabled
> > for one enclave, the ERESUME acts differently.  Instead of restoring the
> > saved thread context and decreasing the CSSA, it acts like EENTER which
> > doesn't decrease the CSSA but establishes a clean slate thread context
> > using the CSSA for the enclave to handle the notification.  After some
> > handling, the enclave must discard the "new-established" SSA and switch
> > back to the previously saved SSA (upon AEX).  Otherwise, the enclave
> > will run out of SSA space upon further AEXs and eventually fail to run.
> > 
> > To solve this problem, the new EDECCSSA essentially decreases the CSSA.
> > It can be used by the enclave notification handler to switch back to the
> > previous saved SSA when needed, i.e. after it handles the notification.
> > 
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > ---
> > 
> > Hi Dave,
> > 
> > This patch, along with your patch to expose AEX-notify attribute bit to
> > guest, have been tested that both AEX-notify and EDECCSSA work in the VM.
> > Feel free to merge this patch.

Dave, any objection to taking this through the KVM tree?
