Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3E495A95EA
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 13:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiIALsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 07:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiIALsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 07:48:11 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B931616B1
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 04:48:08 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id t11-20020a05683014cb00b0063734a2a786so12173612otq.11
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 04:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gs2edPsujnl7CWNh7HlhsQUZIDEP93wl7jDr/MStIUw=;
        b=p4Jy2v4kA4G083K2jvV8paFTLopfZmvrFFiJVDXHA2CLiAiMQbvzaI+6xtM8fy/ioG
         q6v7h070g3jpHvc4zgWyn3PlpTVoAJgBTO2vVRqQ3EqVA8c08gieh25/eEkREYxnvqky
         TXkIBKV0x1PI2gdqV0XGCVMXGEeDH6C6muFw/yupvnl6MjMyjVVbFbPShk3Jp824gz71
         N7Rba0BKxgepKwaUOE+wXqFZ3V32Gshk2fFTQE/vAu0GyhiDDfyyUOytBQkvw7WZ40UR
         sh7VZ6I3eovXnP5i1aVdjY/A1mrIEVM/6RFgdxOsTWqH4+36C6UQ89MrljrPBnuhgQKp
         7dUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gs2edPsujnl7CWNh7HlhsQUZIDEP93wl7jDr/MStIUw=;
        b=3g+YGrUWPntgFydAJubt+FZxgmHuY3mdQXBQPX7u0g4jk609/eMOM4JcXti0bXvzqE
         ybWMA4Q0eRGs83GAD56ouBliEvPt6XIvM/QsFJV37zv+Bk5rLQ0m4VajbLo3Ij0RlVFM
         qGBwF74zRnbBQw+dtasTQIISeqxJWVdawp9TGTo4vALO51dK9QXiJHWvzeVwcOJe8zxm
         GTlfZFKdC7ausPqR96ryEvxku3aaRdWxcKoKXMYBwK/gG/8URNfYVXpQY5tSnAjAT3L+
         ACR/IJJAKl5p2docImz4k3C5I6OhVI5qPn7vfRzFuguNxlewmbJ/moeusIAH2GB/49Jr
         9yGQ==
X-Gm-Message-State: ACgBeo3HSc5BiKiLBjji9V2VXCpkhXzsFabODIYg/JNWrAv+zv570KAp
        Izd09BCdQiOjppOS1ds0SIae7IUoG4KycXOWoLdHWg==
X-Google-Smtp-Source: AA6agR6hJTVkzRjg9Zp0GaEGFRl4JLkQUdmzHa2xCc6eISLwJhjaURVIMa4Ntc6+O/EMeYoeT/5memUCEXVJ+lrAETU=
X-Received: by 2002:a05:6830:2a8e:b0:638:c41c:d5a1 with SMTP id
 s14-20020a0568302a8e00b00638c41cd5a1mr12801248otu.367.1662032887714; Thu, 01
 Sep 2022 04:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220831003506.4117148-1-seanjc@google.com> <20220831003506.4117148-4-seanjc@google.com>
 <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
 <84c2e836d6ba4eae9fa20329bcbc1d19f8134b0f.camel@redhat.com>
 <Yw+MYLyVXvxmbIRY@google.com> <59206c01da236c836c58ff96c5b4123d18a28b2b.camel@redhat.com>
 <Yw+yjo4TMDYnyAt+@google.com> <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
In-Reply-To: <c6e9a565d60fb602a9f4fc48f2ce635bf658f1ea.camel@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 1 Sep 2022 04:47:56 -0700
Message-ID: <CALMp9eQWHADOoQsocSWwwhyyxk-5oT=GzsGJSj1H=Lsfo=fuEQ@mail.gmail.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Sep 1, 2022 at 3:26 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:

> I just know that nothing is absolute, in some rare cases (like different APIC base per cpu),
> it is just not feasable to support the spec.

Why isn't this feasible? We supported it when I was at VMware.
