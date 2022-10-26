Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83A60EB17
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbiJZV76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiJZV7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:59:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022EEFD07
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:59:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id p3so14612780pld.10
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nR7s6MCaEHlCMlVxMummbX5Q2r2GgdQOaJT5qk5VOZM=;
        b=CqlBImQlgpjUHO0Rx0GwhsgUlHmg4p7+TZLDG7ab2pLnDCf4XoxoBytUinJVpAsGS7
         SGlwn+ELkfhVBLxn/UtORgFKweK0bFONWynDJ0yID6dsF5AxmnEJX7PLOCOdaRVeREci
         3ISpIUyQ7nL2WmBExE4rV2wPgdKHgCc4CLsfL8El4BmGAUEmeB25K7YvHgF+rhSId4L8
         RaijAmPi34k+krFIkTijdPWTsj6FGHdK85wDlx6y7DpR67/O/6jNkwbnM9EMQ/7zeui/
         Ig1gAMZh1qdU46fru5yksFizzP5cP9+Sw8zTySCh9irsWwLkiCX9pU0Krm0bKfefui0c
         dO0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nR7s6MCaEHlCMlVxMummbX5Q2r2GgdQOaJT5qk5VOZM=;
        b=IzR9QdB0OgTBAkyJhbi4ohIBMl5mn0QAYjMvJz1pQwLCMF6JjrxjpcZwsoVEq4yEnU
         dSn2VuDRxdL9qE6gSzCU2ymL8Mz1c3tY8YGcklAY+bPIRs0VmdL7G40HDxVk41tnSr6D
         gpT992hrPl7NAiJnDHou1RVyy5LTmBPv+SH+WMwwgFGuWYDN3KGb8CjCoJKfEIyK50F0
         RaMHgilu4ZMVI/JRaGrnWf7is6UKgHU7lb6ldfocH6Y12CtiQxa2Q7WNjPg2cZr65Rs3
         O4PT/5dv0o5RfA8RRtxclrXvbEgYsDJPXaIoGwqRoHTAl17ncUsRzAEpABuJ1uHYbOsl
         czpw==
X-Gm-Message-State: ACrzQf08gUbMXYffNT1qaH9P5h2OkmT0wCO2WGEjLfzzTxa21rnElKM3
        n+QykoAQIDrBTjTBgimQFD0w0w==
X-Google-Smtp-Source: AMsMyM5SQDNPjD7thnUy1UQuQk1M2SqagZHBjw0JQz6NiII0qQZ/kCP/JGKefog2ciVFBuEb60AoWA==
X-Received: by 2002:a17:902:ee8b:b0:186:a226:7207 with SMTP id a11-20020a170902ee8b00b00186a2267207mr18657114pld.49.1666821592090;
        Wed, 26 Oct 2022 14:59:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b00186c9d17af2sm2749143plb.17.2022.10.26.14.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:59:51 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:59:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 36/46] KVM: selftests: Drop helpers to read/write
 page table entries
Message-ID: <Y1mt1OSfJ8IGp5BU@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-37-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021153521.1216911-37-vkuznets@redhat.com>
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

On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Drop vm_{g,s}et_page_table_entry() and instead expose the "inner"
> helper (was _vm_get_page_table_entry()) that returns a _pointer_ to the
> PTE, i.e. let tests directly modify PTEs instead of bouncing through
> helpers that just make life difficult.
> 
> Opportunsitically use BIT_ULL() in emulator_error_test, and use the
> MAXPHYADDR define to set the "rogue" GPA bit instead of open coding the
> same value.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Missing your SOB, though maybe Paolo will merge my series first and make this a
moot point :-)
