Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8383F54D4FF
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbiFOXKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346086AbiFOXK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:10:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23ACF2BB18
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:10:29 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 123so12731163pgb.5
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9uWxlizkuk9BjIxHjLuuARzpkMD28eCY92hdkTd5oiU=;
        b=TY7zkqyGFFQxwL0GobJKShbn+l+rKWdZE5T7NAOmzRiTHs8bMxrlsEEdvoCx3RpN/6
         zfVIqHW+HoI2CwigYAZZRUXmLigk7gSCWmUFkhySCnqtgC5NnQvpQybUCxI2wHHR3s1U
         VPBzgfpQcyNYggBb/Br9F9rYcHGVvb04AIBDJtTFiuX8fEri7FwM/K8DlrbXcD6QdwYz
         IpFhLnOiwXWBxEwFJC5CB48pclc0GdyvX6B4KWX9BHR7+HpNgoYhwGnL0Iz53kA3zcTG
         tDj2zmBd1hVPHZWm/sgyrnx1S/d4KQvHyPy56Y5xlsNvVM7w1Uk4j943+ke4KbEZDdLm
         wSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9uWxlizkuk9BjIxHjLuuARzpkMD28eCY92hdkTd5oiU=;
        b=MtR1OobTyL1EJlHSwNdBHXMr12Xxk6WkhzjpgFMg+lkFX2XMi44cp0+xKEeQ+QxHUu
         uFLjE7BNIZ6DFdEUqvAOXg5pmHneN/EqLdcp8AT/kf4BkkbyXu7DBKmOHyL3qBqwwM9j
         eGZYixVfzx4X/wnjThMcSw6I17aJxXpa417Zrt4UGc4113ki/JcL1pWZPoePNt2SN/ov
         QGMCwQ8ZUeYHvkHwg6ue6IsenNW7tZkiWugQVNILrkXFFty2d9U1pbENjJTFhK8BLVpW
         LdoEnkvGiU2W/rVW8nLVMTIJ75mAKj7L1CJ1vmnGGQb6PE0CuKSiyHjq03fyKxy531y8
         /gTQ==
X-Gm-Message-State: AJIora8z/Avvys3s//8WCQFcRtddocKIHA4Pv4uXANPAwasu/+q0yBGC
        bo3vTslc9o/v5BS9/u/ZEbA7ag==
X-Google-Smtp-Source: AGRyM1v1PaJhwG8fpRf7RZQk913LdIgGOkK0h+sr89XUemKQXslH6j386O6FuiGcqEafzqHwhPnS/Q==
X-Received: by 2002:a62:a50c:0:b0:510:6b52:cd87 with SMTP id v12-20020a62a50c000000b005106b52cd87mr1811304pfm.30.1655334628397;
        Wed, 15 Jun 2022 16:10:28 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id ds12-20020a17090b08cc00b001e0c1044ceasm110394pjb.43.2022.06.15.16.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:10:27 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:10:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 09/11] x86: Move 32-bit bringup
 routines to start32.S
Message-ID: <Yqpm4LBbIXDhOkl/@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-10-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-10-varad.gautam@suse.com>
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

On Tue, Apr 26, 2022, Varad Gautam wrote:
> These can be shared across EFI and non-EFI builds.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
>  x86/cstart64.S | 60 +-----------------------------------------------
>  x86/start32.S  | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++

start32.S is not a good name.  Yes, it's 32-bit code, but used only for 64-bit
boot.  Looking back, start16.S isn't that great either because it's not _the_
16-bit start sequence (EFI has it's own).

If we go with trampolines.S, then the intent is relatively clear and we can shove
both 16=>32 and 32=>64 trampolines in there.
